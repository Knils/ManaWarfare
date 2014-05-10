//Javelin Throw Code Modified by Knil.

class MWWeapon_StaffSpell extends MWSpellWeapon;

// Animation that plays when we change to the throwable mode
var AnimationInfo SwapToAnimation;
var AnimationInfo AltSwapToAnimation;

var float        SprintAttackSpeedBonusMod;
var float        SprintAttackDamageBonus;
var bool				bHasFired;
var bool				bAlternativeFireStopped;
var bool				bIsReadyToSwitch;

//MW
var float       ChargePercent, ChargeMulti;
var float       Charge;
var float       ManaTickTime;
var bool        bSetSpell, bChargeRebalance, bManaRegen, bInRange, bChannel;
var int         WaterSpread, EarthSpread, VoidMiniSpread, Cost, FeintMana, ManaTickAmount;
var int         Type;
var soundcue    SFXSpellStart, SFXShot, SFXChannel, SFXChargeMin, SFXChargeMax;

//Alt Spell
var bool bDisableAlt; //Disables alt casting
var bool bAltSpell, bAltSpellRef; 
var MWWeapon_StaffMelee StaffMelee;
var class<AOCProjectile> ProjClass;

//SpellInfo
var float Damage, InitialSpeed, MaxSpeed, Gravity, Scale, Radius, Force, Range;

//TestFiremode
var int relfire, relfire2;
var int x;

//SoundReplication
var repnotify bool bIsChargingMin, bIsChargingMax, bIsChanneling;

struct SpellInfo
{
	var float Damage;
	var float InitialSpeed;
	var float MaxSpeed;
	var float Radius;
	var float Gravity;
	var float Charge;
	var float Force;
	var int Cost;
	var float Range;
	var bool bChannel;
	var float Scale;	
	var float Drag;
	var class<AOCProjectile> ProjClass;
	var SoundCue SFXChannel;
	var soundcue SFXChargeMin;
	var soundcue SFXChargeMax;
	var soundcue SFXSpellStart;
	var soundcue SFXShot;

	structdefaultproperties
	{
		bChannel=false;
		SFXChannel=none;
	}
};

var array<SpellInfo> Spell; //Original Spell
var array<SpellInfo> Spell2; //Alt Spell

replication
{
	if ( bNetDirty)
		Type, bAltSpell, bIsChargingMin, bIsChargingMax, bIsChanneling;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
}

simulated function AltSpell()
{
	if(!bDisableAlt)
	{
	//LogAlwaysInternal(StaffMelee);
	
	bAltSpell = MWWeapon_StaffMelee(AlternativeModeInstance).bAltSpell;
	LogAlwaysInternal("Alt Spell="@bAltSpell);
	if(bAltSpell != bAltSpellRef)
		bSetSpell = true;
	bAltSpellRef = bAltSpell;
	}
	
}

//SET Different Spell variables
simulated function SetSpell()
{
	bSetSpell = false;
	if(AOCOwner.PawnInfo.myTertiary == class'MWWeapon_ProjVoid')
		Type = 0;
	else if(AOCOwner.PawnInfo.myTertiary == class'MWWeapon_ProjFlame')
		Type = 1;
	else if(AOCOwner.PawnInfo.myTertiary == class'MWWeapon_ProjEarth')
		Type = 2;
	else if(AOCOwner.PawnInfo.myTertiary == class'MWWeapon_ProjWater')
		Type = 3;
	else if(AOCOwner.PawnInfo.myTertiary == class'MWWeapon_ProjElectric')
		Type = 4;
		
	//Configs
	if(!bAltSpell)
	{
		Damage = Spell[Type].Damage;
		Charge = Spell[Type].Charge;
		InitialSpeed = Spell[Type].InitialSpeed;
		MaxSpeed = Spell[Type].MaxSpeed;
		Gravity = Spell[Type].Gravity;
		Drag = Spell[Type].Drag;
		SFXSpellStart = Spell[Type].SFXSpellStart;
		SFXChargeMin = Spell[Type].SFXChargeMin;
		SFXChargeMax = Spell[Type].SFXChargeMax;
		SFXShot = Spell[Type].SFXShot;
		Cost = Spell[Type].Cost;
		ProjClass = Spell[Type].ProjClass;
		Scale = Spell[Type].Scale;
		SetCurrentFireMode = type * 10 + 10;
		Radius = Spell[Type].Radius;
		Force = Spell[Type].Force;
		Range = Spell[Type].Range;
		bChannel = Spell[Type].bChannel;
		SFXChannel = Spell[Type].SFXChannel;
	}
	else
	{
		Damage = Spell2[Type].Damage;
		Charge = Spell2[Type].Charge;	
		InitialSpeed = Spell2[Type].InitialSpeed;
		MaxSpeed = Spell2[Type].MaxSpeed;
		Gravity = Spell2[Type].Gravity;
		Drag = Spell2[Type].Drag;
		SFXSpellStart = Spell2[Type].SFXSpellStart;
		SFXChargeMin = Spell2[Type].SFXChargeMin;
		SFXChargeMax = Spell2[Type].SFXChargeMax;
		SFXShot = Spell2[Type].SFXShot;
		Cost = Spell2[Type].Cost;
		ProjClass = Spell2[Type].ProjClass;
		Scale = Spell2[Type].Scale;
		SetCurrentFireMode = type * 10 + 11;
		Radius = Spell2[Type].Radius;
		Force = Spell2[Type].Force;
		Range = Spell2[Type].Range;
		bChannel = Spell2[Type].bChannel;
		SFXChannel = Spell2[Type].SFXChannel;
	}

	

	//Cast Times
	WindupAnimations[SetCurrentFireMode].fAnimationLength = default.WindupAnimations[SetCurrentFireMode].fAnimationLength;
	ReleaseAnimations[SetCurrentFireMode].fAnimationLength = default.ReleaseAnimations[SetCurrentFireMode].fAnimationLength;
	RecoveryAnimations[SetCurrentFireMode].fAnimationLength = default.RecoveryAnimations[SetCurrentFireMode].fAnimationLength;
	ReloadAnimations[SetCurrentFireMode].fAnimationLength = default.WindupAnimations[SetCurrentFireMode].fAnimationLength;
	
	WindupAnimations[SetCurrentFireMode].fAnimationLength *= Charge*3/4 + 0.25;
	ReleaseAnimations[SetCurrentFireMode].fAnimationLength *= Charge/4 + 0.75;
	RecoveryAnimations[SetCurrentFireMode].fAnimationLength *= Charge/4 + 0.75;
	ReloadAnimations[SetCurrentFireMode].fAnimationLength *= Charge/4 + 0.75; 

	CacheWeaponReferences();
	//LogAlwaysInternal("Type:" @ Type @ "Windup:"@WindupAnimations[0].fAnimationLength@ "Charge:" @ Charge @ "Tertiary:" @ AOCOwner.PawnInfo.myTertiary @ "&&&&&&&&&&&&&&&&&&&&&&&&&&&");
}

simulated function class<Projectile> GetProjectileClass()
{
	return ProjClass;
}

/**
 * Fire.
 */
