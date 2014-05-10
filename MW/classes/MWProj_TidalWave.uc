class MWProj_TidalWave extends MWProj_Spell;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

simulated function Bounce(vector HitNormal)
{
	/*Alt
	Vel = MirrorVectorByNormal(Velocity,HitNormal);
	Velocity.Z = Vel.Z;
	Velocity.Z = Velocity.Z*0.3 + 700;
	Velocity *= BounceMulti;
	*/
	BounceNumber++;
	if(BounceNumber > BounceMax)
	{
		bCanShutDown = true;
		Shutdown();	
	}
	//LogAlwaysInternal(HitNormal);
	if(HitNormal.X > WallNormal || HitNormal.X < -WallNormal || HitNormal.Y > WallNormal || HitNormal.Y < -WallNormal)
	{
		bCanShutDown = true;
		Shutdown();	
	}
	else
	{
		Vel = MirrorVectorByNormal(Velocity,HitNormal);
		//Velocity.Z = Vel.Z;
		//Velocity.Z = Velocity.Z*0.4 + 700;
		Velocity.Z = 700;
		Velocity *= 0.85;
	}
	//LogAlwaysInternal(vsize(velocity)@"*****************************************");
}

DefaultProperties
{
	bAoEOnce=false
	bCanShutDown=false
	bSmallFlinch=true
	DrawScale=1.1
	BounceMulti=1.25
	AccelRate=0.0
	LifeSpan=20.0
	BounceMax=4
	ZDampen=0.8
	CustomGravityScaling=5
	WallNormal=0.4
	//Look
	bOverrideDefaultExplosionDeffect=false
		
	bAoE=true
	AoETimer=0.05
	DamageRadius=80
	MomentumTransfer=80000.0
	//bWideCheck=true
	//CheckRadius=5.0
	
	bCheckProjectileLight=true
	//ProjectileLightClass=class'MW.MWLight_ProjVoid'
	//ExplosionLightClass=class'UTShockImpactLight'
	//ExplosionLightClass=class'UTGame.UTRocketExplosionLight'
	ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Watr_Wave'
	//ProjExplosionTemplate=ParticleSystem'MWCONTENT_PFX.Void_P_Explode'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Watr_Wave'
	//AttachmentMesh=SkeletalMesh'WP_bow_Longbow.Meshes.WEP_firearrow'
		
	//ProjFlightTemplate=ParticleSystem'WP_bow_Longbow.Particles.P_ArrFire_trail'

	NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	Physics=PHYS_Falling
	bBounce=true
	bRotationFollowsVelocity=false
	bBlockedByInstigator = true
		
	//ColorLevel=(X=100,Y=1,Z=100)
	//ExplosionColor=(X=100,Y=1,Z=100)
	
	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'MWCONTENT_PFX.P_MOD_TidalWave'
		Scale=5
		Rotation=(Yaw=-16384)
	End Object
	
	//CheckRadius=36.0
	//AmbientSound=SoundCue'A_Projectile_Flight.Flight_spear'
	//AmbientSound=SoundCue'MWCONTENT_SFX.Void_ProjectileLoop'

	ExplSound=SoundCue'MWCONTENT_SFX.Watr_AltHit'	
	ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'	

	YawRate = 0.0f
	PitchRate = 0.0f
	RollRate = 0.0f
	fProjectileAttachCompensation=50.f

	ProjCamPosModX=-50
	ProjCamPosModZ=25
	
	bEnableArrowCamAmbientSoundSwap=true
	ArrowCamAmbientSound=SoundCue'A_Projectile_Flight.Flight_jav_Cam'
}

