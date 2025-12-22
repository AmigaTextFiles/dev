/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1992 by Torsten Jürgeleit
 *
 *	Name .....: msg.c
 *	Created ..: Wednesday 12-Feb-92 20:49:35
 *	Revision .: 3
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	16-Sep-92   Torsten Jürgeleit      list of listview gadget now
 *					   removed in free_text_list()
 *					   BEFORE freeing list entries
 *	14-Sep-92   Torsten Jürgeleit      now listview scrollable with
 *					   cursor keys
 *	27-Apr-92   Torsten Jürgeleit      now uses global data structure
 *					   and supports serial io
 *	12-Feb-92   Torsten Jürgeleit      Created this file !
 ****************************************************************************
 *
 *	Support routines for message handling
 *
 * $Revision Header ********************************************************/

	/* Includes */

#include "includes.h"
#include "defines.h"
#include "imports.h"
#include "protos.h"

	/* Perform action appropriate to given intuition message */

   SHORT
perform_intuition_message(struct FarData  *fd, struct IntuiMessage  *im)
{
   USHORT code = im->Code;
   LONG   value = (LONG)im->IAddress;
   SHORT  status = STATUS_NORMAL;

   switch (im->Class) {
      case CLOSEWINDOW :
	 status = STATUS_QUIT;
	 break;

      case RAWKEY :

	 /* Check if cursor keys pressed for listview */
	 {
	    USHORT qualifier = im->Qualifier & ~(IEQUALIFIER_RELATIVEMOUSE |
							IEQUALIFIER_REPEAT),
		   lines = fd->fd_ListViewLines;
	    LONG   old_top, new_top, num = fd->fd_NumFarMessages;

	    /*
	     * Get current top of listview gadget - no USE_CURRENT_VALUE for
	     * data1 due to an error in intuisup.library < 4.6
	     */
	    old_top = ISetGadgetAttributes(fd->fd_GadgetList, GADGET_LIST,
		  0L, 0L, 0L, USE_CURRENT_VALUE, (VOID *)USE_CURRENT_VALUE);

	    /* Check if cursor keys pressed for listview */
	    new_top = old_top;
	    switch (code) {
	       case CURSORUP :   /* from intuition.h */
		  if (qualifier == IEQUALIFIER_LALT ||
					    qualifier == IEQUALIFIER_RALT) {
		     if (num > lines) {
			new_top = 0L;
		     }
		  } else {
		     if (qualifier == IEQUALIFIER_LSHIFT ||
					  qualifier == IEQUALIFIER_RSHIFT) {
			if (num > lines && (new_top -= lines) < 0L) {
			   new_top = 0L;
			}
		     } else {
			if (!qualifier) {
			   if (num > lines && --new_top < 0L) {
			      new_top = 0L;
			   }
			}
		     }
		  }
		  break;

	       case CURSORDOWN :   /* from intuition.h */
		  if (qualifier == IEQUALIFIER_LALT ||
					    qualifier == IEQUALIFIER_RALT) {
		     if (num > lines) {
			new_top = num - lines;
		     }
		  } else {
		     if (qualifier == IEQUALIFIER_LSHIFT ||
					  qualifier == IEQUALIFIER_RSHIFT) {
			if (num > lines && (new_top += fd->fd_ListViewLines)
							  > (num - lines)) {
			   new_top = num - lines;
			}
		     } else {
			if (!qualifier) {
			   if (num > lines && ++new_top > (num - lines)) {
			      new_top = old_top;
			   }
			}
		     }
		  }
		  break;
	    }
	    if (new_top != old_top) {

	       /* Set new top value of listview gadget */
	       ISetGadgetAttributes(fd->fd_GadgetList, GADGET_LIST, 0L, 0L,
		     USE_CURRENT_VALUE, new_top, (VOID *)USE_CURRENT_VALUE);
	    }
	 }
	 break;

      case NEWSIZE :
	 status = STATUS_RESIZE;
	 break;

      case ISUP_ID :

	 /* Perform gadget action */
	 switch (code) {
	    case GADGET_INPUT :

	       /* Init and reply pending far request */
	       {
		  struct FarMessage  *fm;

		  if (fm = fd->fd_InputFarMessage) {
		     if (fm->fm_Command == FM_REQTXT) {
			strcpy(fm->fm_Text, (BYTE *)value);
		     } else {
			fm->fm_Text = (BYTE *)value;
		     }
		     delete_message(fm);
		     fd->fd_InputFarMessage = NULL;
		  }
		  status = STATUS_RESIZE;
	       }
	       break;

	    case GADGET_STOP :
	       if (value) {
		  fd->fd_Flags |= FARPRINT_FLAG_STOPPED;
	       } else {
		  fd->fd_Flags &= ~FARPRINT_FLAG_STOPPED;
	       }
	       break;

	    case GADGET_REFRESH :
	       if (value) {
		  fd->fd_Flags |= FARPRINT_FLAG_REFRESH;
		  ISetGadgetAttributes(fd->fd_GadgetList, GADGET_LIST, 0L,
				   0L, USE_CURRENT_VALUE, USE_CURRENT_VALUE,
					    (VOID *)&fd->fd_FarMessageList);
	       } else {
		  fd->fd_Flags &= ~FARPRINT_FLAG_REFRESH;
	       }
	       break;
	 }
	 break;

      case MENUPICK :

	 /* Perform menu action */
	 switch (MENUNUM(code)) {
	    case MENU_PROJECT :
	       switch (ITEMNUM(code)) {
		  case ITEM_PROJECT_SERIAL :

		     /* Open or close serial device */
		     if (fd->fd_Flags & FARPRINT_FLAG_SERIAL) {
			struct MenuItem  *mi;
			APTR ml = fd->fd_MenuList;

			/* Unselect menu item SERIAL */
			IRemoveMenu(ml);
			if ((mi = IMenuItemAddress(ml,
						   SHIFTMENU(MENU_PROJECT) |
					 SHIFTITEM(ITEM_PROJECT_SERIAL)))) {
			   mi->Flags &= ~CHECKED;
			}
			IAttachMenu(fd->fd_Window, ml);
			close_serial(fd);
		     } else {
			status = open_serial(fd);
		     }
		     break;

		  case ITEM_PROJECT_FLUSH :
		     flush_messages(fd);
		     break;

		  case ITEM_PROJECT_CLEAR :
		     free_text_list(fd);
		     break;

		  case ITEM_PROJECT_MARK :
		     add_text(fd, MARK_LINE_TEXT);
		     break;

		  case ITEM_PROJECT_SAVE :
		     save_text_list(fd);
		     break;

		  case ITEM_PROJECT_ABOUT :
		     about_requester(fd);
		     break;

		  case ITEM_PROJECT_QUIT :
		     status = STATUS_QUIT;
		     break;
				  
	       }
	       break;
	 }
	 break;
   }
   return(status);
}
	/* Perform action appropriate to given far message */

   SHORT
