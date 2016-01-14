if (isServer) then {diag_log "ADF RPT: Init - executing ADF_fnc_MHQ.sqf"}; // Reporting. Do NOT edit/removediag_log "ADF RPT: Init - executing ADF_fnc_MHQ.sqf"; // Reporting. Do NOT edit/remove

/***************************  MHQ functions  *****************************/

// Function fired up by the 'KILLED' eventhandler when the MHQ is destroyed
ADF_fnc_MHQ_respawnInit = { 

	ADF_MHQ_respawnLeft = ADF_MHQ_respawnLeft - 1;
	
	if (ADF_MHQ_respawnLeft != 0) then { 
		// Clean up the FOB if the MHQ was destroyed whilst the FOB was deployed
		if (ADF_MHQ_deployed) then {
			if (isServer) then {[0] spawn ADF_fnc_fobRemove};
			waitUntil {sleep 1; fobDeleted};
			ADF_MHQ_deployed = false;
		};
		// Start the MHQ respawn function
		[] spawn ADF_fnc_MHQ_respawn;
		if (hasInterface) then {hintSilent parseText format ["<img size= '6' shadow='false' image='%1'/><br/><br/><t color='#6C7169' size='1.5'>%2 MHQ</t><br/><br/><t color='#A1A4AD' align='left'>The MHQ was destroyed. The MHQ respawns in</t><t color='#FFFFFF' align='left'> %3 </t><t color='#A1A4AD' align='left'>minute(s).</t><br/><br/><t color='#A1A4AD' align='left'>MHQ reinforcements left: </t><t color='#FFFFFF' align='left'>%4</t><br/><br/>", ADF_clanLogo, ADF_clanName, (ADF_MHQ_respawnTime / 60), ADF_MHQ_respawnLeft];};
	} else { 
		// All mobile HQ respawns used. Create a permanent player respawn location
		if (isServer) then {
			[0] spawn ADF_fnc_fobRemove;
			waitUntil {sleep 1; fobDeleted};
			[] call ADF_fnc_MHQ_FinalSpawn;
			sleep 30;
			deleteMarker "mMHQ";
		};
		if (hasInterface) then {hintSilent parseText format ["<img size= '6' shadow='false' image='%1'/><br/><br/><t color='#6C7169' size='1.5'>%2 MHQ</t><br/><br/><t color='#A1A4AD' align='left'>The MHQ was destroyed. There are</t><t color='#FFFFFF' align='left'> no </t><t color='#A1A4AD' align='left'>more MHQ reinforcements left.</t><br/><br/><t color='#A1A4AD' align='left'>The new player respawn position is now at grid: </t><t color='#FFFFFF' align='left'>%3 %4</t><br/><br/>", ADF_clanLogo, ADF_clanName, round (ADF_MHQ_lastPos select 0), round (ADF_MHQ_lastPos select 1)]};
	};
};


// Update the last safe MHQ position
ADF_fnc_MHQ_lastPos = {  
	ADF_MHQ_lastPos = getPosATL MHQ; publicVariable "ADF_MHQ_lastPos";
};


// Attach the respawn_west marker to the FOB
ADF_fnc_MHQ_PlayerRespawnPos = { 
	private ["_p"];
	_p = getPosATL MHQ;
	"respawn_west" setMarkerPos [(_p select 0) + 3, (_p select 1) + 3, 0];				
};


// Attach the HQ Flag marker to the MHQ vehicle (updated every half second when on the move)
ADF_fnc_MHQ_marker = {	
	while {alive MHQ} do {
		"mMHQ" setMarkerPos getPosATL MHQ;
		// Marker refresh time	
		if (speed MHQ > 0) then {sleep .5;} else {sleep 10}; 	
	};
	// MHQ is destroyed, delete the Flag Marker
	"mMHQ" setMarkerColor "ColorGrey"; 
};


// MHQ vehicle respawn time as configured in init.sqf
ADF_fnc_MHQ_respawn = {
	
	sleep ADF_MHQ_respawnTime; 
	
	if (isServer) then {
		private ["_m"];
		
		// Create a new MHQ
		MHQ = createVehicle [ADF_MHQ_vehicle,ADF_MHQ_orgPos, [], 0, "none"]; publicVariable "MHQ"; 
		MHQ setDir ADF_MHQ_dir;
		
		// Create a new 'HQ flag' marker
		deleteMarker "mMHQ";
		_m = createMarker ["mMHQ",ADF_MHQ_orgPos];
		_m setMarkerShape "ICON";
		_m setMarkerType "b_hq";
		_m setMarkerSize [.8, .8];
		
		// re-add the EH and AddAction (new spawned MHQ)
		MHQ addEventHandler ["killed", {[] spawn ADF_fnc_MHQ_respawnInit;}];
		 // Load the supplies
		[MHQ] execVM "Core\C\ADF_vCargo_B_MHQ.sqf";
			
		[] call ADF_fnc_MHQ_PlayerRespawnPos; // reload to update with new position
		[] spawn ADF_fnc_MHQ_marker; // reload to update
	};
	
	if (hasInterface) then {
		// re-add the EH and AddAction (new spawned MHQ)
		MHQ addEventHandler ["killed", {[] spawn ADF_fnc_MHQ_respawnInit;}];
		ADF_MHQ_FOB_deployAction = MHQ addAction ["<t align='left' color='#c0d6b2'>Deploy the F.O.B.</t>",{remoteExec ["ADF_fnc_fobDeploy", 0, true];},[],-98, false, true,"", ""];
		
		// Display a hint that the MHQ has respawned
		hintSilent parseText format ["<img size= '6' shadow='false' image='%1'/><br/><br/><t color='#6C7169' size='1.5'>%2 MHQ</t><br/><br/><t color='#A1A4AD'>Mobile HQ respawned at grid:</t><br/><t color='#FFFFFF'>%3 %4</t><br/><br/>", ADF_clanLogo, ADF_clanName, round (ADF_MHQ_orgPos select 0), round (ADF_MHQ_orgPos select 1)];
		sleep 5;
		hintSilent "";
	};
};

