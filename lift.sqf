// *******************************************************************************
// **       Funcion: Lift.sqf
// **   Descripcion: Levanta carga
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_veh","_obj","_ajus","_modo","_TipEslinga","_eslinga","_cable","_dif","_ajuAper","_md",
	"_plataforma","_dd","_altobj","_altfinal","_tgt","_cx","_cy","_cz","_center","_excepcion",
	"_reduc","_Obx","_Oby","_Obz","_pp","_point","_txt","_icon","_ropes","_aper","_UL2","_peque",
	"_dtV","_anch","_lng","_dim","_tiptip","_isLadder","_posLadder","_ladderOn","_ajuGenerico"];

_veh  = (_this select 3) select 0;
_obj  = (_this select 3) select 1;
_modo = (_this select 3) select 2;
_tgt  = (_this select 3) select 4;
_UL2  = (_this select 3) select 5;

_tiptip = toUpper(typeOf _veh);

if (_modo) then
{
	if (count (_this select 3) > 3) then {_TipEslinga = (_this select 3) select 3} else {_tipEslinga = 0};
};

_ajus = 0; _ajuAper = 1; _isLadder = 0;
if (_tiptip isKindOf "KYO_MH47E_HELI_BASE") then {_isLadder = 1; _posLadder = [0,0.75, -4.60]};
if (_tiptip in ["CH_147F","CH_47_F"]) then {_isLadder = 1; _posLadder = [0, -1.05, -5.40]};
if (_tiptip in ["CH_47F"]) then {_isLadder = 1; _posLadder = [0, -0.95, -5.85]};

