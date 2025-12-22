/*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */


/****** triton.library/class_String ******
*
*   NAME	
*	class_String -- A GadTools string gadget
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_String
*
*   ATTRIBUTES
*	<Default>        : STRPTR string
*	                   [create, set, get]
*	TRAT_Value       : UWORD maxchars (default: 64)
*	                   [create]
*	TRST_Filter      : STRPTR filter: Only characters in this string will
*	                   be accepted if present, otherwise all characters
*	                   are allowed.
*	                   [create]
*	TRAT_Flags       : ULONG flags
*	                   - TRST_INVISIBLE         : Invisible typing
*	                   - TRST_NORETURNBROADCAST : Don't broadcast <Return>
*	                                              key presses to the window.
*	                   - TRST_FLOAT             : Only one "." or "," symbol
*	                                              is accepted.
*	                   [create]
*
*   APPLICATION MESSAGES
*	TRMS_NEWVALUE is sent when <Return> has been pressed in an activated
*	string gadget. trm_Data contains a pointer to the new string and is
*	only valid as long as the object exists. It is advised that you do not
*	check for TRMS_NEWVALUE messages but instead read the current string
*	using TR_GetAttribute() when you need it.
*
*   OBJECT MESSAGES
*	TROM_ACTIVATE    : Activate the string gadget.
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON
#define TR_EXTERNAL_ONLY

#include <intuition/sghooks.h>
#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "string.def"
#include "/prefs/Triton.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define STRING object

static const char *nullstr="";


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////// The edit hook //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define KEYB_SHORTCUT		1
#define KEYB_POPUP			2

#ifndef RAWKEY_UP
#define RAWKEY_UP				0x4C
#define RAWKEY_DOWN			0x4D
#endif

#define USERFLAG_UP_DOWN_ARROW			0x1
#define USERFLAG_POPUP						0x2

struct StrGadUserData { ULONG flags; };

struct CombStringInfo {
	ULONG magic;
	struct CombStringInfo *self;
	struct StringInfo strinfo;
	struct StringExtend strextend;
	struct Hook edithook;
	};

#define IEQUALIFIER_SHIFT		(IEQUALIFIER_LSHIFT|IEQUALIFIER_RSHIFT)

ULONG __asm __saveds TR_StrEditHookEntry(register __a0 struct Hook *hook,
					 register __a2 struct SGWork *sgw,
					 register __a1 ULONG *msg)
{
  //  struct StrGadUserData *userdata;
  int qual, rawcode; //, uparrow;
  struct TROD_String *object;
  
  if( msg[0] == SGH_KEY)
    {
      object=((struct TROD_String *)(sgw->Gadget->UserData));
      rawcode = sgw->IEvent->ie_Code;
      qual = sgw->IEvent->ie_Qualifier;

      /* Apply filter */
      if(sgw->Code!=27)
	if(sgw->EditOp == EO_INSERTCHAR || sgw->EditOp == EO_REPLACECHAR)
	  if(STRING->Filter)
	    if(TR_FirstOccurance(sgw->Code,STRING->Filter)==-1)
	{
	  sgw->Actions &= ~(SGA_USE|SGA_REUSE);
	  sgw->Actions |= SGA_BEEP;
	  sgw->Code = 0;
	}

      /* Float separator check */
      if((sgw->Code=='.')||(sgw->Code==','))
	if(sgw->EditOp == EO_INSERTCHAR || sgw->EditOp == EO_REPLACECHAR)
	  if(STRING->Flags&TRST_FLOAT)
	    if((TR_FirstOccurance(',',(((struct StringInfo *)
					(((struct Gadget *)
					  DISPLAYOBJECT->PrivData)->SpecialInfo))->Buffer))!=-1)
	       || (TR_FirstOccurance('.',(((struct StringInfo *)
					   (((struct Gadget *)
					     DISPLAYOBJECT->PrivData)->SpecialInfo))->Buffer))!=-1))
	      {
		sgw->Actions &= ~(SGA_USE|SGA_REUSE);
		sgw->Actions |= SGA_BEEP;
		sgw->Code = 0;
	      }

      if( sgw->EditOp == EO_INSERTCHAR ||
	  sgw->EditOp == EO_REPLACECHAR ||
	  sgw->EditOp == EO_BADFORMAT ||
	  ( sgw->EditOp == EO_NOOP &&
	    sgw->Actions == (SGA_USE|SGA_BEEP) &&
	    sgw->NumChars == (sgw->StringInfo->MaxChars - 1)
	    )
	  )
	{
	  if ((qual & IEQUALIFIER_RCOMMAND) || (sgw->Code==27))
	    {
	      sgw->Actions &= ~(SGA_USE|SGA_BEEP|SGA_REDISPLAY);
	      sgw->IEvent->ie_Qualifier &= ~IEQUALIFIER_RCOMMAND;
	      if (!(qual & IEQUALIFIER_REPEAT))
		{
		  sgw->Actions |= SGA_REUSE|SGA_END;
		  sgw->Code = KEYB_SHORTCUT;
		}
	    }
	}

      if( ( (rawcode==68) && (!(STRING->Flags & TRST_NORETURNBROADCAST)) )
	  || (rawcode==76)
	  || (rawcode==77)
	  || (rawcode==95) )
	{
	  sgw->Actions &= ~(SGA_USE|SGA_BEEP|SGA_REDISPLAY);
	  sgw->IEvent->ie_Qualifier &= ~IEQUALIFIER_RCOMMAND;
	  if (!(qual & IEQUALIFIER_REPEAT))
	    {
	      sgw->Actions |= SGA_REUSE|SGA_END;
	      sgw->Code = KEYB_SHORTCUT;
	    }
	}

