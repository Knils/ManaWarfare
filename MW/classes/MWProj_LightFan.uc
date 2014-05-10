class MWProj_LightFan extends MWProj_Spell;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	//SetTimer(0.02,true,'SpawnDust');
}

simulated function SpawnDust()
{
	WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplTemplate, self.location);
}

simulated function SuccessHitMWPawn(MWPawn P)
{
	//LogAlwaysInternal("SuccessHitMWPawn"@ROLE);
	//P.SetPawnSpecialDaze(true, EDIR_TOP, true, true, true);	
}

simulated function Bounce(vector HitNormal)
{
	BounceNumber++;
	if(BounceNumber > BounceMax)
		Shutdown();	
	
	if(HitNormal.X > WallNormal || HitNormal.X < -WallNormal || HitNormal.Y > WallNormal || HitNormal.Y < -WallNormal)
	{
		Shutdown();
	}
	else
	{
		Vel = MirrorVectorByNormal(Velocity,HitNormal);
		Velocity.Z = 700;
		Velocity *= 0.85;
	}	
}

DefaultProperties
{
	//bAoE=true
	AoETimer=0.1
	//DamageRadius=80
	BounceMax=4
	WallNormal=0.4
	MomentumTransfer=32000.0

	bCanShutDown=true
	bBounce=true

	Begin Object Name=StaticMeshComponent0
		//StaticMesh=StaticMesh'MWCONTENT.Spell_Void'
		StaticMesh=none
		Scale=1
	End Object

	AmbientSound=SoundCue'MWCONTENT_SFX.Light_ProjectileLoop'
	ExplSound=SoundCue'MWCONTENT_SFX.Light_Hit'
	bCheckProjectileLight=true
	ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Lite_P_Tesla'
	//ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.LITE_P_Pillar01'
	ExplosionLightClass=class'UTShockImpactLight'
	ProjectileLightClass=class'MW.MWLight_ProjFlame'
	//ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Lite_P_Explode'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Lite_P_Explode'
}