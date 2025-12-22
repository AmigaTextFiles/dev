/*
** vlabwinclass.c - a module in VLab-Demo
** © Steve Quartly 1999
**
** This is a MUI Custom Class.
** The class is a sub class of MUIC_Window.
**
** This is the main window in this demo program.
**
** For the monitor to work, or grabbed images to be displayed,
** either CyberGraphx or guigfx.library must be installed.
**
** You do not need these libraries to grab.
**
*/

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/muimaster_protos.h>
#include <pragmas/muimaster_pragmas.h>
#include <libraries/mui.h>
#include <libraries/iffparse.h>
#include <stdio.h>

#include <mui/vlab_mcc.h>

#include "vlabwinclass.h"

/* Prototypes.*/
ULONG __saveds __asm VLabWinDispatcher( register __a0 struct IClass *cl, register __a2 Object *obj, register __a1 Msg msg );
ULONG __saveds VLabWinNew( struct IClass *cl, Object *obj, struct opSet *msg );
ULONG __saveds VLabWinOwnMonitorOn( struct IClass *cl, Object *obj, Msg msg );
ULONG __saveds VLabWinOwnMonitorOff( struct IClass *cl, Object *obj, Msg msg );
ULONG __saveds VLabWinOwnMonitorRun( struct IClass *cl, Object *obj, Msg msg );
ULONG __saveds VLabWinOwnMonitorStop( struct IClass *cl, Object *obj, Msg msg );
ULONG __saveds VLabWinGrab( struct IClass *cl, Object *obj, Msg msg );
ULONG __saveds VLabWinDispose( struct IClass *cl, Object *obj, Msg msg );

extern struct Library *MUIMasterBase;

extern struct MUI_CustomClass *mccVLabWin;

ULONG __stdargs DoSuperNew( struct IClass *cl,Object *obj,ULONG tag1,... )
{
	return( DoSuperMethod( cl, obj, OM_NEW, &tag1, NULL ) );
}

/*
**
** The dispatcher for our custom class, VLabWinClass.
**
*/
ULONG __saveds __asm VLabWinDispatcher( register __a0 struct IClass *cl, register __a2 Object *obj, register __a1 Msg msg )
{
	switch ( msg->MethodID )
	{
		case OM_NEW: return( VLabWinNew( cl, obj, ( APTR )msg ) );
		case OM_DISPOSE: return( VLabWinDispose( cl, obj, ( APTR )msg ) );
		case MUIM_VLabWin_OwnMonitorOn: return( VLabWinOwnMonitorOn( cl, obj, ( APTR )msg ) );
		case MUIM_VLabWin_OwnMonitorOff: return( VLabWinOwnMonitorOff( cl, obj, ( APTR )msg ) );
		case MUIM_VLabWin_OwnMonitorRun: return( VLabWinOwnMonitorRun( cl, obj, ( APTR )msg ) );
		case MUIM_VLabWin_OwnMonitorStop: return( VLabWinOwnMonitorStop( cl, obj, ( APTR )msg ) );
		case MUIM_VLabWin_Grab: return( VLabWinGrab( cl, obj, ( APTR )msg ) );
	}

	return( DoSuperMethodA( cl, obj, ( Msg )msg ) );
}

/*
**
** This is called by OM_NEW.
**
*/

