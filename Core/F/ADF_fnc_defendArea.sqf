/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Defend area script
Author: Whiztler
Script version: 1.20

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

Lock (all) the vehicle to prevent AI's from populating the turret/static weapon.

Note this function requires the ADF_fnc_position.sqf:
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_position.sqf";
****************************************************************/

diag_log "ADF RPT: Init - executing ADF_fnc_defendArea.sqf"; // Reporting. Do NOT edit/remove

bPos_debug = false; // enable to test building positions (yellow sphere ingame and yellow dot on the map)

ADF_fnc_buildingArr = {
	/**********************************************************************
	The gbuildingArr function is called by the defendArea function. It creates
	and pupulates an array of buildings within the garrison radius.
	The buildings are checked for being enterable and haaving garrison positions.
	**********************************************************************/
	// init	
	params [["_p", [0, 0, 0], [[]], [3]],["_r", 10,[0]]];
	private ["_b", "_bp", "_be"];	

	// Create the building array
	_b = nearestObjects [_p, ["building"], _r];
	if (count _b == 0) exitWith {[]};	
	
	// Check if building can be entered. Then check if the building has garrison positions. If no position available, remove the building from the array
	{
		if !(_x getVariable ["ADF_garrPosAvail", true]) then {
			_b = _b - [_x];
		} else {
			if ((count (_x getVariable ["ADF_garrPos", []])) == 0) then {
				_x setVariable ["ADF_garrPos", []];
				_be = [_x] call BIS_fnc_isBuildingEnterable;
				_bp = [_x] call BIS_fnc_buildingPositions;
				
				if (ADF_debug && bPos_debug) then {
					{
						_v = createVehicle ["Sign_Sphere100cm_F", [_x select 0, _x select 1, (_x select 2) + 1], [], 0, "NONE"];
						_mName = format ["p_%1", _x];
						_m = createMarker [_mName, _x];
						_m setMarkerSize [.7, .7];
						_m setMarkerShape "ICON";
						_m setMarkerType "hd_dot";
						_m setMarkerColor "ColorYellow";
					} forEach _bp;
				};

				if (!_be || (count _bp == 0)) then {_b = _b - [_x]};
				_x setVariable ["ADF_garrPos", _bp];
				_x setVariable ["ADF_garrPosAvail", true];
			};
		};
		
	} forEach _b;
	
	// return the building array
	_b
};

ADF_fnc_getTurrets = {
	/**********************************************************************
	The getTurrets function is called by the defendArea function. It creates
	and pupulates an array of empty unlocked static weapons and vehicles with 
	empty turrets.
	If you have vehciles on the map you DO NOT want to be populated by AI's,
	then 'LOCK' the vehicle (not player lock!)
	**********************************************************************/
	// init
	params [["_p", [0, 0, 0], [[]], [3]],["_r", 10,[0]]];
	private ["_t", "_a"];
	_t = [];
	_a = [];	
	
	// Create array of empty static turrets
	{_t append nearestObjects [_p, [_x], _r]} forEach ["TANK", "APC", "CAR", "StaticWeapon"];
	// Remove already populated turrest from the array
	{if ((_x emptyPositions "gunner") > 0 && ((count crew _x) == 0 && (locked _x) != 2)) then {_a append [_x]}} forEach _t;
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea - Turrets array: %1", _a]};
	
	// return turrets array
	_a
};

ADF_fnc_setGarrison = {
	/**********************************************************************
	The setGarrison function is executed by the defendArea function for
	units that have been assigned a position within a building.
	It makes the unit move (walk/run) to the position. Once at the position
	the unit will be disabled to move untill a thread has been detected.
	**********************************************************************/
	// init
	params ["_u", ["_p", [0, 0, 0], [[]], [3]],"_b"];
	private ["_t", "_d"];
	
	// Move the unit inside the predefined building position. Give the unit 60 secs to reach its position.	
	_t = round time;
	_u doMove _p;
	sleep 5;
	waitUntil {unitReady _u || (time == _t + 60)};
	
	// Set unit just in case the building or building position is bugged
	_u allowDamage false; _u setPosATL [_p select 0, _p select 1, ( _p select 2) + .15]; _u allowDamage true;
	
		// Attempt to make the unit face outside 
	_d = (([_u, _b] call BIS_fnc_dirTo) - 180);
	 if (_d < 0) then {_d = _d + 360};
	_u setFormDir _d;
	_u setVariable ["ADF_garrSetDir", _d];
	if ((_p select 2) > 4) then {_u setUnitPos "MIDDLE"} else {_u setUnitPos "_UP"};

	_u disableAI "move";
	doStop _u;
	
	//_u setVariable ["ADF_garrSetBuilding", [true, _p]];
	
	waitUntil {sleep 1 + (random 1); !(unitReady _u)};
	_u enableAI "move";
};

