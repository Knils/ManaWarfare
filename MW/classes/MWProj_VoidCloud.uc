class MWProj_VoidCloud extends MWProj_Spell;

var vector RefLocation;
var int Range;
var bool bRun;

simulated event Tick( float DeltaTime)
{
	super.Tick(DeltaTime);
	if(!bRun)
	{
		RefLocation = Location;
		bRun = true;
	}

	if(vsize(Location - RefLocation) >= Range)
	{
		Stick();
	}
}

simulated function Bounce(vector HitNormal)
{
	Stick();
}

simulated function Stick()
{
	if(vsize(velocity) != 0)
		Velocity = vect(0,0,0);
	SetTimer(0.99,true,'TimerExplode');
	SetTimer(5.0,false,'ClearTimers');
}

simulated function TimerExplode()
{
	local vector HitNormal;

	AoE( Location, HitNormal );
}

simulated function ClearTimers()
{
	ClearTimer('TimerExplode');
}

DefaultProperties
{
	bAoEOnce=false
	bSmallFlinch=true
	DrawScale=5
	LifeSpan=10.0
	DamageRadius=250
	//MomentumTransfer=10000.0
	Range=2000
	
	bCanShutDown=false
	//bCheckProjectileLight=true
	bBounce=true
	//ProjectileLightClass=class'MW.MWLight_ProjVoid'
	//ExplosionLightClass=class'UTShockImpactLight'
	//ExplosionLightClass=class'UTGame.UTRocketExplosionLight'
	//ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Void_P_Sphere'
	//ProjExplosionTemplate=ParticleSystem'MWCONTENT_PFX.Void_P_Explode'
	//ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Void_Alt'
	ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Void_Alt'
	AmbientSound=SoundCue'MWCONTENT_SFX.Void_Alt'

	//AmbientSound=SoundCue'MWCONTENT_SFX.Void_ProjectileLoop'
	//ExplSound=SoundCue'MWCONTENT_SFX.Void_Alt_Out'
	//ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'
}
