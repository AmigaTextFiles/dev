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


/****** triton.library/class_Group ******
*
*   NAME	
*	class_Group -- A grouping object
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TRGR_Horiz
*	TRGR_Vert
*
*   ATTRIBUTES
*	<Default>        : ULONG flags
*	                   - TRGR_PROPSHARE  : Divide objects
*	                                       proportionally
*	                   - TRGR_EQUALSHARE : Divide objects equally
*	                   - TRGR_PROPSPACES : Divide spaces
*	                                       proportionally
*	                   - TRGR_ARRAY      : Top group of an array. Lines
*	                                       or culumns can be built
*	                                       using TRGR_PROPSHARE groups.
*	                                       At least one group must
*	                                       be contained in an array.
*	                   - TRGR_ALIGN      : Align resizable objects in
*	                                       their secondary dimension
*	                   - TRGR_CENTER     : Center non-resizable
*	                                       objects in their secondary
*	                                       dimension
*	                   - TRGR_FIXHORIZ   : Don't allow horizontal
*	                                       resizing
*	                   - TRGR_FIXVERT    : Don't allow vertical
*	                                       resizing
*	                   - TRGR_INDEP (V2) : Group is independent of
*	                                       surrounding array
*	                   [create]
*	TRAT_ID          : ULONG objectid (V4)
*	                   [create]
*	<other>          : Treated as elements of the group
*	                   [create]
*	TRGR_End         : <unused> : Marks the end of the group
*	                   [create]
*
*   NOTES
*	An array group must contain at least one non-space object.
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <clib/alib_protos.h>
#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "group.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define GROUP object

#define CHILDOBJECT (&(child->O))
#define CHILDGROUP ((struct TROD_Group *)(child))


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_DEFAULTMETHOD(Group)
{
  ULONG width=0, height=0, spacewidth=0, spaceheight=0,left,top,maxsize,totalsize,newmaxsize;
  ULONG maxwidth=0, maxheight=0, maxspacewidth=0, maxspaceheight=0, newspacewidth, newspaceheight;
  struct TROD_DisplayObject *child=NULL, *child2;
  BOOL childresize;
  struct TROM_NewData newdata;
  struct TROM_InstallData installdata;
  ULONG objecttype;
  ULONG numobj=0,currobj;
  BOOL resizable;
  ULONG retval;
  struct TROM_SetAttributeData sadata;

  switch(messageid)
  {
    case TROM_NEW:

      NEWDATA->parseargs=FALSE;
      if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;
      objecttype=NEWDATA->objecttype; /* Are we horiz. or vert.? */
      GROUP->Flags=(ULONG)(NEWDATA->itemdata);
      NewList((struct List *)&(GROUP->ObjectList));

      /* Fill in the TROM_NewData fields for all child objects */
      newdata.project=NEWDATA->project;
      newdata.grouptype=objecttype;
      newdata.backfilltype=DISPLAYOBJECT->BackfillType;

      /* Set the resizability flags to their defaults */
      if(objecttype==TRGR_Horiz)
	{
	  if(GROUP->Flags&TRGR_PROPSPACES)
	    DISPLAYOBJECT->XResize=TRUE; else DISPLAYOBJECT->XResize=FALSE;
	  DISPLAYOBJECT->YResize=TRUE;
	}
      else
	{
	  if(GROUP->Flags&TRGR_PROPSPACES)
	    DISPLAYOBJECT->YResize=TRUE; else DISPLAYOBJECT->YResize=FALSE;
	  DISPLAYOBJECT->XResize=TRUE;
	}

      for(;;) /* Go through all child objects */
	continue_here:
	{
	  if(NEWDATA->firstitem->ti_Tag==TRGR_End) break; /* No more objects */

	  if(!child) /* No objects yet */
	    if((TR_GetTagType(NEWDATA->firstitem->ti_Tag)==TRTG_OAT)&&(NEWDATA->firstitem->ti_Tag!=TRGR_End))
	      {
		switch(NEWDATA->firstitem->ti_Tag)
		  {
		  case TRAT_ID:
		    DISPLAYOBJECT->ID=NEWDATA->firstitem->ti_Data;
		    break;
		  case TRAT_Disabled:
		    if(NEWDATA->firstitem->ti_Data) DISPLAYOBJECT->Flags|=TROB_DISPLAYOBJECT_DISABLED;
		    else DISPLAYOBJECT->Flags&=~TROB_DISPLAYOBJECT_DISABLED;
		    break;
		  default:
		    sadata.attribute=NEWDATA->firstitem->ti_Tag;
		    sadata.value=NEWDATA->firstitem->ti_Data;
		    TR_DoMethod(OBJECT,TROM_SETATTRIBUTE,(APTR)(&sadata));
		  }
		NEWDATA->firstitem++;
		goto continue_here;
	      }

	  /* Fill in the TROM_NewData fields for the next child object */
	  newdata.firstitem=(((struct TROM_NewData *)(data))->firstitem)+1;
	  newdata.objecttype=NEWDATA->firstitem->ti_Tag;
	  newdata.itemdata=NEWDATA->firstitem->ti_Data;
	  newdata.parseargs=TRUE;

	  /** Initialize the child object */
	  if(!(child=(struct TROD_DisplayObject *)TR_DoMethod(NULL,TROM_NEW,(APTR)&newdata)))
	    return NULL;
	  AddTail((struct List *)(&(GROUP->ObjectList)),(struct Node *)child);
	  NEWDATA->firstitem=newdata.firstitem;

	  /* Resizable object? */
	  if(GROUP->Flags&TRGR_PROPSPACES) /* Resizable spaces, fixed objects */
	    {
	      if(child->Flags&TROB_DISPLAYOBJECT_SPACE)
		resizable=TRUE;
	      else resizable=FALSE;
	    }
	  else /* Resizablility depends on object */
	    {
	      if(((objecttype==TRGR_Horiz)&&(child->XResize==TRUE))||
		 ((objecttype!=TRGR_Horiz)&&(child->YResize==TRUE)))
		resizable=TRUE;
	      else resizable=FALSE;
	    }

	  if(resizable)
	    {
	      numobj++;
	      width+=child->MinWidth;
	      height+=child->MinHeight;
	      maxwidth=max(maxwidth,child->MinWidth);
	      maxheight=max(maxheight,child->MinHeight);
	    }
	  else
	    {
	      spacewidth+=child->MinWidth;
	      spaceheight+=child->MinHeight;
	      maxspacewidth=max(maxspacewidth,child->MinWidth);
	      maxspaceheight=max(maxspaceheight,child->MinHeight);
	    }

	  /* Alter the resizability flags */
	  if(objecttype==TRGR_Horiz)
	    {
	      if(child->XResize==TRUE) DISPLAYOBJECT->XResize=TRUE;
	      if(child->YResize==FALSE) DISPLAYOBJECT->YResize=FALSE;
	    }
	  else
	    {
	      if(child->YResize==TRUE) DISPLAYOBJECT->YResize=TRUE;
	      if(child->XResize==FALSE) DISPLAYOBJECT->XResize=FALSE;
	    }
	}

      /* Primary dimension */

      if((NEWDATA->itemdata)&TRGR_EQUALSHARE)
	{
	  if(objecttype==TRGR_Horiz) width=(maxwidth*numobj)+spacewidth;
	  else height=(maxheight*numobj)+spaceheight;
	}
      else /* TRGR_PROPSHARE or TRGR_PROPSPACES */
	{
	  if(objecttype==TRGR_Horiz) width+=spacewidth;
	  else height+=spaceheight;
	}

      /* Secondary dimension */
      if(objecttype==TRGR_Horiz) height=max(maxheight,maxspaceheight);
      else width=max(maxwidth,maxspacewidth);

      NEWDATA->firstitem++; /* The first item for the next object */

      /* Fixed group? */
      if((NEWDATA->itemdata)&TRGR_FIXHORIZ) DISPLAYOBJECT->XResize=FALSE;
      if((NEWDATA->itemdata)&TRGR_FIXVERT) DISPLAYOBJECT->YResize=FALSE;

      if((NEWDATA->itemdata)&TRGR_ARRAY) /* Correct dimensions in arrays */
	{
	  for(numobj=0,totalsize=0;;numobj++,totalsize+=maxsize) /* Go through all 2nd level child objects */
	    {
	      /* Get maximum size */
	      maxsize=0;
	      childresize=TRUE;
	      for(child=(struct TROD_DisplayObject *)(GROUP->ObjectList.mlh_Head);
		  CHILDOBJECT->Node.mln_Succ;
		  child=(struct TROD_DisplayObject *)(CHILDOBJECT->Node.mln_Succ))
		{
		  if(((CHILDOBJECT->Class->trc_Tag==TRGR_Horiz)||
		      (CHILDOBJECT->Class->trc_Tag==TRGR_Vert))
		     &&(!(CHILDGROUP->Flags&TRGR_INDEP)))
		  { /* Get dimensions of embedded groups */
		    for(currobj=0,child2=(struct TROD_DisplayObject *)
			  (CHILDGROUP->ObjectList.mlh_Head);
			(child2->O.Node.mln_Succ->mln_Succ)&&(currobj<numobj);
			child2=(struct TROD_DisplayObject *)
			  (child2->O.Node.mln_Succ), currobj++);
		    if(currobj==numobj)
		      {
			newmaxsize=(CHILDOBJECT->Class->trc_Tag==TRGR_Horiz)?
			  child2->MinWidth:child2->MinHeight;
			maxsize=max(maxsize,newmaxsize);
			if(CHILDOBJECT->Class->trc_Tag==TRGR_Horiz)
			  childresize=(!(child2->XResize))?FALSE:childresize;
			else childresize=(!(child2->YResize))?FALSE:childresize;
		      }
		  }
		}

	      if(!maxsize) break;

	      /* Set size in all objects */
	      for(child=(struct TROD_DisplayObject *)(GROUP->ObjectList.mlh_Head);
		  CHILDOBJECT->Node.mln_Succ;
		  child=(struct TROD_DisplayObject *)(CHILDOBJECT->Node.mln_Succ))
		{
		  if(((CHILDOBJECT->Class->trc_Tag==TRGR_Horiz)||
		      (CHILDOBJECT->Class->trc_Tag==TRGR_Vert))
		     &&(!(CHILDGROUP->Flags&TRGR_INDEP)))
		  { /* Set dimensions of embedded groups */
		    for(currobj=0,child2=(struct TROD_DisplayObject *)
			  (CHILDGROUP->ObjectList.mlh_Head);
			(child2->O.Node.mln_Succ->mln_Succ)&&(currobj<numobj);
			child2=(struct TROD_DisplayObject *)
			  (child2->O.Node.mln_Succ), currobj++);
		    if(currobj==numobj)
		      {
			if((child2->O.Class->trc_Tag!=TRGR_Horiz)&& //--
			   (child2->O.Class->trc_Tag!=TRGR_Vert))   //--
			if(CHILDOBJECT->Class->trc_Tag==TRGR_Horiz)
			  {
			    child->MinWidth=child->MinWidth-child2->MinWidth+maxsize;
			    child2->MinWidth=maxsize;
			  }
			else
			  {
			    child->MinHeight=child->MinHeight-child2->MinHeight+maxsize;
			    child2->MinHeight=maxsize;
			  }
			if(!childresize)
			  if(CHILDOBJECT->Class->trc_Tag==TRGR_Horiz) child2->XResize=FALSE;
			  else child2->YResize=FALSE;
		      }
		  }
		}
	    }

	  if(objecttype==TRGR_Horiz) height=totalsize; else width=totalsize;
	}

      DISPLAYOBJECT->MinWidth=width;
      DISPLAYOBJECT->MinHeight=height;

      return (ULONG)TR_AddObjectToIDList(OBJECT->Project, object);


  case TROM_INSTALL:

    TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);

    width=((struct TROM_InstallData *)(data))->width;
    height=((struct TROM_InstallData *)(data))->height;

    /* Go through all child objects and get their sizes */
    for(child=(struct TROD_DisplayObject *)(GROUP->ObjectList.mlh_Head);
	CHILDOBJECT->Node.mln_Succ;
	child=(struct TROD_DisplayObject *)(CHILDOBJECT->Node.mln_Succ))
      {
        /* Resizable object? */
        if(GROUP->Flags&TRGR_PROPSPACES) /* Resizable spaces, fixed objects */
	  {
	    if(child->Flags&TROB_DISPLAYOBJECT_SPACE)
	      resizable=TRUE;
	    else resizable=FALSE;
	  }
        else /* Resizablility depends on object */
	  {
	    if(((OBJECT->Class->trc_Tag==TRGR_Horiz)&&(child->XResize==TRUE))||
	       ((OBJECT->Class->trc_Tag!=TRGR_Horiz)&&(child->YResize==TRUE)))
	      resizable=TRUE;
	    else resizable=FALSE;
	  }

        if(resizable) /* Resizable */
	  {
	    numobj++;
	    maxwidth=max(maxwidth,child->MinWidth);
	    maxheight=max(maxheight,child->MinHeight);
	  }
        else /* Not resizable */
	  {
	    spacewidth+=child->MinWidth;
	    spaceheight+=child->MinHeight;
	    maxspacewidth=max(maxspacewidth,child->MinWidth);
	    maxspaceheight=max(maxspaceheight,child->MinHeight);
	  }
      }

    left=DISPLAYOBJECT->Left;
    top=DISPLAYOBJECT->Top;

    newspacewidth=spacewidth;
    newspaceheight=spaceheight;

    /* Go through all child objects and install them */
    for(child=(struct TROD_DisplayObject *)(GROUP->ObjectList.mlh_Head);
	CHILDOBJECT->Node.mln_Succ;
	child=(struct TROD_DisplayObject *)(CHILDOBJECT->Node.mln_Succ))
      {
        /* Resizable object? */
	if(GROUP->Flags&TRGR_PROPSPACES) /* Resizable spaces, fixed objects */
	  {
	    if(child->Flags&TROB_DISPLAYOBJECT_SPACE)
	      resizable=TRUE;
	    else resizable=FALSE;
	  }
        else /* Resizablility depends on object */
	  {
	    if(((OBJECT->Class->trc_Tag==TRGR_Horiz)&&(child->XResize==TRUE))||
	       ((OBJECT->Class->trc_Tag!=TRGR_Horiz)&&(child->YResize==TRUE)))
	      resizable=TRUE;
	    else resizable=FALSE;
	  }

        /* PRIMARY DIMENSION */
	if(GROUP->Flags&TRGR_EQUALSHARE)                     /* TRGR_EQUALSHARE */
	  {
	    if(OBJECT->Class->trc_Tag==TRGR_Horiz)
	      {
		if(resizable)
		  {
		    width=(DISPLAYOBJECT->Width-spacewidth)/numobj;       /* Proportional size */
		    spacewidth+=width; numobj--;                          /* Error correction */
		  }
		else width=child->MinWidth;                               /* Minimum size */
	      }
	    else                                                          /* Vertical */
	      {
		if(resizable)
		  {
		    height=(DISPLAYOBJECT->Height-spaceheight)/numobj;    /* Proportional size */
		    spaceheight+=height; numobj--;                        /* Error correction */
		  }
		else height=child->MinHeight;                             /* Minimum size */
	      }
	  }
	else                                                              /* TRGR_PROP... */
	  {
	    if(OBJECT->Class->trc_Tag==TRGR_Horiz)                        /* Horizontal */
	      {
		if(resizable)
		  {
		    width=child->MinWidth
		      *(DISPLAYOBJECT->Width-newspacewidth)
		      /(DISPLAYOBJECT->MinWidth-spacewidth);

		    /* Error correction */
		    newspacewidth+=width;
		    spacewidth+=child->MinWidth;
		    numobj--;
		  }
		else width=child->MinWidth;                               /* Minimum size */
	      }
	    else                                                          /* Vertical */
	      {
		if(resizable)
		  {
		    height=child->MinHeight
		      *(DISPLAYOBJECT->Height-newspaceheight)
		      /(DISPLAYOBJECT->MinHeight-spaceheight);
		    TR_DoMethod(CHILDOBJECT,TROM_GETBETTERHEIGHT,(APTR)(&height));

		    /* Error correction */
		    newspaceheight+=height;
		    spaceheight+=child->MinHeight;
		    numobj--;
		  }
		else height=child->MinHeight;                             /* Minimum size */
	      }
	  }

        /* SECONDARY DIMENSION */
	installdata.left=left;
	installdata.top=top;

	if(OBJECT->Class->trc_Tag==TRGR_Horiz)
	  {
	    installdata.height=child->MinHeight;
	    installdata.width=width;
	  }
	else
	  {
	    installdata.width=child->MinWidth;
	    installdata.height=height;
	  }

	if(GROUP->Flags&TRGR_ALIGN) /* Align the object */
	  {
	    if(OBJECT->Class->trc_Tag==TRGR_Horiz)
	      {
		if(child->YResize) installdata.height=DISPLAYOBJECT->Height;
	      }
	    else
	      {
		if(child->XResize) installdata.width=DISPLAYOBJECT->Width;
	      }
	  }
	if(GROUP->Flags&TRGR_CENTER) /* Center the object */
	  {
	    if(OBJECT->Class->trc_Tag==TRGR_Horiz)
	      {
		if(!(child->YResize))
		  installdata.top=top+(DISPLAYOBJECT->Height-child->MinHeight)/2;
	      }
	    else
	      {
		if(!(child->XResize))
		  installdata.left=left+(DISPLAYOBJECT->Width-child->MinWidth)/2;
	      }
	  }

	TR_DoMethod(CHILDOBJECT,TROM_INSTALL,(APTR)&installdata);         /* Install the object  */
	if(OBJECT->Class->trc_Tag==TRGR_Horiz) left+=width;               /* ...and calculate the... */
        else top+=height;                                                 /* ...new position         */
      }
    return 1;


  case TROM_EVENT: /* BROADCAST AN EVENT MESSAGE */

    /* Go through all child objects */
    for(child=(struct TROD_DisplayObject *)(GROUP->ObjectList.mlh_Head);
	CHILDOBJECT->Node.mln_Succ;
	child=(struct TROD_DisplayObject *)(CHILDOBJECT->Node.mln_Succ))
      {
        if(TR_DoMethod(CHILDOBJECT,messageid,data)==1) return 1;
      }
    return NULL;



  /* Ignore some methods */
  case TROM_CREATECLASS:
  case TROM_DISPOSECLASS:
  case TROM_GETBETTERHEIGHT:
    return NULL;


  default: /* ALL OTHER MESSAGES ARE JUST BROADCAST TO THE CHILD OBJECTS */

    TR_SUPERMETHOD;
    retval=1L;
    for(child=(struct TROD_DisplayObject *)(GROUP->ObjectList.mlh_Head);
	CHILDOBJECT->Node.mln_Succ;
	child=(struct TROD_DisplayObject *)(CHILDOBJECT->Node.mln_Succ))
      {
	/* If only one object fails,everything will fail      */
	if(TR_DoMethod(CHILDOBJECT,messageid,data)==FALSE) retval=NULL;
      }
    return retval;
  }
}
