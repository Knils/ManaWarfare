class MWProj_RockArmor extends MWProj_Spell;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	
		//SelfRockArmor();
}

/*
simulated function SelfRockArmor()
{
	LogAlwaysInternal(OwnerPawn@"SelfROCKARMOR+++++++++++");
	MWPawn(OwnerPawn).SetPawnOnRock(HealPS, OwnerPawn.Controller, OwnerPawn,,10);
}
*/

simulated function SuccessHitMWPawn(MWPawn P)
{
	LogAlwaysInternal(OwnerPawn@P@"SelfROCKARMOR+++++++++++");
	MWPawn(OwnerPawn).SetPawnOnRock(HealPS, OwnerPawn.Controller, OwnerPawn,,12);
	ShutDown();
}


DefaultProperties
{
	bHitOwner=true
	bAoE=true
	AoETimer=0.05
	bSmallFlinch=false
}