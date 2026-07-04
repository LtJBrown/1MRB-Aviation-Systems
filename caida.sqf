// *******************************************************************************
// **       Funcion: Caida.sqf
// **   Descripcion: Simula caida de objetos que no tienen peso/fisica
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_obj","_suelo","_cono","_aborta","_Bank","_Pitch","_xBank","_xPitch","_tfin",
	"_enAgua","_altura","_apilado","_ListObj","_ropes","_soga1","_soga2","_pos1","_posAnt",
	"_pos2","_dir","_point1","_point2","_rr","_flota","_vecVel","_dam"];

_obj = _this select 0;
_ropes = _this select 1;
_veh = _this select 2;

_enAgua = false;
_suelo = ((getposASL _obj) select 2) - ((getpos _obj) select 2);
_altura = (getpos _obj) select 2;

_vecVel = velocity _veh;
_ropes setObjectTextureGlobal [1,""];

if ("thing" counttype [_obj] > 0) then
{
	detach _ropes;
	detach _obj;
	_ropes attachTo [_obj];
	_bank = (vectorUp _obj) select 1;
	_pitch = (vectorUp _obj) select 0;

	_cono = "roadcone_F" createvehicle [0,0,0];
	_cono disableCollisionWith _obj;
	_cono hideObjectGlobal true;
	_cono setposASL (getposASL _obj);
	_cono setvelocity [_vecVel select 0, _vecVel select 1, -2.00];

	_enAgua = false;
	if (surfaceIsWater [getposASL _obj select 0, getposASL _obj select 1, _suelo]) then {_suelo = _suelo - 5; _enAgua = true};
	_aborta = false;
	_posAnt = position _obj;
	sleep 1;
	waitUntil {((getpos _obj) select 2) <= 0.1};
	deletevehicle _cono;
	_obj setVectorUp [0, 0, 1];
	_obj setposASL [getposASL _obj select 0, getposASL _obj select 1, _suelo];
	_ropes animate ["cae",1]; sleep 0.1;
	waitUntil {_ropes animationPhase "cae" > 0.90};
	detach _ropes;
	deletevehicle _ropes;
}
else
{
	detach _ropes;
	detach _obj;
	_ropes attachTo [_obj];

	[[[_obj, false],pathlifter+"lock.sqf"],"BIS_fnc_execVM",true,true] spawn BIS_fnc_MP;
	_obj setvelocity [_vecVel select 0, _vecVel select 1, -2.00];
	sleep 1.00;
	_aborta = false;
	while {not _aborta} do
	{
		sleep 0.01;
		if ((getposASL _obj select 2) <= (_suelo + 0.10)) then {_aborta = true};
		if (abs((velocity _obj select 2)) < 0.25) then {_aborta = true};
	};

	_ropes animate ["cae",1]; sleep 0.1;
	waitUntil {_ropes animationPhase "cae" > 0.90};
	detach _ropes;
	deletevehicle _ropes;
};
if ((surfaceIsWater (getposASL _obj)) and ((getposASL _obj select 2) < 0.10)) then {_enAgua = true};

//--- Sound of impact
nul = [_obj, _altura, _enAgua] execVM pathLifter + "caidaSound.sqf";

//Restaura dammage
_obj setdamage (_obj getvariable "damageOri");

//--- Dammage
if (_enAgua) then {_dam = 0.5} else {_dam = 1.00};

if (_altura > 5.00 and _altura < 10) then
{
	_obj setdammage ((damage _obj)+(_dam / 2));
};
if (_altura > 10) then
{
	if (not _enAgua) then {_obj setdammage 99.0};
}
else
{
	_apilado = false;
	_ListObj = nearestObjects [_obj modelToWorld [0,0,-4], ["landVehicle"], 7.00];
	sleep 0.5;
	if (count _ListObj > 0) then {_apilado = true};

	if (not _apilado) then
	{
		//------ Cuerdas en el suelo
		if (not _enAgua) then
		{
			[_obj] execVM pathlifter + "ropeGround.sqf";
			_obj setpos [getpos _obj select 0, getpos _obj select 1, 0];
		}
		else
		{
			_flota = getNumber (configFile >> "CfgVehicles" >> format ["%1", typeOf _obj] >> "canFloat");
			if ((_flota == 0) and ((getposASL _obj select 2 )< 1)) then {sleep 30; deletevehicle _obj};
		};
	}
	else
	{
		if ((getposATL _obj select 2) < 0.10) then
		{
			[_obj] execVM pathlifter + "ropeGround.sqf";
		}
		else
		{
			if ((getposASL _obj select 2) > 1.00) then {[_obj] execVM pathlifter + "ropeGround.sqf"};
		};
	};
};
