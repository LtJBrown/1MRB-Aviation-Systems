private ["_veh","_aborta","_ya"];

_veh = _this;

_aborta = false;
if ("AIR" counttype [_veh] == 0) then {_aborta = true};

_ya = _veh getvariable ["lifter", false];
if (_ya) then {_aborta = true};
if (_aborta) exitWith {};

_veh setvariable ["lifter", true, true];
null = _veh execVM pathLifter + "Main.sqf";