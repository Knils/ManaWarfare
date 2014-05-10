class MWProj_Spell extends AOCProjectile
	abstract;

var SoundCue        ExplSound;
var ParticleSystem  ProjExplTemplate;
var ParticleSystem  HealPS;

var bool            bCanExplode; //If we can explode
var bool            bHaveExplode; //If we have exploded yet
var bool            bAoE; //AOE Pulse toggle
var float           AoETimer; //Timer for AOE pulse around projectile
var bool            bCanShutDown; //Used to stop explosion on impact
var bool            bSmallFlinch; //Adds small flinch to AOE
var bool            bSuckIn; //AOE Force pulls towards instead of away
var bool            bSuperHurtRadius; //Call Super Hurt Radius
var bool            bHitDead; //If we can hit the dead
var bool            bHitOwner; //If we can hit self
var bool            bHaveAOCProcessTouch; //If we have AOCProcessTouched
var bool            bAoEHitShield; //AOE Pulse will break on shield hit
var bool            bIgnoreShield; //Ignores shields and goes right through
var bool            bAoEOnce;
var bool            bFireArmor;

var vector          StartLocation; //Location the projectile was spawned
var int             MaxDistance; //The max distance the projectile can move before shutdown

//Stops AOE from hitting same target more than once
var array<Actor> HitActorArray;

/**Speed increase from each bounce*/
var float BounceMulti;
/**Maximum number of bounces*/
var int BounceMax;
/**How many times the projectile has bounced*/
var int BounceNumber;
/**The Z dampen on each bounce*/
var float ZDampen;
/**Ignored min Normal*/
var float WallNormal;
/**Velocity*/
var vector vel;

var int             x, y; //counter

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if(bAoE)
		SetTimer(AoETimer,true,'AoESet');
	if(!bCanShutDown)
		SetTimer(LifeSpan-0.25,false,'CanShutDown');
}

simulated function CanShutDown()
{
	bCanShutDown = true;
}

simulated function AoESet()
{
	local vector HitNormal;

	HitNormal = vect(0,0,1);
	AoE( Location, HitNormal );
}

//Exlpode without the shutdown
simulated function AoE(vector HitLocation, vector HitNormal)
{
	if (DamageRadius>0)
	{
		if ( Role == ROLE_Authority )
			MakeNoise(1.0);
		if ( !bShuttingDown )
		{
			ProjectileHurtRadius(HitLocation, HitNormal );
		}
	}
	SpawnExplosionEffects(HitLocation, HitNormal);
}

