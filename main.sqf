// *******************************************************************************
// **       Funcion: Init.sqf
// **   Descripcion: Levanta objetos con helicopteros
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_veh","_tgt","_pos","_lng","_dtV","_dtT","_listObj","_obj","_px","_py","_pz","_icon",
		"_anch","_alt","_volVeh","_dtOb","_volObj","_rel","_liftOn","_liftOff","_txt","_ok","_tope",
		"_esEslinga","_retira","_dist","_avisa","_tipEslinga","_nomObj","_obj","_listObj2","_aborta",
		"_tt","_altobj","_buscaOn","_anclaje","_datCam","_distDetect","_topeObj","_topeLand","_topeSea",
		"_topeAir",	"_crew","_center","_cutRope","_esIA","_accIAant","_tiptip","_camActive","_UL","_UL2",
		"_cameraOn","_display","_handDisplay","_cualRender","_datHelo","_datFastRopes","_ya","_permite",
		"_datCrane","_gruaOn","_gruaOff"];

_veh = _this;

_aborta = false; _permite = false;
_tiptip = toUpper(typeOf _veh);

if (isnil("RAV_LIFTER3")) then {_aborta = true};
if ((("plane" counttype [_veh] > 0) and (format ["%1",typeOf _veh] in ["MV22","USAF_CV22"]))) then {_permite = true};
if (("helicopter" counttype [_veh] == 0) and not _permite) then {_aborta = true};

_crew = 0;
{_crew = _crew + (count (crew _veh)) + (_veh emptyPositions _x)} foreach ["commander","driver","gunner","cargo"];
if (_crew <= 2) then {_aborta = true};
if (player != (driver _veh)) then {_aborta = true};

if (_aborta) exitWith {};

_datCam = []; _cualRender = 1; _datFastRopes = [];
_center = _veh getvariable "GeoLifter";

//--- Posicion de GeoLifter y display-LCD/camara/objetivo de camara
_datHelo = [_tiptip] call fnc_RAV_chkHelo;

_center = _datHelo select 0;
_datCam = _datHelo select 1;
_CualRender = _datHelo select 2;
_datFastRopes = _datHelo select 3;
_datCrane = _datHelo select 4;

if ((count _datCam) == 0) exitWith {};

if (isnil("_center")) then {_center = [0,0,0]; _veh setvariable ["GeoLifter", _center]};

//--- Class/Targets to lift
_tgt = ["LandVehicle","Ship","air","Static","StaticWeapon","ReammoBox_F","thing","house_F"];

if (not isnil("RAV_LIFTER_cargo")) then
{
	if (typeName RAV_LIFTER_cargo == "ARRAY") then {_tgt = RAV_LIFTER_cargo};
};

_UL = "logic" createvehicleLocal [0,0,0]; _UL attachTo [_veh, _datCam select 2];
_UL2= "logic" createvehicleLocal [0,0,0];

_topeObj = 16; _topeLand = 12.3; _topeSea = 7.0; _topeAir = 6.0;
_avisa = false;
_avisa2 = false;
_distDetect = 10.00;
_camActive = false;

_dtV = boundingBoxReal _veh;
_anch = abs (((_dtV select 1) select 0) - ((_dtV select 0) select 0));
_lng  = abs (((_dtV select 1) select 1) - ((_dtV select 0) select 1));
_alt  = abs (((_dtV select 1) select 2) - ((_dtV select 0) select 2));
_volVeh = (_lng * _anch) * _alt;

//--- Ajustes a volumen de helicoptero con probe-fuel
if (_tiptip isKindOf "KYO_MH47E_BASE") then {_volVeh = 5940.48}; //--- Igual volumen a Chinook de Aplion (el de ArmA2)

masaVeh = _volVeh;

_veh setvariable ["accDeploy", -1];
_veh setvariable ["accCatch", -1];
_veh setvariable ["accCut", -1];
_veh setvariable ["selObj", objnull];
_veh setvariable ["lift", false];
_veh setvariable ["cameraOn", nil];
_veh setvariable ["AllowLift", true];
_veh setvariable ["eslinga2", objnull];
_veh setvariable ["antObj", objnull];
_veh setvariable ["ObjCargo", objnull];
_veh setvariable ["NoselObj", objnull];
_veh setvariable ["ladder", objnull];
_veh setvariable ["accIA", 0];
_veh setvariable ["heavy", false];

