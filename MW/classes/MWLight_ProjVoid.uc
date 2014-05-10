class MWLight_ProjVoid extends UDKExplosionLight;

defaultproperties
{
	HighDetailFrameTime=+0.02
	Brightness=2
	Radius=192
	LightColor=(R=255,G=255,B=255,A=255)

	TimeShift=((StartTime=0.0,Radius=192,Brightness=8,LightColor=(R=192,G=50,B=192,A=0)),(StartTime=2.0,Radius=128,Brightness=5,LightColor=(R=255,G=1,B=192,A=1)),(StartTime=2.5,Radius=128,Brightness=12,LightColor=(R=255,G=255,B=192,A=255)))
}