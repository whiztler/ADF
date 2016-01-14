/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Game Master/Instructor/Zeus configuration
Author: Whiztler
Script version: 1.52

Game type: n/a
File: ADF_GM.sqf
****************************************************************
This script applies various additional functionality to the GM/
Zeus/instructor roles.

Instructions:

Make sure your zeus units (max 2) are named: GM_1 and/or GM_2
Place a 'ZEUS Game Master' module for each unit:
- Name: GMmod_x (where x is the unit number)
- Owner: GM_x (where x is the unit number)
- Default addons: All addons (incl unofficial ones)
- Forced interface: disabled
****************************************************************/

if (isServer) then {diag_log "ADF RPT: Init - executing ADF_GM.sqf"}; // Reporting. Do NOT edit/remove

// Init
if ((isNil "GM_1") && (isNil "GM_2")) exitWith {// No Zeus playable slots detected
	if (ADF_debug) then {
		["ZEUS - No GM units active. Terminating ADF_GM", false] call ADF_fnc_log
	} else {
		diag_log "ADF RPT: ZEUS - No GM units active. Terminating ADF_GM";
	};
}; 

params ["_ADF_zeusEagle"];
private ["_ADF_GM_gear"];

showCuratorCompass true;

// GM roles
_ADF_GM_gear = {
	params ["_u"];
	removeBackpackGlobal _u;
	removeUniform _u;
	removeHeadgear _u;
	_u forceAddUniform "U_BG_Guerrilla_6_1";
	_u addHeadgear "H_Booniehat_khk_hs";
	if (ADF_mod_TFAR) then {_u addBackpack "tf_rt1523g";} else {_u addBackpack "B_TacticalPack_blk";};
	_u addVest "V_Rangemaster_belt";
	_u unassignItem "NVGoggles";
	_u addWeapon "ItemGPS";
	_u addWeapon "NVGoggles";
	_u addWeapon "Laserdesignator";
	_u addMagazine "Laserbatteries";
	_u unassignItem "NVGoggles";
	_u linkItem "ItemGPS";
	if (ADF_mod_ACE3) then {
		_u setVariable ["ace_medical_allowDamage", false];	
		_u addItem "ACE_fieldDressing";
		_u addItem "ACE_fieldDressing";
		_u addItem "ACE_morphine";
		_u addItem "ACE_EarPlugs";
		_u addItem "ace_mapTools";
		_u addItem "ACE_CableTie";
		_u addItem "ACE_IR_Strobe_Item";		
	} else {
		_u addItem "FirstAidKit";
		_u addItem "FirstAidKit";			
	};
	if (ADF_mod_ACRE) then {_u addWeapon "ACRE_PRC343"};
	if (ADF_mod_TFAR) then {_u addWeapon "tf_anprc152"};	
	if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {_u addWeapon "ItemRadio"};
	if (ADF_mod_CTAB) then {(backpackContainer _u) addItemCargoGlobal ["ItemcTab", 1]};
	if (ADF_Clan_uniformInsignia) then {[_u,"CLANPATCH"] call BIS_fnc_setUnitInsignia};
};

if !(isNil "GM_1") then {
	if !(player == GM_1) exitWith {};
	GM_1 addAction ["<t align='left' color='#FBF4DF'>GM - Teleport</t>",{openMap true;hintSilent format ["%1, click on a location on the map to teleport...", name vehicle player];onMapSingleClick "vehicle player setPos _pos; onMapSingleClick ' '; true; openMap false; hint format ['%1, you are now at: %2', name vehicle player, getPosATL player];";},[],-85, true, true,"", ""];	
	[GM_1] call _ADF_GM_gear;
	ADF_GM_init = true;
	if (ADF_debug) then {["ZEUS: GM-1 active", false] call ADF_fnc_log};	
};

if !(isNil "GM_2") then {
	if !(player == GM_2) exitWith {};
	GM_2 addAction ["<t align='left' color='#FBF4DF'>GM - Teleport</t>",{openMap true;hintSilent format ["%1, click on a location on the map to teleport...", name vehicle player];onMapSingleClick "vehicle player setPos _pos; onMapSingleClick ' '; true; openMap false; hint format ['%1, you are now at: %2', name vehicle player, getPosATL player];";},[],-85, true, true,"", ""];	
	[GM_2] call _ADF_GM_gear;
	ADF_GM_init = true;
	if (ADF_debug) then {["ZEUS: GM-2 active", false] call ADF_fnc_log};	
};

if (!isServer) exitWith {};