ADF_fnc_setTurretGunner = {
	/**********************************************************************
	The setTurretGunner function is executed by the defendArea function for
	units that have been assigned to a static weapon or a turret in an empty
	vehicle. The skill set of turret units is increased to make them more
	responsive to threads.
	If you have vehciles on the map you DO NOT want to be populated by AI's,
	then 'LOCK' the vehicle (not player lock!)
	**********************************************************************/
	// init
	params ["_u"];
	
	// Increase gunner skill so they are more responsive to approaching enemies
	_u setSkill ["spotDistance",.7 + (random .3)];
	_u setSkill ["spotTime",.7 + (random .3)];
	_u setSkill ["aimingAccuracy",.4 + (random .3)];
	_u setSkill ["aimingSpeed",.4 + (random .3)];
	_u setCombatMode "YELLOW";

	true
};

ADF_fnc_defendAreaPatrol = {
	/**********************************************************************
	The defendAreaPatrol function is executed by the defendArea function for
	units that cannot be garrisoned (no buildings, or no positions left).
	The remaining units are grouped in a new group and send out to patrol
	the area. Same radius as the garrison area radius.
	**********************************************************************/
	// Init
	params ["_i", "_g", "_p", "_r"];
	private ["_gt", "_u", "_a"];

	// Init
	_u	= units _g;
	_a	= [];
	
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendAreaPatrol - Group units: %1", _u]};
	
	// Check if the unit is garrisoned
	{
		if !(_x getVariable ["ADF_garrSet", true]) then {
			_a append [_x];
			if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendAreaPatrol - Unit: %1 -- ADF_garrSet: %2", _x, _x getVariable "ADF_garrSet"]};
		}
	} forEach _u;	
	
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendAreaPatrol - # garrisoned units: %1 -- # patrol units: %2 -- Patrol units: %3", _i, count _a, _a]};
	
	// Create a new group for not-garrisoned units 
	_gt = createGroup (side _g);
	{[_x] joinSilent _gt} forEach _a;
	
	if (_r < 75) then {_r = 75};
	[_gt, _p, _r, 4, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5] call ADF_fnc_footPatrol;
	_gt setVariable ["ADF_hc_garrison_ADF", false];
	_gt enableAttack true;
};

