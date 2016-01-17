/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: air suppert script
Author: Whiztler
Script version: 1.00

Game type: N/A
File: ADF_fnc_airSupport.sqf
****************************************************************
Air support function that activates the BIS cas run.

INSTRUCTIONS:
load the function on mission start (e.g. in Scr\init.sqf):
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_airSupport.sqf";

Config:
[
	side,				// Side - side of the CAS plane (west, east, independent).
	position,				// Marker (string), Object, Position (Array [X,Y,Z])
	Approach vector,		// Number - The approach direction. If -1 then the direction of the marker or object is used. 
	CAS weapons type		// 0 - Machinegun (west side only!!)
						// 1 - Missile launcher
						// 2 - Machinegun and missile launcher
] call ADF_fnc_airSupport;

Example for scripted groups:
[west, "casRun", -1, 0] call ADF_fnc_airSupport; // Blufor, Wipeout with machinegun and the marker direction is the approach vector
[east, MRAP1, 40, 1] call ADF_fnc_airSupport; // CSAT, missile run on a vehicle named MRAP1 with a 40 degrees approach vector

Notes

Note this function requires the ADF_fnc_position.sqf:
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_position.sqf";
****************************************************************/

ADF_fnc_airSupport = {
	// init	
	params [
		["_s", west, [east]],
		"_p",
		["_d", -1, [0]],
		["_w", 1, [0]]
	];
	private ["_v", "_vc", "_t", "_a", "_o"];
	
	_v 	= 0;
	_a 	= false;
	_o 	= objNull;
	_vc	= "";
	
	if (_d == -1) then {
		if (typeName _p == "STRING") then {_v = markerDir _p};
		if (typeName _p == "OBJECT") then {_v = getDir _p};
	} else {
		_v = _d;
	};
	systemChat str _v;
	
	if (typeName _p == "OBJECT") then {_a = true; _o = _p} else {false};
	_p 	= [_p] call ADF_fnc_checkPosition;
	
	switch _s do {
		case west 		: {_vc = "B_Plane_CAS_01_F"};
		case east 		: {_vc = "O_Plane_CAS_02_F"; _w = 1};
		case independent	: {_vc = "I_Plane_Fighter_03_CAS_F";  _w = 1};	
	};

	_t = "Land_PenBlack_F" createVehicle _p;
	if (_a) then {_t attachTo [_o]} else {_t enableSimulationGlobal false};	
	_t hideObjectGlobal true;
	_t setVariable ["type", _w];
	_t setVariable ["vehicle", _vc];	
	_t setDir _v;
	
	[_t] spawn {params ["_t"]; sleep 30; deleteVehicle _t};

	[_t, nil, true] call BIS_fnc_moduleCAS;


	
	true	
};