/****************************************************************
ARMA Mission Development Framework
ADF version: 1.39 / MAY 2015

Script: customize call signs and radio freq/channels for groups
Author: Whiztler
Script version: 2.1

Game type: n/a
File: ADF_presets.sqf
****************************************************************
This script lets you customize call signs and radio freqs for groups.
The call signs and radio freqs are displayed in the roster, cTAB,
MicroDAGR, etc.
You Only need to configure the call sign for the leader of the
group. All other team members will get the correct call sign
automatically.
****************************************************************/

///// Nopryl Preset
ADF_preset_NOPRYL = {
	_ADF_presetData_NOPRYL = [

		//---------- INFANTRY PLATOON & COMPANY COMMAND ----------
		
		//	Call Sign, 		TFAR LR	TFAR SW
		[	"GANDALF",		30,		55],	// Company Commander
		
		[	"FOXHOUND",		40,		100],	// INF Platoon Cmd
		
		[	"FOX-1",		40,		110],	// INF 1-1 SQUAD Rifle Squad
		[	"FOX-1-1",		40,		111],	// INF 1-1 ALPHA Fire team
		[	"FOX-1-2",		40,		112],	// INF 1-1 BRAVO Fire team
		
		[	"FOX-2",		40,		120],	// INF 1-2 SQUAD Rifle Squad
		[	"FOX-2-2",		40,		121],	// INF 1-2 ALPHA Fire team
		[	"FOX-2-3",		40,		122],	// INF 1-2 BRAVO Fire team
		
		[	"FOX-3",		40,		130],	// INF 1-3 SQUAD Weapons Squad
		[	"FOX-3-1",		40,		131],	// INF 1-3 ALPHA Weapons Team	
		[	"FOX-3-2",		40,		132],	// INF 1-3 BRAVO Weapons Team
		
		//---------- CAVALRY BATTERY ----------
		
		//	Call Sign, 		TFAR LR, 	TFAR SW	
		[	"KNIGHT",		50,		200],	// CAV Battery Cmd 
		
		[	"DAGGER-1",		50,		211],	// CAV 2-1 ALPHA APC crew
		[	"DAGGER-2",		50,		212],	// CAV 2-1 BRAVO APC crew
		[	"DAGGER-3",		50,		213],	// CAV 2-1 CHARLIE APC crew
		
		[	"BROADSWORD-1",	50,		221],	// CAV 2-2 ALPHA MBT crew
		[	"BROADSWORD-2",	50,		222],	// CAV 2-2 BRAVO MBT crew
		
		[	"STORM-1",		50,		231],	// CAV 2-3 ALPHA ART crew	
		[	"STORM-2",		50,		232],	// CAV 2-3 BRAVO ART crew
		
		//---------- AIR WING ----------
		
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"RAPTOR",		60,		300],	// Air Wing Cmd - MH-9 crew
		
		[	"HAWK",			60,		311],	// AIR 3-1 ALPHA AH-99 crew
		[	"FALCON",		60,		312],	// AIR 3-1 BRAVO AH-9 crew

		[	"CONDOR-1",		60,		321],	// AIR 3-2 ALPHA UH-80 crew
		[	"CONDOR-2",		60,		322],	// AIR 3-2 BRAVO UH-80 crew
		[	"CONDOR-3",		60,		323],	// AIR 3-2 CHARLIE CH-67 crew
		
		[	"EAGLE-1",		60,		341],	// AIR 3-3 ALPHA A-164 Pilot	
		[	"EAGLE-2",		60,		342],	// AIR 3-3 BRAVO A-164 Pilot	
		
		//---------- SPECIAL OPERATIONS SQUADRON ----------
		
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"DIREWOLF",		70,		400],	// SOR Squadron Cmd
		
		[	"WOLF-1",		70,		411],	// SOR 4-1 MIKE SpecOp team
		[	"WOLF-2",		70,		412],	// SOR 4-1 ROMEO Explosives team
		[	"WOLF-3",		70,		413],	// SOR 4-1 YANKEE Recon UAV team
		[	"WOLF-4",		70,		413],	// SOR 4-1 ZULU Amphibious team

		[	"PROPHET-1",	70,		421],	// SOR 4-2 ALPHA Sniper team
		[	"PROPHET-1",	70,		422],	// SOR 4-2 BRAVO Sniper team
		
		[	"ANGEL",		80,		431],	// SOR 4-3 FOXTROT JTAC	
		
		//---------- GAME MASTER UNITS (ZEUS) ----------
		
		[	"GM-1",			35,		350],	// GM-1
		[	"GM-2",			35,		350]	// GM-2
		
		// DO NOT EDIT BELOW
	];
	if (ADF_debug) then {["PRESETS - NOPRYL preset loaded",false] call ADF_fnc_log};
	_ADF_presetData_NOPRYL;
};


