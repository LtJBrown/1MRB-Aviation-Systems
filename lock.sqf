_obj = _this select 0;
_modo = _this select 1;

_obj lock _modo;
_obj lockDriver _modo;
_obj lockCargo _modo;
if (_modo) then {_obj enableSimulationGlobal false} else {_obj enableSimulationGlobal true};