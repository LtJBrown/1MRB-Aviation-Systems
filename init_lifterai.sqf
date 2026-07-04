private ["_veh","_acc","_accAnt","_dst","_UL2"];

_veh = _this select 0;
if (not isServer) exitWith {};

_accAnt = ""; _dst = [];
_veh setvariable ["busyLifter", false];

_UL2= "logic" createvehicleLocal [0,0,0];

while {alive _veh} do
{
	if ((_veh emptyPositions "driver") == 0) then
	{
		if (not isPlayer (driver _veh)) then
		{
			_acc = _veh getvariable ["actionLifter",[]];
			if ((count _acc) > 0) then
			{
				_accAnt = _acc select 0;
				switch (_acc select 0) do
				{
			    	case "move":
			    	{
		    			_dst = _acc select 1;
			    		if (_dst distance [getpos _veh select 0, getpos _veh select 1, _dst select 2] > 100) then
			    		{
			    			_veh domove _dst;
			    		}
			    		else
			    		{
							_veh setvariable ["busyLifter", true];
							_veh setvariable ["approach", true, true];
							nul = [_veh, _dst, true, false] execVM pathlifter + "lander.sqf";
							waitUntil {(alive _veh) and not (_veh getvariable "approach")};
							_veh flyInHeight ((position _veh select 2));
							_veh setvariable ["busyLifter", false];
							_veh setvariable ["actionLifter", []];
							_accAnt = "";
			    		};
			    		sleep 1;
			    	};
			    	case "slingDown":
			    	{
						[false,false,false,[_veh,[],_UL2]] execVM pathLifter + "deployRopes.sqf";
			    		_veh setvariable ["actionLifter", []];
						_accAnt = "";
			    	};
			    	//case "slingUp":
			    	//{
					//	[false,false,false,[_veh,[],_UL2]] execVM pathLifter + "deployRopes.sqf";
			    	//	_veh setvariable ["actionLifter", []];
					//	_accAnt = "";
			    	//};
				};
			} else {sleep 1};
		} else {sleep 5};
	} else {sleep 5};
};