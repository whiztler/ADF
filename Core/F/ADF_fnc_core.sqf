/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Framework functions
Author: whiztler
Script version: 1.01

Game type: N/A
File: ADF_fnc_core.sqf
****************************************************************
Core functions used by the ADF.
****************************************************************/

if (isServer) then {diag_log "ADF RPT: Init - executing ADF_fnc_core.sqf"}; // Reporting. Do NOT edit/remove


// if (ADF_debug) then {["YourTextMessageHere", true] call ADF_fnc_log}; // where true or false for error message
ADF_fnc_log = {
	// 0 - String: message
	// 1 - Bool: true/false - error message?) 

	// init
	params ["_m", "_e"];
	private ["_h", "_w"];
	
	// Is it an error message?
	if (_e) then { 
		_h = "ADF Error: ";
		_w = _h + _m;
		[_w] call BIS_fnc_error;
		diag_log _w;
		
	// Is it a debug log message?	
	} else { 
		_h = "ADF Debug: ";
		_w = _h + _m;
		_w remoteExec ["systemChat", -2, false];
		diag_log _w;		
	};	
};

ADF_fnc_stripUnit = {	
	// 0 - object: AU unit, player
	// 1 - Bool: true/false - remove uniform) 

	// init
	params ["_o", ["_u", true, [false]]];
	
	removeAllWeapons _o;
	removeAllAssignedItems _o;
	removeHeadgear _o;
	removeGoggles _o;
	removeVest _o;
	removeBackpack _o;
	if (_u) then  {removeUniform _o};
	
	true	
};

/****************************************************************
From here on HC and Server only
****************************************************************/
if (hasInterface && isMultiplayer) exitWith {};

ADF_fnc_statsReporting = {
	params ["_s", "_n", "_c"];
	private ["_a", "_p", "_f", "_h", "_t", "_m"];

	waitUntil {
		// init
		_f	= round (diag_fps);	
		_h	= count (entities "HeadlessClient_F");
		_u	= {alive _x} count allPlayers;
		_p	= _u - _h;
		_a	= {local _x} count allUnits;		
		
		if (_a < 0)  then {_a = 0};
		if (_f > 30) then {_s = 60};
		if (_f < 30) then {_s = 30};
		if (_f < 20) then {_s = 20};
		if (_f < 10) then {_s = 10};
		
		_t = [(round time)] call BIS_fnc_secondsToString;
		diag_log format ["ADF RPT: %1 PERF - Total players: %2  --  Total AI's: %3", _n, _p, _a];
		_m = format ["ADF RPT: %1 PERF - Elapsed time: %2  --  %3 FPS: %4  --  %3 Min FPS: %5", _n, _t, _c, _f, round (diag_fpsmin)];
		diag_log _m;
		if (ADF_Debug && (_c == "Server")) then {_m remoteExec ["systemChat", -2, false]};
		uiSleep _s;
		false
	};
};

ADF_fnc_stripVehicle = {
	// 0 - object: vehicle
	
	//init
	params ["_v"];

	clearWeaponCargoGlobal _v;
	clearBackpackCargoGlobal _v;	
	clearMagazineCargoGlobal _v;
	clearItemCargoGlobal _v;
	
	true
};