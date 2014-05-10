class MWProj_Boulder extends MWProj_Spell;

simulated function tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	SetRotation(Rotator(Velocity));
}

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
		ExplosionEffect();
		Shutdown();
	}
	
}

simulated function AOCProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal, TraceHitInfo TraceInfo)
{}

DefaultProperties
{
	bHitOwner=false
	bSuperHurtRadius=false;
	bAoE=true
	AoETimer=0.05
	bCanShutDown=false

	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Rock_P_Burst02'
	ExplSound=SoundCue'MWCONTENT_SFX.Rock_Break'
	//bSpawnSticky=true
	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'CHV_CitRocks.SM_straight_spike_rock'
		//StaticMesh=none
		Scale=1
		Rotation=(Pitch=-16384)
	End Object
}
