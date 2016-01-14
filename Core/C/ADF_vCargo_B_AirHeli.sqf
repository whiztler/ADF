/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Vehicle Cargo Script (BLUEFOR) (BLUEFOR) - Helicopter
Author: Whiztler
Script version: 1.7

Game type: n/a
File: ADF_vCargo_B_AirHeli.sqf
****************************************************************
Instructions:

Paste below line in the INITIALIZATION box of the vehicle:
null = [this] execVM "Core\C\ADF_vCargo_B_AirHeli.sqf";

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

// Magazines primary weapon
_v addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", 5];

// Demo/Explosives
_v addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 1];
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_Clacker", 2];
	_v addItemCargoGlobal ["ACE_wirecutter", 1];
};	

// Grenades
_v addMagazineCargoGlobal ["HandGrenade", 5]; 	 
_v addMagazineCargoGlobal ["SmokeShell", 5]; 	 
_v addMagazineCargoGlobal ["SmokeShellGreen", 5]; 	 
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_HandFlare_White", 3];
	_v addItemCargoGlobal ["ACE_HandFlare_Red", 1];
	_v addItemCargoGlobal ["ACE_HandFlare_Green", 1];
	_v addItemCargoGlobal ["ACE_HandFlare_Yellow", 1];
};

// ACRE / TFAR and cTAB
if (ADF_mod_ACRE) then {
	_v addItemCargoGlobal ["ACRE_PRC343", 3];
	_v addItemCargoGlobal ["ACRE_PRC148", 1];
};
if (ADF_mod_TFAR) then {
	_v addItemCargoGlobal ["tf_anprc152", 3];
	//_v addItemCargoGlobal ["tf_rt1523g", 3];
	_v addBackpackCargoGlobal ["tf_rt1523g", 1];
};
if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {_v addItemCargoGlobal ["ItemRadio", 3]};
if (ADF_mod_CTAB) then {
	_v addItemCargoGlobal ["ItemAndroid", 1];
	_v addItemCargoGlobal ["ItemcTabHCam", 3];
};

// ACE3 Specific	
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_EarPlugs", 5];
	_v addItemCargoGlobal ["ace_mapTools", 1];
};

// Medical Items
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_fieldDressing", 5];
	_v addItemCargoGlobal ["ACE_personalAidKit", 1];
	_v addItemCargoGlobal ["ACE_morphine", 5];
} else {
	_v addItemCargoGlobal ["FirstAidKit", 5];
	_v addItemCargoGlobal ["Medikit", 1];
};

// Gear kit 
_v addItemCargoGlobal ["B_Parachute", 25];

// Misc items
_v addItemCargoGlobal ["ToolKit", 2];

//hintSilent "vAmmo loaded."; // For debug only.