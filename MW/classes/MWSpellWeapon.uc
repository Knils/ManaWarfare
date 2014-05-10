class MWSpellWeapon extends AOCRangeWeapon;

var bool bUseAlternateSide;

var bool bWantToFire;       // variable used in the wind-up phase to send user to release if he releases the mouse click

/** Attack queuing */
var EAttack AttackQueue;

var bool bTestThrowable; // Examining Mantis Bug 0000697 (CU1)

var int SetCurrentFireMode;

/** This struct will contain the possible sound cues for impact sounds */
struct HitMaterialImpactSounds
{
	var SoundCue Light;
	var SoundCue Medium;
	var SoundCue Heavy;
	var SoundCue Stone;
	var SoundCue Dirt;
	var SoundCue Gravel;
	var SoundCue Foliage;
	var SoundCue Sand;
	var SoundCue Water;
	var SoundCue ShallowWater;
	var SoundCue Metal;
	var SoundCue Snow;
	var SoundCue Wood;
	var SoundCue Ice;
	var SoundCue Mud;
	var SoundCue Tile;
};

var array< HitMaterialImpactSounds > ImpactSounds;

/** Conumse Ammo
 *  Only consume when we fire weapon.
 */
function ConsumeAmmo( byte FireModeNum )
{
	// Subtract the Ammo
	if (CurrentFireMode == SetCurrentFireMode)
		super.ConsumeAmmo(FireModeNum);
}

/**
 * Network: Server Only
 * Change from AOCRangeWeapon since weapon will be behind the player. 
 */
/*
simulated function Fire()
{
	local rotator Aim, rot;
   	local Vector RealStartLoc, AimOffset, x, y, z;

	if (bLoaded && self.Class != class'AOCWeapon_Javelin')
	{
		// get other pawn's forward axis
		rot = AOCPawn(Owner).GetViewRotation(); 
		AOCPawn(Owner).GetAxes(rot, x, y, z);
		x = Normal(x);
		// this is the location where the projectile is spawned
		RealStartLoc = AOCPawn(Owner).GetPawnViewLocation() + 50.0f * x;
		AimOffset = RealStartLoc - AOCPawn(Owner).GetPawnViewLocation();
		Aim = Rotator(AimOffset);
		SpawnProjectile( RealStartLoc, Aim );
		//Aim = GetAdjustedAim( RealStartLoc );			// get fire aim direction
	}
	else if (bLoaded)
		super.Fire();
} */


simulated function SpawnProjectile( Vector RealStartLoc, float Pitch, float Yaw, float Roll )
{
	local Rotator Aim;
	local EProjType Type;
	
	if(Worldinfo.TimeSeconds - fLastProjectileSpawnTime < fReasonableRefireRate)
	{
		//LogAlwaysInternal("Rejected SpawnProjectile from"@AOCOWner.PlayerReplicationInfo.PlayerName@"because"@(Worldinfo.TimeSeconds - fLastProjectileSpawnTime)@"is faster than"@fReasonableRefireRate);
		return;
	}
	else
	{
		//LogAlwaysInternal("Allowed SpawnProjectile from"@AOCOWner.PlayerReplicationInfo.PlayerName@"because"@(Worldinfo.TimeSeconds - fLastProjectileSpawnTime)@"is slower than"@fReasonableRefireRate);
	}	
	fLastProjectileSpawnTime = Worldinfo.TimeSeconds;
	
	Type = GetProjectileType();
	Aim.Pitch = Pitch + ConfigProjectileBaseDamage[Type].PitchCorrection;;
	Aim.Yaw = Yaw;
	Aim.Roll = Roll;
	SpawnedProjectile = Spawn(GetProjectileClass(),self,, RealStartLoc, Aim);
	
	//LogAlwaysInternal("Spawned"@SpawnedProjectile@"for"@self);
	
	if (AOCPlayerController(AOCOwner.Controller) != none)
	{
		AOCProjectile(SpawnedProjectile).ProjIdent = ++AOCPlayerController(AOCOwner.Controller).ProjectileNumber;
		AOCPlayerController(AOCOwner.Controller).SpawnedProjectile.AddItem(AOCProjectile(SpawnedProjectile));
	}
	if ( SpawnedProjectile != None )
	{
		// Give the projectiles properties based on weapon
		AOCProjectile(SpawnedProjectile).Damage = ConfigProjectileBaseDamage[Type].Damage;
		AOCProjectile(SpawnedProjectile).Speed = ConfigProjectileBaseDamage[Type].InitialSpeed;
		AOCProjectile(SpawnedProjectile).MaxSpeed = ConfigProjectileBaseDamage[Type].MaxSpeed;
		AOCProjectile(SpawnedProjectile).TerminalVelocity = ConfigProjectileBaseDamage[Type].MaxSpeed;
		AOCProjectile(SpawnedProjectile).CustomGravityScaling = ConfigProjectileBaseDamage[Type].InitialGravityScale;
		AOCProjectile(SpawnedProjectile).Drag = ConfigProjectileBaseDamage[Type].Drag;
		
		if (AOCOwner.bIsBot) //TEMP: Bots can't handle drag at the moment, so, uh, turn it off
			AOCProjectile(SpawnedProjectile).Drag = 0;

		AOCProjectile(SpawnedProjectile).LaunchingWeapon = self.Class;
		AOCProjectile(SpawnedProjectile).OwnerPawn = AOCOwner;
		AOCProjectile(SpawnedProjectile).CurrentAssociatedWeapon = 2;
		AOCProjectile(SpawnedProjectile).AOCInit(Aim);

		if (AOCPlayerController(AOCOwner.Controller) != none)
			AOCProjectile(SpawnedProjectile).ThisController = AOCPlayerController(AOCOwner.Controller);
	}
}

