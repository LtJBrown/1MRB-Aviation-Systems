// *******************************************************************************
// **       Funcion: Down.sqf
// **   Descripcion: Controla descenso de objeto
// *******************************************************************************

private ["_altura","_pos","_camilla","_overSea","_dd","_aju","_obj"];

_veh = (_this select 3) select 0;
_obj = (_this select 3) select 1;

//_veh removeaction (_obj getvariable "downHitch");
_veh setvariable ["craneState", true];
_altura = 9999;

_aju = 0;
/*
_overSea = surfaceIsWater [getpos _veh select 0, getpos _veh select 1];
//if ((getpos _veh select 2) == (getposATL _veh select 2) and _overSea) then {_overSea = false};
_camilla = _obj getvariable "stretcher";

if (isnull _camilla) then
{
	if (not _overSea) then
	{
		_camilla = "Rav_Stretcher" createvehicle [0,0,0];
		_aju = 0.50;
	}
	else
	{
		_camilla = "Rav_Harness1" createvehicle [0,0,0];
		_aju = 0.50;
	};
	_obj setvariable ["stretcher", _camilla, true];
	_camilla attachto [_obj, [0,0,0], "hitch_point"];
	if (not _overSea) then {_camilla setdir 0} else {_camilla setdir 270};
};
*/
_obj animate ["hitchDown", 1];

_aborta = false;
while {not _aborta} do
{
	_dd = (_obj animationPhase "hitchDown") * 20;
	_altura = ((getpos _veh) select 2) + 2 - _aju;
	if (((_obj animationPhase "hitchDown") > 0.95) or (_dd > _altura)) then {_aborta = true};
	sleep 0.10;
};

//detach _altimetro;
//deletevehicle _altimetro;

if (_altura > 0) then {_obj animate ["hitchDown", _obj animationPhase "hitchDown"]};
_obj setvariable ["upHitch", -1, true];
/*
if (isnull (_obj getvariable "hitched")) then
{
	null = [_veh, _obj, _camilla] execVM pathCrane + "carga.sqf";
}
else
{
	null = [_veh, _obj, _camilla] execVM pathCrane + "Descarga.sqf";
};
*/