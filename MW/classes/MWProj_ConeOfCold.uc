class MWProj_ConeOfCold extends MWProj_Spell;

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
		//LogAlwaysInternal("REPLICATING - MWSpell_ConeOfCold@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
		Spawn(class'MWSpell_ConeOfCold',,,RepData.Loc,RepData.Rot,,true);	
	}
	super.ReplicatedEvent(VarName);
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if(Role == ROLE_Authority)
	{
		SpawnConeOfCold();
	}
}

simulated function AOCProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal, TraceHitInfo TraceInfo)
{}

simulated function SuccessHitMWPawn(MWPawn P)
{
	LogAlwaysInternal("SetPawnOnFreeze");
	P.SetPawnOnFreeze(HealPS, OwnerPawn.Controller, OwnerPawn,,1);	
}

simulated function SpawnConeOfCold()
{
	//Spawn(class'MWSpell_WaterSplash',,,Location,Rotation,,true);	
	//WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'MWCONTENT_PFX.Watr_Squirt',self.Location,self.Rotation,,,,true);
	//Spawn(class'MWSpell_Splurt',,,Location,Rotation,,true);
	//LogAlwaysInternal("MWSpell_ConeOfCold");
	RepData.Loc = Location;
	RepData.Rot = Rotation;

	if(Rotation == rot(0,0,0))
	{
		LogAlwaysInternal("Rejected Spawn");
		return;
	}
	Spawn(class'MWSpell_ConeOfCold',,,Location,Rotation,,true);
	//LogAlwaysInternal("MWSpell_ConeOfCold Rotation"@Rotation);
}

DefaultProperties
{
	bHitOwner=false
	bIgnoreShield=false
	bAoE=true
	AoETimer=0.05
	bCanShutDown=false
	bSuperHurtRadius=false
	//bCanExplode=false
	bSmallFlinch=true
	DrawScale=2.0
	AccelRate=0.0
	LifeSpan=2.0
	
	MaxDistance=300

	//ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Watr_ConeCold'
	//ProjExplosionTemplate=ParticleSystem'MWCONTENT_PFX.Void_P_Explode'
	//ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Watr_Hit'

	Begin Object Name=StaticMeshComponent0
		//StaticMesh=StaticMesh'MWCONTENT.Spell_Void'
		StaticMesh=none
		Scale=0.8
	End Object
}