_accIAant = 0;

fnc_KeyPressed =
{
	_key = _this select 1;
	_shift = _this select 2;
	switch (_key) do
	{
		//tecla: H
//		player sidechat format ["Tecla: %1", _key];
		case 35: {nul = [_shift] execVM (pathLifter + "ControlCamera.sqf")};
	};
};
waituntil {!isnull (finddisplay 46)};
disableSerialization;
_display = findDisplay 46;
_handDisplay = _display displayAddEventHandler ["KeyDown","_this call fnc_KeyPressed; false;"];

//--- Crane
if (count _datCrane > 0) then
{
	_crane = "Crane" createvehicle [0,0,0];
	_crane attachTo [_veh, _datCrane select 0];
	_crane setdir (_datCrane select 1);
	switch (_datCrane select 2) do
	{
    	case 0: {_crane setObjectTextureGlobal [0, pathLifter + "Crane_0_co.paa"]}; /* verde */
    	case 1: {_crane setObjectTextureGlobal [0, pathLifter + "Crane_1_co.paa"]}; /* gris */
    	case 2: {_crane setObjectTextureGlobal [0, pathLifter + "Crane_2_co.paa"]}; /* negro */
    	case 3: {_crane setObjectTextureGlobal [0, pathLifter + "Crane_3_co.paa"]}; /* blanco */
    };

	_veh setvariable ["craneState", false, true];
	_txt = "<t color='#00b300' size='1.2'>" + format ["%1",localize "STR_lifter401"] + "</t>";
	_icon = "<img size='3.5' shadow=0 color='#FFFF00' image='" + pathlifter + "deploy.paa'/>";
	_icon = "";
	_gruaOn = _veh addAction [_txt+_icon, pathLifter + "CraneDown.sqf", [_veh, _crane, ["man"]], 80, false, true, "", "(_this in _target) and (_this == (driver _target)) and ((getpos _target select 2) > 3) and (speed _target < 10) and not (_target getvariable ['craneState', false])"];

	_txt = "<t color='#00b300' size='1.2'>" + format ["%1",localize "STR_lifter402"] + "</t>";
	_icon = "<img size='3.5' shadow=0 color='#FFFF00' image='" + pathlifter + "deploy.paa'/>";
	_icon = "";
	_gruaOff = _veh addAction [_txt+_icon, pathLifter + "CraneUp.sqf", [_veh, _crane], 80, false, true, "", "(_this in _target) and (_this == (driver _target)) and ((getpos _target select 2) > 3) and (speed _target < 10) and (_target getvariable ['craneState', false])"];
};

