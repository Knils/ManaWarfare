class MWWeapon_StaffMelee extends AOCMeleeWeapon;

// Animation that plays when we change to the melee mode
var AnimationInfo SwapToAnimation;

// Melee Javelin is the only one that plays the original draw animation
var bool                bFinishedEquip; // Take note of that so we know whether to play original draw or mode transfer animation
var bool				bAllowedToSwitch; //Switch to the throwing mode?
var bool                bSwitchingWeapon;
var bool                bAltSpell;

var AudioComponent Shield_Loop;
//var ParticleSystemComponent ElementPSComp;

replication
{
	if ( bNetDirty)
		bAltSpell;
}

simulated function BeginFire(Byte FireModeNum)
{
	if(FireModeNum == Attack_Slash && !bUseAlternateSide && FireModeNum != Attack_AltSlash && !bPlayAlternateAnimation)
	{
		LogAlwaysInternal("SPELL");
		bAltSpell = false;
		bAllowedToSwitch = true;
		bSwitchingWeapon = true;
		AOCOwner.SwitchWeapon(1);	
		bSwitchingWeapon = false;
	}
	else if(FireModeNum == Attack_Slash && bUseAlternateSide || bPlayAlternateAnimation)
	{
		LogAlwaysInternal("ALT SPELL");
		bAltSpell = true;
		bAllowedToSwitch = true;
		bSwitchingWeapon = true;
		AOCOwner.SwitchWeapon(1);	
		bSwitchingWeapon = false;
	}
	else
	{
		//LogAlwaysInternal("BROKE SPELL");
		//AOCOwner.PlaySound(AOCOwner.GenericCantDoSound, true);
		LogAlwaysInternal(WindupAnimations[FireModeNum].AnimationName);
		super.BeginFire(FireModeNum);
		//GoToState('Active');
	}
}

simulated function EndFire(Byte FireModeNum)
{
	super.EndFire(FireModeNum);

	if (FireModeNum == Attack_Slash && AttackQueue == EAttack(Attack_Slash) && !bSwitchingWeapon)
	{
		// If the end fire occurs before switching to JavilinThrow, make sure it still fires
		MWWeapon_StaffSpell(AlternativeModeInstance).AlternativeFireStopped();
	}
}

simulated function bool TrySwitch()
{
	return bAllowedToSwitch;
}

auto state Inactive
{
	reliable server function ServerStartFire(byte FireModeNum)
	{
		if ( FireModeNum == 0 ) 
		{
			// Start javelin throw, remain in inactive state
			Global.ServerStartFire(FireModeNum);
			return;
		}
		super.ServerStartFire(FireModeNum);
	}
}

simulated state WeaponEquipping
{
	simulated event BeginState(Name PreviousStateName)
	{
		LogAlwaysInternal("EquipMelee");
		CacheWeaponReferences();
		//WeaponFontSymbol="5";

		bUseAlternateSide = MWWeapon_StaffSpell(AlternativeModeInstance).bUseAlternateSide;

		if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE)
		{
			///LogAlwaysInternal("HIDE RANGE CROSSHAIR");
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).TurnOffCrosshair();
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).TurnOnMeleeCrosshair();
			if(AlternativeModeInstance.MaxAmmoCount > 0)
			{
				AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).ShowAmmoCount(true);
				AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).UpdateAmmoCount(AlternativeModeInstance.AmmoCount, AlternativeModeInstance.MaxAmmoCount);
			}

		}
		super.BeginState(PreviousStateName);
		
		if (!AOCOwner.StateVariables.bShieldEquipped)
		{
			//AOCOwner.EquipShield(True);
			AOCOwner.EquipShield(False);
		}
			
		bAllowedToSwitch = false;
	}

	/** Play release animation */
	simulated function PlayStateAnimation()
	{
		///LogAlwaysInternal("PLAY WEAPON EQUIP ANIM"@bFinishedEquip);
		if (!bFinishedEquip)
		{
			super.PlayStateAnimation();
			bFinishedEquip = true;
		}
		else
		{
			//Skipping this, because the anims appear to skip it.
			///LogAlwaysInternal("PLAY JAVELINE MELEE SWAP TO ANIM"@SwapToAnimation.AnimationName);
			OnStateAnimationEnd();
			//AOCOwner.PlayPawnAnimation(SwapToAnimation);
		}
	}
}

