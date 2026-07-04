// *******************************************************************************
// **       Funcion: DeployRopes.sqf
// **   Descripcion: despliega cuerdas de carga
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_buscaOff","_ropes","_center","_cx","_cy","_cz","_txt","_icon","_UL2"];

_veh = (_this select 3) select 0;
_tgt = (_this select 3) select 1;
_UL2 = (_this select 3) select 2;

_center = _veh getvariable "GeoLifter";
_cx = (_center select 0);
_cy = (_center select 1);
_cz = (_center select 2);

_ropes = "eslinga" createvehicle [0,0,0];
_ropes attachto [_veh, [_cx+0,_cy+2,_cz+(-4.5)]];
_veh vehiclechat format ["%1",localize "STR_lifter321"];

_veh setvariable ["antObj", objNull];
_veh setvariable ["eslinga2", _ropes];
_veh removeAction (_veh getvariable "accDeploy");

_UL2 attachTo [_ropes, _ropes selectionPosition "anclaje"];

_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1", localize "STR_lifter308"] + "</t>";
_icon = "<img size='3.5' shadow=0 color='#FFFF00' image='" + pathlifter + "freeRopes.paa'/>";
_BuscaOff = _veh addAction [_txt+_icon, pathLifter + "FreeRopes.sqf", [_veh, _ropes, _UL2], 98, false, true, "", "(_this in _target) and (_this == (driver _target)) and ((getpos _target select 2) > 3)"];

_veh setvariable ["accFree", _buscaOff];

//null = [_veh] execVM pathlifter + "aidLift.sqf";

null = [_veh, _ropes, _UL2] execVM pathLifter + "physRopes.sqf";

waitUntil {(_veh getvariable "accDeploy") == -1};
_veh removeaction _BuscaOff;
_veh setvariable ["accFree", nil];

if ((_veh getvariable "accCatch") != -1) then
{
	_veh removeAction (_veh getvariable "accCatch");
	_veh setvariable ["accCatch", -1];
};