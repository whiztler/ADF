/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / NOVEMBER 2015

Script: Para drop script
Author: Whiztler
Script version: 1.00

Game type: N/A
File: ADF_fnc_createPara.sqf
****************************************************************
This script creates a transport helicopter and a infantry fire team
or infantry squad. The units are loaded onto the helicopter and then
flown to the drop off point where they will para drop.

You can pass 2 functions to the script:

Function1 will run (call) on individual units once the infantry group has
been created (e.g. a loadout script). Params passed to the function:
_this select 0: unit 

Function2 will run (spawn) on the group itself. Can be used to give the
group directives once they have landed (e.g. assault waypoints).
Params passed to the function:
_this select 0: group.

After dropping off the para group, the helicopter returns to the spawn
position where the helicopter and its crew are deleted.

INSTRUCTIONS:
load the function on mission start (e.g. in Scr\init.sqf):
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_createPara.sqf";

Config:
[
	Spawn position,		// E.g. getMarkerPos "Spawn". This is where both the heli and the group is created
	Para drop position,		// E.g. getMarkerPos "drop". The para drop starts 350 m from the drop position
	side,				// west, east or independent
	group size,			// Number:
						// 1 - Fire team
						// 2 - Squad
	"function1",			// String (optional) - function to run on each created para unit
	"function2",			// String (optional) - Function to run on the para group.	
] call ADF_fnc_createAirPatrol;

Example for scripted groups:
[getMarkerPos "paraSpawn", getMarkerPos "paraDrop", east, 2, "My_fnc_loadouteast", "My_fnc_paraAssault"] spawn ADF_fnc_createPara;
[getMarkerPos "paraSpawn", getMarkerPos "paraDrop", east, 2, "", ""] spawn ADF_fnc_createPara;
[_ps, _pd, east, 2, "", "my_fnc_killThemAll"] spawn ADF_fnc_createPara;

Notes

Note this function requires the ADF_fnc_position.sqf:
call compile preprocessFileLineNumbers "Core\F\ADF_fnc_position.sqf";
****************************************************************/


