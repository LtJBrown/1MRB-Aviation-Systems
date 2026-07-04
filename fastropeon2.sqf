private ["_veh","_who","_rope","_listRopes","_extremo","_units","_datFastRopes","_altura","_list","_can","_max",
	"_hayRutaWP","_openD"];

_veh = _this select 0;
_who = _this select 1;
_datFastRopes = _this select 2;

if (isnil ("_who")) exitWith {};
if (_veh getvariable ["fastRoping", false]) exitWith {};

//Fast-rope iniciado por player en la carga y piloto AI
if ((_who != driver _veh) and (not (isPlayer (driver _veh)))) then
{
	_veh setvariable ["fastRopeManual", true, true];
	_altura = (_veh getvariable ["fastRopeHeight", 9.99]);
	while {((getpos _veh select 2) > _altura) and (alive _veh)} do
	{
		_veh flyInHeight _altura;
		sleep 0.1;
	};
	_veh flyInHeight (getpos _veh select 2);
	if (not alive _veh) exitWith {};
};

if (count (waypoints (group _veh)) <= 1) then {_hayRutaWP = false} else {_hayRutaWP = true};

_veh setvariable ["fastRopeOn", true, true];
_veh setvariable ["fastRoping", false, true];
_veh vehicleChat format ["%1", localize "STR_fastrope11"];

 _can = 0; _max = 0;
{
	if (not (isPlayer _x)) then {_x setvariable ["FRdown", 1, true]};
	if ((_x getvariable ["FRdown", 0]) == 1) then {_max = _max + 1};
} foreach (crew _veh);

_listRopes = [];
_max = (_max/4);
if (_max > (count _datFastRopes)) then {_max = (count _datFastRopes)};

{
	if (_can <= _max) then
	{
		_rope = "rav_fastrope" createvehicle [0,0,0];
		{_rope animate [format["bajando%1",_x], 0]} foreach [1,2];
		_rope setObjectTextureGlobal  [0,"RAV_LIFTER_A3\negro.paa"];
		_rope setObjectTextureGlobal  [1,"RAV_LIFTER_A3\negro.paa"];
		_rope setObjectTextureGlobal  [2,"RAV_LIFTER_A3\anilla.paa"];
		_rope setObjectTextureGlobal  [4,"RAV_LIFTER_A3\soga.paa"];
		_rope setObjectTextureGlobal  [3,"RAV_LIFTER_A3\soga.paa"];
		_rope setObjectTextureGlobal  [5,""];
		if ((_x select 2) == 0) then {_rope setObjectTextureGlobal  [0,""]}
		else
		{
			_rope setObjectTextureGlobal  [0,"RAV_LIFTER_A3\negro.paa"];
			_rope setObjectTextureGlobal  [1,"RAV_LIFTER_A3\negro.paa"];
			_rope setObjectTextureGlobal  [2,"RAV_LIFTER_A3\anilla.paa"];
		};
		_rope attachTo [_veh,_x select 0]; //--- Posicion de cuerda
		_rope setdir (_x select 1); //--- Direccion de cuerda
		_rope setvariable ["modeSet", _x select 3]; //--- Posicion inicial en cuerda

		_rope setvariable ["freeSlot", 0]; //--- Estado Libre:0 Ocupado:1
		_listRopes = _listRopes + [_rope];
		sleep 0.001;
	};
	_can = _can + 1;
} foreach _datFastRopes;

//--- Abre rampas / puertas
_openD = [_veh] execVM (pathlifter + "OpenDoors.sqf");
waitUntil {scriptdone _openD};

