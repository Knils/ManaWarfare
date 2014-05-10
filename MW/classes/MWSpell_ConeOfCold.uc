class MWSpell_ConeOfCold extends Actor;

DefaultProperties
{
	LifeSpan=0.75

	Begin Object Class=ParticleSystemComponent Name=Cone
		Template=ParticleSystem'MWCONTENT_PFX.Watr_ConeCold'
		//LightEnvironment=MyLightEnvironment
		bAutoActivate=true
		//Scale3D=(X=0.5,Y=0.5,Z=0.45)
		Translation=(x=50,y=0,z=0)
		Scale=20
		//Rotation=(Pitch=-16384)
	End Object
	Components.Add(Cone)	
}
