class MWProj_BlackHole extends MWProj_Spell;

simulated function Bounce(vector HitNormal)
{
	CustomGravityScaling=0;
	velocity = MirrorVectorByNormal(Velocity,HitNormal)/2;
	SetTimer(0.225,false,'Stick');
}

simulated function Stick()
{
	if(vsize(velocity) != 0)
		Velocity = vect(0,0,0);
	SetTimer(0.65,true,'TimerExplode');
}

simulated function TimerExplode()
{
	local vector HitNormal;

	AoE( Location, HitNormal );
}

DefaultProperties
{
	LifeSpan=5.0
	bSuckIn=true
	//DrawScale=5	
	//DamageRadius=220
	//MomentumTransfer=10000.0
	bHitOwner=true
	bSmallFlinch=true
	bAoEOnce=false
	bCanShutDown=false
	bCheckProjectileLight=true
	bBounce=true
	ProjectileLightClass=class'MW.MWLight_ProjVoid'
	//ExplosionLightClass=class'UTShockImpactLight'
	//ExplosionLightClass=class'UTGame.UTRocketExplosionLight'
	ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Void_BlackHole'
	//ProjExplosionTemplate=ParticleSystem'MWCONTENT_PFX.Void_P_Explode'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Void_P_Explode'

	AmbientSound=SoundCue'MWCONTENT_SFX.Void_ProjectileLoop'
	ExplSound=SoundCue'MWCONTENT_SFX.Void_Alt_Out'
	ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'	

	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'MWCONTENT.Spell_Void'
		//StaticMesh=none
		Scale=3
	End Object

	ImpactSounds= {(
		Light=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Medium=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Heavy=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Stone=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Dirt=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Wood=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Gravel=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Foliage=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Sand=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Water=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		ShallowWater=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Metal=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Snow=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Ice=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Mud=SoundCue'MWCONTENT_SFX.Void_Alt_In',
		Tile=SoundCue'MWCONTENT_SFX.Void_Alt_In'
		)}
}
