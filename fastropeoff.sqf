_veh = _this select 0;

_veh removeaction (_veh getvariable "accFastRope");
_veh setvariable ["fastRopeOn", false, true];
_veh setvariable ["fastRoping", false, true];