class MWProj_Earthquake extends MWProj_Spell;

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
	LogAlwaysInternal("SuccessHitMWPawn"@ROLE);
	P.SetPawnSpecialDaze(true, EDIR_TOP, true, true, true);	
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

simulated function ExplosionEffect()
{
	if(!bHaveExplode && bCanExplode)
	{
		if(Role < ROLE_Authority && OwnerPawn.IsLocallyControlled())
		{
			//LogAlwaysInternal("PROXY DENIED");
		}
		else
		{				
			PlaySound(ExplSound,false, true, false);
			WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplTemplate, self.location,,,,,true);
			bHaveExplode=true;
			//WorldInfo.MyEmitterPool.SpawnEmitter(ProjExplTemplate, self.);
			//SkeletalMeshComponent.AttachComponentToSocket(ProjExplTemplate, TraceEnd);
			//LogAlwaysInternal(ROLE);
			//LogAlwaysInternal("EXPLODE" @ Location);
		}
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

	ExplSound=SoundCue'MWCONTENT_SFX.Rock_Alt'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Rock_GustExpire'
	ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Rock_Gust'
}