ADF_fnc_createPara = {
	// init
	params ["_ps", "_pd", ["_s", east, [east]], ["_gt", 2, [0]], ["_f1", "", [""]], ["_f2", "", [""]]];
	private ["_vc", "_c", "_g" ,"_gf", "_gfs", "_gft", "_u", "_wp", "_sbi", "_sb", "_ub", "_t"];
	_vc		= "";
	_gs		= "";
	_gf		= "";
	_gfs		= "";
	_gft		= "";
	_sbi		= [];
	_sb		= "";
	_d 		= random 360;
	
	// Check the direction of the spawn position
	if (_ps isEqualType "") then {
		_d = markerDir _ps
	} else {
		if (_ps isEqualType objNull) then {
			_d = getDir _ps
		};
	};
	
	// Check the spawn/drop-off position
	_ps 	= [_ps] call ADF_fnc_checkPosition;
	_pd	= [_pd] call ADF_fnc_checkPosition;
	
	// Check the side to determine the class of the transport helicopter and the para group
	switch _s do {
		case west		: {_vc = "B_Heli_Transport_01_F"; _gf = "BLU_F"; _gfs = str _s; _gft = "BUS"};
		case east		: {_vc = "O_Heli_Transport_04_bench_F"; _gf = "OPF_F"; _gfs = str _s; _gft = "OIA"};
		case independent	: {_vc = "I_Heli_light_03_unarmed_F"; _gf = "IND_F"; _gfs = "Indep"; _gft = "HAF"};
	};
	
	// Create the helicopter at the spawnposition
	_c = createGroup _s;
	_v = [_ps, (random 360), _vc, _c] call BIS_fnc_spawnVehicle;
	_v = _v select 0;
	_v setDir _d;
	
	// Let's give the pilot a lot of alcohol so he doesn't get scared too much.
	_cp = driver _v;
	_cp disableAI "AUTOTARGET";	
	_cp disableAI "TARGET";
	_cp setBehaviour "COMBAT";	
	_cp setCombatMode "BLUE";
	_cp enableAttack false;
	
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_createPara - Heli crew group: %1 --- Helicopter:", _c, _v]};
	
	// Determine groupsize and put together classname for ACM
	switch _gt do {
		case 1		: {_gs = "_InfTeam"};
		case 2		: {_gs = if ((random 1) < 0.75) then {if (_s == independent) then {"_InfSquad"} else {"_InfAssault"}} else {"_InfSquad_Weapons"}};
	};
	
	_gs = format ["%1%2", _gft, _gs];
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_createPara - group ACM class: %1", _gs]};
	
	// Create the para group and assign them into the cargo of the helicopter
	_g = createGroup _s;
	_g = [_ps, _s, (configFile >> "CfgGroups" >> _gfs >> _gf >> "Infantry" >> _gs)] call BIS_fnc_spawnGroup;	
	_u = units _g;
	_g setVariable ["ADF_noHC_transfer", true];
	_g setVariable ["zbe_cacheDisabled", true];
	
	// Run the units function on the para group units
	if (_f1 != "") then {
		{[_x] call (call compile format ["%1", _f1])} forEach _u;
		if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_createPara - call %1 for units of group: %2", _f1, _g]};
	};
	if (_f2 != "") then {
		[_g] spawn (call compile format ["%1", _f2]);
		if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_createPara - spawn %1 for group: %2", _f2, _g]};
	};

	// If the unit has backpack then store the backpack + backpack items
	// The we move the unit inside the cargo of the heli
	{
		if ((backpack _x) != "") then {
			_sbi = backpackItems _x;
			_sb = backpack _x;
			removeBackpack _x;
			_ub = true;
		};
		_x assignAsCargo _v;
		_x moveInCargo _v;
		_x allowDamage false;
		_x disableCollisionWith _v;
	} forEach _u;
	
	[_u] allowGetIn false;
	
	// Check distance to dropoff location and spawn the para drop function
	[_u, _ub, _sb, _sbi, _v, _pd] spawn {
		params ["_u", "_ub", "_sb", "_sbi", "_v", "_pd"];
		waitUntil {
			sleep 1;
			private ["_p"];
			_p = getPosASL _v;		
			(round (_p distance2D _pd) < 350)
		};
		{[_x, _ub, _sb, _sbi] spawn ADF_fnc_paraDrop; sleep 0.6} forEach _u;
	};
	
	// Create the waypoints for the helicopter
	_v flyInHeight 125;
	_wp = _c addWaypoint [_pd, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointBehaviour "COMBAT";
	_wp setWaypointCombatMode "GREEN";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointCompletionRadius 50;
	
	_wpx = _c addWaypoint [_ps, 0];
	_wpx setWaypointType "MOVE";
	_wpx setWaypointBehaviour "COMBAT";
	_wpx setWaypointCombatMode "GREEN";
	_wpx setWaypointSpeed "NORMAL";
	_wpx setWaypointCompletionRadius 50;
	
	waitUntil {sleep 2; !(alive _v) || ((currentWaypoint (_wp select 0)) > (_wp select 1))};
	_t = round time;
	waitUntil {sleep 1; !(alive _v) || (time == _t + 300) || ((currentWaypoint (_wpx select 0)) > (_wpx select 1))};
	if !(isNil "_v") then {{deleteVehicle _x} forEach (crew _v); deleteVehicle _v;};
};


ADF_fnc_paraDrop = {
	// Paradrop function for para group
	// init
	params ["_u", "_ub", "_sb", "_sbi"];
	private ["_pc", "_p", "_v", "_g"];
	_pc = "Steerable_Parachute_F";
	_vp = getPosASL (vehicle _u);
	_g	= group _u;
	
	unassignVehicle _u;
	_u action ["EJECT", vehicle _u];	
	
	_u setPosASL [_vp select 0, _vp select 1, (_vp select 0) - 2.5];
	
	_p = createVehicle [_pc, getPosASL _u, [], 0, 'FLY'];
	_u assignAsDriver _p;
	_u moveInDriver _p;
	
	if (_u == leader _g) then {
		private ["_s", "_sc"];
		_sc	= ["SmokeShellRed", "SmokeShellPurple"] call BIS_fnc_selectRandom;
		_s	= createVehicle [_sc, getPos _p, [], 0, "FLY"];
		_s attachTo [_p, [0.8, 0, 0]];
	};
	
	sleep 3;	
	_u allowDamage true;
	
	waitUntil {sleep 1; getPosATL _u select 2 < 5 || isNull _u};
	_u allowDamage false;
	
	waitUntil {sleep 1; isTouchingGround _u || isNull _u};
	if (_ub) then {_u addBackpack _sb; {_u addItemToBackpack _x} forEach _sbi};
	_u allowDamage true;
	_g setVariable ["ADF_noHC_transfer", false];
	_g setVariable ["zbe_cacheDisabled", false];
};