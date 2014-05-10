class MWTOGRI extends AOCGRI
dependson(MWTeamObjective);

var ObjInfo PrevObjective;
var repnotify ObjInfo CurObjective;
var ObjInfo MemoryCurObjective;
var ObjInfo NextObjective;

replication
{
	if ( bNetDirty || bNetInitial )
		PrevObjective, CurObjective, NextObjective;
}

// Replicated Event - When we get to client, notify the PC
// This will allow us to notify the PC to update the HUD Markers
simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'CurObjective')
	{
		if (CurObjective.StageObjectives[0] != MemoryCurObjective.StageObjectives[0])
		{
			AOCTeamObjectivePC(GetALocalPlayerController()).ForceClearDynamicHUDMarkers();
			AOCTeamObjectivePC(GetALocalPlayerController()).AddObjectiveDynamicHUDMarker(CurObjective);
		}
		MemoryCurObjective = CurObjective;
	}
	else
		super.ReplicatedEvent(VarName);
}

// Force Sync Objectives
simulated function RequestSyncGametypeHUD(AOCPlayerController PC)
{
	local Actor ActList[25];
	local int i, x;
	local int bGen;
	bGen = -1;
	// Set ActList for generic objective
	for(i = 0; i < 7; i++)
	{
		if (AOCObjective_Generic(CurObjective.StageObjectives[i]) != none)
		{
			bGen = i;
			for (x = 0; x < 25; x++)
				ActList[x] = AOCObjective_Generic(CurObjective.StageObjectives[i]).ActList[x];
			break;
		}
	}
	//`log("SYNC OBJECTIVES"@PrevObjective.StageObjectives[0]@CurObjective.StageObjectives[0]@NextObjective.StageObjectives[0]@bGen);
	SetObjectivesSync(PrevObjective, CurObjective, NextObjective, PC, ActList, bGen);
}

simulated function SetObjectivesSync(ObjInfo Prev, ObjInfo Cur, ObjInfo Next, AOCPlayerController PC, Actor ActList[25], int bGeneric)
{
	//`log("SET OBJ SYNC"@PC@bGeneric);
	AOCTeamObjectivePC(PC).SetPrevObj(Prev);
	AOCTeamObjectivePC(PC).SetCurObj(Cur, bGeneric, ActList);
	AOCTeamObjectivePC(PC).SetNextObj(Next);
}

// Objective Info
simulated function float  RetrieveObjectiveCompletionPercentage()
{
	local float TotalSum;
	local int Count, i;
	TotalSum = 0.f;
	Count = 0;
	// Go through current stage objectives and average out their completion percentages
	for (i = 0; i < 7; i++)
	{
		if (CurObjective.StageObjectives[i] == none)
			break;

		TotalSum += IAOCObjective(CurObjective.StageObjectives[i]).RetrieveCompletionPercentage();
		Count += 1;
	}

	if (Count == 0)
		return 0.f;

	return TotalSum / Count;
}

simulated function string RetrieveObjectiveName(EAOCFaction Faction)
{
	if (Faction == EFAC_AGATHA || CurObjective.MasonStageName == "")
		return  CurObjective.StageName != "" ? Localize("ObjectiveSB", CurObjective.StageName, "AOCMaps") : "";
	else
		return  CurObjective.MasonStageName != "" ? Localize("ObjectiveSB", CurObjective.MasonStageName, "AOCMaps") : "";
}

simulated function string RetrieveObjectiveDescription(EAOCFaction Faction)
{
	if (Faction == EFAC_AGATHA || CurObjective.MasonStageDescript == "")
		return CurObjective.StageDescription != "" ? Localize("ObjectiveDescript", CurObjective.StageDescription, "AOCMaps") : "";
	else
		return CurObjective.MasonStageDescript != "" ? Localize("ObjectiveDescript", CurObjective.MasonStageDescript, "AOCMaps") : "";
}

simulated function string RetrieveObjectiveStatusText(EAOCFaction Faction)
{
	// Grab Text for Objective Stage as registered
	local string Text;
	Text = CurObjective.ScoreboardText;
	if (Text == "")
		return "";
	Text = Localize("ObjectiveStatus", Text, "AOCMaps");
	if (!CurObjective.bUseIntegerCurMax)
	{
		if (InStr(Text, "{Cur}",,true) != -1)
			Text = Repl(Text, "{Cur}", string(CurObjective.CurVar), false);
		if (InStr(Text, "{Max}",,true) != -1)
			Text = Repl(Text, "{Max}", string(CurObjective.MaxVar), false);
	}
	else
	{
		if (InStr(Text, "{Cur}",,true) != -1)
			Text = Repl(Text, "{Cur}", string(int(CurObjective.CurVar)), false);
		if (InStr(Text, "{Max}",,true) != -1)
			Text = Repl(Text, "{Max}", string(int(CurObjective.MaxVar)), false);
	}

	if (InStr(Text, "{Extra}",,true) != -1)
	{
		if (!CurObjective.bUseIntegerExtra)
			Text = Repl(Text, "{Extra}", string(CurObjective.ExtraVar), false);
		else
			Text = Repl(Text, "{Extra}", string(int(CurObjective.ExtraVar)), false);
	}
	return Text;
}

simulated function string RetrieveObjectiveImg(EAOCFaction Faction)
{
	if (Faction == EFAC_AGATHA || CurObjective.MasonStageImage == "")
		return "img://"$CurObjective.StageImage;
	else
		return "img://"$CurObjective.MasonStageImage;
}

simulated function bool   CheckPreviousObjectiveExist()
{
	return (PrevObjective.StageObjectives[0] != none);
}

simulated function string RetrievePreviousObjectiveName(EAOCFaction Faction)
{
	if (Faction == EFAC_AGATHA)
		return Localize("ObjectiveSB", PrevObjective.StageName, "AOCMaps");
	else
		return Localize("ObjectiveSB", PrevObjective.MasonStageName, "AOCMaps");
}

simulated function string RetrievePreviousObjectiveImg(EAOCFaction Faction)
{
	if (Faction == EFAC_AGATHA || PrevObjective.MasonStageImage == "")
		return "img://"$PrevObjective.StageImage;
	else
		return "img://"$PrevObjective.MasonStageImage;
}

simulated function bool   CheckNextObjectiveExist()
{
	return (NextObjective.StageObjectives[0] != none);
}

simulated function string RetrieveNextObjectiveName(EAOCFaction Faction)
{
	if (Faction == EFAC_AGATHA || NextObjective.MasonStageName == "")
		return Localize("ObjectiveSB", NextObjective.StageName, "AOCMaps");
	else
		return Localize("ObjectiveSB", NextObjective.MasonStageName, "AOCMaps");
}

simulated function string RetrieveNextObjectiveImg(EAOCFaction Faction)
{
	if (Faction == EFAC_AGATHA || NextObjective.MasonStageImage == "")
		return "img://"$NextObjective.StageImage;
	else
		return "img://"$NextObjective.MasonStageImage;
}

defaultproperties
{
}
