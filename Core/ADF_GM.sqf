/****************************************************************
ARMA Mission Development Framework
ADF version: 1.40 / JUNE 2015

Script: Game Master/Instructor/Zeus configuration
Author: Whiztler
Script version: 1.49

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

diag_log "ADF RPT: Init - executing ADF_GM.sqf"; // Reporting. Do NOT edit/remove
if (ADF_isHC) exitWith {}; // HC exits script

// Init
if ((isNil "GM_1") && (isNil "GM_2")) exitWith {// No Zeus playable slots detected
	if (ADF_debug) then {
		["ZEUS - No GM units active. Terminating ADF_GM",false] call ADF_fnc_log
	} else {
		diag_log "ADF RPT: ZEUS - No GM units active. Terminating ADF_GM";
	};
}; 
_ADF_zeusEagle = _this select 0;
showCuratorCompass true;

// GM roles
if !(isNil "GM_1") then {
	if !(player == GM_1) exitWith {};

	GM_1 addAction ["<t align='left' color='#FBF4DF'>GM - Teleport</t>",{openMap true;hintSilent format ["%1, click on a location on the map to teleport...", name vehicle player];onMapSingleClick "vehicle player setPos _pos; onMapSingleClick ' '; true; openMap false; hint format ['%1, you are now at: %2', name vehicle player, getPosATL player];";},[],-85,true,true,"",""];	
	
	removeBackpackGlobal GM_1;
	removeUniform GM_1;
	removeHeadgear GM_1;
	GM_1 forceAddUniform "U_BG_Guerrilla_6_1";
	GM_1 addHeadgear "H_Booniehat_khk_hs";
	if (ADF_mod_TFAR) then {GM_1 addBackpack "tf_rt1523g";} else {GM_1 addBackpack "B_TacticalPack_blk";};
	GM_1 addVest "V_Rangemaster_belt";
	GM_1 unassignItem "NVGoggles";
	GM_1 addWeapon "ItemGPS";
	GM_1 addWeapon "NVGoggles";
	GM_1 addWeapon "Laserdesignator";
	GM_1 addMagazine "Laserbatteries";
	GM_1 unassignItem "NVGoggles";
	GM_1 linkItem "ItemGPS";
	if (ADF_mod_ACE3) then {
		GM_1 setVariable ["ace_medical_allowDamage", false];	
		GM_1 addItem "ACE_fieldDressing";
		GM_1 addItem "ACE_fieldDressing";
		GM_1 addItem "ACE_morphine";
		GM_1 addItem "ACE_EarPlugs";
		GM_1 addItem "ace_mapTools";
		GM_1 addItem "ACE_CableTie";
		GM_1 addItem "ACE_IR_Strobe_Item";		
	} else {
		GM_1 addItem "FirstAidKit";
		GM_1 addItem "FirstAidKit";			
	};
	if (ADF_mod_ACRE) then {GM_1 addWeapon "ACRE_PRC343"};
	if (ADF_mod_TFAR) then {GM_1 addWeapon "tf_anprc152"};	
	if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {GM_1 addWeapon "ItemRadio"};
	if (ADF_mod_CTAB) then {(backpackContainer GM_1) addItemCargoGlobal ["ItemcTab",1]};
	if (ADF_Clan_uniformInsignia) then {[GM_1,"CLANPATCH"] call BIS_fnc_setUnitInsignia};
	ADF_GM_init = true;
	if (ADF_debug) then {["ZEUS: GM-1 active",false] call ADF_fnc_log};	
};

if !(isNil "GM_2") then {
	if !(player == GM_2) exitWith {};

	GM_2 addAction ["<t align='left' color='#FBF4DF'>GM - Teleport</t>",{openMap true;hintSilent format ["%1, click on a location on the map to teleport...", name vehicle player];onMapSingleClick "vehicle player setPos _pos; onMapSingleClick ' '; true; openMap false; hint format ['%1, you are now at: %2', name vehicle player, getPosATL player];";},[],-85,true,true,"",""];	
	
	removeBackpackGlobal GM_2;
	removeUniform GM_2;
	removeHeadgear GM_2;
	GM_2 forceAddUniform "U_BG_Guerrilla_6_1";
	GM_2 addHeadgear "H_Booniehat_khk_hs";
	if (ADF_mod_TFAR) then {GM_2 addBackpack "tf_rt1523g";} else {GM_2 addBackpack "B_TacticalPack_blk";};
	GM_2 addVest "V_Rangemaster_belt";
	GM_2 unassignItem "NVGoggles";
	GM_2 addWeapon "ItemGPS";
	GM_2 addWeapon "NVGoggles";
	GM_2 addWeapon "Laserdesignator";
	GM_2 addMagazine "Laserbatteries";
	GM_2 unassignItem "NVGoggles";
	GM_2 linkItem "ItemGPS";
	
	if (ADF_mod_ACE3) then {
		GM_2 setVariable ["ace_medical_allowDamage", false];	
		GM_2 addItem "ACE_fieldDressing";
		GM_2 addItem "ACE_fieldDressing";
		GM_2 addItem "ACE_morphine";
		GM_2 addItem "ACE_EarPlugs";
		GM_2 addItem "ace_mapTools";
		GM_2 addItem "ACE_CableTie";
		GM_2 addItem "ACE_IR_Strobe_Item";		
	} else {
		GM_2 addItem "FirstAidKit";
		GM_2 addItem "FirstAidKit";			
	};
	if (ADF_mod_ACRE) then {GM_2 addWeapon "ACRE_PRC343"};
	if (ADF_mod_TFAR) then {GM_2 addWeapon "tf_anprc152"};	
	if (!ADF_mod_ACRE && !ADF_mod_TFAR) then {GM_2 addWeapon "ItemRadio"};
	if (ADF_mod_CTAB) then {(backpackContainer GM_2) addItemCargoGlobal ["ItemcTab",1]};
	if (ADF_Clan_uniformInsignia) then {[GM_2,"CLANPATCH"] call BIS_fnc_setUnitInsignia};
	ADF_GM_init = true;
	if (ADF_debug) then {["ZEUS: GM-2 active",false] call ADF_fnc_log};	
};

if (!isServer) exitWith {};

if !(_ADF_zeusEagle) then { // Kill the Zeus Eagle?
	[] spawn {
		private ["_curPos"];
		_curPos = [];
		
		for "_i" from 0 to ((count allCurators) - 1) do {
			_curPos = _curPos + [getPosASL (allCurators select _i)];
		};
		{
			while {true} do {
				{if (typeOf _x == "Eagle_F") then {deleteVehicle _x}} forEach ((_curPos select 0) nearEntities ["man", 500]); // v1.39 B10
				Sleep 120;
				if (ADF_debug) then {["ZEUS - Zeus Eagle deactivated",false] call ADF_fnc_log};
			};
		} forEach allCurators;		
	};
};

if ((isNil "GMmod_1") && (isNil "GMmod_2")) exitWith {
	if (ADF_debug) then {["ZEUS - No Zeus Modules exist (GMmod_1/2). Terminating",false] call ADF_fnc_log};
};

if 	((!(isNil "GMmod_1") &&  !(isNil "GMmod_2")) && (!(isNil "GM_1") && !(isNil "GM_2"))) then {
	curArray = [GMmod_1,GMmod_2];
	GM_1 assignCurator GMmod_1;
	GM_2 assignCurator GMmod_2;
	if (ADF_debug) then {["ZEUS - Assigning GM_1 to GMmod_1 -- GM_2 to GMmod_2",false] call ADF_fnc_log};
};

if 	(!(isNil "GMmod_1") && (!(isNil "GM_1") && (isNil "GM_2"))) then {
	curArray = [GMmod_1];
	GM_1 assignCurator GMmod_1;
	if (ADF_debug) then {["ZEUS - Assigning GM_1 to GMmod_1 - No GM_2 detected.",false] call ADF_fnc_log};
};

if	(!(isNil "GMmod_2") && ((isNil "GM_1") && !(isNil "GM_2"))) then {
	curArray = [GMmod_2];
	GM_2 assignCurator GMmod_2;
	if (ADF_debug) then {["ZEUS - Assigning GM_2 to GMmod_2 - No GM_1 detected.",false] call ADF_fnc_log};
};

// Wrong GM or wrong Logic. Can't connect GM_1 to GMmod_2 and vica versa
if (((isNil "GMmod_1") && !(isNil "GMmod_2")) && (!(isNil "GM_1") && (isNil "GM_2"))) exitWith {
	if (ADF_debug) then {["ZEUS - Cannot assign GM_1 to GMmod_2. Terminating",true] call ADF_fnc_log};
};
if ((!(isNil "GMmod_1") && (isNil "GMmod_2")) && ((isNil "GM_1") && !(isNil "GM_2"))) exitWith {
	if (ADF_debug) then {["ZEUS - Cannot assign GM_2 to GMmod_1. Terminating",true] call ADF_fnc_log};
};

if (ADF_mod_Ares) exitWith { // Use ARES instead of ADF Zeus functions > V1.39 B7
	if (ADF_debug) then {
		["ZEUS - Ares addon detected. Using Ares instead of ADF Zeus functions",false] call ADF_fnc_log
	} else {
		diag_log "ADF RPT: ZEUS - Ares addon detected. Using Ares instead of ADF Zeus functions";
	};
}; 

// ADV_zeus by Belbo. Edited by Whiz

_addCivilians = true;

{ //adds objects placed in editor:
	_x addCuratorEditableObjects [vehicles,true];
	_x addCuratorEditableObjects [(allMissionObjects "Man"),false];
	_x addCuratorEditableObjects [(allMissionObjects "Air"),true];
	_x addCuratorEditableObjects [(allMissionObjects "Ammo"),false];
	_x allowCuratorLogicIgnoreAreas true;
} forEach curArray;

//makes all units continuously available to Zeus (for respawning players and AI that's being spawned by a script.)
if (ADF_debug) then {["ZEUS - ADV Zeus function Initialized",false] call ADF_fnc_log};
while {true} do {
	_toAdd = if (!_addCivilians && {(side _x) == civilian}) then {false} else {true};
	{
		if (_toAdd) then {
			if !(isNil "GMmod_1") then {GMmod_1 addCuratorEditableObjects [[_x], true]};
			if !(isNil "GMmod_2") then {GMmod_2 addCuratorEditableObjects [[_x], true]};
		};
	} forEach allUnits;
	
	if !(isNil "GMmod_1") then {GMmod_1 addCuratorEditableObjects [vehicles, true]};
	if !(isNil "GMmod_2") then {GMmod_2 addCuratorEditableObjects [vehicles, true]};
	
	sleep 10;
	if (ADF_debug) then {["ZEUS - Objects transferred to Curator(s) ",false] call ADF_fnc_log};
};

