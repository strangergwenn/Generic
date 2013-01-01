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

var (List) const int 					ShortTitleLength;

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
	Title = T;
	TitleButton.Set(Title, Comment);
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
	local byte i;
	super.PostBeginPlay();
	
	bDropped = true;
	for (i = 0; i < Items.Length; i++)
	{
		Items[i].SetVisible(bDropped);
	}
	TitleButton.Set(Title, "");
}

/**
 * @brief Retract the list
 */
simulated function RetractList()
{
	local byte i;
	super.PostBeginPlay();
	
	bDropped = false;
	for (i = 0; i < Items.Length; i++)
	{
		Items[i].SetVisible(bDropped);
	}
	TitleButton.SetState(false);
}


/*----------------------------------------------------------
	Button callbacks
----------------------------------------------------------*/

/**
 * @brief List item callback
 * @param Caller				Reference actor
 */
delegate ListCallback(Actor Caller)
{
	local GListItem Temp;
	Temp = GListItem(Caller);
	CurrentSelectedItem = (Temp.GetState() ? Temp : None);
	TitleButton.Set(Left(Title, ShortTitleLength) @"-" @Temp.Data, "");
	PressEvent(self);
	RetractList();
}

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
	local GToggleButton Temp;
	super.PostBeginPlay();
	Temp = Spawn(ButtonClass, self, , Location);
	Temp.SetRotation(Rotation);
	Temp.Set(""$self, "");
	Temp.SetPress(GoToggle);
	TitleButton = Temp;
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	bDropped=false
	ShortTitleLength=3
	ButtonClass=class'GToggleButton'
}
