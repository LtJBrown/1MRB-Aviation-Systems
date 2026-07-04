// *******************************************************************************
// **       Funcion: Ladder.sqf
// **   Descripcion: Coloca/retira escalera
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_veh","_obj","_pos","_modo","_posLadder","_txt","_icon","_ladderOff","_ladder","_ladderUp","_ladderDown","_condic"];

_veh  = (_this select 3) select 0;
_obj  = (_this select 3) select 1;
_pos  = (_this select 3) select 2;
_modo = (_this select 3) select 3;

_ladder = _veh getvariable "ladder";
if (_modo) then
{
	//--- escalera desplegada
	{_x setvariable ["switchLadder", true, true]} foreach [_veh, _obj];
	_veh vehiclechat format ["%1",localize "STR_lifter323"];

	_ladder = "RAV_ladder" createvehicle [0,0,0];
	_ladder attachTo [_veh, _pos]; _ladder setdir 0;
	_veh setvariable ["ladder", _ladder, true];
	_ladder setvariable ["free", true, true];
	_veh animate ["Ani_Hatch1", 0]; _veh animate ["Ani_Hatch2", 0]; //KYO_MH47E_BASE
}
else
{
	//--- escalera recogida
	{_x setvariable ["switchLadder", false, true]} foreach [_veh, _obj];
	_veh vehiclechat format ["%1",localize "STR_lifter324"];
	deletevehicle (_veh getvariable "ladder");
	_veh animate ["Ani_Hatch1", 1]; _veh animate ["Ani_Hatch2", 1]; //KYO_MH47E_BASE
};