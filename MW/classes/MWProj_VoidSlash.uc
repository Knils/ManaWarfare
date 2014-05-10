class MWProj_VoidSlash extends MWProj_Spell;

simulated function tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	SetRotation(Rotator(Velocity));
}

DefaultProperties
{
	bCheckProjectileLight=true
	ProjectileLightClass=class'MW.MWLight_ProjVoid'
	ExplosionLightClass=class'UTShockImpactLight'
	ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Void_Hadouken'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Void_P_Explode'

	AmbientSound=SoundCue'MWCONTENT_SFX.Void_Hadouken_plp'
	ExplSound=SoundCue'MWCONTENT_SFX.Void_Hadouken_imp'

	ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'	

	Begin Object Name=StaticMeshComponent0
		//StaticMesh=SkeletalMesh'MWCONTENT_PFX.MOD_WEP_Hadouken'
		StaticMesh=none
		Scale=0.8
	End Object

	Begin Object Class=SkeletalMeshComponent Name=Slash
		Rotation=(Yaw=16384)//(Pitch=-16384)
		Scale3D=(X=0.8,Y=1,Z=1.2)
		SkeletalMesh=SkeletalMesh'MWCONTENT_PFX.MOD_WEP_Hadouken'
	End Object
	Components.Add(Slash)
}
