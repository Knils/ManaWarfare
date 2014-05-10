class MWSpell_EarthSpike extends Actor;

var int Speed;
var vector RefLocation;
//var int Health;

var vector NewLocation, VectorRotation;
var rotator Rot;

simulated function PostBeginPlay()
{
	//LogAlwaysInternal("EarthSpike@"@Location);
}

Auto simulated state Rising
{
	simulated event BeginState(Name PreviousStateName)
	{
		RefLocation = Location;
		///LogAlwaysInternal("EARTHSPIKE");
		
		Rot = Rotation;
		Rot.Pitch += 16384;
		VectorRotation = vector(Rot);
		
	}
	simulated function tick(float DeltaTime)
	{
		NewLocation = Location;
				
		if(vsize(Newlocation - RefLocation) > 160)
		{
			///LogAlwaysInternal("Done");
			GoToState('Idle');
		}
		else
			NewLocation += VectorRotation*Speed*DeltaTime;
	
		SetLocation(NewLocation);
	}
}

simulated state Idle
{
	simulated event BeginState(Name PreviousStateName)
	{
		SetTimer(LifeSpan-1,false,'Lower');
	}
	simulated event EndState(Name PreviousStateName)
	{
		///LogAlwaysInternal("DESTROY");
		//Components.Add(ParticleSystemComponent0);
		//ShutDown();
	}
	simulated function Lower()
	{
		GoToState('Lowering');
	}
}

simulated state Lowering
{
	simulated event BeginState(Name PreviousStateName)
	{
		RefLocation = Location;
		///LogAlwaysInternal("EARTHSPIKE");
		
		Rot = Rotation;
		Rot.Pitch += 16384;
		VectorRotation = vector(Rot);
		
	}
	simulated function tick(float DeltaTime)
	{
		NewLocation = Location;
				
		if(vsize(Newlocation - RefLocation) > 125)
		{
			ShutDown();
		}
		else
			NewLocation -= VectorRotation*Speed*DeltaTime;
	
		SetLocation(NewLocation);
	}
}

DefaultProperties
{
	//Health=5
	bBlockActors=True
	bCollideActors=True
	bAlwaysRelevant=true
	//bCollideWorld=true
	bWorldGeometry=true
	//Physics=PHYS_RigidBody
		
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=True
		End Object
	Components.Add(MyLightEnvironment)
	
	
	Begin Object Class=StaticMeshComponent Name=EnemyMesh
		StaticMesh=StaticMesh'CHV_CitRocks.SM_straight_spike_rock'
		LightEnvironment=MyLightEnvironment
		Scale3D=(X=0.5,Y=0.5,Z=0.45)
		//Translation=(x=0,y=0,z=-175)
		//Scale=0.5
		//Rotation=(Pitch=-16384)
	End Object
	Components.Add(EnemyMesh)

	Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent0
        Template=ParticleSystem'MWCONTENT_PFX.Rock_P_Burst01'
        bAutoActivate=true
		Scale=6
		Translation=(x=0,y=0,z=50)
		//Rotation=(Roll=-400)
	End Object
	Components.Add(ParticleSystemComponent0)

	LifeSpan=4
	Speed=850
	/*
	Begin Object Name=StaticMeshComponent0
		StaticMesh=none
	End Object
	*/
}