simulated function Fire()
{
	local rotator Aim;
   	local Vector RealStartLoc;
	local vector HitLocation, HitNormal, EndTrace, StartTrace;

	///LogAlwaysInternal("ARE WE LOADED?"@bLoaded);
	if (bLoaded)
	{
		if (!AOCOwner.bIsBot)
			AOCOwner.OwnerMesh.GetSocketWorldLocationAndRotation(AOCOwner.CameraSocket, RealStartLoc, Aim);
		else
		{
			AOCOwner.Mesh.GetSocketWorldLocationAndRotation(AOCOwner.CameraSocket, RealStartLoc, Aim);
			Aim = AOCAICombatController(AOCOwner.Controller).GetAim(RealStartLoc);
		}

		AddProjectileSpread(Aim);

		LogAlwaysInternal("FIRE!");

		if(bChannel && ProjClass != class'MWProj_Electric')
		{
			RealStartLoc -= vect(0,0,40);
		}
		
		if(ProjClass == class'MWProj_Pillar')
		{
			//StartTrace = InstantFireStartTrace();
			LogAlwaysInternal("LIGHTNING STRIKE!");
			StartTrace = RealStartLoc;
			EndTrace = InstantFireEndTrace(StartTrace);
			Trace(HitLocation,HitNormal,EndTrace,StartTrace,false);
			SpawnProjectile( HitLocation + vect(0,0,750),-16384,0,0);
			//Trace(HitLocation2,HitNormal,HitLocation - vect(0,0,500),HitLocation + vect(0,0,500),false);
			//Spawn(class'MWSpell_LightPillar',,,HitLocation2);
			//ConfigProjectileBaseDamage[Type].Damage = 67;
			
		}
		else if(ProjClass == class'MWProj_Earthquake')
		{
			SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw, Aim.Roll );
			SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw + EarthSpread, Aim.Roll );
			SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw - EarthSpread, Aim.Roll );
			SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw + 2*EarthSpread, Aim.Roll );
			SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw - 2*EarthSpread, Aim.Roll );
		}
		else if(ProjClass == class'MWProj_Water')
		{
			SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll );
			//SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll );
			/*SpawnProjectile( RealStartLoc, Aim.Pitch + WaterSpread, Aim.Yaw, Aim.Roll );
			SpawnProjectile( RealStartLoc, Aim.Pitch -WaterSpread, Aim.Yaw, Aim.Roll );
			SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw + WaterSpread, Aim.Roll );
			SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw -WaterSpread, Aim.Roll );

			InitialSpeed=250;
			SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll );*/
		}
		else if(ProjClass == class'MWProj_VoidMini')
		{
			SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll );
			SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw + VoidMiniSpread, Aim.Roll );
			SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw - VoidMiniSpread, Aim.Roll );
			//SpawnProjectile( RealStartLoc, Aim.Pitch + VoidMiniSpread, Aim.Yaw, Aim.Roll );
			//SpawnProjectile( RealStartLoc, Aim.Pitch - VoidMiniSpread, Aim.Yaw, Aim.Roll );
		}
		else if(ProjClass == class'MWProj_VoidSlash')
		{
			SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll );
			ProjClass = class'MWProj_Dummy';
			SpawnProjectile( RealStartLoc + vect(0,0,25.0), Aim.Pitch, Aim.Yaw, Aim.Roll );
			SpawnProjectile( RealStartLoc - vect(0,0,25.0), Aim.Pitch, Aim.Yaw, Aim.Roll );
			SpawnProjectile( RealStartLoc + 2*vect(0,0,25.0), Aim.Pitch, Aim.Yaw, Aim.Roll );
			SpawnProjectile( RealStartLoc - 2*vect(0,0,25.0), Aim.Pitch, Aim.Yaw, Aim.Roll );
			ProjClass = class'MWProj_VoidSlash';
		}
		else if(ProjClass == class'MWProj_LightFan')
		{
			SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw, Aim.Roll );
			//SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw + EarthSpread, Aim.Roll );
			//SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw - EarthSpread, Aim.Roll );
			SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw + 2*EarthSpread, Aim.Roll );
			SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw - 2*EarthSpread, Aim.Roll );
		}
		else
		{
			SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll );
		}
		
		if (WorldInfo.NetMode != NM_Standalone && !AOCOwner.bIsBot)
		{
			if(ProjClass == class'MWProj_Pillar')
			{
				Server_SpawnProjectile( HitLocation + vect(0,0,750),-16384,0,0);
			}
			else if(ProjClass == class'MWProj_Earthquake')
			{
				Server_SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw + EarthSpread, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw - EarthSpread, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw + 2.5*EarthSpread, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw - 2.5*EarthSpread, Aim.Roll );
			}
			else if(ProjClass == class'MWProj_Water')
			{
				Server_SpawnProjectile(RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll);
				/*Server_SpawnProjectile( RealStartLoc, Aim.Pitch + WaterSpread, Aim.Yaw, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc, Aim.Pitch -WaterSpread, Aim.Yaw, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw + WaterSpread, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw -WaterSpread, Aim.Roll );

				InitialSpeed=250;
				Server_SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll );*/
			}
			else if(ProjClass == class'MWProj_VoidMini')
			{
				Server_SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw + VoidMiniSpread, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw - VoidMiniSpread, Aim.Roll );
				//Server_SpawnProjectile( RealStartLoc, Aim.Pitch + VoidMiniSpread, Aim.Yaw, Aim.Roll );
				//Server_SpawnProjectile( RealStartLoc, Aim.Pitch - VoidMiniSpread, Aim.Yaw, Aim.Roll );
			}
			else if(ProjClass == class'MWProj_VoidSlash')
			{
				Server_SpawnProjectile( RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll );
				ProjClass = class'MWProj_Dummy';
				Server_SpawnProjectile( RealStartLoc + vect(0,0,25.0), Aim.Pitch, Aim.Yaw, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc - vect(0,0,25.0), Aim.Pitch, Aim.Yaw, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc + 2*vect(0,0,25.0), Aim.Pitch, Aim.Yaw, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc - 2*vect(0,0,25.0), Aim.Pitch, Aim.Yaw, Aim.Roll );
				ProjClass = class'MWProj_VoidSlash';
			}
			else if(ProjClass == class'MWProj_LightFan')
			{
				Server_SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw, Aim.Roll );
				//Server_SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw + EarthSpread, Aim.Roll );
				//Server_SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw - EarthSpread, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw + 2.5*EarthSpread, Aim.Roll );
				Server_SpawnProjectile( RealStartLoc - vect(0,0,80), 0, Aim.Yaw - 2.5*EarthSpread, Aim.Roll );
			}
			else
			{
				Server_SpawnProjectile(RealStartLoc, Aim.Pitch, Aim.Yaw, Aim.Roll);
			}

			
		}
		else
		{
			SpawnedProjectile.RemoteRole = ROLE_None; //It's MINE (client-side projectile)
		}

		enableProjCam();
		//Aim = GetAdjustedAim( RealStartLoc );			// get fire aim direction

		AOCOwner.OnActionInitiated(EACT_RangedWeaponFired);
	}
}