///// Default/SHAPE Preset
ADF_preset_DEFAULT = {
	_ADF_presetData_DEFAULT = [

		//---------- INFANTRY PLATOON & COMPANY COMMAND ----------
		
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"CO CMD",		30,		55],	// Company Commander
		
		[	"1 PLT",		40,		100],	// INF Platoon Cmd
		
		[	"1-1 SQUAD",	40,		110],	// INF 1-1 SQUAD Rifle Squad
		[	"1-1 ALPHA",	40,		111],	// INF 1-1 ALPHA Fire team
		[	"1-1 BRAVO",	40,		112],	// INF 1-1 BRAVO Fire team
		
		[	"1-2 SQUAD",	40,		120],	// INF 1-2 SQUAD Rifle Squad
		[	"1-2 ALPHA",	40,		121],	// INF 1-2 ALPHA Fire team
		[	"1-2 BRAVO",	40,		122],	// INF 1-2 BRAVO Fire team
		
		[	"1-3 SQUAD",	40,		130],	// INF 1-3 SQUAD Weapons Squad
		[	"1-3 ALPHA",	40,		131],	// INF 1-3 ALPHA Weapons Team	
		[	"1-3 BRAVO",	40,		132],	// INF 1-3 BRAVO Weapons Team
		
		//---------- CAVALRY BATTERY ----------
		
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"2 BAT",		50,		200],	// CAV Battery Cmd
		[	"2-1 ALPHA",	50,		211],	// CAV 2-1 ALPHA APC crew
		[	"2-1 BRAVO",	50,		212],	// CAV 2-1 BRAVO APC crew
		[	"2-1 CHARLIE",	50,		213],	// CAV 2-1 CHARLIE APC crew
		
		[	"2-2 ALPHA",	50,		221],	// CAV 2-2 ALPHA MBT crew
		[	"2-2 BRAVO",	50,		222],	// CAV 2-2 BRAVO MBT crew
		
		[	"2-3 ALPHA",	50,		231],	// CAV 2-3 ALPHA ART crew	
		[	"2-3 BRAVO",	50,		232],	// CAV 2-3 BRAVO ART crew
		
		//---------- AIR WING ----------
		
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"3 WING",		60,		300],	// Air Wing Cmd
		
		[	"3-1 ALPHA",	60,		311],	// AIR 3-1 ALPHA AH-99 crew
		[	"3-1 BRAVO",	60,		312],	// AIR 3-1 BRAVO AH-9 crew

		[	"3-2 ALPHA",	60,		321],	// AIR 3-2 ALPHA UH-80 crew
		[	"3-2 BRAVO",	60,		322],	// AIR 3-2 BRAVO UH-80 crew
		[	"3-2 CHARLIE",	60,		323],	// AIR 3-2 CHARLIE CH-67 crew
		
		[	"3-3 ALPHA",	60,		331],	// AIR 3-3 ALPHA A-164 Pilot	
		[	"3-3 BRAVO",	60,		332],	// AIR 3-3 BRAVO A-164 Pilot	
		
		//---------- SPECIAL OPERATIONS SQUADRON ----------
		
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"4 SQDR",		70,		400],	// SOR Squadron Cmd
		
		[	"4-1 LIMA",		70,		411],	// SOR 4-1 MIKE SpecOp team
		[	"4-1 MIKE",		70,		412],	// SOR 4-1 ROMEO Explosives team
		[	"4-1 ROMEO",	70,		413],	// SOR 4-1 YANKEE Recon UAV team
		[	"4-1 ZULU",		70,		414],	// SOR 4-1 ZULU Amphibious team

		[	"4-2 TANGO",	70,		421],	// SOR 4-2 ALPHA Sniper team
		[	"4-2 VICTOR",	70,		422],	// SOR 4-2 BRAVO Sniper team
		
		[	"4-3 FOXTROT",	80,		431],	// SOR 4-3 FOXTROT JTAC	
				
		//---------- GAME MASTER UNITS (ZEUS) ----------
		
		[	"GM-1",			35,		350],	// GM-1
		[	"GM-2",			35,		350]	// GM-2
	
	// DO NOT EDIT BELOW
	];
	if (ADF_debug) then {["PRESETS - DEFAULT preset loaded",false] call ADF_fnc_log};
	_ADF_presetData_DEFAULT;
};

