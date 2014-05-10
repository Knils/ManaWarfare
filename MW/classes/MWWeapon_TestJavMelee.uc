class MWWeapon_TestJavMelee extends AOCWeapon_JavelinMelee;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	LogAlwaysInternal("Melee");
}

simulated function EndFire(Byte FireModeNum)
{
	super.EndFire(FireModeNum);

	if (FireModeNum == Attack_Slash && AttackQueue == EAttack(Attack_Slash) && !bSwitchingWeapon)
	{
		// If the end fire occurs before switching to JavilinThrow, make sure it still fires
		MWWeapon_TestJavelinThrow(AlternativeModeInstance).AlternativeFireStopped();
	}
}

DefaultProperties
{
	AlternativeMode=class'MWWeapon_TestJavelinThrow'
}