simulated function SpawnProjectile( Vector RealStartLoc, float Pitch, float Yaw, float Roll )
{
	local Rotator Aim;
	//local EProjType Type;
	/*
	if(Worldinfo.TimeSeconds - fLastProjectileSpawnTime < fReasonableRefireRate)
	{
		///LogAlwaysInternal("Rejected SpawnProjectile from"@AOCOWner.PlayerReplicationInfo.PlayerName@"because"@(Worldinfo.TimeSeconds - fLastProjectileSpawnTime)@"is faster than"@fReasonableRefireRate);
		return;
	}
	else
	{
		///LogAlwaysInternal("Allowed SpawnProjectile from"@AOCOWner.PlayerReplicationInfo.PlayerName@"because"@(Worldinfo.TimeSeconds - fLastProjectileSpawnTime)@"is slower than"@fReasonableRefireRate);
	}
	fLastProjectileSpawnTime = Worldinfo.TimeSeconds;
	*/	
	
	Aim.Pitch = Pitch + ConfigProjectileBaseDamage[Type].PitchCorrection;;
	Aim.Yaw = Yaw;
	Aim.Roll = Roll;
	
	SpawnedProjectile = Spawn(GetProjectileClass(),self,, RealStartLoc, Aim);
	
	///LogAlwaysInternal("Spawned"@SpawnedProjectile@"for"@self);
	
	if (AOCPlayerController(AOCOwner.Controller) != none)
	{
		AOCProjectile(SpawnedProjectile).ProjIdent = ++AOCPlayerController(AOCOwner.Controller).ProjectileNumber;
		AOCPlayerController(AOCOwner.Controller).SpawnedProjectile.AddItem(AOCProjectile(SpawnedProjectile));
	}

	
	if ( SpawnedProjectile != None )
	{
		//AOCProjectile(SpawnedProjectile).SetDrawScale(Scale*(ChargePercent + 1));

		ChargeMulti = ChargePercent/2 + 1; //+ FRand()/10;
						
		//x1.5 multi at max
		AOCProjectile(SpawnedProjectile).Damage = Damage*ChargeMulti;
		AOCProjectile(SpawnedProjectile).Speed = InitialSpeed*ChargeMulti;
		AOCProjectile(SpawnedProjectile).MaxSpeed = MaxSpeed*ChargeMulti;
		AOCProjectile(SpawnedProjectile).TerminalVelocity = MaxSpeed*ChargeMulti;
		AOCProjectile(SpawnedProjectile).CustomGravityScaling = Gravity;
		AOCProjectile(SpawnedProjectile).Drag = Drag;
		AOCProjectile(SpawnedProjectile).SetDrawScale(Scale*ChargeMulti);

		//x1.25 at max
		AOCProjectile(SpawnedProjectile).DamageRadius = Radius*((ChargeMulti-1)/2 + 1);
		AOCProjectile(SpawnedProjectile).MomentumTransfer = Force*((ChargeMulti-1)/2 + 1);

		//LogAlwaysInternal(AOCProjectile(SpawnedProjectile).DamageRadius);
			
		//LogAlwaysInternal("Gravity="@AOCProjectile(SpawnedProjectile).CustomGravityScaling);

		/*if (AOCOwner.bIsBot) //TEMP: Bots can't handle drag at the moment, so, uh, turn it off
			AOCProjectile(SpawnedProjectile).Drag = 0;*/

		AOCProjectile(SpawnedProjectile).LaunchingWeapon = self.Class;
		AOCProjectile(SpawnedProjectile).OwnerPawn = AOCOwner;
		AOCProjectile(SpawnedProjectile).CurrentAssociatedWeapon = 2;
		AOCProjectile(SpawnedProjectile).AOCInit(Aim);

		if (AOCPlayerController(AOCOwner.Controller) != none)
			AOCProjectile(SpawnedProjectile).ThisController = AOCPlayerController(AOCOwner.Controller);
	}

	LogAlwaysInternal("ChargeMulti:"@ChargeMulti);
	AOCProjectile(SpawnedProjectile).CurrentAssociatedWeapon = 0;
}

// We _always_ want to go through WeaponEquipping; AOCWeapon skips it if IsFiring()
simulated function Activate()
{
	///LogAlwaysInternal("(Jav) ACTIVATE WEAPON HERE"@self);
	LogAlwaysInternal("Activate");
	SetupArmsAnim();
	GotoState('WeaponEquipping');
	AOCOwner = none;
	AOCWepAttachment = none;
	bHasFired = false;
	bLoaded = true; //just to be sure
	bIsReadyToSwitch = false;
}

simulated state WeaponEquipping
{
	simulated event BeginState(Name PreviousStateName)
	{
		LogAlwaysInternal("EquipSpell");
		
		//Reseting
		bUseAlternateSide = MWWeapon_StaffMelee(AlternativeModeInstance).bUseAlternateSide;
		bIsReadyToSwitch = false;
		bWantToFire = false;
		ChargePercent = 0;
		x = 0;
		bChargeRebalance = true;
		bInRange = true;
					
		AltSpell();
		if(bSetSpell)
		{
			SetSpell();
		}

		CurrentFireMode = SetCurrentFireMode;

		//WeaponFontSymbol="J";
		//LogAlwaysInternal(CurrentFireMode);
				
		if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE)
		{
			///LogAlwaysInternal("HIDE MELEE CROSSHAIR");
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).TurnOffCrosshair();
		}
		super.BeginState(PreviousStateName);
		if (!AOCOwner.StateVariables.bShieldEquipped)
			AOCOwner.EquipShield(false);
	}

	simulated function PlayStateAnimation()
	{
		if(!bAltSpell)
			AOCOwner.PlayPawnAnimation(SwapToAnimation);
		else
			AOCOwner.PlayPawnAnimation(AltSwapToAnimation);
	}

	simulated function BeginFire(byte FireModeNum)
	{
		if(CurrentFireMode == SetCurrentFireMode)
			bWantToFire = false;		
	}
	simulated function EndFire(byte FireModeNum)
	{
		if(CurrentFireMode == SetCurrentFireMode)
			bWantToFire = true;
	}
}

/** Weapon Putting Down Has No Animation for Javelin - Handled in Weapon Equip */
simulated state WeaponPuttingDown
{
	/** Play appropriate attack animation */
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		WeaponIsDown();
	}

	/** Play release animation */
	simulated function PlayStateAnimation()
	{
		CacheWeaponReferences();
	}
}

/** Equip state - used for equipping the shield 
 */
simulated state ShieldEquip
{
	/** Play appropriate attack animation */
	simulated event BeginState(Name PreviousStateName)
	{
		// Do a double check here for whether we are allowed to have shield
		OnStateAnimationEnd();
	}
}

simulated state Windup
{
	simulated event BeginState(Name PreviousStateName)
	{
		LogAlwaysInternal("WINDUP");
		LogAlwaysInternal("SetCurrentFireMode"@ SetCurrentFireMode);
		//CurrentFireMode = SetCurrentFireMode;
		super.BeginState(PreviousStateName);
				
		//PlaySound(SFXSpellStart,false, true, true);
		LogAlwaysInternal("Charge:"@Charge @ "Windup:"@WindupAnimations[0].fAnimationLength @ "Release:"@ReleaseAnimations[0].fAnimationLength @ "Reload:"@ReloadAnimations[0].fAnimationLength @ "Recovery:"@RecoveryAnimations[0].fAnimationLength);
	}

	/** Cancel Fire.
	 */
	simulated function BeginFire(byte FireModeNum)
	{
		if (FireModeNum == Attack_Parry)
		{
			LogAlwaysInternal("FEINT*****************************");
			AddAmmo(-FeintMana);
			bManaRegen=true;
			ManaRegen();

			bHasFired = true;
			GotoState('Active');
		}
		if(CurrentFireMode == SetCurrentFireMode)
			bWantToFire = false;
	}

	simulated function EndFire(byte FireModeNum)
	{
		if(CurrentFireMode == SetCurrentFireMode)
			bWantToFire = true;
	}

	simulated function OnStateAnimationEnd()
	{
		LogAlwaysInternal("bWantToFire:"@bWantToFire);
		LogAlwaysInternal(CurrentFireMode @ SetCurrentFireMode);
		if (CurrentFireMode == SetCurrentFireMode && !bWantToFire && !MWWeapon_StaffMelee(AlternativeModeInstance).bPlayAlternateAnimation)
		{
			LogAlwaysInternal("GO TO HOLD");
			GotoState('Hold');
		}
		else
		{
			LogAlwaysInternal("GO TO RELEASE");
			bWantToFire = false;
			GotoState('Release');
		}
	}
}