perform_far_message(struct FarData  *fd, struct FarMessage  *fm)
{
   SHORT status = STATUS_NORMAL;

   switch (fm->fm_Command) {
      case FM_ADDTXT :

	 /* Add mesage text to list and refresh display */
	 status = add_text(fd, fm->fm_Text);
	 break;

      case FM_REQNUM :
      case FM_REQTXT :

	 /* External caller requests input */
	 fd->fd_InputFarMessage = fm;
	 status                 = STATUS_RESIZE;
	 break;
   }
   return(show_error(fd, status));
}
	/* Delete custom message structure or reply it (as approriate) */

   VOID
delete_message(struct FarMessage  *fm)
{
   if (fm) {
      switch (fm->fm_Command) {
	 case FM_ADDTXT :
	    FreeMem(fm, (LONG)fm->fm_ExecMessage.mn_Length);
	    break;

	 case FM_REQNUM :
	 case FM_REQTXT :
	    ReplyMsg((struct Message *)fm);
	    break;
      }
   }
}
	/* Flush all queued messages */

   VOID
flush_messages(struct FarData  *fd)
{
   struct Message  *msg;

   IChangeMousePointer(fd->fd_Window, NULL, TRUE);
   while (msg = GetMsg(fd->fd_FarPort)) {
      delete_message((struct FarMessage *)msg);
   }
   IRestoreMousePointer(fd->fd_Window);
}
	/* Add message to the current list of recorded texts */

   SHORT
