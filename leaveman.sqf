private ["_man","_veh"];

_man = _this select 0;
_veh = _this select 1;

[_man] ordergetin false;
unassignVehicle _man;
_man setpos (getpos _man);