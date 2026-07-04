private ["_veh","_who","_datFastRopes"];

_veh = _this select 0;
_who = _this select 1;
_datFastRopes = (_this select 3) select 0;

if (isnil ("_who")) exitWith {};
if (_veh getvariable ["fastRoping", false]) exitWith {};

[[[_veh,_who,_datFastRopes],pathlifter+"fastRopeOn2.sqf",false],"BIS_fnc_execVM",false,false] spawn BIS_fnc_MP;
