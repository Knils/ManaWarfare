class MWProj_Pillar extends MWProj_Spell;


simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	/*
	if (Role < ROLE_Authority && OwnerPawn.IsLocallyControlled() && !OwnerPawn.bIsBot)
	{
		LogAlwaysInternal("WORKING!!!!!!!!!!!!!!!!!!!!!!!!");
		ShutDown();
		return;
	}
	else
		SpawnPillar();
	*/
}

/*
simulated function SpawnPillar()
{
	local vector HitLocation, HitNormal, Start, End;

	LogAlwaysInternal("ROLE:"@ROLE);
	
	Start = Location;
	End = Location - vect(0,0,1500);
	Trace(HitLocation,HitNormal,End,Start,false);
	LogAlwaysInternal(Start@"*");
	LogAlwaysInternal(End@"*");
	LogAlwaysInternal(HitLocation@"*");
	Spawn(class'MWSpell_LightPillar',,,HitLocation,,,true);
}
*/

//Modified so that explode and direct hit can occur... maybe
simulated function AOCProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal, TraceHitInfo TraceInfo)
{
	local HitInfo Info;
	local int i;
	local class<AOCWeapon> Weap;

	LogAlwaysInternal("PROCESS TOUCH"@Role);
	if( Role < ROLE_Authority )
		return;

	bDamagedSomething=true;

	if (AOCPawn(Other) == none)
	{
		Other.TakeDamage(Damage,InstigatorController,HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType,, self);
		Shutdown();
	}
	else
	{
		LogAlwaysInternal("Damage Continuing");
		Info.AttackType = Attack_Slash;
		Info.BoneName = TraceInfo.BoneName;
		Info.bParry = false;
		Info.DamageType = class<AOCDamageType>(MyDamageType);
		Info.HitActor = AOCPawn(Other);
		Info.HitDamage = Damage;
		Info.HitForce = MomentumTransfer*(-HitNormal);
		Info.HitLocation = HitLocation;
		Info.HitNormal = HitNormal;
		Info.HitComp = TraceInfo.HitComponent;
		Info.Instigator = OwnerPawn;
		Info.HitCombo = 0;
		Info.TimeVar = WorldInfo.TimeSeconds - StartFlightTime;
		Info.ProjType = Class;
		Info.UsedWeapon = CurrentAssociatedWeapon;

		AoE( HitLocation, HitNormal );
		//LogAlwaysInternal("ATTACK OTHER PAWN"@Other@Info.HitComp@AOCPawn(Other).ShieldMesh@AOCPawn(Other).BackShieldMesh@CurrentAssociatedWeapon);
		if (OwnerPawn.Role < ROLE_Authority || WorldInfo.NetMode == NM_Standalone)
		{
			if (Info.HitComp == AOCPawn(Other).Mesh || Info.HitComp == AOCPawn(Other).ShieldMesh || Info.HitComp == AOCPawn(Other).BackShieldMesh)
			{
				if (CurrentAssociatedWeapon == 0)
					Weap = OwnerPawn.PrimaryWeapon;
				else if (CurrentAssociatedWeapon == 1)
					Weap = OwnerPawn.SecondaryWeapon;
				else
					Weap = OwnerPawn.TertiaryWeapon;
				OwnerPawn.AttackOtherPawn(Info,Weap.default.WeaponFontSymbol,,,Info.HitComp == AOCPawn(Other).ShieldMesh || Info.HitComp == AOCPawn(Other).BackShieldMesh);
			}
		}

		//Add StruckByProjectileInfo to struck pawn (for ammo pickup by attacker)
		for ( i=0 ; i < class'AOCPawn'.const.MAXIMUM_STORED_PROJECTILE_TYPES ; i++)
		{
			//Search for empty element or one of the same pawn and weapon type
			if ( AOCPawn(Other).StruckByProjectiles[i].ProjectileOwner == none || AOCPawn(Other).StruckByProjectiles[i].ProjectileType == none)         //If array element is unused
			{
				//Assign info to array element
				AOCPawn(Other).StruckByProjectiles[i].ProjectileOwner = OwnerPawn;
				AOCPawn(Other).StruckByProjectiles[i].ProjectileType = LaunchingWeapon;
				AOCPawn(Other).StruckByProjectiles[i].ProjectileCount = 1;
				break;
			}
			else if(AOCPawn(Other).StruckByProjectiles[i].ProjectileOwner == OwnerPawn && AOCPawn(Other).StruckByProjectiles[i].ProjectileType == LaunchingWeapon)          //If array element matches attacker and launching weapon type 
			{
				//Add ammo to count
				AOCPawn(Other).StruckByProjectiles[i].ProjectileCount++;
				break;
			}
		}
		
		LogAlwaysInternal("REACHING SUCCESSHIT!");
		SuccessHitPawn(AOCPawn(Other), TraceInfo.BoneName);
		SuccessHitMWPawn(MWPawn(Other));
		////LogAlwaysInternal("SUCCESSFULLY HIT A PAWN SHUTDOWN");
		Shutdown();
	}
}

DefaultProperties
{
	DrawScale=1.0
	AccelRate=0.0
	LifeSpan=2.5
	DamageRadius=40
	MomentumTransfer=25000.0

	ProjFlightTemplate=ParticleSystem'MWCONTENT_PFX.Lite_P_Tesla'
	ExplosionLightClass=class'UTShockImpactLight'
	//ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Lite_P_Explode'
	ProjExplTemplate=ParticleSystem'MWCONTENT_PFX.Lite_Pillar01'
	
	//NetCullDistanceSquared=+144000000.0
	bCollideWorld=true
	Physics=PHYS_Falling
	bBounce=false
	CustomGravityScaling=15
	bRotationFollowsVelocity=true
	bBlockedByInstigator=true
		
	//ColorLevel=(X=100,Y=1,Z=100)
	//ExplosionColor=(X=100,Y=1,Z=100)

	
	Begin Object Name=StaticMeshComponent0
		//StaticMesh=StaticMesh'MWCONTENT.Spell_Fireball'
		StaticMesh=none
		Scale=0.5
	End Object
	
	ExplSound=SoundCue'MWCONTENT_SFX.Light_Pillar'
	ProjBlockedSound=SoundCue'MWCONTENT_SFX.Shield_Hit'	

		
	YawRate = 0.0f
	PitchRate = 0.0f
	RollRate = 0.0f
	fProjectileAttachCompensation=50.f

	ProjCamPosModX=-50
	ProjCamPosModZ=25
	
	bEnableArrowCamAmbientSoundSwap=true
	ArrowCamAmbientSound=SoundCue'A_Projectile_Flight.Flight_jav_Cam'
}