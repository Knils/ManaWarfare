class MWView_HUD_WeaponSelect extends AOCView_HUD_WeaponSelect
	dependson(MWFamilyInfo);

//var class<MWFamilyInfo> FamInfo;
/*
function OnTopMostView()
{
	// Grab Family and Weapons that are relevant to us
	FamInfo = class'MWPawn'.default.AllClasses[(MWBaseHUD(Manager.PlayerOwner.myHUD).SelectedTeam % 2) *
		class'MWPawn'.const.NUMBER_CLASSES + MWBaseHUD(Manager.PlayerOwner.myHUD).SelectedClass];

	PrimWeaps = FamInfo.default.NewPrimaryWeapons;
	SecWeaps = FamInfo.default.NewSecondaryWeapons;
	TertWeaps = FamInfo.default.NewTertiaryWeapons;

	super.OnTopMostView();

	Manager.SetSelectionFocus(PrimarySelectWidgets[0].Obj);

	MWPlayerController(Manager.PlayerOwner).AOCWeaponSelectMenu = self;
	MWPlayerController(Manager.PlayerOwner).RequestServerSyncStats();

	UpdateAllIcons();
}
*/

DefaultProperties
{
}
