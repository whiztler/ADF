/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Vehicle Cargo Script (BLUEFOR) (BLUEFOR) - Transport Truck
Author: Whiztler
Script version: 2.0

Game type: n/a
File: ADF_vCargo_B_TruckTrpt.sqf
****************************************************************
Instructions:

Paste below line in the INITIALIZATION box of the vehicle:
null = [this] execVM "Core\C\ADF_vCargo_B_TruckTrpt.sqf";

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
_v addWeaponCargoGlobal ["arifle_MX_GL_F", 2]; // GL

if (ADF_mod_ACE3) then {
	_v addMagazineCargoGlobal ["ACE_30Rnd_65x39_caseless_mag_Tracer_Dim", 25];
} else {
	_v addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", 25]
};

// Demo/Explosives
_v addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 5];

// GL Ammo
_v addMagazineCargoGlobal ["3Rnd_HE_Grenade_shell", 5];

// Grenades
_v addMagazineCargoGlobal ["HandGrenade", 5]; 	 
_v addMagazineCargoGlobal ["SmokeShell", 5]; 	 

// Medical Items
_v addItemCargoGlobal ["FirstAidKit", 5];

// Misc items
_v addItemCargoGlobal ["ToolKit", 2];
