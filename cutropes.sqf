// *******************************************************************************
// **       Funcion: CutRopes.sqf
// **   Descripcion: Corta cuerdas por emergencia
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_veh","_obj","_vel","_dam","_delay","_tip","_retro","_altant","_attach",
	"_condic","_static","_pos","_txt","_rope","_altfinal","_cono","_aborta","_suelo"];
_veh = (_this select 3) select 0;
_obj = (_this select 3) select 1;

_veh setvariable ["ObjCargo", objnull];
_veh setvariable ["NoselObj", objnull];
_veh setvariable ["antObj", objNull];
_veh setvariable ["accDeploy", -1];

_veh setvariable ["lift", false];
_veh setvariable ["objAlt", 0.00];
_veh vehicleChat localize "STR_lifter311";

_rope = _veh getvariable "eslinga";
detach _rope;
detach _obj;
deletevehicle _rope;

_tip = _veh getvariable "eslinga";
_veh setvariable ["eslinga2", objnull];
_veh setvariable ["eslinga", objnull];
_veh setvariable ["AllowLift", false];

_veh removeaction (_veh getvariable "accCut");
_veh setvariable ["accCut", -1];

_vel = velocity _veh;
_retro = _vel select 2;

if (not isnull(_tip)) then
{
	if ("Eslinga_L" countType [_tip] > 0) then {_retro = 5} else {_retro = 10};
};

_altant = (getposASL _obj) select 2;
_veh setvelocity [_vel select 0, _vel select 1, _retro];

_condic = "((getpos _veh select 2) < 1) and (not ((_this select 1) in _veh)) and ((_this select 1) distance _veh > 1) and ((_this select 1) distance _veh < 3.5)";
_txt = "<t color=""#FFFF00"">" + format ["%1", localize "STR_lifter312"] + "</t>";
_attach = _veh addAction [_txt, pathLifter + "attachRopes.sqf", [_veh, _this select 1], 99, true, call compile _condic];

//------ Caida libre de objetos sin fisica/gravedad
[_obj] execVM pathlifter + "Caida.sqf";

while {not (_veh getvariable "AllowLift")} do {sleep 1};
_veh removeAction _attach;
