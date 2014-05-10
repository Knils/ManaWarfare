class MWDmgType_GenericProj extends AOCDamageType;

DefaultProperties
{
	StopAnimAfterDamageInterval=0.0f;
	bIsProjectile = true
	bCanHeadExplode=true
	bCanDecap=true
	DamageType(EDMG_Swing)  = 0.0f
	DamageType(EDMG_Pierce) = 0.0f
	DamageType(EDMG_Blunt)  = 0.0f
	DamageType(EDMG_Generic)= 1.0f

	//DeathAnim=Fall
}