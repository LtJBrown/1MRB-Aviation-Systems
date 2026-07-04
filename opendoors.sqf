_veh = _this select 0;

//--- Abre rampas / puertas
if (_veh isKindOf "CH_47F") then {_veh animate ["ramp", 1]}; //CH_47F
if (_veh isKindOf "CH_147F") then {_veh animatedoor ["ani_ramp",1]; _veh animatedoor ["ani_ramp2",1]}; //CH_147F
if (_veh isKindOf "HELI_TRANSPORT_01_BASE_F") then
{
	_veh animateDoor ["door_L", 1]; _veh animateDoor ["door_R", 1]; //Heli_Transport_01_base_F
};
if (_veh isKindOf "HELI_TRANSPORT_02_BASE_F") then
{
	_veh animateDoor ["door_back_L", 1]; _veh animateDoor ["door_back_R", 1]; //Heli_Transport_02_base_F
	_veh animateDoor ["Ani_Ramp", 0.4]; //Heli_Transport_02_base_F
};
if (_veh isKindOf "KYO_MH47E_BASE") then
{
	_veh animate ["Ani_Ramp",0.4]; //KYO_MH47E_BASE
	_veh animate ["Ani_Hatch1", 0]; _veh animate ["Ani_Hatch2", 0]; //KYO_MH47E_BASE
};
if (_veh isKindOf "CAF_CH146_BASE_F") then
{
	_veh animatedoor ["DoorL3_Open", 1]; _veh animatedoor ["DoorR3_Open", 1]; //CAF_CH146_BASE_F
};
if (_veh isKindOf "A109_BASE") then
{
	nul = [_veh] execVM "\A109\scripts\ldoor_open.sqf";
	nul = [_veh] execVM "\A109\scripts\rdoor_open.sqf";
};
if ((_veh isKindOf "ADF_S70A_BASE")) then
{
	_veh animateDoor ["door_L", 0]; _veh animateDoor ["door_R", 0]; //ADF_S70A_BASE
};
if (_veh isKindOf "MEU_CH46_SEAKNIGHT") then {_veh animate ["ramp",1]}; //MEU_CH46_SEAKNIGHT

if (_veh isKindOf "RAMP_CH_47F") then {_veh animate ["ramp",1]}; //RAMP_CH_47F
if (_veh isKindOf "UNARMED_CH_47F") then {_veh animate ["ramp",1]}; //UNARMED_CH_47F

if (_veh isKindOf "MV22") then {_veh animate ["ramp_bottom",1]; _veh animate ["ramp_top",1]}; //MV22
if (_veh isKindOf "USAF_CV22") then {_veh animate ["ramp_bottom",1]; _veh animate ["ramp_top",1]; sleep 8}; //USAF_CV22
