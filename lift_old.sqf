// *******************************************************************************
// **       Funcion: Lift.sqf
// **   Descripcion: Levanta carga
// *******************************************************************************
// **         Autor: RAVEN
// *******************************************************************************

private ["_veh","_obj","_ajus","_modo","_TipEslinga","_eslinga","_cable","_dif",
	"_plataforma","_dd","_altobj","_altfinal","_tgt","_cx","_cy","_cz","_center","_excepcion",
	"_reduc","_Obx","_Oby","_Obz","_pp","_point","_txt","_icon","_ropes","_aper","_UL2"];

_veh  = (_this select 3) select 0;
_obj  = (_this select 3) select 1;
_modo = (_this select 3) select 2;
_tgt  = (_this select 3) select 4;
_UL2  = (_this select 3) select 5;

if (_modo) then
{
	if (count (_this select 3) > 3) then {_TipEslinga = (_this select 3) select 3} else {_tipEslinga = 0};
};

_ajus = 0;

if (_modo) then
{
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

		//--------------------------------------------------------------------------------------------
		//--- Ajustes especiales de GeoObject por VEHICLE
		//--------------------------------------------------------------------------------------------
		//--- Land
		if (toUpper (typeOf _obj) == "O_APC_WHEELED_02_RCWS_F") then {_Oby = _Oby + 1.0};
		if (toUpper (typeOf _obj) in ["AAF_D_VEH_APC_CANNON","I_APC_WHEELED_03_CANNON_F"]) then {_Obx = _Obx - 0.5};
		if (toUpper (typeOf _obj) in ["O_MRAP_02_HMG_F","O_MRAP_02_GMG_F","O_MRAP_02_F"]) then {_Oby = _Oby + 1.5; _Obz = _Obz - 0.3};
		if (toUpper (typeOf _obj) in ["B_MRAP_01_F","B_MRAP_01_HMG_F","B_MRAP_01_GMG_F"]) then {_Oby = _Oby + 1.5; _Obz = _Obz - 0.3};
		if (toUpper (typeOf _obj) in ["C_VAN_01_BOX_F","C_VAN_01_FUEL_F","C_VAN_01_TRANSPORT_F"]) then {_Oby = _Oby + 1.0; _Obz = _Obz + 1.0};
		if (toUpper (typeOf _obj) in ["HMMWV","HMMWV_M2","HMMWV_MK19","HMMWV_TOW"]) then {_Oby = _Oby + 0.25; _Obz = _Obz - 0.5};

		//--- Sea
		if ("ship" counttype [_obj] > 0) then {_Obz = _Obz - 0.70};
		if (toUpper (typeOf _obj) in ["B_SDV_01_F","I_SDV_01_F","O_SDV_01_F"]) then {_Oby = _Oby + 1.15};
		if (toUpper (typeOf _obj) in ["B_BOAT_ARMED_01_MINIGUN_F","I_BOAT_ARMED_01_MINIGUN_F"]) then {_Oby = _Oby - 1.00};

		//---Wreck
		if (toUpper (typeOf _obj) in ["UH60_WRECK_EP1"]) then {_Obx = _Obx - 0.40, _Oby = _Oby - 3.50, _Obz = _Obz + 1.00};

		//--------------------------------------------------------------------------------------------
		//--- Ajustes especiales de GeoObject por CLASE
		//--------------------------------------------------------------------------------------------
		if ("staticWeapon" counttype [_obj] > 0) then {_Oby = _Oby - 0.5; _Obz = _Obz - 0.6};
		if ("air" counttype [_obj] > 0) then {_Obz = _Obz + 0.50};

		//--------------------------------------------------------------------------------------------

		_obj setvariable ["geoObject", [_Obx, _Oby, _Obz]];
		_center = _obj getvariable "GeoObject";
	};

	if (count (crew _obj) == 0 or ("ship" counttype [_obj] > 0)) then
	{
		_center = _veh getvariable "GeoLifter";
		_cx = (_center select 0);
		_cy = (_center select 1);
		_cz = (_center select 2);

		_dist = (_veh distance _obj) * (-1);
		_obj attachTo [_veh,[0,0,_dist+_ajus]];
		_dd = (direction _obj) - (direction _veh);

		if ("air" counttype [_obj] > 0) then {_dd = 0};
		if ("ship" counttype [_obj] > 0) then {_dd = 0};
		if ("landvehicle" counttype [_obj] > 0) then {_dd = 0};

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
					_excepcion = false;
					if (("static" counttype [_obj] > 0)) then {_excepcion = true};
					if (("staticWeapon" counttype [_obj] > 0)) then {_excepcion = true};
					if (not _excepcion) then
					{
						_cable setObjectTexture [0,""];
						_aper = (sizeOf (typeOf _obj)) / 8;
						if (_aper > 2) then {_aper = 2};
						if (_aper > 0.5) then
						{
							if ("air" counttype [_obj] > 0) then
							{
								_aper = _aper * 0.5; _Oby = _Oby - (_aper * 1);
							};
							_aper = (_aper * 1) / 2;
							{_cable animate [_x, _aper]} foreach ["abre1","abre2"];
						};
					}
					else {_cable setObjectTexture [0, pathLifter + "metal8.paa"]};

					_cable attachto [_veh, [_cx+0,_cy+2,_cz+(-4.5)]]; _cable setdir 0;
					if ("static" counttype [_obj] == 0) then {_Obz = _Obz + 0.5};
				};
				_reduc = 1.0025;
			};
			case 2:
			{
				if (not(_veh getvariable "lift")) then
				{
					_cable = "Eslinga_M" createvehicle [0,0,0];
					_cable attachto [_veh, [_cx+0,_cy+1,_cz+(-4.90)]]; _cable setdir 0;
				};
				_reduc = 1.0050;
			};
			case 3:
			{
				if (not(_veh getvariable "lift")) then
				{
					_cable = "Eslinga_P" createvehicle [0,0,0];
					_cable attachto [_veh, [_cx+0,_cy+1,_cz+(-4.5)]]; _cable setdir 0;
				};
				_reduc = 1.0050;
			};
		};
		_veh setvariable ["eslinga", _cable];
		_pp = _cable selectionposition "anclaje";
		_point = _veh worldToModel (_cable modelToWorld _pp);
		_point set [0, (_point select 0) + _Obx];
		_point set [1, (_point select 1) + _Oby];
		_point set [2, (_point select 2) - _Obz];
		_obj attachTo [_veh, _point];
		_obj setdir _dd; _obj setpos getpos _obj;

		detach _UL2; _UL2 setpos [0,0,0];
		_veh setvariable ["lift", true];
		_veh setvariable ["objAlt", ((_obj modeltoworld [0,0,0]) select 2)];
		_veh setvariable ["ObjCargo", _obj];
		_veh vehicleChat localize "STR_lifter303";
		_obj lock true;

		waitUntil {isnull(_veh getvariable "eslinga2")};

//		null = [_veh, _reduc] execVM pathLifter + "LimitSpeed.sqf";
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
	_veh vehicleChat localize "STR_lifter304";

	_ropes = _veh getvariable "eslinga";
	detach _UL2; _UL2 setpos [0,0,0];
	_veh setvariable ["eslinga2", objnull];
	_veh setvariable ["eslinga", objnull];

	_veh removeaction (_veh getvariable "accCut");
	_veh setvariable ["accCut", -1];

	_txt = "<t color='#FFFF00' size='1.2'>" + format ["%1", localize "STR_lifter307"] + "</t>";
	_icon = "<img size='3.5' shadow=0 color='#FFFF00' image='" + pathlifter + "deploy.paa'/>";
	_BuscaOn = _veh addAction [_txt+_icon, pathLifter + "deployRopes.sqf", [_veh, _tgt, _UL2], 99, false, true, "", "_this in _target and (getpos _target select 2) > 5"];
	_veh setvariable ["accDeploy", _buscaOn];

	//------ Caida libre de objetos sin fisica/gravedad
	[_obj,_ropes] execVM pathlifter + "Caida.sqf";
	_obj lock false;
	hintsilent "";
};