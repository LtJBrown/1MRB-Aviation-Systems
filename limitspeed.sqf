// *******************************************************************************
// **       Funcion: LimitSpeed.sqf
// **   Descripcion: Limita velocidad de helicoptero cargado
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

_veh   = _this select 0;
_reduc = _this select 1;

while {(_veh getvariable "lift") and (canmove _veh) and (alive _veh)} do
{
	_veh setvelocity [((velocity _veh) select 0)/_reduc, ((velocity _veh) select 1)/_reduc, ((velocity _veh) select 2)];
	sleep 0.05;
};
