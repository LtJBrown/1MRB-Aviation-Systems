private ["_cameraOn","_modeCam"];
_shift = _this select 0;

if (not _shift) then
{
	if ((position (vehicle player) select 2) > 2) then
	{
		_cameraOn = (vehicle player) getvariable "CameraOn";
		if isnil("_cameraOn") then {(vehicle player) setvariable ["CameraOn", true]} else {(vehicle player) setvariable ["CameraOn", nil]};
	};
}
else
{
	_modeCam = (vehicle player) getvariable "modeCam";
	if (not (isnil "_modeCam")) then
	{
		_modeCam = _modeCam + 1;
		if (_modeCam > 2) then {_modeCam = 0};
		(vehicle player) setvariable ["modeCam", _modeCam];
	};
};
