class MWWeaponAttachment_2hStaffMelee extends AOCWeaponAttachment;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_DL1_quarterstaff.WEP_quarterstaff'
		//SkeletalMesh=SkeletalMesh'MWCONTENT_3D.MOD_WEP_Defaultstaff'
		Translation=(x=17)
		//Rotation=(Roll=-400)
		Rotation=(Yaw=16384,Pitch=13384)
		Scale=1.0
		bUpdateSkelWhenNotRendered=true
		bForceRefPose=0
		bIgnoreControllersWhenNotRendered=false
		bOverrideAttachmentOwnerVisibility=false
	End Object
	
	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'WP_DL1_quarterstaff.WEP_quarterstaff'
		//SkeletalMesh=SkeletalMesh'MWCONTENT_3D.MOD_WEP_Defaultstaff'
		Translation=(x=17)
		//Rotation=(Roll=-400)
		Rotation=(Yaw=16384,Pitch=13384)
		Scale=1
		bUpdateSkelWhenNotRendered=true
		bForceRefPose=0
		bIgnoreControllersWhenNotRendered=false
		bOverrideAttachmentOwnerVisibility=false
	End Object
	
	
	/*Begin Object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'WP_jav_Javelin.WEP_Javelin'
		Scale=1.0
		bUpdateSkelWhenNotRendered=true
		bForceRefPose=0
		Animations=none
		bIgnoreControllersWhenNotRendered=false
		bOverrideAttachmentOwnerVisibility=false
	End Object

	Begin Object Name=SkeletalMeshComponent2
		SkeletalMesh=SkeletalMesh'WP_jav_Javelin.WEP_Javelin'
		Scale=1.0
		bUpdateSkelWhenNotRendered=true
		bForceRefPose=0
		Animations=none
		bIgnoreControllersWhenNotRendered=false
		bOverrideAttachmentOwnerVisibility=false
	End Object*/
	

	WeaponID=EWEP_Javelin
	WeaponClass=class'MWWeapon_2hStaffMelee'
	WeaponSocket =JavelinPoint
	//WeaponSocket=wepQstaffpoint

	//WeaponPSSocket=Flame
	//WeaponPS=ParticleSystem'CHV_Sky1.Effects.Torch_fire'

	//WeaponStaticMesh=StaticMesh'WP_jav_Javelin.JavelinStatic'
	WeaponStaticMeshScale=1

	AttackTypeInfo(0)=(fBaseDamage=40.0, fForce=22500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(1)=(fBaseDamage=35.0, fForce=22500, cDamageType="AOC.AOCDmgType_Blunt", iWorldHitLenience=6)
	AttackTypeInfo(2)=(fBaseDamage=55.0, fForce=20000, cDamageType="AOC.AOCDmgType_Blunt", iWorldHitLenience=6)
	AttackTypeInfo(3)=(fBaseDamage=0.0, fForce=22500, cDamageType="AOC.AOCDmgType_Generic", iWorldHitLenience=6)
	AttackTypeInfo(4)=(fBaseDamage=0.0, fForce=22500, cDamageType="AOC.AOCDmgType_Swing", iWorldHitLenience=6)
	AttackTypeInfo(5)=(fBaseDamage=5.0, fForce=45500.0, cDamageType="AOC.AOCDmgType_Shove", iWorldHitLenience=12)
}