/** Equip state - Not allowed to
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

simulated state Release
{
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		if (CurrentFireMode == Attack_Overhead)
			AOCWepAttachment.bUseAlternativeTracers = true;
	}
}

simulated state Recovery
{
	simulated function int GetReleaseToParryAnimation(bool bWasCombo)
	{
		return -1;
	}
}

simulated state Active
{
	/** Initialize the weapon as being active and ready to go. */
	simulated event BeginState(Name PreviousStateName)
	{
		///LogAlwaysInternal("%%%%%%% BEGIN ACTIVE STATE"@PreviousStateName);
		
		super.BeginState(PreviousStateName);
		
		if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE)
		{
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).TurnOffCrosshair();
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).TurnOnMeleeCrosshair();
		}

		if (!AOCOwner.StateVariables.bShieldEquipped)
		{
			AOCOwner.EquipShield(false);
			//AOCOwner.EquipShield(true);
		}

	}

	simulated event EndState(Name PreviousStateName)
	{
		super.EndState(PreviousStateName);
	}
}

/** Weapon Putting Down Has No Animation for Javelin - Handled in Weapon Equip */
simulated state WeaponPuttingDown
{
	/** Play appropriate attack animation */
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		
		if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE)
		{
			AOCBaseHUD(AOCPlayerController(AOCOwner.Controller).myHUD).ShowAmmoCount(false);
		}
		
		WeaponIsDown();
	}

	/** Play release animation */
	simulated function PlayStateAnimation()
	{
		CacheWeaponReferences();
	}
}

