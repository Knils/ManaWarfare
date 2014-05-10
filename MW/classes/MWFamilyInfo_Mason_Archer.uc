class MWFamilyInfo_Mason_Archer extends MWFamilyInfo_Archer
	dependson(MWPawn);

DefaultProperties
{
	FamilyID="Archer"
	Faction="Mason"
	FamilyFaction=EFAC_MASON

	NewPrimaryWeapons(3)=(CWeapon=class'AOCWeapon_Crossbow',CForceTertiary=(class'AOCWeapon_PaviseShield_Mason',class'AOCWeapon_ExtraAmmo'))
	NewPrimaryWeapons(4)=(CWeapon=class'AOCWeapon_LightCrossbow',CForceTertiary=(class'AOCWeapon_PaviseShield_Mason',class'AOCWeapon_ExtraAmmo'))
	NewPrimaryWeapons(5)=(CWeapon=class'AOCWeapon_HeavyCrossbow',CForceTertiary=(class'AOCWeapon_PaviseShield_Mason',class'AOCWeapon_ExtraAmmo'))
	NewPrimaryWeapons(6)=(CWeapon=class'AOCWeapon_JavelinMelee',CForceTertiary=(class'AOCWeapon_Buckler_Mason'))
	NewPrimaryWeapons(7)=(CWeapon=class'AOCWeapon_ShortSpearMelee',CForceTertiary=(class'AOCWeapon_Buckler_Mason'))
	NewPrimaryWeapons(8)=(CWeapon=class'AOCWeapon_HeavyJavelinMelee',CForceTertiary=(class'AOCWeapon_Buckler_Mason'))
	//NewTertiaryWeapons(0)=(CWeapon=class'AOCWeapon_PaviseShield_Mason',bEnabledDefault=false)	
	//NewTertiaryWeapons(2)=(CWeapon=class'AOCWeapon_Buckler_Mason',bEnabledDefault=false)

	//MW
	//NewPrimaryWeapons(0)=(CWeapon=class'MWWeapon_StaffMelee',CForceTertiary=(class'AOCWeapon_Buckler'),CheckLimitExpGroup=EEXP_JAVS,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_JavelinUse)
	//NewSecondaryWeapons(6)=(CWeapon=class'MWWeapon_StaffMelee',CForceTertiary=(class'AOCWeapon_Buckler'),CheckLimitExpGroup=EEXP_JAVS,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_JavelinUse)
}