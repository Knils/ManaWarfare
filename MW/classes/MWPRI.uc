class MWPRI extends AOCPRI;

simulated function PostBeginPlay()
{
	/////LogAlwaysInternal("MWPRI==============");
}

reliable server function ReplicateClassToServerPawn(AOCPawn Pawn, bool force)
{
	///LogAlwaysInternal("REPLICATE CLASS TO SERVER PAWN");
	Pawn.AOCSetCharacterClassFromInfo(MyFamilyInfo);
}

DefaultProperties
{
	MyFamilyInfo=class'MWFamilyInfo'
	ToBeClass=class'MWFamilyInfo'
}
