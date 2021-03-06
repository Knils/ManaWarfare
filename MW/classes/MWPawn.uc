//Earth less lighting no jump/dodge, less overall damage taken minor speed penalty
//Water is healing, extra lighting damage, puts out fire
//Freeze is a slow, that is put out by fire.
//Test
class MWPawn extends AOCPawn;

var repnotify bool bIsHealing, bIsFreezing, bIsRocking, bIsFlaming, bLoopSound; //Buffs/Debuffs
var int HealDamage, Heal;
var AudioComponent HealLoop, SFXComponent;
var SoundCue SFXCue;
var ParticleSystemComponent ElementPSComp;
var float BuffDuration;

struct BuffInfo
{
	var ParticleSystem PS;
	var SoundCue Start;
	var SoundCue Loop;
	var SoundCue Stop;
};

//var BuffInfo Heal;
//var BuffInfo Freeze;
//var BuffInfo Rock;
//var BuffInfo Flame;

replication
{
	if ( bNetDirty )
		bIsHealing, bIsRocking, bIsFreezing, bIsFlaming, bLoopSound, SFXCue;
}

simulated event ReplicatedEvent(name VarName)
{
	/*
	if ( VarName == 'HealStatus' )
	{
		bIsHealing = HealStatus != EHeal_None;
		HandleParticles(bIsHealing, ParticleSystem'MWCONTENT_PFX.Watr_HealLoop');
		PlayBuffSFX(bIsHealing, SoundCue'MWCONTENT_SFX.Water_HealStart', SoundCue'MWCONTENT_SFX.Water_HealLoop', SoundCue'MWCONTENT_SFX.Water_HealStop');
	}
	if ( VarName == 'BuffStatus' )
	{
		bIsFreezing = BuffStatus == EBuff_Ice;

		HandleParticles(bIsFreezing, ParticleSystem'MWCONTENT_PFX.Watr_Debuff');
		PlayBuffSFX(bIsFreezing, SoundCue'MWCONTENT_SFX.Water_HealStart', SoundCue'MWCONTENT_SFX.Water_HealLoop', SoundCue'MWCONTENT_SFX.Water_HealStop');
		
	}*/
	if ( VarName == 'bIsHealing' )
	{
		HandleParticles(bIsHealing, ParticleSystem'MWCONTENT_PFX.Watr_HealLoop');
		PlayBuffSFX(bIsHealing, SoundCue'MWCONTENT_SFX.Water_HealStart', SoundCue'MWCONTENT_SFX.Water_HealLoop', SoundCue'MWCONTENT_SFX.Water_HealStop');
	}
	if ( VarName == 'bIsFreezing' )
	{
		HandleParticles(bIsFreezing, ParticleSystem'MWCONTENT_PFX.Watr_Debuff');
		PlayBuffSFX(bIsFreezing, SoundCue'MWCONTENT_SFX.Watr_Debuff', SoundCue'MWCONTENT_SFX.Watr_DebuffLoop', SoundCue'MWCONTENT_SFX.Watr_Debuffoff');		
	}
	if ( VarName == 'bIsRocking' )
	{
		HandleParticles(bIsRocking, ParticleSystem'MWCONTENT_PFX.Rock_Debuff');
		PlayBuffSFX(bIsRocking, SoundCue'MWCONTENT_SFX.Rock_Stoneskin_On', none, SoundCue'MWCONTENT_SFX.Rock_Stoneskin_Off');		
	}
	if ( VarName == 'bIsFlaming' )
	{
		HandleParticles(bIsFlaming, ParticleSystem'MWCONTENT_PFX.Fire_Shld');
		PlayBuffSFX(bIsFlaming, SoundCue'MWCONTENT_SFX.Fire_Shieldstart', SoundCue'MWCONTENT_SFX.Fire_Shld', SoundCue'MWCONTENT_SFX.Fire_Shieldstop');		
	}
	if ( VarName == 'bLoopSound' )
	{
		PlayLoopSound(bLoopSound);
	}
	super.ReplicatedEvent( VarName );
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	//SetTimer(1,true,'AttachElementParticles');
}

simulated function ReplicateLoopSound(bool b, SoundCue SC)
{
	//LogAlwaysInternal(AC);
	
	SFXCue = SC;
	If(bLoopSound && b)
	{
		bLoopSound = false;
		SetTimer(0.05,false,'LoopSoundTrue');
	}
	else
		bLoopSound = b;
	//SFXComponent = AC;
	//SFXComponent = FireCone;	
}

simulated function LoopSoundTrue()
{
	bLoopSound = true;
}

simulated function PlayLoopSound(bool bIng)
{
	//local SoundCue SFX;

	if (bIng)
	{
		//SFX = AC;

		if (SFXComponent != none)
			SFXComponent.Stop();
		//PlaySound(Start,false, true, true);
		SFXComponent = CreateAudioComponent(SFXCue, false, true);
		//SFXComponent = AC;
		SFXComponent.Play();
		
		//SetTimer(fireSFX.Duration, true, 'reactivateHealSFX');
		//SetTimer(BuffDuration, false, 'reactivateHealSFX');
	}
	else
	{
		SFXComponent.FadeOut(1.0f, 0.0f);
		//PlaySound(Stop,false, true, true);
	}	
}

simulated function AttachElementParticles()
{
	if(PawnInfo.myTertiary != none)
	{
		ElementPSComp = new(self) class'UTParticleSystemComponent';
		ElementPSComp.bAutoActivate = true;
		
		//Mesh.AttachComponentToSocket(ElementPSComp, 'JavelinPoint');	
		//Mesh.AttachComponentToSocket(ElementPSComp, 'WeaponPoint');
	
		if(PawnInfo.myTertiary == class'MWWeapon_ProjVoid')
		{
			ElementPSComp.SetTemplate(ParticleSystem'MWCONTENT_3D.Staff_Effect_Void');
		}
		else if(PawnInfo.myTertiary == class'MWWeapon_ProjFlame')
		{
		}
		else if(PawnInfo.myTertiary == class'MWWeapon_ProjEarth')
		{
		}
		else if(PawnInfo.myTertiary == class'MWWeapon_ProjWater')
		{
		}	
		else if(PawnInfo.myTertiary == class'MWWeapon_ProjElectric')
		{
		}
	
		ElementPSComp.ActivateSystem(true);
		Mesh.AttachComponent(ElementPSComp, 'b_r_wrist');
		ClearTimer('AttachElementParticles');
	}
}

