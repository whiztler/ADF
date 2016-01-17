/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Distance functions
Author: Whiztler
Script version: 1.01

Game type: N/A
File: ADF_fnc_distance.sqf
***************************************************************/

// Functions init
diag_log "ADF RPT: Init - executing ADF_fnc_distance.sqf"; // Reporting. Do NOT edit/remove


/***************************************************************
Name: ADF_fnc_checkDistance

Parameters required:
a. marker / object / vehicle / group
1. marker / object / vehicle / group

Optional parameters:
n/a

Returns:
Integer (distance number)
***************************************************************/

ADF_fnc_checkDistance = {
	params ["_a", "_b"];
	private ["_return"];
	_a		= _a call ADF_fnc_checkPosition; // get the position of the first param
	_b		= _b call ADF_fnc_checkPosition; // get the position of the second param
	_return	= round (_a distance2D _b); // return the distance between the first and the second param
	_return
};


/***************************************************************
Name: ADF_fnc_checkClosest

Parameters required:
a. array (e.g. AllPlayers, allUnits, etc)
1. marker / object / vehicle / group (to check against)

Optional parameters:
2. radius (number)

Returns:
Integer (distance number)
***************************************************************/

ADF_fnc_checkClosest = {
	params ["_a", "_b",["_r", 10^5,[0]]];	
	private ["_return"];
	_return = _r + 1;
	{
		_return = [_x, _b] call ADF_fnc_checkDistance;
		if (ADF_Debug) then {diag_log format ["ADF RPT: Debug - ADF_fnc_checkClosest: distance to %1: %2 meters", _b, _return]};
		if (_return < _r) then {_r = _return};
	} forEach _a;
	_return	
};


/***************************************************************
Name: ADF_fnc_countRadius

Parameters required:
a. position (Marker, unit, group, object)
1. side to check (east, wets, independent, etc)
2. radius (number)

Optional parameters:
3. type ("man", "car", "apc", "tank", "all" - default: "man")
   either string for a single type or an array for multiple types

Returns:
Integer (number of units / vehicles / etc.)
***************************************************************/

ADF_fnc_countRadius = {
	params [
		"_p",
		["_s", east, [west]],
		["_r", 100, [0]],
		"_t"
	];
	private "_c";
	
	_p	= [_p] call ADF_fnc_checkPosition;
	
	_c = {side _x == _s} count (_p nearEntities [_t, _r]);
	_c	
};


