// *******************************************************************************
// **       Funcion: FreeRopes.sqf
// **   Descripcion: Libera cuerdas de carga
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_veh","_ropes","_UL2"];

_veh   = (_this select 3) select 0;
_ropes = (_this select 3) select 1;
_UL2   = (_this select 3) select 2;

if (not isnil("_UL2")) then {detach _UL2; _UL2 setpos [0,0,0]};
detach _ropes;
deletevehicle _ropes;
_veh vehiclechat format ["%1",localize "STR_lifter322"];

_veh setvariable ["antObj", objNull];
_veh setvariable ["accDeploy", -1];
_veh setvariable ["eslinga2", objnull];

hintsilent "";