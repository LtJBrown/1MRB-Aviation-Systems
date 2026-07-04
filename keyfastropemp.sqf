private ["_veh"];

_veh = _this select 0;

//--- Es player o Zeus (Ai + player)
while {(isPlayer (driver _veh)) and (alive _veh)} do
{
	if (inputAction "user11" > 0) then
	{
		waituntil {inputAction "user11" == 0};
		if ((abs(speed _veh) <= 10) and ((position _veh select 2) <= 25) and ((position _veh select 2) > 5)) then
		{
			if (not(_veh getvariable ["lift", false])) then
			{
				if ((({not local(_x)} count (crew _veh)) > 0) or (count (assignedCargo _veh) > 0)) then
				{
					_veh setvariable ["execFR", true, true];
					sleep 1;
					while {(_veh getvariable "fastRopeOn") and (alive _veh)} do {sleep 1.00};
					sleep 2;
				};
			};
		};
		waituntil {inputAction "user11" == 0};
	};
	sleep 0.10;
};