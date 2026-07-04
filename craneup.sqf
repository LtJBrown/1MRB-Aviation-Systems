// *******************************************************************************
// **       Funcion: Up.sqf
// **   Descripcion: Controla ascenso de unidad rescatada
// *******************************************************************************
private ["_camilla","_limit","_overSea","_ii","_man","_obj"];

_veh = (_this select 3) select 0;
_obj = (_this select 3) select 1;

_limit = 0.05;

//_overSea = surfaceIsWater [getpos _veh select 0, getpos _veh select 1];
//if (_overSea) then {_ii = "5"} else {_ii = "0"};

//_veh removeaction (_obj getvariable "upHitch");
_obj animate ["hitchDown", _limit];


waitUntil {(_obj animationPhase "hitchDown") <= _limit};

/*
_man = (_obj getvariable "hitched");
_camilla = _obj getvariable "stretcher";
sleep 2;

if (not isnull(_man)) then
{
	_man removeaction (_man getvariable "accCatch");
//	_man setvehicleInit format ["this removeaction (%1 getvariable 'accCatch')", _man];
//	processInitCommands;
	detach _man;
	_man assignascargo _veh;
	_man moveincargo _veh;
};
*/

_obj setvariable ["hitched", objnull, true];
_obj setvariable ["stretcher", objnull, true];
//detach _camilla;
//deletevehicle _camilla;
_obj setvariable ["DownHitch", -1, true];
_obj animate ["hitchDown", 0];

_veh setvariable ["craneState", false];