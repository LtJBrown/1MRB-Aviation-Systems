//---- Execute sound 3D

_snd = _this select 0;
_who = _this select 1;
_vol = _this select 2;
_dis = _this select 3;

playSound3D [_snd, _who, false, getPos _who, _vol, 1, _dis];