while {player == (driver _veh)} do
{
	_esIA = true;
	if (IsPlayer (driver _veh)) then {_esIA = false};
	//if (_esIA) exitWith {};

	_pos = getpos _veh;
	_alt = _pos select 2;
	_retira = false; _retira2 = false;

	//if (_esIA) then {if ((_veh getvariable "accIA") == _accIAant) then {_esIA = false}};
	if (_alt > 3 and _alt < 100) then
	{
		if (not (_veh getvariable "lift") and (_veh getvariable "AllowLift")) then
		{
			if ((_veh getvariable "accDeploy") == -1) then
			{
				if (_esIA) then
				{
					if ((_veh getvariable "accIA") == 1) then
					{
						[false,false,false,[_veh,_tgt,_UL2]] execVM pathLifter + "deployRopes.sqf";
					}
				}
				else
				{
					_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1",localize "STR_lifter307"] + "</t>";
					_icon = "<img size='3.5' shadow=0 color='#FFFF00' image='" + pathlifter + "deploy.paa'/>";
					_BuscaOn = _veh addAction [_txt+_icon, pathLifter + "deployRopes.sqf", [_veh, _tgt, _UL2], 99, false, true, "", "(_this in _target) and (_this == (driver _target)) and ((getpos _target select 2) > 3)"];
					_veh setvariable ["accDeploy", _buscaOn];
				};
				waitUntil {(_veh getvariable "accDeploy") != -1};
			};
		};
	}
	else
	{
		if ((_veh getvariable "accDeploy") != -1) then {_retira = true};
	};
	if (not (IsEngineOn _veh)) then {_retira = true};

	if (_retira) then
	{
		if (not isnull (_veh getvariable "eslinga2")) then
		{
			null = [false,false,false,[_veh, _veh getvariable "eslinga2",_UL2]] execVM pathLifter + "FreeRopes.sqf";
			_veh removeaction (_veh getvariable "accDeploy");
			_veh setvariable ["accDeploy", -1];
			waitUntil {(_veh getvariable "accDeploy") == -1};
			_veh setvariable ["antObj", objNull];
		};
	};

	if (not (_veh getvariable "lift") and (_veh getvariable "AllowLift") and (_alt > 1 and _alt < 100)) then
	{
		if (not isnull(_veh getvariable "eslinga2")) then
		{
			_anclaje = (_veh getvariable "eslinga2") modeltoworld ((_veh getvariable "eslinga2") selectionposition "anclaje");
			if ((_anclaje select 2) > 0) then
			{
				_listObj2 = _anclaje nearEntities [_tgt, _distDetect];
				sleep 0.10;
				_listObj = [];
				{
					_ok = false;
					if (((_x modeltoworld [0,0,0]) distance _anclaje) < 2) then
					{
						if (getNumber (configFile >> "CfgVehicles" >> format ["%1", typeOf _x] >> "Eslinga") == 0) then {_ok = true};
						if (_x getvariable ["noLift", false]) then {_ok = false};
						if (_x isKindOf "NONSTRATEGIC") then {_ok = false};
						if (_ok) then {_listObj = _listObj + [_x]};
					};
					sleep 0.01;
				} foreach _listObj2;

				if (count _listObj > 0) then
				{
					_obj = _listObj select 0;
					if (_obj != _veh getvariable "antObj") then
					{
						if ((_veh getvariable "accCatch") != -1) then
						{
							_veh removeaction (_veh getvariable "accCatch");
							_veh setvariable ["SelObj", objnull];
						};

						_dtOb = boundingBoxReal _obj;
						_anch = abs (((_dtOb select 1) select 0) - ((_dtOb select 0) select 0));
						_lng  = abs (((_dtOb select 1) select 1) - ((_dtOb select 0) select 1));
						_alt  = abs (((_dtOb select 1) select 2) - ((_dtOb select 0) select 2));

						_volObj = (_lng * _anch) * _alt;
						if (_volObj < 0.001) then {_volObj = 1};
						masaObj = _volObj;
						_rel = (_volVeh / _volObj);
						masaRel = _rel;

						//--- objetos/clases inhibidas ------------------------------
						if (_obj iskindOf "TANK" and _volObj > 210) then {_rel = -1};
						//-----------------------------------------------------------

						_tope = _topeObj;
						if ("landvehicle" counttype [_obj] > 0) then {_tope = _topeLand};
						if ("ship" counttype [_obj] > 0) then {_tope = _topeSea};
						if ("air" counttype [_obj] > 0) then {_tope = _topeAir};

						if (_rel >= _tope) then
						{
							_tipEslinga = 3;
							if (_volObj < 420) then {_tipEslinga = 3};
							if (_volObj < 220) then {_tipEslinga = 2};
							if (_volObj < 120) then {_tipEslinga = 1};

							_nomObj = getText (configFile >> "CfgVehicles" >> format ["%1", typeOf _obj] >> "displayName");
							_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1 %2", localize "STR_lifter301", _nomObj] + "</t>";
							_icon = "<img size='3.5' shadow=0 color='#FFFF00' image='" + pathlifter + "liftOn.paa'/>";
							_liftOn = _veh addAction [_txt+_icon, pathLifter + "lift.sqf", [_veh, _obj, true, _tipEslinga, _tgt, _UL2], 99, false, true];
							_veh setvariable ["accCatch", _liftOn];
							_veh setvariable ["selObj", _obj];
							_veh setvariable ["antObj", _obj];
							_veh setvariable ["NoselObj", objnull];
							_veh setvariable ["heavy", false];

							//--------------------------------------------------------------
							//--- userAction lift on
							nul = [_veh, _obj, _tipEslinga, _tgt, _UL2] spawn
							{
								private ["_ya"];
								_veh = _this select 0;
								_obj = _this select 1;
								_tipEslinga = _this select 2;
								_tgt = _this select 3;
								_UL2 = _this select 4;
								_ya = false;
								while {(alive player) and isnull (_veh getvariable "NoSelObj") and (_obj == (_veh getvariable "selObj"))} do
								{
									if (inputAction "user10" > 0 and (not _ya)) then
									{
										_ya = true;
										nul = [nil,nil,nil,[_veh, _obj, true, _tipEslinga, _tgt, _UL2]] execVM pathlifter + "lift.sqf";
										sleep 2;
									};
									if ((_veh getvariable "ObjCargo") == _obj) exitWith {};
									sleep 0.10;
								};
							};
							//--------------------------------------------------------------
						}
						else
						{
							_veh setvariable ["NoselObj", _obj];
							_veh setvariable ["heavy", true];
						};
					};
				} else {_retira2 = true};
			} else {_retira2 = true};
		} else {_retira2 = true};
	};

	if (_retira2) then
	{
		if ((_veh getvariable "accCatch") != -1) then
		{
			_veh removeaction (_veh getvariable "accCatch");
			_veh setvariable ["SelObj", objnull];
		};
		_veh setvariable ["heavy", false];
		_veh setvariable ["antObj", objNull];
		_avisa = false;
	};

	if (_veh getvariable "lift") then
	{
		if (not _avisa2) then
		{
			_avisa2 = true;
			_nomObj = getText (configFile >> "CfgVehicles" >> format ["%1", typeOf _obj] >> "displayName");

			_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1 %2", localize "STR_lifter302", _nomObj] + "</t>";
			_icon = "<img size='3.5' shadow=0 color='#FFFF00' image='" + pathlifter + "liftOff.paa'/>";
			_liftOff = _veh addAction [_txt+_icon, pathLifter + "lift.sqf", [_veh, _obj, false, 0, _tgt, _UL2], 99, false, true];
			_veh setvariable ["accCatch", _liftOff];

			//--------------------------------------------------------------
			//--- userAction lift off
			nul = [_veh, _obj, _tgt, _UL2] spawn
			{
				private ["_vel","_up","_ya"];
				_veh = _this select 0;
				_obj = _this select 1;
				_tgt = _this select 2;
				_UL2 = _this select 3;
				waituntil {inputAction "user10" == 0};
				_ya = false;
				while {(alive player) and (player == (driver _veh)) and (_veh getvariable "lift")} do
				{
					//--- Tecla para lift instantaneo
					if (inputAction "user10" > 0 and (not _ya)) then
					{
						_ya = true;
						nul = [nil,nil,nil,[_veh, _obj, false, 0, _tgt, _UL2]] execVM pathlifter + "lift.sqf";
						sleep 2;
					};
					if (isnull (_veh getvariable "ObjCargo")) exitWith {};

					//--- Carga debajo de nivel suelo
					if ((getpos _obj) select 2 <= 0.00) then
					{
						_vel = velocity _veh;
						_up = true;
						if ((_vel select 2) < 0) then
						{
							if (surfaceIsWater (getposASL _obj) and (abs((getposASL _obj select 2) - (getpos _obj select 2)) < 1)) then {_up = false};
							if (_up) then {_veh setvelocity [_vel select 0, _vel select 1, (abs(_vel select 2)) * 1.2]};
						};
					};
					sleep 0.10;
				};
			};
			//--------------------------------------------------------------
		};
		_altobj = _veh getvariable "objAlt";
		_obj = _veh getvariable "selObj";
		hintsilent format ["%1: %2", localize "STR_lifter310", (getpos _obj) select 2];
	}
	else
	{
		if (_avisa2) then
		{
			_veh removeAction (_veh getvariable "accDrop");
			_veh removeAction (_veh getvariable "accCut");
			_avisa2 = false;
		};

		if (not isnull (_veh getvariable "eslinga2")) then
		{
			if (isnull (_veh getvariable "objCargo")) then
			{
				_anclaje = getpos _UL2;
				hintsilent format ["%1: %2", localize "STR_lifter310", _anclaje select 2];
			};
		} else {hintsilent ""};
	};
	_accIAant = _veh getvariable "accIA";

	//--- Control Camara ----------------------------------------------------------------------------------------
	_cameraOn = _veh getvariable "CameraOn";
	if (not isnil "_cameraOn") then
	{
		if (not _camActive) then
		{
			_camActive = true;
			rav_cameraOn = [_veh, _datCam, _UL, _cualRender] spawn
			{
				private ["_cam","_monitor","_stateCam","_mode","_name","_visionMode","_aborta",
					"_hayCam","_mm","_selAnt","_antTarget","_pathPic"];
				_veh = _this select 0;
				_datCam = _this select 1;
				_UL = _this select 2;
				_cualRender = _this select 3;

				fnc_GET_PITCH_BANK =
				{
					private ["_obj","_pitch","_bank","_yaw","_vdir","_vup","_sign"];

					_obj = _veh;
					_yaw = getdir _obj;
					_vdir = vectordir _obj;
					_vdir = [_vdir, _yaw] call BIS_fnc_rotateVector2D;
					_pitch = atan ((_vdir select 2) / (_vdir select 1));
					_vup = vectorup _obj;
					_vup = [_vup, _yaw] call BIS_fnc_rotateVector2D;
					_bank = atan ((_vup select 0) / (_vup select 2));
					if((_vup select 2) < 0) then
					{
						_sign = [1,-1] select (_bank < 0);
						_bank = _bank - _sign*180;
					};
					[_pitch, _bank];
				};

				fnc_RESET =
				{
					_monitor = _this select 0;
					_cam = _this select 1;
					_cam cameraEffect ["TERMINATE", "BACK"];
					camDestroy _cam;
					sleep 0.5;
					_monitor setObjectTexture [1,""];
					_monitor setObjectTexture [3,""];
					_monitor setObjectTexture [4,""];
					_monitor setObjectTexture [0,pathLifter + "negro.paa"];
				};

				fnc_RENDER =
				{
					private ["_pitch_bank"];

					_monitor =_this select 0;
					_name =_this select 1;
					_cam =_this select 2;
					_visionMode =_this select 3;
					_UL =_this select 4;

					//player globalchat format ["pitch: %1   Bank: %2",(_pitch_bank select 0),(_pitch_bank select 1)];
					//					_pitch_bank = [_veh] call fnc_GET_PITCH_BANK;
					//					_cam camSetDive (_pitch_bank select 0);
					//					_cam camSetBank (_pitch_bank select 1);

					_name setPiPEffect [_visionMode];
					_monitor setObjectTexture [0,(format ["#(argb,256,256,1)r2t(%1,1.0)",_name])];
				};

				_monitor = "LCD_lifter" createvehiclelocal [0,0,0];
				_monitor setObjectTexture [0,pathLifter + "negro.paa"];
				_monitor setObjectTexture [1,""];
				_monitor setObjectTexture [2,""];
				_monitor setObjectTexture [3,""];
				_monitor setObjectTexture [4,""];
				_monitor setObjectTexture [5,""];
				_monitor attachTo [_veh, _datCam select 0]; _monitor setdir 180;
				_veh setvariable ["RAV_lcd", _monitor];
				sleep 1;
				_monitor setObjectTexture [0,pathLifter + "ajuste.paa"];
				sleep 0.5;
				if (not isPipEnabled) then
				{
					_monitor setObjectTexture [0,pathLifter + "noPip.paa"];
					sleep 5;
					_veh setvariable ["CameraOn", nil];
					_veh setvariable ["RAV_lcd", nil];
					deletevehicle _monitor;
				}
				else
				{
					_name = format ["rendertarget%1",_cualRender];
					_cam = "camera" camCreate [0,0,0];
					_cam attachto [_veh,_datCam select 1];
					_cam camSetTarget _UL;
					_cam camSetFov 0.85;
					_cam cameraEffect ["INTERNAL", "BACK",_name];
					_cam camCommit 0;

					_stateCam = cameraView;
					_mode = 0; // 0: normal 1: nightvision 2: termal 3: Correction Color 4: Mirror
					_aborta = false;
					_veh setvariable ["modeCam",_mode];
					_selAnt = objnull;
					_monitor setObjectTexture [1,pathLifter + "NoLift.paa"];
					_monitor setObjectTexture [3,pathLifter + "0.paa"];

					_antTarget = objnull;
					while {not _aborta} do
					{
						_hayCam = _veh getvariable "CameraOn";
						if (isnil "_hayCam") then {_aborta = true};
						if (isnull (driver _veh)) then {_aborta = true};
						if (((position _veh) select 2) < 2.00) then {_aborta = true};

						if (not (_veh getvariable "lift")) then
						{
							if (((_veh getvariable "antObj")) != _selAnt) then
							{
								if (not isnull (_veh getvariable "antObj")) then
								{
									_pathPic = getText (configFile >> "CfgVehicles" >> format["%1",typeOf (_veh getvariable "antObj")] >> "picture");
									_monitor setObjectTexture [2,pathLifter + "SelLift.paa"];
									_monitor setObjectTexture [1,pathLifter + "SiLift.paa"];
									if (not(toUpper(_pathPic) in ["PICTURETHING","PICTURESTATICOBJECT"])) then {_monitor setObjectTexture [4,_pathPic]};
								}
								else
								{
									_monitor setObjectTexture [2,""];
									_monitor setObjectTexture [4,""];
									_monitor setObjectTexture [5,""];
									_monitor setObjectTexture [1,pathLifter + "NoLift.paa"];
								};
								_selAnt = (_veh getvariable "antObj");
							};
							if (_veh getvariable "Heavy") then
							{
								_monitor setObjectTexture [5,pathLifter + "heavy.paa"];
							} else {_monitor setObjectTexture [5,""]};

						}
						else
						{
							_monitor setObjectTexture [1,""];
							_monitor setObjectTexture [5,""];
						};

						if (cameraView != _stateCam) then
						{
							if (cameraView == "INTERNAL") then {_monitor hideObject false} else {_monitor hideObject true};
							_stateCam = cameraView;
						};
						_mm = _veh getvariable "modeCam";
						if (_mm != _mode) then
						{
							_mode = _mm;
							switch (_mode) do
							{
								case 0: {_monitor setObjectTexture [3,pathLifter + "0.paa"]};
								case 1: {_monitor setObjectTexture [3,pathLifter + "1.paa"]};
								case 2: {_monitor setObjectTexture [3,pathLifter + "2.paa"]};
							};
						};

						_cam camSetTarget _UL;
						_cam camCommit 0;

						nul =[_monitor,_name,_cam,_mode,_UL] call fnc_RENDER;
						sleep 0.005;
					};
					nul =[_monitor, _cam] call fnc_RESET;
					deletevehicle _monitor;
					_veh setvariable ["CameraOn", nil];
					_veh setvariable ["RAV_lcd", nil];
				};
			};
		};
	}
	else
	{
		if (_camActive) then {_camActive = false};
	};

	sleep 0.5;
};

_veh setvariable ["lifter", false, true];
_veh removeaction (_veh getvariable "accDeploy");
_veh removeaction (_veh getvariable "accCatch");
_veh removeaction (_veh getvariable "accDrop");
_veh setvariable ["antObj", objNull];
_veh setvariable ["accDeploy", -1];
_veh setvariable ["eslinga2", objnull];
_display displayRemoveEventHandler ["KeyDown", _handDisplay];

if (not(alive _veh)) then
{
	if (_veh getvariable "lift") then
	{
		null = [false,false,false,[_veh, _obj]] execVM pathLifter + "CutRopes.sqf";
	};

	if ((_veh getvariable "accDeploy") != -1) then
	{
		null = [false,false,false,[_veh, _veh getvariable "eslinga2",_UL2]] execVM pathLifter + "FreeRopes.sqf";
	};

	if (count _datCrane > 0) then
	{
		deletevehicle _crane;
		_veh removeAction _gruaOn;
		_veh removeAction _gruaOff;
	};
};