simulated state Hold
{
	simulated event BeginState(Name PreviousStateName)
	{
		//bIsChargingMin, bIsChargingMax, bIsChanneling;
		LogAlwaysInternal("HOLD");
		Super.BeginState(PreviousStateName);
		
		bManaRegen = false;

		if(bChannel)
		{
			bIsChanneling = true;
			//MWPawn(AOCOwner).bChannelFire=true;
			LogAlwaysInternal(SFXChannel);
			MWPawn(AOCOwner).ReplicateLoopSound(bIsChanneling, SFXChannel);
			SetTimer(0.45,true,'Fire');
			//SFXChannel.Play();
		}
		else
		{
			bIsChargingMin = true;
			MWPawn(AOCOwner).ReplicateLoopSound(bIsChargingMin, SFXChargeMin);
		}
		//SFXChargeMin.FadeIn(0.1,1);
		//SFXChargeMin.Play();
	}

	//Spell charge
	simulated event Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
				
		if(ChargePercent < 1)
		{
			
			ChargePercent = FMin(ChargePercent + (DeltaTime/Charge),1);
			LogAlwaysInternal(ChargePercent);
			if(ChargePercent == 1)
			{
				if(!bChannel)
				{
					//bIsChargingMin = false;
					bIsChargingMax = true;
					MWPawn(AOCOwner).ReplicateLoopSound(bIsChargingMax, SFXChargeMax);
				}
				PlaySound(SoundCue'MWCONTENT_SFX.Mana_Maxcharge', true, true, true);
				SetTimer(2,false,'ManaDrain');
			}
		}
		if(AmmoCount <= Cost)
		{
			bWantToFire = true;
			GotoState('Release');
		}

	}

	simulated function ManaDrain()
	{
		PlaySound(SoundCue'MWCONTENT_SFX.Mana_Empty_NoAttenuation', true, true, true);
		if(bChannel)
		{
			AddAmmo(-10*Charge);
		}
		else
		{
			AddAmmo(-5*Charge);		
		}

		SetTimer(1.5,false,'ManaDrain');
	}

	simulated function EndState( name NextStateName )
	{
		super.EndState(NextStateName);

		if(bChannel)
		{
			bIsChanneling = false;
			//SFXChannel.FadeOut(1.0f, 0.0f);
			//MWPawn(AOCOwner).bChannelFire=false;
			MWPawn(AOCOwner).ReplicateLoopSound(bIsChanneling, SFXChannel);
			ClearTimer('Fire');
		}
		else
		{
			bIsChargingMin = false;
			bIsChargingMax = false;
			MWPawn(AOCOwner).ReplicateLoopSound(bIsChargingMin, SFXChargeMax);
		}
		
		ClearTimer('ManaDrain');
		bManaRegen = true;
		ManaRegen();		
	}

	/** Cancel Fire.
	 */
	simulated function BeginFire(byte FireModeNum)
	{
		if (FireModeNum == Attack_Shove)
			AOCOwner.PlaySound(AOCOwner.GenericCantDoSound, true);
		else if (FireModeNum == Attack_Parry)
		{
			if(bChannel)
			{
				AddAmmo(-Cost);
			}
			GotoState('Recovery');
		}
	}
}

/** Release state. Fire the projectile.
 */
simulated state Release
{
	/** Play appropriate attack animation */
	simulated event BeginState(Name PreviousStateName)
	{
		LogAlwaysInternal("RELEASE");
		If(Range > 0)
		{
			RangeCheck();
		}
		if (AOCOwner == none || AOCWepAttachment == none)
			CacheWeaponReferences();

		ReleaseProjectileTime = WorldInfo.TimeSeconds;
		PlayStateAnimation();		
	}

	simulated function RangeCheck()
	{
		local rotator Aim;
		local Vector RealStartLoc;
		local vector HitLocation, HitNormal, EndTrace, StartTrace;

		if (!AOCOwner.bIsBot)
			AOCOwner.OwnerMesh.GetSocketWorldLocationAndRotation(AOCOwner.CameraSocket, RealStartLoc, Aim);
		else
		{
			AOCOwner.Mesh.GetSocketWorldLocationAndRotation(AOCOwner.CameraSocket, RealStartLoc, Aim);
			Aim = AOCAICombatController(AOCOwner.Controller).GetAim(RealStartLoc);
		}

		AddProjectileSpread(Aim);

		StartTrace = RealStartLoc;
		EndTrace = InstantFireEndTrace(StartTrace);
		Trace(HitLocation,HitNormal,EndTrace,StartTrace,false);
		if(Vsize(HitLocation - StartTrace) > Range)
		{
			LogAlwaysInternal("Out of Range!"@Vsize(HitLocation - StartTrace) @">"@ Range);
			PlaySound(SoundCue'MWCONTENT_SFX.Mana_Empty_NoAttenuation', true, true, true);
			bInRange = false;
			GoToState('Recovery');
		}
		
	}

	simulated function EndState( name NextStateName )
	{	
		if(bInRange)
		{
			if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE)
			{
				CacheWeaponReferences();
			
				Fire();							
				//AOCWeaponAttachment(AOCOwner.CurrentWeaponAttachment).DetachArrow();
			}
			ConsumeAmmo(0); // consume ammo for 0'th fire type - only one type of range firing
			ManaRegen();
			AOCOwner.StateVariables.bIsAttacking = false;
			NumVerticalReversals = 0;
			NumHorizontalReversals = 0;
		
			if(Role == Role_Authority)
			{
				AOCOwner.ResetSprintSpeed();
			}
		}
	}

	simulated function BeginFire(byte FireModeNum)
	{
		
	}
	simulated function EndFire(byte FireModeNum)
	{
		
	}

}

/** Recovery state. User coming back to active/idle after firing weapon.
 */
