_condition = {
    true
};
_statement = {
    params ["_target", "_player", "_params"];
    
};
_insertChildren = {
    params ["_target", "_player", "_params"];
   
    private _actions = [];
  
        private _childStatement_ropdown = 
        {   
            params ["_target", "_player", "_params"];

                _tiptip = toUpper(typeOf _target);
                fnc_RAV_chkHelo = compile loadFile (pathlifter+ "chkHelo.sqf");
	            _datHelo = [_tiptip] call fnc_RAV_chkHelo;
	            _datFastRopes = _datHelo select 3;
               
             
                [[[_target,_player,_datFastRopes],(pathlifter+"fastRopeOn2.sqf"),false],"BIS_fnc_execVM",false,false] spawn BIS_fnc_MP;
                
          
            
        };

        private _childStatement_mandown = 
        {   
            params ["_target", "_player", "_params"];
               hint "Ready";
                _player assignAsCargo _target;
                [_player] orderGetIn true;
               _player setvariable ["FRdown", 1, true];  
                
               
           
            
               
        };

        private _action1 = ["Put down the rope", "Put down the rope", "", _childStatement_ropdown, {true}, {},[]] call ace_interact_menu_fnc_createAction;
        private _action2 = ["Fastrope", "Fastrope", "", _childStatement_mandown, {true}, {},[]] call ace_interact_menu_fnc_createAction;
        _actions pushBack [_action1, [], _target]; 
        _actions pushBack [_action2, [], _target];
  

    _actions
};
_modifierFunc = {
    params ["_target", "_player", "_params", "_actionData"];
  
};


_action = ["Fastrope", "Fastrope","",_statement,_condition,_insertChildren,[],"",[],[false, false, false, true, false], _modifierFunc] call ace_interact_menu_fnc_createAction;

["Helicopter", 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
