class MWSpell_FireBombExplode extends Actor;

DefaultProperties
{
	Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent0
        Template=ParticleSystem'CHV_PartiPack.Particles.P_Fire_Burst'
        bAutoActivate=true
		//Scale3D=(X=0.6,Y=1,Z=1)
		Scale=0.75
		//Translation=(x=60,y=-10)
		//Rotation=(Roll=-400
	End Object
	Components.Add(ParticleSystemComponent0)

	LifeSpan=0.65
}
