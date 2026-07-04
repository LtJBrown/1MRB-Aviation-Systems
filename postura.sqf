private ["_man","_acc","_inmovil"];

_man = _this select 0;
_acc = _this select 1;
_inmovil = _this select 2;

_man setdir 180;
_man switchmove _acc;
if (_inmovil) then {_man disableAI "move"} else {_man enableAI "move"};