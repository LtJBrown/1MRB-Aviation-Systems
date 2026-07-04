private ["_veh","_obj","_pos","_ladder","_txt","_icon","_condic","_ladderUp","_ladderDown","_ladderOff",
	"_ladderUp2","_ladderDown2"];

_veh = _this select 0;
_obj = _this select 1;
_pos = _this select 2;

_ladder = _veh getvariable "ladder";
{_x setvariable ["switchLadder", false, true]} foreach [_veh, _obj];

//---------------------------------------------------------------------------------------------------------------
//--- Accion desplegar escalera ---------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1",localize "STR_lifter317"] + "</t>";
//_icon = "<img size='3.5' shadow=0 color='#FFFF00' image='" + pathlifter + "ladderOn.paa'/>";
_icon = "";
_condic = "(_this in _target) and not (_target getvariable 'switchLadder')";

_ladderOn = _veh addAction [_txt+_icon, pathLifter + "ladder.sqf", [_veh, _obj, _pos, true], 90, false, true, "", _condic];
_veh setvariable ["ladderOn", _ladderOn, true];

//---------------------------------------------------------------------------------------------------------------
//--- Accion recoger escalera -----------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1", localize "STR_lifter318"] + "</t>";
//_icon = "<img size='3.5' shadow=0 color='#FFFF00' image='" + pathlifter + "ladderOff.paa'/>";
_icon = "";
_condic = "(_this in _target) and (_target getvariable 'switchLadder')";

_ladderOff = _veh addAction [_txt+_icon, pathLifter + "ladder.sqf", [_veh, _obj, _pos, false], 90, false, true, "", _condic];
_veh setvariable ["ladderOff", _ladderOff, true];

//---------------------------------------------------------------------------------------------------------------
//--- Accion subir por escalera a helo (UNIDAD) -----------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1", localize "STR_lifter319"] + "</t>";
_icon = "";
_condic = "(_this in _target) and (_target getvariable 'switchLadder')";

_ladderUp = _obj addAction [_txt+_icon, pathLifter + "laddering.sqf", [_veh, _obj, true], 85, false, true, "", _condic];
_obj setvariable ["ladderUp", _ladderUp, true];

//---------------------------------------------------------------------------------------------------------------
//--- Accion bajar por escalera a bote de asalto (UNIDAD) -------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1", localize "STR_lifter320"] + "</t>";
_icon = "";
_condic = "(_this != (driver _target)) and (_this in _target) and (_target getvariable 'switchLadder')";

_ladderDown = _veh addAction [_txt+_icon, pathLifter + "laddering.sqf", [_veh, _obj, false], 85, false, true, "", _condic];
_veh setvariable ["ladderDown", _ladderDown, true];

//---------------------------------------------------------------------------------------------------------------
//--- Accion subir por escalera a helo (GRUPO) ------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1", localize "STR_lifter326"] + "</t>";
_icon = "";
_condic = "(_this == leader group _this) and (_this in _target) and (count (assignedCargo _target) > 0) and (_target getvariable 'switchLadder')";

_ladderUp2 = _obj addAction [_txt+_icon, pathLifter + "laddering.sqf", [_veh, _obj, true, true], 85, false, true, "", _condic];
_veh setvariable ["ladderUp2", _ladderUp2, true];

//---------------------------------------------------------------------------------------------------------------
//--- Accion bajar por escalera a bote de asalto (GRUPO) --------------------------------------------------------
//---------------------------------------------------------------------------------------------------------------
_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1", localize "STR_lifter327"] + "</t>";
_icon = "";
//_condic = "(_this == leader group _this) and (_this in _target) and (count (assignedCargo _target) > 0) and (_target getvariable 'switchLadder')";
_condic = "((_this == leader group _this) or (_this == (driver _target))) and (_this in _target) and (count (assignedCargo _target) > 0) and (_target getvariable 'switchLadder')";

_ladderDown2 = _veh addAction [_txt+_icon, pathLifter + "laddering.sqf", [_veh, _obj, false, true], 85, false, true, "", _condic];
_veh setvariable ["ladderDown2", _ladderDown2, true];
