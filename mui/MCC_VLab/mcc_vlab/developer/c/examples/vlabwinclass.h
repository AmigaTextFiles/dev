/* Defines and Structures for our custom class, VLabWinClass.*/

/* This sets up an abritray value to use as the starting point for our tags.*/
#define MUISERIALNR_VLABWIN 1
#define TAGBASE_VLABWIN			( TAG_USER | ( MUISERIALNR_VLABWIN << 16 ) )

/* Instance data */
/* This contains all the variable required by our custom class, VLabWinClass.*/
struct VLabWinData
{
	Object *vlabObj;			// The "main" VLab object that is passed into us with a tag. (see below)

	Object *ownMonitor;		// The monitor object that we get() from VLab.mcc.

	Object *buttonGroup;	// The group containing all the buttons in the window.

	Object *mainGroup;		// The group containing everything in the window.

	Object *monitorGroup;	// The group containing the "own monitor".

	Object *monitorText;	// The text object below the "own monitor".

	Object *vlabImage;		// The image object pointer returned from a "grab".

	Object *vlabImageWin;	// The window in which we are displaying the grabbed image.
};

/* Methods */
/* These methods are called on our custom class, VLabWinClass.*/
#define MUIM_VLabWin_OwnMonitorOn 	( TAGBASE_VLABWIN + 1 )	// Turns on a monitor in our own window.
#define MUIM_VLabWin_OwnMonitorOff	( TAGBASE_VLABWIN + 2 )	// Turns off the monitor in our own window.
#define MUIM_VLabWin_OwnMonitorRun	( TAGBASE_VLABWIN + 3 )	// Runs the monitor in our window.
#define MUIM_VLabWin_OwnMonitorStop	( TAGBASE_VLABWIN + 4 )	// Stops the monitor in our window.
#define	MUIM_VLabWin_Grab						( TAGBASE_VLABWIN + 5 )	// Grabs an image from the VLab card.

/* Tags */
/* These tags are passed from object to object when required.*/
#define	VLAB_Object	( TAGBASE_VLABWIN + 20 )	// Used to pass VLab.mcc to our custom class, VLabWinClass.