// Custom preset. Use this preset if you want to create your own call signs and frequencies
ADF_preset_CUSTOM = {
	_ADF_presetData_CUSTOM = [

		//---------- INFANTRY PLATOON & COMPANY COMMAND ----------
		
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"CO CMD",		30,		55],	// Company Commander
		
		[	"1 PLT",		40,		100],	// INF Platoon Cmd
		
		[	"1-1 SQUAD",	40,		110],	// INF 1-1 SQUAD Rifle Squad
		[	"1-1 ALPHA",	40,		111],	// INF 1-1 ALPHA Fire team
		[	"1-1 BRAVO",	40,		112],	// INF 1-1 BRAVO Fire team
		
		[	"1-2 SQUAD",	40,		120],	// INF 1-2 SQUAD Rifle Squad
		[	"1-2 ALPHA",	40,		121],	// INF 1-2 ALPHA Fire team
		[	"1-2 BRAVO",	40,		122],	// INF 1-2 BRAVO Fire team
		
		[	"1-3 SQUAD",	40,		130],	// INF 1-3 SQUAD Weapons Squad
		[	"1-3 ALPHA",	40,		131],	// INF 1-3 ALPHA Weapons Team	
		[	"1-3 BRAVO",	40,		132],	// INF 1-3 BRAVO Weapons Team
		
		//---------- CAVALRY BATTERY ----------
		
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"2 BAT",		50,		200],	// CAV Battery Cmd
		[	"2-1 ALPHA",	50,		211],	// CAV 2-1 ALPHA APC crew
		[	"2-1 BRAVO",	50,		212],	// CAV 2-1 BRAVO APC crew
		[	"2-1 CHARLIE",	50,		213],	// CAV 2-1 CHARLIE APC crew
		
		[	"2-2 ALPHA",	50,		221],	// CAV 2-2 ALPHA MBT crew
		[	"2-2 BRAVO",	50,		222],	// CAV 2-2 BRAVO MBT crew
		
		[	"2-3 ALPHA",	50,		231],	// CAV 2-3 ALPHA ART crew	
		[	"2-3 BRAVO",	50,		232],	// CAV 2-3 BRAVO ART crew
		
		//---------- AIR WING ----------
		
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"3 WING",		60,		300],	// Air Wing Cmd
		
		[	"3-1 ALPHA",	60,		311],	// AIR 3-1 ALPHA AH-99 crew
		[	"3-1 BRAVO",	60,		312],	// AIR 3-1 BRAVO AH-9 crew

		[	"3-2 ALPHA",	60,		321],	// AIR 3-2 ALPHA UH-80 crew
		[	"3-2 BRAVO",	60,		322],	// AIR 3-2 BRAVO UH-80 crew
		[	"3-2 CHARLIE",	60,		323],	// AIR 3-2 CHARLIE CH-67 crew
		
		[	"3-3 ALPHA",	60,		331],	// AIR 3-3 ALPHA A-164 Pilot	
		[	"3-3 BRAVO",	60,		332],	// AIR 3-3 BRAVO A-164 Pilot	
		
		//---------- SPECIAL OPERATIONS SQUADRON ----------
		
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"4 SQDR",		70,		400],	// SOR Squadron Cmd
		
		[	"4-1 LIMA",		70,		411],	// SOR 4-1 MIKE SpecOp team
		[	"4-1 MIKE",		70,		412],	// SOR 4-1 ROMEO Explosives team
		[	"4-1 ROMEO",	70,		413],	// SOR 4-1 YANKEE Recon UAV team
		[	"4-1 ZULU",		70,		414],	// SOR 4-1 ZULU Amphibious team

		[	"4-2 TANGO",	70,		421],	// SOR 4-2 ALPHA Sniper team
		[	"4-2 VICTOR",	70,		422],	// SOR 4-2 BRAVO Sniper team
		
		[	"4-3 FOXTROT",	80,		431],	// SOR 4-3 FOXTROT JTAC	
				
		//---------- GAME MASTER UNITS (ZEUS) ----------
		
		[	"GM-1",			35,		350],	// GM-1
		[	"GM-2",			35,		350]	// GM-2
		
	// DO NOT EDIT BELOW
	];	
	if (ADF_debug) then {["PRESETS - CUSTOM preset loaded",false] call ADF_fnc_log};
	_ADF_presetData_CUSTOM;
};

// Wolfpack campaign preset
ADF_preset_WP = {
	_ADF_presetData_WP = [
		[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],
		//	Call Sign,		TFAR LR,	TFAR SW	
		[	"WOLF-1",		50,		100],	// Wolfpack Wolf-1
		[	"WOLF-2",		50,		200],	// Wolfpack Wolf-2
		[	"WOLF-3",		50,		300],	// Wolfpack Wolf-3
		[],[],[],[],[],[],[]
	// DO NOT EDIT BELOW
	];	
	if (ADF_debug) then {["PRESETS - WOLFPACK preset loaded",false] call ADF_fnc_log};
	_ADF_presetData_WP;
};

if (ADF_debug) then {["PRESETS - presets function processed",false] call ADF_fnc_log};