class MWWeapon_Half_Greatsword extends AOCWeapon_Bill;

DefaultProperties
{
	ImpactSounds(ESWINGSOUND_Slash)={(
		light=SoundCue'A_Impacts_Melee.Light_Slash_large',
		medium=SoundCue'A_Impacts_Melee.Medium_Slash_large',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Slash_large',
		wood=SoundCue'A_Phys_Mat_Impacts.Greatsword_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Greatsword_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Greatsword_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Greatsword_Stone')}

	ImpactSounds(ESWINGSOUND_SlashCombo)={(
		light=SoundCue'A_Impacts_Melee.Light_Slash_large',
		medium=SoundCue'A_Impacts_Melee.Medium_Slash_large',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Slash_large',
		wood=SoundCue'A_Phys_Mat_Impacts.Greatsword_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Greatsword_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Greatsword_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Greatsword_Stone')}

	ImpactSounds(ESWINGSOUND_Stab)={(
		light=SoundCue'A_Impacts_Melee.Light_stab_large',
		medium=SoundCue'A_Impacts_Melee.Medium_stab_large',
		heavy=SoundCue'A_Impacts_Melee.Heavy_stab_large',
		wood=SoundCue'A_Phys_Mat_Impacts.Greatsword_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Greatsword_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Greatsword_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Greatsword_Stone')}

	ImpactSounds(ESWINGSOUND_StabCombo)={(
		light=SoundCue'A_Impacts_Melee.Light_stab_Small',
		medium=SoundCue'A_Impacts_Melee.Medium_stab_Small',
		heavy=SoundCue'A_Impacts_Melee.Heavy_stab_Small',
		wood=SoundCue'A_Phys_Mat_Impacts.Greatsword_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Greatsword_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Greatsword_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Greatsword_Stone')}


	ImpactSounds(ESWINGSOUND_Overhead)={(
		light=SoundCue'A_Impacts_Melee.Light_Chop_large',
		medium=SoundCue'A_Impacts_Melee.Medium_Chop_large',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Chop_large',
		wood=SoundCue'A_Phys_Mat_Impacts.Greatsword_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Greatsword_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Greatsword_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Greatsword_Stone')}

	ImpactSounds(ESWINGSOUND_OverheadCombo)={(
		light=SoundCue'A_Impacts_Melee.Light_Chop_large',
		medium=SoundCue'A_Impacts_Melee.Medium_Chop_large',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Chop_large',
		wood=SoundCue'A_Phys_Mat_Impacts.Greatsword_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Greatsword_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Greatsword_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Greatsword_Stone')}

	ImpactSounds(ESWINGSOUND_Sprint)={(
		light=SoundCue'A_Impacts_Melee.Light_Chop_Large',
		medium=SoundCue'A_Impacts_Melee.Medium_Chop_Large',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Chop_Large',
		wood=SoundCue'A_Phys_Mat_Impacts.Greatsword_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Greatsword_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Greatsword_metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Greatsword_Stone')}

	ImpactSounds(ESWINGSOUND_Shove)={(
		light=SoundCue'A_Impacts_Melee.Light_Kick_Small',
		medium=SoundCue'A_Impacts_Melee.Medium_Kick_Small',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Kick_Small',
		wood=SoundCue'A_Phys_Mat_Impacts.Kick_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Kick_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Kick_Metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Kick_Stone')}

	ImpactSounds(ESWINGSOUND_ShoveCombo)={(
		light=SoundCue'A_Impacts_Melee.Light_Kick_Small',
		medium=SoundCue'A_Impacts_Melee.Medium_Kick_Small',
		heavy=SoundCue'A_Impacts_Melee.Heavy_Kick_Small',
		wood=SoundCue'A_Phys_Mat_Impacts.Kick_Wood',
		dirt=SoundCue'A_Phys_Mat_Impacts.Kick_Dirt',
		metal=SoundCue'A_Phys_Mat_Impacts.Kick_Metal',
		stone=SoundCue'A_Phys_Mat_Impacts.Kick_Stone')}

	ParriedSound=SoundCue'A_Phys_Mat_Impacts.Greatsword_Blocked'
	ParrySound=SoundCue'A_Phys_Mat_Impacts.Greatsword_Blocking'

	//bIgnoreAlternate=false
	AttachmentClass=class'MWWeaponAttachment_Half_Greatsword'
	
	AlternativeMode=class'MWWeapon_Greatsword'
	InventoryAttachmentClass=none

	WeaponFontSymbol="b"
}

