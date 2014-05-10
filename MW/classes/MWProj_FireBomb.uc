class MWProj_FireBomb extends MWProj_Spell;

var ParticleSystem          FirePS;

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
				///LogAlwaysInternal("Hitwall1");
				continue;
			}
		
			if( HitActor != none && WorldInfo(HitActor) == none && /*AOCPawn(HitActor) != OwnerPawn && */HitActors.Find(HitActor) == INDEX_NONE )
			{
				/////LogAlwaysInternal("HIT ACTOR:"@HitActor@AOCPawn(HitActor).Health);
				if (AOCPawn(HitActor) != none && !AOCPawn(HitActor).bPlayedDeath)
				{
					ImpactedActor = HitActor;
					ImpactedTrace = HitInf;
					///LogAlwaysInternal(HitActor@"Hitwall2");
					LogAlwaysInternal("HITWALL AOCProcessTouch:"@ROLE);
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
					//Shutdown();
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
		/////LogAlwaysInternal("ATTACH TO WORLD"@Wall);

		///LogAlwaysInternal(Vsize(velocity) @ Location.X @ Location.Y @ Location.Z);

		Stick(HitNormal);
		if(bBounce)
			AttachToWorld(Location, Wall, ImpactSoundName);

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
		/////LogAlwaysInternal("HIT ACTOR WALL"@HitActor);
		PlayImpactSound(HitActor, HitInfo, HitLocation);
		//DisableProjCam();

		//HitActor = AOCTrace( HitLocation, HitNormal2, PrevLocation, Location + Normal(Location-PrevLocation) * 5.0f, true,, HitInfo);
		
		//Explode(Location, HitNormal);
		ImpactedActor = None;
	}

	if(ROLE < ROLE_Authority)
	{
		foreach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, PrevLocation, Location,, HitInf, TRACEFLAG_Bullet | TRACEFLAG_PhysicsVolumes)
		{
			if( HitActor != none && AOCPawn(HitActor) != none && HitInfo.HitComponent == AOCPawn(HitActor).ParryComponent )
			{
				Shutdown();
				return;
			}
		}
		Stick(HitNormal);
	}
}

simulated function SuccessHitAOCPawn(AOCPawn P)
{	
	P.SetPawnOnFire(FirePS, OwnerPawn.Controller, OwnerPawn,,2);
}

simulated function Stick(vector HitNormal)
{
	Velocity = vect(0,0,0);
	SetTimer(1.0,false,'TimerExplode');
}

simulated function TimerExplode(vector HitNormal)
{
	AoE( Location, HitNormal );
	ExplosionEffect();
	ShutDown();
}

/*
simulated function ExplosionEffect()
{
	if(!bHaveExplode && bCanExplode)
	{
		if(Role < ROLE_Authority && OwnerPawn.IsLocallyControlled())
			LogAlwaysInternal("PROXY DENIED");
		else
		{				
			PlaySound(ExplSound,false, true, false);
			Spawn(class'MWSpell_FireBombExplode',,,Location,,,true);
			bHaveExplode=true;
			LogAlwaysInternal("EXPLODE");
		}
	}
}
*/
DefaultProperties
{
	FirePS=ParticleSystem'CHV_PartiPack.Particles.P_fire_blazing_grow1_nosmoke'
	bHitOwner=true
	DrawScale=5
	LifeSpan=5.0
	CustomGravityScaling=5
	DamageRadius=220
	MomentumTransfer=30000.0

	bCheckProjectileLight=true
	ProjFlightTemplate=ParticleSystem'WP_bow_Longbow.Particles.P_ArrFire_trail'
	ProjectileLightClass=class'MW.MWLight_ProjFlame'
	//ExplosionLightClass=class'UTShockImpactLight'
	ExplosionLightClass=class'UTGame.UTRocketExplosionLight'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Fire_Shield'

	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'MWCONTENT.Spell_Fireball'
		//StaticMesh=none
		Scale=0.35
	End Object

	AmbientSound=SoundCue'MWCONTENT_SFX.Fire_ProjectileLoop'
	ExplSound=SoundCue'MWCONTENT_SFX.Fire_Impact'
	ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'	
}

