private ["_man","_tgt"];

_man = _this select 0;
_tgt = _this select 1;

if (_tgt emptyPositions "driver" > 0) then {_man moveindriver _tgt; _man assignasdriver _tgt}
else
{
	if (_tgt emptyPositions "commander" > 0) then {_man moveincommander _tgt; _man assignascommander _tgt}
	else
	{
		if (_tgt emptyPositions "gunner" > 0) then {_man moveingunner _tgt; _man assignasgunner _tgt}
		else
		{
			if (_tgt emptyPositions "cargo" > 0) then {_man moveincargo _tgt; _man assignascargo _tgt};
		};
	};
};