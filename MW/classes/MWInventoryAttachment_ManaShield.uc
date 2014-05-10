class MWInventoryAttachment_ManaShield extends AOCInventoryAttachment;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
		//SkeletalMesh=SkeletalMesh'WP_shld_Buckler.WEP_Buckler'
		//SkeletalMesh=SkeletalMesh'MWCONTENT.MOD_WEP_ManaShield03_ZBrush_defualt_group'
		PhysicsAsset=PhysicsAsset'WP_shld_Buckler.WEP_Buckler_PKG_Physics'
	End Object

	//CustomizationMaterial=MaterialInstanceConstant'WP_shld_Buckler.M_BucklerCUST_A'
	//PlainMaterial=MaterialInstanceConstant'WP_shld_Buckler.M_Buckler_a'
	//PlainMaterial=Material'MWCONTENT_PFX.MAT_ManaShield_D'
	ShieldID=ESHIELD_Buckler

	StaticMeshSpawn=StaticMesh'WP_shld_Buckler.sm_Buckler'
	CarryType=ECARRY_LARGE
	CarryLocation=ELOC_BACK
	CarrySocketName=BucklerCarry
	bIsShield=true
}
