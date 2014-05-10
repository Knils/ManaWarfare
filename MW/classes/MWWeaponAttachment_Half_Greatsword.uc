class MWWeaponAttachment_Half_Greatsword extends AOCWeaponAttachment_Bill;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_2hs_greatsword.wep_greatsword'
		//Translation=(Z=1)
		//Rotation=(Roll=-400)
		Translation=(X=13)
		Scale=1.0
		bUpdateSkelWhenNotRendered=true
		bForceRefPose=0
		bIgnoreControllersWhenNotRendered=false
		bOverrideAttachmentOwnerVisibility=false
	End Object

	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'WP_2hs_greatsword.wep_greatsword'
		//Translation=(Z=1)
		//Rotation=(Roll=-400)
		Translation=(X=13)
		Scale=1.0
		bUpdateSkelWhenNotRendered=true
		bForceRefPose=0
		bIgnoreControllersWhenNotRendered=false
		bOverrideAttachmentOwnerVisibility=false
	End Object

	AttackTypeInfo(0)=(fBaseDamage=70.0, fForce=35500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(1)=(fBaseDamage=85.0, fForce=35500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(2)=(fBaseDamage=70.0, fForce=36500, cDamageType="AOC.AOCDmgType_Pierce", iWorldHitLenience=6)
	AttackTypeInfo(3)=(fBaseDamage=100.0, fForce=65000, cDamageType="AOC.AOCDmgType_Pierce", iWorldHitLenience=6)
	AttackTypeInfo(4)=(fBaseDamage=1.0, fForce=35500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(5)=(fBaseDamage=5.0, fForce=45500.0, cDamageType="AOC.AOCDmgType_Shove", iWorldHitLenience=12)
}