/** Flinch state
 *  Return user back to reload if previous state was reload.
 */
simulated state Flinch
{
	simulated event BeginState(Name PreviousStateName)
	{		
		super.BeginState(PreviousStateName);

		if (PreviousStateName == 'Release')
			FlinchReturnState = 'NullState';
	}
}


/** Default Active/Idle state.
 */ 
simulated state Active
{
	/** Initialize the weapon as being active and ready to go. */
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);

		if (AmmoCount > 0)
		{
			bLoaded = true;
		}

		if (AttackQueue != Attack_Null)
		{
			CurrentFireMode = AttackQueue;
			BeginFire(AttackQueue);
			AttackQueue = Attack_Null;
		}
		else
			bWantToFire = false;
	}
}

simulated function SwitchWeaponNoAmmo()
{
	AOCOwner.SwitchWeapon(1);
	if(!AOCOwner.bSwitchingWeapons)
	{
		AOCOwner.SwitchWeapon(2);
	}
}


simulated state WeaponEquipping
{
	/** Modify for HUD info */
	simulated function BeginState(name PreviousStateName)
	{
		if (AOCOwner == none)
			CacheWeaponReferences();
			
		//LogAlwaysInternal("START EQUIP");
		bWeaponPutDown	= false;
		PlayStateAnimation();

		AttackQueue = Attack_Null;
		
		// attach weapon
		AttachWeaponTo( Instigator.Mesh );

		// change weapon attachments
		AOCOwner.bUseIdleForTopHalf = bUseIdleForTopHalf;
		
		if (ForwardModify != -1.0f)
			AOCOwner.FORWARD_MODIFY = ForwardModify;

		if (StrafeModify != -1.0f)
			AOCOwner.STRAFE_MODIFY = StrafeModify;

		if (BackModify != -1.0f)
			AOCOwner.BACK_MODIFY = BackModify;
			
		if (CrouchModify != -1.0f)
			AOCOwner.CROUCH_MODIFY = CrouchModify;


		// reset FOV
		AOCOwner.ResetFOV();

		if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE)
		{
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).TurnOffCrosshair();
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).TurnOnRangeCrosshair();
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).ShowAmmoCount(true);
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).UpdateAmmoCount(AmmoCount, MaxAmmoCount);
		}
	}

	simulated function BeginFire(byte FireModeNum)
	{
	}
}

// We can skip putting down weapon if we have no ammo
simulated state WeaponPuttingDown
{
	simulated event BeginState(Name PreviousStateName)
	{
		if (AmmoCount == 0)
		{
			// Turn off ammo count and crosshair manually
			if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE)
			{
				AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).TurnOffCrosshair();
				AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).ShowAmmoCount(false);
			}
			WeaponIsDown();
		}
		else
			super.BeginState(PreviousStateName);
	}

	simulated function BeginFire(byte FireModeNum)
	{
	}
}


/** Windup state. Getting ready to fire.
 *  Go into hold if necessary.
 */
