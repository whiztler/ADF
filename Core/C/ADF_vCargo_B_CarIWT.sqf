/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Vehicle Cargo Script (BLUEFOR) (BLUEFOR) - Car Infantry Weapons Team
Author: Whiztler
Script version: 1.7

Game type: n/a
File: ADF_vCargo_B_CarIWT.sqf
****************************************************************
Instructions:

Paste below line in the INITIALIZATION box of the vehicle:
null = [this] execVM "Core\C\ADF_vCargo_B_CarIWT.sqf";

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
_v addWeaponCargoGlobal ["arifle_MX_GL_F", 1]; // GL
_v addWeaponCargoGlobal ["LMG_mk200_f", 1]; // MG
_v addWeaponCargoGlobal ["MMG_02_sand_RCO_LP_F", 1]; // MG
_v addWeaponCargoGlobal ["arifle_MXM_F", 1]; // Marksman

// Secondary weapon
_v addWeaponCargoGlobal ["hgun_P07_F", 1];

// Magazines primary weapon
if (ADF_mod_ACE3) then {
	_v addMagazineCargoGlobal ["ACE_30Rnd_65x39_caseless_mag_Tracer_Dim", 25];
	_v addMagazineCargoGlobal ["ACE_30Rnd_65x47_Scenar_mag", 5];
	_v addMagazineCargoGlobal ["ACE_30Rnd_65_Creedmor_mag", 5];
	_v addMagazineCargoGlobal ["ACE_200Rnd_65x39_cased_Box_Tracer_Dim", 7];	
} else {
	_v addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", 20];
	_v addMagazineCargoGlobal ["200Rnd_65x39_cased_Box_Tracer", 5]; // MG
	_v addMagazineCargoGlobal ["200Rnd_65x39_cased_Box", 2]; // MG
};
	_v addMagazineCargoGlobal ["130Rnd_338_Mag", 2];

// Magazines secondary weapon
_v addMagazineCargoGlobal ["16Rnd_9x21_Mag", 2];

// Static weapon
_v addItemCargoGlobal ["B_GMG_01_weapon_F", 1];
_v addItemCargoGlobal ["B_HMG_01_weapon_F", 1];
_v addItemCargoGlobal ["B_HMG_01_support_F", 2];

// Static weapon Ammunition
//_v addMagazineCargoGlobal ["500Rnd_127x99_mag", 2];
//_v addMagazineCargoGlobal ["40Rnd_20mm_g_belt", 2];

// Mortar
//_v addMagazineCargoGlobal ["8Rnd_82mm_Mo_guided", 4];
//_v addMagazineCargoGlobal ["8Rnd_82mm_Mo_shells", 4];
//_v addMagazineCargoGlobal ["8Rnd_82mm_Mo_LG", 2];

// Launchers
_v addWeaponCargoGlobal ["launch_B_Titan_F", 1];
_v addWeaponCargoGlobal ["launch_B_Titan_short_F", 1];

// Rockets/Missiles
_v addMagazineCargoGlobal ["Titan_AT", 2];
_v addMagazineCargoGlobal ["Titan_AP", 1];
_v addMagazineCargoGlobal ["Titan_AA", 2];

// Demo/Explosives
_v addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 2];
_v addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 1];
_v addMagazineCargoGlobal ["ATMine_Range_Mag", 2];
_v addMagazineCargoGlobal ["APERSBoundingMine_Range_Mag", 2];
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_Cellphone", 1];
	_v addItemCargoGlobal ["ACE_Clacker", 1];
	_v addItemCargoGlobal ["ACE_M26_Clacker", 1]; // ACE3 094	
	_v addItemCargoGlobal ["ACE_DefusalKit", 1];
	_v addItemCargoGlobal ["ACE_wirecutter", 1];
};	

// Weapon mountings
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["acc_pointer_IR", 4];
	_v addItemCargoGlobal ["acc_flashlight", 4];	
	_v addItemCargoGlobal ["ACE_optic_Hamr_2D", 1];
	_v addItemCargoGlobal ["ACE_optic_Hamr_PIP", 1];
	_v addItemCargoGlobal ["ACE_optic_Arco_2D", 1];
	_v addItemCargoGlobal ["ACE_optic_Arco_PIP", 1];
	_v addItemCargoGlobal ["ACE_optic_MRCO_2D", 1];
	_v addItemCargoGlobal ["optic_tws_mg", 1];	
	_v addItemCargoGlobal ["optic_NVS", 1];	
} else {
	_v addItemCargoGlobal ["acc_pointer_IR", 4];
	_v addItemCargoGlobal ["optic_ACO", 1];
	_v addItemCargoGlobal ["optic_DMS", 1];
	_v addItemCargoGlobal ["optic_NVS", 1];
	_v addItemCargoGlobal ["optic_Hamr", 1];
	_v addItemCargoGlobal ["optic_tws_mg", 1];
	_v addItemCargoGlobal ["acc_flashlight", 4];
};

// GL Ammo
_v addMagazineCargoGlobal ["3Rnd_HE_Grenade_shell", 2];
_v addMagazineCargoGlobal ["3Rnd_Smoke_Grenade_shell", 4];
_v addMagazineCargoGlobal ["3Rnd_UGL_FlareCIR_F", 1]; 
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_HuntIR_M203", 2];
	_v addItemCargoGlobal ["ACE_HuntIR_monitor", 1];
};

// Grenades
_v addMagazineCargoGlobal ["HandGrenade", 6]; 	 
_v addMagazineCargoGlobal ["SmokeShell", 4]; 	 
_v addMagazineCargoGlobal ["SmokeShellGreen", 1]; 	 
_v addMagazineCargoGlobal ["SmokeShellRed", 1]; 
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_HandFlare_White", 3];
	_v addItemCargoGlobal ["ACE_HandFlare_Red", 1];
	_v addItemCargoGlobal ["ACE_HandFlare_Green", 1];
	_v addItemCargoGlobal ["ACE_HandFlare_Yellow", 1];
	_v addItemCargoGlobal ["ACE_M84" , 5]; // ACE3 094	
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
if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {_v addItemCargoGlobal ["ItemRadio", 4]};
/*if (ADF_mod_CTAB) then {
	_v addItemCargoGlobal ["ItemAndroid", 1];
	_v addItemCargoGlobal ["ItemcTabHCam", 6];
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
_v addWeaponCargoGlobal ["Rangefinder", 1];
_v addItemCargoGlobal ["NVGoggles", 1];
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_Vector" , 1];		
};	

// Gear kit 
//_v addBackpackCargoGlobal ["B_Carryall_Base", 3];
//_v addBackpackCargoGlobal ["B_AssaultPack_blk", 5];

// Misc items
_v addItemCargoGlobal ["ToolKit", 1];