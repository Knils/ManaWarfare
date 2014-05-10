class MWGame extends AOCGame;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	local string prefix;

	LogAlwaysInternal("SetGameType is being called on"@default.Class);

	MapName = StripPlayOnPrefix(MapName);

	prefix = left(MapName,InStr(MapName,"-"));

	if(prefix ~= "AOCTD")
	{
		return class'MWTeamDeathmatch';
	}	
	else if(prefix ~= "AOCCTF")
	{
		return class'AOCCTF';
	}
	else if(prefix ~= "AOCKOTH")
	{
		return class'AOCKOTH';
	}
	else if(prefix ~= "AOCLTS")
	{
		return class'AOCLTS';
	}
	else if(prefix ~= "AOCDuel")
	{
		return class'AOCDuel';
	}
	else if(prefix ~= "AOCFFA")
	{
		return class'MWFFA';
	}
	else if(prefix ~= "AOCTO")
	{
		return class'MWTeamObjective';
	}

	return super.SetGameType(MapName, Options, Portal);
}


DefaultProperties
{
	PlayerControllerClass=class'MW.MWPlayerController'
	DefaultPawnClass=class'MWPawn'
	HUDType=class'MWBaseHUD'
	//PlayerReplicationInfoClass=class'MWPRI'
	
	//Test
	TimeBetweenRounds=0
	RoundTime=0
	SpawnWaveInterval=1

	ModDisplayString="Mana Warfare"
}
