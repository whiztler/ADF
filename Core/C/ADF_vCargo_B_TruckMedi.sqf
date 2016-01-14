/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Vehicle Cargo Script (BLUEFOR) - Medical Truck/Ambulance
Author: Whiztler
Script version: 2.0

Game type: n/a
File: ADF_vCargo_B_TruckMedi.sqf
****************************************************************
Instructions:

Paste below line in the INITIALIZATION box of the vehicle:
null = [this] execVM "Core\C\ADF_vCargo_B_TruckMedi.sqf";

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
if (ADF_mod_ACE3) then {
	_v addMagazineCargoGlobal ["ACE_30Rnd_65x39_caseless_mag_Tracer_Dim", 5];
} else {
	_v addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", 5]
};

// Grenades
_v addMagazineCargoGlobal ["SmokeShell", 25]; 	 
_v addMagazineCargoGlobal ["SmokeShellGreen", 50];
_v addMagazineCargoGlobal ["SmokeShellYellow", 10];
_v addMagazineCargoGlobal ["SmokeShellPurple", 10];
_v addMagazineCargoGlobal ["SmokeShellRed", 10];
_v addMagazineCargoGlobal ["SmokeShellBlue", 10];
_v addMagazineCargoGlobal ["SmokeShellOrange", 10];

// Demo/Explosives
_v addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 1];
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_Clacker", 1];
	_v addItemCargoGlobal ["ACE_wirecutter", 1];
};	

// ACRE / TFAR and cTAB
if (ADF_mod_ACRE) then {
	_v addItemCargoGlobal ["ACRE_PRC343", 2];
	_v addItemCargoGlobal ["ACRE_PRC148", 1];
};
if (ADF_mod_TFAR) then {
	_v addItemCargoGlobal ["tf_anprc152", 2];
	//_v addItemCargoGlobal ["tf_rt1523g", 3];
	_v addBackpackCargoGlobal ["tf_rt1523g", 1];
};
if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {_v addItemCargoGlobal ["ItemRadio", 6]};
/*if (ADF_mod_CTAB) then {
	_v addItemCargoGlobal ["ItemAndroid", 1];
	_v addItemCargoGlobal ["ItemcTabHCam", 2];
};*/

// ACE3 Specific	
if (ADF_mod_ACE3) then {_v addItemCargoGlobal ["ACE_EarPlugs", 5]};
if (ADF_mod_ACE3) then {_v addItemCargoGlobal ["ace_mapTools", 2]};
if (ADF_mod_ACE3) then {_v addItemCargoGlobal ["ACE_CableTie", 5]}; // ACE3 094

// Medical Items
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_fieldDressing", 150];
	_v addItemCargoGlobal ["ACE_packingBandage", 50];
	_v addItemCargoGlobal ["ACE_elasticBandage", 50];
	_v addItemCargoGlobal ["ACE_quikclot", 25];
	_v addItemCargoGlobal ["ACE_tourniquet", 25];
	_v addItemCargoGlobal ["ACE_surgicalKit", 5];
	_v addItemCargoGlobal ["ACE_personalAidKit", 25];
	_v addItemCargoGlobal ["ACE_morphine", 50];
	_v addItemCargoGlobal ["ACE_epinephrine", 50];
	_v addItemCargoGlobal ["ACE_atropine", 50];
	_v addItemCargoGlobal ["ACE_bloodIV", 25];
	_v addItemCargoGlobal ["ACE_bloodIV_500", 35];
	_v addItemCargoGlobal ["ACE_bloodIV_250", 50];
	_v addItemCargoGlobal ["ACE_plasmaIV", 25];
	_v addItemCargoGlobal ["ACE_plasmaIV_500", 35];
	_v addItemCargoGlobal ["ACE_plasmaIV_250", 50];
	_v addItemCargoGlobal ["ACE_salineIV", 25];
	_v addItemCargoGlobal ["ACE_salineIV_500", 35];
	_v addItemCargoGlobal ["ACE_salineIV_250", 50];	
	_v addItemCargoGlobal ["ACE_bodyBag", 50];	
} else {
	_v addItemCargoGlobal ["FirstAidKit", 150];
	_v addItemCargoGlobal ["Medikit", 5];
};

// Optical/Bino's/Goggles
_v addWeaponCargoGlobal ["Rangefinder", 1];
_v addItemCargoGlobal ["NVGoggles", 3];
if (ADF_mod_ACE3) then {
	_v addItemCargoGlobal ["ACE_Vector", 1];		
};	

// Gear kit 
_v addBackpackCargoGlobal ["B_AssaultPack_rgr_Medic", 3];

// Misc items
_v addItemCargoGlobal ["ToolKit", 2];