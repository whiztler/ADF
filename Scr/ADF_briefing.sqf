/****************************************************************
ARMA Mission Development Framework
ADF version: 1.39 / MAY 2015

Script: Mission Briefing
Author: Whiztler
Script version: 1.4

Game type: COOP
File: ADF_Briefing.sqf
****************************************************************
Instructions:

Note the reverse order of topics. Start from the bottom.
Change the "Text goes here..." line with your info. Use a <br/> to
start a new line.
****************************************************************/

diag_log "ADF RPT: Init - executing briefing.sqf"; // Reporting. Do NOT edit/remove
if (!isDedicated && (isNull player)) then {waitUntil {sleep 0.1; !isNull player};};

///// CREDITS
player createDiaryRecord ["Diary",["Credits","
<br/><br/><font size='18'>CREDITS</font><br/><br/>
<font color='#9DA698'>Mission by {yourname}</font>
"]];

///// SUPPORT & LOGISTICS
player createDiaryRecord ["Diary",["MOB & Logistics","
<br/><br/><font size='18'>PLAYER RESPAWN</font>
<br/><font color='#9DA698'>Text goes here<br/>This goes on a new line.</font>

<br/><br/><font size='18'>PLAYER LOADOUT</font>
<br/><font color='#9DA698'>Text goes here<br/>This goes on a new line.</font>

<br/><br/><font size='18'>VEHICLE RESPAWN</font>
<br/><font color='#9DA698'>Text goes here<br/>This goes on a new line.</font>

<br/><br/><font size='18'>VEHICLE SUPPLY CARG</font>
<br/><font color='#9DA698'>Text goes here<br/>This goes on a new line.</font>

<br/><br/><font size='18'>TRANSPORT ARRANGEMENTS</font>
<br/><font color='#9DA698'>Text goes here<br/>This goes on a new line.</font>
"]];

///// TACTICAL PLAN & EXECUTION
player createDiaryRecord ["Diary",["Tactical / Execution","
<br/><br/><font size='18'>CONCEPT OF OPERATIONS</font>
<br/><font color='#9DA698'>This is a statement of your intent which explains your mission in relation to the higher commander's intent.
It consists of an explanation of the purpose of the task, a general method to achieve the task and an end result desired.</font>

<br/><br/><font size='18'>TACTICAL MOVEMENT</font>
<br/><font color='#9DA698'>Control measures include locations, boundaries, routes to various control points, order of march, report lines,
limits of exploitation, assembly areas, axes of advance, etc. </font>

<br/><br/><font size='18'>WEAPONS/FIRE SUPPORT</font>
<br/><font color='#9DA698'>Text goes here<br/>This goes on a new line.</font>

<br/><br/><font size='18'>SPECIAL OPERATIONS</font>
<br/><font color='#9DA698'>Text goes here<br/>This goes on a new line.</font>

<br/><br/><font size='18'>ADMINISTRATIVE</font>
<br/><font color='#9DA698'>Text goes here<br/>This goes on a new line.</font>
"]];

///// OBJECTIVES
player createDiaryRecord ["Diary",["Objectives","
<br/><br/><font size='18'>MISSION OBJECTIVES</font>
<br/><font color='#9DA698'>The mission will be the principal task along with a statement of the purpose behind the task.
It is expressed as to ...(mission task verb) in order to ... (purpose). It is stated twice for emphasis.</font>
"]];

///// SITUATION

player createDiaryRecord ["Diary",["Situation","
<br/><br/><font size='18'>SUMMARY</font>
<br/><font color='#9DA698'>Text goes here<br/>This goes on a new line.</font>

<br/><br/><font size='18'>INTEL ON ENEMY FORCES</font>
<br/><font color='#9DA698'>Known or estimated strength, locations and actions that may effect the completion of the mission.</font>

<br/><br/><font size='18'>NATO FORCES</font>
<br/><font color='#9DA698'>Any troops added to or detached from the unit for the operation, the tasks of flanking units, and support units.</font>

<br/><br/><font size='18'>CIVILIAN CONSIDERATION</font>
<br/><font color='#9DA698'>Information about the civilian populous, what to expect, how to address, etc.</font>
"]];
