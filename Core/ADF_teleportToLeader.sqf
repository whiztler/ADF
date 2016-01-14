/****************************************************************
ARMA Mission Development Framework
ADF version: 1.43 / JANUARY 2016

Script: Teleport to group leader script
Author: Whiztler
Script version: 1.03

Game type: N/A
File: ADF_teleportToLeader.sqf
****************************************************************
Instructions:

Place an object (flag pole, vehicle, etc.) and add the following
to the init field:
this addAction ["<t align='left' color='#E4F2AA'>Teleport to Troop Leader</t>", "Core\ADF_teleportToLeader.sqf",[], 5, true, false,"", ""]; this allowDamage false;

****************************************************************/

// Init
params ["_pole", "_u"];
private ["_l", "_p", "_d"];
_l	= leader (group _u);
_p	= getPosATL _l;
_d	= getDirVisual _l;

// Check if the unit is the leader of the group (cannot teleport to itself).
if (_u == leader (group _u)) exitWith {hintSilent parseText format ["<img size= '6' shadow='false' image='" + ADF_clanLogo + "'/><br/><br/><t color='#6C7169' align='left'>%1, it appears that you are the leader of your unit.</t><br/><br/><t color='#6C7169' align='left'>You cannot teleport to yourself.</t><br/><br/>", name _u];};
// Check if the leader of the unit is alive. If not alive, display a message.
if (!alive _l) exitWith {hintSilent parseText format ["<img size= '6' shadow='false' image='" + ADF_clanLogo + "'/><br/><br/><t color='#6C7169' align='left'>%1, your unit Leader, %2, is currently K.I.A.</t><br/><br/><t color='#6C7169' align='left'>You can teleport to %2's position once he has respawned.</t><br/><br/>", name _u, name _l];};

// Leader is alive, let's check if he/she is on foot or in a vehicle
if (vehicle _l == _l) then { // TL is not in a vehicle

	_u setUnitPos "DOWN";
	_u setDir _d;
	_u setPosATL _p;
	_u setPos (_l modelToWorldVisual [0, -5, 0]);
	if (ADF_mod_ACE3) then {[_u, currentWeapon _u, currentMuzzle _u] call ACE_SafeMode_fnc_lockSafety;};

} else {	// Tl is in a vehicle

	scopeName "ADF_TeleportVeh";
	if (((vehicle _l) emptyPositions "commander") > 0) then {
		_u assignAsCommander (vehicle _l);
		_u moveInCommander (vehicle _l);
		breakOut "ADF_TeleportVeh";
	};
	if (((vehicle _l) emptyPositions "gunner") > 0) then {
		_u assignAsGunner (vehicle _l);
		_u moveInGunner (vehicle _l);
		breakOut "ADF_TeleportVeh";
	};
	if (((vehicle _l) emptyPositions "driver") > 0) then {
		_u assignAsDriver (vehicle _l);
		_u moveInDriver (vehicle _l);
		breakOut "ADF_TeleportVeh";
	};
	if (((vehicle _l) emptyPositions "cargo") > 0) then {
		_u assignAsCargo (vehicle _l);
		_u moveInCargo (vehicle _l);
		breakOut "ADF_TeleportVeh";
	};
	// No space in vehicle
	hintSilent parseText format ["<img size= '6' shadow='false' image='" + ADF_clanLogo + "'/><br/><br/><t color='#6C7169' align='left'>%1, your unit Leader, %2, is in a vehicle.</t><br/><br/><t color='#6C7169' align='left'>The vehicle does not have an empty seat at the moment. Please try again later.</t><br/><br/>", name _u, name _l];
};

