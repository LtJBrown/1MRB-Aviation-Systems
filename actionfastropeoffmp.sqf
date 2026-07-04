private ["_txt","_icon","_fastRopeOff"];

_veh = _this select 0;

_veh removeaction (_veh getvariable "accFastRope");

_txt = "<t color='#E8991B' size='1.2'>" + format ["%1",localize "STR_fastrope2"] + "</t>";
//_icon = "<img size='3.5' shadow=0 color='#E8991B' image='" + pathlifter + "fastRopeOff.paa'/>";
_icon = "";
_fastRopeOff = _veh addAction [_txt+_icon, pathLifter + "fastRopeOff.sqf", [_veh], 80, false, true, "", "(_this == driver _target) and (getpos _target select 2 < 25) and (getpos _target select 2 > 5) and (abs(speed _target) < 10) and (_target getvariable 'fastRopeOn') and (_veh getvariable ['accFastRope', false])"];

_veh setvariable ["accFastRope", _fastRopeOff, true];