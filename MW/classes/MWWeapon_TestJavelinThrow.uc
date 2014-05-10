class MWWeapon_TestJavelinThrow extends AOCWeapon_JavelinThrow;

var float ChargePercent, ChargeTime;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	LogAlwaysInternal("Throw");
}

simulated state Hold
{
	simulated event BeginState(Name PreviousStateName)
	{
		LogAlwaysInternal("HOLD");
		Super.BeginState(PreviousStateName);
		///LogAlwaysInternal("HOLD");
		//bManaRegen = false;
		//SFXChargeMin.FadeIn(0.1,1);
		//SFXChargeMin.Play();
		ChargePercent=0;
	}

	//Spell charge
	simulated event Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
				
		if(ChargePercent < 1)
		{
			
			ChargePercent = FMin(ChargePercent + (DeltaTime/ChargeTime),1);
			LogAlwaysInternal(ChargePercent);
			if(ChargePercent == 1)
			{
				//SFXChargeMin.Stop();
				//SFXChargeMax.Play();
			}
		}
	}
}

DefaultProperties
{
	ChargeTime=1
	AlternativeMode=class'MWWeapon_TestJavMelee'
}
