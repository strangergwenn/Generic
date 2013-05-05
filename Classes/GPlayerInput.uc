/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class GPlayerInput extends UDKPlayerInput within UDKPlayerController
	config(Input);


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var IntPoint						MousePosition;


/*----------------------------------------------------------
	Public methods
----------------------------------------------------------*/

/**
 * @brief Init
 */
function InitInputSystem()
{
	super.InitInputSystem();
	SetSensitivity(MouseSensitivity);
}


/** @brief Mouse input */
event PlayerInput(float DeltaTime)
{
	if (myHUD != None)
	{
		MousePosition.X = Clamp(MousePosition.X + aMouseX, 0, myHUD.SizeX);
		MousePosition.Y = Clamp(MousePosition.Y - aMouseY, 0, myHUD.SizeY);
	}		
	super.PlayerInput(DeltaTime);
}


/** @brief Set sensitivity */
function SetMouseSensitivity(float NewValue)
{
	MouseSensitivity = NewValue;
	SetSensitivity(MouseSensitivity);
	SaveConfig();
}


/** @brief Set inversion */
function SetMouseInvert(bool status)
{
	bInvertMouse = status;
	SaveConfig();
}

/**
 * @brief Reset the mouse at the center of the screen
 */
function ResetMouse()
{
	MousePosition.X = myHUD.SizeX / 2;
	MousePosition.Y = myHUD.SizeY / 2;
}


/** @brief Key pressed delegate */
function bool KeyInput(int ControllerId, name KeyName, EInputEvent IEvent, float AmountDepressed, optional bool bGamepad)
{
	if (GHUD(myHUD) != None)
	{
		GHUD(myHUD).KeyPressed(KeyName, IEvent);
		return true;
	}
	return false;
}

/**
 * Process a character input event (typing) routed through unrealscript from another object. This method is assigned as the value for the
 * OnReceivedNativeInputKey delegate so that native input events are routed to this unrealscript function.
 * @param	ControllerId	the controller that generated this character input event
 * @param	Unicode			the character that was typed
 * @return	True to consume the character, false to pass it on.
 */
function bool InputChar(int ControllerId, string Unicode)
{
	if (GHUD(myHUD) != None)
	{
		GHUD(myHUD).CharPressed(Unicode);
		return true;
	}
	return false;
}

/** @brief Get a key current binding */
simulated exec function string GetKeyBinding(string Command)
{
    local byte i;

	for (i = 0; i < Bindings.Length; i++)
	{
		if (Bindings[i].Command == Command)
			return string(Bindings[i].Name);
	}
}

/** @brief Switch a key binding */
simulated exec function SetKeyBinding(name BindName, string Command)
{
	// Init
    local int i;
    if (Command == "none")
    	Command = "";

	// Setting
	for(i = Bindings.Length - 1; i >= 0; i --)
	{
		if (Bindings[i].Name == BindName)
		{
			Bindings[i].Command = Command;
			SaveConfig();
		}
		else if (Bindings[i].Command == Command)
		{
			Bindings[i].Name = BindName;
			SaveConfig();
		}
	}
	SaveConfig();
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	OnReceivedNativeInputKey=KeyInput
	OnReceivedNativeInputChar=InputChar
}