ULONG __saveds VLabWinNew( struct IClass *cl, Object *obj, struct opSet *msg )
{
	struct VLabWinData *data;

	Object *vlabon, *vlaboff, *vlabrun, *vlabstop;
	Object *ownon, *ownoff, *ownrun, *ownstop, *grab;
	Object *mainGroup, *buttonGroup, *vlabObj;

	/* Get the object pointer to the VLab.mcc object.*/
	vlabObj = ( Object * )GetTagData( VLAB_Object, NULL, msg->ops_AttrList );

	/* Build the main window.*/
	if ( obj = ( Object * ) DoSuperNew( cl, obj,
			MUIA_Window_Title, "VLab-Demo",
			MUIA_Window_ID, MAKE_ID('V','L','A','B'),
			WindowContents, mainGroup = HGroup,

				/* The group with all the buttons.*/
				Child, buttonGroup = VGroup,
					Child, VGroup, GroupFrameT( "Monitor in VLab Window" ),
						Child, vlabon = KeyButton( "On", 'o'),
						Child, vlaboff = KeyButton( "Off", 'f'),
						Child, vlabrun = KeyButton( "Run", 'r'),
						Child, vlabstop = KeyButton( "Stop", 'p'),
					End,

					Child, VGroup, GroupFrameT( "Monitor in Own Window" ),
						Child, ownon = KeyButton( "On", 'n'),
						Child, ownoff = KeyButton( "Off", 'h'),
						Child, ownrun = KeyButton( "Run", 'u'),
						Child, ownstop = KeyButton( "Stop", 't'),
					End,

					Child, VGroup, GroupFrameT( "Grab Image" ),
						Child, grab = KeyButton("Grab", 'g'),
					End,

				End,
    End,

		TAG_MORE, ( ULONG ) msg->ops_AttrList ) )
	{
		data = ( struct VLabWinData * )INST_DATA( cl, obj );

		/* Store the pointers to certain object that we will require later
			 in our instance data.*/
		data->vlabObj = vlabObj;
		data->buttonGroup = buttonGroup;
		data->mainGroup = mainGroup;

		/* Set up the notification on our buttons.*/
		/* To get VLab.mcc to provide the window for the monitor, simply do this...*/
		DoMethod( vlabon, MUIM_Notify, MUIA_Pressed, FALSE, data->vlabObj, 1, MUIM_VLab_MonitorOn );

		/* Do this to close the window...*/
		DoMethod( vlaboff, MUIM_Notify, MUIA_Pressed, FALSE, data->vlabObj, 1, MUIM_VLab_MonitorOff );

		/* Do this to run and stop the monitor...*/
		DoMethod( vlabrun, MUIM_Notify, MUIA_Pressed, FALSE, data->vlabObj, 3, MUIM_Set, MUIA_VLab_Monitor, MUIV_VLab_MonitorRun );
		DoMethod( vlabstop, MUIM_Notify, MUIA_Pressed, FALSE, data->vlabObj, 3, MUIM_Set, MUIA_VLab_Monitor, MUIV_VLab_MonitorStop );

		/* To get a monitor object and display it in our own window, I invoke these methods
			 on ourself.*/
		DoMethod( ownon, MUIM_Notify, MUIA_Pressed, FALSE, obj, 1, MUIM_VLabWin_OwnMonitorOn );
		DoMethod( ownoff, MUIM_Notify, MUIA_Pressed, FALSE, obj, 1, MUIM_VLabWin_OwnMonitorOff );
		DoMethod( ownrun, MUIM_Notify, MUIA_Pressed, FALSE, obj, 1, MUIM_VLabWin_OwnMonitorRun );
		DoMethod( ownstop, MUIM_Notify, MUIA_Pressed, FALSE, obj, 1, MUIM_VLabWin_OwnMonitorStop );

		/* Same with grab, invoke this method on ourself.*/
		DoMethod( grab, MUIM_Notify, MUIA_Pressed, FALSE, obj, 1, MUIM_VLabWin_Grab );

		/* OM_NEW was successful..... return.*/
		return ( ULONG )obj;
	}

	/* OM_NEW failed..... invoke a dispose to tidy up and return.
		 In our case there will be nothing to do, but we might add something later
		 so it is better to leave it here.*/
	CoerceMethod( cl, obj, OM_DISPOSE );

	return NULL;
}

/*
**
** This is called by OM_DISPOSE.
**
*/

ULONG __saveds VLabWinDispose( struct IClass *cl, Object *obj, Msg msg )
{
//	struct VLabWinData *data = INST_DATA( cl, obj );

	/* Nothing to do in our dispose.*/

	return( DoSuperMethodA( cl, obj, ( Msg ) msg ) );
}

