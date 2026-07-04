private ["_asloc","_lockobj","_lock","_xfall","_xvelx","_xvely","_xvelz","_retardo","_altura","_lz2"
	,"_px","_py","_spdmode","_manual","_isfastRope"];

_veh = _this select 0;
_targetPos = _this select 1;
_isfastRope = _this select 2;
_manual = _this select 3;

_altura = _veh getvariable ["fastRopeHeight", 9.99];
if (_altura < 6) then {_altura = 6};
if (_altura > 30) then {_altura = 30};

if (_isfastRope) then
{
	_veh setvariable ["fastRopePos", _targetPos, true];
	_veh setvariable ["fastRopeHeight", (_targetPos select 2) + _altura, true];
	_veh flyInHeight 50;
	_veh setSpeedMode "normal";
	_veh domove _targetPos;
	sleep 10;
} else {_altura = 9.99};

_px = (_targetPos select 0) + (200 * sin(direction _veh));
_py = (_targetPos select 1) + (200 * cos(direction _veh));
_lz2 = [_px, _py, (_targetPos select 2) + _altura];
_veh setSpeedMode "normal";
_veh flyInHeight 50;
_veh domove _lz2;

_asloc = [_targetPos select 0, _targetPos select 1, (_targetPos select 2) + _altura];
_lockobj = "Land_HelipadEmpty_F" createVehiclelocal _asloc;
_lock = getPosATL _lockobj select 2; deleteVehicle _lockobj;

while {(alive _veh) and ([getpos _veh select 0, getpos _veh select 1, 0] distance [_targetPos select 0, _targetPos select 1, getpos _veh select 2]) > 100} do {sleep 0.5};
//_retardo = 1.00;
//_retardo = 0.75;
_retardo = 0.45;
_targetPos = _asloc;
_veh disableAi "move";
_spdmode = speedMode _veh;
_veh setSpeedMode "limited";
while {(!isNull _veh) and ((getpos _veh) distance _asloc > 5) and (alive _veh)} do
{
	_xfall = sqrt(((getPosATL _veh select 2)-_lock)/0.95);
	_xvelx = (((_targetPos select 0)-(getPos _veh select 0))/_xfall) / _retardo;
	_xvely = (((_targetPos select 1)-(getPos _veh select 1))/_xfall) / _retardo;
	_xvelz = (((_targetPos select 2)-(getPos _veh select 2))/_xfall) / (_retardo * 1.5);

	_veh setVelocity [_xvelx,_xvely,_xvelz];
	sleep 0.05;
};
_veh domove (getpos _veh);
_veh setSpeedMode _spdmode;

if (alive _veh) then
{
	if (_isfastRope) then
	{
		if (not _manual) then
		{
			_veh setvariable ["fastRopeOn", true, true];
		};
	};
};
_veh setvariable ["approach", false, true];