_altura = (getpos _veh select 2);
{
	null = [_veh, _x] spawn
	{
		private ["_veh","_rope","_anim","_animAnt","_altMax","_dir","_altura"];

		_veh = _this select 0;
		_rope = _this select 1;

		sleep (1 + random(0.5));

		//---- Despliegua cuerda
		_rope animate ["ladea",65];
		waitUntil {_rope animationPhase "ladea" > 0.50};
		_rope animate ["despliega",1];
		waitUntil {_rope animationPhase "despliega" > 0.05};
		_rope animate ["voltea",1];
		waitUntil {(_rope animationPhase "ladea" > 0.649) or (_rope animationPhase "despliega" > 0.50)};
		_rope animate ["ladea",0.45];
		waitUntil {(_rope animationPhase "ladea" < 0.451) or (_rope animationPhase "despliega" > 0.99)};
		_rope animate ["ladea",0.60];
		waitUntil {(_rope animationPhase "ladea" < 0.599) or (_rope animationPhase "despliega" > 0.99)};
		//
		_rope animate ["ladea",0.50];
		waitUntil {_rope animationPhase "despliega" > 0.99};
		_rope say3D "fastropeEnd";

		_animAnt = 0;
		_altMax = 25.00;
		_extremo = false;
		_dir = direction _veh;

		while {(alive _veh) and (_veh getvariable "fastRopeOn")} do
		{
			if (not (isPlayer (driver _veh))) then
			{
				_veh setvelocity [0,0,0]; _veh setvectorUp [0,0,1]; _veh setdir _dir;
			}
			else
			{
				//--- Amortiguador de maniobras (piloto humano)
				//_veh setvelocity [(velocity _veh select 0) * 0.25, (velocity _veh select 1) * 0.25, velocity _veh select 2];
			};
			if (abs(speed _veh) > 10) then {_veh setvariable ["fastRopeOn", false]};

			_altura = (getpos _veh) select 2;
			//_altura = (_rope modelToWorld (_rope selectionPosition "posRope") select 2);
			if (_altura > _altMax) then {_anim = 1}
			else {_anim = (_altura / _altMax)};
			if ((abs(_anim - _animAnt) > 0.01)) then
			{
				if (_anim != _animAnt) then
				{
					_rope animate ["aju_altura", _anim];
					_animAnt = _anim;
					if (_anim < 0.90) then
					{
						if (not _extremo) then {_rope setObjectTextureGlobal  [3,"RAV_LIFTER_A3\soga.paa"]; _extremo = true};
					}
					else
					{
						if (_extremo) then {_rope setObjectTextureGlobal  [2,""]; _extremo = false};
					};
				};
			};
			sleep 0.005;
		};
	};
	sleep 0.5;
} foreach _listRopes;

_veh vehiclechat format ["%1",localize "STR_fastrope3"];
_veh setvariable ["waitRelease", true, true];

nul = [_veh, _listRopes] execVm pathlifter + "grpOut.sqf";
while {(alive _veh) and (_veh getvariable ["fastRopeOn",false])} do {sleep 0.5};

if (not isPlayer (driver _veh)) then
{
	//if (count (waypoints (group _veh)) <= 1) then
	if (not _hayRutaWP) then
	{
		null = [_veh, _altura] spawn
		{
			private ["_veh","_altura","_altura2","_px","_py","_wp"];
			_veh = _this select 0;
			_altura = _this select 1;
			_altura2 =  (getpos _veh) select 2;
			while {_veh getvariable "waitRelease"} do {_veh flyInHeight _altura2; sleep 1};

			_px = ((getpos _veh) select 0) + (2500 * sin(direction _veh));
			_py = ((getpos _veh) select 1) + (2500 * cos(direction _veh));

			{deleteWaypoint _x} foreach (waypoints (group _veh));

			_wp = (group _veh) addWaypoint [[_px, _py, 0], 100];
			(group _veh) setCurrentWaypoint [(group _veh), count (waypoints (group _veh))-1];
			sleep 2;
			_veh flyinheight (_altura * 3);
		};
	}
	else
	{
		while {(alive _veh) and (_veh getvariable ["fastRopeOn",false])} do {_veh setvelocity [0,0,0]; sleep 0.1};
	};
};

_veh removeaction (_veh getvariable "accFastRope");
{
	null = [_veh, _x] spawn
	{
		private ["_veh","_r","_rope"];
		_veh = _this select 0;
		_r = _this select 1;

		detach _r;
		_r setObjectTextureGlobal  [5,"RAV_LIFTER_A3\soga.paa"];
		{_r setObjectTextureGlobal  [_x, ""]} foreach [0,1,2,4];
		_rope = "RAV_fastrope_suelta" createvehicle [0,0,0];
		_rope setpos [getpos _r select 0, getpos _r select 1, 0];
		_r animate ["suelta", 1];
		_veh setvariable ["waitRelease", false, true];
		sleep 1;
		waitUntil {_r animationPhase "suelta" > 0.99};
		deletevehicle _r;
		_r say3D "fastropeEnd";
		sleep 30;
		deletevehicle _rope;
	};
	sleep 0.1;
} foreach _listRopes;
_veh setvariable ["fastRopeManual", false, true];
_veh vehiclechat format ["%1",localize "STR_fastrope4"];
