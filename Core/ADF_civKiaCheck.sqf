/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Civilian KIA Check
Author: Shuko (Adapted for A3 by Whiztler)
Script version: 1.3

Game type: N/A
File: ADF_civKiaCheck.sqf
****************************************************************
Instructions:

This script checks for the number of civilians being killed
by BlueFor. When a civilian is KIA, a warning message is displayed.
The location is marked on the map with a green mil-dot.
****************************************************************/


ADF_civKilled = 0;
if (isServer) then {
	ADF_fnc_civKia_EH = {
		private ["_s", "_p"];
		_p = getPos (_this select 0);
		_s = side (_this select 1);
		ADF_civKiller = _this select 1;
		
		if (rating ADF_civKiller < 0) then {ADF_civKiller addRating 9999; publicVariable "ADF_civKiller";}; 
		
		if (_s == ADF_playerSide) then {
			private "_m";
			ADF_civKilled = ADF_civKilled + 1;
			publicVariable "ADF_civKilled"; publicVariable "ADF_civKiller";
			_m = createMarker [format ["m_ADF_civKilled_%1", ADF_civKilled], _p];
			_m setMarkerShape "ICON"; _m setMarkerType "mil_dot"; _m setMarkerSize [0.7, 0.7]; _m setMarkerColor "ColorCIV"; _m setMarkerText format ["%1", ADF_civKilled];
		}
	};
	
	{
		if ((side _x == civilian) && (_x isKindOf "Man")) then {
		  _x addEventhandler ["killed", ADF_fnc_civKia_EH];
		};
	} foreach allUnits;
} else {
	ADF_fnc_civKia_msg = {hintSilent parseText format ["
		<t color='#A1A4AD' align='left'>Brigade: a civilian has been killed in action by </t>
		<t color='#FFFFFF' align='left'>%1 </t>
		<t color='#A1A4AD' align='left'>(%2)</t><br/><br/>
		<t color='#A1A4AD' align='left'>The total civilian death toll is: </t>
		<t color='#FFFFFF' align='left' size='1.2'>%3 </t><br/><br/>
		<t color='#A1A4AD' align='left' size='1'>Civilians KIA are marked on the map with a </t>
		<t color='#AE1AB0' align='left' shadow='1.2'>purple dot</t>
		", name vehicle ADF_civKiller, ADF_civKiller, ADF_civKilled];
	};
  "ADF_civKilled" addPublicVariableEventHandler {call ADF_fnc_civKia_msg}; // JIP compatible EH
};