//Daze
simulated function SetPawnSpecialDaze(bool bFullBody, EDirection Direction, bool bGeneric, bool bSpecial, bool bTwoHander)
{
	Server_SetPawnSpecialDaze(bFullBody, Direction, bGeneric, bSpecial, bTwoHander);
	Client_SetPawnSpecialDaze(bFullBody, Direction, bGeneric, bSpecial, bTwoHander);
}

reliable server function Server_SetPawnSpecialDaze(bool bFullBody, EDirection Direction, bool bGeneric, bool bSpecial, bool bTwoHander)
{
	LogAlwaysInternal("Server_SetPawnSpecialDaze"@Role);
	AOCWeapon(Weapon).ActivateFlinch(bFullBody, Direction, bGeneric, bSpecial, bTwoHander);	
}

reliable client function Client_SetPawnSpecialDaze(bool bFullBody, EDirection Direction, bool bGeneric, bool bSpecial, bool bTwoHander)
{
	LogAlwaysInternal("Client_SetPawnSpecialDaze"@Role);
	AOCWeapon(Weapon).ActivateFlinch(bFullBody, Direction, bGeneric, bSpecial, bTwoHander);	
}

simulated function TakeRadiusDamage
(
	Controller			InstigatedBy,
	float				BaseDamage,
	float				DamageRadius,
	class<DamageType>	DamageType,
	float				Momentum,
	vector				HurtOrigin,
	bool				bFullDamage,
	Actor               DamageCauser,
	optional float      DamageFalloffExponent=1.f
)
{
	local float		ColRadius, ColHeight;
	local float		DamageScale, Dist, ScaledDamage;
	local vector	Dir;

	LogAlwaysInternal("TakeRadiusDamage");

	GetBoundingCylinder(ColRadius, ColHeight);

	Dir	= Location - HurtOrigin;
	Dist = VSize(Dir);
	Dir	= Normal(Dir);

	if ( bFullDamage )
	{
		DamageScale = 1.f;
	}
	else
	{
		Dist = FMax(Dist - ColRadius,0.f);
		DamageScale = FClamp(1.f - Dist/DamageRadius, 0.f, 1.f);
		DamageScale = DamageScale ** DamageFalloffExponent;
	}

	if (DamageScale > 0.f)
	{
		ScaledDamage = DamageScale * BaseDamage;
		TakeDamage
		(
			ScaledDamage,
			InstigatedBy,
			Location - 0.5f * (ColHeight + ColRadius) * Dir,
			(DamageScale * Momentum * Dir),
			DamageType,,
			DamageCauser
		);
	}
}

event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo myHitInfo, optional Actor DamageCauser)
{
	LogAlwaysInternal("TakeDamage_____________");
	if(bIsRocking)
	{
		Damage *= 0.8;
		Momentum *= 0.3;
	}
	if(Damage <= 0)
	{
		Heal = Damage * -1;
		if ((PawnState == ESTATE_PUSH) && AOCPlayerController(InstigatedBy) == none)
			return;
	
		if(AOCPRI(PlayerReplicationInfo).CurrentHealth + Heal >= 100)
		{
			AOCPRI(PlayerReplicationInfo).CurrentHealth = 100;
			Health = 100;
		}
		else
		{
			AOCPRI(PlayerReplicationInfo).CurrentHealth += Heal;
			Health += Heal;
		}
		AOCPRI(PlayerReplicationInfo).bForceNetUpdate = true;
		///LogAlwaysInternal(Heal @ AOCPRI(PlayerReplicationInfo).CurrentHealth @ Health);
		// Notify Controller
		if(AOCPlayerController(Controller) != none)
		{
			//AOCPlayerController(Controller).NotifyPawnTookHit();
		}

		// Sometimes TakeDamage is called and is not routed through AttackOtherPawn. Oh well. Watchoo gonna do.
		ReplicatedHitInfo.DamageType = class<AOCDamageType>(DamageType);

		AOCGame(WorldInfo.Game).DisplayDebugDamage(self, DamageCauser == none?InstigatedBy.Pawn:DamageCauser, EDAM_Health, Damage);
		
		super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, myHitInfo, DamageCauser);
	}
	else
	{
		//Buff Multiplier
		if(ReplicatedHitInfo.DamageString == "J" && bIsHealing)
		{
			LogAlwaysInternal("Lightning Damage Enhanced");
			Damage *= 1.2;		
		}
		if(ReplicatedHitInfo.DamageString == "J" && bIsRocking)
		{
			Damage *= 0.8;
		}
		
		if(AOCPRI(PlayerReplicationInfo).CurrentHealth - Damage <= 0)
		{
			ClearBuffs();
		}

		super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, myHitInfo, DamageCauser);
	}
}

