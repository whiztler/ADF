/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Framework functions
Author: whiztler
Script version: 1.00

Game type: N/A
File: ADF_fnc_core.sqf
****************************************************************
Core functions used by the ADF.
****************************************************************/

if (isServer) then {diag_log "ADF RPT: Init - executing ADF_fnc_core.sqf"}; // Reporting. Do NOT edit/remove


// if (ADF_debug) then {["YourTextMessageHere", true] call ADF_fnc_log}; // where true or false for error message
ADF_fnc_log = {
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


/****************************************************************
From here on HC and Server only
****************************************************************/
if (hasInterface) exitWith {};

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