if !(_ADF_zeusEagle) then { // Kill the Zeus Eagle?
	[] spawn {
		private ["_p"];
		_p = [];
		
		for "_i" from 0 to ((count allCurators) - 1) do {
			_p = _p + [getPosASL (allCurators select _i)];
		};
		{
			while {true} do {
				{if (typeOf _x == "Eagle_F") then {deleteVehicle _x}} forEach ((_p select 0) nearEntities ["man", 500]); // v1.39 B10
				Sleep 120;
				if (ADF_debug) then {["ZEUS - Zeus Eagle deactivated", false] call ADF_fnc_log};
			};
		} forEach allCurators;		
	};
};

if ((isNil "GMmod_1") && (isNil "GMmod_2")) exitWith {
	if (ADF_debug) then {["ZEUS - No Zeus Modules exist (GMmod_1/2). Terminating", false] call ADF_fnc_log};
};

if 	((!(isNil "GMmod_1") &&  !(isNil "GMmod_2")) && (!(isNil "GM_1") && !(isNil "GM_2"))) then {
	curArray = [GMmod_1,GMmod_2];
	GM_1 assignCurator GMmod_1;
	GM_2 assignCurator GMmod_2;
	if (ADF_debug) then {["ZEUS - Assigning GM_1 to GMmod_1 -- GM_2 to GMmod_2", false] call ADF_fnc_log};
};

if 	(!(isNil "GMmod_1") && (!(isNil "GM_1") && (isNil "GM_2"))) then {
	curArray = [GMmod_1];
	GM_1 assignCurator GMmod_1;
	if (ADF_debug) then {["ZEUS - Assigning GM_1 to GMmod_1 - No GM_2 detected.", false] call ADF_fnc_log};
};

if	(!(isNil "GMmod_2") && ((isNil "GM_1") && !(isNil "GM_2"))) then {
	curArray = [GMmod_2];
	GM_2 assignCurator GMmod_2;
	if (ADF_debug) then {["ZEUS - Assigning GM_2 to GMmod_2 - No GM_1 detected.", false] call ADF_fnc_log};
};

// Wrong GM or wrong Logic. Can't connect GM_1 to GMmod_2 and vica versa
if (((isNil "GMmod_1") && !(isNil "GMmod_2")) && (!(isNil "GM_1") && (isNil "GM_2"))) exitWith {
	if (ADF_debug) then {["ZEUS - Cannot assign GM_1 to GMmod_2. Terminating", true] call ADF_fnc_log};
};
if ((!(isNil "GMmod_1") && (isNil "GMmod_2")) && ((isNil "GM_1") && !(isNil "GM_2"))) exitWith {
	if (ADF_debug) then {["ZEUS - Cannot assign GM_2 to GMmod_1. Terminating", true] call ADF_fnc_log};
};

if (ADF_mod_Ares) exitWith { // Use ARES instead of ADF Zeus functions > V1.39 B7
	if (ADF_debug) then {
		["ZEUS - Ares addon detected. Using Ares instead of ADF Zeus functions", false] call ADF_fnc_log
	} else {
		diag_log "ADF RPT: ZEUS - Ares addon detected. Using Ares instead of ADF Zeus functions";
	};
}; 

// ADV_zeus by Belbo. Edited by Whiz

private "_civ";
_civ = true;

{ //adds objects placed in editor:
	_x addCuratorEditableObjects [vehicles, true];
	_x addCuratorEditableObjects [(allMissionObjects "Man"), false];
	_x addCuratorEditableObjects [(allMissionObjects "Air"), true];
	_x addCuratorEditableObjects [(allMissionObjects "Ammo"), false];
	_x allowCuratorLogicIgnoreAreas true;
} forEach curArray;

//makes all units continuously available to Zeus (for respawning players and AI that's being spawned by a script.)
if (ADF_debug) then {["ZEUS - ADV Zeus function Initialized", false] call ADF_fnc_log};
while {true} do {
	_a = if (!_civ && {(side _x) == civilian}) then {false} else {true};
	{
		if (_a) then {
			if !(isNil "GMmod_1") then {GMmod_1 addCuratorEditableObjects [[_x], true]};
			if !(isNil "GMmod_2") then {GMmod_2 addCuratorEditableObjects [[_x], true]};
		};
	} forEach allUnits;
	
	if !(isNil "GMmod_1") then {GMmod_1 addCuratorEditableObjects [vehicles, true]};
	if !(isNil "GMmod_2") then {GMmod_2 addCuratorEditableObjects [vehicles, true]};
	
	sleep 10;
	//if (ADF_debug) then {["ZEUS - Objects transferred to Curator(s) ", false] call ADF_fnc_log};
};