simulated function ClearBuffs()
{	
	if(bIsFreezing)
	{
		bIsFreezing = false;
		HandleParticles(bIsFreezing, ParticleSystem'MWCONTENT_PFX.Watr_Debuff');
		PlayBuffSFX(bIsFreezing, SoundCue'MWCONTENT_SFX.Watr_Debuff', SoundCue'MWCONTENT_SFX.Watr_DebuffLoop', SoundCue'MWCONTENT_SFX.Watr_Debuffoff');			
	}
	If(bIsHealing)
	{
		bIsHealing = false;
		HandleParticles(bIsHealing, ParticleSystem'MWCONTENT_PFX.Watr_HealLoop');
		PlayBuffSFX(bIsHealing, SoundCue'MWCONTENT_SFX.Water_HealStart', SoundCue'MWCONTENT_SFX.Water_HealLoop', SoundCue'MWCONTENT_SFX.Water_HealStop');			
	}
	If(bIsRocking)
	{
		bIsRocking = false;
		HandleParticles(bIsRocking, ParticleSystem'MWCONTENT_PFX.Rock_Debuff');
		PlayBuffSFX(bIsRocking, SoundCue'MWCONTENT_SFX.Rock_Stoneskin_On', none, SoundCue'MWCONTENT_SFX.Rock_Stoneskin_Off');			
	}
	If(bIsFlaming)
	{
		bIsFlaming = false;
		HandleParticles(bIsFlaming, ParticleSystem'MWCONTENT_PFX.Fire_Shld');
		PlayBuffSFX(bIsFlaming, SoundCue'MWCONTENT_SFX.Fire_Shieldstart', SoundCue'MWCONTENT_SFX.Fire_Shld', SoundCue'MWCONTENT_SFX.Fire_Shieldstop');			
	}
	//bIsBurning=false;	
}

simulated function SetPawnOnFire(ParticleSystem FirePS, Controller Cont, optional Actor InflictedBy = none, optional class<AOCDamageType> dmgType = none, optional float OverrideTime = 0.0f)
{
	if(bIsFreezing)
	{
		StopFreezeOnPawn();
	}
	super.SetPawnOnFire(FirePS,Cont,InflictedBy,dmgType,OverrideTime);
}

simulated function SetPawnOnFlame(ParticleSystem FirePS, Controller Cont, optional Actor InflictedBy = none, optional class<AOCDamageType> dmgType = none, optional float OverrideTime = 0.0f)
{
	LogAlwaysInternal("Flame");

	if (Role == ROLE_Authority && !bIsFlaming)
	{
		bIsFlaming=true;
		
		if (WorldInfo.NetMode == NM_STANDALONE)
		{
			HandleParticles(bIsFlaming, ParticleSystem'MWCONTENT_PFX.Fire_Shld');
		}
	}
	if(OverrideTime > 0)
	{
		SetTimer(OverrideTime, false, 'StopFlameOnPawn');
	}
	else
	{
		SetTimer(2, false, 'StopFlameOnPawn');
	}
}

simulated function SetPawnOnRock(ParticleSystem FirePS, Controller Cont, optional Actor InflictedBy = none, optional class<AOCDamageType> dmgType = none, optional float OverrideTime = 0.0f)
{
	LogAlwaysInternal("Rock");

	if (Role == ROLE_Authority && !bIsRocking)
	{
		bIsRocking=true;
		
		if (WorldInfo.NetMode == NM_STANDALONE)
		{
			HandleParticles(bIsRocking, ParticleSystem'MWCONTENT_PFX.Rock_Debuff');
		}
	}
	if(OverrideTime > 0)
	{
		SetTimer(OverrideTime, false, 'StopRockOnPawn');
	}
	else
	{
		SetTimer(2, false, 'StopRockOnPawn');
	}
}

/*
function StartSprintLockOut(float F)
{
	if(IsTimerActive('EndSprintRecovery'))
	{
		ClearTimer('EndSprintRecovery');
	}
	bForceNoSprint = true;
	SetTimer(f, false, 'EndSprintRecovery');
}

function EndSprintRecovery()
{
	bForceNoSprint = false;
}
*/
simulated function SetPawnOnFreeze(ParticleSystem FirePS, Controller Cont, optional Actor InflictedBy = none, optional class<AOCDamageType> dmgType = none, optional float OverrideTime = 0.0f)
{
	LogAlwaysInternal("Freeze");

	if (Role == ROLE_Authority && !bIsFreezing)
	{
		bIsFreezing=true;
		//AddDebuff(false, EDEBF_ATTACK, 1.0f - AttackDebuff, -1.0f, false);

		//RemoveDebuff(EDEBF_SPRINT);
		//AddDebuff(true, EDEBF_SPRINT, 1.3f, OverrideTime, false);
		//AddDebuff(false, EDEBF_DRAFT, 1.2f, OverrideTime, false);

		//AddDebuff(true, EDEBF_ANIMATION, 0.5, OverrideTime, true);
		//AddDebuff(false, EDEBF_DIRMOV, 0.25, OverrideTime, false);
		//AddDebuff(false, EDEBF_DRAFT, 1.2f, 2.0f, false);

		//StateVariables.bIsSprintMaxSpeed = false;
		//bIsSprintMaxSpeed = false;
		if(StateVariables.bIsSprinting)
		{
			//StopSprint();
			//RemoveDebuff(EDEBF_SPRINT);	
			//ResetSprintSpeed();
		}
		//DisableSprint(true);
		//StateVariables.bCanSprint = false;
		//bForceNoSprint = true;

		DisableSprint(true);
		StartSprintRecovery();

		StopFireOnPawn();
		//BuffStatus = EBuff_Ice;
		//PlaySound(SoundCue'MWCONTENT_SFX.Water_HealStart',false, true, true);
		//HealLoop.Play();

		//ClearTimer('StopFreezeOnPawn');
		
		if (WorldInfo.NetMode == NM_STANDALONE)
		{
			HandleParticles(bIsFreezing, ParticleSystem'MWCONTENT_PFX.Watr_Debuff');
		}
	}
	if(OverrideTime > 0)
	{
		SetTimer(OverrideTime, false, 'StopFreezeOnPawn');
	}
	else
	{
		SetTimer(2, false, 'StopFreezeOnPawn');
	}
}

