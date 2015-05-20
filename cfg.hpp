/****************************************************************
ARMA Mission Development Framework
ADF version: 1.39 / MAY 2015

Script: Config entries
Author: Whiztler
Script version: 1.0

Game type: n/a
File: cfg.hpp
****************************************************************
Config entry registration goes in here.
****************************************************************/

class CfgUnitInsignia {
	class CLANPATCH {
		displayName = "Nopryl"; // Name displayed in Arsenal
		author = "ADF / Whiztler";
		texture = "Img\clan_patch_Nopryl.paa";
		textureVehicle = ""; // Does nothing currently, reserved for future use
	};
};

class CfgRespawnTemplates { // F3 Spectator Script
	class f_Spectator {
		onPlayerRespawn = "f_fnc_CamInit";
	};

    class Seagull { //Overwrite Vanilla Seagull
        onPlayerRespawn = "";
    };
};