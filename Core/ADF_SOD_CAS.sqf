/****************************************************************
ARMA Mission Development Framework
ADF version: 1.41 / JULY 2015

Script: CAS request with 9-liner
Author: Whiztler
Script version: 1.01

Game type: n/a
File: ADF_SOD_CAS.sqf
****************************************************************
Intructions:
WIP (just the instructions)
****************************************************************/

// Init
ADF_CAS_pos 			= []; // This will be the position where the CAS vehicle does his magic
ADF_CAS_active 		= false;
ADF_CAS_marker		= false;
ADF_CAS_bingoFuel 	= false; 
ADF_CAS_spawn			= getMarkerPos "mAirSupport";
//ADF_CAS_delay			= round (420 + (random 60)); // Delay for the CAS to be created. Simulate that CAS vehicle needs to depart from a distant airbase.
ADF_CAS_delay			= 1 + (random 25); // Delay for the CAS to be created. Simulate that CAS vehicle needs to depart from a distant airbase.
ADF_CAS_onSite		= round (60 + (random 60)); // Time spend in the CAS area. After which the CAS vehicle returns to the spawn location and is deleted.
ADF_CAS_apprDelay 	= 115;

ADF_fnc_CAS_supportRq = {
	// Init
	params ["_unit", "_actionID"];
	// Removed the action
	_unit removeAction _actionID;
	// Map click process. 
	openMap true;
	hintSilent format ["\n%1, click on a location\n on the map where you want\n Close Air Support.\n\n", name vehicle _unit];
	_unit onMapSingleClick {ADF_CAS_pos = _pos; publicVariableServer "ADF_CAS_pos"; onMapSingleClick ""; true; openMap false; hint ""; [] spawn ADF_fnc_CAS_Activated;};
};

