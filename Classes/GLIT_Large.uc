/**
 *  This work is distributed under the Lesser General Public License,
 *	see LICENSE for details
 *
 *  @author Gwennaël ARBONA
 **/

class GLIT_Large extends GListItem;


/*----------------------------------------------------------
	Private methods
----------------------------------------------------------*/

/**
 * @brief Entering over state
 */
simulated function OverIn()
{
	MoveSmooth((-ClickMove) >> Rotation);
	PlayUISound(OverSound);
}


/**
 * @brief Exiting over state
 */
simulated function OverOut()
{
	MoveSmooth(ClickMove >> Rotation);
}


/*----------------------------------------------------------
	Properties
----------------------------------------------------------*/

defaultproperties
{
	Begin Object Name=LabelMesh
		StaticMesh=StaticMesh'DV_UI.Mesh.SM_LargePictureLabel'
		Scale=1.0
	End Object
	
	TextScale=3.0
	TextOffsetX=30.0
	TextOffsetY=30.0
	ClickMove=(X=0,Y=-20,Z=0)
	OnLight=(R=0.0,G=0.5,B=3.0,A=1.0)
	OffLight=(R=0.0,G=0.5,B=3.0,A=1.0)
}
