private ["_txt","_icon","_fastRopeOn","_datFastRopes","_tiptip","_datHelo","_yesFastrope","_posFR","_baja","_yaChkKey",
	"_fastRopeHeight","_timeF","_crew"];

_veh = _this select 0;
if (not isServer) exitWith {};
if (("plane" counttype [_veh] > 0) and not (format ["%1",typeOf _veh] in ["MV22","USAF_CV22"])) exitWith {};

_crew = 0;
{_crew = _crew + (_veh emptyPositions _x)} foreach ["commander","driver","gunner","cargo"];
_veh setvariable ['rav_positions', _crew];

_timeF = time + (10+random(5));
while {(isnil("RAV_LIFTER3")) and (time < _timeF)} do {sleep 0.5};
if (isnil("RAV_LIFTER3")) exitWith {};

if (_veh getvariable ["execFR", false]) exitWith {};
_veh setvariable ["fastRopeOn", false, true];
_veh setvariable ["execFR", false, true];

if (isnil("RAV_FastRope_on")) then {_yesFastRope = true} else {if (not RAV_FastRope_on) then {_yesFastRope = false} else {_yesFastRope = true}};
if (not _yesFastRope) exitWith {};

_tiptip = toUpper(typeOf _veh);

if ((count _this) > 1) then
{
	_datFastRopes = _this select 1;
}
else
{
	pathLifter = "\RAV_Lifter_A3\";
	fnc_RAV_chkHelo = compile loadFile (pathlifter + "chkHelo.sqf");
	_datHelo = [_tiptip] call fnc_RAV_chkHelo;
	_datFastRopes = _datHelo select 3;
};
if ((count _datFastRopes) == 0) exitWith {};

//--- Auto Lifter
[[[_veh],pathlifter+"Init_LifterAI.sqf"],"BIS_fnc_execVM",false,false] spawn BIS_fnc_MP;

//--- Auto-FastRope
[[[_veh, _datFastRopes],pathlifter+"ActionFastRopeMP.sqf"],"BIS_fnc_execVM",true,true] spawn BIS_fnc_MP;

_yaChkKey = false;
_veh setvariable ["fastRopeManual", false, true];
while {alive _veh} do
{
	//--- es AI
	if (not isPlayer (driver _veh)) then
	{
		//--- No es Zeus
		if (isnull (getAssignedCuratorLogic (driver _veh))) then
		{
			_yaChkKey = false;
			if ((_veh getvariable "fastRopeOn") and not (_veh getvariable ["fastRopeManual", false])) then
			{
				//--- Aproximacion forzada a zona
				_posFR = _veh getvariable ["fastRopePos", getpos _veh];
				_veh setvariable ["approach", true, true];
				nul = [_veh, _posFR, true, false] execVM pathlifter + "lander.sqf";
				waitUntil {(alive _veh) and not (_veh getvariable "approach")};
				_veh flyInHeight ((position _veh select 2));

				if (alive _veh) then
				{
					if (count(assignedCargo _veh) > 0) then
					{
						_veh setvariable ["execFR", true, true];
					};
				};
			} else {_veh enableAi "move"};
		};
	}
	else
	{
		if ((not _yaChkKey)) then
		{
			_yaChkKey = true;
			//--------------------------------------------------------------
			//--- userAction drop fast-rope
			[[[_veh],pathlifter+"KeyFastRopeMP.sqf"],"BIS_fnc_execVM",true,true] spawn BIS_fnc_MP; //only in server
			sleep 1;
			//--------------------------------------------------------------
		};
	};

	if ((_veh getvariable "execFR") and (alive _veh)) then
	{
		_veh setvariable ["execFR", false, true];
		null = [_veh,(driver _veh),nil,[_datFastRopes]] execVM (pathlifter + "fastRopeOn.sqf");
		sleep 1;
		while {(_veh getvariable "fastRopeOn") and (alive _veh) and not (isplayer (driver _veh))} do { _veh setvelocity [0,0,0]; sleep 0.10};
		if (alive _veh) then {_veh setspeedmode "normal"};
		_veh enableAi "move"
	};
	sleep 1;
};
_veh removeaction (_veh getvariable "accFastRope");