class MWProj_Water extends MWProj_Spell;

struct ExplosionFXInf
{
	var Vector Loc;
	var Rotator Rot;
};

var repnotify ExplosionFXInf RepData;

replication
{
	if ( bNetDirty )
		RepData;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'RepData')
	{
		LogAlwaysInternal("REPLICATING - Spawn Splurt@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		Spawn(class'MWSpell_Splurt',,,RepData.Loc,RepData.Rot,,true);	
	}
	super.ReplicatedEvent(VarName);
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if(Role == ROLE_Authority)
	{
		SpawnWaterSplash();
	}
}

simulated function AOCProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal, TraceHitInfo TraceInfo)
{	
}

simulated function SuccessHitMWPawn(MWPawn P)
{
	P.SetPawnOnHeal(HealPS, OwnerPawn.Controller, OwnerPawn);
	bCanExplode=true;
}

simulated function SpawnWaterSplash()
{
	//Spawn(class'MWSpell_WaterSplash',,,Location,Rotation,,true);	
	//WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'MWCONTENT_PFX.Watr_Squirt',self.Location,self.Rotation,,,,true);
	//Spawn(class'MWSpell_Splurt',,,Location,Rotation,,true);
	LogAlwaysInternal("SpawnSplashStart");
	RepData.Loc = Location;
	RepData.Rot = Rotation;

	if(Rotation == rot(0,0,0))
	{
		LogAlwaysInternal("Rejected Spawn");
		return;
	}
	Spawn(class'MWSpell_Splurt',,,Location,Rotation,,true);
	LogAlwaysInternal("SpawnMWSpell_Splurt, Rotation"@Rotation);
}

DefaultProperties
{
	bHitOwner=false
	bIgnoreShield=true
	bAoE=true
	AoETimer=0.05
	bCanExplode=false
	bSmallFlinch=false
	DrawScale=2.0
	AccelRate=0.0
	LifeSpan=10.0
	
	MaxDistance=225

	//ProjFlightTemplate=ParticleSystem'CHV_PartiPack.Particles.P_water_splashy'
			
	NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	Physics=PHYS_Falling
	bBounce=false
	CustomGravityScaling=-100
	bRotationFollowsVelocity=true
	bBlockedByInstigator = true

	bAlwaysRelevant=true
	bNetTemporary=False
		
	Begin Object Name=StaticMeshComponent0
		//StaticMesh=StaticMesh'MWCONTENT.Spell_Void'
		StaticMesh=none
		Scale=1.0
	End Object
	
	//ProjType=EPROJ_Javelin
	//ProjExplosionTemplate=none
	//CheckRadius=36.0
	//AmbientSound=SoundCue'A_Projectile_Flight.Flight_spear'

	//AmbientSound=SoundCue'MWCONTENT_SFX.Fire_ProjectileLoop'
	//ExplSound=SoundCue'MWCONTENT_SFX.Water_HealStart'
	//ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Watr_Hit'
	//ProjExplTemplate=ParticleSystem'CHV_PartiPack.Particles.P_splash_player'
	ProjBlockedSound=none
	//ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Watr_Squirt'

	YawRate = 0.0f
	PitchRate = 0.0f
	RollRate = 0.0f
	fProjectileAttachCompensation=50.f

	ProjCamPosModX=-50
	ProjCamPosModZ=25
	
	bEnableArrowCamAmbientSoundSwap=true
	ArrowCamAmbientSound=SoundCue'A_Projectile_Flight.Flight_jav_Cam'
}


