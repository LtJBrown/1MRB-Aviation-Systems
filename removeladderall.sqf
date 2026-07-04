private ["_veh","_obj","_ord","_ladder"];

_veh = _this select 0;
_obj = _this select 1;
_ord = _this select 2;

if (_ord == 1) then
{
	_veh removeaction (_veh getvariable "ladderOn");
	_veh removeaction (_veh getvariable "ladderOff");
	_obj removeaction (_obj getvariable "ladderUp");
	_veh removeaction (_veh getvariable "ladderDown");
	_veh removeaction (_veh getvariable "ladderDown2");

	_ladder = _veh getvariable "ladder";
	if (not isnil("_ladder")) then {deletevehicle _ladder};
}
else
{
	_veh setvariable ["ladder", nil];
	_veh setvariable ["switchLadder", nil, true];
	_obj setvariable ["switchLadder", nil, true];
	_veh setvariable ["ladder", nil, true];
};