private ["_man","_px","_py","_dir"];

_man = _this select 0;
_man setunitpos "middle";
_dir = random(360);
_px = (position _man select 0) + 10 * sin(_dir);
_py = (position _man select 1) + 10 * cos(_dir);
_man domove [_px, _py, 0];
sleep 20;
_man setunitpos "auto";
