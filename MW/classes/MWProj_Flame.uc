class MWProj_Flame extends MWProj_Spell;

/**Charge mulitplier*/
var float ChargeMulti;

var vector ColorLevel;
var vector ExplosionColor;

var ParticleSystem          FirePS;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	//SetTimer(0.01,false,'ChargeFunction');
}

simulated function SuccessHitMWPawn(MWPawn P)
{
	P.SetPawnOnFire(FirePS, OwnerPawn.Controller, OwnerPawn,,2);
}

//Modified for flamespawn
simulated function ExplosionEffect()
{
	if(!bHaveExplode && bCanExplode)
	{
		if(Role < ROLE_Authority && OwnerPawn.IsLocallyControlled())
		{			
		}
		else
		{				
			PlaySound(ExplSound,false, true, false);
			Spawn(class'MWSpell_FireImpact',,,Location,,,true);
			bHaveExplode=true;
			//WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplTemplate, self.);
			//SkeletalMeshComponent.AttachComponentToSocket(ProjExplTemplate, TraceEnd);
			//LogAlwaysInternal(ROLE);
			LogAlwaysInternal("EXPLODE @ Location:"@Location);
		}
	}
}

DefaultProperties
{
	FirePS=ParticleSystem'CHV_PartiPack.Particles.P_fire_blazing_grow1_nosmoke'
	//ProjType = EPROJ_Fire

	DrawScale=2.0
	AccelRate=0.0
	LifeSpan=7.0
	CustomGravityScaling=-1.5
	
	//Damage=26
	//DamageRadius=100
	MomentumTransfer=15000.0
	//bWideCheck=true
	CheckRadius=5.0	
	speed=2500.0
	MaxSpeed=6000.0f
	
	bCheckProjectileLight=true
	ProjFlightTemplate=ParticleSystem'WP_bow_Longbow.Particles.P_ArrFire_trail'
	ProjectileLightClass=class'MW.MWLight_ProjFlame'
	//ExplosionLightClass=class'UTShockImpactLight'
	ExplosionLightClass=class'UTGame.UTRocketExplosionLight'
	
	//ExplosionSound=SoundCue'MWCONTENT.SFXCUE_Cig'
	//AmbientSound=SoundCue'MWCONTENT.SFXCUE_Fuse'
	
	//NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	Physics=PHYS_Falling
	bBounce=false
	bRotationFollowsVelocity=true
	//bBlockedByInstigator = true
		
	//ColorLevel=(X=100,Y=1,Z=100)
	//ExplosionColor=(X=100,Y=1,Z=100)

	
	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'MWCONTENT.Spell_Fireball'
		//StaticMesh=none
		Scale=0.5
	End Object
	
	AmbientSound=SoundCue'MWCONTENT_SFX.Fire_ProjectileLoop'
	ExplSound=SoundCue'MWCONTENT_SFX.Fire_Impact'
	ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'	
	
	YawRate = 0.0f
	PitchRate = 0.0f
	RollRate = 0.0f
	//fProjectileAttachCompensation=50.f

	ProjCamPosModX=-50
	ProjCamPosModZ=25
	
	bEnableArrowCamAmbientSoundSwap=true
	ArrowCamAmbientSound=SoundCue'A_Projectile_Flight.Flight_jav_Cam'
}

