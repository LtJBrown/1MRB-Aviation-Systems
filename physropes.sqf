
// *******************************************************************************
// **       Funcion: PhysRopes.sqf
// **   Descripcion: Gestiona fisica de cuerdas en vuelo
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************
private ["_vUp","_bank","_pitch","_dX","_dY","_spd","_tipoEslinga","_topeMin",
	"_topeMax","_aborta","_dXc","_dYc","_vellat","_aborta"];

_veh = _this select 0;
_ropes = _this select 1;
_obj = _this select 2;

_tipoEslinga = getNumber (configFile >> "CfgVehicles" >> (typeOf _ropes) >> "tipoEslinga");

_aborta = false;
_topeMin = -0.45; _topeMax = 0.45;
if (_tipoEslinga in [3,4]) then {_topeMin = -0.30; _topeMax = 0.30};
if (_tipoEslinga in [2,3,4]) then {_aborta = true};

if (_aborta) exitWith {};
if (_tipoEslinga > 0 and (not _aborta)) then
{
	sleep 1;
	_aborta = false;
	while {not _aborta} do
	{
		if (_tipoEslinga == 1) then
		{
			if ((_veh getvariable "accDeploy") == -1) then {_aborta = true};
		} else {if (not(_veh getvariable "lift")) then {_aborta = true}};

		_vUp = vectorUp _veh; _vellat = (velocity _veh) select 0;
		_pitch = _vUp select 0;
		_bank = _vUp select 1;

		if (_bank < _topeMin) then {_bank = _topeMin} else {if (_bank > _topeMax) then {_bank = _topeMax}};
		if (_pitch < _topeMin) then {_pitch = _topeMin} else {if (_pitch > _topeMax) then {_pitch = _topeMax}};
		_dX = (_bank + _topeMax) / (_topeMax * 2);
		_dY = (_pitch + _topeMax) / (_topeMax * 2);

		//--- Ajuste por velocidad/helo
		_spd = speed _veh;
		if (_spd > 0) then {if (_spd > 10) then {_dY = _dY + (_spd / 400)}}
		else {_dY = _dY - (_spd / 600)};
		//if (abs(_vellat) > 0.2) then {_dX = _dX - (_vellat / 200)};
		if (_bank < _topeMin) then {_bank = _topeMin} else {if (_bank > _topeMax) then {_bank = _topeMax}};
		if (_pitch < _topeMin) then {_pitch = _topeMin} else {if (_pitch > _topeMax) then {_pitch = _topeMax}};

		//--- Ajuste de carga por velocidad/helo
		_dXc = _bank / 2500;
		_dYc = _pitch + (_spd / 300);

		_ropes animate ["derecha_izquierda", _dX];
		if (_tipoEslinga in [1,2]) then {_ropes animate ["adelante_atras", _dY]};
		if (_tipoEslinga in [3,4]) then {_dYc = 0};
		_obj setVectorUp [_dXc,_dYc, 1];
		sleep 0.10;
	};
};

/*
_tipoEslinga
	0- no definida
	1- suelta
	2- ligera
	3- mediana
	4- pesada
	5- en el suelo
*/