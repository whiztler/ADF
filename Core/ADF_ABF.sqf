/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Altitude Based Fatigue (ABF)
Author: Whiztler
Script version: 1.00

Game type: N/A
File: ADF_ABF.sqf
****************************************************************
Instructions:

Configure in ADF_init_config.sqf
****************************************************************/

if (!hasInterface) exitWith {}; // clients only - double check

// Init
private ["_u", "_f1", "_f2", "_f3", "_f4", "_f5", "_f", "_s"];
_u 	= player;
_f1	= 1.10 + random 0.05;	// 10%
_f2	= 1.20 + random 0.05; 	// 25%
_f3	= 1.40 + random 0.10; 	// 50%
_f4	= 1.60 + random 0.10; 	// 75
_f5	= 2; 					// 125
_s	= 60;					// runs every xx seconds
_f 	= [];

_u enableFatigue true;

ADF_fnc_ABF_update = {
	private ["_u", "_h", "_f"];
	params ["_u"];
	_f	= getFatigue _u;
	_h	= getPosASL _u;
	_f	= [_h select 2, _f];
	_f
};

waitUntil {
	private ["_a"];
	_a = [_u] call ADF_fnc_ABF_update;
	if !((vehicle player) isKindOf "Air") then {
		if (_a select 0 <= 1500) then {player setFatigue (_a select 1)};
		if ((_a select 0 > 1500) && (_a select 0 <= 2000)) then {player setFatigue (_a select 1) * _f1};
		if ((_a select 0 > 2000) && (_a select 0 <= 3000)) then {player setFatigue (_a select 1) * _f2};
		if ((_a select 0 > 3000) && (_a select 0 <= 4000)) then {player setFatigue (_a select 1) * _f3};
		if ((_a select 0 > 4000) && (_a select 0 <= 5000)) then {player setFatigue (_a select 1) * _f4};
		if (_a select 0 > 5000)  then {player setFatigue (_a select 1) * _f5};
		if ((getFatigue _u) >= 1) then {player setFatigue 1};
	};
	sleep _s;
	(!alive _u)
};