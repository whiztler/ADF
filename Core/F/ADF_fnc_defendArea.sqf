/****************************************************************
ARMA Mission Development Framework
ADF version: 1.42 / SEPTEMBER 2015

Script: Defend area script
Author: Whiztler
Script version: 1.01

Game type: N/A
File: ADF_fnc_defendArea.sqf
****************************************************************
This is a defend/garrison script based on CBA_fnc_taskDefend by Rommel.
The script garrisons units in empty buildings, static weapons and vehicle
turrets.
Units that have not been garrisoned will go on patrol in the assigned
(radius) area.

INSTRUCTIONS:
load the function on mission start (e.g. in Scr\init.sqf):
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_defendArea.sqf";

Config:
[
	group,				// Group name - Name of the group.
	position,				// Array or Position - E.g. getMarkerPos "Spawn" -or- Position Player
	radius				// Number - Radius from the start position in which a waypoint is created
] call ADF_fnc_defendArea;

Example for scripted groups:
[_grp, _Position, 100] call ADF_fnc_defendArea;
[_grp, getMarkerPos "PatrolMarker", 75] call ADF_fnc_defendArea;

Notes

Note this function requires the ADF_fnc_position.sqf:
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_position.sqf";
****************************************************************/


ADF_fnc_garrisonArr = {
	params ["_p","_r"];
	private ["_b","_bp"];

	// init
	_r = if (_r > 0) then {_r} else {75};

	// Create the building array
	_b = _p nearObjects ["building",_r];
	if (count _b == 0) exitWith {[]};
	
	// Check if the building has garrison positions. If no position available, remove the building from the array
	{_bp = _x buildingPos 0; 	if (str _bp == "[0,0,0]") then {_b deleteAt (_b find _x)}} forEach _b;	
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_garrisonArr - valid buildings found: %1",_b]};
	
	// return the building array
	_b
};

ADF_fnc_buildingPos = {
	// init
	params ["_b"];
	private ["_a"];
	_a = [];	
	
	{
		// init
		private ["_i","_e","_bp"];
		_i = 0;
		_e = [_x] call BIS_fnc_isBuildingEnterable;
		_x setVariable ["ADF_garrPos",[]];

		// Loop through available positions inside the building and store them into a variable.
		while {_e && str (_x buildingPos _i) != "[0,0,0]"} do {
			_x setVariable ["ADF_garrPos",(_x getVariable "ADF_garrPos") + [_i]];
			if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_garrisonArr - Found building Position %1 for building %2",_i,_x]};
			_i = _i + 1;
		};
		_a = _x getVariable "ADF_garrPos";
		if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_garrisonArr - ADF_garrPos set (building: %1): %2",_x,_a]};
	} forEach _b;
	
	// return the building position array
	_a
};

ADF_fnc_getTurrets = {
	// init
	params ["_p","_r"];
	private ["_t","_a"];
	
	// Create array of empty turrets
	_t =  [];
	{_t append nearestObjects [_p,[_x],_r]} forEach ["TANK","APC","CAR","StaticWeapon"];

	_a = [];
	{if ((_x emptyPositions "gunner") > 0 && ((count crew _x) == 0)) then {_a append [_x]}; if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_getTurrets - Turret found: %1",_x]}} forEach _t;
	
	// return turrets array
	_a
};

ADF_fnc_setGarrison = {
	// init
	params ["_u","_p","_b","_gt"];
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea - Garrison position unit: %1",_p]};
	
	// Join a new group and move the unit inside the predefined building position 
	[_u] joinSilent _gt;
	_u setPosATL [_p select 0, _p select 1, ( _p select 2) + .15];
	_u disableAI "move";
	_u setUnitPos "UP";
	// Attempt to make the unit face outside 
	_u setDir (([_u, _b] call BIS_fnc_dirTo) - 180);
						
	_u setVariable ["ADF_garrSetBuilding",true];		
	
	waitUntil {sleep 1; !(unitReady _u)};
	_u enableAI "move";
};

ADF_fnc_defendArea = {	
	params ["_g","_p","_r"];
	private ["_b","_bs","_bp","_t","_u","_uf","_c","_ct","_i","_a","_s","_gt","_ADF_perfDiagStart","_ADF_perfDiagStop"];
	
	// init
	_ADF_perfDiagStart = diag_tickTime;
	if !(local _g) exitWith {}; 
	_p	= [_p] call ADF_fnc_checkPosition;
	_bs	= [_p,_r] call ADF_fnc_garrisonArr;
	_t	= [_p,_r] call ADF_fnc_getTurrets;
	[_bs] call ADF_fnc_buildingPos;
	
	_g enableAttack false;
	_s	= side _g;
	_gt	= createGroup _s;
	_u	= units _g;
	_c	= count _u;
	_i	= 0;
	
	// Modified CBA_fnc_taskDefend by Rommel et all
	
	{		
		if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea - Unit nr.: %1",_i]};
		_ct	= (count _t) - 1;
		
		if ((_ct > -1) && (_x != leader _g)) then {
			_x assignAsGunner (_t select _ct);
			_x moveInGunner (_t select _ct);
			_t resize _ct;
			_x setVariable ["ADF_garrSetTurret",true];
			[_x] joinSilent _gt;
			_i = _i + 1;
		} else {
			if (true && {count _bs > 0}) then {
				private ["_b","_bp","_a"];
				_b = _bs call BIS_fnc_selectRandom;
				if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea - building selected: %1",_b]};
				_a = _b getVariable "ADF_garrPos";
				if (isNil "_a") then {_a = 0};
				if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea - ADF_garrPos: %1",_a]};				
				
				if (count _a > 0) then {
					_bp = (_b getVariable "ADF_garrPos") call BIS_fnc_selectRandom;
					if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea - ADF_garrPos random: %1",_bp]};
					_a = _a - [_bp];
					
					if (count _a == 0) then {
						_bs = _bs - [_b];
						_b setVariable ["ADF_garrPos",nil];
					};
					
					_b setVariable ["ADF_garrPos",_a];					
					[_x,_b buildingPos _bp,_b,_gt] spawn ADF_fnc_setGarrison;					
					_i = _i + 1;
				};
			};
		};
	} forEach _u;
	
	{_x setVariable ["ADF_garrPos",nil]} forEach _bs;
	
	// Non garrisoned units patrol the area
	if (_r < 100) then {_r = 100};
	[_g, _p, _r, 4, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5] call ADF_fnc_footPatrol;
	_ADF_perfDiagStop = diag_tickTime;
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea processed (DIAG: %1)",_ADF_perfDiagStop - _ADF_perfDiagStart]};
};