/*
simulated state Parry
{
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
	}
	simulated event EndState(Name PreviousStateName)
	{
		
		super.EndState(PreviousStateName);
	}
}

simulated state ParryRelease
{
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		if (AOCOwner.StateVariables.bIsParrying)
		{
			///LogAlwaysInternal("Blocking");
			foreach AllActors(class'MWPlayerController', MWPLC)
				break;
			MWPLC.ShowMyParryBox(false);
			//PlaySound(SoundCue'MWCONTENT_SFX.Shield_Up',false, true, true);
			Shield_Loop.Play();
		}
		if (!AOCOwner.StateVariables.bIsParrying)
		{
			///LogAlwaysInternal("UnBlocking");
			foreach AllActors(class'MWPlayerController', MWPLC)
				break;
			MWPLC.ShowMyParryBox(true);
			//PlaySound(SoundCue'MWCONTENT_SFX.Shield_Down',false, true, true);
			Shield_Loop.Stop();
		}
	}

	simulated function OnStateAnimationEnd()
	{
      //`log("PARRY RELEASE ATTACK ANIM END"@bParryHitCounter@bSuccessfulParry);
		if (bSuccessfulParry)
			GotoState('Active');
		else 
			GotoState('Recovery');	
	}

	simulated event EndState(Name PreviousStateName)
	{
		super.EndState(PreviousStateName);
		if (AOCOwner.StateVariables.bIsParrying)
		{
			///LogAlwaysInternal("Blocking");
			foreach AllActors(class'MWPlayerController', MWPLC)
				break;
			MWPLC.ShowMyParryBox(false);
			//PlaySound(SoundCue'MWCONTENT_SFX.Shield_Up',false, true, true);
			Shield_Loop.Play();
		}
		if (!AOCOwner.StateVariables.bIsParrying)
		{
			///LogAlwaysInternal("UnBlocking");
			foreach AllActors(class'MWPlayerController', MWPLC)
				break;
			MWPLC.ShowMyParryBox(true);
			//PlaySound(SoundCue'MWCONTENT_SFX.Shield_Down',false, true, true);
			Shield_Loop.Stop();
		}
	}
}

simulated state ShieldUpIdle
{
	simulated event BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		bAllowAttackOutOfShield = true;
		AttackQueue = Attack_Null;

		MWPawn(AOCOwner).SetManaShield(false);
		/*
		foreach AllActors(class'MWPlayerController', MWPLC)
			break;
		MWPLC.ShowMyParryBox(false);
		*/
		//PlaySound(SoundCue'MWCONTENT_SFX.Shield_Up',false, true, true);
		//Shield_Loop.Play();		
	}
	
	simulated function bool CanSwitch()
	{
		return false;	
	}

	simulated function SuccessfulParry(EAttack Type, int Dir)
	{
		AOCOwner.OnActionSucceeded(EACT_Block);
		bAllowAttackOutOfShield = false;
		super.SuccessfulParry(Type, Dir);
	}

	simulated function FinishShieldHitAnimation()
	{
		bAllowAttackOutOfShield = true;

		if (AttackQueue != Attack_Null)
		{
			bAttackFromShieldUp = true;
			GotoState('Active');
		}
	}

	simulated function BeginFire(byte FireModeNum)
	{
		if (bAllowAttackOutOfShield)
		{
			if(default.bAllowAttackOutOfShield || FireModeNum == Attack_Shove)
			{
				super.BeginFire(FireModeNum);
				AttackQueue = EAttack(FireModeNum);
				bAttackFromShieldUp = true;
				GotoState('Active');
			}
			else
			{
				AttackQueue = EAttack(FireModeNum);
				LowerShield();
			}
		}
	}
	simulated event EndState(Name PreviousStateName)
	{
		super.EndState(PreviousStateName);

		MWPawn(AOCOwner).SetManaShield(true);
		/*
		foreach AllActors(class'MWPlayerController', MWPLC)
			break;
		MWPLC.ShowMyParryBox(true);
		*/
		//Shield_Loop.Stop();		
	}
}
*/
DefaultProperties
{
	Begin Object Class=AudioComponent Name=Shield_Loop
        SoundCue=SoundCue'MWCONTENT_SFX.Shield_Loop'               
    End Object
	Shield_Loop = Shield_Loop;

	//set maximum ammo
	//AIRange=5000
	bCanCombo=false

	bUseDirParryHitAnims=true

	AttachmentClass=class'MWWeaponAttachment_StaffMelee'
	// should never be part of inventory attachment
	InventoryAttachmentClass=class'MWInventoryAttachment_StaffMelee'
	//PermanentAttachmentClass(0)=class'AOCInventoryAttachment_JavelinQuiver'
	//PermanentAttachmentClass(1)=class'AOCInventoryAttachment_JavelinQuiver'
	PermanentAttachmentClass(0)=class'MWInventoryAttachment_StaffMelee'
	PermanentAttachmentClass(1)=class'MWInventoryAttachment_StaffMelee'
	//AllowedShieldClass=class'AOCShield_Buckler'
	AllowedShieldClass=class'MWShield_Mana'
	bHaveShield=true
	
	CurrentWeaponType = EWEP_Javelin
	CurrentGenWeaponType=EWT_Javelin
	//WeaponIdleAnim=''	
	//bRetIdle = false
	//bRetIdleOriginal=false
	bPlayOnWeapon=false
	bEquipShield=false
	bCanParry=true
	bCanSwitchShield=false
	WeaponIdentifier="javelin"
	
	//WeaponIdentifier="1hsharp"

	/*
	ImpactSounds(ESWINGSOUND_Slash)={(
		light=SoundCue'A_Impacts_Melee.Light_Blunt_Average',
		medium=SoundCue'A_Impacts_Melee.Medium_Blunt_Average',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Blunt_Average',
		wood=SoundCue'A_Phys_Mat_Impacts.torch_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.torch_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.torch_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.torch_Stone')}
		*/
	ImpactSounds(ESWINGSOUND_Slash)={(
		light=SoundCue'MWCONTENT_SFX.Mana_Hit_Lite',
		medium=SoundCue'MWCONTENT_SFX.Mana_Hit_Med',
		heavy=SoundCue'MWCONTENT_SFX.Mana_Hit_Hevy',
		wood=SoundCue'A_Phys_Mat_Impacts.Claymore_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Claymore_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Claymore_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Claymore_Stone')}

	ImpactSounds(ESWINGSOUND_SlashCombo)={(
		light=SoundCue'A_Impacts_Melee.Light_Blunt_Average',
		medium=SoundCue'A_Impacts_Melee.Medium_Blunt_Average',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Blunt_Average',
		wood=SoundCue'A_Phys_Mat_Impacts.torch_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.torch_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.torch_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.torch_Stone')}

	ImpactSounds(ESWINGSOUND_Stab)={(
		light=SoundCue'A_Impacts_Melee.Light_Blunt_Small',
		medium=SoundCue'A_Impacts_Melee.Medium_Blunt_Small',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Blunt_Small',
		wood=SoundCue'A_Phys_Mat_Impacts.torch_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.torch_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.torch_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.torch_Stone')}

	ImpactSounds(ESWINGSOUND_StabCombo)={(
		light=SoundCue'A_Impacts_Melee.Light_Blunt_Small',
		medium=SoundCue'A_Impacts_Melee.Medium_Blunt_Small',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Blunt_Small',
		wood=SoundCue'A_Phys_Mat_Impacts.torch_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.torch_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.torch_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.torch_Stone')}


	ImpactSounds(ESWINGSOUND_Overhead)={(
		light=SoundCue'A_Impacts_Melee.Light_Blunt_Large',
		medium=SoundCue'A_Impacts_Melee.Medium_Blunt_Large',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Blunt_Large',
		wood=SoundCue'A_Phys_Mat_Impacts.torch_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.torch_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.torch_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.torch_Stone')}

	ImpactSounds(ESWINGSOUND_OverheadCombo)={(
		light=SoundCue'A_Impacts_Melee.Light_Blunt_Average',
		medium=SoundCue'A_Impacts_Melee.Medium_Blunt_Average',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Blunt_Average',
		wood=SoundCue'A_Phys_Mat_Impacts.torch_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.torch_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.torch_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.torch_Stone')}

	ImpactSounds(ESWINGSOUND_Sprint)={(
		light=SoundCue'A_Impacts_Melee.Light_Blunt_Large',
		medium=SoundCue'A_Impacts_Melee.Medium_Blunt_Large',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Blunt_Large',
		wood=SoundCue'A_Phys_Mat_Impacts.torch_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.torch_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.torch_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.torch_Stone')}

	ImpactSounds(ESWINGSOUND_Shove)={(
		light=SoundCue'A_Impacts_Melee.Light_Kick_Small',
		medium=SoundCue'A_Impacts_Melee.Medium_Kick_Small',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Kick_Small',
		wood=SoundCue'A_Phys_Mat_Impacts.Kick_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Kick_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Kick_Metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Kick_Stone')}

	ImpactSounds(ESWINGSOUND_ShoveCombo)={(
		light=SoundCue'A_Impacts_Melee.Light_Kick_Small',
		medium=SoundCue'A_Impacts_Melee.Medium_Kick_Small',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Kick_Small',
		wood=SoundCue'A_Phys_Mat_Impacts.Kick_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Kick_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Kick_Metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Kick_Stone')}

	ParriedSound=SoundCue'A_Phys_Mat_Impacts.Quarterstaff_Blocking'
	ParrySound=SoundCue'A_Phys_Mat_Impacts.Quarterstaff_Blocking'

	ImpactBloodTemplates(0)=ParticleSystem'CHV_Particles_01.Player.P_ImpactBlunt'
	ImpactBloodTemplates(1)=ParticleSystem'CHV_Particles_01.Player.P_ImpactBlunt'
	ImpactBloodTemplates(2)=ParticleSystem'CHV_Particles_01.Player.P_ImpactBlunt'

	BloodSprayTemplates(0)=ParticleSystem'CHV_Particles_01.Player.P_OnWeaponBlood'
	BloodSprayTemplates(1)=ParticleSystem'CHV_Particles_01.Player.P_OnWeaponBlood'
	BloodSprayTemplates(2)=ParticleSystem'CHV_Particles_01.Player.P_OnWeaponBlood'
		
	StrafeModify=0.75f
	bFinishedEquip=false
	bCanDodge=false
	AlternativeMode=class'MWWeapon_StaffSpell'
	
	//SwappingAttack=Attack_Null
	bAllowedToSwitch=false
	bIgnoreShieldReplacement=true
	bSwitchingWeapon=false

	/* 
	 * Formerly in UDKNewWeapon.ini - [AOC.AOCWeapon_JavelinMelee]
	 */
	iFeintStaminaCost=15
	FeintTime=0.4
	TertiaryFeintTime=0.4
	fParryNegation=12
	ParryDrain(0)=5
	ParryDrain(1)=20
	ParryDrain(2)=10
	WeaponFontSymbol="r"
	//WeaponFontSymbol=","
	WeaponReach=100
	WeaponLargePortrait=""
	WeaponSmallPortrait=""
	//WeaponLargePortrait="SWF.weapon_select_javelin"
	//WeaponSmallPortrait="SWF.weapon_select_javelin"
	HorizontalRotateSpeed=60000.0
	VerticalRotateSpeed=60000.0
	AttackHorizRotateSpeed=60000.0
	SprintAttackHorizRotateSpeed=20000.0
	SprintAttackVerticalRotateSpeed=20000.0
	WindupAnimations(0)=(AnimationName=3p_javelin_swingdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.Jav_Reload',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(1)=(AnimationName=3p_javelin_bashdowntoup,ComboAnimation=,AlternateAnimation=3p_javelin_bashdowntoup,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.Jav_Reload',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.35,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(2)=(AnimationName=3p_javelin_stabdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.Jav_Reload',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.425,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(3)=(AnimationName=3p_javelin_sattackdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Footsteps.Archer_Dirt_Jump',bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false,bUseAltBoneBranch=true)
	WindupAnimations(4)=(AnimationName=3p_javelin_parryib,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Shield_Up',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.125,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(5)=(AnimationName=3p_javelin_shovestart,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.warhammer_windup',bFullBody=True,bCombo=False,bLoop=False,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.35,fBlendInTime=0.05,fBlendOutTime=0.05,bLastAnimation=false,bUseAltNode=true,bUseAltBoneBranch=true)
	ReleaseAnimations(0)=(AnimationName=3p_javelin_swingrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_attack_01',bFullBody=true,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(1)=(AnimationName=3p_javelin_bashrelease,ComboAnimation=3p_javelin_bashrelease,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_Attack_02',bFullBody=true,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(2)=(AnimationName=3p_javelin_stabrelease,ComboAnimation=3p_1hsharp_stabrelease,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_Attack_03',bFullBody=true,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.325,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(3)=(AnimationName=3p_javelin_sattackrelease,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_sprint_attack',bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false,bUseAltBoneBranch=true)
	ReleaseAnimations(4)=(AnimationName=3p_javelin_parryup,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(5)=(AnimationName=3p_javelin_shoverelease_new,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.3,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bUseAltNode=true,bUseAltBoneBranch=true,bUseRMM=true)
	ReleaseAnimations(6)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(7)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(8)=(AnimationName=3p_javelin_equipup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_draw',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.00,fBlendOutTime=0.01,bLastAnimation=false)
	ReleaseAnimations(9)=(AnimationName=3p_javelin_equipdown,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_sheath',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.00,fBlendOutTime=0.01,bLastAnimation=false)
	RecoveryAnimations(0)=(AnimationName=3p_javelin_swingrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(1)=(AnimationName=3p_javelin_bashrecover,ComboAnimation=3p_javelin_bashrecover,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(2)=(AnimationName=3p_javelin_stabrecover,ComboAnimation=3p_1hsharp_stabrecover,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.55,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(3)=(AnimationName=3p_javelin_sattackrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true,bUseAltBoneBranch=true)
	RecoveryAnimations(4)=(AnimationName=3p_javelin_parryrecover,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Shield_Down',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(5)=(AnimationName=3p_javelin_shoverecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.1,fBlendOutTime=0.1,bLastAnimation=true,bUseAltNode=true,bUseAltBoneBranch=true)
	RecoveryAnimations(6)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(7)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(8)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(9)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	StateAnimations(0)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.8,fBlendInTime=0.00,fBlendOutTime=0.08,bLastAnimation=true)
	StateAnimations(1)=(AnimationName=3p_javelin_dazed,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	StateAnimations(2)=(AnimationName=3p_javelin_dazed,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.9,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	StateAnimations(3)=(AnimationName=3p_javelin_hitFR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.9,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	StateAnimations(4)=(AnimationName=3p_javelin_hitBL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.08,bLastAnimation=false)
	OtherParryAnimations(0)=(AnimationName=3p_javelin_parryhit1,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	OtherParryAnimations(1)=(AnimationName=3p_javelin_parryhit1,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	OtherParryAnimations(2)=(AnimationName=3p_javelin_parryhit1,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	TurnInfo(0)=(AnimationName=3p_javelin_turnL,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=true,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=false,bLowerBody=true)
	TurnInfo(1)=(AnimationName=3p_javelin_turnR,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=true,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=false)
	SwapToAnimation=(AnimationName=3p_javelin_throwtostab,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_draw',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	DazedAnimations(0)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(1)=(AnimationName=3p_javelin_dazedR01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(2)=(AnimationName=3p_javelin_dazedF01,AlternateAnimation=3p_javelin_parrydazed,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(3)=(AnimationName=3p_javelin_dazedL01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(4)=(AnimationName=3p_javelin_dazedBL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(5)=(AnimationName=3p_javelin_dazedBR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(6)=(AnimationName=3p_javelin_dazedFL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(7)=(AnimationName=3p_javelin_dazedFR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	BattleCryAnim=(AnimationName=3p_javelin_battlecry,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DirHitAnimation(0)=(AnimationName=ADD_3p_javelin_hitFL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	DirHitAnimation(1)=(AnimationName=ADD_3p_javelin_hitFR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	DirHitAnimation(2)=(AnimationName=ADD_3p_javelin_hitBL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	DirHitAnimation(3)=(AnimationName=ADD_3p_javelin_hitBR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	AlternateRecoveryAnimations(0)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(1)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(2)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(3)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(4)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(5)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(6)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(7)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(8)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(9)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DirParryHitAnimations(0)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	DirParryHitAnimations(1)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	DirParryHitAnimations(2)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	DirParryHitAnimations(3)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	//Executions:
	//0 - Front
	//1 - Back
	//2 - Front (attacker has shield equipped)
	//3 - Back (attacker has shield equipped)
	ExecuterAnimations(0)=(AnimationName=3p_javelin_executorF,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuterAnimations(1)=(AnimationName=3p_javelin_executorB,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuterAnimations(2)=(AnimationName=3p_javelin_executorF,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuterAnimations(3)=(AnimationName=3p_javelin_executorB,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuteeAnimations(0)=(AnimationName=3p_death_javelinFdeath,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuteeAnimations(1)=(AnimationName=3p_death_javelinBdeath,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuteeAnimations(2)=(AnimationName=3p_death_javelinFdeath,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuteeAnimations(3)=(AnimationName=3p_death_javelinBdeath,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)

}
/*
	WindupAnimations(0)=(AnimationName=3p_javelin_swingdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.Jav_Reload',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(1)=(AnimationName=3p_javelin_bashdowntoup,ComboAnimation=,AlternateAnimation=3p_javelin_bashdowntoup,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.Jav_Reload',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.35,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(2)=(AnimationName=3p_javelin_stabdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.Jav_Reload',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.425,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(3)=(AnimationName=3p_javelin_sattackdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Footsteps.Archer_Dirt_Jump',bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false,bUseAltBoneBranch=true)
	WindupAnimations(4)=(AnimationName=3p_javelin_parryib,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Shield_Up',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.125,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(5)=(AnimationName=3p_javelin_shovestart,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.warhammer_windup',bFullBody=True,bCombo=False,bLoop=False,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.35,fBlendInTime=0.05,fBlendOutTime=0.05,bLastAnimation=false,bUseAltNode=true,bUseAltBoneBranch=true)
	ReleaseAnimations(0)=(AnimationName=3p_javelin_swingrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_attack_01',bFullBody=true,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(1)=(AnimationName=3p_javelin_bashrelease,ComboAnimation=3p_javelin_bashrelease,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_Attack_02',bFullBody=true,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(2)=(AnimationName=3p_javelin_stabrelease,ComboAnimation=3p_1hsharp_stabrelease,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_Attack_03',bFullBody=true,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.325,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(3)=(AnimationName=3p_javelin_sattackrelease,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_sprint_attack',bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false,bUseAltBoneBranch=true)
	ReleaseAnimations(4)=(AnimationName=3p_javelin_parryup,ComboAnimation=,AssociatedSoundCue=,bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(5)=(AnimationName=3p_javelin_shoverelease_new,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.3,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bUseAltNode=true,bUseAltBoneBranch=true,bUseRMM=true)
	ReleaseAnimations(6)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(7)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(8)=(AnimationName=3p_javelin_equipup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_draw',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.00,fBlendOutTime=0.01,bLastAnimation=false)
	ReleaseAnimations(9)=(AnimationName=3p_javelin_equipdown,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_sheath',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.00,fBlendOutTime=0.01,bLastAnimation=false)
	RecoveryAnimations(0)=(AnimationName=3p_javelin_swingrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(1)=(AnimationName=3p_javelin_bashrecover,ComboAnimation=3p_javelin_bashrecover,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(2)=(AnimationName=3p_javelin_stabrecover,ComboAnimation=3p_1hsharp_stabrecover,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.55,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(3)=(AnimationName=3p_javelin_sattackrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true,bUseAltBoneBranch=true)
	RecoveryAnimations(4)=(AnimationName=3p_javelin_parryrecover,ComboAnimation=,AssociatedSoundCue=SoundCue'MWCONTENT_SFX.Shield_Down',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(5)=(AnimationName=3p_javelin_shoverecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.1,fBlendOutTime=0.1,bLastAnimation=true,bUseAltNode=true,bUseAltBoneBranch=true)
	RecoveryAnimations(6)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(7)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(8)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	RecoveryAnimations(9)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=true)
	StateAnimations(0)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.8,fBlendInTime=0.00,fBlendOutTime=0.08,bLastAnimation=true)
	StateAnimations(1)=(AnimationName=3p_javelin_dazed,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	StateAnimations(2)=(AnimationName=3p_javelin_dazed,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.9,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	StateAnimations(3)=(AnimationName=3p_javelin_hitFR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.9,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	StateAnimations(4)=(AnimationName=3p_javelin_hitBL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.08,bLastAnimation=false)
	OtherParryAnimations(0)=(AnimationName=3p_javelin_parryhit1,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	OtherParryAnimations(1)=(AnimationName=3p_javelin_parryhit1,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	OtherParryAnimations(2)=(AnimationName=3p_javelin_parryhit1,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	TurnInfo(0)=(AnimationName=3p_javelin_turnL,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=true,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=false,bLowerBody=true)
	TurnInfo(1)=(AnimationName=3p_javelin_turnR,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=true,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.0,bLastAnimation=false)
	SwapToAnimation=(AnimationName=3p_javelin_throwtostab,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_draw',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1,fBlendInTime=0.10,fBlendOutTime=0.10,bLastAnimation=false)
	DazedAnimations(0)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(1)=(AnimationName=3p_javelin_dazedR01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(2)=(AnimationName=3p_javelin_dazedF01,AlternateAnimation=3p_javelin_parrydazed,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(3)=(AnimationName=3p_javelin_dazedL01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(4)=(AnimationName=3p_javelin_dazedBL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(5)=(AnimationName=3p_javelin_dazedBR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(6)=(AnimationName=3p_javelin_dazedFL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DazedAnimations(7)=(AnimationName=3p_javelin_dazedFR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	BattleCryAnim=(AnimationName=3p_javelin_battlecry,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DirHitAnimation(0)=(AnimationName=ADD_3p_javelin_hitFL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	DirHitAnimation(1)=(AnimationName=ADD_3p_javelin_hitFR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	DirHitAnimation(2)=(AnimationName=ADD_3p_javelin_hitBL,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	DirHitAnimation(3)=(AnimationName=ADD_3p_javelin_hitBR,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.1,bLastAnimation=false,bUseSlotSystem=true)
	AlternateRecoveryAnimations(0)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(1)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(2)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(3)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(4)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(5)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(6)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(7)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(8)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	AlternateRecoveryAnimations(9)=(AnimationName=3p_javelin_dazedB01,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=1.1,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true)
	DirParryHitAnimations(0)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	DirParryHitAnimations(1)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	DirParryHitAnimations(2)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	DirParryHitAnimations(3)=(AnimationName=3p_javelin_parried,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.2,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=true,bUseAltNode=true)
	//Executions:
	//0 - Front
	//1 - Back
	//2 - Front (attacker has shield equipped)
	//3 - Back (attacker has shield equipped)
	ExecuterAnimations(0)=(AnimationName=3p_javelin_executorF,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuterAnimations(1)=(AnimationName=3p_javelin_executorB,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuterAnimations(2)=(AnimationName=3p_javelin_executorF,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuterAnimations(3)=(AnimationName=3p_javelin_executorB,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuteeAnimations(0)=(AnimationName=3p_death_javelinFdeath,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuteeAnimations(1)=(AnimationName=3p_death_javelinBdeath,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuteeAnimations(2)=(AnimationName=3p_death_javelinFdeath,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
	ExecuteeAnimations(3)=(AnimationName=3p_death_javelinBdeath,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.0,fBlendInTime=0.0,fBlendOutTime=0.00,bLastAnimation=false,fShieldAnimLength=0.0,bUseSlotSystem=True)
*/
