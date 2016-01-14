/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Mission init / Init reporting
Author: Whiztler
Script version: 1.17

Game type: n/a
File: ADF_init_rpt.sqf

Executed on dedicated server only
****************************************************************/

diag_log "ADF RPT: Init - executing ADF_init_rpt.sqf"; // Reporting. Do NOT edit/remove

// Init
private ["_ai", "_p", "_hc", "_m", "_msg"];

_m	= "";
_hc	= count (entities "HeadlessClient_F");
_p	= {alive _x} count (allPlayers - entities "HeadlessClient_F");
_ai	= count (allUnits - (_p + _hc));
if (_ai < 0) then {_ai = 0};

if (ADF_mod_CBA) then {_m = _m + "CBA A3";};
if (ADF_mod_ACRE) then {_m = _m + ", ACRE2";};
if (ADF_mod_TFAR) then {_m = _m + ", TFAR";};
if (ADF_mod_CTAB) then {_m = _m + ", cTab";};
if (ADF_mod_ACE3) then {_m = _m + ", ACE3";};
if (ADF_mod_AIA) then {_m = _m + ", AiATP";};
if (ADF_mod_Ares) then {_m = _m + ", Ares";};
if (ADF_mod_CSAT) then {_m = _m + ", TEC CSAT";};
if (ADF_mod_RHS) then {_m = _m + ", RHS";};

// Init reporting
if (ADF_debug) then {
	diag_log "--------------------------------------------------------------------------------------";
	_msg = format ["Init - ADF version: %1",ADF_tpl_version];
	[_msg, false] call ADF_fnc_log;
	_msg = format ["Init - Mission version: %1",ADF_mission_version];
	[_msg, false] call ADF_fnc_log;
	_msg = format ["Init - Number of players connected: %1", _p];
	[_msg, false] call ADF_fnc_log;
	_msg = format ["Init - Number of HC's connected: %1", _hc];
	[_msg, false] call ADF_fnc_log;	
	_msg = format ["Init - Number of AI's active: %1", _ai];
	[_msg, false] call ADF_fnc_log;
	diag_log "--------------------------------------------------------------------------------------";
} else { // Live mission logging
	diag_log ""; diag_log "";
	diag_log "--------------------------------------------------------------------------------------";
	diag_log format ["ADF RPT: Init - ADF version: %1",ADF_tpl_version];
	diag_log "--------------------------------------------------------------------------------------";
	diag_log format ["ADF RPT: Init - Mission version: %1",ADF_mission_version];
	diag_log format ["ADF RPT: Init - Mission name: %1",(getText (missionConfigFile >> "overviewText"))];
	diag_log format ["ADF RPT: Init - Mission developer: %1",(getText (missionConfigFile >> "author"))];
	diag_log "--------------------------------------------------------------------------------------";
	diag_log format ["ADF RPT: Init - Number of players connected: %1", _p];
	diag_log format ["ADF RPT: Init - Number of HC's connected: %1", _hc];
	diag_log "--------------------------------------------------------------------------------------";
	diag_log format ["ADF RPT: Init - Number of AI's active: %1", _ai];
	diag_log "--------------------------------------------------------------------------------------";
	diag_log format ["ADF RPT: Init - ADF autodetect addons active: %1", _m];
	diag_log "--------------------------------------------------------------------------------------";
	diag_log "ADF_debug mode is disabled (set to 'false'). To debug missions please enable ADF_debug";
	diag_log "by setting 'ADF_debug = true' in the 'ADF_init_config.sqf'";
	diag_log "--------------------------------------------------------------------------------------";
	diag_log ""; diag_log "";
};

// Server FPS reporting in RPT. The frequency of the reporting is based on server performance.
if (ADF_Log_ServerPerfEnable) then {[60,"Server", "Server"] spawn ADF_fnc_statsReporting};