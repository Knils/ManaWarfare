class MWWeaponAttachment_Half_Claymore extends AOCWeaponAttachment_Spear;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_2hs_claymore.wep_claymore'
		//Translation=(Z=1)
		//Rotation=(Roll=-400)
		Translation=(X=8)
		Scale=1.0
		bUpdateSkelWhenNotRendered=true
		bForceRefPose=0
		bIgnoreControllersWhenNotRendered=false
		bOverrideAttachmentOwnerVisibility=false
	End Object

	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'WP_2hs_claymore.wep_claymore'
		//Translation=(Z=1)
		//Rotation=(Roll=-400)
		Translation=(X=8)
		Scale=1.0
		bUpdateSkelWhenNotRendered=true
		bForceRefPose=0
		bIgnoreControllersWhenNotRendered=false
		bOverrideAttachmentOwnerVisibility=false
	End Object

	AttackTypeInfo(0)=(fBaseDamage=40.0, fForce=37000, cDamageType="AOC.AOCDmgType_Blunt", iWorldHitLenience=6)
	AttackTypeInfo(1)=(fBaseDamage=65.0, fForce=31500, cDamageType="AOC.AOCDmgType_Pierce", iWorldHitLenience=6)
	AttackTypeInfo(2)=(fBaseDamage=55.0, fForce=26000, cDamageType="AOC.AOCDmgType_Pierce", iWorldHitLenience=6)
	AttackTypeInfo(3)=(fBaseDamage=100.0, fForce=65000, cDamageType="AOC.AOCDmgType_Pierce", iWorldHitLenience=6)
	AttackTypeInfo(4)=(fBaseDamage=0.0, fForce=32500, cDamageType="AOC.AOCDmgType_Pierce", iWorldHitLenience=6)
	AttackTypeInfo(5)=(fBaseDamage=5.0, fForce=45500.0, cDamageType="AOC.AOCDmgType_Shove", iWorldHitLenience=12)
}