/*
**
** This turns on a monitor in our own window.
**
*/

ULONG __saveds VLabWinOwnMonitorOn( struct IClass *cl, Object *obj, Msg msg )
{
	struct VLabWinData *data = INST_DATA( cl, obj );

	/* Only turn it on if it doesn't already exist.*/
	/* Of course you can open as many monitor's as you want!! (Pretty pointless really).*/
	if ( !data->ownMonitor )
	{
		/* Ask VLab.mcc for a monitor object pointer.
			 It is now OUR responsibility to dispose of the monitor object (data->ownMonitor)
			 when we have finished with it.*/
		get( data->vlabObj, MUIA_VLab_MonitorObject, &data->ownMonitor );

		/* Now build a group to add to our main window.*/
		data->monitorGroup = VGroup, GroupFrameT( "VLab Monitor" ),

			/* For spacing only.*/
			Child, RectangleObject, End,

			/* Add our monitor.*/
			Child, data->ownMonitor,

			/* Somewhere to display text.*/
			Child, data->monitorText = TextObject,
				TextFrame,
				MUIA_Background, MUII_TextBack,
				MUIA_Text_Contents, "\33cRunning...", 
				MUIA_Text_SetMax, FALSE,
			End,

			/* Spacing again.*/
			Child, RectangleObject, End,

		End;

		/* If it created successfully.*/
		if ( data->monitorGroup )
		{
			/* Put the main group into an InitChange so we can dynamically add objects to it.*/
			if ( DoMethod( data->mainGroup, MUIM_Group_InitChange ) )
			{
				/* Add our newly created monitor group.*/
				DoMethod( data->mainGroup, OM_ADDMEMBER, data->monitorGroup );

				/* Sort the group so the buttons are on the left and the monitor on the right.*/
				DoMethod( data->mainGroup, MUIM_Group_Sort, data->buttonGroup, data->monitorGroup, NULL );

				/* Put the main group into ExitChange, we have finished adding our object(s).*/
				DoMethod( data->mainGroup, MUIM_Group_ExitChange );
			}

			/* The monitor is now being displayed in the main window.*/

		}

		/* Ooops, the monitor group failed for some reason...*/
		else
		{
			/*... but the monitor may still have been created, so we have to dispose of it.*/
			if ( data->ownMonitor ) MUI_DisposeObject( data->ownMonitor );

			/* We should return some error to the user here.*/
		}
	}

	return NULL;
}

/*
**
** This turns off the monitor in our own window.
**
*/

ULONG __saveds VLabWinOwnMonitorOff( struct IClass *cl, Object *obj, Msg msg )
{
	struct VLabWinData *data = INST_DATA( cl, obj );

	/* Only turn it off if it is on!*/
	if ( data->ownMonitor )
	{
		/* Put the main group into an InitChange so we can dynamically remove object from it.*/ 
		if ( DoMethod( data->mainGroup, MUIM_Group_InitChange ) )
		{
			/* Remove our monitor group.*/
			DoMethod( data->mainGroup, OM_REMMEMBER, data->monitorGroup );

			/* Put the main group into ExitChange, we have finished removing our object(s).*/
			DoMethod( data->mainGroup, MUIM_Group_ExitChange );
		}

		/* Dispose of the monitor group. We don't have to dispose of our monitor object
			 (data->ownMonitor) seperately as it is a child of this group and will be
			 automatically disposed with this group.*/
		MUI_DisposeObject( data->monitorGroup );

		data->ownMonitor = NULL;
	}

	return TRUE;
}

/*
**
** This set the monitor in our own window to 'run' mode.
**
*/

ULONG __saveds VLabWinOwnMonitorRun( struct IClass *cl, Object *obj, Msg msg )
{
	struct VLabWinData *data = INST_DATA( cl, obj );

	/* Set the monitor to run..... easy!*/
	set( data->ownMonitor, MUIA_VLab_Monitor, MUIV_VLab_MonitorRun );

	/* Modify the text below the monitor accordingly.*/
	set( data->monitorText, MUIA_Text_Contents, "\33cRunning..." );

	return NULL;
}