ADF_fnc_CAS_Activated = {
	// Init
	private ["_ADF_CAS_posToString","_ADF_CAS_posString","_ADF_CAS_targetTime","_ADF_CAS_delayMin","_ADF_CAS_locVeh","_ADF_CAS_altVeh","_ADF_CAS_MSLlong","_ADF_CAS_MSL"];	
	_ADF_CAS_posToString 	= format ["%1,%2",ADF_CAS_pos select 0,ADF_CAS_pos select 1];
	_ADF_CAS_posString 	= str _ADF_CAS_posToString;
	_ADF_CAS_locVeh		= createVehicle ["Land_HelipadEmpty_F", position player, [], 0, "NONE"];
	_ADF_CAS_altVeh		= getPosASL _ADF_CAS_locVeh;
	_ADF_CAS_MSLlong		= _ADF_CAS_altVeh select 2;
	_ADF_CAS_MSL			= round _ADF_CAS_MSLlong; deleteVehicle _ADF_CAS_locVeh;
	_ADF_CAS_targetTime 	= [(dayTime + 600)] call BIS_fnc_secondsToString;
	_ADF_CAS_delayMin		= str (round (ADF_CAS_delay/60));
	ADF_CAS_vector		= [];
	ADF_CAS_marker 		= true; publicVariableServer "ADF_CAS_marker";

	// 9=liner CAS proc
	hintSilent parseText"<img size= '5' shadow='false' image='Img\2SIERRA_logo.paa'/><br/><br/><t color='#6C7169' align='left'>RAPTOR this is TWO SIERRA. Request OSCAR. How copy?</t><br/><br/>";
	_logTime = [dayTime] call BIS_fnc_timeToString;
	_logTimeText = "Log: " + _logTime;
	player createDiaryRecord ["Two Sierra Log", [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: TWO SIERRA</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>RAPTOR this is TWO SIERRA. Request OSCAR. How copy?</font><br/><br/>"]];
	
	sleep 6;

	hintSilent parseText"<img size= '5' shadow='false' image='Img\6SQDR_logo.paa'/><br/><br/><t color='#6C7169' align='left'>Lt. McDevon: TWO SIERRA this is RAPTOR. Ready to copy.</t><br/><br/>";
	_logTime = [dayTime] call BIS_fnc_timeToString;
	_logTimeText = "Log: " + _logTime;
	player createDiaryRecord ["Two Sierra Log", [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: RAPTOR</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/>	<font color='#6C7169'>Lt. McDevon: TWO SIERRA this is RAPTOR. Ready to copy.</font><br/><br/>"]];
	
	sleep 9;
	
	hintSilent parseText format ["<img size= '5' shadow='false' image='Img\2SIERRA_logo.paa'/><br/><br/><t color='#6C7169' align='left'>RAPTOR with OSCAR:</t><br/><br/><t color='#6C7169' align='left'>PRIORIY: #1</t><br/><t color='#6C7169' align='left'>TARGET: ELVIS, victors, small arms</t><br/><t color='#6C7169' align='left'>LOCATION: %1, %3 MSL</t><br/><t color='#6C7169' align='left'>TARGET TIME: NLT %2</t><br/><t color='#6C7169' align='left'>RESULT: interdict</t><br/><t color='#6C7169' align='left'>CONTROL: 2S PC</t><br/><t color='#6C7169' align='left'>REMARKS: Vectors WEST, Friendlies close. How copy?</t><br/><br/>", _ADF_CAS_posString, _ADF_CAS_targetTime,_ADF_CAS_MSL];
	_logTime = [dayTime] call BIS_fnc_timeToString;
	_logTimeText = "Log: " + _logTime;
	player createDiaryRecord ["Two Sierra Log", [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: TWO SIERRA</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>RAPTOR with OSCAR:<br/><br/>PRIORIY: #1<br/><br/>TARGET: ELVIS, victors, small arms<br/><br/>LOCATION: "+ _ADF_CAS_posString +", "+ str _ADF_CAS_MSL +" MSL<br/><br/>TARGET TIME: NLT "+ _ADF_CAS_targetTime +"<br/><br/>RESULT: interdict<br/><br/>CONTROL: 2S PC<br/><br/>REMARKS: Vectors WEST, Friendlies close. How copy?</font><br/><br/>"]];
	
	sleep 30;
	
	hintSilent parseText format ["<img size= '5' shadow='false' image='Img\6SQDR_logo.paa'/><br/><br/><t color='#6C7169' align='left'>Lt. McDevon: Read back. PRIORIY: #1, TARGET: ELVIS, victors, small arms, LOCATION: %1, %3 MSL, TARGET TIME: NLT %2, RESULT: interdict, CONTROL: 2S PC, REMARKS: Vectors WEST, Friendlies close. </t><br/><br/>", _ADF_CAS_posString, _ADF_CAS_targetTime,_ADF_CAS_MSL];
	_logTime = [dayTime] call BIS_fnc_timeToString;
	_logTimeText = "Log: " + _logTime;
	player createDiaryRecord ["Two Sierra Log", [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: RAPTOR</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>Lt. McDevon: Read back. PRIORIY: #1, TARGET: ELVIS, victors, small arms, LOCATION: "+ _ADF_CAS_posString +", "+ str _ADF_CAS_MSL +" MSL, TARGET TIME: NLT "+ _ADF_CAS_targetTime +", RESULT: interdict, CONTROL: 2S PC, REMARKS: Vectors WEST, Friendlies close.</font><br/><br/>"]];

	sleep 18;
	
	hintSilent parseText "<img size= '5' shadow='false' image='Img\2SIERRA_logo.paa'/><br/><br/><t color='#6C7169' align='left'>Read back correct. Execute OSCAR. Cleared OSCAR. How Copy?</t><br/><br/>";
	
	_logTime = [dayTime] call BIS_fnc_timeToString;
	_logTimeText = "Log: " + _logTime;
	player createDiaryRecord ["Two Sierra Log", [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: TWO SIERRA</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>Read back correct. Execute OSCAR. Cleared OSCAR. How Copy?</font><br/><br/>"]];
	
	sleep 8;
	
	hintSilent parseText format ["<img size= '5' shadow='false' image='Img\6SQDR_logo.paa'/><br/><br/><t color='#6C7169' align='left'>Lt. McDevon: Go on OSCAR. ETA %1 Mikes.</t><br/><br/>",_ADF_CAS_delayMin];
	_logTime = [dayTime] call BIS_fnc_timeToString;
	_logTimeText = "Log: " + _logTime;
	player createDiaryRecord ["Two Sierra Log", [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: RAPTOR</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>Lt. McDevon: Go on OSCAR. ETA "+ _ADF_CAS_delayMin +" Mikes.</font><br/><br/>"]];

	sleep (ADF_CAS_delay - 110); // Raptor takes about 70 secs to reach the AO.	
	ADF_CAS_active = true; publicVariableServer "ADF_CAS_active"; // Inform the server to create the CAS vehicle
	
	waitUntil {sleep 3; ADF_CAS_bingoFuel};
	if (!alive vRaptor) exitWith {
		hintSilent parseText "<img size= '5' shadow='false' image='Img\2SIERRA_logo.paa'/><br/><br/><t color='#6C7169' align='left'>FIRESTONE this is TWO SIERRA. RAPTOR is down. How copy?</t><br/><br/>";
		sleep 12;
		hintSilent parseText"<img size= '5' shadow='false' image='Img\ACO_logo.paa'/><br/><br/><t color='#6C7169' align='left'>FIRESTONE: Copy TWO SIERRA. We'll inform AOC. Stay on mission. Out.</t><br/><br/>";
		_logTime = [dayTime] call BIS_fnc_timeToString;
		_logTimeText = "Log: " + _logTime;
		player createDiaryRecord ["Two Sierra Log", [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: ACO</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>FIRESTONE: Copy TWO SIERRA. We'll inform AOC. Stay on mission. Out.</font><br/><br/>"]];
	};	
	
	hintSilent parseText format ["<img size= '5' shadow='false' image='Img\6SQDR_logo.paa'/><br/><br/><t color='#6C7169' align='left'>Lt. McDevon: TWO SIERRA this is RAPTOR with bingo fuel. We are RTB. Out.</t><br/><br/>",_ADF_CAS_delayMin];
	_logTime = [dayTime] call BIS_fnc_timeToString;
	_logTimeText = "Log: " + _logTime;
	player createDiaryRecord ["Two Sierra Log", [_logTimeText,"<br/><br/><font color='#9da698' size='14'>From: RAPTOR</font><br/><font color='#9da698' size='14'>Time: " + _logTime + "</font><br/><br/><font color='#6c7169'>------------------------------------------------------------------------------------------</font><br/><br/><font color='#6C7169'>Lt. McDevon: TWO SIERRA this is RAPTOR with bingo fuel. We are RTB. Out.</font><br/><br/>"]];
	call ADF_fnc_destroyVars;
};

ADF_fnc_destroyVars = {
	// Destroy not needed variables:
	vRaptor 				= nil; 
	ADF_CAS_pos 			= nil;
	ADF_CAS_active 		= nil;
	ADF_CAS_marker		= nil;
	ADF_CAS_bingoFuel 	= nil; 
	ADF_CAS_spawn			= nil;
	ADF_CAS_delay			= nil;
	ADF_fnc_CAS_supportRq = nil;
	ADF_fnc_CAS_Activated = nil;	
};

// Add the action to the unit that can request CAS
if !(isNil "INF_PC") then {
	if (player != INF_PC) exitWith {};
	_actionID = INF_PC addAction ["<t align='left' color='#f4c300' shadow='false'>Request CAS: RAPTOR",{[[_this select 1, _this select 2],"ADF_fnc_CAS_SupportRq"] call BIS_fnc_MP;},[],-95,false,true,"",""];
};

// From here on server only. Create the CAS vehicle, create markers etc.
if (!isServer) exitWith {};

waitUntil {ADF_CAS_marker}; // wait till the CAS request action was executed

_m = createMarker ["mRaptorSAD", ADF_CAS_pos];
_m setMarkerSize [500, 500];
_m setMarkerShape "ELLIPSE";
_m setMarkerBrush "Border";
_m setMarkerColor "ColorWEST";
_m setMarkerDir 0;

waitUntil {ADF_CAS_active}; // wait till the 9-liners are finished and CAS-delay timer is 0. 

/********************************************
Approach vectors:

North:	 [543.313,5063.63,0]
Median:	 [521.882,3996.98,0] 
South:	 [562.569,2592.54,0]
********************************************/

// Check the Y-coords of the the requested CAS position. Add additional time according to vector location.
if ((ADF_CAS_pos select 1) > 4000) then {ADF_CAS_vector = [543.313,5063.63,0]; ADF_CAS_apprDelay = 80;} else {ADF_CAS_vector = [562.569,2592.54,0]; ADF_CAS_apprDelay = 135;};

// Create RAPTOR
_c = createGroup WEST;
_c setGroupIdGlobal ["RAPTOR"];
_v = [ADF_CAS_spawn, 90, "B_Heli_Attack_01_F", _c] call BIS_fnc_spawnVehicle;
vRaptor = _v select 0;
//vRaptor allowDamage false; // debug
//{_x allowDamage false} forEach units _c; // debug

// Attach marker to RAPTOR
[vRaptor] spawn {	
	params ["_vX"];
	private ["_m"];
	_m = createMarker ["mCasIcon", getPosASL _vX];
	_m setMarkerSize [1, 1];
	_m setMarkerShape "ICON";
	_m setMarkerType "b_air";
	_m setMarkerColor "ColorWEST";
	_m setMarkerText " RAPTOR";
	while {alive _vX} do {"mCasIcon" setMarkerPos (getPosASL _vX);};
	_m setMarkerColor "ColorGrey"; // Raptor is no more...
};

// Create waypoints for RAPTOR based on appraoch vectors
_wp = _c addWaypoint [ADF_CAS_vector, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "FULL";
_wp setWaypointCombatMode "BLUE";
_wp setWaypointCompletionRadius 250;

_wp = _c addWaypoint [ADF_CAS_pos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "COMBAT";
_wp setWaypointSpeed "NORMAL";
_wp setWaypointCombatMode "RED";

sleep ADF_CAS_apprDelay; // Let Raptor reach the AO
if (!alive vRaptor) exitWith {ADF_CAS_bingoFuel = true; publicVariable "ADF_CAS_bingoFuel"; call ADF_fnc_destroyVars;};

vRaptor flyInHeight 100;

sleep ADF_CAS_onSite; // Limited time in AO
if (!alive vRaptor) exitWith {ADF_CAS_bingoFuel = true; publicVariable "ADF_CAS_bingoFuel"; call ADF_fnc_destroyVars;};

// RTB Bingo Fuel
deleteMarker "mRaptorSAD";
ADF_CAS_bingoFuel = true; publicVariable "ADF_CAS_bingoFuel";
vRaptor flyInHeight 250;

_wp = _c addWaypoint [ADF_CAS_vector, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "FULL";
_wp setWaypointCombatMode "BLUE";
_wp setWaypointCompletionRadius 350;

_wp = _c addWaypoint [ADF_CAS_spawn, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "FULL";
_wp setWaypointCombatMode "BLUE";
waitUntil {(currentWaypoint (_wp select 0)) > (_wp select 1)};

// Delete Raptor and Raptor crew
if !(isNil "vRaptor") then {{deleteVehicle _x} forEach (crew vRaptor); deleteVehicle vRaptor;};
deleteMarker "mCasIcon";

call ADF_fnc_destroyVars;