//    if (userdata = (struct StrGadUserData *)sgw->Gadget->UserData)
//    {
//      if (userdata->flags & USERFLAG_POPUP)
//      {
//        if( (sgw->IEvent->ie_Qualifier & IEQUALIFIER_SHIFT) &&
//            rawcode == RAWKEY_DOWN )
//        {
//          sgw->Actions &= ~(SGA_USE|SGA_BEEP|SGA_REDISPLAY);
//          sgw->Actions |= SGA_END;
//          sgw->Code = KEYB_POPUP;
//          return (TRUE);
//        }
//      }
//      if (userdata->flags & USERFLAG_UP_DOWN_ARROW)
//      {
//        uparrow = (rawcode == RAWKEY_UP);
//        if (uparrow || (rawcode == RAWKEY_DOWN))
//        {
//          sgw->Actions &= ~(SGA_USE|SGA_BEEP|SGA_REDISPLAY);
//          sgw->Actions |= SGA_REUSE|SGA_END;
//          sgw->Code = KEYB_SHORTCUT;
//        }
//      }
//    }
      return (TRUE);
    }
  return (FALSE);
}

struct Hook TR_StrEditHook = { { NULL }, TR_StrEditHookEntry, NULL, NULL };


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(String,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;
  data->project->trp_IDCMPFlags|=STRINGIDCMP;

  if(STRING->MaxChars==0) STRING->MaxChars=64;
  if(!(STRING->WorkBuffer=
       (STRPTR)TR_AllocPooled(data->project->trp_MemPool,STRING->MaxChars+2))) return NULL;

  DISPLAYOBJECT->MinHeight=(data->project->trp_PropFont->tf_YSize)+6;
  DISPLAYOBJECT->MinWidth=DISPLAYOBJECT->MinHeight;
  DISPLAYOBJECT->XResize=TRUE;
  DISPLAYOBJECT->Flags|=TROB_DISPLAYOBJECT_TABOK;

  return (ULONG)object;
}


TR_METHOD(String,INSTALL,InstallData)
{
  struct TR_Project *project;

  TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);
  project=OBJECT->Project;
  TR_InternalAreaFill(project,NULL,DISPLAYOBJECT->Left+4,DISPLAYOBJECT->Top+2,
		      DISPLAYOBJECT->Left+DISPLAYOBJECT->Width-5,
		      DISPLAYOBJECT->Top+DISPLAYOBJECT->Height-3,TRBF_NONE);
  if(!((STRING->StrExt)=(struct StringExtend *)
       TR_AllocPooled(project->trp_MemPool,sizeof(struct StringExtend)))) return NULL;
  STRING->StrExt->Pens[1]=TR_GetPen(project,TRPT_TRITONPEN,TRTP_USSTRINGGADBACK);
  STRING->StrExt->Pens[0]=TR_GetPen(project,TRPT_TRITONPEN,TRTP_USSTRINGGADFRONT);
  STRING->StrExt->ActivePens[1]=TR_GetPen(project,TRPT_TRITONPEN,TRTP_SSTRINGGADBACK);
  STRING->StrExt->ActivePens[0]=TR_GetPen(project,TRPT_TRITONPEN,TRTP_SSTRINGGADFRONT);
  if(STRING->Flags&TRST_INVISIBLE)
    {
      STRING->StrExt->Pens[1]=TR_GetPen(project,TRPT_TRITONPEN,TRTP_USSTRINGGADFRONT);
      STRING->StrExt->ActivePens[1]=TR_GetPen(project,TRPT_TRITONPEN,TRTP_SSTRINGGADFRONT);
    }
  STRING->StrExt->EditHook=&TR_StrEditHook;
  STRING->StrExt->WorkBuffer=STRING->WorkBuffer;
  if(DISPLAYOBJECT->PrivData=(ULONG)
     TR_CreateGadgetTags(OBJECT->Project,
			 OBJECT,
			 STRING_KIND,
			 DISPLAYOBJECT->Left,
			 DISPLAYOBJECT->Top,
			 DISPLAYOBJECT->Width,
			 DISPLAYOBJECT->Height,
			 STRINGA_Justification, GACT_STRINGLEFT,
			 STRINGA_ReplaceMode,   FALSE,
			 STRINGA_ExitHelp,      FALSE,
			 GA_TabCycle,           TRUE,
			 GTST_String,           STRING->String,
			 GTST_MaxChars,         STRING->MaxChars,
			 GA_Disabled,           TR_DO_DISABLED,
			 TAG_END))
    {
      ((struct StringInfo*)(((struct Gadget *)(DISPLAYOBJECT->PrivData))->SpecialInfo))->Extension=
	(STRING->StrExt);
      return 1L;
    }

  return NULL;
}