simulated state Recovery
{
	/** Skip state and go straight to reload */
	simulated event BeginState(Name PreviousStateName)
	{
		LogAlwaysInternal("RECOVERY");
		bWantToFire = false;		
		AOCOwner.StateVariables.bIsParrying = false;
		PlayStateAnimation();
	}

	/** When finished with recovery go to the next state */
	simulated function OnStateAnimationEnd()
	{
		GotoState('Reload');
	}

	/** Play recovery animation */
	simulated function PlayStateAnimation()
	{
		local AnimationInfo Info; // custom AnimationInfo to pass
		Info = RecoveryAnimations[0];
		//Info.fBlendOutTime = GetRealAnimLength(Info) - 0.05f;
		AOCOwner.PlayPawnAnimation(Info);
	}
	
	simulated function BeginFire(byte FireModeNum)
	{
		/*
		if (EAttack(FireModeNum) == SetCurrentFireMode || EAttack(FireModeNum) == Attack_Overhead)
		{
			AttackQueue = EAttack(FireModeNum);
		}
		*/
		AttackQueue = EAttack(FireModeNum);
	}

	simulated function EndFire(byte FireModeNum)
	{
		/*
		if (FireModeNum == Attack_Overhead)
			return;
		else
			bWantToFire = true;
			*/
		//AttackQueue = Attack_Null;
	}
}

/** Reload state. Most range weapons are automated reload with the exception of the crossbow.
 */
simulated state Reload
{
	/** When finished with reload go to the next state */
	simulated function OnStateAnimationEnd()
	{
		LogAlwaysInternal("RELOAD");
		///LogAlwaysInternal("Should now go to Active");
		bIsReadyToSwitch = true;
		GotoState('Active');
	}

	simulated function BeginFire(byte FireModeNum)
	{
		/*
		if (EAttack(FireModeNum) == SetCurrentFireMode || EAttack(FireModeNum) == Attack_Overhead)
		{
			AttackQueue = EAttack(FireModeNum);
		}
		*/
		AttackQueue = EAttack(FireModeNum);
	}	
}

/** Active - check our alternative weapon to see if it switched to us during an attack */
simulated state Active
{
	simulated event BeginState(Name PreviousStateName)
	{
		LogAlwaysInternal("ACTIVE");
		bManaRegen=true;
		ForceEndFire();
		bLoaded = true;

		//AttackQueue = Attack_Null;
		super.BeginState(PreviousStateName);
		//bWantToFire = true;
				
		CacheWeaponReferences();
		
		bIsReadyToSwitch = false;

		//bAlternativeFireStopped = false;
		//CurrentFireMode = SetCurrentFireMode;
		if(!bHasFired)
		{
			//LogAlwaysInternal("STARTING BEGINFIRE!!!!!!!!!!!!!!!!!");
			bHasFired = true;
			BeginFire(SetCurrentFireMode);
			if(bAlternativeFireStopped)
			{
				//LogAlwaysInternal("STOP FIREEEEEEEEEEEEEEEEEEE!!!!");
				StopFire(SetCurrentFireMode);
				ServerStopFire(SetCurrentFireMode); //just to be sure
				bAlternativeFireStopped = false;	
			}
		}
		else
		{
			//the javelin has fired, switch back to melee mode	
			bIsReadyToSwitch = true;
			AOCOwner.SwitchWeapon(1);		
		}
		//SetTimer(0.05,false,'SwapToMelee');
	}

	//Keep us from getting stuck in Active
	simulated event Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);

		x++;
		LogAlwaysInternal(x);
		if(x > 1)
		{
			bIsReadyToSwitch = true;
			AOCOwner.SwitchWeapon(1);	
		}
	}

	simulated function BeginFire(Byte FireModeNum)
	{
		//LogAlwaysInternal("BEGINFIRE!!!!!!!!!!!!!!!!!");
		if(CurrentFireMode == SetCurrentFireMode || CurrentFireMode == 1)
		{
			if(!bIsReadyToSwitch && Cost < AmmoCount)
			{
				//LogAlwaysInternal("SUPER BEGINFIRE!!!!!!!!!!!!!!!!!");
				//LogAlwaysInternal("bLoaded"@bLoaded);
				//super.BeginFire(FireModeNum);
				super.BeginFire(SetCurrentFireMode);
				//bWantToFire=false;
				GoToState('Windup');
			}
			else
			{
				PlaySound(SoundCue'MWCONTENT_SFX.Mana_Empty_NoAttenuation', true, true, true);
				bIsReadyToSwitch = true;
				AOCOwner.SwitchWeapon(1);
			}
		}
	}

	simulated function EndState( name NextStateName )
	{
		super.EndState(NextStateName);
	}
}

// If we just swapped from another weapon and have a pending attack, cache any StopFires
simulated function StopFire(byte FireModeNum)
{
	super.StopFire(FireModeNum);
	
	CacheWeaponReferences();
	if(IsInState('WeaponEquipping'))
	{
		AlternativeFireStopped();
	}
}

simulated function AlternativeFireStopped()
{
	bAlternativeFireStopped = true;
	if (AOCOwner.Role != ROLE_Authority && WorldInfo.NetMode != NM_STANDALONE)
	{
		ServerAlternativeFireStopped();
	}
}

// Need to remember that we're requesting a stop on the server as well
reliable server function ServerAlternativeFireStopped()
{
	bAlternativeFireStopped = true;
}

simulated function bool CanSwitch()
{
	return bIsReadyToSwitch;	
}

function ManaRegen()
{
	/////LogAlwaysInternal("1"@bManaRegen @ AmmoCount);
	if(bManaRegen && AmmoCount != 99)
	{
		SetTimer(ManaTickTime,false,'ManaAdd');
	}
}

function ManaAdd()
{
	/////LogAlwaysInternal("2"@bManaRegen @ AmmoCount);
	if(bManaRegen && AmmoCount != 99)
	{
		AddAmmo(ManaTickAmount);
		ManaRegen();
	}
}

function ConsumeAmmo( byte FireModeNum )
{
	// Subtract the Ammo
	if (CurrentFireMode == SetCurrentFireMode)
	{
		AddAmmo(-Cost);
		//super.ConsumeAmmo(FireModeNum);
	}
}

function int AddAmmo( int Amount )
{
	
	local int ret;
	ret =  UTAmmo(Amount);
	
	if (WorldInfo.NetMode == NM_STANDALONE)
		NotifyAmmoConsume();
	
	if (ret == 0)
	{
		if (Amount > 0)
			bLoaded = false;
		AOCWepAttachment.bHasAmmo = false;
		AOCOwner.bWeaponHasAmmoLeft = false;
	}
	
	else if (Amount > 0)
	{
		if (Amount > 0)
			bLoaded = true;
		MWPlayerController(AOCOwner.Controller).NotifyManaGain(Amount);
		AOCWepAttachment.bHasAmmo = true;
		AOCOwner.bWeaponHasAmmoLeft = true;
	}

	return ret;
	
}

function int UTAmmo( int Amount )
{
	AmmoCount = Clamp(AmmoCount + Amount,0,MaxAmmoCount);
	// check for infinite ammo
	if (AmmoCount <= 0 && (UTInventoryManager(InvManager) == None || UTInventoryManager(InvManager).bInfiniteAmmo))
	{
		AmmoCount = MaxAmmoCount;
	}

	return AmmoCount;
}

simulated function NotifyAmmoConsume()
{	
	if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE)
	{
		AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).UpdateAmmoCount(AmmoCount, MaxAmmoCount);
		AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).bIsLowAmmo = AmmoCount <= 0.10f* MaxAmmoCount;
	}	
	
}

simulated function SwitchWeaponNoAmmo()
{
}