simulated function bool HurtRadius( float DamageAmount,
								    float InDamageRadius,
									class<DamageType> DamageType,
									float Momentum,
									vector HurtOrigin,
									optional actor IgnoredActor,
									optional Controller InstigatedByController = Instigator != None ? Instigator.Controller : None,
									optional bool bDoFullDamage
									)
{
	local Actor	Victim;
	local TraceHitInfo HitInfo;
	local vector HitNormal;

	local HitInfo Info;
	//local int i;
	local class<AOCWeapon> Weap;

	if(bSuperHurtRadius)
	{
		LogAlwaysInternal("bSuperHurtRadius TICK");
		if(bFireArmor)
		{
			//ImpactedActor = OwnerPawn;
		}
		Super.HurtRadius(DamageAmount, InDamageRadius, DamageType, Momentum, HurtOrigin, ImpactedActor, InstigatedByController, bDoFullDamage);
	}

	if (Role == ROLE_Authority || OwnerPawn.bIsBot)
	{	
		foreach VisibleCollidingActors( class'Actor', Victim, DamageRadius*0.8, HurtOrigin,,,,, HitInfo )
		{	
			if ( !Victim.bWorldGeometry && (Victim != self) && (Victim != IgnoredActor) && (Victim.bCanBeDamaged || Victim.bProjTarget))
			{
				LogAlwaysInternal("AOE CHECK NON SUPER");
				//AOE Check that we don't hit the same target more than once
				if(bAoEOnce)
				{
					HitActorArray[x] = Victim;
					//LogAlwaysInternal("HitActorArray.Length:"@HitActorArray.Length);
					
					for (y = 0; y < HitActorArray.Length - 1; y++)
					{
						if(HitActorArray[y] == Victim)
						{
							LogAlwaysInternal("REJECT ATTACK" @HitActorArray.Length-1);
							return false;			
						}
					}
					x++;
					y = 0;
				}
				
				//Dead Check
				/*
				if (AOCPawn(Victim) != none && AOCPawn(Victim).bPlayedDeath && !bHitDead)
				{
					LogAlwaysInternal("Dead Pawn Reject Hit");
					return false;					
				}
				*/
				//Buffs/Debuffs
				if(AOCPawn(Victim) != OwnerPawn || bHitOwner)
				{
					LogAlwaysInternal("Apply Buffs");
					If(bFireArmor && bHitOwner)
						SuccessHitMWPawn(MWPawn(Victim));
					else if(!bFireArmor)
						SuccessHitMWPawn(MWPawn(Victim));
					SuccessHitAOCPawn(AOCPawn(Victim));

					if(bFireArmor)
						MWPawn(Victim).TakeRadiusDamage(InstigatedByController, DamageAmount, DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);

					if ( (ImpactedActor != None) && (ImpactedActor != self)  )
					{
						//ImpactedActor.TakeRadiusDamage(InstigatedByController, DamageAmount, DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);
						//bAoEOnce=true;
					}
					else
					{
						//MWPawn(Victim).TakeRadiusDamage(InstigatedByController, DamageAmount, DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);
					}
				}

				if(bSmallFlinch && AOCPawn(Victim) != OwnerPawn || bHitOwner)
				{
					LogAlwaysInternal("SMALL FLINCH"@DamageRadius@DamageRadius*0.8);
					//MWPawn(Victim).SetPawnSpecialDaze(false, EDIR_BOT, true, false, false);
					//bStopFlinchLoop = true;
					//AOCProcessTouch(Victim,HurtOrigin,HitNormal,HitInfo);	

					if (OwnerPawn.Role < ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
					{
						if (Info.HitComp == AOCPawn(Victim).Mesh || Info.HitComp == AOCPawn(Victim).ShieldMesh || Info.HitComp == AOCPawn(Victim).BackShieldMesh)
						{
							Info.AttackType = Attack_Slash;
							Info.BoneName = HitInfo.BoneName;
							Info.bParry = false;
							Info.DamageType = class<AOCDamageType>(MyDamageType);
							Info.HitActor = AOCPawn(Victim);

							if(!bSuperHurtRadius)
							{
								//LogAlwaysInternal("VSize:"@vsize(Self.Location - HurtOrigin)@Self.Location@HurtOrigin);

								LogAlwaysInternal("Set Damage Because bSuperHurtRadius="@bSuperHurtRadius);
								//Explode on Each impact
								//ExplosionEffect();
								//bHaveExplode = false;
								if(!bFireArmor)
								{
									Info.HitDamage = Damage;
									HitNormal = normal(HurtOrigin - Victim.Location);
									Info.HitForce = MomentumTransfer*(-HitNormal);
								}
							}

							if(bSuckIn)
							{
								HitNormal = normal(HurtOrigin - Victim.Location);
								Info.HitForce = 35000*(HitNormal);
							}
							
							//Info.HitLocation = HitLocation;
							Info.HitNormal = HitNormal;
							Info.HitComp = HitInfo.HitComponent;
							Info.Instigator = OwnerPawn;
							Info.HitCombo = 0;
							Info.TimeVar = WorldInfo.TimeSeconds - StartFlightTime;
							Info.ProjType = Class;
							Info.UsedWeapon = CurrentAssociatedWeapon;

							Weap = OwnerPawn.TertiaryWeapon;

							LogAlwaysInternal("Info.HitComp="@Info.HitComp@"---------------------------");
							
							MWPawn(OwnerPawn).AttackOtherPawn_NoFlinch(Info,Weap.default.WeaponFontSymbol,,,Info.HitComp == AOCPawn(Victim).ShieldMesh || Info.HitComp == AOCPawn(Victim).BackShieldMesh);

							/*
							if(!bIgnoreShield && Victim != none && Info.HitComp == AOCPawn(Victim).ShieldMesh || Info.HitComp == AOCPawn(Victim).BackShieldMesh)
							{
								LogAlwaysInternal("HitShieldBreak@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
								//bHaveExplode = true;
								bCanShutDown = true;
								ShutDown();
							}
							*/
						}
					}
				}
			}		
		}
	}
	
	return true;
}

simulated event Tick( float DeltaTime)
{
	local Vector HitLocation, HitNormal;
	local Vector CurTraceLocs[5];
	local Actor HitActor;
	local TraceHitInfo HitInfo;
	local int i;
	local vector PrevLoc, CurLoc;

	if(bFirstTick)
	{
		StartLocation = Location;
	}

	//Distance Check
	if(MaxDistance > 0)
	{
		if(vsize(Location - StartLocation) >= MaxDistance)
		{
			bCanShutDown=true;
			Shutdown();
		}
	}

	// Calculate drag
	if (!( Normal(Velocity) Dot Vect(0.0f, 0.0f, -1.0f) >= 0.7f ))  // If it's not moving down
	{
		Velocity -= Velocity * Drag * DeltaTime * DRAG_SCALE;
	}

	if (Role < ROLE_Authority && OwnerPawn.IsLocallyControlled() && !OwnerPawn.bIsBot)
	{
		ShutDown();
		return;
	}
	if(bHasShutdown)
	{
		return;
	}
	
	super.Tick( DeltaTime );
	
	if ((Role == ROLE_Authority /*&& OwnerPawn.IsLocallyControlled()*/) || OwnerPawn.bIsBot)
	{
		for (i = 0; i < 5; i++)
		{
			SetupExtraTracerLocations(CurTraceLocs, Location);
			PrevLoc = PreviousTraceLoc[i];
			CurLoc = CurTraceLocs[i];
			if(AOCPawn(Instigator) != none && AOCWeaponAttachment(AOCPawn(Instigator).CurrentWeaponAttachment).bDrawDebug)
				AOCWeaponAttachment(AOCPawn(Instigator).CurrentWeaponAttachment).DrawServerDebugLineOnClient( PrevLoc,CurLoc, PlayerController(Instigator.Controller), 255,0,0);
			foreach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, CurLoc, PrevLoc,, HitInfo, TRACEFLAG_BULLET)
			{
				if( HitActor != none && AOCPawn(HitActor) != none && HitInfo.HitComponent == AOCPawn(HitActor).ParryComponent )
				{
					continue;
				}

				//Projectile goes through shields
				if(bIgnoreShield && HitActor != none && HitInfo.HitComponent == AOCPawn(HitActor).ShieldMesh || HitInfo.HitComponent == AOCPawn(HitActor).BackShieldMesh)
				{
					continue;
				}
			
				if( HitActor != none && WorldInfo(HitActor) == none && AOCPawn(HitActor) != OwnerPawn && HitActors.Find(HitActor) == INDEX_NONE )
				{
					if (AOCPawn(HitActor) != none && !AOCPawn(HitActor).bPlayedDeath)
					{
						ImpactedActor = HitActor;
						LogAlwaysInternal("TICK AOCProcessTouch:"@ROLE);
						AOCProcessTouch(HitActor, HitLocation, HitNormal, HitInfo);

						AttachToComponent( HitActor, HitInfo.HitComponent, HitLocation, HitNormal );

						bShouldAttach = true;
						Shutdown();
						//PlayImpactSound(HitActor, HitInfo, HitLocation);

						ImpactedActor = None;

						HitActors.AddItem(HitActor);
						return;
					}
					else if (AOCPawn(HitActor) != none && AOCPawn(HitActor).bPlayedDeath && Role == ROLE_Authority)
					{
						if(bHitDead)
						{
							AttackDeadPawn(AOCPawn(HitActor), HitInfo, HitLocation, HitNormal);
							//ImpactSoundName = PlayImpactSound(HitActor, HitInf, HitLocation);
							Shutdown();
							HitActors.AddItem(HitActor);
							return;
						}
						else
							continue;
					}
				}
			}
		}
	}

	TimeElapsed+=DeltaTime;
	MovementDirection=Normal(Location-PrevLocation);
	PrevLocation = Location;
	for (i = 0; i < 5; i++)
		PreviousTraceLoc[i] = CurTraceLocs[i];
	RotateProjectile(YawRate, PitchRate, RollRate);
	bFirstTick = false;
}

simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	local KActorFromStatic NewKActor;
	local StaticMeshComponent HitStaticMesh;
	local Vector HitLocation, HitNormal2;
	local TraceHitInfo HitInf, HitInfo;
	local Actor HitActor;
	local name ImpactSoundName;

	//LogAlwaysInternal("HITWALL ROLE:"@ROLE);
	if(ROLE < ROLE_Authority)
	{
		if(bBounce)
		{
			Bounce(HitNormal);
		}
		else
		{
			ExplosionEffect();
			Shutdown();
		}
	}
		
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
					if(bHitDead)
					{
						AttackDeadPawn(AOCPawn(HitActor), HitInfo, HitLocation, HitNormal);
						ImpactSoundName = PlayImpactSound(HitActor, HitInf, HitLocation);
						Shutdown();
						HitActors.AddItem(HitActor);
						return;
					}
					else
						continue;
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

		if(bBounce)
		{
			Bounce(HitNormal);
		}
		else if(bSpawnSticky)
		{
			AttachToWorld(Location, Wall, ImpactSoundName);
		}

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
		
		//HitActor = AOCTrace( HitLocation, HitNormal2, PrevLocation, Location + Normal(Location-PrevLocation) * 5.0f, true,, HitInfo);
		if(!bBounce)
			Explode(Location, HitNormal);
		ImpactedActor = None;
	}
}