ADF_fnc_MHQ_FinalSpawn = {
	private ["_m", "_v"];
	
	// All MHQ's destroyed. Create marker to show final player respawn location
	_m = createMarker ["mFinalSpawn",getMarkerPos "respawn_west"];
	_m setMarkerShape "ICON"; 
	_m setMarkerSize [0.8, 0.8]; 
	_m setMarkerType "respawn_inf";	
	_m setMarkerColor "Colorwest";
	
	// Create the flagPole
	if (ADF_clanFlag != "") then {
		ADF_respawnFlag = createVehicle ["Flag_White_F", getMarkerPos "respawn_west", [], 0, "NONE"];
		ADF_respawnFlag setFlagTexture ADF_clanFlag;		
	} else {
		ADF_respawnFlag = createVehicle ["Flag_NATO_F", getMarkerPos "respawn_west", [], 0, "NONE"];
	};
	
	// Remove the respawn marker when all Tickets are used.
	if (ADF_Tickets) then {
		waitUntil {sleep 10; ([west] call BIS_fnc_respawnTickets) == 0};
		deleteMarker "mFinalSpawn";
		deleteVehicle ADF_respawnFlag;
	};
};


/************************ FOB functions **************************/


// deploy the fob
ADF_fnc_fobDeploy = { 
	// Exit with a message if the FOB already is deployed
	if (ADF_MHQ_deployed) exitWith { 
		if (hasInterface) then {
			hintSilent parseText format ["<img size= '6' shadow='false' image='%1'/><br/><br/><t color='#6C7169' size='1.5'>%2 MHQ</t><br/><br/><t color='#A1A4AD'>The F.O.B. is already deployed</t><br/><br/>", ADF_clanLogo, ADF_clanName];
			sleep 5;
			hintSilent "";
		};
	};
	// Exit with a message if the the MHQ is not stationary
	if (speed MHQ > 1) exitWith {  
		if (hasInterface) then {
			hintSilent parseText format ["<img size= '6' shadow='false' image='%1'/><br/><t color='#6C7169' size='1.5'>%2 MHQ</t><br/><br/><t color='#A1A4AD'>The MHQ needs to be stationary for the F.O.B. to be deployed!</t><br/><br/>", ADF_clanLogo, ADF_clanName];
			sleep 5;
			hintSilent "";
		};
	};
	
	// Remove the FOB deploy action menu item.
	MHQ removeAction ADF_MHQ_FOB_deployAction;
	ADF_MHQ_fuel = fuel MHQ;
	MHQ setFuel 0;	
	
	// Create the FOB
	if (isServer) then {
		private ["_f", "_o"];
		
		_o = [
			[["Flag_NATO_F",[-5.23633, 0.240234, 0], 70, 1, 0,[],"", "if (ADF_clanFlag != '') then {_this setFlagTexture '" + ADF_clanFlag + "';};", true, false]], 
			[["Land_Pallet_MilBoxes_F",[5.23633, 2.33203, 0], 90, 1, 0,[],"", "", true, false]], 
			[["CamoNet_BLUFOR_F",[6.56055,-0.185547, 1], 90, 1, 0,[],"", "", true, false]], 
			[["B_supplyCrate_F",[6.91406,-0.630859, 0], 0, 1, 0,[],"", "", true, false]], 
			[["Land_Pallet_MilBoxes_F",[7.19336, 2.43555, 0], 70, 1, 0,[],"", "", true, false]], 
			[["Land_PaperBox_open_full_F",[6.25, 4.49609, 0], 10, 1, 0,[],"", "", true, false]], 
			[["Land_Cargo20_military_green_F",[-7.71875,-0.671875, 0], 90, 1, 0,[],"", "_this allowDamage false;", true, false]], 
			[["Land_HBarrierBig_F",[-0.175781,-8.28125, 0], 0, 1, 0,[],"", "_this allowDamage false;", true, false]], 
			[["Land_HBarrier_3_F",[-7.64063, 5.05859, 0], 90, 1, 0,[],"", "_this allowDamage false;", true, false]], 
			[["Land_HBarrierBig_F",[-0.0683594, 9.27734, 0], 0, 1, 0,[],"", "_this allowDamage false;", true, false]], 
			[["Land_HBarrier_3_F",[-7.67578,-4.50586, 0], 90, 1, 0,[],"", "_this allowDamage false;", true, false]], 
			[["Land_HBarrierBig_F",[11.9688, 3.82813, 0], 70, 1, 0,[],"", "_this allowDamage false;", true, false]], 
			[["Land_HBarrierBig_F",[12.0762,-4.19727, 0], 110, 1, 0,[],"", "_this allowDamage false;", true, false]]
		];
		
		{[getPosATL MHQ, getDir MHQ, _x] call BIS_fnc_ObjectsMapper; sleep (ADF_MHQ_BuildTime / 10);} forEach _o;
		
		ADF_MHQ_deployed = true; publicVariable "ADF_MHQ_deployed"; // Announce that the FOB has been deployed
		
		[] call ADF_fnc_MHQ_lastPos; // update LastPos
		[] call ADF_fnc_MHQ_PlayerRespawnPos; // update respawn_west
	};	
	
	// Announce message
	if (hasInterface) then {
		hintSilent parseText format ["<img size= '6' shadow='false' image='%1'/><br/><t color='#6C7169' size='1.5'>%2 MHQ</t><br/><br/><t color='#A1A4AD'>Deploying the F.O.B.</t><br/><t color='#A1A4AD'>F.O.B. ready in:</t><t color='#FFFFFF'> %3 </t><t color='#A1A4AD'>seconds</t><br/><br/>", ADF_clanLogo, ADF_clanName, ADF_MHQ_BuildTime];
		sleep 5;
		hintSilent "";
	
		waitUntil {sleep 1; ADF_MHQ_deployed};
		
		hintSilent parseText format ["<img size= '6' shadow='false' image='%1'/><br/><t color='#6C7169' size='1.5'>%2 MHQ</t><br/><br/><t color='#A1A4AD'>F.O.B. deployed</t><br/><br/>", ADF_clanLogo, ADF_clanName];
		sleep 5;
		hintSilent "";
	};
	
	// Add the FOB packUp action menu item
	ADF_MHQ_FOB_PackupAction = MHQ addAction ["<t align='left' color='#c0d6b2'>Pack up the F.O.B.</t>",{remoteExec ["ADF_fnc_fobPackUp", 0, true]},[],-98, false, true,"", ""];
	fobDeleted = false;	
};


