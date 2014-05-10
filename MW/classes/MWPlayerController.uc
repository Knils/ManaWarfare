class MWPlayerController extends AOCPlayerController;

simulated function ShowMyParryBox(bool b)
{
	//local AOCPAWN RefPawn;
	LogAlwaysInternal("MANA SHIELD");
	AOCPawn(Pawn).ParryComponent.SetMaterial(0, Material'CHV_Material_Pack.Materials.Masters.M_Water_Master');	
	AOCPawn(Pawn).ParryComponent.SetHidden(b);
	//RefPawn = AOCPawn(Pawn);
	//LogAlwaysInternal(AOCPawn(Pawn)@"PAWN <------------");
	///Client_ShowMyParryBox(b, RefPawn);
}
/*
reliable client function Client_ShowMyParryBox(bool b, AOCPawn p)
{
	LogAlwaysInternal("CLIENT MANA SHIELD");
	LogAlwaysInternal(AOCPawn(Pawn)@"PAWN <------------");
	LogAlwaysInternal(P@"P_PAWN <------------");
	p.ParryComponent.SetMaterial(0, Material'CHV_Material_Pack.Materials.Masters.M_Water_Master');	
	p.ParryComponent.SetHidden(b);
}
*/
exec function ShowOthersParryBoxes()
{
	local AOCPawn P;
	foreach Worldinfo.AllPawns(class'AOCPawn', P)
	{
		if(P != Pawn)
		{
			P.ParryComponent.SetMaterial(0, Material'CHV_Material_Pack.Materials.Masters.M_Water_Master');	
			P.ParryComponent.SetHidden(false);
		}
	}
}
exec function ShowAllParryBoxes()
{
	local AOCPawn P;
	foreach Worldinfo.AllPawns(class'AOCPawn', P)
	{
		P.ParryComponent.SetMaterial(0, Material'CHV_Material_Pack.Materials.Masters.M_Water_Master');	
		P.ParryComponent.SetHidden(false);
	}
}

reliable server function ServerRequestSetNewClass(class<AOCFamilyInfo> InputFamily)
{
	///LogAlwaysInternal("ServerRequestSetNewClass"@self@PlayerReplicationInfo.PlayerName@InputFamily);
	if( class<AOCFamilyInfo_Agatha_King>(InputFamily) == none && class<AOCFamilyInfo_Mason_King>(InputFamily) == none &&
	   (class<AOCFamilyInfo_Archer>(InputFamily) != none || class<AOCFamilyInfo_Knight>(InputFamily) != none || class<AOCFamilyInfo_ManAtArms>(InputFamily) != none || class<AOCFamilyInfo_Vanguard>(InputFamily) != none || class<MWFamilyInfo_Archer>(InputFamily) != none))
	{
		///LogAlwaysInternal("ServerRequestSetNewClass ALLOWED");
		SetNewClass(InputFamily);
	}	
	else
	{
		///LogAlwaysInternal("ServerRequestSetNewClass BLOCKED");
	}
}

unreliable client function NotifyManaGain(int Amt)
{
	AOCBaseHUD(myHUD).PickUpAmmo(Amt, false);
	//PlaySound(SoundCue'A_Meta.Pickup', true);
	//SetTimer(1.5f, false, 'HidePickupAmmo');
}

exec function PerformAlternateAttack(bool bDo)
{	
	if ( AOCPawn(Pawn) != none && AOCMeleeWeapon(Pawn.Weapon) != none)
	{
	//	if (!AOCMeleeWeapon(Pawn.Weapon).bIgnoreAlternate)
	//	{
		AOCMeleeWeapon(Pawn.Weapon).bUseAlternateSide = bDo;
		S_PerformAlternateAttack(bDo);
	//	}
	}
	if ( AOCPawn(Pawn) != none && MWSpellWeapon(Pawn.Weapon) != none)
	{
		//LogAlwaysInternal("Alt");
		MWSpellWeapon(Pawn.Weapon).bUseAlternateSide = bDo;
		S_PerformAlternateAttack_Spell(bDo);
	}
}

reliable server function S_PerformAlternateAttack_Spell(bool bDo)
{
	MWSpellWeapon(Pawn.Weapon).bUseAlternateSide = bDo;
}

DefaultProperties
{
	ThirdPersonCameraPositions(1)=(X=130.0000, Y=38.0000, Z=-6.0000)
	ThirdPersonCameraPositions(0)=(X=130.0000, Y=0.0000, Z=20.0000)
	ThirdPersonCameraPositions(2)=(X=130.0000, Y=-18.0000, Z=-7.0000)
}