simulated function SetPawnOnHeal(ParticleSystem FirePS, Controller Cont, optional Actor InflictedBy = none, optional class<AOCDamageType> dmgType = none, optional float OverrideTime = 0.0f)
{
	LogAlwaysInternal("Heal");
	if (Role == ROLE_Authority && !bIsHealing)
	{
		bIsHealing=true;
		
		//Water Puts Out Fire
		StopFireOnPawn();
		
		//HealStatus = EHeal_Water;
		if (WorldInfo.NetMode == NM_STANDALONE)
		{
			HandleParticles(bIsHealing, ParticleSystem'MWCONTENT_PFX.Watr_HealLoop');
		}
	}
	// Check damage type
	if (dmgType == none)
	{
		HealDamage = -6;
		if (OverrideTime > 0.0f)
		{
			SetTimer(OverrideTime, false, 'StopHealOnPawn');
			BuffDuration = OverrideTime;
		}
		else
		{
			SetTimer(5, false, 'StopHealOnPawn');
			BuffDuration = 5;
		}

		if (!bIsBot)
			ToggleHealPE(true);
	}
	else
	{
		// Custom burn damage over time
		HealDamage = -dmgType.default.DamageOverTime;
		SetTimer(dmgType.default.DOTTime, false, 'StopHealOnPawn');

		if (!bIsBot)
		{
			if (class<AOCDmgType_BoilingOilBurn>(dmgType) != none)
			{				
				ToggleHealPE(true);
			}
			else
			{
				ToggleHealPE(true);
			}
		}
	}
}

simulated function StopFlameOnPawn()
{
	bIsFlaming=false;
	
	PlayBuffSFX(bIsFlaming, SoundCue'MWCONTENT_SFX.Fire_Shieldstart', SoundCue'MWCONTENT_SFX.Fire_Shld', SoundCue'MWCONTENT_SFX.Fire_Shieldstop');
	
	if (FireSFXComponent != none)
		FireSFXComponent.Stop();

	if (BurningPSComp != None)
	{
		BurningPSComp.DeactivateSystem();
		WorldInfo.MyEmitterPool.OnParticleSystemFinished(BurningPSComp);
		BurningPSComp = None;
	}

	if (WorldInfo.NetMode == NM_STANDALONE)
		handleParticles(bIsFlaming, ParticleSystem'MWCONTENT_PFX.Fire_Shld');

	if (!bIsBot)
	{
		ToggleHealPE(false);
		ToggleHealPE(false);
	}
}

simulated function StopRockOnPawn()
{
	bIsRocking=false;
	
	PlayBuffSFX(bIsRocking, SoundCue'MWCONTENT_SFX.Rock_Stoneskin_On', none, SoundCue'MWCONTENT_SFX.Rock_Stoneskin_Off');
	
	if (FireSFXComponent != none)
		FireSFXComponent.Stop();

	if (BurningPSComp != None)
	{
		BurningPSComp.DeactivateSystem();
		WorldInfo.MyEmitterPool.OnParticleSystemFinished(BurningPSComp);
		BurningPSComp = None;
	}

	if (WorldInfo.NetMode == NM_STANDALONE)
		HandleParticles(bIsRocking, ParticleSystem'MWCONTENT_PFX.Rock_Debuff');

	if (!bIsBot)
	{
		ToggleHealPE(false);
		ToggleHealPE(false);
	}
}

simulated function StopFreezeOnPawn()
{
	bIsFreezing=false;
	//HealStatus = EHeal_None;
	//BuffStatus = EBuff_None;

	//bForceNoSprint = false;
	//StateVariables.bCanSprint = true;

	PlayBuffSFX(bIsFreezing, SoundCue'MWCONTENT_SFX.Watr_Debuff', SoundCue'MWCONTENT_SFX.Watr_DebuffLoop', SoundCue'MWCONTENT_SFX.Watr_Debuffoff');	
	//SetOnFireBy = none;

	if (FireSFXComponent != none)
		FireSFXComponent.Stop();

	if (BurningPSComp != None)
	{
		BurningPSComp.DeactivateSystem();
		WorldInfo.MyEmitterPool.OnParticleSystemFinished(BurningPSComp);
		BurningPSComp = None;
	}

	if (WorldInfo.NetMode == NM_STANDALONE)
		HandleParticles(bIsFreezing, ParticleSystem'MWCONTENT_PFX.Watr_Debuff');

	if (!bIsBot)
	{
		ToggleHealPE(false);
		ToggleHealPE(false);
	}
}

simulated function StopHealOnPawn()
{
	bIsHealing=false;
	//HealStatus = EHeal_None;
	//BuffStatus = EBuff_None;
	PlayBuffSFX(bIsHealing, SoundCue'MWCONTENT_SFX.Water_HealStart', SoundCue'MWCONTENT_SFX.Water_HealLoop', SoundCue'MWCONTENT_SFX.Water_HealStop');
	//SetOnFireBy = none;

	if (FireSFXComponent != none)
		FireSFXComponent.Stop();

	if (BurningPSComp != None)
	{
		BurningPSComp.DeactivateSystem();
		WorldInfo.MyEmitterPool.OnParticleSystemFinished(BurningPSComp);
		BurningPSComp = None;
	}

	if (WorldInfo.NetMode == NM_STANDALONE)
		handleParticles(bIsHealing, ParticleSystem'MWCONTENT_PFX.Watr_HealLoop');

	if (!bIsBot)
	{
		ToggleHealPE(false);
		ToggleHealPE(false);
	}
}

simulated function HandleParticles(bool bIng, ParticleSystem PS)
{
	// Spawn burn particles only on the clients
	if (Role < ROLE_Authority || WorldInfo.NetMode == NM_STANDALONE)
	{
		LogAlwaysInternal("Particle Effects"@bIng);
		if (bIng)
		{
			BurningPSComp = new(self) class'UTParticleSystemComponent';
			BurningPSComp.bAutoActivate = true;
			//BurningPSComp.SetOwnerNoSee(false);
			//BurningPSComp.SetTemplate(ParticleSystem'MWCONTENT_PFX.Watr_HealLoop');

			BurningPSComp.SetTemplate(PS);
			
			BurningPSComp.ActivateSystem(true);
			Mesh.AttachComponent(BurningPSComp, 'b_root');
		}
		else
		{
			BurningPSComp.DeactivateSystem();
			WorldInfo.MyEmitterPool.OnParticleSystemFinished(BurningPSComp);
			BurningPSComp = None;
		}
	}
}

