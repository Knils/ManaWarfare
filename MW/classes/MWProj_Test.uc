class MWProj_Test extends MWProj_Spell;

DefaultProperties
{
	DrawScale=1.0
	AccelRate=0.0
	LifeSpan=1.5

	//Range=1500
	DamageRadius=100
	MomentumTransfer=60000.0

	//bCanShutDown=false
	//NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	Physics=PHYS_Falling
	bBounce=false
	CustomGravityScaling=15
	bRotationFollowsVelocity=true
	bBlockedByInstigator=true

	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'MWCONTENT.Spell_Void'
		//StaticMesh=none
		Scale=0.8
	End Object
		
	//ProjExplosionTemplate=none
	//CheckRadius=36.0
	//AmbientSound=SoundCue'A_Projectile_Flight.Flight_spear'
	ExplSound=SoundCue'MWCONTENT_SFX.Rock_Burst'
	
	ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'	

	YawRate = 0.0f
	PitchRate = 0.0f
	RollRate = 0.0f
	
	ProjCamPosModX=-50
	ProjCamPosModZ=25
	
	bEnableArrowCamAmbientSoundSwap=true
	ArrowCamAmbientSound=SoundCue'A_Projectile_Flight.Flight_jav_Cam'
}
