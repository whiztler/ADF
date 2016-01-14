/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Vehicle Cargo Script (BLUEFOR) (BLUEFOR) - Car Infantry Fire Team
Author: Whiztler
Script version: 2.2

Game type: n/a
File: ADF_vCargo_B_CarIFT.sqf
****************************************************************
Instructions:

Paste below line in the INITIALIZATION box of the vehicle:
null = [this] execVM "Core\C\ADF_vCargo_B_CarIFT.sqf";

You can comment out (//) lines of ammo you do not want to include
in the vehicle cargo. 
****************************************************************/

// Init
if (!isServer) exitWith {};

waitUntil {time > 0};

// Init
params ["_v"];

// Settings 
clearWeaponCargoGlobal _v; // Empty vehicle CargoGlobal contents on init
clearMagazineCargoGlobal _v; // Empty vehicle CargoGlobal contents on init
clearItemCargoGlobal _v; // Empty vehicle CargoGlobal contents on init

// Primary weapon
_v addWeaponCargoGlobal ["arifle_MX_F", 1]; // R

// Magazines primary weapon
if (ADF_mod_ACE3) then {
	_v addMagazineCargoGlobal ["ACE_30Rnd_65x39_caseless_mag_Tracer_Dim", 25];
} else {
	_v addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", 25]
};
_v addMagazineCargoGlobal ["100Rnd_65x39_caseless_mag_tracer", 1]; // LMG
_v addMagazineCargoGlobal ["100Rnd_65x39_caseless_mag", 3]; // LMG

// Launchers
_v addweaponCargoGlobal ["launch_NLAW_F", 1];

// Rockets/Missiles
if (!ADF_mod_ACE3) then {_v addMagazineCargoGlobal ["NLAW_F", 2]};

// Demo/Explosives
_v addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 1];
_v addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 1];
_v addMagazineCargoGlobal ["ATMine_Range_Mag", 1];
_v addMagazineCargoGlobal ["APERSBoundingMine_Range_Mag", 1];
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_Clacker", 1];
	_v addItemCargoGlobal ["ACE_Cellphone", 1];
	_v addItemCargoGlobal ["ACE_M26_Clacker", 1];
	_v addItemCargoGlobal ["ACE_DefusalKit", 1];
	_v addItemCargoGlobal ["ACE_wirecutter", 1];
};	

// Weapon mountings
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["acc_pointer_IR", 4];
	_v addItemCargoGlobal ["acc_flashlight", 4];	
	_v addItemCargoGlobal ["ACE_optic_Arco_2D", 1];
	_v addItemCargoGlobal ["ACE_optic_Arco_PIP", 1];
} else {
	_v addItemCargoGlobal ["acc_pointer_IR", 4];
	_v addItemCargoGlobal ["optic_ACO", 1];
	_v addItemCargoGlobal ["acc_flashlight", 2];
};

// GL Ammo
_v addMagazineCargoGlobal ["3Rnd_HE_Grenade_shell", 3];
_v addMagazineCargoGlobal ["3Rnd_Smoke_Grenade_shell", 1];
_v addMagazineCargoGlobal ["3Rnd_UGL_FlareCIR_F", 1];
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_HuntIR_M203", 1];
	_v addItemCargoGlobal ["ACE_HuntIR_monitor", 1];
};

// Grenades
_v addMagazineCargoGlobal ["HandGrenade", 10]; 	 
_v addMagazineCargoGlobal ["SmokeShell", 5]; 	 
_v addMagazineCargoGlobal ["SmokeShellGreen", 2]; 	 
_v addMagazineCargoGlobal ["SmokeShellRed", 1]; 
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_HandFlare_White", 2];
	_v addItemCargoGlobal ["ACE_HandFlare_Red", 1];
	_v addItemCargoGlobal ["ACE_HandFlare_Green", 1];
	_v addItemCargoGlobal ["ACE_HandFlare_Yellow", 1];
	_v addItemCargoGlobal ["ACE_M84", 3];
};

// ACRE / TFAR and cTAB
if (ADF_mod_ACRE) then {
	_v addItemCargoGlobal ["ACRE_PRC343", 4];
	_v addItemCargoGlobal ["ACRE_PRC148", 1];
};
if (ADF_mod_TFAR) then {
	_v addItemCargoGlobal ["tf_anprc152", 4];
	//_v addItemCargoGlobal ["tf_rt1523g", 3];
	_v addBackpackCargoGlobal ["tf_rt1523g", 1];
};
if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {_v addItemCargoGlobal ["ItemRadio", 5]};
/*if (ADF_mod_CTAB) then {
	_v addItemCargoGlobal ["ItemAndroid", 1];
	_v addItemCargoGlobal ["ItemcTabHCam", 5];
};*/

// ACE3 Specific	
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_EarPlugs", 4];
	_v addItemCargoGlobal ["ace_mapTools", 1];
	_v addItemCargoGlobal ["ACE_CableTie", 2];
	_v addItemCargoGlobal ["ACE_UAVBattery", 1];
	_v addItemCargoGlobal ["ACE_TacticalLadder_Pack", 1];
};

// Medical Items
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_fieldDressing", 5];
	_v addItemCargoGlobal ["ACE_personalAidKit", 1];
	_v addItemCargoGlobal ["ACE_morphine", 3];
	_v addItemCargoGlobal ["ACE_epinephrine", 2];
	_v addItemCargoGlobal ["ACE_bloodIV", 1];
} else {
	_v addItemCargoGlobal ["FirstAidKit", 5];
	_v addItemCargoGlobal ["Medikit", 1];
};

// Optical/Bino's/Goggles
_v addWeaponCargoGlobal ["Binocular", 1];
_v addItemCargoGlobal ["NVGoggles", 2];
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_Vector", 1];		
};	

// Gear kit 
//_v addBackpackCargoGlobal ["B_Carryall_Base", 2];
//_v addBackpackCargoGlobal ["B_AssaultPack_blk", 3];

// Misc items
_v addItemCargoGlobal ["ToolKit", 1];