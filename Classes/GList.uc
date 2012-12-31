/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class GList extends Actor;

//TODO : scroll and activation

/*----------------------------------------------------------
	Public attributes
----------------------------------------------------------*/

var (List) bool							bEnabled;

var (List) const int					ListSize;

var (List) const vector					ListOffset;
var (List) const vector					ScrollOffset;

var (List) const class<GListItem>		ListItemClass;


/*----------------------------------------------------------
	Private attributes
----------------------------------------------------------*/

var int									ListCount;
var int									ScrollCount;

var GListItem							CurrentSelectedItem;

var array<GListItem>					Items;

var delegate<GButton.PressCB>			PressEvent;


/*----------------------------------------------------------
	Public methods
----------------------------------------------------------*/

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
	local byte i;
	local Vector Pos;
	local GListItem Temp;
	Pos = ListOffset;
	PressEvent = CB;
	
	if (ListCount == Content.Length)
	{
		return;
	}
	
	EmptyList();
	for (i = 0; i < Content.Length; i++)
	{
		Pos += ScrollOffset;
		Temp = Spawn(ListItemClass, self, , Location + (Pos >> Rotation));
		Temp.SetRotation(Rotation);
		Temp.SetData(i, Content[i]);
		Temp.Set(Content[i], "");
		if (Pictures.Length > 0)
		{
			Temp.SetPicture(Pictures[i]);
		}
		Temp.SetPress(ListCallback);
		Items.AddItem(Temp);
		`log("ADD" @Temp @Temp.Location @Location @Content[i]);
	}
	ListCount = i;
}

/**
 * @brief Get the current text content
 * @return The string set as content for the selected item
 */
simulated function string GetSelectedContent()
{
	return CurrentSelectedItem.Text;
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
	PressEvent(self);
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

/**
 * @brief Tick event (thread)
 * @param DeltaTime			Time since last tick
 */
simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
}

/**
 * @brief Create a data list
 */
function EmptyList()
{
	Items.Remove(0, ListCount);
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
	ScrollOffset=(X=0,Y=0,Z=-30)
	ListOffset=(X=0,Y=0,Z=0)
	ListItemClass=class'GListItem'
}
