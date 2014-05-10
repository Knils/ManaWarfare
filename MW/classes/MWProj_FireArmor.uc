class MWProj_FireArmor extends MWProj_Spell;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();	
}

simulated event Tick( float DeltaTime)
{
	super.Tick(DeltaTime);
	if(OwnerPawn.Location != vect(0,0,0))
	{
		//LogAlwaysInternal("OwnerPawn.Location:"@OwnerPawn.Location);
		SetLocation(OwnerPawn.Location);
	}
}

simulated function SuccessHitMWPawn(MWPawn P)
{
	LogAlwaysInternal(OwnerPawn@P@"SelfFIREARMOR+++++++++++");
	MWPawn(OwnerPawn).SetPawnOnFlame(HealPS, OwnerPawn.Controller, OwnerPawn,,LifeSpan);
	bHitOwner=false;
}

DefaultProperties
{
	bAoEOnce=false
	LifeSpan=10
	bSuperHurtRadius=false
	bFireArmor=true
	bCanShutDown=false
	bHitOwner=true
	bAoE=true
	AoETimer=0.75
	bSmallFlinch=true
}
