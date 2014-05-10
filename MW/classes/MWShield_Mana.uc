class MWShield_Mana extends AOCBaseShield;

DefaultProperties
{
	BlockSound = SoundCue'MWCONTENT_SFX.Shield_Hit'

	ShieldID = ESHIELD_Buckler
	AttachSocketName = BucklerPoint
	ShieldIdentifier="javelin"
	//ShieldIdentifier="buckler"
	//ShieldIdentifier="qstaff"
	
	//ShieldMesh(0)=SkeletalMesh'WP_shld_Buckler.WEP_Buckler_a'
	//ShieldMesh(0)=SkeletalMesh'MWCONTENT.MOD_WEP_ManaShield_pCylinder1'
	//ShieldMesh(1)=SkeletalMesh'MWCONTENT.MOD_WEP_ManaShield_pCylinder1'
	//ShieldMesh(1)=SkeletalMesh'WP_shld_Buckler.WEP_Buckler_m'
	//BlockSound = SoundCue'A_Phys_Mat_Impacts.Buckler_Blocking'
	PhysAsset(0)=PhysicsAsset'WP_shld_Buckler.WEP_Buckler_PKG_Physics'
	PhysAsset(1)=PhysicsAsset'WP_shld_Buckler.WEP_Buckler_PKG_Physics'

	ShieldMesh(0)=SkeletalMesh'MWCONTENT_PFX.SHIELD_WEP_ManaShield_Agatha'
	ShieldMesh(1)=SkeletalMesh'MWCONTENT_PFX.SHIELD_WEP_ManaShield_Mason'

	CustomizationMaterial(0)=none
	CustomizationMaterial(1)=none

	//PlainMaterial(0)=MaterialInstanceConstant'WP_shld_Buckler.M_Buckler_a'
	//PlainMaterial(1)=MaterialInstanceConstant'WP_shld_Buckler.M_Buckler_m'

	//PlainMaterial(0)=MaterialInstanceConstant'CHV_Battlegrounds_Props_PKG.Materials.M_Water_Master_BG'
	//PlainMaterial(1)=MaterialInstanceConstant'CHV_Battlegrounds_Props_PKG.Materials.M_Water_Master_BG'
	
	fShieldDownLength = 0.2f
	fParryNegation = 4f
	fStaminaDrain=3f
	fShieldRaiseCost=5f

	InventoryAttachmentClass(EFAC_MASON)=class'MWInventoryAttachment_ManaShield'
	InventoryAttachmentClass(EFAC_AGATHA)=class'MWInventoryAttachment_ManaShield'
	bUseStaminaBasedHits=true
	CorrespondingShieldWeapon=class'MWWeapon_ManaShield'
}
