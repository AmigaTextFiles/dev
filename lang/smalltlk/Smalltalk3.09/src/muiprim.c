/* 
	MUI primitives
	written by David Faught, July 1995
*/

# include "muist.h"
# include "env.h"
# include "memory.h"
# include "names.h"

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

extern object trueobj, falseobj;
extern boolean parseok;
extern int initial;

/* A little array definition */
extern const char LVT_STinit[];

/* Conventional GadTools NewMenu structure, a memory saving way of defining menus */
extern struct NewMenu Menu[];

/* Pointers for some MUI objects */
extern APTR AP_Small;
extern APTR LV_Classes, LV_Methods, LV_Text, LV_Console;
extern APTR ST_Console;

object sysPrimitive(primitiveNumber, arguments)
int primitiveNumber;
object *arguments;
{	int i, j, k;
	char *c, *d;
	object returnedObject;
	struct Window *window;
	struct Gadget *gadget;
	char *text;
	ULONG size;
	char buf[200];

	returnedObject = nilobj;

	switch(primitiveNumber) {
	case 160:	/* open window */
		i = intValue(arguments[0]);
		set(wins[i], MUIA_Window_Open, TRUE);
		break;

	case 161:	/* close window */
		i = intValue(arguments[0]);
		set(wins[i], MUIA_Window_Open, FALSE);
		break;

	case 170:	/* get next event */
		i = intValue(arguments[0]);
		{
		ULONG signal,event;
		char *buf;

		event=(DoMethod(AP_Small, MUIM_Application_Input, &signal));
		if (event == 0 && signal != 0 && i < 2) {
			Wait(signal);
			event=(DoMethod(AP_Small, MUIM_Application_Input, &signal));
			}
		returnedObject = newInteger(event);
		}
		break;

	case 171:	/* integer event info */
		i = intValue(arguments[0]);
		/* for this primitive only, default to non-nil returnedObject */
		returnedObject = newStString(""); /* this is not nilobj */
		switch(i) {
			case MUIV_Application_ReturnID_Quit:
				returnedObject = nilobj;
				break;

			case ID_NEWCON:
				get(ST_Console,MUIA_String_Contents,&text);
				sprintf(buf, ">    %s", text);
				putCons(buf);
				returnedObject = newStString(text);
				set(ST_Console,MUIA_String_Contents,"");
				set(wins[0],MUIA_Window_ActiveObject,ST_Console);
				break;

			case ID_NEWCLA:
				DoMethod(LV_Classes, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &text);
				returnedObject = newStString(text);
				break;

			case ID_NEWMET:
				DoMethod(LV_Methods, MUIM_List_GetEntry, MUIV_List_GetEntry_Active, &text);
				returnedObject = newStString(text);
				break;

			case ID_ABOUT:
				genRequest(LVT_STinit);
				break;
		}
		break;

	case 180:	/* clear browser Classes listview list */
		i = intValue(arguments[0]); /* win number? */
		DoMethod(LV_Classes, MUIM_List_Clear);
		break;

	case 181:	/* add an item to browser Classes listview list */
		i = intValue(arguments[0]); /* win number? */
		c = charPtr(arguments[1]); /* new item text */
		DoMethod(LV_Classes, MUIM_List_InsertSingle, c, MUIV_List_Insert_Sorted);
		break;

	case 182:	/* clear browser Methods listview list */
		i = intValue(arguments[0]);
		DoMethod(LV_Methods, MUIM_List_Clear);
		break;

	case 183:	/* add an item to browser Methods listview list */
		i = intValue(arguments[0]); /* win number? */
		c = charPtr(arguments[1]); /* new item text */
		DoMethod(LV_Methods, MUIM_List_InsertSingle, c, MUIV_List_Insert_Sorted);
		break;

	case 185:	/* add an item to browser Text listview list */
		i = intValue(arguments[0]); /* win number? */
		c = charPtr(arguments[1]); /* new item text */
		set(LV_Text, MUIA_Floattext_Text, c);
		break;

	case 191:	/* menu item */
		i = intValue(arguments[0]); /* menu number */
		c = charPtr(arguments[1]); /* title */
		break;

	case 200:	/* issue a message */
		c = charPtr(arguments[0]);
		putCons(c);
		break;

	case 201:	/* requester message */
		c = charPtr(arguments[0]);
		genRequest(c);
		break;

	case 202:	/* ask a binary question */
		c = charPtr(arguments[0]);
		i = MUI_Request(AP_Small, wins[0], 0, NULL, "_Yes|_No", c);
		if (i == 1) returnedObject = trueobj;
		else if (i == 0) returnedObject = falseobj;
		break;

	case 203:	/* ask for a file */
		c = charPtr(arguments[0]);
{
	APTR win, TX_Request, ST_Request;
	ULONG signal;
	boolean running = TRUE;

	set(AP_Small,MUIA_Application_Sleep,TRUE);	/* disable other windows */
	win = WindowObject, MUIA_Window_Title, "Smalltalk", MUIA_Window_ID, MAKE_ID('R','E','Q','F'), WindowContents,
			VGroup,
				Child, TX_Request = TextObject,	TextFrame, End,
				Child, ST_Request = PopaslObject,
					MUIA_Popstring_String, KeyString(0,256,'f'),
					MUIA_Popstring_Button, PopButton(MUII_PopFile),
					ASL_Hail, "Please select a file...",
					ASL_Pattern, "#?.st",
					ASL_FuncFlags, FILF_PATGAD,
					End,
				End,
			End;

	if (win)				/* ok ? */
	{
		DoMethod(AP_Small,OM_ADDMEMBER,win);	/* add window... */
		DoMethod(ST_Request,MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,MUIV_Notify_Application,2,MUIM_Application_ReturnID,ID_REQU);
		set(TX_Request,MUIA_Text_Contents,c);
		set(win,MUIA_Window_Open,TRUE);	/* and open it */
		set(win,MUIA_Window_ActiveObject,ST_Request);

		returnedObject = newStString("");

		while (running)
		{
			switch (DoMethod(AP_Small,MUIM_Application_Input,&signal))
			{
				case MUIV_Application_ReturnID_Quit:
					running = FALSE;
					break;

				case ID_REQU:
					get(ST_Request,MUIA_String_Contents,&text);
					running = FALSE;
					returnedObject = newStString(text);
					break;
			}
			if (running && signal) Wait(signal);
		}

		set(win,MUIA_Window_Open,FALSE);	/* Close window */
		DoMethod(AP_Small,OM_REMMEMBER,win);	/* remove */
		MUI_DisposeObject(win);		/* and kill it */
	}
	set(AP_Small,MUIA_Application_Sleep,FALSE); /* wake up the application */
}
		break;

	case 204:	/* ask a question with a string reply */
		c = charPtr(arguments[0]);
		d = charPtr(arguments[1]);
{
	APTR win, TX_Request, ST_Request;
	ULONG signal;
	boolean running = TRUE;

	set(AP_Small,MUIA_Application_Sleep,TRUE);	/* disable other windows */
	win = WindowObject, MUIA_Window_Title, "Smalltalk", MUIA_Window_ID, MAKE_ID('R','E','Q','U'), WindowContents,
			VGroup,
				Child, TX_Request = TextObject,	TextFrame, End,
				Child, ST_Request = StringObject, StringFrame, End,
				End,
			End;

	if (win)				/* ok ? */
	{
		DoMethod(AP_Small,OM_ADDMEMBER,win);	/* add window... */
		DoMethod(ST_Request,MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,MUIV_Notify_Application,2,MUIM_Application_ReturnID,ID_REQU);
		set(TX_Request,MUIA_Text_Contents,c);
		set(ST_Request,MUIA_String_Contents,d);
		set(win,MUIA_Window_Open,TRUE);	/* and open it */
		set(win,MUIA_Window_ActiveObject,ST_Request);

		returnedObject = newStString("");

		while (running)
		{
			switch (DoMethod(AP_Small,MUIM_Application_Input,&signal))
			{
				case MUIV_Application_ReturnID_Quit:
					running = FALSE;
					break;

				case ID_REQU:
					get(ST_Request,MUIA_String_Contents,&text);
					running = FALSE;
					returnedObject = newStString(text);
					break;
			}
			if (running && signal) Wait(signal);
		}

		set(win,MUIA_Window_Open,FALSE);	/* Close window */
		DoMethod(AP_Small,OM_REMMEMBER,win);	/* remove */
		MUI_DisposeObject(win);		/* and kill it */
	}
	set(AP_Small,MUIA_Application_Sleep,FALSE); /* wake up the application */
}
		break;

	default:
	fprintf(stderr,"primitive not implmented %d\n",
		primitiveNumber);
	sysError("primitive not implemented","");
	}

	return returnedObject;
}
