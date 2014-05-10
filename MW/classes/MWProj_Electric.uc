class MWProj_Electric extends MWProj_Spell;

/**Charge mulitplier*/
var float ChargeMulti;

var vector ColorLevel;
var vector ExplosionColor;

simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;
	local Vector HitLocation, HitNormal2;
	local TraceHitInfo HitInf, HitInfo;
	local Actor HitActor;
	local name ImpactSoundName;
	
	if(bHasShutdown)
	{
		return;
	}

	// do a trace first to see if we hit an actor in the process
	if( AOCWeaponAttachment(AOCPawn(Instigator).CurrentWeaponAttachment).bDrawDebug)
		AOCWeaponAttachment(AOCPawn(Instigator).CurrentWeaponAttachment).DrawServerDebugLineOnClient( PrevLocation,Location, PlayerController(Instigator.Controller), 255,0,0);
		
	if ((Role == ROLE_Authority /*&& OwnerPawn.IsLocallyControlled()*/) || OwnerPawn.bIsBot)
	{
		foreach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, PrevLocation, Location,, HitInf, TRACEFLAG_Bullet | TRACEFLAG_PhysicsVolumes)
		{
			if( HitActor != none && AOCPawn(HitActor) != none && HitInfo.HitComponent == AOCPawn(HitActor).ParryComponent )
			{
				continue;
			}
		
			if( HitActor != none && WorldInfo(HitActor) == none && AOCPawn(HitActor) != OwnerPawn && HitActors.Find(HitActor) == INDEX_NONE )
			{
				//LogAlwaysInternal("HIT ACTOR:"@HitActor@AOCPawn(HitActor).Health);
				if (AOCPawn(HitActor) != none && !AOCPawn(HitActor).bPlayedDeath)
				{
					ImpactedActor = HitActor;
					ImpactedTrace = HitInf;
					AOCProcessTouch(HitActor, HitLocation, HitNormal, HitInf);
					HitActors.AddItem(HitActor);
					
					AttachToComponent( HitActor, HitInf.HitComponent, HitLocation, HitNormal );
					
					Shutdown();
					ImpactedActor = None;

					bShouldAttach = true;
				
					return;
				}
				else if (AOCPawn(HitActor) != none && AOCPawn(HitActor).bPlayedDeath && Role == ROLE_Authority)
				{
					AttackDeadPawn(AOCPawn(HitActor), HitInfo, HitLocation, HitNormal);
					ImpactSoundName = PlayImpactSound(HitActor, HitInf, HitLocation);
					Shutdown();
					HitActors.AddItem(HitActor);
					return;
				}
				else if (IAOCActor(HitActor) != none)
				{
					ImpactSoundName = PlayImpactSound(HitActor, HitInf, HitLocation);
				
					// Hit a custom actor
					AttachToWorld(HitLocation, HitActor);
					Shutdown();
					HitActors.AddItem(HitActor);

					return;
				}
			}
		}
	}
	
	Super(Actor).HitWall(HitNormal, Wall, WallComp);

	if ((Role == ROLE_Authority /*&& OwnerPawn.IsLocallyControlled()*/) || OwnerPawn.bIsBot)
	{
		//LogAlwaysInternal("ATTACH TO WORLD"@Wall);

		AttachToWorld(Location, Wall, ImpactSoundName);
		bCanShutDown = true;
		ShutDown();

		if ( Wall.bWorldGeometry )
		{
			HitStaticMesh = StaticMeshComponent(WallComp);
			if ( (HitStaticMesh != None) && HitStaticMesh.CanBecomeDynamic() )
			{
				NewKActor = class'KActorFromStatic'.Static.MakeDynamic(HitStaticMesh);
				if ( NewKActor != None )
				{
					Wall = NewKActor;
				}
			}
		}
		ImpactedActor = Wall;
		if (!Wall.bStatic && (DamageRadius == 0))
		{
			Wall.TakeDamage( Damage, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		}

		// do a trace to get physical material

		HitActor = AOCTrace( HitLocation, HitNormal2, PrevLocation, Location + Normal(Location-PrevLocation) * 5.0f, true,, HitInfo);
		ImpactedTrace = HitInfo;
		//LogAlwaysInternal("HIT ACTOR WALL"@HitActor);
		PlayImpactSound(HitActor, HitInfo, HitLocation);
		//DisableProjCam();

		//HitActor = AOCTrace( HitLocation, HitNormal2, PrevLocation, Location + Normal(Location-PrevLocation) * 5.0f, true,, HitInfo);
		
		Explode(Location, HitNormal);
		ImpactedActor = None;
	}

	if(ROLE < ROLE_Authority)
	{
		bCanShutDown = true;
		Shutdown();
	}
	
}

DefaultProperties
{
	DrawScale=1.0
	AccelRate=0.0
	LifeSpan=1.5
	
	//So it can penetrate actors
	bCanShutDown=false

	bCheckProjectileLight=true
	ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Lite_P_Tesla'
	//ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.LITE_P_Pillar01'
	ExplosionLightClass=class'UTShockImpactLight'
	ProjectileLightClass=class'MW.MWLight_ProjFlame'
	//ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Lite_P_Explode'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Lite_P_Explode'
	
	//ExplosionSound=SoundCue'MWCONTENT.SFXCUE_Cig'
	//AmbientSound=SoundCue'MWCONTENT.SFXCUE_Fuse'
	
	NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	Physics=PHYS_Falling
	bBounce=false
	CustomGravityScaling=-100
	bRotationFollowsVelocity=true
	bBlockedByInstigator=true
		
	//ColorLevel=(X=100,Y=1,Z=100)
	//ExplosionColor=(X=100,Y=1,Z=100)

	
	Begin Object Name=StaticMeshComponent0
		//StaticMesh=StaticMesh'MWCONTENT.Spell_Fireball'
		StaticMesh=none
		Scale=0.5
	End Object
	
	//ProjType=EPROJ_Javelin
	//ProjExplosionTemplate=none
	//CheckRadius=36.0

	AmbientSound=SoundCue'MWCONTENT_SFX.Light_ProjectileLoop'
	ExplSound=SoundCue'MWCONTENT_SFX.Light_Hit'
	//ExplSound=SoundCue'MWCONTENT_SFX.Light_Pillar'
	ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'	

		
	YawRate = 0.0f
	PitchRate = 0.0f
	RollRate = 0.0f
	fProjectileAttachCompensation=50.f

	ProjCamPosModX=-50
	ProjCamPosModZ=25
	
	bEnableArrowCamAmbientSoundSwap=true
	ArrowCamAmbientSound=SoundCue'A_Projectile_Flight.Flight_jav_Cam'
}


