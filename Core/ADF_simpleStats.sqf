/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Simple Server/Mission Stats (Headless Client enabled)
Author: Whiztler
Script version: 3.14

Game type: n/a
File: ADF_simpleStats.sqf
****************************************************************
Instructions:

Execute the script using a trigger with radio alpha/bravo/etc
****************************************************************/

// Init
private ["_c", "_s"];
ADF_sStats_textServer 	= "";
ADF_sStats_textHeadless1	= "";
ADF_sStats_textHeadless2	= "";
ADF_sStats_textHeadless3	= "";
_s						= 0.5;
_c						= 0;

while {(_c != 20)} do {
	private "_ADF_textIntro";
	_c = _c + 1;
	
	ADF_fnc_SimpleStatsCheck = {
		params ["_c", "_n", "_m"];
		private ["_ADF_FPS"];
		
		if (isMultiplayer) then {_ADF_FPS = round (diag_fps)} else {_ADF_FPS = "N/A";};
		
		_m = format ["
			<t color='#FFFFFF' align='left' font='PuristaMedium' size='.9'>%1:</t><br/>
			
			<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>FPS:</t>
			<t color='#FFFFFF' align='right' font='PuristaMedium' size='.9'>%2</t><br/>
			
			<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Units west:</t>
			<t color='#799cff' align='right' font='PuristaBold' size='.9'>%3</t><br/>
			<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Units east:</t>
			<t color='#ff8989' align='right' font='PuristaBold' size='.9'>%4</t><br/>
			<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Units independent:</t>
			<t color='#d8ff5f' align='right' font='PuristaBold' size='.9'>%5</t><br/>
			<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Units Civilian:</t>
			<t color='#eebffd' align='right' font='PuristaBold' size='.9'>%6</t><br/><br/>",
			_n,																	// 1
			_ADF_FPS, 															// 2			
			{(local _x) && (side _x == west)} count allUnits, 			// 3
			{(local _x) && (side _x == east)} count allUnits, 			// 4
			{(local _x) && (side _x == independent)} count allUnits, 	// 5
			{(local _x) && (side _x == CIVILIAN)} count allUnits 		// 6
		];

		if (_c == 0) exitWith {ADF_sStats_textServer = _m; publicVariable "ADF_sStats_textServer"};
		if (_c == 1) exitWith {ADF_sStats_textHeadless1 = _m; publicVariable "ADF_sStats_textHeadless1"};
		if (_c == 2) exitWith {ADF_sStats_textHeadless2 = _m; publicVariable "ADF_sStats_textHeadless2"};
		if (_c == 3) exitWith {ADF_sStats_textHeadless3 = _m; publicVariable "ADF_sStats_textHeadless3"};
		
	};	

	if (isDedicated || isServer) then {[0,"Server",ADF_sStats_textServer] call ADF_fnc_SimpleStatsCheck};
	if (ADF_isHC1) then {[1,"Headless Client 1",ADF_sStats_textHeadless1] call ADF_fnc_SimpleStatsCheck};
	if (ADF_isHC2) then {[2,"Headless Client 2",ADF_sStats_textHeadless2] call ADF_fnc_SimpleStatsCheck};
	if (ADF_isHC3) then {[3,"Headless Client 3",ADF_sStats_textHeadless2] call ADF_fnc_SimpleStatsCheck};
		
	_ADF_textIntro = format ["
		<t color='#FFFFFF' size='1.3' font='PuristaMedium'>SERVER STATS</t><br/><br/>		
		<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Game time:</t>
		<t color='#FFFFFF' align='right' font='PuristaMedium' size='.9'>%1</t><br/>
		<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Total Units:</t>
		<t color='#FFFFFF' align='right' font='PuristaMedium' size='.9'>%2</t><br/>
		<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Total Players:</t>
		<t color='#FFFFFF' align='right' font='PuristaMedium' size='.9'>%3</t><br/>	
		<t color='#A1A4AD' align='left' font='PuristaMedium' size='.9'>Total Groups:</t>
		<t color='#FFFFFF' align='right' font='PuristaMedium' size='.9'>%4</t><br/><br/>",
		[(round time)] call BIS_fnc_secondsToString, 					//1
		count allUnits,												//2
		{alive _x} count (allPlayers - entities "HeadlessClient_F"),	//3
		count allGroups												//4		
	];
		
	if (hasInterface) then {hintSilent parseText (_ADF_textIntro + ADF_sStats_textServer + ADF_sStats_textHeadless1 + ADF_sStats_textHeadless2 + ADF_sStats_textHeadless3)}; // v1.42B01
	
	UiSleep _s;
};

hintSilent "";