simulated function PlayBuffSFX(bool bIng, SoundCue Start, SoundCue Loop, SoundCue Stop)
{
	local SoundCue fireSFX;

	if (bIng && Health > 0)
	{
		fireSFX = Loop;

		if (FireSFXComponent != none)
			FireSFXComponent.Stop();
		PlaySound(Start,false, true, true);
		FireSFXComponent = CreateAudioComponent(fireSFX, false, true);
		FireSFXComponent.Play();
		
		//SetTimer(fireSFX.Duration, true, 'reactivateHealSFX');
		SetTimer(BuffDuration, false, 'reactivateHealSFX');
	}
	else
	{
		FireSFXComponent.FadeOut(1.0f, 0.0f);
		PlaySound(Stop,false, true, true);
	}
}

reliable client function ToggleHealPE(bool enable)
{
	//AOCBaseHUD(AOCPlayerController(Controller).myHUD).ToggleFirePostEffects(enable);
}

reliable client function ToggleOilPE(bool enable)
{
	AOCBaseHUD(AOCPlayerController(Controller).myHUD).ToggleOilPostEffects(enable);
}

simulated event Tick( float DeltaTime )
{
	super.Tick( DeltaTime );

	//only if we're healing
	if (Role == ROLE_Authority && bIsHealing && WorldInfo.TimeSeconds - LastDOTTime >= DOTTimeInterval)
	{
		//ReplicatedHitInfo.DamageString = "L";
		TakeDamage(HealDamage, LastBurnHit, Vect(0,0,0),vect(0,0,0), class'AOCDmgType_Burn', , SetOnFireBy);
		LastDOTTime = WorldInfo.TimeSeconds;
	}
	if (bIsFreezing)
	{
		//DisableSprint(true);
		//StateVariables.bCanSprint = false;
		//bForceNoSprint = true;
		DisableSprint(true);
		StartSprintRecovery();
	}
}

reliable server function AttackOtherPawn(HitInfo Info, string DamageString, optional bool bCheckParryOnly = false, optional bool bBoxParrySuccess, optional bool bHitShield = false, optional SwingTypeImpactSound LastHit = ESWINGSOUND_Slash, optional bool bQuickKick = false)
{
	LogAlwaysInternal("MWPAWN AttackOtherPawn_________________________");
	if(DamageString == "J" && bIsHealing)
	{
		LogAlwaysInternal("Lightning Damage Enhanced");
		Info.HitDamage *= 1.2;		
	}
	if(DamageString == "J" && bIsRocking)
	{
		Info.HitDamage *= 0.8;
	}
	if(bIsRocking)
	{
		Info.HitForce *= 0.1;
	}
	Super.AttackOtherPawn(Info, DamageString, bCheckParryOnly, bBoxParrySuccess, bHitShield, LastHit, bQuickKick);
}


