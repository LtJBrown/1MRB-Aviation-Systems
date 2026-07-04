// *******************************************************************************
// **       Funcion: Ropeground.sqf
// **   Descripcion: Crea cuerdas en el suelo junto a objeto
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_rope1","_rope2","_pos","_tt","_px","_py","_dd","_espera","_dif","_posAnt"];

_obj = _this select 0;

if (surfaceIsWater (getposASL _obj)) then {if (getpos _obj select 2 > 0.5) then {_dif = 0.08} else {_dif = 0.03}} else {_dif = 0.02};

_espera = true;
_posAnt = position _obj;
while {_espera} do
{
	sleep 0.01;
	if (_posAnt distance (position _obj) < 0.01) then {_espera = false};
	_posAnt = position _obj;
};

_pos = getposASL _obj;

_dd = (sizeOf (typeOf _obj)) / 4;
if (_dd < 1.5) then {_dd = 1.5};

_rope1 = "Eslinga_0" createvehicle [0,0,0];
_rope2 = "Eslinga_0" createvehicle [0,0,0];
_rope1 setdir (direction _obj);
_rope2 setdir ((direction _obj)+180);

//--- Rope1
_px = (_pos select 0) + (_dd * sin(direction _rope1));
_py = (_pos select 1) + (_dd * cos(direction _rope1));
if (surfaceIsWater (getpos _obj)) then
{
	if (getposASL _obj select 2 > 0.00) then
	{
		if (_obj isKindOf "tank") then {_dif = 0.25} else {_dif = 0.05};
		_rope1 setposASL [_px,_py,(getposASL _obj select 2) + _dif]; _rope1 setdir ((direction _rope1)+180);
	};
}
else {_rope1 setpos [_px,_py,_dif]; _rope1 setdir ((direction _rope1)+180)};

//--- Rope2
_px = (_pos select 0) + (_dd * sin(direction _rope2));
_py = (_pos select 1) + (_dd * cos(direction _rope2));
if (surfaceIsWater (getpos _obj)) then
{
	if (getposASL _obj select 2 > 0.00) then
	{
		if (_obj isKindOf "tank") then {_dif = 0.25} else {_dif = 0.05};
		_rope2 setposASL [_px,_py,(getposASL _obj select 2) + _dif]; _rope2 setdir ((direction _rope2)+180);
	};
}
else {_rope2 setpos [_px,_py,_dif]; _rope2 setdir ((direction _rope2)+180)};

_tt = (time+60+(random(60)));
waitUntil {time > _tt};
deletevehicle _rope1;
deletevehicle _rope2;
