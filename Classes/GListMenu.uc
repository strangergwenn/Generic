/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class GListMenu extends GMenu;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (Menu) const int					ListSize;

var (Menu) const vector					ListOffset;
var (Menu) const vector					ScrollOffset;

var (Menu) const array<string>			IgnoreList;

var (Menu) const class<GListItem>		ListItemClass;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var int									ListCount;
var int									ScrollCount;

var string								CurrentData;

var GButton								Launch;


/*----------------------------------------------------------
	Button callbacks
----------------------------------------------------------*/

/**
 * @brief Launch button
 * @param Reference				Caller actor
 */
delegate GoLaunch(Actor Caller)
{
}

/**
 * @brief Selection callback
 * @param Reference				Caller actor
 */
delegate GoSelect(Actor Caller)
{
	local Actor Temp;
	CurrentData = GListItem(Caller).Data;
	
	foreach AllActors(ListItemClass, Temp)
	{
		if (Temp != Caller && GToggleButton(Temp).GetState())
		{
			GToggleButton(Temp).SetState(false);
		}
	}
	
	if (GToggleButton(Caller).GetState())
	{
		Launch.Activate();
	}
	else
	{
		Launch.Deactivate();
		CurrentData = "";
	}
}

/**
 * @brief Change collision status
 * @param bState				New collision state
 */
simulated function SetListItemsCollision(bool bState)
{
	local byte i;
	for (i = 0; i < Items.Length; i++)
	{
		if (Items[i].IsA(ListItemClass.Name))
		{
			Items[i].SetCollisionType((bState? COLLIDE_BlockAll : COLLIDE_NoCollision));
		}
	}
}

/**
 * @brief Called on scroll
 * @param bIsGoingUp			Is the player going up ?
 */
simulated function Scroll(bool bIsGoingUp)
{
	local byte i;
	if (( bIsGoingUp && (ScrollCount < ListCount - ListSize))
	 || (!bIsGoingUp && (ScrollCount > ListSize - ListCount)))
	{
		SetListItemsCollision(false);
		for (i = 0; i < Items.Length; i++)
		{
			if (Items[i].IsA(ListItemClass.Name))
			{
				Items[i].MoveSmooth((bIsGoingUp? -ScrollOffset : ScrollOffset) >> Rotation);
			}
		}
		SetListItemsCollision(true);
		ScrollCount += (bIsGoingUp ? 1 : -1);
	}
}

/**
 * @brief Called on enter key
 */
simulated function Enter()
{
	GoLaunch(None);
}


/*----------------------------------------------------------
	Private methods
----------------------------------------------------------*/

/**
 * @brief UI setup
 */
simulated function SpawnUI()
{
	AddButton(Vect(-320,0,0), lMBackText, lMBackComment, GoBack);
	Launch = AddButton(Vect(320,0,0), lMLaunchText, lMBackComment, GoLaunch);
	Launch.Deactivate();
	UpdateList();
}

/**
 * @brief Tick event (thread)
 * @param DeltaTime			Time since last tick
 */
simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if (CurrentData == "" && Launch != None)
	{
		Launch.Deactivate();
	}
}

/**
 * @brief Create a data list
 */
function UpdateList()
{
}

/**
 * @brief Create a data list
 */
function EmptyList()
{
	local byte i;
	for (i = 0; i < Items.Length; i++)
	{
		if (Items[i] != None)
		{
			if (Items[i].IsA(ListItemClass.Name))
			{
				Items[i].Destroy();
			}
		}
	}
	ListCount = 0;
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	ListSize=5
	ListCount=0
	ScrollCount=0

	ListItemClass=class'GListItem'
	ListOffset=(X=0,Y=-50,Z=100)
	ScrollOffset=(X=0,Y=0,Z=50)
}
