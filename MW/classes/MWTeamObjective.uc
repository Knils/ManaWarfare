class MWTeamObjective extends AOCTeamObjective;

/*
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return default.class;
}
*/

DefaultProperties
{
	MapPrefixes.Empty
	MapPrefixes(0)="MWTO"
	//GameReplicationInfoClass=class'MWTOGRI'
	DefaultPawnClass=class'MWPawn'
	//PlayerControllerClass=class'MW.MWTeamObjectivePC'
	PlayerControllerClass=class'MWTeamObjectivePC_New'
	HUDType=class'MWTeamObjectiveHUD'
	//PlayerReplicationInfoClass=class'MWPRI'	

	ModDisplayString="Mana Warfare"
}
