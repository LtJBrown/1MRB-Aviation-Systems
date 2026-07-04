private ["_man"];

_veh = _this select 0;
_man = _this select 1;
_mode = (_this select 3) select 0;

if (_mode) then
{
	_man setvariable ["FRdown", 1, true];
	_man groupChat format ["FAST-ROPE: %1 %2",name _man, localize "STR_fastrope9"];
}
else
{
	_man setvariable ["FRdown", 0, true];
	_man groupChat format ["FAST-ROPE: %1 %2",name _man, localize "STR_fastrope10"];
};