class MWSpell_Splurt extends Actor;

var int Speed;
var vector RefLocation;
//var int Health;

var vector NewLocation, VectorRotation;
var rotator Rot;

Auto simulated state Rising
{
	simulated event BeginState(Name PreviousStateName)
	{
		RefLocation = Location;
		///LogAlwaysInternal("EARTHSPIKE");
		LogAlwaysInternal("MWSpell_Splurt, Rotation"@Rotation);
		Rot = Rotation;
		//Rot.Pitch += 16384;
		VectorRotation = vector(Rot);
		LogAlwaysInternal("VectorRotation"@VectorRotation);
	}
	simulated function tick(float DeltaTime)
	{
		NewLocation = Location;
				
		if(vsize(Newlocation - RefLocation) > 225)
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
}

DefaultProperties
{
	Speed=275
	LifeSpan=5
		
	Begin Object Class=ParticleSystemComponent Name=Splurt
		Template=ParticleSystem'MWCONTENT_PFX.Watr_Squirt'
		//LightEnvironment=MyLightEnvironment
		bAutoActivate=true
		//Scale3D=(X=0.5,Y=0.5,Z=0.45)
		//Translation=(x=0,y=0,z=-175)
		//Scale=0.5
		//Rotation=(Pitch=-16384)
	End Object
	Components.Add(Splurt)	
}
