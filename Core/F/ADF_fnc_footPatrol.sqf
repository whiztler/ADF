/****************************************************************
ARMA Mission Development Framework
ADF version: 1.42 / SEPTEMBER 2015

Script: foot patrol script
Author: Whiztler
Script version: 1.00

Game type: N/A
File: ADF_fnc_footPatrol.sqf
****************************************************************
This is an infantry foot patrol function. You can use it on pre-existing groups
or the function can create the group for you as well

INSTRUCTIONS:
load the function on mission start (e.g. in Scr\init.sqf):
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_footPatrol.sqf";

*** PATROL ONLY ***

Config:
[
	group,				// Group name - Name of the group.
	position,				// Array or Position - E.g. getMarkerPos "Spawn" -or- Position Player
	radius,				// Number - Radius from the start position in which a waypoint is created
	waypoints,			// Number - Number of waypoint for the patrol
	waypoint type,			// String. Info: https://community.bistudio.com/wiki/Waypoint_types
	behaviour,			// String. Info: https://community.bistudio.com/wiki/setWaypointBehaviour
	combat mode,			// String. Info: https://community.bistudio.com/wiki/setWaypointCombatMode
	speed,				// String. Info: https://community.bistudio.com/wiki/waypointSpeed
	formation,			// String. Info: https://community.bistudio.com/wiki/waypointFormation
	completion radius		// Number. Info: https://community.bistudio.com/wiki/setWaypointCompletionRadius
] call ADF_fnc_footPatrol;

Example for scripted groups:
[_grp, _Position, 300, 5, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 25] call ADF_fnc_footPatrol;
[_grp, getMarkerPos "PatrolMarker", 500, 6, "MOVE", "SAFE", "RED", "LIMITED","FILE",25] call ADF_fnc_footPatrol;

Notes

Note this function requires the ADF_fnc_position.sqf:
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_position.sqf";

*** CREATE GROUP + PATROL ***

Config:
[
	position,				// Array or Position - E.g. getMarkerPos "Spawn" -or- Position Player
	side,				// WEST, EAST or INDEPENDENT
	group size,			// 2 (sentry), 4 (fireteam), 8 squad
	weapons squad,			// TRUE or FALSE
	radius,				// Number - Radius from the start position in which a waypoint is created
	waypoints,			// Number - Number of waypoint for the patrol
	waypoint type,			// String. Info: https://community.bistudio.com/wiki/Waypoint_types
	behaviour,			// String. Info: https://community.bistudio.com/wiki/setWaypointBehaviour
	combat mode,			// String. Info: https://community.bistudio.com/wiki/setWaypointCombatMode
	speed,				// String. Info: https://community.bistudio.com/wiki/waypointSpeed
	formation,			// String. Info: https://community.bistudio.com/wiki/waypointFormation
	completion radius		// Number. Info: https://community.bistudio.com/wiki/setWaypointCompletionRadius
] call ADF_fnc_createFootPatrol;

Example for scripted groups:
[_spawnPos, WEST, 6, FALSE, 300, 5, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5] call ADF_fnc_createFootPatrol;
[getMarkerPos "myMarker", EAST, 8, TRUE, 500, 6, "MOVE", "SAFE", "RED", "LIMITED", "FILE", 5] call ADF_fnc_createFootPatrol;

Notes

Note this function requires the ADF_fnc_position.sqf:
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_position.sqf";
****************************************************************/

ADF_fnc_addWaypoint = {
	// init	
	params ["_g","_p","_r","_t","_b","_m","_s","_f","_cr"];
	private ["_wp"];

	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_addWaypoint - WP radius: %1",_r]};
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_addWaypoint - passed pos (before check): %1",_p]};
	_p = [_p] call ADF_fnc_checkPosition;
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_addWaypoint - passed pos (after check): %1",_p]};
	
	// Create the waypoint
	_wp = _g addWaypoint [_p, _r];
	
	// add the waypoint parameters
	_wp setWaypointType _t;
	_wp setWaypointBehaviour _b;
	_wp setWaypointCombatMode _m;
	_wp setWaypointSpeed _s;
	_wp setWaypointFormation _f;
	_wp setWaypointCompletionRadius _cr;
	
	// return the waypoint
	_wp 
};

ADF_fnc_footPatrol = {
	params ["_g","_p","_r","_c","_t","_b","_m","_s","_f","_cr"];
	private ["_a","_i","_cycle"];

	_a = [_g,_p,_r,_t,_b,_m,_s,_f,_cr];

	// Loop through the number of waypoints needed
	for "_i" from 0 to _c do {
		_a call ADF_fnc_addWaypoint;
		if (ADF_debug) then {diag_log " "; diag_log format ["ADF Debug: ADF_fnc_footPatrol - called ADF_fnc_addWaypoint for WP %1",_i]};
	};
	
	// Add a cycle waypoint
	_cycle =+ _a;
	_cycle set [3, "CYCLE"];
	_cycle call ADF_fnc_addWaypoint;
	if (ADF_debug) then {diag_log " "; diag_log "ADF Debug: ADF_fnc_footPatrol - called ADF_fnc_addWaypoint for cycle WP"};

	// Remove the spawn/start waypoint
	deleteWaypoint ((waypoints _g) select 0);
};

ADF_fnc_createFootPatrol = {
	params ["_p","_gs","_gc","_gw","_r","_c","_t","_b","_m","_s","_f","_cr"];
	private ["_gSize","_gSide","_gFact","_gID","_gStr"];
	
	// check group size/type
	switch (_gc) do {
		case 1;
		case 2: {_gSize = "InfSentry"};
		case 3;
		case 4;
		case 5: {_gSize = "InfTeam"};
		case 6;
		case 7;
		case 8: {if (_gw) then {_gSize = "InfSquad_Weapons"} else {_gSize = "InfSquad"}};		
		default {_gSize = "InfTeam"};
	};
	
	switch (_gs) do {
		case WEST:		{_gSide = "WEST"; _gFact = "BLU_F"; _gID = "BUS_"};
		case EAST: 		{_gSide = "EAST"; _gFact = "OPF_F"; _gID = "OIA_"};
		case INDEPENDENT:	{_gSide = "INDEP"; _gFact = "IND_F"; _gID = "HAF_"};
	};
	
	_gStr = _gID + _gSize;

	//Create the group
	_g = [_p, _gs, (configFile >> "CfgGroups" >> _gSide >> _gFact >> "Infantry" >> _gStr)] call BIS_fnc_spawnGroup;
	
	[_g, _p, _r, _c, _t, _b, _m, _s , _f , _cr] call ADF_fnc_footPatrol;
	
	true	
};




