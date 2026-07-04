// *******************************************************************************
// **       Funcion: Laddering.sqf
// **   Descripcion: unidad/grupo sube/baja por escalera hacia helicoptero
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_man","_veh","_obj","_modo","_ladder","_units","_ord","_unidades","_lug","_vv"];

_man = _this select 1;
_veh  = (_this select 3) select 0;
_obj  = (_this select 3) select 1;
_modo = (_this select 3) select 2;

if (count (_this select 3) > 3) then
{
	if (_modo) then {_vv = _obj} else {_vv = _veh};
	_unidades = [];
	if (_man == (driver _veh)) then
	{
		{if ((_x in _vv) and ((group _x) != (group _man))) then {_unidades = _unidades + [_x]}} foreach (crew _vv);
	}
	else
	{
		{if (_x in _vv) then {_unidades = _unidades + [_x]}} foreach (units (group _man));
	};
} else {_unidades = [_man]};

_ladder = _veh getvariable ["ladder", objnull];

if (not isnull(_ladder)) then
{
	_ord = 0; _lug = 0;
	while {_ord < (count _unidades)} do
	{
		_man = _unidades select _ord;

		if (_modo) then
		{
			if (_man != (driver _veh) and (_man in _obj)) then
			{
				//--- Sube escalera
				{_lug = _lug + (_veh emptyPositions _x)} foreach ["driver","commander","gunner","cargo"];
				if (_lug > 0) then
				{
					if (_ladder getvariable "free") then
					{
						_ladder setvariable ["free", false, true];
						if (_ladder animationPhase "sube" > 0.01) then
						{
							_ladder animate ["sube", 0];
							waitUntil {_ladder animationPhase "sube" < 0.01};
						};
						_man action ["getOut", (vehicle _man)];
						[[[_man,(vehicle _man)],pathlifter+"LeaveMan.sqf",true],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
						waitUntil {not(_man in _obj)};
						_man attachTo [_ladder, [0,0,0], "Anclaje"]; _man setdir 180;
						_ladder animate ["sube", 1]; _man allowdamage false;
						_man setBehaviour "safe";
						_man switchmove "LadderCivilUpLoop";
						waitUntil {_ladder animationPhase "sube" > 0.99};
						_man switchmove ""; detach _man; _man allowdamage true;
						_ladder animate ["sube", 0.50];
						_ladder setvariable ["free", true, true];
						nul = [_man, _veh] execVM (pathlifter + "seatMan.sqf");
						if ((count _unidades) > 1) then {waitUntil {_ladder animationPhase "sube" < 0.51}};
					} else {_veh vehicleChat localize "STR_lifter325"};
				} else {_veh vehicleChat localize "STR_lifter328"};
			};
		}
		else
		{
			if (_man != (driver _veh) and (_man in _veh)) then
			{
				//--- baja escalera
				{_lug = _lug + (_obj emptyPositions _x)} foreach ["driver","commander","gunner","cargo"];
				if (_lug > 0) then
				{
					if (_ladder getvariable "free") then
					{
						_ladder setvariable ["free", false, true];
						if (_ladder animationPhase "sube" < 0.99) then
						{
							_ladder animate ["sube", 1];
							waitUntil {_ladder animationPhase "sube" > 0.99};
						};
						_man action ["getOut", (vehicle _man)];
						[[[_man,(vehicle _man)],pathlifter+"LeaveMan.sqf",true],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
						waitUntil {not(_man in _veh)};
						_man attachTo [_ladder, [0,0,0], "Anclaje"]; _man setdir 180;
						_ladder animate ["sube", 0]; _man allowdamage false;
						_man setBehaviour "safe";
						_man switchmove "LadderRifleDownLoop";
						waitUntil {_ladder animationPhase "sube" < 0.01};
						_man switchmove ""; detach _man; _man allowdamage true;
						_ladder animate ["sube", 0.50];
						_ladder setvariable ["free", true, true];
						nul = [_man, _obj] execVM (pathlifter + "seatMan.sqf");
						if ((count _unidades) > 1) then {waitUntil {_ladder animationPhase "sube" > 0.49}};
					} else {_veh vehicleChat localize "STR_lifter325"};
				} else {_veh vehicleChat localize "STR_lifter328"};
			};
		};
		_ord = _ord + 1;
		_ladder = _veh getvariable ["ladder", objnull];
		if (isnull(_ladder)) then {_ord = 9999};
	};
};