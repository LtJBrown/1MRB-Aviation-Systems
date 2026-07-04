// *******************************************************************************
// **       Funcion: AttachRopes.sqf
// **   Descripcion: Habilita capacidad de helitransporte por reponer cuerdas
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_who","_veh","_man","_attach","_anim","_rope"];

_who = _this select 1;
_veh = (_this select 3) select 0;
_man = (_this select 3) select 1;

if ((position _veh select 2) >= 0) then
{
	_who vehicleChat (localize "STR_lifter314");
};

if (not (_man in _veh)) then
{
	_rope = "Eslinga_0" createvehicle [0,0,0];
	_rope setdir ((direction _man)+180);
	_rope setposASL [(getposASL _man) select 0, (getposASL _man) select 1, ((getposASL _man) select 2)];

	_anim = "AinvPknlMstpSlayWrflDnon_medic";
	_man playmove _anim;
	sleep 5;
	waitUntil {(animationState _man) != _anim};

	deletevehicle _rope;
	_who groupChat (localize "STR_lifter313");
	_veh setvariable ["AllowLift", true];
};