add_text(struct FarData  *fd, BYTE *text)
{
   SHORT status = STATUS_NORMAL;

   if (text) {
      struct FarText  *ft;
      BYTE   *ptr;
      USHORT i, len = strlen(text), retries = MAX_ALLOC_RETRIES;
      LONG   size = sizeof(struct FarText) + len;

      /* Strip all non printable characters from text */
      for (i = 0, ptr = text; i < len; i++, ptr++) {
	 BYTE c = *ptr & 0x7f;

	 /* Use blank if character not printable */
	 if (c < ' ' || c > '~') {
	    *ptr = ' ';

	    /* If 0x07 (bell) given then flash display */
	    if (c == '\a') {
	       DisplayBeep(NULL);
	    }
	 }
      }

      /* Allocate FarText structure and add it to list */
      do {

	 /* Try to allocate FarText structure */
	 if (!(ft = DosAllocMem(size))) {

	    /* Free oldest FarText structure and try again */
	    if (ft = (struct FarText *)
			   RemHead((struct List *)&fd->fd_FarMessageList)) {
	       DosFreeMem(ft);
	    }
	 } else {

	    /* Init FarText structure with given text */
	    ft->ft_Node.ln_Name = &ft->ft_Buffer[0];
	    strcpy(&ft->ft_Buffer[0], text);

	    /* Add new FarText to list */
	    AddTail((struct List *)&fd->fd_FarMessageList, &ft->ft_Node);
	    fd->fd_NumFarMessages++;
	 }
      } while (!ft && retries);

      /* Check if allocation failed */
      if (!ft) {
	 status = ERROR_OUT_OF_MEM;
      } else {

	 /* Refresh message list */
	 if (fd->fd_Flags & FARPRINT_FLAG_REFRESH) {
	    ISetGadgetAttributes(fd->fd_GadgetList, GADGET_LIST, 0L, 0L,
				   USE_CURRENT_VALUE, fd->fd_NumFarMessages,
					    (VOID *)&fd->fd_FarMessageList);
	 }
      }
   }
   return(status);
}
	/* Frees the list of recorded messages */

   VOID
free_text_list(struct FarData  *fd)
{
   struct List     *list = (struct List *)&fd->fd_FarMessageList;
   struct FarText  *ft;

   IChangeMousePointer(fd->fd_Window, NULL, TRUE);
   ISetGadgetAttributes(fd->fd_GadgetList, GADGET_LIST, 0L, 0L,
				USE_CURRENT_VALUE, USE_CURRENT_VALUE, NULL);
   while (ft = (struct FarText *)RemHead(list)) {
      DosFreeMem(ft);
   }
   fd->fd_NumFarMessages = 0L;
   IRestoreMousePointer(fd->fd_Window);
}
	/* Save list of recorded messages to disk */
	
   SHORT
save_text_list(struct FarData  *fd)
{
   struct List  *lh = (struct List *)&fd->fd_FarMessageList;
   SHORT status = STATUS_NORMAL;

   /* First check if text list are empty */
   if (lh->lh_TailPred != (struct Node *)lh) {
      struct FileRequester  *fr = fd->fd_FileRequester;

      /* Call ARP file requester and check if user selected ok */
      IChangeMousePointer(fd->fd_Window, NULL, TRUE);
      if (!FileRequest(fr)) {
	 DisplayBeep(NULL);
      } else {
	 BPTR fh;
	 BYTE *path = &fd->fd_PathBuffer[0];

	 /* Build full path for file */
	 strcpy(path, fr->fr_Dir);
	 TackOn(path, fr->fr_File);

	 /* Check if file already exists and inform user */
	 if (fh = Open(path, (LONG)MODE_OLDFILE)) {
	    Close(fh);
	 }
	 if (!fh || ok_cancel_requester(fd, " Save ", "File already exists."
		       "\\n\\nDo you really want to write over?") == TRUE) {
	    /* Open save file */
	    if (!(fh = Open(path, (LONG)MODE_NEWFILE))) {
	       status = ERROR_OPEN_FAILED;
	    } else {
	       struct FarText  *ft = (struct FarText *)lh->lh_Head;

	       /* Write text list to file */
	       do {
		  if (FPrintf(fh, "%s\n", &ft->ft_Buffer[0]) == -1L) {
		     status = ERROR_WRITE_FAILED;
		  } else {
		     ft = (struct FarText *)ft->ft_Node.ln_Succ;
		  }
	       } while (status == STATUS_NORMAL && ft->ft_Node.ln_Succ);
	       Close(fh);
	    }
	 }
      }
      IRestoreMousePointer(fd->fd_Window);
   }
   return(show_error(fd, status));
}
