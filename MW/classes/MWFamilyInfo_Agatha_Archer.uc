class MWFamilyInfo_Agatha_Archer extends MWFamilyInfo_Archer
	dependson(MWPawn);

DefaultProperties
{
	FamilyID="Archer"
	Faction="Agatha"
	FamilyFaction=EFAC_AGATHA

	NewPrimaryWeapons(3)=(CWeapon=class'AOCWeapon_Crossbow',CForceTertiary=(class'AOCWeapon_PaviseShield_Agatha',class'AOCWeapon_ExtraAmmo'))
	NewPrimaryWeapons(4)=(CWeapon=class'AOCWeapon_LightCrossbow',CForceTertiary=(class'AOCWeapon_PaviseShield_Agatha',class'AOCWeapon_ExtraAmmo'))
	NewPrimaryWeapons(5)=(CWeapon=class'AOCWeapon_HeavyCrossbow',CForceTertiary=(class'AOCWeapon_PaviseShield_Agatha',class'AOCWeapon_ExtraAmmo'))	
	NewPrimaryWeapons(6)=(CWeapon=class'AOCWeapon_JavelinMelee',CForceTertiary=(class'AOCWeapon_Buckler_Agatha'))
	NewPrimaryWeapons(7)=(CWeapon=class'AOCWeapon_ShortSpearMelee',CForceTertiary=(class'AOCWeapon_Buckler_Agatha'))
	NewPrimaryWeapons(8)=(CWeapon=class'AOCWeapon_HeavyJavelinMelee',CForceTertiary=(class'AOCWeapon_Buckler_Agatha'))
	
	//NewTertiaryWeapons(6)=(CWeapon=class'AOCWeapon_PaviseShield_Agatha',bEnabledDefault=false)
	//NewTertiaryWeapons(2)=(CWeapon=class'AOCWeapon_Buckler_Agatha',bEnabledDefault=false)
	//NewTertiaryWeapons(5)=(CWeapon=class'AOCWeapon_Buckler_Agatha',bEnabledDefault=false)

	//MW
	//NewPrimaryWeapons(0)=(CWeapon=class'MWWeapon_StaffMelee',CForceTertiary=(class'AOCWeapon_Buckler'),CheckLimitExpGroup=EEXP_JAVS,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_JavelinUse)
	//NewSecondaryWeapons(6)=(CWeapon=class'MWWeapon_StaffMelee',CForceTertiary=(class'AOCWeapon_Buckler'),CheckLimitExpGroup=EEXP_JAVS,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_JavelinUse)

	//NewPrimaryWeapons(0)=(CWeapon=class'AOCWeapon_DoubleAxe',CheckLimitExpGroup=EEXP_2HAXE,UnlockExpLevel=0.f)
	//NewPrimaryWeapons(1)=(CWeapon=class'AOCWeapon_Spear',CheckLimitExpGroup=EEXP_SPEAR,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_SpearUse)
	//NewPrimaryWeapons(2)=(CWeapon=class'AOCWeapon_Bardiche',CheckLimitExpGroup=EEXP_POLEARM,UnlockExpLevel=0.f,CorrespondingDuelProp=EDUEL_BardicheUse)
}