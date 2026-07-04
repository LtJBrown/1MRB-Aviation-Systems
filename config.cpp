////////////////////////////////////////////////////////////////////
//DeRap: config.bin
//Produced from mikero's Dos Tools Dll version 10.21
//https://mikero.bytex.digital/Downloads
//'now' is Sun Jun 21 12:39:48 2026 : 'file' last modified on Sun Mar 21 08:28:28 2021
////////////////////////////////////////////////////////////////////

#define _ARMA_

class BIS_AddonInfo
{
	author = "RAVEN";
	timepacked = "1545739483";
};
class CfgPatches
{
	class RAV_Lifter_A3
	{
		units[] = {"Eslinga","Eslinga_L","Eslinga_M","Eslinga_P","Eslinga_0","LCD_lifter","RAV_Ladder","RAV_fastrope","RAV_fastrope_suelta","Crane"};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"Extended_EventHandlers","CBA_main"};
		author = "RAVEN";
		authorUrl = "http://forums.bistudio.com/showthread.php?173483-LIFTER-for-ArmA-3";
	};
};
class CfgFunctions
{
	class p
	{
		class aceaction
		{
			file = "\RAV_LIFTER_A3";
			class aceaction{};
			class preInitClient_ROP
			{
				preInit = 1;
			};
		};
	};
};
class CfgVehicleClasses
{
	class RAV_Objects
	{
		displayName = "$STR_Class00";
	};
};
class CfgMovesBasic
{
	class DefaultDie;
	class ManActions
	{
		RAV_fastrope = "RAV_fastrope";
		RAV_naufrago = "RAV_naufrago";
	};
};
class CfgMovesMaleSdr: CfgMovesBasic
{
	class States
	{
		class Crew;
		class RAV_fastrope: Crew
		{
			file = "\RAV_LIFTER_A3\RAV_fastrope.rtm";
			interpolateFrom[] = {};
			interpolateTo[] = {};
		};
		class RAV_naufrago: Crew
		{
			file = "\RAV_LIFTER_A3\rav_naufrago.rtm";
			interpolateFrom[] = {};
			interpolateTo[] = {};
		};
	};
};
class CfgVehicles
{
	class All{};
	class Logic: All{};
	class RAV_Lifter_A3: Logic
	{
		displayName = "$STR_lifter300";
		icon = "\RAV_lifter_A3\icono.paa";
		picture = "\RAV_lifter_A3\icono.paa";
		vehicleClass = "Modules";
		mapsize = 30;
		class Eventhandlers
		{
			init = "null = _this execVM ""\RAV_lifter_A3\setup.sqf"";";
		};
	};
	class RoadCone_L_F;
	class Eslinga: RoadCone_L_F
	{
		scope = 1;
		vehicleClass = "RAV_Objects";
		model = "\RAV_lifter_A3\Eslinga.p3d";
		displayName = "Eslinga Suelta";
		destructype = "Destructno";
		cost = 0;
		armor = 999999;
		tipoEslinga = 1;
		eslinga = 1;
		animated = 1;
		class Animationsources
		{
			class adelante_atras
			{
				source = "user";
				animPeriod = 0.001;
				initPhase = 0.5;
			};
			class derecha_izquierda
			{
				source = "user";
				animPeriod = 0.001;
				initPhase = 0.5;
			};
		};
	};
	class Eslinga_L: Eslinga
	{
		displayName = "Eslinga ligera";
		model = "\RAV_lifter_A3\Eslinga_L.p3d";
		hiddenSelections[] = {"0","1"};
		tipoEslinga = 2;
		animated = 1;
		class Animationsources
		{
			class Abre1
			{
				source = "user";
				animPeriod = 1e-05;
				initPhase = 0;
			};
			class Abre2
			{
				source = "user";
				animPeriod = 1e-05;
				initPhase = 0;
			};
			class Cae
			{
				source = "user";
				animPeriod = 0.35;
				initPhase = 0;
			};
		};
	};
	class Eslinga_M: Eslinga_L
	{
		model = "\RAV_lifter_A3\Eslinga_M.p3d";
		displayName = "Eslinga Mediana";
		tipoEslinga = 3;
		eslinga = 1;
		animated = 0;
	};
	class Eslinga_P: Eslinga_L
	{
		model = "\RAV_lifter_A3\Eslinga_P.p3d";
		displayName = "Eslinga Pesada";
		tipoEslinga = 4;
		eslinga = 1;
		animated = 0;
	};
	class Eslinga_0: Eslinga
	{
		model = "\RAV_lifter_A3\Eslinga_0.p3d";
		displayName = "Eslinga para reponer";
		tipoEslinga = 5;
		eslinga = 1;
		animated = 0;
	};
	class LCD_lifter: Eslinga
	{
		model = "\RAV_lifter_A3\LCD_lifter.p3d";
		displayName = "Display LCD (lifter)";
		hiddenSelections[] = {"0","1","2","3","4","5"};
	};
	class RAV_ladder: RoadCone_L_F
	{
		animated = 1;
		vehicleClass = "RAV_Objects";
		displayName = "Escalerilla";
		model = "\RAV_lifter_A3\ladder.p3d";
		tipoEslinga = 0;
		class Animationsources
		{
			class sube
			{
				source = "user";
				animPeriod = 5;
				initPhase = 0.5;
			};
		};
	};
	class RAV_fastrope: RoadCone_L_F
	{
		animated = 1;
		vehicleClass = "RAV_Objects";
		displayName = "cuerda rapida";
		model = "\RAV_lifter_A3\fast_rope.p3d";
		hiddenSelections[] = {"0","1","2","3","4","5"};
		tipoEslinga = 0;
		class Animationsources
		{
			class aju_altura
			{
				source = "user";
				animPeriod = 0.0001;
				initPhase = 0;
			};
			class bajando1
			{
				source = "user";
				animPeriod = 5;
				initPhase = 0;
			};
			class bajando2
			{
				source = "user";
				animPeriod = 5;
				initPhase = 0;
			};
			class suelta
			{
				source = "user";
				animPeriod = 2;
				initPhase = 0;
			};
			class despliega
			{
				source = "user";
				animPeriod = 2;
				initPhase = 0;
			};
			class ladea
			{
				source = "user";
				animPeriod = 1;
				initPhase = 0;
			};
			class voltea
			{
				source = "user";
				animPeriod = 3;
				initPhase = 0;
			};
		};
	};
	class RAV_fastrope_suelta: RoadCone_L_F
	{
		vehicleClass = "RAV_Objects";
		displayName = "cuerda rapida suelta";
		model = "\RAV_lifter_A3\fast_rope_suelta.p3d";
		tipoEslinga = 0;
		eslinga = 1;
	};
	class Crane: RoadCone_L_F
	{
		scope = 1;
		animated = 1;
		vehicleClass = "RAV_Objects";
		model = "\RAV_lifter_A3\Crane.p3d";
		displayName = "$STR_lifter400";
		destructype = "Destructno";
		cost = 0;
		armor = 999999;
		class Animationsources
		{
			class hitchDown
			{
				animPeriod = 10;
				initPhase = 0;
			};
		};
		class Eventhandlers{};
	};
	class RAV_altimetro: RoadCone_L_F
	{
		scope = 1;
		animated = 0;
		vehicleClass = "RAV_Objects";
		model = "\RAV_lifter_A3\altimetro.p3d";
		displayName = "Altimetro";
		destructype = "Destructno";
		cost = 0;
		armor = 99999999;
	};
};
class Extended_Init_EventHandlers
{
	class Man
	{
		lifter3_1 = "_dummy = (_this select 0) execVM '\RAV_Lifter_A3\InitMan.sqf';";
	};
	class helicopter
	{
		lifter3_2 = "if (isServer) then {_dummy = [(_this select 0)] execVM '\RAV_Lifter_A3\Init_FastRope.sqf'};";
	};
	class plane
	{
		lifter3_3 = "if (isServer and (typeOf (_this select 0) in ['MV22','USAF_CV22'])) then {_dummy = [(_this select 0)] execVM '\RAV_Lifter_A3\Init_FastRope.sqf'};";
	};
};
class CfgSounds
{
	sounds[] = {"rav_snd_drop_obj","rav_snd_drop_veh","rav_snd_drop_splash","fastropeEnd","fastropeloop"};
	class rav_snd_drop_obj
	{
		name = "rav_snd_crash1";
		sound[] = {"\RAV_LIFTER_A3\Sound\dropObj.ogg",3,1};
		titles[] = {};
	};
	class rav_snd_drop_veh
	{
		name = "rav_snd_drop_veh";
		sound[] = {"\RAV_LIFTER_A3\Sound\dropVeh.ogg",3,1};
		titles[] = {};
	};
	class rav_snd_drop_splash
	{
		name = "rav_snd_drop_splash";
		sound[] = {"\RAV_LIFTER_A3\Sound\splash.ogg",3,1};
		titles[] = {};
	};
	class fastropeloop
	{
		name = "fastropeloop";
		sound[] = {"\RAV_LIFTER_A3\Sound\fastropeloop.ogg",1,0.5};
		titles[] = {};
	};
	class fastropeEnd
	{
		name = "fastropeEnd";
		sound[] = {"\RAV_LIFTER_A3\Sound\fastropeEnd.ogg",1,1};
		titles[] = {};
	};
};
class cfgMods
{
	author = "piko";
	timepacked = "1616362108";
};
