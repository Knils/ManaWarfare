class MWFamilyInfo extends AOCFamilyInfo
	dependson(MWPawn)
	dependson(AOCDamageType)
	dependson(AOCOnlineStatsWrite)
	abstract;

/*
static function class<AOCFamilyInfo> GetFamilyFromEAOCClass(EAOCClass ConvertClass, optional EAOCFaction Fac = EFAC_Agatha)
{
	switch(ConvertClass)
	{
	case ECLASS_Archer:
		return Fac == EFAC_Agatha ? class'MWFamilyInfo_Agatha_Archer' : class'MWFamilyInfo_Mason_Archer';
	case ECLASS_ManAtArms:
		return Fac == EFAC_Agatha ? class'AOCFamilyInfo_Agatha_ManAtArms' : class'AOCFamilyInfo_Mason_ManAtArms';
	case ECLASS_Knight:
		return Fac == EFAC_Agatha ? class'AOCFamilyInfo_Agatha_Knight' : class'AOCFamilyInfo_Mason_Knight';
	case ECLASS_Vanguard:
		return Fac == EFAC_Agatha ? class'AOCFamilyInfo_Agatha_Vanguard' : class'AOCFamilyInfo_Mason_Vanguard';
	}
}
*/

DefaultProperties
{
}
