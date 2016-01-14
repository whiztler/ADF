/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: IED scripts
Author: Whiztler
Script version: 1.05

Game type: COOP
File: ADF_fnc_createIED.sqf
****************************************************************
IED functions:
ADF_fnc_createRandomIEDs
ADF_fnc_carBomb
****************************************************************/


ADF_fnc_createRandomIEDs = {
	/****************************************************************
	Instructions:
	Execute on server:

	// Create random IED"s
	_iedMarkerArr = ["mIED_1", "mIED_2", "mIED_3", "mIED_4", "mIED_5", "mIED_6", "mIED_7", "mIED_8", "mIED_9", "mIED_10", "mIED_11", "mIED_12", "mIED_13", "mIED_14", "mIED_15", "mIED_16", "mIED_17", "mIED_18", "mIED_19"];
	for "_i" from 1 to 10 do {
		private ["_iedMarkerPos", "_v", "_mN", "_m", "_idx"];
		_iedMarkerPos = _iedMarkerArr call BIS_fnc_selectRandom;
		_idx =  _iedMarkerArr find _iedMarkerPos;
		_iedMarkerArr deleteAt _idx;
		[
			_iedMarkerPos, // Markers array
			100,			// Radius from marker
			250,			// Search road position radius
			4.5			// IED position from middle of the road (use 4.5 for small roads, 6 for large roads, or 5 as medium)
		] call ADF_fnc_createRandomIEDs;
	};
	****************************************************************/

	// init
	params [["_p", "", [""]], ["_r", 100, [0]], ["_d", 260, [0]], ["_dx", 4.5, [0]]];
	private ["_v", "_o", "_a", "_ap", "_apx", "_apy", "_ad", "_ax", "_i", "_t"];
	
	_p	= getMarkerPos _p;
	_o	= ["Land_Wreck_Car3_F", "Land_GarbagePallet_F", "Land_CanisterPlastic_F", "Land_Sack_F", "Land_JunkPile_F", "Land_BarrelTrash_F", "Land_GarbageBarrel_01_F"] call BIS_fnc_selectRandom;
	//_o	= ["IEDLandBig_F", "IEDUrbanBig_F", "IEDLandSmall_F", "IEDUrbanSmall_F"] call BIS_fnc_selectRandom;
	_a	= [];
	_ap	= [];
	_ad	= 0;
	_ax	= 0;
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_createRandomIEDs - passed position: %1", _p]};

	// Search for IED locations within the search radius. Try 3 times
	for "_i" from 1 to 3 do { 
		_a = [_p, _r, _d] call ADF_fnc_randomPos_IED;
		if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_createRandomIEDs -random position: %1", _a]};
		_ap = _a select 0;
		_ad = _a select 1;
		if (isOnRoad _ap) exitWith {if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_createRandomIEDs -position on road: %1", _ap]};};
	};
	
	// Debug position found
	if (ADF_debug) then {_v = createVehicle ["Sign_Arrow_Direction_Green_F", _ap, [], 0, "NONE"]; _v setDir _ad;};
	
	// create offset position
	_ax = _ad + 90;
	_apx = (_ap select 0) + (_dx * sin _ax);
	_apy = (_ap select 1) + (_dx * cos _ax);	
		
	// create the IED (random object)
	if (ADF_debug) then {
		_v = createVehicle ["Sign_Arrow_Cyan_F", [_apx, _apy, 1], [], 0, "CAN_COLLIDE"];
		_v enableSimulationGlobal false;
	};	
	
	_v = createVehicle [_o, [_apx, _apy, 0], [], 0, "NONE"];
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_createRandomIEDs -IED object created: %1", _v]};
	
	if (ADF_debug) then {
		private ["_mName", "_m"];
		_mName = format ["IEDclass_%1",round (random 9999)];
		_m = createMarker [_mName,[_apx, _apy, 0]];
		_m setMarkerSize [0, 0];
		_m setMarkerShape "ICON";
		_m setMarkerType "mil_dot";
		_m setMarkerColor "ColorBlack";
		_m setMarkerText format ["%1", _o];
	};
	
	// Disguise the IED
	_v enableSimulationGlobal false;
	_v setDir (random 360);	
	
	switch _o do {
		case "Land_Wreck_Car3_F" : {_v setVectorUp [0.1, 0, 0]; _v setPosATL [getPosATL _v select 0, getPosATL _v select 1, -.30];};
		case	 "Land_CanisterPlastic_F" : {_v setVectorUp [0.08, 0, 0]; _v setPosATL [getPosATL _v select 0, getPosATL _v select 1, -.05];};
		case "Land_Sack_F" : {_v setVectorUp [0, 0.1, 0.01]; _v setPosATL [getPosATL _v select 0, getPosATL _v select 1, -.05];};
		case "Land_JunkPile_F";
		case "Land_GarbagePallet_F" : { _v setPosATL [getPosATL _v select 0, getPosATL _v select 1, -.20];};
		case "Land_GarbageBarrel_01_F" : {_v setVectorUp [0.1, 0, 0]; _v setPosATL [getPosATL _v select 0, getPosATL _v select 1, -.10];};
		case "Land_BarrelTrash_F" : {_v setVectorUp [0.1, 0, 0]; _v setPosATL [getPosATL _v select 0, getPosATL _v select 1, -.08];};
	};
	
	// Create the trigger
	_t = createTrigger ["EmptyDetector", _ap, false];
	_t setTriggerActivation ["west", "PRESENT", false];
	_t setTriggerArea [4, 3, _ax, true];
	_t setTriggerTimeout [0, 0, 0, false];
	_t setTriggerStatements [
		"{vehicle _x in thisList && isPlayer _x && ((getPosATL _x) select 2) < 5} count allUnits > 0;",
		"[thisTrigger] call ADF_fnc_carBombDetonate; deleteVehicle thisTrigger;",
		""
	];
	
	if (ADF_debug) then {
		private ["_mName", "_m"];
		_mName = format ["obj_t%1",round (random 9999)];
		_m = createMarker [_mName, _ap];
		_m setMarkerSize [4, 3];
		_m setMarkerShape "RECTANGLE";
		_m setMarkerColor "ColorRED";
		_m setMarkerDir _ax;
		_m setMarkerType "empty";
	};
};


ADF_fnc_createCarBomb = {
	/****************************************************************
	Instructions:
	Execute on server:
	
	// Create carbomb at a single location (e.g. marker)
	[
		"myMarker",		// Marker where the car should be created
		50,				// trigger radius
		west,			// Side that can active the trigger
		"C_Van_01_fuel_F"	// IED position from middle of the road (use 4.5 for small roads, 6 for large roads, or 5 as medium)
	] call ADF_fnc_createCarBomb;	

	// Create car bomb multiple locations (in an array)
	_carMarkerArr = ["mCar_1", "mCar_2", "mCar_3", "mCar_4", "mCar_5"];
	{
		[
			_x, 				// marker in the _carMarkerArr array
			50,				// trigger radius
			west,			// Side that can active the trigger
			"C_Van_01_fuel_F"	// IED position from middle of the road (use 4.5 for small roads, 6 for large roads, or 5 as medium)
		] call ADF_fnc_createCarBomb;
	} forEach _carMarkerArr
	****************************************************************/

	// Init
	params [	"_p", ["_r", 50, [0]], ["_s", west, [east]], ["_vc", "C_Van_01_fuel_F", [""]]];
	private ["_v", "_d", "_t"];
	_d	= 0;
	
	if (_p isEqualType "") then {
		_d = markerDir _p
	} else {
		if (_p isEqualType objNull) then {
			_d = getDir _p
		} else {
			_d = random 360
		};
	};
	
	// Check the position (marker, array, etc.)
	_p	= [_p] call ADF_fnc_checkPosition;
	
	// Create te vehicle
	_v = createVehicle [_vc, _p, [], 0, "NONE"];
	_v setDir _d;
	_v lock 2;
	
	// Create the trigger
	_t = createTrigger ["EmptyDetector", _p, false];
	_t setTriggerActivation [str _s,"PRESENT", false];
	_t setTriggerArea [_r, _r, 0, false];
	_t setTriggerTimeout [0, 0, 0, false];
	_t setTriggerStatements [
		"{vehicle _x in thisList && isPlayer _x && ((getPosATL _x) select 2) < 5} count allUnits > 0;",
		"[thisTrigger] call ADF_fnc_carBombDetonate; deleteVehicle thisTrigger;",
		""
	];
	
	// Debug
	if (ADF_debug) then {
		private ["_mName", "_m"];
		_mName = format ["mCB%1",round (random 9999)];
		_m = createMarker [_mName, _p];
		_m setMarkerSize [_r, _r];
		_m setMarkerShape "ELLIPSE";
		_m setMarkerColor "ColorRED";
		_m setMarkerType "empty";};
};


ADF_fnc_randomPos_IED = {

	// Init
	params ["_p", "_r", "_rr"];
	private ["_px", "_py", "_d", "_rd", "_rda", "_rdp", "_rdd", "_rdx"];
	_d = random 360;
	
	// Create random position from centre & radius
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_randomPos_IED -passed position: %1", _p]};
	_px = (_p select 0) + (_r * sin _d);
	_py = (_p select 1) + (_r * cos _d);
	
	// new position
	_p = [_px, _py, 0];
	if (ADF_debug) then {
		diag_log format ["ADF Debug: ADF_fnc_randomPos_IED -new position: %1", _p];
		private ["_mName", "_m"];
		_mName = format ["obj_%1",round (random 9999)];
		_m = createMarker [_mName, _p];
		_m setMarkerSize [.7, .7];
		_m setMarkerShape "ICON";
		_m setMarkerType "mil_dot";
		_m setMarkerColor "ColorBLACK";
		_m setMarkerText "search pos";
	};
	
	// Check nearby raods from new position
	_rda	= _p nearRoads _rr;
	_rdp	= [];
	_rdd	= 0; // road dir
	if (count _rda == 0) then {if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_randomPos_IED - no road positions found", _rda]}};
	
	// if road position found, use it else use original position
	if (count _rda > 0) then {		
		_rd	= _rda select 0;
		_rdp	= getPos _rd;		
		_rdx	= roadsConnectedTo _rd;
		if (count _rdx > 0) then {
			_rdX	= _rdx select 0;
			if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_randomPos_IED - road positions found: %1 -- connected to: %2", _rdp, _rdx]};
			_rdd	= [_rd, _rdX] call BIS_fnc_DirTo;
			if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_randomPos_IED - road positions direction: %2", _rdd]};
		} else {
			if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_randomPos_IED - No connecting road found: %1", _rdx]};
		};
	} else {
		_rdp = _p;
		_rdd = 0;
		if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_randomPos_IED - NO road positions found. Using org postition: %1 with direction: %2", _rdp, _rdd]};
	};
	
	if (ADF_debug) then {
		private ["_mName", "_m"];
		_mName = format ["obj_%1",round (random 9999)];
		_m = createMarker [_mName, _rdp];
		_m setMarkerSize [.7, .7];
		_m setMarkerShape "ICON";
		_m setMarkerType "mil_dot";
		_m setMarkerColor "ColorGREEN";
		_m setMarkerText format ["road pos - %1",round _rdd];
	};

	// return the position + dir
	[_rdp, _rdd]
};

ADF_fnc_carBombDetonate = {
	if (!isServer) exitWith {};
	params ["_t"];
	private ["_p", "_v", "_b"];
	
	_p = getPosATL _t;
	_a = nearestObjects [_p, ["CAR"], 8];
	if (count _a == 0) exitWith {if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_carBombDetonate - no vehicle found", _a]};};
	
	_v = _a select 0;
	_v allowDamage false;
	_v enableSimulationGlobal false;
	
	_b = createVehicle ["HelicopterExploBig", _p, [], 0, "NONE"];
	_b = createVehicle ["Bo_GBU12_LGB", [_p select 0, _p select 1, (_p select 2) + 3], [], 0, "NONE"];		
	
	enableCamShake true;
	addCamShake [4, 3, 3];
	_v allowDamage true;
	_v enableSimulationGlobal true;
	_v setDamage 1;
	
	true
};

ADF_fnc_iedDetonate = {
	if (!isServer) exitWith {};
	params ["_t"];
	private ["_tp", "_p", "_a", "_b"];

	_tp = getPosATL _t;
	if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_iedDetonate - trigger (%1) position: %2", _t, _tp]};
	
	_a = nearestObjects [_tp, ["Land_Wreck_Car3_F", "Land_GarbagePallet_F", "Land_CanisterPlastic_F", "Land_Sack_F", "Land_JunkPile_F", "Land_BarrelTrash_F", "Land_GarbageBarrel_01_F"], 8];
	if (count _a == 0) exitWith {if (ADF_debug) then {diag_log format ["ADF Debug: ADF_fnc_iedDetonate - no IED object found", _a]}};
	_p = getPos (_a select 0);
	{deleteVehicle _x} forEach _a;
	
	_b = createVehicle ["HelicopterExploSmall", _p, [], 0, "NONE"];

	true
};