simulated function Bounce(vector HitNormal)
{
	Velocity = MirrorVectorByNormal(Velocity,HitNormal);
}

simulated function AOCProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal, TraceHitInfo TraceInfo)
{
	local HitInfo Info;
	local int i;
	local class<AOCWeapon> Weap;

	LogAlwaysInternal("PROCESS TOUCH"@Role);
	if( Role < ROLE_Authority || bHaveAOCProcessTouch)
		return;
	bHaveAOCProcessTouch = true;
	bDamagedSomething=true;

	if (AOCPawn(Other) == none)
	{
		Other.TakeDamage(Damage,InstigatorController,HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		Shutdown();
	}
	else if (AOCPawn(Other) == OwnerPawn && !bHitOwner)
	{
		return;
	}
	else
	{
		if (DamageRadius > 0.0)
		{
			Explode( HitLocation, HitNormal );
		}
		Info.AttackType = Attack_Slash;
		Info.BoneName = TraceInfo.BoneName;
		Info.bParry = false;
		Info.DamageType = class<AOCDamageType>(MyDamageType);
		Info.HitActor = AOCPawn(Other);
		Info.HitDamage = Damage;
		Info.HitForce = MomentumTransfer*(-HitNormal);
		Info.HitLocation = HitLocation;
		Info.HitNormal = HitNormal;
		Info.HitComp = TraceInfo.HitComponent;
		Info.Instigator = OwnerPawn;
		Info.HitCombo = 0;
		Info.TimeVar = WorldInfo.TimeSeconds - StartFlightTime;
		Info.ProjType = Class;
		Info.UsedWeapon = CurrentAssociatedWeapon;
		//LogAlwaysInternal("ATTACK OTHER PAWN"@Other@Info.HitComp@AOCPawn(Other).ShieldMesh@AOCPawn(Other).BackShieldMesh@CurrentAssociatedWeapon);
		if (OwnerPawn.Role < ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
		{
			if (Info.HitComp == AOCPawn(Other).Mesh || Info.HitComp == AOCPawn(Other).ShieldMesh || Info.HitComp == AOCPawn(Other).BackShieldMesh)
			{
				/*
				if (CurrentAssociatedWeapon == 0)
					Weap = OwnerPawn.PrimaryWeapon;
				else if (CurrentAssociatedWeapon == 1)
					Weap = OwnerPawn.SecondaryWeapon;
				else
					Weap = OwnerPawn.TertiaryWeapon;
					*/
				Weap = OwnerPawn.TertiaryWeapon;
				OwnerPawn.AttackOtherPawn(Info,Weap.default.WeaponFontSymbol,,,Info.HitComp == AOCPawn(Other).ShieldMesh || Info.HitComp == AOCPawn(Other).BackShieldMesh);
			}
		}

		//Add StruckByProjectileInfo to struck pawn (for ammo pickup by attacker)
		for ( i=0 ; i < class'AOCPawn'.const.MAXIMUM_STORED_PROJECTILE_TYPES ; i++)
		{
			//Search for empty element or one of the same pawn and weapon type
			if ( AOCPawn(Other).StruckByProjectiles[i].ProjectileOwner == none || AOCPawn(Other).StruckByProjectiles[i].ProjectileType == none)         //If array element is unused
			{
				//Assign info to array element
				AOCPawn(Other).StruckByProjectiles[i].ProjectileOwner = OwnerPawn;
				AOCPawn(Other).StruckByProjectiles[i].ProjectileType = LaunchingWeapon;
				AOCPawn(Other).StruckByProjectiles[i].ProjectileCount = 1;
				break;
			}
			else if(AOCPawn(Other).StruckByProjectiles[i].ProjectileOwner == OwnerPawn && AOCPawn(Other).StruckByProjectiles[i].ProjectileType == LaunchingWeapon)          //If array element matches attacker and launching weapon type 
			{
				//Add ammo to count
				AOCPawn(Other).StruckByProjectiles[i].ProjectileCount++;
				break;
			}
		}
		
		LogAlwaysInternal("REACHING SUCCESSHIT!");
		
		SuccessHitPawn(AOCPawn(Other), TraceInfo.BoneName);
		SuccessHitMWPawn(MWPawn(Other));
		SuccessHitAOCPawn(AOCPawn(Other));
		////LogAlwaysInternal("SUCCESSFULLY HIT A PAWN SHUTDOWN");
		
		Shutdown();
	}
}

simulated function SuccessHitMWPawn(MWPawn P)
{	
}

simulated function SuccessHitAOCPawn(AOCPawn P)
{
}

auto simulated state Exist
{
	simulated event EndState(Name PreviousStateName)
	{		
		ExplosionEffect();
	}
}

simulated function ExplosionEffect()
{
	if(!bHaveExplode && bCanExplode)
	{
		//Stops Simulated Proxy Effects On Authority Client
		if(Role < ROLE_Authority && OwnerPawn.IsLocallyControlled())
		{
			//LogAlwaysInternal("PROXY DENIED");
		}
		else
		{				
			PlaySound(ExplSound,false, true, false);
			WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplTemplate, self.location,,,,,true);
			bHaveExplode=true;
			
			//SkeletalMeshComponent.AttachComponentToSocket(ProjExplTemplate, TraceEnd);
			
			LogAlwaysInternal("EXPLODE @ Location:"@Location);
		}
	}
}

simulated function Actor AOCTrace
(
	out vector					HitLocation,
	out vector					HitNormal,
	vector						TraceEnd,
	optional vector				TraceStart,
	optional bool				bTraceActors,
	optional vector				Extent,
	optional out TraceHitInfo	HitInfo,
	optional int				ExtraTraceFlags
)
{
	local Actor HitActor;
	
	foreach TraceActors(class'Actor', HitActor, HitLocation, HitNormal, TraceStart, TraceEnd, Extent, HitInfo, ExtraTraceFlags)
	{
		if( HitActor != none && AOCPawn(HitActor) != none && HitInfo.HitComponent == AOCPawn(HitActor).ParryComponent )
		{
			continue;
		}
		else if (AOCPawn(HitActor) == OwnerPawn)
		{
			continue;
		}
		else
		{
			return HitActor;	
		}
	}
	return none;
}

function ReceiveShutdownForce(ProjectileBaseInfo BaseInfo)
{
	local SoundCue Sound;

	if(BaseInfo.Other != none || BaseInfo.bHitWorld)
	{
		RepBaseInfo = BaseInfo;
		bNetDirty = true;
		Shutdown();
	}
	else
	{
		//got a forced shutdown without any base info. Tear us right the hell off, and let the clients do any resulting attaches themselves.
		bTearOff = true;
		LifeSpan = 1.0f;
	}

	// Play impact sound if there was one
	if (BaseInfo.ImpactSound != 'None')
	{
		Sound = none;
		switch(BaseInfo.ImpactSound)
		{
			case 'Stone':
				Sound = ImpactSounds.Stone;
				break;
			case 'Dirt':
				Sound = ImpactSounds.Dirt;
				break;
			case 'Gravel':
				Sound = ImpactSounds.Gravel;
				break;
			case 'Foliage':
				Sound = ImpactSounds.Foliage;
				break;
			case 'Sand':
				Sound = ImpactSounds.Sand;
				break;
			case 'Metal':
				Sound = ImpactSounds.Metal;
				break;
			case 'Snow':
				Sound = ImpactSounds.Snow;
				break;
			case 'Wood':
				Sound = ImpactSounds.Wood;
				break;
			case 'Ice':
				Sound = ImpactSounds.Ice;
				break;
			case 'Mud':
				Sound = ImpactSounds.Mud;
				break;
			case 'Tile':
				Sound = ImpactSounds.Tile;
				break;
			case 'Water':
				Sound = ImpactSounds.Water;
				break;
		}
		if (Sound != none)
		{
			PlaySound(Sound, false,true, false, BaseInfo.Location);
		}
	}
}

simulated function name PlayImpactSound(Actor Other, TraceHitInfo HitInfoTrace, vector HitLoc)
{
	local name SoundName;
	local UTPhysicalMaterialProperty PhysicalProperty;
	local ARMORTYPE armorType;
	
	// We hit a player or bot
	if (AOCPawn(Other) != none)
	{
		// Hit player's shield, use 2 cue block sound sysem.
		if (bHitShield)
		{
			ImpactSound = AOCPawn(Other).ShieldClass.NewShield.default.BlockSound;
			PlaySound(ProjBlockedSound, false,, false, Location);
		}
		else
		{
			armorType = AOCPawn(Other).PawnInfo.myFamily.default.PawnArmorType;

			if (armorType == ARMORTYPE_HEAVY)
				ImpactSound = ImpactSounds.Heavy;
			else if (armorType == ARMORTYPE_MEDIUM)
				ImpactSound =  ImpactSounds.Medium;
			else if (armorType == ARMORTYPE_LIGHT)
				ImpactSound = ImpactSounds.Light;
		}
	}
	// Hit something else in the world
	else 
	{
		if (AOCWaterVolume(Other) != None)
		{
			AOCWaterVolume(Other).PlayEntrySplash(self);
			ImpactSound = ImpactSounds.Water;
			SoundName = 'Water';
		}
		else if (HitInfoTrace.PhysMaterial != None)
		{
			PhysicalProperty = UTPhysicalMaterialProperty(HitInfoTrace.PhysMaterial.GetPhysicalMaterialProperty(class'UTPhysicalMaterialProperty'));
			if (PhysicalProperty != None)
			{
				SoundName = PhysicalProperty.MaterialType;

				Switch (PhysicalProperty.MaterialType)
				{
					case 'Stone':
						ImpactSound = ImpactSounds.Stone;
						break;
					case 'Dirt':
						ImpactSound = ImpactSounds.Dirt;
						break;
					case 'Gravel':
						ImpactSound = ImpactSounds.Gravel;
						break;
					case 'Foliage':
						ImpactSound = ImpactSounds.Foliage;
						break;
					case 'Sand':
						ImpactSound = ImpactSounds.Sand;
						break;
					case 'Metal':
						ImpactSound = ImpactSounds.Metal;
						break;
					case 'Snow':
						ImpactSound = ImpactSounds.Snow;
						break;
					case 'Wood':
						ImpactSound = ImpactSounds.Wood;
						break;
					case 'Ice':
						ImpactSound = ImpactSounds.Ice;
						break;
					case 'Mud':
						ImpactSound = ImpactSounds.Mud;
						break;
					case 'Tile':
						ImpactSound = ImpactSounds.Tile;
						break;
					default:
						ImpactSound = ImpactSounds.Stone;
						break;
				}	
			}
			else
			{
				ImpactSound = ImpactSounds.Stone;
				SoundName = 'Stone';
			}
		}
		else
		{
			ImpactSound = ImpactSounds.Stone;
			SoundName = 'Stone';
		}
	}

	if (bLimitImpactSound && WorldInfo.TimeSeconds - LastImpactSoundTime < 2.f)
		return 'None';
	LastImpactSoundTime = WorldInfo.TimeSeconds;
	// Play the sound
	//LogAlwaysInternal("IMPACT SOUND:"@ImpactSound);

	PlaySound(ImpactSound, false,true, false, HitLoc);
	return SoundName;
}

simulated function Shutdown()
{	
	//LogAlwaysInternal("ShutDown");
	if(bCanShutDown || Role < ROLE_Authority && OwnerPawn.IsLocallyControlled())
	{
		ExplosionEffect();
		super.ShutDown();
	}
}

DefaultProperties
{
	bAoEOnce=true
	bIgnoreShield=false
	bHitDead=false
	bSuperHurtRadius=true
	bHaveAOCProcessTouch=false
	bHitOwner=true
	bSmallFlinch=true
	bCanShutDown=true
	bHaveExplode=false
	bCanPickupProj=false
	bSpawnSticky=false
	bBounce=false
	bCanExplode=true
	bNetTemporary=False
	bWaitForEffects=false
	bOverrideDefaultExplosionDeffect=false

	MaxDistance=0

	AccelRate=0.0
	LifeSpan=8

	MyDamageType=class'MWDmgType_GenericProj'
	HealPS=ParticleSystem'MWCONTENT_PFX.Watr_HealLoop'
	//ProjType=EPROJ_Default
	ProjType=EPROJ_Javelin
	fProjectileAttachCompensation=0
	Physics=PHYS_Falling

	YawRate = 0.0f
	PitchRate = 0.0f
	RollRate = 0.0f

	NetCullDistanceSquared=+144000000.0	
}