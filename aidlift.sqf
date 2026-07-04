private ["_veh","_veland","_veldes","_delay","_vx","_vy","_vz","_limit","_reduc","_LCD","_vel","_ropes"];

_veh  = _this select 0;

_limit = 0.03;
_reduc = 0.10;
_delay = 0.15;

while {(alive _veh) and (not isnull (_veh getvariable "eslinga2"))} do
{
	_LCD = _veh getvariable "RAV_lcd";
	_ropes = _veh getvariable "eslinga2";
	_velant = velocity _veh;
	sleep _delay;

	if (abs(speed _veh) < 20) then
	{
		_veldes = velocity _veh;
		_vx = (_veldes select 0) - (_velant select 0);
		_vy = (_veldes select 1) - (_velant select 1);
		_vz = (_veldes select 2) - (_velant select 2);

		if (abs(_vx) > _limit) then {_vx = _vx * _reduc};
		if (abs(_vy) > _limit) then {_vy = _vy * _reduc};
		if (abs(_vz) > _limit) then {_vz = _vz * _reduc};
		_vel = [(_velant select 0) + _vx, (_velant select 1) + _vy, (_velant select 2) + _vz];

		_veh setvelocity _vel;
		_ropes setvelocity _vel;
		if (not isnil ("_LCD")) then {_LCD setvelocity _vel};
	};
};