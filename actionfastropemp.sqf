private ["_txt","_icon","_cond","_fastRopeOn","_fastRopeOn2","_fastRopeOn3","_datFastRopes","_fastRopeGo"];

_veh = _this select 0;
_datFastRopes = _this select 1;

//--- Lider de grupo indica posicion para fast-rope -------------------------------------
_txt = "<t color='#E8991B' size='1.2'>" + format ["%1",localize "STR_fastrope12"] + "</t>";
//_icon = "<img size='3.5' shadow=0 color='#E8991B' image='" + pathlifter + "fastRopeOn.paa'/>";
_icon = "";
_cond = "(_this in _target) and (_this == leader (group _this)) and (_this != (driver _target)) and not (_target getvariable 'fastRopeOn') and ((({not local(_x)} count (crew _target)) > 0) or (count (assignedCargo _target) > 0)) and (not(_target getvariable ['lift', false]))";
_fastRopeGo = _veh addAction [_txt+_icon, pathLifter + "fastRopeGo.sqf", [_veh], 80, false, true, "", _cond];

//--- Piloto/lider de grupo inicia despliegue de cuerdas -------------------------------------
_txt = "<t color='#E8991B' size='1.2'>" + format ["%1",localize "STR_fastrope1"] + "</t>";
//_icon = "<img size='3.5' shadow=0 color='#E8991B' image='" + pathlifter + "fastRopeOn.paa'/>";
_icon = "";
_cond = "(_this in _target) and ((_this == driver _target and (getpos _target select 2 < 25)) or (_this == leader (group _this) and (getpos _target select 2 < 250))) and (getpos _target select 2 > 5) and (abs(speed _target) < 10) and not (_target getvariable 'fastRopeOn') and ((({not local(_x)} count (crew _target)) > 0) or (count (assignedCargo _target) > 0)) and (not(_target getvariable ['lift', false]))";
_fastRopeOn = _veh addAction [_txt+_icon, pathLifter + "fastRopeOn.sqf", [_datFastRopes], 80, false, true, "", _cond];

//--- Player elige descender por cuerda ---------------------------------------
_txt = "<t color='#E8991B' size='1.2'>" + format ["%1",localize "STR_fastrope7"] + "</t>";
//_icon = "<img size='3.5' shadow=0 color='#E8991B' image='" + pathlifter + "fastRopeOn.paa'/>";
_icon = "";
_cond = "((_this getvariable ['FRdown', 0]) == 0) and (getpos _target select 2 < 200) and (getpos _target select 2 > 5) and (abs(speed _target) < 150) and (isplayer _this) and (_this != (driver _target)) and ((({not local(_x)} count (crew _target)) > 0) or (count (assignedCargo _target) > 0)) and not (_target getvariable ['fastRoping', false])";
_fastRopeOn2 = _veh addAction [_txt+_icon, pathLifter + "includefastRope.sqf", [true], 70, false, true, "", _cond];

//--- Player cancela descender por cuerda --------------------------------------
_txt = "<t color='#E8991B' size='1.2'>" + format ["%1",localize "STR_fastrope8"] + "</t>";
//_icon = "<img size='3.5' shadow=0 color='#E8991B' image='" + pathlifter + "fastRopeOn.paa'/>";
_icon = "";
_cond = "((_this getvariable ['FRdown', 0]) == 1) and (getpos _target select 2 < 200) and (getpos _target select 2 > 5) and (abs(speed _target) < 150) and (isplayer _this) and ((({not local(_x)} count (crew _target)) > 0) or (count (assignedCargo _target) > 0)) and not (_target getvariable ['fastRoping', false])";
_fastRopeOn3 = _veh addAction [_txt+_icon, pathLifter + "includefastRope.sqf", [false], 70, false, true, "", _cond];