// pack up the fob	
ADF_fnc_fobPackUp = { 
	MHQ removeAction ADF_MHQ_FOB_PackupAction;

	if (hasInterface) then {
		hintSilent parseText format ["<img size= '6' shadow='false' image='%1'/><br/><t color='#6C7169' size='1.5'>%2 MHQ</t><br/><br/><t color='#A1A4AD'>Packing-up the F.O.B.</t><br/><t color='#A1A4AD'>MHQ ready in:</t><t color='#FFFFFF'> %3 </t><t color='#A1A4AD'>seconds</t><br/><br/>", ADF_clanLogo, ADF_clanName, ADF_MHQ_PackUpTime];  
		sleep 5;
		hintSilent "";
		sleep (ADF_MHQ_PackUpTime - 5);
		if (alive MHQ) then {ADF_MHQ_FOB_deployAction = MHQ addAction ["<t align='left' color='#c0d6b2'>Deploy the FOB</t>",{remoteExec ["ADF_fnc_fobDeploy", 0, true]},[],-98, false, true,"", ""]};
		
		waitUntil {sleep 1; fobDeleted};
		
		MHQ setFuel ADF_MHQ_fuel;	
		hintSilent parseText format ["<img size= '6' shadow='false' image='%1'/><br/><t color='#6C7169' size='1.5'>%2 MHQ</t><br/><br/><t color='#A1A4AD'>F.O.B. packed up.<br/>MHQ is ready to go.</t><br/><br/>", ADF_clanLogo, ADF_clanName];
		sleep 5;
		hintSilent "";		
	};
	
	if (isServer) then {
		[10] spawn ADF_fnc_fobRemove;		
		waitUntil {sleep 1; fobDeleted};
		MHQ setFuel ADF_MHQ_fuel;	
	};
	
	ADF_MHQ_deployed = false;
};


// Delete FOB objects
ADF_fnc_fobRemove = {
	params ["_s"];
	private ["_q", "_o"];

	_q = ["Flag_NATO_F", "Land_Pallet_MilBoxes_F", "CamoNet_BLUFOR_F", "B_supplyCrate_F", "Land_PaperBox_open_full_F", "Land_Cargo20_military_green_F", "Land_HBarrierBig_F", "Land_HBarrier_3_F"];
	_o = nearestObjects [getPos MHQ, _q, 14];
	_t = 0;	
	if (_s == 0) then {_t = 0.01} else {_t = ADF_MHQ_PackUpTime / _s};

	{deleteVehicle _x; sleep _t;} forEach _o;
	fobDeleted = true; publicVariable "fobDeleted";
};