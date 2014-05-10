class MWProj_Void extends MWProj_Spell;

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
		bCanShutDown=true;
		Shutdown();
	}
	//LogAlwaysInternal(HitNormal);
	if(HitNormal.X > WallNormal || HitNormal.X < -WallNormal || HitNormal.Y > WallNormal || HitNormal.Y < -WallNormal)
	{
		Velocity = 0.8 * MirrorVectorByNormal(Velocity,HitNormal);
		Velocity.Z = Velocity.Z*0.5 + 650;
	}
	else
	{
		Vel = MirrorVectorByNormal(Velocity,HitNormal);
		Velocity.Z = Vel.Z;
		Velocity.Z = Velocity.Z*0.4 + 700;
		Velocity *= 0.85;
	}
	//LogAlwaysInternal(vsize(velocity)@"*****************************************");
}

DefaultProperties
{
	bCanShutDown=true
	DrawScale=1
	BounceMulti=1.25
	AccelRate=0.0
	LifeSpan=10.0
	BounceMax=4
	ZDampen=0.8
	CustomGravityScaling=5
	WallNormal=0.3
	TraceRadius=5
	//Look
	bOverrideDefaultExplosionDeffect=false
		
	//Damage=26
	DamageRadius=0
	MomentumTransfer=25000.0
	//bWideCheck=true
	//CheckRadius=5.0
	
	/*
	bCheckProjectileLight=true
	ProjectileLightClass=class'TestGame.TestVoidLight'
	//ExplosionLightClass=class'UTGame.UTRocketExplosionLight'
	ExplosionLightClass=class'UTShockImpactLight'
	ExplosionSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	//ImpactSound=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_ImpactCue'
	ImpactSound=SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_JumpBoots_PickupCue'
	//ProjFlightTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Projectile'
	ProjFlightTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball'
	//ProjExplosionTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Impact'
	ProjExplosionTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball_Impact'
	MaxEffectDistance=10000.0

	MyDamageType=class'UTDmgType_LinkPlasma'
	*/

	//ProjFlightTemplate=ParticleSystem''
	/*
	TipPS=ParticleSystem'WP_bow_Longbow.Particles.P_ArrFire_static'
	Begin Object Class=UTParticleSystemComponent Name=FirePartiSysComp
		Template=ParticleSystem'WP_bow_Longbow.Particles.P_ArrFire_static'
		Translation=(X=67.f)
		bAutoActivate=true
	End Object
	bHasTipComp=true
	Components.Add(FirePartiSysComp)
	*/
	
	bCheckProjectileLight=true
	ProjectileLightClass=class'MW.MWLight_ProjVoid'
	ExplosionLightClass=class'UTShockImpactLight'
	//ExplosionLightClass=class'UTGame.UTRocketExplosionLight'
	ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Void_P_Sphere'
	//ProjExplosionTemplate=ParticleSystem'MWCONTENT_PFX.Void_P_Explode'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Void_P_Explode'
	//AttachmentMesh=SkeletalMesh'WP_bow_Longbow.Meshes.WEP_firearrow'
		
	//ProjFlightTemplate=ParticleSystem'WP_bow_Longbow.Particles.P_ArrFire_trail'

	NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	Physics=PHYS_Falling
	bBounce=true
	bRotationFollowsVelocity=true
	bBlockedByInstigator = true
		
	//ColorLevel=(X=100,Y=1,Z=100)
	//ExplosionColor=(X=100,Y=1,Z=100)
	
	Begin Object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'MWCONTENT.Spell_Void'
		//StaticMesh=none
		Scale=0.8
	End Object
	

	//ProjType=EPROJ_Javelin
	//CheckRadius=36.0
	//AmbientSound=SoundCue'A_Projectile_Flight.Flight_spear'
	AmbientSound=SoundCue'MWCONTENT_SFX.Void_ProjectileLoop'
	ExplSound=SoundCue'MWCONTENT_SFX.Void_Explode'
	
	ImpactSounds= {(
		Light=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Medium=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Heavy=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Stone=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Dirt=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Wood=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Gravel=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Foliage=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Sand=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Water=SoundCue'MWCONTENT_SFX.Void_Bounce',
		ShallowWater=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Metal=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Snow=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Ice=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Mud=SoundCue'MWCONTENT_SFX.Void_Bounce',
		Tile=SoundCue'MWCONTENT_SFX.Void_Bounce'
		)}
	ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'	

	YawRate = 0.0f
	PitchRate = 0.0f
	RollRate = 0.0f
	fProjectileAttachCompensation=50.f

	ProjCamPosModX=-50
	ProjCamPosModZ=25
	
	//bEnableArrowCamAmbientSoundSwap=true
	//ArrowCamAmbientSound=SoundCue'A_Projectile_Flight.Flight_jav_Cam'
}

