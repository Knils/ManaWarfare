class MWFFA extends AOCFFA;
/*
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return default.class;
}
*/
DefaultProperties
{
	MapPrefixes.Empty
	MapPrefixes(0)="MWFFA"

	DefaultPawnClass=class'MWPawn'
	PlayerControllerClass=class'MWFFAPlayerController'
	HUDType=class'MWFFAHUD'

	ModDisplayString="Mana Warfare"
}