TR_SIMPLEMETHOD(String,PREGTREMOVE)
{
  ULONG textlength;

  FreeVec((APTR)(STRING->String));
  textlength=TR_FirstOccurance(0,(STRPTR)
			       (((struct StringInfo *)
				 (((struct Gadget *)DISPLAYOBJECT->PrivData)->SpecialInfo))->Buffer))+1;
  if(!(STRING->String=AllocVec(textlength, MEMF_ANY))) return NULL;
  CopyMem((APTR)
	  (((struct StringInfo *)(((struct Gadget *)DISPLAYOBJECT->PrivData)->SpecialInfo))->Buffer),
	  (APTR)(STRING->String),textlength);
  return 1L;
}


TR_SIMPLEMETHOD(String,REMOVE)
{
  if(STRING->StrExt)
    TR_FreePooled(OBJECT->Project->trp_MemPool,(APTR)(STRING->StrExt),sizeof(struct StringExtend));
  return 1L;
}


TR_METHOD(String,SETATTRIBUTE,SetAttributeData)
{
  ULONG textlength;

  switch(data->attribute)
    {
    case TRAT_Value:
      STRING->MaxChars=(UWORD)(data->value);
      return 1;

    case TRAT_Flags:
      STRING->Flags=data->value;
      return 1;

    case TRST_Filter:
      textlength=TR_FirstOccurance(0,(STRPTR)(data->value))+1;
      if(!(STRING->Filter=
	   (STRPTR)TR_AllocPooled(OBJECT->Project->trp_MemPool,textlength)))
	return 0;
      CopyMem((APTR)(data->value),(APTR)(STRING->Filter),textlength);
      return 1;

    case 0:
      if(!(data->value)) data->value=(ULONG)nullstr;
      if(STRING->String) FreeVec((APTR)(STRING->String));
      textlength=TR_FirstOccurance(0,(STRPTR)(data->value))+1;
      if(!(STRING->String=AllocVec(textlength, MEMF_ANY))) return 0;
      CopyMem((APTR)(data->value),(APTR)(STRING->String),textlength);
      if(DISPLAYOBJECT->Installed)
	GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,NULL,
			  GTST_String,STRING->String,GA_Disabled,TR_DO_DISABLED,
			  TAG_END);
      return 1;

    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(String,GETATTRIBUTE)
{
  switch((ULONG)data)
    {
    case 0:
      return (ULONG)
	(((struct StringInfo *)(((struct Gadget *)DISPLAYOBJECT->PrivData)->SpecialInfo))->Buffer);
    default:
      return TRDP_DisplayObject_GETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(String,KEYDOWN)
{
  ActivateGadget((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,NULL);
  OBJECT->Project->trp_CurrentID=0;
  OBJECT->Project->trp_IsShortcutDown=FALSE;
  return 1;
}


TR_SIMPLEMETHOD(String,DISABLED_ENABLED)
{
  GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,NULL,
		    GA_Disabled,TR_DO_DISABLED,TAG_END);
  return 1;
}


TR_METHOD(String,EVENT,EventData)
{
  struct TR_Message *m;

  if((data->imsg->Class==IDCMP_GADGETUP)&&(data->imsg->IAddress==(APTR)(DISPLAYOBJECT->PrivData)))
    if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
      {
	m->trm_ID=DISPLAYOBJECT->ID;
	m->trm_Class=TRMS_NEWVALUE;
	m->trm_Data=(ULONG)
	  (((struct StringInfo *)(((struct Gadget *)DISPLAYOBJECT->PrivData)->SpecialInfo))->Buffer);
	return TROM_EVENT_SWALLOWED;
      }
  return TROM_EVENT_CONTINUE;
}


TR_SIMPLEMETHOD(String,DISPOSE)
{
  // if(STRING->WorkBuffer) TR_FreePooled((void *)(STRING->WorkBuffer),STRING->MaxChars);
  // Not needed; the entire pool gets deleted
  if(STRING->String) FreeVec((APTR)(STRING->String));
  return 1;
}


TR_SIMPLEMETHOD(String,ACTIVATE)
{
  if((struct Gadget *)DISPLAYOBJECT->PrivData)
    {
      TR_DoMethodID(OBJECT->Project, OBJECT->Project->trp_CurrentID, TROM_KEYCANCELLED, NULL);
      //TR_DoShortcut(OBJECT->Project, 0, TR_SHORTCUT_CANCELLED, NULL);
      return ActivateGadget((struct Gadget *)DISPLAYOBJECT->PrivData,
			    OBJECT->Project->trp_Window,NULL);
    }
  return 0;
}
