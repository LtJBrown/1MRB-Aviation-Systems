private ["_veh","_tfin","_delay"];

_veh = _this select 0;

private ["_tam"];

_veh = _this select 0;

_tfin = time + 10;

RAV_fastRope_pos = [];
openMap [true, false];
[] spawn
{
	while {count RAV_fastRope_pos == 0} do
	{
		["<t color='#000000'>"+format ["%1",localize "STR_fastrope14"],0,.5,0.5,0] call bis_fnc_dynamictext;
		sleep 0.01;
	};
	["<t color='#000000'>"+" ",0,.5,4,0] call bis_fnc_dynamictext;
};
onmapSingleClick "RAV_fastRope_pos = _pos; onmapSingleClick ''; true;";

_delay = 0;
while {(time < _tfin) and visibleMap and (count RAV_fastRope_pos == 0)} do
{
	if (_delay == 0) then {/* tiempo agotado */};
	sleep 0.5;
	_delay = _delay + 0.5;
	if (_delay == 10) then {_delay = 0};
};

if ((count RAV_fastRope_pos) > 0) then
{
	RAV_fastRope_pos = [RAV_fastRope_pos select 0, RAV_fastRope_pos select 1, 0];

	[RAV_fastRope_pos, "<Fast-Rope", 45] spawn
	{
		_pos = _this select 0;
		_msg = _this select 1;
		_tmp = (_this select 2) + time;
		_marker = createMarkerlocal ["mrkFastRope", _pos];
		_marker setMarkerColorlocal "colorBlack";
		_marker setMarkerDirlocal 0;
		_marker setMarkerSizelocal [1.5,1.5];
		_marker setMarkerTextlocal _msg;
		_marker setMarkerTypelocal "selector_selectedMission";
		_marker setMarkerShapelocal "icon";
		while {time < _tmp} do {_marker setMarkerDirlocal (MarkerDir _marker) + 10; sleep 0.1};
		deletemarker _marker;
	};
	_veh setvariable ["approach", true, true];
	[[[_veh, RAV_fastRope_pos, true, false],pathlifter+"lander.sqf",false],"BIS_fnc_execVM",false,false] spawn BIS_fnc_MP;
	waitUntil {(alive _veh) and not (_veh getvariable "approach")};

	_veh flyInHeight ((position _veh select 2));
}
else
{
	RAV_fastRope_pos = [0]; //para abortar peticion en mapa
	_veh groupchat format ["%1",localize "STR_fastrope13"];
};
openMap [false, false];
