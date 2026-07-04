private ["_obj","_alt","_enAgua"];

_obj = _this select 0;
_alt = _this select 1;
_enAgua = _this select 2;

_enAgua = surfaceIsWater (getposASL _obj);
if ((getposASL _obj select 2) > 0.1) then {_enAgua = false};
if (not _enAgua) then
{
	if ("static" counttype [_obj] > 0) then
	{
		_obj say3D "rav_snd_drop_obj";
	} else {_obj say3D "rav_snd_drop_veh"};
} else {_obj say3D "rav_snd_drop_splash"};

/*
//--- Sin damage ------------------------------------------
if (_alt < 5) then
{
	if (not _enAgua) then
	{
		if ("static" counttype [_obj] > 0) then
		{
			[[["rav_snd_drop_obj",_obj,1,10],"playSoundMP.sqf"],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
		}
		else
		{
			[[["rav_snd_drop_veh",_obj,1,10],"playSoundMP.sqf"],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
		};
	}
	else
	{
		[[["rav_snd_drop_splash",_obj,1,10],"playSoundMP.sqf"],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
	};
};

//--- Damage medio ------------------------------------------
if (_alt >= 5 and _alt < 10) then
{
	if (not _enAgua) then
	{
		if ("static" counttype [_obj] > 0) then
		{
			[[["rav_snd_drop_obj",_obj,5,20],"playSoundMP.sqf"],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
		}
		else
		{
			[[["rav_snd_drop_veh",_obj,5,20],"playSoundMP.sqf"],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
		};
	}
	else
	{
		[[["rav_snd_drop_splash",_obj,5,20],"playSoundMP.sqf"],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
	};
};

//--- Damage maximo ------------------------------------------
if (_alt > 10) then
{
	if (not _enAgua) then
	{
		if ("static" counttype [_obj] > 0) then
		{
			[[["rav_snd_drop_obj",_obj,10,30],"playSoundMP.sqf"],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
		}
		else
		{
			[[["rav_snd_drop_veh",_obj,10,30],"playSoundMP.sqf"],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
		};
	}
	else
	{
		[[["rav_snd_drop_splash",_obj,10,30],"playSoundMP.sqf"],"BIS_fnc_execVM",true,false] spawn BIS_fnc_MP;
	};
};
*/