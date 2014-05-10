class MWProj_Earth extends MWProj_Spell;

struct ExplosionFXInf
{
	var Vector Loc;
	var Rotator Rot;
	
	structdefaultproperties
	{
	}
};
var repnotify ExplosionFXInf RepData;

replication
{
	if ( bNetDirty )
		RepData;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'RepData')
	{
		LogAlwaysInternal("REPLICATING - Spawn EarthSpike@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		Spawn(class'MWSpell_EarthSpike',,,RepData.Loc,RepData.Rot,,true);		
	}
	super.ReplicatedEvent(VarName);
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	LogAlwaysInternal("PostBeginPlay:"@Role@"**************");
}

simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;
	local Vector HitLocation, HitNormal2;
	local TraceHitInfo HitInfo; //HitInf
	local Actor HitActor;
	//local name ImpactSoundName;
	
	LogAlwaysInternal("HitWall - ROLE:"@Role@"**************");

	//Stop Double Spawn Rock
	if(bCanShutDown)
	{
		return;
	}
		
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
		
		AOE(Location, HitNormal);
		ImpactedActor = None;
	}
}

simulated function AOCProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal, TraceHitInfo TraceInfo)
{
}

simulated function SpawnEarthSpike(vector HitNormal)
{
	local Vector SpawnLoc;
	local rotator SpawnRot;

	
	SpawnLoc = Location - vect(170,170,170)*HitNormal;
	LogAlwaysInternal("Spawn Earth Spike - ROLE:"@Role@"&&&&&&&&&&&&&&&");
	//SpawnLoc = Location;
	LogAlwaysInternal("SpawnLoc"@SpawnLoc @ "*************************************************");
	LogAlwaysInternal("ProjHitLoc"@Location);
	SpawnRot = rotator(HitNormal);
	SpawnRot.Pitch -= 16384;
	///LogAlwaysInternal("SpawnRot"@SpawnRot @ "*************************************************");
	//SpawnRot.Yaw += rand(10)*10000;

	LogAlwaysInternal(RepData.Loc@RepData.Rot);
	RepData.Loc = SpawnLoc;
	RepData.Rot = SpawnRot;
	LogAlwaysInternal(RepData.Loc@RepData.Rot);

	//Stop Double Spawn on Casters Side
	if(!OwnerPawn.IsLocallyControlled())
		Spawn(class'MWSpell_EarthSpike',,,SpawnLoc,SpawnRot,,true);

	//ExplSound=SoundCue'MWCONTENT_SFX.Rock_Burst';
	bCanShutDown = true;
	//AOE(Location, HitNormal);
	SetTimer(0.05,false,'ShutDown');
	///LogAlwaysInternal("Location:"@Location);
}

DefaultProperties
{
	DrawScale=1.0
	AccelRate=0.0
	LifeSpan=5

	MaxDistance=2000

	DamageRadius=120
	MomentumTransfer=60000.0

	bCanShutDown=false
	//NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	Physics=PHYS_Falling
	bBounce=false
	CustomGravityScaling=15
	bRotationFollowsVelocity=true
	bBlockedByInstigator=true

	bAlwaysRelevant=true
	bNetTemporary=False

	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'MWCONTENT.Spell_Void'
		//StaticMesh=none
		Scale=0.8
	End Object
		
	//ProjExplosionTemplate=none
	//CheckRadius=36.0
	//AmbientSound=SoundCue'A_Projectile_Flight.Flight_spear'
	ExplSound=SoundCue'MWCONTENT_SFX.Rock_Burst'
	
	ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'	

	YawRate = 0.0f
	PitchRate = 0.0f
	RollRate = 0.0f
	
	ProjCamPosModX=-50
	ProjCamPosModZ=25
	
	bEnableArrowCamAmbientSoundSwap=true
	ArrowCamAmbientSound=SoundCue'A_Projectile_Flight.Flight_jav_Cam'
}

