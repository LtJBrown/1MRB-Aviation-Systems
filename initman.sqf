private ["_man","_vehAnt","_shift","_key","_veh","_ServerVersion","_version","_Stxt","_timeF"];

_man = _this;

pathLifter = "\RAV_Lifter_A3\";
_version = "1.0.8";

if ((isplayer _man) or (_man in playableUnits)) then
{
	while {not (isplayer _man)} do {sleep 5};

	_timeF = time + (5+random(5));

	if ((isPlayer _man) and (local _man) and (isnil("RAV_LIFTER3"))) then
	{
		//--- verifica existencia de Zeus, Alive o MCC corriendo en la partida
		while {time < _timeF} do {sleep 1};
		private ["_autoRun","_center","_logics","_ll","_hayCurator","_hayZeus","_hayAlive"];
		_center = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
		_logics = _center nearEntities [["logic"], 50000];
		_autoRun = false; _ll = "";
		if (count _logics > 0) then
		{
			{_ll = _ll + toUpper (format ["%1,", _x]); sleep 0.1} foreach _logics;
			_hayCurator = ["CURATOR", _ll] call BIS_fnc_inString;
			if (not _hayCurator) then
			{
				_hayZeus = ["ZEUS", _ll] call BIS_fnc_inString;
				if (not _hayZeus) then
				{
					_hayAlive = ["ALIVE", _ll] call BIS_fnc_inString;
					if (_hayAlive) then {_autoRun = true};
				} else {_autoRun = true};
			} else {_autoRun = true};
		};
		if (_autoRun) then
		{
			[[[],pathlifter+"setup.sqf",false],"BIS_fnc_execVM",false,false] spawn BIS_fnc_MP;
		};
	};

	sleep 1;
	while {(isnil("RAV_LIFTER3")) and (time < _timeF)} do {sleep 0.5};
	if (isnil("RAV_LIFTER3")) exitWith {};

	fnc_RAV_chkHelo = compile loadFile (pathlifter + "chkHelo.sqf");

	if ((isPlayer _man) and local player) then
	{
		//--- Check version SERVER and CLIENT
		if (isnil("RAV_LIFTER3_version")) exitWith {};
		_ServerVersion = RAV_LIFTER3_version;
		if ((typename _ServerVersion) == "STRING") then
		{
			if (_version != _ServerVersion) exitWith
			{
				_timeF = time + 15;
				while {time < _timeF} do
				{
					_Stxt = parseText ("<t font='LucidaConsoleB' size='1.2' color='#F0A804'>" + format ["%1",localize "STR_lifter001"] + "</t><br/><img size='7' image='\RAV_LIFTER_A3\icono.paa'/><br/><t size='1.4'>" + format ["Server: %1", _serverVersion] + "<br/>" + format ["Client: %1", _version] + "</t>");
					hintsilent _Stxt;
					sleep 0.05;
				};
			};
		};

		while {true} do
		{
			_man = player;
			while {(isPlayer _man) and (local player)} do
			{
				while {player == (vehicle player)} do {sleep 5};
				_veh = vehicle player;
				if (("helicopter" counttype [_veh] > 0) or (format ["%1",typeOf _veh] in ["MV22","USAF_CV22"])) then
				{
					if (player == driver _veh) then
					{
						null = _veh execVM (pathLifter + "InitAir.sqf");
						while {alive(player) and ((vehicle player) == _veh) and (player == (driver _veh))} do {sleep 1};
					};
				};
				sleep 1;
			};
			sleep 1;
		};
	};
};
