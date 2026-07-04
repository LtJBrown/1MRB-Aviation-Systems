private ["_center","_datCam","_cualRender","_datFastRopes","_description","_datCrane"];

_tiptip = _this select 0;

_center = [0,0,0];
_datCam = [];
_cualRender = 1;
_datFastRopes = [];
_datCrane = [];

if (_tiptip isKindOf "MV22") then
{
	_description = "MV22 by HotShotMike";
	_center = [0,-1.7,-0.8];
	_datCam = [[-0.31,6,-1],[0,-3.5,-3],[0,2,-7]];
	_datFastRopes = [[[0,-5.5,-13.05],0,0,3]];
};
if (_tiptip isKindOf "USAF_CV22") then
{
	_description = "CV22 by fullerpj";
	_center = [0,-1.7,-0.8];
	_datCam = [[-0.31,6,-1],[0,-3.5,-3],[0,2,-7]]; _cualRender = 4;
	_datFastRopes = [[[0,-5.5,-13.05],0,0,3]];
};
if (_tiptip isKindOf "SFP_HKP9") then
{
	_description = "Swiss Mod";
	_center = [0,-2.5,0.7];
	_datCam = [[0.65,1.4,0.15],[0,-2,-1.5],[0,2, -6]];
	_datFastRopes = [[[0.1,0,-12],270,1,1],[[-0.1,0,-12],90,1,1]];
};
if (_tiptip isKindOf "HELI_LIGHT_01_BASE_F") then
{
	_center = [0, -1.5,1.2];
	_datCam = [[-0.25,1.6,0.8],[0,0, -1.4],[0,2, -6]]; _cualRender = 0;
	_datFastRopes = [[[0.35,0.80, -12.7],270,0,4],[[-0.35,0.80, -12.7],90,0,4]];
};
if (_tiptip isKindOf "HELI_LIGHT_02_BASE_F") then
{
	_center = [0, -0.5,0];
	_datCam = [[0.57,4, -0.2],[0,0.5, -1.8],[0,2, -6]];
	_datFastRopes = [[[1.0,1.40, -12.15],270,1,1],[[-1.0,1.40, -12.15],90,1,1]];
};
if (_tiptip isKindOf "HELI_TRANSPORT_02_BASE_F") then
{
	_center = [0,0, -1];
	_datCam = [[1,6.8, -1],[0,0, -2.9],[0,2, -6]];
	_datFastRopes = [[[1.05,2.40, -12.6],270,1,3],[[-1.00,4.70, -12.6],90,1,3]];
};
if (_tiptip isKindOf "HELI_TRANSPORT_01_BASE_F") then
{
	_center = [0,0,0.1];
	_datCam = [[-0.8,6.05, -0.35],[0,0.5, -1.8],[0,2, -6]];
	_datFastRopes = [[[0.75,2.40, -12.15],270,1,1],[[-0.70,2.40, -12.15],90,1,1]];
	_datCrane = [[1.5,2.4,0.25],0,0];
};
if (_tiptip isKindOf "I_HELI_LIGHT_03_UNARMED_BASE_F") then
{
	_center = [0,0,1];
	_datCam = [[0.67,4.45,0.2],[0,1, -1.7],[0,2, -6]];
	_datFastRopes = [[[1.00,3.00, -11.95],270,1,1],[[-1.05,3.00, -11.95],90,1,1]];
};
if (_tiptip isKindOf "CAF_CH146_BASE_F") then
{
	_center = [0,0, -0.5];
	_datCam = [[0.75,4.3, -1.3],[0, -1, -2],[0,2, -6]];
	_datFastRopes = [[[0.60,2.4, -13.5],270,1,1],[[-0.65,2.4, -13.5],90,1,1]];
};
if (_tiptip isKindOf "CH_47_BASE") then
{
	_description = "Mod Marsof";
	_center = [0, -1.8, -0.9];
	_datCam = [[0.85,6.65, -1.25],[0, -2, -3.5],[0,2.5, -7.5]];
	_datFastRopes = [[[0.7, -7.0, -13.20],0,0,5],[[-0.7, -7.0, -13.20],0,0,5],[[0,0.25, -12.80],0,0,2]];
};
if (_tiptip isKindOf "CH147_BASE") then
{
	_description = "Mod Canadian";
	_center = [0, -1.8, -0.9];
	_datCam = [[-0.75,6.60, -1.10],[0, -2, -3],[0,2.5, -7.5]];
	_datFastRopes = [[[0.7, -7.0, -13.10],0,0,5],[[-0.7, -7.0, -13.10],0,0,5],[[0,0.3, -12.50],0,0,2]];
};
if (_tiptip isKindOf "UNARMED_CH_47F") then
{
	_description = "Mod deltagamer UNARMED";
	_center = [0, -1.70, -1.4];
	_datCam = [[-0.85,7.60, -1.20],[0, -3.5, -3.7],[0,3.0, -7.5]];
	_datFastRopes = [[[0.7, -7.7, -13.65],0,0,3],[[-0.7, -7.7, -13.65],0,0,3],[[0,0.25, -13.00],0,0,5]];
};
if (_tiptip isKindOf "RAMP_CH_47F") then
{
	_description = "Mod deltagamer RAMP";
	_center = [0, -1.70, -1.4];
	_datCam = [[-0.85,7.60, -1.20],[0, -3.5, -3.7],[0,3.0, -7.5]];
	_datFastRopes = [[[0.7, -7.7, -13.65],0,0,3],[[-0.7, -7.7, -13.65],0,0,3],[[0,0.25, -13.00],0,0,5]];
};
if ((_tiptip isKindOf "RAMPGUN_CH_47F") or (_tiptip isKindOf "RAMPGUNDES_CH47")) then
{
	_description = "Mod deltagamer RAMPGUN";
	_center = [0, -1.70, -1.05];
	_datCam = [[-0.85,6.70, -1.20],[0, -3.5, -3.7],[0,3.0, -7.5]];
	_datFastRopes = [[[0,0.25, -13.00],0,0,5]];
};
if (_tiptip isKindOf "RAMPGUNBAF_CH_47F") then
{
	_description = "Mod deltagamer RAMPGUN";
	_center = [0, -1.70, -1.05];
	_datCam = [[0.85,6.70, -1.20],[0, -3.5, -3.7],[0,3.0, -7.5]];
	_datFastRopes = [[[0,0.25, -13.00],0,0,5]];
};
if (_tiptip isKindOf "CH_47F_BASE") then
{
	_description = "Mod Aplion";
	_center = [0, -1.70, -1.4];
	_datCam = [[-0.85,7.60, -1.20],[0, -3.5, -3.7],[0,3.0, -7.5]];
	_datFastRopes = [[[0.7, -7.7, -13.65],0,0,3],[[-0.7, -7.7, -13.65],0,0,3],[[0,0.25, -13.00],0,0,2]];
};
if (_tiptip isKindOf "KYO_MH47E_BASE") then
{
	_description = "Mod Konyo";
	_center = [0,0,0.2];
	_datCam = [[1.00,8.95,0.20],[0, -3.5, -2.2],[0,3.0, -7.0]];
	_datFastRopes = [[[0.7, -6.1, -12.5],0,0,5],[[-0.7, -6.1, -12.5],0,0,5],[[0,1.85, -11.75],0,0,5]];
};
if (_tiptip isKindOf "MEU_CH46_SEAKNIGHT") then
{
	_center = [0.3, -0.5,0.40];
	_datCam = [[1.25,6.50,0.25],[0.3, -3.5, -3.2],[0.3,3.0, -7.0]];
	_datFastRopes = [[[0.3, -4.6, -12.5],0,0,5],[[0.3,1.0, -11.75],0,0,5]];
};
if ((_tiptip isKindOf "ADF_S70A_BASE")) then
{
	_center = [0, -0.9,0.5];
	_datCam = [[1.05,5.2, -0.18],[0, -1, -2],[0,2, -6]];
	_datFastRopes = [[[0.65,1.6, -11.95],270,1,1],[[-0.60,1.6, -11.95],90,1,1]];
};
if ((_tiptip isKindOf "UH60_BASE") or (_tiptip isKindOf "UH60M_BASE") or (_tiptip isKindOf "SFP_HKP16_BASE")) then
{
	_center = [0, -0.9,0];
	_datCam = [[1.05,5.1, -0.63],[0, -1, -2],[0,2, -6]];
	_datFastRopes = [[[0.65,1.6, -12.75],270,1,1],[[-0.60,1.6, -12.75],90,1,1]];
};
if (_tiptip isKindOf "UH60MFAB_BASE") then
{
	_center = [0, -0.7,0.5];
	_datCam = [[1.05,5.35, -0.2],[0, -1, -2],[0,2, -6]];
	_datFastRopes = [[[0.65,1.6, -11.95],270,1,1],[[-0.60,1.6, -11.95],90,1,1]];
};
if (_tiptip isKindOf "UH1H_BASE") then
{
	_center = [0, -1,0.1];
	_datCam = [[0.70,3.30, -0.2],[0, -1.5, -1.7],[0,2, -6]];
	_datFastRopes = [[[0.80,1.4, -12.4],270,1,1],[[-0.85,1.4, -12.4],90,1,1]];
};
if (_tiptip isKindOf "A109_BASE") then
{
	_center = [0, -2,2.5];
	_datCam = [[0.85,2.60,1.95],[0, -3.5, -1.0],[0,2, -6]];
	_datFastRopes = [[[0.35,0.80, -10.15],270,1,1],[[-0.35,0.80, -10.15],90,1,1]];
};
if (_tiptip in ["SAF_MI17_BASE","CROAF_MI171_F","CROAF_MI8_AMT_F","SAF_MI8_MEDEVAC_BASE"]) then
{
	_center = [0,0.3, -0.5];
	_datCam = [[-0.86,6.50, -1.05],[0, -3.5, -2.45],[0,2, -9]];
	_datFastRopes = [[[-1.10,4.75, -13.0],90,1,1]];
};
if (_tiptip in ["CHA_MI17_INS", "CHA_MI17_CDF", "CHA_MI17_UN_CDF_EP1", "CHA_MI171SH_CZ_EP1", "CHA_MI17_TK_EP1","CHA_MI17_MEDEVAC_INS", "CHA_MI17_MEDEVAC_CDF", "CHA_MI17_MEDEVAC_RU", "CHA_MI17_CIVILIAN"]) then
{
	_description = "Mod Chairborne";
	_center = [0,0.3, -0.5];
	_datCam = [[-0.86,6.50, -1.05],[0, -3.5, -2.45],[0,2, -9]]; _cualRender = 2;
	_datFastRopes = [[[-0.60,4.75, -13.0],90,1,1]];
};
if (_tiptip isKindOf "USAF_HH60G") then
{
	_description = "Mod USAF";
	_center = [0, -0.7,-0.05];
	_datCam = [[0.90,5.05, -0.6],[0, -1, -2],[0,2, -6]];
	_datFastRopes = [[[0.80,1.95, -12.75],270,0,1],[[-0.80,2.05, -12.75],90,0,1]];
};
if (_tiptip isKindOf "SUD_UH60_BASE") then
{
	_description = "???";
	_center = [0, -0.77,-0.05];
	_datCam = [[0.85,5.05, -0.65],[0, -1, -2],[0,2, -6]];
	_datFastRopes = [[[0.70,1.45, -12.65],270,0,1],[[-0.70,1.55, -12.65],90,1,1]];
};

if (((_center select 0) + (_center select 1) + (_center select 2)) != 0) then {_veh setvariable ["GeoLifter", _center]};
[_center,_datCam,_cualRender,_datFastRopes,_datCrane];