/*
**
** This set the monitor in our own window to 'stop' mode.
**
*/

ULONG __saveds VLabWinOwnMonitorStop( struct IClass *cl, Object *obj, Msg msg )
{
	struct VLabWinData *data = INST_DATA( cl, obj );

	/* Set the monitor to stop..... easy!*/
	set( data->ownMonitor, MUIA_VLab_Monitor, MUIV_VLab_MonitorStop );

	/* Modify the text below the monitor accordingly.*/
	set( data->monitorText, MUIA_Text_Contents, "\33cStopped..." );

	return NULL;
}

/*
**
** Grab an image from the VLab card.
**
*/

ULONG __saveds VLabWinGrab( struct IClass *cl, Object *obj, Msg msg )
{
	struct VLabWinData *data = INST_DATA( cl, obj );

	ULONG result;

	/* Firstly dispose of any old images.
		 This demo can only grab one at a time, of course you can have as many as you want.*/
	if ( data->vlabImage )
	{
		/* Close the image window if it is open.*/
		set( data->vlabImageWin, MUIA_Window_Open, FALSE );

		/* Remove it from the application.*/
		DoMethod( _app( obj ), OM_REMMEMBER, data->vlabImageWin );

		/* Dispose of the window.... this will also dispose of the image (data->vlabImage)
			 as it is a child of the window and will be automatically disposed with this window.*/
		MUI_DisposeObject( data->vlabImageWin );

		data->vlabImageWin = data->vlabImage = NULL;
	}

	/* Set our main window to sleep so the user can't do anything while we are grabbing.*/
	set( obj, MUIA_Window_Sleep, TRUE );

	/* Tell VLab.mcc to grab and image and store it in data->vlabImage.*/
	result = DoMethod( data->vlabObj, MUIM_VLab_Grab, &data->vlabImage );

	/* If all went well, we now have a image. We can do whatever we want with it now.
		 In this demo I simply attach it to a window and display it, of course you can
		 request an RGB pointer to it (DoMethod( data->vlabImage, MUIM_VLabImage_ObtainRGBPointer))
		 and do what you want, eg save it.
		 *NOTE* If you want to change the buffer, ie rotate it, scale it etc.. you **MUST** copy
		 the buffer first.
		 DO NOT MODIFY THE SOURCE RGB BUFFER PASSED TO YOU, COPY IT FIRST.*/
	if ( result == VLABERR_OK )
	{
		/* We now have an image!.
			 Let's build the window and display it....*/
		data->vlabImageWin = WindowObject,
			MUIA_Window_Title, "VLab Image",
			MUIA_Window_Width, MUIV_Window_Width_Default,
			MUIA_Window_Height, MUIV_Window_Height_Default,
			WindowContents, VGroup,

				/* The group with the scroll bars.*/
				Child, ScrollgroupObject,
					/* The virtual group containing the image.*/
					MUIA_Scrollgroup_Contents, VirtgroupObject,
						VirtualFrame,
						/* The image.*/
						Child, data->vlabImage,
					End,
				End,
			End,

 		TAG_DONE );

		if ( data->vlabImageWin )
  	{
			/* Add the window to the application.*/
			DoMethod( _app( obj ), OM_ADDMEMBER, data->vlabImageWin );

			/* Open it.*/
			set( data->vlabImageWin, MUIA_Window_Open, TRUE );

			/* Set notification on the close gaddet.*/
			DoMethod( data->vlabImageWin, MUIM_Notify, MUIA_Window_CloseRequest, TRUE, data->vlabImageWin, 3, MUIM_Set, MUIA_Window_Open, FALSE );
		}
	}

	/* Wake up the main window.*/
	set( obj, MUIA_Window_Sleep, FALSE );

	return NULL;
}

