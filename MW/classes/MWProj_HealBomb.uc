class MWProj_HealBomb extends MWProj_Spell;

simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;
	local Vector HitLocation, HitNormal2;
	local TraceHitInfo HitInfo; //HitInf
	local Actor HitActor;
	//local name ImpactSoundName;
	
	if(ROLE < ROLE_Authority)
	{
		SpawnEarthSpike(HitNormal);
	}
	LogAlwaysInternal("HitWall - ROLE:"@Role@"**************"@DamageRadius);
		
	if(bHasShutdown)
	{
		return;
	}

	// do a trace first to see if we hit an actor in the process
	if( AOCWeaponAttachment(AOCPawn(Instigator).CurrentWeaponAttachment).bDrawDebug)
		AOCWeaponAttachment(AOCPawn(Instigator).CurrentWeaponAttachment).DrawServerDebugLineOnClient( PrevLocation,Location, PlayerController(Instigator.Controller), 255,0,0);
	/*	
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
				///LogAlwaysInternal("HIT ACTOR:"@HitActor@AOCPawn(HitActor).Health);
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
	*/
	Super(Actor).HitWall(HitNormal, Wall, WallComp);

	if ((Role == ROLE_Authority /*&& OwnerPawn.IsLocallyControlled()*/) || OwnerPawn.bIsBot)
	{
		///LogAlwaysInternal("ATTACH TO WORLD"@Wall);
		SpawnEarthSpike(HitNormal);
		//AttachToWorld(Location, Wall, ImpactSoundName);

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
		///LogAlwaysInternal("HIT ACTOR WALL"@HitActor);
		PlayImpactSound(HitActor, HitInfo, HitLocation);
		DisableProjCam();

		//HitActor = AOCTrace( HitLocation, HitNormal2, PrevLocation, Location + Normal(Location-PrevLocation) * 5.0f, true,, HitInfo);
		
		Explode(Location, HitNormal);
		ImpactedActor = None;
	}
}

simulated function AOCProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal, TraceHitInfo TraceInfo)
{
}

simulated function SpawnEarthSpike(vector HitNormal)
{
	//LogAlwaysInternal("EXPLODE_TEST");
	AOE(Location, HitNormal);
	ShutDown();
}

simulated function SuccessHitMWPawn(MWPawn P)
{
	P.SetPawnOnHeal(HealPS, OwnerPawn.Controller, OwnerPawn,,3);	
}

DefaultProperties
{
	bHitOwner=false
	bSmallFlinch=false
	DamageRadius=150

	//ExplSound=SoundCue'MWCONTENT_SFX.Water_HealStart'
	ExplSound=SoundCue'MWCONTENT_SFX.Watr_AltHit'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Watr_Poof'
}
