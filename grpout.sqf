private ["_veh","_listCargo","_cualMan","_listRopes","_aborta","_rope","_man","_altura","_pos","_ropeFree",
	"_txt","_icon","_fastRopeOff","_leaders","_first","_ll","_list"];

_veh = _this select 0;
_listRopes = _this select 1;

_pos = getpos _veh;
_altura = _pos select 2;

_list = [player];//assignedCargo _veh;
{
	if (not (local _x)) then
	{
		if (_x != (driver _veh) and _x != (gunner _veh) and _x != commander _veh) then
		{
				if (not(_x in _list)) then {_list = _list + [_x]};
		};
	};
} foreach (crew _veh);

{
	if (_x != leader (group _x)) then { _x setvariable ["whoGrp", group _x]; [_x] joinSilent grpnull};
} foreach _list;

_cualMan = 0;
{_x setvariable ["free", true]} foreach _listRopes;

_veh removeaction (_veh getvariable "accFastRope");
[[[_veh],pathlifter+"ActionFastRopeOffMP.sqf",true],"BIS_fnc_execVM",true,true] spawn BIS_fnc_MP;
sleep (1.5 + random(1.5));

//--- Seleccion de unidades que bajan
_listCargo = [];
{
	if ((_x getvariable ["FRdown", 0]) == 1) then {_listCargo = _listCargo + [_x]};
} foreach _list;

_aborta = false; _first = true;
if ((count _listRopes == 0) or not (_veh getvariable ["fastRopeOn",false]) or (count _listCargo == 0)) then {_aborta = true};

_veh setvariable ["fastRoping", true, true];
while {not _aborta} do
{
	_rope = objnull; _ropeFree = false;
	{
		if (not (_ropeFree)) then
		{
			if (_x getvariable "free") then {_rope = _x; _ropeFree = true};
		};
		sleep 0.10;
	} foreach _listRopes;

	if (_ropeFree) then
	{
		_rope setvariable ["free", false, true];
		_man = _listCargo select _cualMan;

		sleep random(1);
		if ((_veh getvariable ["fastRopeOn",false])) then
		{
			null = [_rope, _man, _veh] spawn
			{
				private ["_rope","_man","_veh","_cono","_slot","_t","_acc"];
				_rope = _this select 0;
				_man = _this select 1;
				_veh = _this select 2;
				_slot = _rope getvariable ["freeSlot", 0];
				_slot = _slot + 1;
				if (_slot > 2) then {_slot = 1};
				_rope setvariable ["freeSlot", _slot];

				[[[_man,_veh],pathlifter+"LeaveMan.sqf",true],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
				if ((_rope getvariable "modeSet") in [1,4]) then
				{
					_acc = "crew_tank01_out";
					_man attachTo [_rope, [0,0,0], format ["set%1", (_rope getvariable "modeSet")]];
					_man setdir 180; _man switchmove _acc; _man disableAI "move";
					[[[_man,_acc,true],pathlifter+"postura.sqf",true],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
				}
				else
				{
					_acc = "AmovPknlMstpSnonWnonDnon";
					_man attachTo [_rope, [0,0,0], format ["set%1", (_rope getvariable "modeSet")]];
					_man setdir 180; _man switchmove _acc; _man disableAI "move";
					[[[_man,_acc,true],pathlifter+"postura.sqf",true],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
				};
				sleep 1+random(1);

				if ((_veh getvariable ["fastRopeOn",false]) and (_slot in [1,2])) then
				{
					_man attachTo [_rope, [0,0,0], format ["enganche%1", _slot]];
					_acc = "RAV_fastrope";
					_man switchmove _acc; _man setdir (135+random(90)); _man disableAI "move";
					[[[_man,_acc,true],pathlifter+"postura.sqf",true],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
					_rope animate [format["bajando%1",_slot], 1]; _man allowdamage false;
					_t = time - 0.10;
					while {(_rope animationPhase format["bajando%1",_slot]) < ((_rope animationPhase "aju_altura")-0.005) and (_veh getvariable "fastRopeOn")} do
					{
						if (time > _t) then {_man say3D "fastropeloop"; _t = time + 0.50};
						sleep 0.10;
					};
					if ((_veh getvariable ["fastRopeOn",false])) then
		 			{
	 					detach _man;
						[[[_man,"",false],pathlifter+"postura.sqf",true],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
 						_man setvelocity [0,0,-1];
 						_man say3D "fastropeEnd"; _man allowdamage true;
 						_rope animate [format["bajando%1",_slot], 0];
						_rope setvariable ["free", true];
 						if (not isPlayer(_man)) then
						{
							[[[_man],pathlifter+"dispersa.sqf",true],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
 						};
						//--- Ensambla a grupo
						null = [_man] spawn
						{
							private ["_man","_grp"];
							_man = _this select 0;
							_grp = _man getvariable "whoGrp";
							if (not isnil("_grp")) then {[_man] joinSilent _grp};
							_man setvariable ["FRdown", nil, true];
						};
						waitUntil {_rope animationPhase format["bajando%1",_slot] < 0.001};
					}
					else
					{
						_veh setvariable ["fastRoping", false, true];
						detach _man;
						[[[_man,"",false],pathlifter+"postura.sqf",true],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
						//--- Ensambla a grupo
						null = [_man] spawn
						{
							private ["_man","_grp"];
							_man = _this select 0;
							_grp = _man getvariable "whoGrp";
							if (not isnil("_grp")) then {[_man] joinSilent _grp};
							_man setvariable ["FRdown", nil, true];
						};
					};
					_man allowdamage true;
				} else { detach _man; _man moveincargo _veh; _aborta = true};
			};
		} else {_veh setvariable ["fastRoping", false, true];};
		if (_cualMan < ((count _listCargo)-1)) then {_cualMan = _cualMan + 1} else {_aborta = true};
	};
	if (not(_veh getvariable ["fastRoping", false])) then {_aborta = true};
	sleep 0.1;
};

[[[_veh],pathlifter+"ActionRemoveRopeOffMP.sqf",true],"BIS_fnc_execVM",true,true] spawn BIS_fnc_MP;
_veh removeaction (_veh getvariable "accFastRope");
_veh setvariable ["fastRoping", false, true];

_aborta = false;
while {not _aborta} do
{
	_aborta = true;
	{
		if (not(_x getvariable "free")) then {_aborta = false};
		sleep 0.01;
	} foreach _listRopes;
	sleep 0.1;
};
_veh setvariable ["fastRopeOn", false, true];

if (_cualMan == ((count _listCargo)-1)) then {_veh vehiclechat format ["%1",localize "STR_fastrope5"]}
else {_veh vehiclechat format ["%1",localize "STR_fastrope6"];};

[_veh] spawn
{
	private ["_time","_vUp"];
	_veh = _this select 0;
	_time = time + 3;
	_vUp = vectorUp _veh;
	_veh disableAI "move";
	while {time < _time} do
	{
		if ((velocity _veh select 2) < 0) then {_veh setvelocity [velocity _veh select 0, velocity _veh select 1, 0]};
		_veh setVectorUp _vUp;
		sleep 0.01;
	};
	_veh enableAI "move";
};

//--- Cierra rampas / puertas
nul = [_veh] execVM (pathlifter + "CloseDoors.sqf");
