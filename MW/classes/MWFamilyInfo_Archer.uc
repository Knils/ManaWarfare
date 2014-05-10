class MWFamilyInfo_Archer extends MWFamilyInfo
	dependson(MWPawn);

DefaultProperties
{
	PrimaryWeapons(0)=class'AOCWeapon_Longbow'
	PrimaryWeapons(1)=class'AOCWeapon_Crossbow'
	PrimaryWeapons(2)=class'AOCWeapon_JavelinMelee'

	SecondaryWeapons(0)=class'AOCWeapon_Dagesse'
	SecondaryWeapons(1)=class'AOCWeapon_BroadDagger'
	SecondaryWeapons(2)=class'AOCWeapon_PaviseShield'

	NewPrimaryWeapons(0)=(CWeapon=class'AOCWeapon_Longbow',CForceTertiary=(class'AOCWeapon_ProjBodkin', class'AOCWeapon_ProjBroadhead', class'AOCWeapon_ProjFireArrow'),CheckLimitExpGroup=EEXP_BOWS,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_LongbowUse)
	NewPrimaryWeapons(1)=(CWeapon=class'AOCWeapon_Shortbow',CForceTertiary=(class'AOCWeapon_ProjBodkin', class'AOCWeapon_ProjBroadhead', class'AOCWeapon_ProjFireArrow'),CheckLimitExpGroup=EEXP_BOWS,UnlockExpLevel=25.f,CorrespondingDuelProp=EDUEL_ShortbowUse)
	NewPrimaryWeapons(2)=(CWeapon=class'AOCWeapon_Warbow',CForceTertiary=(class'AOCWeapon_ProjBodkin', class'AOCWeapon_ProjBroadhead', class'AOCWeapon_ProjFireArrow'),CheckLimitExpGroup=EEXP_BOWS,UnlockExpLevel=100.f,CorrespondingDuelProp=EDUEL_WarbowUse)
	NewPrimaryWeapons(3)=(CWeapon=class'AOCWeapon_Crossbow',CForceTertiary=(class'AOCWeapon_PaviseShield',class'AOCWeapon_ExtraAmmo'),CheckLimitExpGroup=EEXP_XBOWS,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_CrossbowUse)
	NewPrimaryWeapons(4)=(CWeapon=class'AOCWeapon_LightCrossbow',CForceTertiary=(class'AOCWeapon_PaviseShield',class'AOCWeapon_ExtraAmmo'),CheckLimitExpGroup=EEXP_XBOWS,UnlockExpLevel=25.f,CorrespondingDuelProp=EDUEL_LightCrossbowUse)
	NewPrimaryWeapons(5)=(CWeapon=class'AOCWeapon_HeavyCrossbow',CForceTertiary=(class'AOCWeapon_PaviseShield',class'AOCWeapon_ExtraAmmo'),CheckLimitExpGroup=EEXP_XBOWS,UnlockExpLevel=100.f,CorrespondingDuelProp=EDUEL_HeavyCrossbowUse)
	NewPrimaryWeapons(6)=(CWeapon=class'AOCWeapon_JavelinMelee',CForceTertiary=(class'AOCWeapon_Buckler'),CheckLimitExpGroup=EEXP_JAVS,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_JavelinUse)
	NewPrimaryWeapons(7)=(CWeapon=class'AOCWeapon_ShortSpearMelee',CForceTertiary=(class'AOCWeapon_Buckler'),CheckLimitExpGroup=EEXP_JAVS,UnlockExpLevel=25.f,CorrespondingDuelProp=EDUEL_ShortSpearUse)
	NewPrimaryWeapons(8)=(CWeapon=class'AOCWeapon_HeavyJavelinMelee',CForceTertiary=(class'AOCWeapon_Buckler'),CheckLimitExpGroup=EEXP_JAVS,UnlockExpLevel=100.f,CorrespondingDuelProp=EDUEL_HeavyJavelinUse)
	NewPrimaryWeapons(9)=(CWeapon=class'AOCWeapon_Sling',CForceTertiary=(class'AOCWeapon_ProjPebble',class'AOCWeapon_ProjLeadBall'),CheckLimitExpGroup=EEXP_SLING,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_SlingUse)

	NewSecondaryWeapons(0)=(CWeapon=class'AOCWeapon_BroadDagger',CheckLimitExpGroup=EEXP_DAGGER,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_BroadDaggerUse)
	NewSecondaryWeapons(1)=(CWeapon=class'AOCWeapon_HuntingKnife',CheckLimitExpGroup=EEXP_DAGGER,UnlockExpLevel=25.f,CorrespondingDuelProp=EDUEL_HuntingKnifeUse)
	NewSecondaryWeapons(2)=(CWeapon=class'AOCWeapon_ThrustDagger',CheckLimitExpGroup=EEXP_DAGGER,UnlockExpLevel=100.f,CorrespondingDuelProp=EDUEL_ThrustDaggerUse)
	NewSecondaryWeapons(3)=(CWeapon=class'AOCWeapon_Dagesse',CheckLimitExpGroup=EEXP_LIGHTAUX,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_DagesseUse)
	NewSecondaryWeapons(4)=(CWeapon=class'AOCWeapon_Saber',CheckLimitExpGroup=EEXP_LIGHTAUX,UnlockExpLevel=25.f,CorrespondingDuelProp=EDUEL_SaberUse)
	NewSecondaryWeapons(5)=(CWeapon=class'AOCWeapon_Cudgel',CheckLimitExpGroup=EEXP_LIGHTAUX,UnlockExpLevel=100.f,CorrespondingDuelProp=EDUEL_CudgelUse)

	//NewTertiaryWeapons(7)=(CWeapon=class'AOCWeapon_PaviseShield',bEnabledDefault=false)
	//NewTertiaryWeapons(8)=(CWeapon=class'AOCWeapon_ExtraAmmo',bEnabledDefault=false)
	//NewTertiaryWeapons(9)=(CWeapon=class'AOCWeapon_ProjPebble',bEnabledDefault=false)
	NewTertiaryWeapons(1)=(CWeapon=class'MWWeapon_ProjFlame',bEnabledDefault=false)
	NewTertiaryWeapons(5)=(CWeapon=class'AOCWeapon_ProjBodkin',bEnabledDefault=false)
	//NewTertiaryWeapons(5)=(CWeapon=class'AOCWeapon_ProjBroadhead',bEnabledDefault=false)
	//NewTertiaryWeapons(6)=(CWeapon=class'AOCWeapon_ProjLeadBall',bEnabledDefault=false)
	//NewTertiaryWeapons(7)=(CWeapon=class'AOCWeapon_PaviseShield',bEnabledDefault=false)
	NewTertiaryWeapons(0)=(CWeapon=class'MWWeapon_ProjVoid',bEnabledDefault=false)
	//NewTertiaryWeapons(6)=(CWeapon=class'AOCWeapon_ProjFireArrow',bEnabledDefault=false)
	NewTertiaryWeapons(6)=(CWeapon=class'AOCWeapon_ExtraAmmo',bEnabledDefault=false)
	NewTertiaryWeapons(2)=(CWeapon=class'MWWeapon_ProjEarth',bEnabledDefault=false)
	NewTertiaryWeapons(3)=(CWeapon=class'MWWeapon_ProjWater',bEnabledDefault=false)
	NewTertiaryWeapons(4)=(CWeapon=class'MWWeapon_ProjElectric',bEnabledDefault=false)
	
	PawnArmorType = ARMORTYPE_LIGHT

	iPrimaryWeapons=3
	iSecondaryWeapons=2

	AirSpeed=440.0
	WaterSpeed=220.0
	AirControl=0.35
	//GroundSpeed=220.0

	ClassReference=ECLASS_Archer

	DefaultFOV=95.0f
	
	// damage modifiers
	DamageResistances(EDMG_Swing) = 1.00
	DamageResistances(EDMG_Pierce) = 0.9
	DamageResistances(EDMG_Blunt) = 0.8

	/*
	 * 
	 * Formerly in UDKFamilyInfo.ini
	 *
	 */
	GroundSpeed=200
	AccelRate=600.0
	SprintAccelRate=100.0
	JumpZ=380.0
	SprintModifier=1.65
	SprintTime=10.0
	DodgeSpeed=400.0
	DodgeSpeedZ=200.0
	Health=100
	BACK_MODIFY=0.8
	STRAFE_MODIFY=0.8
	FORWARD_MODIFY=1.0
	CROUCH_MODIFY=0.65
	//PercentDamageToTake=1.0
	MaxSprintSpeedTime=3.5
	bCanDodge=false
	iDodgeCost=30
	iKickCost=25
	fComboAggressionBonus=1.0
	fBackstabModifier=1.5
	iMissMeleeStrikePenalty=10
	iMissMeleeStrikePenaltyBonus=0
	//fShieldStaminaAbsorption=6
	bCanSprintAttack=false
	fStandingSpread=0.05f
	fCrouchingSpread=0.0f
	fWalkingSpread=0.1
	fSprintingSpread=0.25
	fFallingSpread=0.25
	fSpreadPenaltyPerSecond=0.5
	fSpreadRecoveryPerSecond=0.3
	fMaxComplexRelevancyDistanceSquared = 25000000

	//NewPrimaryWeapons.Empty
	NewPrimaryWeapons(10)=(CWeapon=class'MWWeapon_StaffMelee',CForceTertiary=(class'MWWeapon_ProjVoid', class'MWWeapon_ProjFlame', class'MWWeapon_ProjEarth', class'MWWeapon_ProjWater', class'MWWeapon_ProjElectric'/*,class'AOCWeapon_ProjBodkin',class'AOCWeapon_ProjFireArrow',class'AOCWeapon_Buckler_Agatha'*/),CheckLimitExpGroup=EEXP_JAVS,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_JavelinUse)
	NewPrimaryWeapons(11)=(CWeapon=class'MWWeapon_2hStaffMelee',CForceTertiary=(class'MWWeapon_ProjVoid', class'MWWeapon_ProjFlame', class'MWWeapon_ProjEarth', class'MWWeapon_ProjWater', class'MWWeapon_ProjElectric'/*,class'AOCWeapon_ProjBodkin',class'AOCWeapon_ProjFireArrow',class'AOCWeapon_Buckler_Agatha'*/),CheckLimitExpGroup=EEXP_JAVS,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_JavelinUse)
	//NewPrimaryWeapons(11)=(CWeapon=class'MWWeapon_TestJavMelee',CForceTertiary=(class'MWWeapon_ProjVoid', class'MWWeapon_ProjFlame', class'MWWeapon_ProjEarth', class'MWWeapon_ProjWater', class'MWWeapon_ProjElectric'/*,class'AOCWeapon_ProjBodkin',class'AOCWeapon_ProjFireArrow',class'AOCWeapon_Buckler_Agatha'*/),CheckLimitExpGroup=EEXP_JAVS,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_JavelinUse)
}