simulated state Windup
{
	/** When finished with windup go to the next state */
	simulated function OnStateAnimationEnd()
	{
		if (CurrentFireMode == SetCurrentFireMode && !bWantToFire)
			GotoState('Hold');
		else
		{
			//LogAlwaysInternal("GO TO RELEASE");
			bWantToFire = false;
			GotoState('Release');
		}
	}


	/** The user released the mouse button and we should fire */
	simulated function EndFire(byte FireModeNum)
	{
		global.EndFire(FireModeNum);

		// release
		if ( CurrentFireMode == SetCurrentFireMode)
		{
			//LogAlwaysInternal("WANT TO END FIRE");
			bWantToFire = true;
		}
	}

	simulated function BeginState(name PreviousStateName)
	{
		if (AOCOwner == none)
			CacheWeaponReferences();
		super.BeginState(PreviousStateName);
	}
}

/** Release state. Fire the projectile.
 */
simulated state Release
{
	/** Play appropriate attack animation */
	simulated event BeginState(Name PreviousStateName)
	{
		local HitInfo Inf;
		if (AOCOwner == none)
			CacheWeaponReferences();
		CurrentAnimations = ReleaseAnimations;
		// no longer need to update abilities...should carry over from windup
		PlayStateAnimation();
		ReleaseProjectileTime = WorldInfo.TimeSeconds;

		AOCPRI(AOCOwner.PlayerReplicationInfo).NumAttacks += 1;

		if (Role == ROLE_Authority)
			AOCOwner.PauseHealthRegeneration();

		if (bTestThrowable)
		{
				// Immediately try to break it by "getting hit"
			Inf.AttackType = Attack_Slash;
			Inf.bBreakAllBones = false;
			Inf.BoneName = 'b_head';
			Inf.bParry = false;
			Inf.DamageString = "S";
			Inf.DamageType = class'AOCDmgType_Swing';
			Inf.HitActor = AOCOWner;
			Inf.HitCombo = 1;
			Inf.HitComp = Mesh;
			Inf.HitDamage = 10.f;
			Inf.HitForce = Normal(Vector(Rotation)) * 2000.f;
			Inf.HitLocation =  Location;
			Inf.HitNormal = Vect(0.f, 0.f, 0.f);
			Inf.Instigator = AOCOwner;
			Inf.PRI = AOCOwner.PlayerReplicationInfo;
			Inf.UsedWeapon = 0;

			AOCOWner.AttackOtherPawn(Inf, "S");

			bTestThrowable = false;
		}
		
	}

	simulated event EndState(Name NextStateName)
	{
		super.EndState(NextStateName);
		if (CurrentFireMode == SetCurrentFireMode)
		{
			if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE)
			{
				//LogAlwaysInternal("FIRE");
				Fire();
			}
			ConsumeAmmo(0); // consume ammo for 0'th fire type - only one type of range firing
			// after consuming ammo, we are not loaded anymore
			bLoaded = false;
			AOCWepAttachment.DetachArrow();

			if (AmmoCount == 0)
				SwitchWeaponNoAmmo();
		}
	}
	
}

/** Recovery state. User coming back to active/idle after firing weapon.
 */
simulated state Recovery
{

	/** Skip state and go straight to reload */
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		AOCWepAttachment.GotoState('');
	}

	/** If we decide to do an attack during the windup animation, take note of it and handle during release state */
	simulated function BeginFire(byte FireModeNum)
	{
		if (EAttack(FireModeNum) == SetCurrentFireMode || EAttack(FireModeNum) == Attack_Overhead)
		{
			AttackQueue = EAttack(FireModeNum);
		}
	}

	/** The user released the mouse button and we should fire */
	simulated function EndFire(byte FireModeNum)
	{
		if (FireModeNum == Attack_Overhead)
			return;
		else
			bWantToFire = true;
	}
}

/** After holding for 1.5 seconds, transit to 
 */
simulated state Hold
{
	/** Cancel Fire.
	 */
	simulated function BeginFire(byte FireModeNum)
	{
		if (FireModeNum == Attack_Shove)
			AOCOwner.PlaySound(AOCOwner.GenericCantDoSound, true);
		else if (FireModeNum == Attack_Parry)
			GotoState('Recovery');
	}

}

auto state Inactive
{
	reliable server function ServerStartFire(byte FireModeNum)
	{
		if (AmmoCount != 0)
			super.ServerStartFire(FireModeNum);
	}

}

DefaultProperties
{
	FiringStatesArray(0)=Windup

	WeaponFireTypes(0)=EWFT_Custom
	WeaponFireTypes(1)=EWFT_Custom
	WeaponFireTypes(2)=EWFT_Custom

	ShotCost(0)=1

	bRetIdle=false;
	bRetIdleOriginal=false;
	//WeaponIdleAnim=''
	bPlayOnWeapon=false
	bWantToFire=false
	AttackQueue=Attack_Null
	bCanPickupStickies=true
}

