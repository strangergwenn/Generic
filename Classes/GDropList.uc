/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class GDropList extends GList
	placeable;


/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (List) bool							bDropped;

var (List) const class<GToggleButton>	ButtonClass;
var (List) GToggleButton				TitleButton;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var string								Title;


/*----------------------------------------------------------
	Public methods
----------------------------------------------------------*/

/**
 * @brief Set the title of the list
 * @param T 					List name
 * @param Comment 				List comment
 */
simulated function SetTitle(string T, string Comment)
{
	local GToggleButton Temp;
	Temp = Spawn(ButtonClass, self, , Location);
	Temp.SetRotation(Rotation);
	Temp.Set(T, Comment);
	Temp.SetPress(GoToggle);
	Title = T;
}

/**
 * @brief Set the contents of the list
 * @param Content 				String array to use as content
 * @param Pictures 				Pictures associated to the content
 * @param CB 					Callback for item selection
 */
simulated function Set(array<string> Content,
	optional array<Texture2D> Pictures,
	optional delegate<GButton.PressCB> CB)
{
	super.Set(Content, Pictures, CB);
	RetractList();
}


/**
 * @brief Drop the list down
 */
simulated function DropList()
{
	bDropped = true;
}

/**
 * @brief Retract the list
 */
simulated function RetractList()
{
	bDropped = false;
}


/*----------------------------------------------------------
	Button callbacks
----------------------------------------------------------*/

/**
 * @brief Toggle the list
 * @param Reference				Caller actor
 */
delegate GoToggle(Actor Caller)
{
	if (bDropped)
		RetractList();
	else
		DropList();
}


/*----------------------------------------------------------
	Private methods
----------------------------------------------------------*/

/**
 * @brief Spawn event
 */
simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	bDropped=false
	ButtonClass=class'GToggleButton'
}
