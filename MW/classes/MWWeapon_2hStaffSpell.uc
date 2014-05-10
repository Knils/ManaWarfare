class MWWeapon_2hStaffSpell extends MWWeapon_StaffSpell;

DefaultProperties
{
	ManaTickAmount=15
	VoidMiniSpread=500
	
	//Void
	Spell[0]=(Damage=12,InitialSpeed=2500.0,MaxSpeed=6000,Radius=0,Charge=1.5,Force=15000.0,Cost=20,Gravity=0,Range=0,Scale=2,Drag=0.0,ProjClass=class'MWProj_VoidSlash',SFXChargeMin=SoundCue'MWCONTENT_SFX.Void_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Void_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Void_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Void_Shot')
	Spell2[0]=(Damage=8,InitialSpeed=1500.0,MaxSpeed=6000,Radius=150,Charge=2.5,Force=0,Cost=25,Gravity=1.5,Range=0,Scale=2,Drag=0.0,ProjClass=class'MWProj_BlackHole',SFXChargeMin=SoundCue'MWCONTENT_SFX.Void_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Void_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Void_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Void_Shot')	
	
	//Spell2[0]=(Damage=15,InitialSpeed=5000.0,MaxSpeed=6000,Radius=210,Charge=2.0,Force=0,Cost=35,Gravity=0,Range=0,Scale=0.9,Drag=0.0,ProjClass=class'MWProj_VoidCloud',SFXChargeMin=VoidCharge1,SFXChargeMax=VoidCharge2,SFXSpellStart=SoundCue'MWCONTENT_SFX.Void_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Void_Shot')
	//OLD: BlackHole Spell2[0]=(Damage=15,InitialSpeed=1500.0,MaxSpeed=6000,Charge=2.0,Cost=25,Gravity=1.5,Scale=4,Drag=0.0,ProjClass=class'MWProj_BlackHole',SFXChargeMin=VoidCharge1,SFXChargeMax=VoidCharge2,SFXSpellStart=SoundCue'MWCONTENT_SFX.Void_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Void_Shot')
	//OLD: Void MultiShotSpell[0]=(Damage=20,InitialSpeed=2250.0,MaxSpeed=6000,Radius=0,Charge=1,Force=15000.0,Cost=20,Gravity=3,Range=0,Scale=0.5,Drag=0.0,ProjClass=class'MWProj_VoidMini',SFXChargeMin=VoidCharge1,SFXChargeMax=VoidCharge2,SFXSpellStart=SoundCue'MWCONTENT_SFX.Void_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Void_Shot')

	//Flame
	Spell[1]=(Damage=6,InitialSpeed=1500.0,MaxSpeed=6000.0,Radius=20,Charge=1.5,Force=0.0,Cost=25,Gravity=0,Range=0,Scale=1,bChannel=true,Drag=0.0,ProjClass=class'MWProj_FlameThrower',SFXChannel=SoundCue'MWCONTENT_SFX.Fire_Cone',SFXChargeMin=SoundCue'MWCONTENT_SFX.Fire_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Fire_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Fire_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Fire_Shot')
	Spell2[1]=(Damage=14,InitialSpeed=1.0,MaxSpeed=2000.0,Radius=150,Charge=2.5,Force=1500,Cost=40,Gravity=0,Range=0,Scale=1,Drag=0.0,ProjClass=class'MWProj_FireArmor',SFXChargeMin=SoundCue'MWCONTENT_SFX.Fire_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Fire_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Fire_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Fire_Shot')
	
	//Earth
	Spell[2]=(Damage=55,InitialSpeed=1100.0,MaxSpeed=2000.0,Radius=5,Charge=3.0,Force=50000.0,Cost=30,Gravity=1.0,Range=0,Scale=0.2,Drag=0.0,ProjClass=class'MWProj_Boulder',SFXChargeMin=SoundCue'MWCONTENT_SFX.Rock_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Rock_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Rock_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Rock_Shot')
	Spell2[2]=(Damage=0,InitialSpeed=1.0,MaxSpeed=2000.0,Radius=1,Charge=2.5,Force=0,Cost=40,Gravity=0,Range=0,Scale=1,Drag=0.0,ProjClass=class'MWProj_RockArmor',SFXChargeMin=SoundCue'MWCONTENT_SFX.Rock_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Rock_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Rock_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Rock_Shot')
	
	//Water	
	Spell[3]=(Damage=5,InitialSpeed=1500.0,MaxSpeed=10000.0,Radius=20,Charge=1.75,Force=0,Cost=20,Gravity=0,Range=0,bChannel=true,Scale=1.75,Drag=0.0,ProjClass=class'MWProj_ConeOfCold',SFXChannel=SoundCue'MWCONTENT_SFX.Watr_Cone',SFXChargeMin=SoundCue'MWCONTENT_SFX.Water_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Water_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Water_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Water_Shot')
	Spell2[3]=(Damage=-12,InitialSpeed=3000.0,MaxSpeed=3000.0,Radius=100,Charge=2.0,Force=0,Cost=25,Gravity=0,Range=0,Scale=1,Drag=0.0,ProjClass=class'MWProj_HealBomb',SFXChargeMin=SoundCue'MWCONTENT_SFX.Water_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Water_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Water_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Water_Shot')
	
	//Electric	
	Spell[4]=(Damage=10,InitialSpeed=3000.0,MaxSpeed=20000.0,Radius=0,Charge=2,Cost=20,Force=0,Gravity=0,Range=0,Scale=1,bChannel=true,Drag=0.0,ProjClass=class'MWProj_Electric',SFXChannel=none,SFXChargeMin=SoundCue'MWCONTENT_SFX.Light_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Light_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Light_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Light_Shot')
	Spell2[4]=(Damage=35,InitialSpeed=2500.0,MaxSpeed=20000.0,Radius=0,Charge=2,Cost=30,Force=20000.0,Gravity=15,Range=0,Scale=1,Drag=0.0,ProjClass=class'MWProj_LightFan',SFXChargeMin=SoundCue'MWCONTENT_SFX.Light_Charge1',SFXChargeMax=SoundCue'MWCONTENT_SFX.Void_Charge2',SFXSpellStart=SoundCue'MWCONTENT_SFX.Light_SpellStart',SFXShot=SoundCue'MWCONTENT_SFX.Light_Shot')

	AllowedShieldClass=none
	//CurrentWeaponType=EWEP_QStaff
	CurrentShieldType=ESHIELD_None
	bHaveShield=false
	WeaponIdentifier="spear"

	CurrentGenWeaponType=EWT_2hand

	bTwoHander=true
	bUseRMMDazed=true
	bUseDirHitAnims=true

	AlternativeMode=class'MWWeapon_2hStaffMelee'
	AttachmentClass=class'MWWeaponAttachment_2hStaffSpell'
	WeaponFontSymbol=","
}