if (_modo) then
{
	//##############################################################################
	_obj setvariable ["GeoObject", nil];
	//##############################################################################
	_center = _obj getvariable "GeoObject";
	if (not isnil("_center")) then
	{
		_Obx = (_center select 0);
		_Oby = (_center select 1);
		_Obz = (_center select 2);
	}
	else
	{
		_Obx = 0;
		_Oby = 0;
		_Obz = (((boundingCenter _obj) select 2) * (-1)) + 0.50;
	};

	_ajuGenerico = true;
	//--------------------------------------------------------------------------------------------
	//--- Ajustes especiales de GeoObject por VEHICLE
	//--------------------------------------------------------------------------------------------
	//--- Land
	if (toUpper (typeOf _obj) == "O_APC_WHEELED_02_RCWS_F") then {_Oby = _Oby + 1.0};
	if (toUpper (typeOf _obj) in ["O_MRAP_02_HMG_F","O_MRAP_02_GMG_F","O_MRAP_02_F"]) then {_Oby = _Oby + 1.5; _Obz = _Obz - 0.3};
	if (toUpper (typeOf _obj) in ["C_VAN_01_BOX_F","C_VAN_01_FUEL_F","C_VAN_01_TRANSPORT_F"]) then {_Oby = _Oby + 1.0; _Obz = _Obz + 1.0};
	if (toUpper (typeOf _obj) in ["RC_HMMWV"]) then {_Oby = _Oby + 0.2; _Obz = _Obz + 0.5; _ajuAper = 0.6};
	if (toUpper (typeOf _obj) in ["M1114_AGS_ACR","HMMWV_M1151_M2"]) then {_Oby = _Oby + 0.25; _Obz = _Obz + 1.5};
	if (toUpper (typeOf _obj) in ["NATO_STRIDER"]) then {_Oby = _Oby + 0.30; _Obz = _Obz + 0.9};
	if (toUpper (typeOf _obj) in ["HUNTER_TACOPS_D","HUNTER2_TACOPS_D"]) then {_Oby = _Oby + 0; _Obz = _Obz + 1.0};
	if (toUpper (typeOf _obj) in ["STRIDER1_TACOPS_D"]) then {_Oby = _Oby + 0; _Obz = _Obz + 1.0};
	if (_obj isKindOf "HMMWV_BASE") then {_Oby = _Oby + 0.25; _Obz = _Obz - 0.5};
	if (_obj isKindOf "B_MRAP_01_F") then {_Oby = _Oby + 1.5; _Obz = _Obz + 0.7};
	if (_obj isKindOf "BAF_JACKAL2_BASE_D") then {_Obx = _Obx + 0.15; _Obz = _Obz + 0.7};
	if (_obj isKindOf "MRAP_02_BASE_F") then {_Obz = _Obz + 0.5};
	if (_obj isKindOf "BAF_OFFROAD_D") then {_Obz = _Obz + 0.7};
	if (_obj isKindOf "QUADBIKE_01_BASE_F") then {_Oby = _Oby + 0.1};
	if (_obj isKindOf "GLT_OSHKOSH_BASE") then {_Obz = _Obz + 1.7};
	if (_obj isKindOf "B_MRAP_01_HMG_F") then {_Oby = _Oby + 1.30; _Obz = _Obz + 0.9};
	if (_obj isKindOf "B_MRAP_01_GMG_F") then {_Oby = _Oby + 1.30; _Obz = _Obz + 0.9};
	if (_obj isKindOf "OFFROAD_01_BASE_F") then {_Obz = _Obz + 0.5};
	if (_obj isKindOf "GLT_FENNEK_BASE") then {_Obz = _Obz + 0.5};
	if (_obj isKindOf "I_APC_WHEELED_03_CANNON_F") then {_Obx = _Obx - 0.5};
	if (_obj isKindOf "I_MRAP_03_HMG_F") then {_Obz = _Obz + 0.7};
	if (_obj isKindOf "I_MRAP_03_F") then {_Oby = _Oby + 0.5; _Obz = _Obz + 1.25};
	if (_obj isKindOf "I_G_VAN_01_TRANSPORT_F") then {_Oby = _Oby + 0.2; _Obz = _Obz + 1.0};
	if (_obj isKindOf "I_UGV_01_F") then {_Obx = _Obx - 0.5; _Obz = _Obz + 0.7};
	if (_obj isKindOf "B_UGV_01_F") then {_Obx = _Obx - 0.5; _Obz = _Obz + 0.7};
	if (_obj isKindOf "I_UGV_01_RCWS_F") then {_Obx = _Obx - 0.5; _Obz = _Obz + 0.7};
	if (_obj isKindOf "B_UGV_01_RCWS_F") then {_Obx = _Obx - 0.5; _Obz = _Obz + 0.7};
	if (_obj isKindOf "UAV_02_CAS_BASE_F") then {_Oby = _Oby - 0.2; _Obz = _Obz - 0.4};
	if (_obj isKindOf "UAV_02_BASE_F") then {_Oby = _Oby - 0.2; _Obz = _Obz - 0.4};
	if (_obj isKindOf "STATICWEAPON") then {_Oby = _Oby + 1.0; _Obz = _Obz + 1.1};
	if (_obj isKindOf "RDS_BMP1_AAF_BASE") then {_Obz = _Obz + 1.5};
	if (_obj isKindOf "RDS_BMP2_AAF_01") then {_Obz = _Obz + 0.5};
	if (_obj isKindOf "UIM_MRAP_F") then {_Obz = _Obz + 0.5};
	if (_obj isKindOf "C_MAS_AFR_TRUCK_02_REFUEL_F") then {_Oby = _Oby + 1.0};
	if (_obj isKindOf "KAE_UAZ_469_OPEN_SZ") then {_Oby = _Oby + 0.5; _Obz = _Obz - 0.5};
	if (_obj isKindOf "DAR_MTVRBASE") then {_Obz = _Obz + 1.5};
	if (_obj isKindOf "DAR_HMMWV_BASE") then {_Obz = _Obz + 1.0};
	if (_obj isKindOf "TRUCK_02_BASE_F") then {_Oby = _Oby + 1.0; _Obz = _Obz + 1.2};
	if (_obj isKindOf "TRUCK_03_BASE_F") then {_Oby = _Oby + 1.0; _Obz = _Obz + 1.2};
	if (_obj isKindOf "CARGO_BASE_F") then {_Obz = _Obz + 2.00};
	if (_obj isKindOf "CHA_LAV25_HQ") then {_Obx = _Obx - 0.15; _Obz = _Obz + 1};

	//--- Sea
	if ("ship" counttype [_obj] > 0) then {_Obz = _Obz - 0.70};
	if (toUpper (typeOf _obj) in ["B_SDV_01_F","I_SDV_01_F","O_SDV_01_F"]) then {_Oby = _Oby + 1.15};
	if (toUpper (typeOf _obj) in ["B_BOAT_ARMED_01_MINIGUN_F","I_BOAT_ARMED_01_MINIGUN_F","B_BOAT_ARMED_UIM_MINIGUN_F"]) then {_Oby = _Oby - 1.00; _isLadder = _isLadder + 1};

	//---Wreck
	if (toUpper (typeOf _obj) in ["UH60_WRECK_EP1"]) then {_Obx = _Obx - 0.40, _Oby = _Oby - 3.50, _Obz = _Obz + 1.00};

	//--- Air
	if (toUpper (typeOf _obj) in ["UH1H"]) then {_Obz = _Obz - 0.80};
	if (toUpper (typeOf _obj) in ["IVORY_T6A_1"]) then {_Oby = _Oby + 1.00; _Obz = _Obz - 0.50};

	//--- Cannon
	if (toUpper (typeOf _obj) in ["RDS_M119_AAF"]) then {_Oby = _Oby - 1.00; _Obz = _Obz - 0.50; _ajuGenerico = false};
	if (toUpper (typeOf _obj) in ["RDS_D30_AAF"]) then {_Oby = _Oby - 1.00; _Obz = _Obz - 0.10; _ajuGenerico = false};

	//--------------------------------------------------------------------------------------------
	//--- Ajustes especiales de GeoObject por CLASE
	//--------------------------------------------------------------------------------------------
	if (("staticWeapon" counttype [_obj] > 0) and _ajuGenerico) then {_Oby = _Oby - 0.5; _Obz = _Obz - 0.6};
	if (("air" counttype [_obj] > 0) and _ajuGenerico) then {_Obz = _Obz + 0.50};
	if (("ship" counttype [_obj] > 0) and _ajuGenerico) then {_Obz = _Obz + 0.20};
	//--------------------------------------------------------------------------------------------

	_obj setvariable ["geoObject", [_Obx, _Oby, _Obz]];
	_center = _obj getvariable "GeoObject";

	if (count (crew _obj) == 0 or ("ship" counttype [_obj] > 0)) then
	{
		_center = _veh getvariable "GeoLifter";
		_cx = (_center select 0);
		_cy = (_center select 1);
		_cz = (_center select 2);

		_dist = (_veh distance _obj) * (-1);

		//--------------------------------------------------------------------
		_excepcion = false; _peque = false;
		_dtV = boundingBoxReal _obj;
		_anch = abs (((_dtV select 1) select 0) - ((_dtV select 0) select 0));
		_lng  = abs (((_dtV select 1) select 1) - ((_dtV select 0) select 1));
		if (_anch > _lng) then {_dim = _anch; _dd = -90} else {_dim = _lng; _dd = 0};
		if (_dim < 5) then {_excepcion = true; _peque = true};
		//--------------------------------------------------------------------

		if ("air" counttype [_obj] > 0) then {_dd = 0};
		if ("landvehicle" counttype [_obj] > 0) then {_dd = 0};
		if ("ship" counttype [_obj] > 0) then {_dd = 0; _excepcion = false};
		if ("staticCannon" counttype [_obj] > 0) then {_dd = 0; _excepcion = true};

		_veh removeAction (_veh getvariable "accFree");
		_veh removeAction (_veh getvariable "accCatch");
		_veh setvariable ["accCatch", -1];

		deletevehicle (_veh getvariable "eslinga2");
		_veh setvariable ["eslinga2", objnull];

		//--- Eslinga ligera SOLO para clase "air"
		if ("air" counttype [_obj] > 0) then {_tipEslinga = 1};
		if ("motorcycle" counttype [_obj] > 0) then {_tipEslinga = 1};

		switch (_tipEslinga) do
		{
			case 1:
			{
				if (not(_veh getvariable "lift")) then
				{
					_cable = "Eslinga_L" createvehicle [0,0,0];
					_cable setObjectTextureGlobal  [1,"\rav_lifter_a3\soga.paa"];

					if (not _excepcion) then
					{
						_cable setObjectTextureGlobal  [0,""];
						_aper = (sizeOf (typeOf _obj)) / 8;
						if (_aper > 2) then {_aper = 2};
						if (_aper > 0.6) then
						{
							if ("air" counttype [_obj] > 0) then
							{
								_aper = _aper * 0.5; _Oby = _Oby - (_aper * 1);
							};
							_aper = ((_aper * _ajuAper) * 1) / 2;
							{_cable animate [_x, _aper]} foreach ["abre1","abre2"];
						};
					}
					else
					{
						if ("car" counttype [_obj] > 0) then
						{
							_cable setObjectTextureGlobal  [0,""];
							_obz = _obz + 0.5;
						} else {_cable setObjectTextureGlobal  [0, pathLifter + "metal8.paa"]};
					};

					_cable attachto [_veh, [_cx+0,_cy+2,_cz+(-4.5)]]; _cable setdir 0;
				};
				_reduc = 1.0025;
			};
			case 2:
			{
				if (not(_veh getvariable "lift")) then
				{
					_cable = "Eslinga_M" createvehicle [0,0,0];
					_cable setObjectTextureGlobal  [1,"\rav_lifter_a3\soga.paa"];
					_cable attachto [_veh, [_cx+0,_cy+1,_cz+(-4.90)]]; _cable setdir 0;
				};
				_reduc = 1.0050;
			};
			case 3:
			{
				if (not(_veh getvariable "lift")) then
				{
					_cable = "Eslinga_P" createvehicle [0,0,0];
					_cable setObjectTextureGlobal  [1,"\rav_lifter_a3\soga.paa"];
					_cable attachto [_veh, [_cx+0,_cy+1,_cz+(-4.5)]]; _cable setdir 0;
				};
				_reduc = 1.0050;
			};
		};

		//--- Modo de enganche (a la eslinga o al helicoptero)
		_md = false;
		_veh setvariable ["eslinga", _cable];
		if (_md) then
		{
			_point = _cable selectionposition "anclaje";
			_point set [0, (_point select 0) + _Obx];
			_point set [1, (_point select 1) + _Oby];
			_point set [2, (_point select 2) - _Obz];
			_obj attachTo [_cable, _point];
		}
		else
		{
			_pp = _cable selectionposition "anclaje";
			_point = _veh worldToModel (_cable modelToWorld _pp);
			_point set [0, (_point select 0) + _Obx];
			_point set [1, (_point select 1) + _Oby];
			_point set [2, (_point select 2) - _Obz];
			_obj attachTo [_veh, _point];
		};
		_obj setdir _dd; _obj setpos getpos _obj;

		detach _UL2; _UL2 setpos [0,0,0];
		_veh setvariable ["lift", true];
		_veh setvariable ["objAlt", ((_obj modeltoworld [0,0,0]) select 2)];
		_veh setvariable ["ObjCargo", _obj];
		_veh vehicleChat localize "STR_lifter303";
		if ("ship" counttype [_obj] == 0) then
		{
			[[[_obj, true],pathlifter+"lock.sqf",_obj],"BIS_fnc_execVM",true,true] spawn BIS_fnc_MP;
		};

		//--- Almacena dammage actual de objeto para restaurar al liberar
		_obj setvariable ["damageOri", (damage _obj), true];

		null = [_veh, _cable, _obj] execVM pathLifter + "physRopes.sqf";

		//--- Escalera helo a bote de asalto
		if (_isLadder == 2) then
		{
			[[[_veh, _obj, _posLadder],pathlifter+"initLadder.sqf"],"BIS_fnc_execVM",true,true] spawn BIS_fnc_MP;
			waitUntil {not (_veh getvariable "lift")};
		};

		//null = [_veh, _reduc] execVM pathLifter + "LimitSpeed.sqf";
	}
	else
	{
		_veh vehiclechat localize "STR_lifter305";
		{_x vehiclechat localize "STR_lifter305"} foreach (crew _obj);
	};
}
else
{
	_obj = _veh getvariable "selObj";
	_altobj = _veh getvariable "objAlt";

	_veh setvariable ["lift", false];
	_veh setvariable ["objAlt", 0.00];
	_veh setvariable ["ObjCargo", objnull];
	_veh setvariable ["antObj", objNull];
	_veh setvariable ["NoselObj", objnull];
	_veh vehicleChat localize "STR_lifter304";

	_ropes = _veh getvariable "eslinga";
	detach _UL2; _UL2 setpos [0,0,0];
	_veh setvariable ["eslinga2", objnull];
	_veh setvariable ["eslinga", objnull];

	_veh removeaction (_veh getvariable "accCut");
	_veh setvariable ["accCut", -1];

	_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1", localize "STR_lifter307"] + "</t>";
	_icon = "<img size='3.5' shadow=0 color='#FFFF00' image='" + pathlifter + "deploy.paa'/>";
	_BuscaOn = _veh addAction [_txt+_icon, pathLifter + "deployRopes.sqf", [_veh, _tgt, _UL2], 99, false, true, "", "_this in _target and (getpos _target select 2) > 3"];
	_veh setvariable ["accDeploy", _buscaOn];

	//------ Caida libre de objetos sin fisica/gravedad
	[_obj, _ropes, _veh] execVM pathlifter + "Caida.sqf";
	if ("ship" counttype [_obj] == 0) then
	{
		[[[_obj, false],pathlifter+"lock.sqf"],"BIS_fnc_execVM",true,true] spawn BIS_fnc_MP;
	};
	hintsilent "";

	//--- por si es un bote armado
	[[[_veh, _obj, 1],pathlifter+"removeLadderAll.sqf"],"BIS_fnc_execVM",true,true] spawn BIS_fnc_MP;
	sleep 0.5;
	[[[_veh, _obj, 2],pathlifter+"removeLadderAll.sqf"],"BIS_fnc_execVM",true,true] spawn BIS_fnc_MP;
};