//bSameTeam = true;
reliable server function AttackOtherPawn_NoFlinch(HitInfo Info, string DamageString, optional bool bCheckParryOnly = false, optional bool bBoxParrySuccess, optional bool bHitShield = false, optional SwingTypeImpactSound LastHit = ESWINGSOUND_Slash, optional bool bQuickKick = false)
{
local bool bParry;
	local float ActualDamage;
	local bool bSameTeam;
	local bool bFlinch;
	local IAOCAIListener AIList;
	local int i;
	local float Resistance;
	local float GenericDamage;
	local float HitForceMag;
	local PlayerReplicationInfo PRI;
	local bool bOnFire;
	local bool bPassiveBlock;
	local AOCWeaponAttachment HitActorWeaponAttachment;

	if (PlayerReplicationInfo == none)
		PRI = Info.PRI;
	else
		PRI = PlayerReplicationInfo;

	if (!PerformAttackSSSC(Info) && WorldInfo.NetMode != NM_Standalone)
	{
		//LogAlwaysInternal("SSSC Failure Notice By:"@PRI.PlayerName);
		//LogAlwaysInternal( self@"performed an illegal move directed at"@Info.HitActor$".");
		//LogAlwaysInternal("Attack Information:");
		//LogAlwaysInternal("My Location:"@Location$"; Hit Location"@Info.HitLocation);
		//LogAlwaysInternal("Attack Type:"@Info.AttackType@Info.DamageType);
		//LogAlwaysInternal("Hit Damage:"@Info.HitDamage);
		//LogAlwaysInternal("Hit Component:"@Info.HitComp);
		//LogAlwaysInternal("Hit Bone:"@Info.BoneName);
		//LogAlwaysInternal("Current Weapon State:"@Weapon.GetStateName());
		return;
	}

	HitActorWeaponAttachment = AOCWeaponAttachment(Info.HitActor.CurrentWeaponAttachment);

	//bSameTeam = PawnFamily.default.FamilyFaction == Info.HitActor.PawnFamily.default.FamilyFaction;
	//MW
	bSameTeam = true;

	bParry = false;
	bFlinch = false;

	//if game type is free-for-all ignore same team considerations used by other game types
	/*if( AOCFFA(WorldInfo.Game) != none || AOCTUT(WorldInfo.Game) != none)
		bSameTeam = false;*/

	//if(AOCPlayerController(Info.HitActor.Controller).bBoxParrySystem)
	//{
		bParry = bBoxParrySuccess && (Info.HitActor.StateVariables.bIsParrying || Info.HitActor.StateVariables.bIsActiveShielding) && class<AOCDmgType_Generic>(Info.DamageType) == none 
			&& Info.DamageType != class'AOCDmgType_SiegeWeapon';

		// Check if fists...fists can only blocks fists
		if (AOCWeapon_Fists(Info.HitActor.Weapon) != none && class<AOCDmgType_Fists>(Info.DamageType) == none)
			bParry = false;

		if(bParry)
		{
			DetectSuccessfulParry(Info, i, bCheckParryOnly, 0);
		}
	//}
	//else
	//{
	//	// check if the other pawn is parrying or active shielding
	//	if (!Info.HitActor.bPlayedDeath && (Info.HitActor.StateVariables.bIsParrying || Info.HitActor.StateVariables.bIsActiveShielding) && class<AOCDmgType_Generic>(Info.DamageType) != none)
	//	{
	//		bParry = ParryDetectionBonusAngles(Info, bCheckParryOnly);
	//	}
	//}

	if (Info.DamageType.default.bIsProjectile)
		AOCPRI(PlayerReplicationInfo).NumHits += 1;
	
	bPassiveBlock = false;
	if ( bHitShield && Info.DamageType.default.bIsProjectile)
	{
		// Check for passive shield block
		bParry = true;
		Info.HitDamage = 0.0f;
		bPassiveBlock = !Info.HitActor.StateVariables.bIsActiveShielding;
	}

	if (bCheckParryOnly)
		return;
	//LogAlwaysInternal("SUCCESSFUL ATTACK OTHER PAWN HERE");
	// Play hit sound
	AOCWeaponAttachment(CurrentWeaponAttachment).LastSwingType = LastHit;
	if(!bParry)
	{
		Info.HitActor.OnActionFailed(EACT_Block);
		Info.HitSound = AOCWeaponAttachment(CurrentWeaponAttachment).PlayHitPawnSound(Info.HitActor);
	}
	else        
		Info.HitSound = AOCWeaponAttachment(CurrentWeaponAttachment).PlayHitPawnSound(Info.HitActor, true);
	
	if (AOCMeleeWeapon(Info.Instigator.Weapon) != none)
	{
		AOCMeleeWeapon(Info.Instigator.Weapon).bHitPawn = true;
	}

	// Less damage for quick kick
	if (bQuickKick)
	{
		Info.HitDamage = 3;
	}

	ActualDamage = Info.HitDamage;
	GenericDamage = Info.HitDamage * Info.DamageType.default.DamageType[EDMG_Generic];
	ActualDamage -= GenericDamage; //Generic damage is unaffected by resistances etc.

	//Backstab damage for melee damage
	if (!CheckOtherPawnFacingMe(Info.HitActor) && !Info.DamageType.default.bIsProjectile)
		ActualDamage *= PawnFamily.default.fBackstabModifier;

	// Vanguard Aggression
	ActualDamage *= PawnFamily.default.fComboAggressionBonus ** Info.HitCombo;
	
	// make the other pawn take damage, the push back should be handled here too
	//Damage = HitDamage * LocationModifier * Resistances
	if (Info.UsedWeapon == 0 && AOCWeapon_Crossbow(Weapon) != none && Info.DamageType.default.bIsProjectile)
	{
		ActualDamage *= Info.HitActor.PawnFamily.default.CrossbowLocationModifiers[GetBoneLocation(Info.BoneName)];
	}
	else
	{
		ActualDamage *= (Info.DamageType.default.bIsProjectile ? Info.HitActor.PawnFamily.default.ProjectileLocationModifiers[GetBoneLocation(Info.BoneName)] : 
			Info.HitActor.PawnFamily.default.LocationModifiers[GetBoneLocation(Info.BoneName)]);
	}
		                                                           
	Resistance = 0;
	
	for( i = 0; i < ArrayCount(Info.DamageType.default.DamageType); i++)
	{
		Resistance += Info.DamageType.default.DamageType[i] * Info.HitActor.PawnFamily.default.DamageResistances[i];
	}
	
	ActualDamage *= Resistance;

	if (PawnFamily.default.FamilyFaction == Info.HitActor.PawnFamily.default.FamilyFaction)
		ActualDamage *= AOCGame(WorldInfo.Game).fTeamDamagePercent;
		
	ActualDamage += GenericDamage;
		
	//Damage calculations should be done now; round it to nearest whole number
	ActualDamage = float(Round(ActualDamage));

	//LogAlwaysInternal("ATTACK OTHER PAWN"@ActualDamage);
	// Successful parry but stamina got too low!
	if (bParry && !bPassiveBlock && Info.HitActor.Stamina <= 0)
	{
		bFlinch = true;
		AOCWeapon(Info.HitActor.Weapon).ActivateFlinch(true, Info.HitActor.GetHitDirection(Location), true, true, AOCWeapon(Weapon).bTwoHander); 
	}
	// if the other pawn is currently attacking, we just conducted a counter-attack
	if (Info.AttackType == Attack_Shove && !bParry && !Info.HitActor.StateVariables.bIsSprintAttack)
	{
		// kick should activate flinch and take away 10 stamina
		if (!bSameTeam)
		{
			bFlinch = true;
			AOCWeapon(Info.HitActor.Weapon).ActivateFlinch(true, Info.HitActor.GetHitDirection(Location),true, Info.HitActor.StateVariables.bIsActiveShielding && !bQuickKick, false);
		}
		Info.HitActor.ConsumeStamina(10);
		if (Info.HitActor.StateVariables.bIsActiveShielding && Info.HitActor.Stamina <= 0)
		{
			Info.HitActor.ConsumeStamina(-30.f);
		}
	}
	else if (Info.AttackType == Attack_Sprint && !bSameTeam)
	{
		bFlinch = true;
		AOCWeapon(Info.HitActor.Weapon).ActivateFlinch(true, Info.HitActor.GetHitDirection(Location), true, false, AOCWeapon(Weapon).bTwoHander); // sprint attack should daze
	}
	else if ((Info.HitActor.StateVariables.bIsParrying || Info.HitActor.StateVariables.bIsActiveShielding) && !bSameTeam && !bParry)
	{
		bFlinch = true;
		AOCWeapon(Info.HitActor.Weapon).ActivateFlinch(true, Info.HitActor.GetHitDirection(Location), class<AOCDmgType_Generic>(Info.DamageType) != none
			, class<AOCDmgType_Generic>(Info.DamageType) != none, AOCWeapon(Weapon).bTwoHander);
	}
	else if ((ActualDamage >= 80.0f || Info.HitActor.StateVariables.bIsSprinting || Info.HitActor.Weapon.IsInState('Deflect') ||
		Info.HitActor.Weapon.IsInState('Feint') || (Info.HitActor.Weapon.IsInState('Windup') && AOCRangeWeapon(Info.HitActor.Weapon) == none) || Info.HitActor.Weapon.IsInState('Active') || Info.HitActor.Weapon.IsInState('Flinch')
		|| Info.HitActor.Weapon.IsInState('Transition') || Info.HitActor.StateVariables.bIsManualJumpDodge || (Info.HitActor.Weapon.IsInState('Recovery') && AOCWeapon(Info.HitActor.Weapon).GetFlinchAnimLength(true) >= WeaponAnimationTimeLeft()) ) 
		&& !bParry && !bSameTeam &&	!Info.HitActor.StateVariables.bIsSprintAttack)
	{
		AOCWeapon(Info.HitActor.Weapon).ActivateFlinch(true, Info.HitActor.GetHitDirection(Location), false, false, AOCWeapon(Weapon).bTwoHander);
	}
	else if (AOCWeapon_JavelinThrow(Info.HitActor.Weapon) != none && Info.HitActor.Weapon.IsInState('WeaponEquipping'))
	{
		AOCWeapon(Info.HitActor.Weapon).ActivateFlinch(true, Info.HitActor.GetHitDirection(Location), false, false, AOCWeapon(Weapon).bTwoHander);
	}
	else if (!bParry && !bSameTeam) // cause the other pawn to play the hit animation
	{
		AOCWeapon(Info.HitActor.Weapon).ActivateHitAnim(Info.HitActor.GetHitDirection(Location, false, true), bSameTeam);
	}

	// GOD MODE - TODO: REMOVE
	if (Info.HitActor.bInfiniteHealth)
		ActualDamage = 0.0f;

	if (ActualDamage > 0.0f)
	{
		Info.HitActor.SetHitDebuff();
		LastAttackedBy = Info.Instigator;
		PauseHealthRegeneration();
		Info.HitActor.PauseHealthRegeneration();
		Info.HitActor.DisableSprint(true);	
		Info.HitActor.StartSprintRecovery();

		// play a PING sound if we hit a player when shooting
		if (Info.DamageType.default.bIsProjectile)
			PlayRangedHitSound();

		// Play sounds for everyone
		if (Info.HitActor.Health - ActualDamage > 0.0f)
			Info.HitActor.PlayHitSounds(ActualDamage, bFlinch);
		
		//PlayPitcherHitSound(ActualDamage, Info.HitActor.Location);
		if (AOCPlayerController(Controller) != none)
			AOCPlayerController(Controller).PC_SuccessfulHit();

		// Add to assist list if not in it already
		if (Info.HitActor.ContributingDamagers.Find(AOCPRI(PlayerReplicationInfo)) == INDEX_NONE && !bSameTeam)
			Info.HitActor.ContributingDamagers.AddItem(AOCPRI(PlayerReplicationInfo));

		Info.HitActor.LastPawnToHurtYou = Controller;

		//do not set the timer to clear the last pawn to attack value on a duel map...we want players to receive the kill even if the other player
		//  commits suicide by receiving falling damage or trap damage
		if( AOCDuel(WorldInfo.Game) == none )
			Info.HitActor.SetTimer(10.f, false, 'ClearLastPawnToAttack');
	}

	
	// Notify Pawn that we hit
	if (AOCMeleeWeapon(Weapon) != none && Info.HitActor.Health - ActualDamage > 0.0f && Info.AttackType != Attack_Shove && Info.AttackType != Attack_Sprint && !bParry)
		AOCMeleeWeapon(Weapon).NotifyHitPawn();

	// pass attack info to be replicated to the clients
	Info.bParry = bParry;
	Info.DamageString = DamageString;
	if (Info.BoneName == 'b_Neck' && !Info.DamageType.default.bIsProjectile && Info.DamageType.default.bCanDecap && Info.AttackType != Attack_Stab)
		Info.DamageString $= "3";
	else if ((Info.BoneName == 'b_Neck' || Info.BoneName == 'b_Head') && Info.DamageType.default.bIsProjectile)
	{
		Info.DamageString $= "4";

		if ( AOCPlayerController(Controller) != none)
			AOCPlayerController(Controller).NotifyAchievementHeadshot();
	}
	else if ((Info.BoneName == 'b_spine_A' || Info.BoneName == 'b_spine_B' || Info.BoneName == 'b_spine_C' || Info.BoneName == 'b_spine_D') && Info.DamageType.default.bIsProjectile)
	{
		if ( AOCPlayerController(Controller) != none)
			AOCPlayerController(Controller).NotifyCupidProgress();
	}
	Info.HitActor.ReplicatedHitInfo = Info;
	Info.HitDamage = ActualDamage;

	// manually do the replication if we're on the standalone
	if (WorldInfo.NetMode == NM_Standalone)
		Info.HitActor.HandlePawnGetHit();

	Info.HitForce *= int(PawnState != ESTATE_PUSH && PawnState != ESTATE_BATTERING);
	////LogAlwaysInternal("DAMAGE FORCE:"@Info.HitForce);
	Info.HitForce *= int(!bFlinch);
	HitForceMag = VSize( Info.HitForce );
	Info.HitForce.Z = 0.f;
	Info.HitForce = Normal(Info.HitForce) * HitForceMag;

	// Stat Tracking For Damage
	// TODO: Also sort by weapon
	if (PRI != none)
	{
		if (AOCFFA(WorldInfo.Game) != none || Info.HitActor.PawnFamily.default.FamilyFaction != PawnFamily.default.FamilyFaction)
		{
			AOCPRI(PRI).EnemyDamageDealt += ActualDamage;
		}
		else
		{
			AOCPRI(PRI).TeamDamageDealt += ActualDamage;
		}
		
		AOCPRI(PRI).bForceNetUpdate = TRUE;
	}

	if (Info.HitActor.PlayerReplicationInfo != none)
	{
		AOCPRI(Info.HitActor.PlayerReplicationInfo).DamageTaken += ActualDamage;
		AOCPRI(Info.HitActor.PlayerReplicationInfo).bForceNetUpdate = TRUE;
	}

	//LogAlwaysInternal("ATTACK OTHER PAWN"@Controller@CurrentSiegeWeapon.Controller);
	bOnFire = Info.HitActor.bIsBurning;
	
	Info.HitActor.TakeDamage(ActualDamage, Controller != none ? Controller : CurrentSiegeWeapon.Controller, Info.HitLocation, Info.HitForce, Info.DamageType);

	if ((Info.HitActor == none || Info.HitActor.Health <= 0) && WorldInfo.NetMode == NM_DedicatedServer)
	{
		// Make sure this wasn't a team kill
		if (AOCPlayerController(Controller).StatWrapper != none
			&& (AOCFFA(WorldInfo.Game) != none || Info.HitActor.PawnFamily.default.FamilyFaction != PawnFamily.default.FamilyFaction)
			&& Info.UsedWeapon < 2)
		{
			AOCPlayerController(Controller).StatWrapper.IncrementKillStats(
				Info.UsedWeapon == 0 ? PrimaryWeapon : SecondaryWeapon, 
				PawnFamily,
				Info.HitActor.PawnFamily,
				class<AOCWeapon>(HitActorWeaponAttachment.WeaponClass)
			);
		}

		// Do another check for a headshot here
		if (Info.BoneName == 'b_Neck' && !Info.DamageType.default.bIsProjectile && Info.DamageType.default.bCanDecap && Info.AttackType != Attack_Stab)
		{
			// Award rotiserie chef achievement on client
			if (AOCPlayerController(Controller) != none && bOnFire)
			{
				AOCPlayerController(Controller).UnlockRotisserieChef();
			}

			// Notify decap
			AOCPlayerController(Controller).NotifyAchievementDecap();
		}

		// Check if fists
		if (class<AOCDmgType_Fists>(Info.DamageType) != none)
		{
			if (AOCPlayerController(Controller) != none)
			{
				AOCPlayerController(Controller).NotifyFistofFuryProgress();
			}
		}
	}

	foreach AICombatInterests(AIList)
	{
		AIList.NotifyPawnPerformSuccessfulAttack(self);
	}
	
	foreach Info.HitActor.AICombatInterests(AIList)
	{
		if (!bParry)
			AIList.NotifyPawnReceiveHit(Info.HitActor,self);
		else
			AIList.NotifyPawnSuccessBlock(Info.HitActor, self);
	}
}

