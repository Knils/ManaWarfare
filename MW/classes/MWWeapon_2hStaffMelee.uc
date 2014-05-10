class MWWeapon_2hStaffMelee extends MWWeapon_StaffMelee;

var ParticleSystemComponent ElementPSComp;

var Vector PreviousBucklerLoc;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	//AttachmentClass=class'MWWeaponAttachment_2hStaffMelee';
	//SetTimer(0.1,true,'AttachElementParticles');
}

simulated function AttachElementParticles()
{
	if(AOCOwner.PawnInfo.myTertiary != none)
	{
		ElementPSComp = new(self) class'UTParticleSystemComponent';
		ElementPSComp.bAutoActivate = true;
		
		//Mesh.AttachComponentToSocket(ElementPSComp, 'JavelinPoint');	
		//Mesh.AttachComponentToSocket(ElementPSComp, 'WeaponPoint');
	
		if(AOCOwner.PawnInfo.myTertiary == class'MWWeapon_ProjVoid')
		{
			//ElementPSComp.SetTemplate(ParticleSystem'MWCONTENT_3D.Staff_Effect_Void');
			LogAlwaysInternal("CHANGING ATTACHMENTCLASS Void");
			//AttachmentClass=class'MWWeaponAttachment_StaffMelee';
		}
		else if(AOCOwner.PawnInfo.myTertiary == class'MWWeapon_ProjFlame')
		{
		}
		else if(AOCOwner.PawnInfo.myTertiary == class'MWWeapon_ProjEarth')
		{
		}
		else if(AOCOwner.PawnInfo.myTertiary == class'MWWeapon_ProjWater')
		{
		}	
		else if(AOCOwner.PawnInfo.myTertiary == class'MWWeapon_ProjElectric')
		{
		}
	
		//ElementPSComp.ActivateSystem(true);
		//Mesh.AttachComponent(ElementPSComp, 'b_r_wrist');
		//Mesh.AttachComponent(ElementPSComp, 'b_weapon_tip');
		ClearTimer('AttachElementParticles');
	}
}

//Stop Shield Bash
simulated state Release
{
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		if (CurrentFireMode == Attack_Overhead)
			AOCWepAttachment.bUseAlternativeTracers = false;
	}
}

simulated state ParryRelease
{
	/** Play appropriate attack animation */
	simulated event BeginState(Name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		//bWantParryToDrop=true;
	}
}

DefaultProperties
{
	//2h
	AllowedShieldClass=none
	//CurrentWeaponType=EWEP_QStaff
	CurrentShieldType=ESHIELD_None
	bHaveShield=false
	AlternativeMode=class'MWWeapon_2hStaffSpell'
	AttachmentClass=class'MWWeaponAttachment_2hStaffMelee'
	WeaponIdentifier="spear"

	//CurrentGenWeaponType=EWT_2hand

	bTwoHander=true
	bUseRMMDazed=true
	bUseDirHitAnims=true

	//AlternativeMode=class'MWWeapon_2hStaffSpell'
	WeaponFontSymbol=","


	//set maximum ammo
	//AIRange=5000
	bCanCombo=false

	bUseDirParryHitAnims=true

	
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
	//WeaponFontSymbol="r"
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
	WindupAnimations(1)=(AnimationName=3p_spear_stab01downtoup,ComboAnimation=,AlternateAnimation=3p_javelin_bashdowntoup,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.Jav_Reload',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.35,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(2)=(AnimationName=3p_spear_stab021downtoup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.Jav_Reload',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.425,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(3)=(AnimationName=3p_javelin_sattackdowntoup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Footsteps.Archer_Dirt_Jump',bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false,bUseAltBoneBranch=true)
	WindupAnimations(4)=(AnimationName=3p_spear_parryib,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.halberd_Parry',bFullBody=False,bCombo=False,bLoop=False,bForce=false,fModifiedMovement=1.0,fAnimationLength=0.125,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	WindupAnimations(5)=(AnimationName=3p_javelin_shovestart,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.warhammer_windup',bFullBody=True,bCombo=False,bLoop=False,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.35,fBlendInTime=0.05,fBlendOutTime=0.05,bLastAnimation=false,bUseAltNode=true,bUseAltBoneBranch=true)
	ReleaseAnimations(0)=(AnimationName=3p_javelin_swingrelease,ComboAnimation=3p_1hsharp_slash011release,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_attack_01',bFullBody=true,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.4,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(1)=(AnimationName=3p_spear_stab01release,ComboAnimation=3p_javelin_bashrelease,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_Attack_02',bFullBody=true,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.3,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(2)=(AnimationName=3p_spear_stab021release,ComboAnimation=3p_1hsharp_stabrelease,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_Attack_03',bFullBody=true,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.325,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(3)=(AnimationName=3p_javelin_sattackrelease,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_sprint_attack',bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false,bUseAltBoneBranch=true)
	ReleaseAnimations(4)=(AnimationName=3p_spear_parryup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.halberd_Parry',bFullBody=False,bCombo=False,bLoop=True,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(5)=(AnimationName=3p_javelin_shoverelease_new,ComboAnimation=,AssociatedSoundCue=,bFullBody=True,bCombo=False,bLoop=False,bForce=false,UniqueShieldSound=none,fModifiedMovement=0.0,fAnimationLength=0.3,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=false,bUseAltNode=true,bUseAltBoneBranch=true,bUseRMM=true)
	ReleaseAnimations(6)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.halberd_Parry',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(7)=(AnimationName=,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.00,fBlendOutTime=0.00,bLastAnimation=false)
	ReleaseAnimations(8)=(AnimationName=3p_javelin_equipup,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_draw',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.00,fBlendOutTime=0.01,bLastAnimation=false)
	ReleaseAnimations(9)=(AnimationName=3p_javelin_equipdown,ComboAnimation=,AssociatedSoundCue=SoundCue'A_Combat_Locomotion.jav_sheath',bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.00,fBlendOutTime=0.01,bLastAnimation=false)
	RecoveryAnimations(0)=(AnimationName=3p_javelin_swingrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(1)=(AnimationName=3p_spear_stab01recover,ComboAnimation=3p_javelin_bashrecover,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(2)=(AnimationName=3p_spear_stab021recover,ComboAnimation=3p_1hsharp_stabrecover,AssociatedSoundCue=,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.55,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
	RecoveryAnimations(3)=(AnimationName=3p_javelin_sattackrecover,ComboAnimation=,AssociatedSoundCue=,bFullBody=true,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.0,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true,bUseAltBoneBranch=true)
	RecoveryAnimations(4)=(AnimationName=3p_spear_parryrecover,ComboAnimation=,AssociatedSoundCue=none,bFullBody=false,bCombo=false,bLoop=false,bForce=false,UniqueShieldSound=none,fModifiedMovement=1.0,fAnimationLength=0.5,fBlendInTime=0.05,fBlendOutTime=0.1,bLastAnimation=true)
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