DefaultProperties
{
	bInRange = true
	bChargeRebalance=true
	bSetSpell=true
	bDisableAlt=false
	bAltSpell=false
	bManaRegen=true

	//WaterSpread=3500
	WaterSpread=750
	EarthSpread=750
	//EarthSpread=0
	
	FeintMana=10
	ManaTickTime=2
	ManaTickAmount=10

	FiringStatesArray(3)= Windup
	ShotCost(3)=1

	CurrentWeaponType = EWEP_Javelin
	// set maximum ammo
	AmmoCount=99
	MaxAmmoCount=99
	AIRange=5000
	
	AttachmentClass=class'MWWeaponAttachment_StaffSpell'
	// should never be part of inventory attachment
	InventoryAttachmentClass=class'MWInventoryAttachment_StaffMelee'
	//PermanentAttachmentClass(0)=class'AOCInventoryAttachment_JavelinQuiver'
	//PermanentAttachmentClass(1)=class'AOCInventoryAttachment_JavelinQuiver'
	PermanentAttachmentClass(0)=class'MWInventoryAttachment_StaffMelee'
	PermanentAttachmentClass(1)=class'MWInventoryAttachment_StaffMelee'
	//AllowedShieldClass=class'AOCShield_Buckler'
	AllowedShieldClass=class'MWShield_Mana'
	bHaveShield=true
	
	ImpactBloodTemplates(0)=ParticleSystem'CHV_Particles_01.Player.Impact.P_1HSwordHit'
	ImpactBloodTemplates(1)=ParticleSystem'CHV_Particles_01.Player.Impact.P_1HSwordHit'
	ImpactBloodTemplates(2)=ParticleSystem'CHV_Particles_01.Player.Impact.P_1HSwordHit'

	BloodSprayTemplates(0)=ParticleSystem'CHV_Particles_01.Player.P_OnWeaponBlood'
	BloodSprayTemplates(1)=ParticleSystem'CHV_Particles_01.Player.P_OnWeaponBlood'
	BloodSprayTemplates(2)=ParticleSystem'CHV_Particles_01.Player.P_OnWeaponBlood'
	
	CurrentGenWeaponType=EWT_Javelin
	//WeaponIdleAnim=''
	bRetIdle = false
	bRetIdleOriginal=false
	bPlayOnWeapon=false
	bEquipShield=false
	bCanParry=False
	bCanSwitchShield=false
	bUseDirParryHitAnims=true

	WeaponIdentifier="javelin"
	//WeaponIdentifier="1hsharp"

	ProjectileSpawnLocation=ProjJavelinPoint

	Begin Object Class=AudioComponent Name=VoidCharge1
        SoundCue=SoundCue'MWCONTENT_SFX.Void_Charge1'                
    End Object
	
	Begin Object Class=AudioComponent Name=VoidCharge2
        SoundCue=SoundCue'MWCONTENT_SFX.Void_Charge2'                
    End Object
	
	Begin Object Class=AudioComponent Name=FireCharge1
        SoundCue=SoundCue'MWCONTENT_SFX.Fire_Charge1'                
    End Object
	
	Begin Object Class=AudioComponent Name=FireCharge2
        SoundCue=SoundCue'MWCONTENT_SFX.Fire_Charge2'               
    End Object
	
	Begin Object Class=AudioComponent Name=RockCharge1
        SoundCue=SoundCue'MWCONTENT_SFX.Rock_Charge1'                
    End Object
	
	Begin Object Class=AudioComponent Name=RockCharge2
        SoundCue=SoundCue'MWCONTENT_SFX.Rock_Charge2'               
    End Object
	
	Begin Object Class=AudioComponent Name=WaterCharge1
        SoundCue=SoundCue'MWCONTENT_SFX.Water_Charge1'                
    End Object
	
	Begin Object Class=AudioComponent Name=WaterCharge2
        SoundCue=SoundCue'MWCONTENT_SFX.Water_Charge2'               
    End Object
	
	Begin Object Class=AudioComponent Name=LightCharge1
        SoundCue=SoundCue'MWCONTENT_SFX.Light_Charge1'                
    End Object
	
	Begin Object Class=AudioComponent Name=LightCharge2
        SoundCue=SoundCue'MWCONTENT_SFX.Light_Charge2'               
    End Object

	Begin Object Class=AudioComponent Name=FireCone
        SoundCue=SoundCue'MWCONTENT_SFX.Fire_Cone'            
    End Object

	Begin Object Class=AudioComponent Name=WaterCone
        SoundCue=SoundCue'MWCONTENT_SFX.Watr_Cone'           
    End Object

	Begin Object Class=AudioComponent Name=LightChannel
        SoundCue=none          
    End Object
	
	StrafeModify=0.75f
	bCanDodge=false
	bUseIdleForTopHalf=true
	AlternativeMode=class'MWWeapon_StaffMelee'
	bAlternativeFireStopped=false
	bHasFired=false
	bIgnoreShieldReplacement=true
	bIsReadyToSwitch = false
	bCanPickupStickies = true

	WeaponProjectiles(0)=class'MWProj_Void'
	
	
	//Void
	Spell[0]=(Damage=38,InitialSpeed=2500.0,MaxSpeed=6000,Radius=0,Charge=0.75,Force=25000.0,Cost=15,Gravity=5,Range=0,Scale=0.95,Drag=0.0,ProjClass=class'MWProj_Void',SFXChargeMin=SoundCue'MWCONTENT_SFX.Void_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Void_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Void_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Void_Shot')
	Spell2[0]=(Damage=17,InitialSpeed=5000.0,MaxSpeed=6000,Radius=210,Charge=2.0,Force=0,Cost=35,Gravity=0,Range=0,Scale=0.9,Drag=0.0,ProjClass=class'MWProj_VoidCloud',SFXChargeMin=SoundCue'MWCONTENT_SFX.Void_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Void_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Void_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Void_Shot')
		
	//Flame
	Spell[1]=(Damage=40,InitialSpeed=2200.0,MaxSpeed=6000.0,Radius=0,Charge=1.0,Force=15000.0,Cost=15,Gravity=-1.8,Range=0,Scale=1.75,Drag=0.0,ProjClass=class'MWProj_Flame',SFXChargeMin=SoundCue'MWCONTENT_SFX.Fire_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Fire_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Fire_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Fire_Shot')
	Spell2[1]=(Damage=40,InitialSpeed=1700.0,MaxSpeed=6000.0,Radius=190,Charge=2.25,Force=35000.0,Cost=30,Gravity=1,Range=0,Scale=5,Drag=0.0,ProjClass=class'MWProj_FireBomb',SFXChargeMin=SoundCue'MWCONTENT_SFX.Fire_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Fire_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Fire_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Fire_Shot')
	
	//Earth
	Spell[2]=(Damage=35,InitialSpeed=2000.0,MaxSpeed=2000.0,Radius=110,Charge=1.75,Force=55000.0,Cost=25,Gravity=0,Range=0,Scale=1,Drag=0.0,ProjClass=class'MWProj_Earth',SFXChargeMin=SoundCue'MWCONTENT_SFX.Rock_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Rock_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Rock_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Rock_Shot')
	Spell2[2]=(Damage=8,InitialSpeed=2000.0,MaxSpeed=2000.0,Radius=0,Charge=2.5,Force=32000,Cost=30,Gravity=15,Range=0,Scale=1,Drag=0.0,ProjClass=class'MWProj_Earthquake',SFXChargeMin=SoundCue'MWCONTENT_SFX.Rock_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Rock_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Rock_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Rock_Shot')
	
	//Water	
	Spell[3]=(Damage=-2,InitialSpeed=2000.0,MaxSpeed=10000.0,Radius=2,Charge=1.5,Force=0,Cost=20,Gravity=0,Range=0,Scale=1,Drag=0.0,ProjClass=class'MWProj_Water',SFXChargeMin=SoundCue'MWCONTENT_SFX.Water_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Water_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Water_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Water_Shot')
	Spell2[3]=(Damage=1,InitialSpeed=2000.0,MaxSpeed=10000.0,Radius=85,Charge=1.5,Force=72000.0,Cost=20,Gravity=12,Range=0,Scale=2,Drag=0.0,ProjClass=class'MWProj_TidalWave',SFXChargeMin=SoundCue'MWCONTENT_SFX.Water_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Water_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Water_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Water_Shot')
	
	//Electric	
	Spell[4]=(Damage=45,InitialSpeed=5000.0,MaxSpeed=20000.0,Radius=0,Charge=1.75,Cost=20,Force=0,Gravity=0,Range=0,Scale=1,Drag=0.0,ProjClass=class'MWProj_Electric',SFXChargeMin=SoundCue'MWCONTENT_SFX.Light_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Light_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Light_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Light_Shot')
	Spell2[4]=(Damage=65,InitialSpeed=2000.0,MaxSpeed=20000.0,Radius=80,Charge=3.0,Cost=35,Force=30000.0,Gravity=0,Range=0,Scale=1,Drag=0.0,ProjClass=class'MWProj_Pillar',SFXChargeMin=SoundCue'MWCONTENT_SFX.Light_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Light_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Light_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Light_Shot')

	iFeintStaminaCost=0
	//WeaponFontSymbol="z"
	WeaponReach=100
	WeaponLargePortrait="SWF.weapon_select_javelin"
	WeaponSmallPortrait="SWF.weapon_select_javelin"
	HorizontalRotateSpeed=75000.0
	VerticalRotateSpeed=75000.0
	AttackHorizRotateSpeed=75000.0
	SprintAttackHorizRotateSpeed=20000.0
	SprintAttackVerticalRotateSpeed=20000.0

	WindupAnimations(10)=(AnimationName=3p_javelin_throwwindup,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Void_SpellStart',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(11)=(AnimationName=3p_1hsharp_throwdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Void_SpellStart',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.8,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(20)=(AnimationName=3p_javelin_throwwindup,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Fire_SpellStart',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(21)=(AnimationName=3p_1hsharp_throwdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Fire_SpellStart',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.8,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(30)=(AnimationName=3p_javelin_throwwindup,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Rock_SpellStart',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(31)=(AnimationName=3p_1hsharp_throwdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Rock_SpellStart',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.8,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(40)=(AnimationName=3p_javelin_throwwindup,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Water_SpellStart',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(41)=(AnimationName=3p_1hsharp_throwdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Water_SpellStart',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.8,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(50)=(AnimationName=3p_javelin_throwwindup,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Light_SpellStart',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(51)=(AnimationName=3p_1hsharp_throwdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Light_SpellStart',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.8,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)

	ReleaseAnimations(10)=(AnimationName=3p_javelin_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Void_Shot',bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(11)=(AnimationName=3p_1hsharp_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Void_Shot',bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(20)=(AnimationName=3p_javelin_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Fire_Shot',bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(21)=(AnimationName=3p_1hsharp_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Fire_Shot',bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(30)=(AnimationName=3p_javelin_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Rock_Shot',bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(31)=(AnimationName=3p_1hsharp_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Rock_Shot',bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(40)=(AnimationName=3p_javelin_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Water_Shot',bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(41)=(AnimationName=3p_1hsharp_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Water_Shot',bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(50)=(AnimationName=3p_javelin_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Light_Shot',bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(51)=(AnimationName=3p_1hsharp_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Light_Shot',bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)

	RecoveryAnimations(10)=(AnimationName=3p_javelin_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(11)=(AnimationName=3p_1hsharp_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(20)=(AnimationName=3p_javelin_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(21)=(AnimationName=3p_1hsharp_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(30)=(AnimationName=3p_javelin_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(31)=(AnimationName=3p_1hsharp_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(40)=(AnimationName=3p_javelin_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(41)=(AnimationName=3p_1hsharp_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(50)=(AnimationName=3p_javelin_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(51)=(AnimationName=3p_1hsharp_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)

	ReloadAnimations[10]=(AnimationName=3p_javelin_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[11]=(AnimationName=3p_1hsharp_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[20]=(AnimationName=3p_javelin_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[21]=(AnimationName=3p_1hsharp_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[30]=(AnimationName=3p_javelin_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[31]=(AnimationName=3p_1hsharp_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[40]=(AnimationName=3p_javelin_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[41]=(AnimationName=3p_1hsharp_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[50]=(AnimationName=3p_javelin_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[51]=(AnimationName=3p_1hsharp_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)

	HoldAnimations[10]=(AnimationName=3p_javelin_throwwindupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	HoldAnimations[11]=(AnimationName=3p_1hsharp_throwupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	HoldAnimations[20]=(AnimationName=3p_javelin_throwwindupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	HoldAnimations[21]=(AnimationName=3p_1hsharp_throwupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	HoldAnimations[30]=(AnimationName=3p_javelin_throwwindupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	HoldAnimations[31]=(AnimationName=3p_1hsharp_throwupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	HoldAnimations[40]=(AnimationName=3p_javelin_throwwindupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	HoldAnimations[41]=(AnimationName=3p_1hsharp_throwupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	HoldAnimations[50]=(AnimationName=3p_javelin_throwwindupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	HoldAnimations[51]=(AnimationName=3p_1hsharp_throwupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)


	BattleCryAnim=(AnimationName=3p_javelin_battlecry,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	WindupAnimations(0)=(AnimationName=3p_javelin_throwwindup,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(1)=(AnimationName=3p_javelin_throwwindup,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	WindupAnimations(2)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.Jav_Reload',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=0.7,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(3)=(AnimationName=3p_javelin_sprintthrowstart,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Footsteps.Archer_Dirt_Jump',bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(4)=(AnimationName=3p_javelin_parryib,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.warhammer_Parry',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.125,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(5)=(AnimationName=3p_javelin_shovestart,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.warhammer_windup',bFullBody=True,bCombo=False,bLoop=False,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(0)=(AnimationName=3p_javelin_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=,bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(1)=(AnimationName=3p_javelin_throwrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=none,bFullBody=false,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.25,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReleaseAnimations(2)=(AnimationName=3p_javelin_stabrelease,ComboAnimation=3p_1hsharp_stabrelease,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_Attack_03',bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(3)=(AnimationName=3p_javelin_sprintthrowrelease,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_sprint_attack',bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(4)=(AnimationName=3p_javelin_parryup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_Parry',bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(5)=(AnimationName=3p_javelin_shoverelease_new,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false,bUseRMM=true)
	ReleaseAnimations(6)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(7)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(8)=(AnimationName=3p_javelin_equipup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_draw',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.01,bLastAnimation=false)
	ReleaseAnimations(9)=(AnimationName=3p_javelin_equipdown,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_sheath',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.00,fBlendOutTime=0.01,bLastAnimation=false)
	RecoveryAnimations(0)=(AnimationName=3p_javelin_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(1)=(AnimationName=3p_javelin_throwrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(2)=(AnimationName=3p_javelin_stabrecover,ComboAnimation=3p_1hsharp_stabrecover,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(3)=(AnimationName=3p_javelin_sprintthrowrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(4)=(AnimationName=3p_javelin_parryrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(5)=(AnimationName=3p_javelin_shoverecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.10,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(6)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(7)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(8)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(9)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	ReloadAnimations[0]=(AnimationName=3p_javelin_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[1]=(AnimationName=3p_javelin_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=2)
	ReloadAnimations[2]=(AnimationName=3p_javelin_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=1)
	ReloadAnimations[3]=(AnimationName=3p_javelin_throwreload,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.60,fBlendInTime=0.0,fBlendOutTime=0.1,bLastAnimation=false,bAttachArrow=1)
	HoldAnimations[0]=(AnimationName=3p_javelin_throwwindupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	HoldAnimations[1]=(AnimationName=3p_javelin_throwwindupidle,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.75,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	StateAnimations(0)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.00,fBlendInTime=0.00,fBlendOutTime=0.08,bLastAnimation=true)
	StateAnimations(1)=(AnimationName=3p_javelin_dazed,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	StateAnimations(2)=(AnimationName=3p_javelin_dazed,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.9,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	StateAnimations(3)=(AnimationName=3p_javelin_hitFR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.9,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	StateAnimations(4)=(AnimationName=3p_javelin_hitBL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.08,bLastAnimation=false)
	TurnInfo(0)=(AnimationName=3p_javelin_turnL,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=true,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=false,bLowerBody=true)
	TurnInfo(1)=(AnimationName=3p_javelin_turnR,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=true,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=false)
	
	SwapToAnimation=(AnimationName=3p_javelin_stabtothrow,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.40,fBlendInTime=0.10,fBlendOutTime=0.01,bLastAnimation=false)
	AltSwapToAnimation=(AnimationName=3p_1hsharp_throwdowntoup,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.1,fBlendInTime=0.10,fBlendOutTime=0.01,bLastAnimation=false)
	
	DazedAnimations(0)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(1)=(AnimationName=3p_javelin_dazedR01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(2)=(AnimationName=3p_javelin_dazedF01,AlternateAnimation=3p_javelin_parrydazed,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(3)=(AnimationName=3p_javelin_dazedL01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(4)=(AnimationName=3p_javelin_dazedBL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(5)=(AnimationName=3p_javelin_dazedBR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(6)=(AnimationName=3p_javelin_dazedFL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(7)=(AnimationName=3p_javelin_dazedFR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DirHitAnimation(0)=(AnimationName=ADD_3p_javelin_hitFL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	DirHitAnimation(1)=(AnimationName=ADD_3p_javelin_hitFR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	DirHitAnimation(2)=(AnimationName=ADD_3p_javelin_hitBL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	DirHitAnimation(3)=(AnimationName=ADD_3p_javelin_hitBR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	DirParryHitAnimations(0)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	DirParryHitAnimations(1)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	DirParryHitAnimations(2)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	DirParryHitAnimations(3)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	// Range Weapon ConfigProjectileBaseDamage Info
	// 0 - Bodkin
	// 1 - Broadhead
	// 2 - Fire
	// 3 - Steel
	// 4 - Javelin
	// 5 - Default
	// NOTE: Javelin sprint damage bonus found in DefaultWeapon.ini
	// The ones that aren't used shouldn't need to be set but I do it just to be safe.

	//Backup
	ConfigProjectileBaseDamage[0]=(Damage=38,InitialSpeed=2200.0,MaxSpeed=6000.0,AmmoCount=99,InitialGravityScale=5,Drag=0.0,PitchCorrection=0.0)
	ConfigProjectileBaseDamage[1]=(Damage=40,InitialSpeed=2200.0,MaxSpeed=6000.0,AmmoCount=99,InitialGravityScale=-1.8,Drag=0.0,PitchCorrection=0.0)
	ConfigProjectileBaseDamage[2]=(Damage=35,InitialSpeed=10000.0,MaxSpeed=6000.0,AmmoCount=99,InitialGravityScale=0,Drag=0.0,PitchCorrection=0.0)
	ConfigProjectileBaseDamage[3]=(Damage=-1.5,InitialSpeed=5000.0,MaxSpeed=10000.0,AmmoCount=99,InitialGravityScale=0,Drag=0.0,PitchCorrection=0.0)
	ConfigProjectileBaseDamage[4]=(Damage=50,InitialSpeed=5000.0,MaxSpeed=20000.0,AmmoCount=99,InitialGravityScale=0,Drag=0.0,PitchCorrection=0.0)
	ConfigProjectileBaseDamage[5]=(Damage=51,InitialSpeed=2000.0,MaxSpeed=6000.0,AmmoCount=20,InitialGravityScale=3,Drag=0.00000000003,PitchCorrection=0.0)
	//ConfigProjectileBaseDamage[1]=(Damage=0,InitialSpeed=0,MaxSpeed=0,AmmoCount=0,InitialGravityScale=0,Drag=0,PitchCorrection=0.0)
}

//Old Comments
//LogAlwaysInternal(AOCOwner.PawnInfo.bAltSpell @ "****************************");
//LogAlwaysInternal(AOCMeleeWeapon(MWWeapon_StaffMelee).bAltSpell);
//LogAlwaysInternal(class<AOCWeapon>(AOCOwner.PawnInfo.myPrimary).default.bAltSpell@"8888888888888888888888");
//LogAlwaysInternal(AOCOwner.PawnInfo.myPrimary.default.bAltSpell@"8888888888888888888888");
//LogAlwaysInternal(AOCOwner.class'MWWeapon_StaffMelee'.default.bAltSpell);

//LogAlwaysInternal(AOCOwner.PawnInfo.myPrimary@"8888888888888888888888");
//LogAlwaysInternal(StaffMelee@"8888888888888888888888");
//StaffMelee = AlternativeMode;
//LogAlwaysInternal(StaffMelee.bAltSpell@"00000000");
//LogAlwaysInternal(AOCPawn(Owner).PrimaryWeapon.bAltSpell@"00000000");
//LogAlwaysInternal(MWWeapon_StaffMelee(AOCPawn(Owner).Weapon)@"00000000");
//LogAlwaysInternal(AlternativeMode(AOCPawn(Owner).Weapon)@"00000000");
//LogAlwaysInternal(MWWeapon_StaffMelee(AlternativeModeInstance).bAltSpell);

	/*if(ProjClass == class'MWProj_Earth1')
		{
			//StartTrace = InstantFireStartTrace();
			LogAlwaysInternal("Earth StaffSpell");
			StartTrace = RealStartLoc;
			EndTrace = InstantFireEndTrace(StartTrace);
			
			Trace(HitLocation,HitNormal,EndTrace,StartTrace,false);
			Rot = rotator(HitNormal);
			SpawnProjectile( HitLocation,Rot.Pitch,Rot.Yaw,Rot.Roll);
			//Trace(HitLocation2,HitNormal,HitLocation - vect(0,0,500),HitLocation + vect(0,0,500),false);
			//Spawn(class'MWSpell_LightPillar',,,HitLocation2);
			//ConfigProjectileBaseDamage[Type].Damage = 67;
			
		}
		*/