ADF_fnc_defendArea = {
	/**********************************************************************
	This is the main function which is called by scripts.	
	**********************************************************************/
	// init
	params ["_g", "_p", ["_r", 10,[0]]];
	private ["_a", "_b", "_bs", "_bp", "_t", "_u", "_c", "_ct", "_i", "_ADF_perfDiagStart", "_ADF_perfDiagStop"];
	
	// init
	_ADF_perfDiagStart = diag_tickTime;
	
	_a 	= [];
	_u	= units _g;
	_c	= count _u;
	_i	= 0;
	_l	= 0;	
	
	// Check the position (marker, array, etc.)
	_p	= [_p] call ADF_fnc_checkPosition;
	// Populate an array with suitable garrison buildings
	_bs	= [_p, _r] call ADF_fnc_buildingArr;
	// Populate an array with turret positions (statics and empty vehicles)
	_t	= [_p, _r] call ADF_fnc_getTurrets;

	if (ADF_debug) then {
		diag_log format ["ADF Debug: ADF_fnc_defendArea - Group: %1 -- # units: %2", _g, _c];
		diag_log format ["ADF Debug: ADF_fnc_defendArea - Turrets found: %1", (count _t)];
	};
	
	_g enableAttack false;

	// Modified CBA_fnc_taskDefend by Rommel et all	
	{		
		// init
		_ct	= (count _t) - 1;
		_l = _l + 1;
		_x setVariable ["ADF_garrSet", false];
		
		// Populate static weapons and vehicles with turrets first
		if ((_ct > -1) && (_x != leader _g)) then {
			_x assignAsGunner (_t select _ct);
			_x moveInGunner (_t select _ct);
			[_x] call ADF_fnc_setTurretGunner;
			_t resize _ct;
			_x setVariable ["ADF_garrSet", true];
			_i = _i + 1;
		// All turrets populated, populate building positions
		} else {
			if (count _bs > 0) then {
				private ["_b", "_bp", "_p"];
				_b = _bs call BIS_fnc_selectRandom;
				_p = _b getVariable ["ADF_garrPos", []];
				
				// Create a spread when the nr of buildings > number of units
				if ((count _bs) >= _c) then {_bs = _bs - [_b]};
				
				if ((count _p) > 0) then {
				
					// In case there are multiple building positions within the bui;ding, check for high altitude positions for rooftop placement
					if ((count _p) > 1) then {
						// 60 percent change for rooftops / toop floor
						if ((random 1) > 0.4) then {
							private "_ap";
							_ap 	= [_p, ADF_fnc_altitudeDescending] call ADF_fnc_positionArraySort;
							_bp	= _ap select 0;							
						} else {
							_bp = _p call BIS_fnc_selectRandom;
						};
					} else {
						_bp = _p select 0;
					};

					// Remove the populated position from the array
					_p	= _p - [_bp];
					
					// Check if there are positions left within the building else remove the building from the buildings array. Set the building varaibles accordingly.
					if ((count _p) == 0) then {
						_bs = _bs - [_b];
						_b setVariable ["ADF_garrPos", []];
						_b setVariable ["ADF_garrPosAvail", false];
					} else {
						_b setVariable ["ADF_garrPos", _p];
					};
					
					// Unit now has a random position within a random building. Pass it the the setGarrison function so thsat the unit will move into the selected position.
					[_x, _bp, _b] spawn ADF_fnc_setGarrison;
					
					// Set the ADF_garrSet for the unit and add his position to an array that is used for headless client management.
					_x setVariable ["ADF_garrSet", true];
					_a append [[_x, _bp]];
					if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea - Unit garrisson array: %1", _a]};
					_i = _i + 1;
				
				} else {if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea - No positions found for unit %1 (nr. %2)", _x, _l]}};
			};
		};
	} forEach _u;
	
	// Clean up the building variables
	[_bs] spawn {
		sleep 60; // wait 1 min before removing the stored building positions as other groups might occupy the same building.
		params ["_bs"];
		{
			_x setVariable ["ADF_garrPos", nil];
			//_x setVariable ["ADF_garrPosAvail", nil];
		} forEach _bs;
	};

	// Set HC loadbalancing variables if a HC is active
	if (ADF_HC_connected) then {
		_g setVariable ["ADF_hc_garrison_ADF", true];
		_g setVariable ["ADF_hc_garrisonArr", _a];
		if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea - ADF_hc_garrisonArr set for group: %1 -- array: %2", _g, _a]};
	};

	// Non garrisoned units patrol the area	
	waitUntil {_c == _l};
	if (_i < _c) then {[_i, _g, _p, _r] spawn ADF_fnc_defendAreaPatrol};

	_ADF_perfDiagStop = diag_tickTime;
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea processed (DIAG: %1)", _ADF_perfDiagStop - _ADF_perfDiagStart]};
};

ADF_fnc_defendArea_HC = {
	/**********************************************************************
	The defendArea_HC function is used by HC's with the loadBalancer active.
	Without this function, garrisoned units would regroup on their leader
	after group ownership transfer (server to HC).
	The function is executed once the HC has ownership of the group. It 
	re-applies garrison positions for each units within the group.
	**********************************************************************/
	// init
	params ["_g", "_a"];
	private ["_i"];
	
	_c = count _a;
	if (_c == 0) exitWith {if (ADF_debug) then {diag_log "----------------------------------------------------------------------"; diag_log format ["ADF Debug: ADF_fnc_defendArea_HC - Passed array: %1 seems to be empty (%2)", _a, _c]}};\
	_g enableAttack false;
	
	if (ADF_debug) then {diag_log "----------------------------------------------------------------------"; diag_log format ["ADF Debug: HC -- ADF_fnc_defendArea_HC - group: %1 -- array count: %2 -- array: %3", _g, _c, _a]};
	
	// reapply garrison position for each unit
	for "_i" from 0 to (_c - 1) do {
		private ["_u", "_up"];
		_ua	= _a select _i;
		_u	= _ua select 0;
		_up	= _ua select 1;
		
		_u setPosATL [_up select 0, _up select 1, ( _up select 2) + .15]; // Direct placement without movement.
		if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_defendArea_HC - SetPosATL for unit: %1 -- position: %2", _u, _up]};
		_u disableAI "move";
		if ((_up select 2) > 4) then {_u setUnitPos "MIDDLE"} else {_u setUnitPos "_UP"};
		_u setDir (_u getVariable ["ADF_garrSetDir", random 360]);
		doStop _u;
		
		[_u] spawn {
			params ["_u"];
			waitUntil {sleep 1 + (random 1); !(unitReady _u)};
			_u enableAI "move";
		};
	};
};