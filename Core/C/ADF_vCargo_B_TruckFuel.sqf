/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Vehicle Cargo Script (BLUEFOR) (BLUEFOR) - Fuel Truck
Author: Whiztler
Script version: 1.9

Game type: n/a
File: ADF_vCargo_B_TruckFuel.sqf
****************************************************************
Instructions:

Paste below line in the INITIALIZATION box of the vehicle:
null = [this] execVM "Core\C\ADF_vCargo_B_TruckFuel.sqf";

You can comment out (//) lines of ammo you do not want to include
in the vehicle cargo. 
****************************************************************/

// Init
if (!isServer) exitWith {};

waitUntil {time > 0};

// Init
params ["_v"];

// Settings 
[_v] call ADF_fnc_stripVehicle;

// Magazines primary weapon
_v addMagazineCargoGlobal ["30Rnd_65x39_caseless_mag", 5];

// Demo/Explosives
_v addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 1];
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
if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {_v addItemCargoGlobal ["ItemRadio", 2]};
/*if (ADF_mod_CTAB) then {
	_v addItemCargoGlobal ["ItemAndroid", 1];	
	_v addItemCargoGlobal ["ItemcTabHCam", 1];
};*/


// Grenades
_v addMagazineCargoGlobal ["HandGrenade", 3]; 	 
_v addMagazineCargoGlobal ["SmokeShell", 2]; 	 

// Medical Items
_v addItemCargoGlobal ["FirstAidKit", 2];

// Misc items
if (ADF_mod_ACE3) then {_v addItemCargoGlobal ["ACE_EarPlugs", 2]};

//hintSilent "vAmmo loaded."; // For debug only.

// Misc items
_v addItemCargoGlobal ["ToolKit", 2];