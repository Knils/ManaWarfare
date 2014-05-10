class MWSpell_WaterSplash extends Actor;

var ParticleSystemComponent Water;

DefaultProperties
{
	Begin Object Class=ParticleSystemComponent Name=ParticleSystemComponent0
        Template=ParticleSystem'CHV_PartiPack.Particles.P_water_splashy'
        bAutoActivate=true
		Scale3D=(X=0.6,Y=1,Z=1)
		Translation=(x=60,y=-10)
		//Rotation=(Roll=-400)
	End Object
	Water=ParticleSystemComponent0
	Components.Add(ParticleSystemComponent0)

	LifeSpan=0.7
}