// Only called on Server
function ClearLastPawnToAttack()
{
	LastPawnToHurtYou = none;
}

/** Notify we hit somebody */
reliable client function PerformedSuccessfulHit()
{
	if (AOCRangeWeapon(Weapon) != none); //FIXME: should be removed, unless someone was using it for something
}


simulated function AddDebuff(bool bUnique, EMovementDebuffs eIdentifier, float fPercent, float fTime, bool bStack)
{
	local MovementDebuff sDebuff;

	if (bDisableDirDebuffs && eIdentifier == EDEBF_DIRMOV)
		return;

	if (bStack || !SearchForSimilarDebuff(eIdentifier))
	{
		if (eIdentifier == EDEBF_JUMP)
		{
			//LogAlwaysInternal("ADD DEBUFF"@eIdentifier@fPercent);
			//ScriptTrace();
		}
		sDebuff.bUnique = bUnique;
		sDebuff.eIdentifier = eIdentifier;
		sDebuff.fPercentDebuff = fPercent;
		sDebuff.fTime = fTime;
		PlayerMovementDebuffs.AddItem(sDebuff);
	}
}

DefaultProperties
{
	PawnFamily=class'MWFamilyInfo'

	//AllClasses.Empty;
	// do some initialization work here
	AllClasses(ECLASS_Archer)=class'MWFamilyInfo_Agatha_Archer'
	//AllClasses(ECLASS_Archer)=class'AOCFamilyInfo_Agatha_Archer'
	AllClasses(ECLASS_ManAtArms)=class'MWFamilyInfo_Agatha_ManAtArms'
	AllClasses(ECLASS_Vanguard)=class'MWFamilyInfo_Agatha_Vanguard'
	AllClasses(ECLASS_Knight)=class'AOCFamilyInfo_Agatha_Knight'
	//AllClasses(ECLASS_SiegeEngineer)=class'AOCFamilyInfo_Agatha_SiegeEngineer'

	// same order as above for Masons, but we cant do maths in the thingys.
	AllClasses(5)=class'MWFamilyInfo_Mason_Archer'
	//AllClasses(5)=class'AOCFamilyInfo_Mason_Archer'
	AllClasses(6)=class'MWFamilyInfo_Mason_ManAtArms'
	AllClasses(7)=class'MWFamilyInfo_Mason_Vanguard'
	AllClasses(8)=class'AOCFamilyInfo_Mason_Knight'
	//AllClasses(9)=class'AOCFamilyInfo_Mason_SiegeEngineer'

	Begin Object Class=AudioComponent Name=HealLoop
        SoundCue=SoundCue'MWCONTENT_SFX.Water_HealLoop'               
    End Object
	HealLoop = HealLoop

	Begin Object Class=AudioComponent Name=FireCone
        SoundCue=SoundCue'MWCONTENT_SFX.Fire_Cone'            
    End Object

	Begin Object Class=AudioComponent Name=WaterCone
        SoundCue=SoundCue'MWCONTENT_SFX.Watr_Cone'           
    End Object
}

/*
simulated function StopbInging(bool bIng, SoundCue Start, SoundCue Loop, SoundCue Stop, ParticleSystem PS)
{
	bIng=false;
	
	PlayBuffSFX(bIng, Start, Loop, Stop);
	
	if (FireSFXComponent != none)
		FireSFXComponent.Stop();

	if (BurningPSComp != None)
	{
		BurningPSComp.DeactivateSystem();
		WorldInfo.MyEmitterPool.OnParticleSystemFinished(BurningPSComp);
		BurningPSComp = None;
	}

	if (WorldInfo.NetMode == NM_STANDALONE)
		handleParticles(bIng, PS);

	if (!bIsBot)
	{
		ToggleHealPE(false);
		ToggleHealPE(false);
	}
}*/
