/*
   mm.amiga.c           Amiga multi-media extensions

   Copyright (C) 1997 Tony Belding, <tlbelding@htcomp.net>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
#include "logo.h"
#include "globals.h"
#include "amiterm.h"

#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>
#include <graphics/displayinfo.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/layers_protos.h>

__near struct ReqToolsBase *ReqToolsBase = NULL;


NODE *lmm_screensize()
{
   return (cons(make_intnode((FIXNUM)screen_width),
      cons(make_intnode((FIXNUM)screen_height),NIL)));
}


NODE *lmm_pixel(NODE *args)
{
   NODE *xnode, *ynode = UNBOUND, *arg;
   FLONUM x, y;
   int ix, iy;

   arg = vector_arg(args);
   if (NOT_THROWING) {
      xnode = car(arg);
      ynode = cadr(arg);

      x = ((nodetype(xnode) == FLOATT) ? getfloat(xnode) :
           (FLONUM)getint(xnode));
      y = ((nodetype(ynode) == FLOATT) ? getfloat(ynode) :
           (FLONUM)getint(ynode));

      ix = x2screen(x*x_scale);
      iy = y2screen(y*y_scale);

      return (cons(make_intnode(ix),cons(make_intnode(iy),NIL)));
   }
   return(UNBOUND);
}


NODE *lmm_turtle(NODE *args)
{
   NODE *xnode, *ynode = UNBOUND, *arg;
   FLONUM x, y;

   arg = vector_arg(args);
   if (NOT_THROWING) {
      xnode = car(arg);
      ynode = cadr(arg);

      x = ((nodetype(xnode) == FLOATT) ? getfloat(xnode) :
           (FLONUM)getint(xnode));
      y = ((nodetype(ynode) == FLOATT) ? getfloat(ynode) :
           (FLONUM)getint(ynode));

      x = screen2x(x)/x_scale;
      y = screen2y(y)/y_scale;

      return (cons(make_floatnode(x),cons(make_floatnode(y),NIL)));
   }
   return(UNBOUND);
}


NODE *lmm_alert(NODE *args)
{
   char *buffer;
   char msg[512], btn[80];
   int choice = -1;

   if (NOT_THROWING) {
      int ctr, index;
      BOOL close;

      buffer = AllocVec(512L,MEMF_CLEAR);

      print_stringptr = buffer;
      print_stringlen = 510;
      print_node(NULL,car(args));

      for (ctr=0, index=0, close=FALSE; buffer[ctr]; ctr++) {
         if (buffer[ctr]=='[')
            continue;
         if (buffer[ctr]==']') {
            close = TRUE;
            continue;
         }
         if (buffer[ctr]==' ' && close) {
            msg[index++] = '\n';
            close = FALSE;
            continue;
         }
         close = FALSE;
         msg[index++] = buffer[ctr];
      }
      msg[index] = '\0';

      for (ctr=0; ctr<=80; ctr++)   /* clear the buffer */
         buffer[ctr] = '\0';

      print_stringptr = buffer;
      print_stringlen = 79;
      print_node(NULL,cadr(args));

      for (ctr=0, index=0, close=FALSE; buffer[ctr]; ctr++) {
         if (buffer[ctr]=='[')
            continue;
         if (buffer[ctr]==']') {
            close = TRUE;
            continue;
         }
         if (buffer[ctr]==' ' && close) {
            btn[index++] = '|';
            close = FALSE;
            continue;
         }
         close = FALSE;
         btn[index++] = buffer[ctr];
      }
      btn[index] = '\0';

      FreeVec(buffer);

      ReqToolsBase=(struct ReqToolsBase *)OpenLibrary(REQTOOLSNAME,REQTOOLSVERSION);
      if (ReqToolsBase) {
         choice = rtEZRequestTags(msg,btn,NULL,NULL,
            RT_ReqPos,     REQPOS_CENTERWIN,
            RT_LockWindow, TRUE,
            RT_Window,     win,
            TAG_DONE);

         CloseLibrary((APTR)ReqToolsBase);
      }
   }
   return make_intnode((FIXNUM)choice);
}


NODE *lmm_getlist(NODE *args)
{
   char *buffer;
   char msg[512], btn[80];
   int choice = -1;
   NODE *oplist=NULL;
   NODE *opnum=NULL;

   if (NOT_THROWING) {
      int ctr, index;
      BOOL close;

      buffer = AllocVec(512L,MEMF_CLEAR);

      print_stringptr = buffer;
      print_stringlen = 510;
      print_node(NULL,car(args));
      args = cdr(args);

      for (ctr=0, index=0, close=FALSE; buffer[ctr]; ctr++) {
         if (buffer[ctr]=='[')
            continue;
         if (buffer[ctr]==']') {
            close = TRUE;
            continue;
         }
         if (buffer[ctr]==' ' && close) {
            msg[index++] = '\n';
            close = FALSE;
            continue;
         }
         close = FALSE;
         msg[index++] = buffer[ctr];
      }
      msg[index] = '\0';

      for (ctr=0; ctr<=80; ctr++)   /* clear the buffer */
         buffer[ctr] = '\0';

      print_stringptr = buffer;
      print_stringlen = 78;
      print_node(NULL,car(args));
      args = cdr(args);

      for (ctr=0, index=0, close=FALSE; buffer[ctr]; ctr++) {
         if (buffer[ctr]=='[')
            continue;
         if (buffer[ctr]==']') {
            close = TRUE;
            continue;
         }
         if (buffer[ctr]==' ' && close) {
            btn[index++] = '|';
            close = FALSE;
            continue;
         }
         close = FALSE;
         btn[index++] = buffer[ctr];
      }
      btn[index] = '\0';

      {
         char *zbuf=AllocVec(512L,MEMF_CLEAR);
         int ctr=0;

         for (;ctr<512;buffer[ctr++]='\0') ;
         if (zbuf && args!=NIL) {
            print_stringptr = zbuf;
            print_stringlen = 510;
            print_node(NULL,car(args));
            strncpy(buffer,zbuf+1,strlen(zbuf)-2);
            FreeVec(zbuf);
         }
      }

      ReqToolsBase=(struct ReqToolsBase *)OpenLibrary(REQTOOLSNAME,REQTOOLSVERSION);
      if (ReqToolsBase) {
         choice = rtGetString(buffer,511L,NULL,NULL,
            RT_ReqPos,     REQPOS_CENTERWIN,
            RT_LockWindow, TRUE,
            RT_Window,     win,
            RTGS_GadFmt,   btn,
            RTGS_TextFmt,  msg,
            TAG_DONE);

         opnum = make_intnode(choice);

         if (buffer[0])
            oplist = parser(make_static_strnode(buffer));

         CloseLibrary((APTR)ReqToolsBase);
      }

      FreeVec(buffer);
   }

   return cons(opnum,cons(oplist,NIL));
}


NODE *lmm_getint(NODE *args)
{
   char *buffer;
   char msg[512], btn[80];
   int choice = -1;
   ULONG longvar;
   ULONG tags[20], i=0L;
   NODE *opchoice=NULL;
   NODE *opnum=NULL;

   if (NOT_THROWING) {
      int ctr, index;
      BOOL close;

      buffer = AllocVec(512L,MEMF_CLEAR);

      print_stringptr = buffer;
      print_stringlen = 510;
      print_node(NULL,car(args));
      args = cdr(args);

      for (ctr=0, index=0, close=FALSE; buffer[ctr]; ctr++) {
         if (buffer[ctr]=='[')
            continue;
         if (buffer[ctr]==']') {
            close = TRUE;
            continue;
         }
         if (buffer[ctr]==' ' && close) {
            msg[index++] = '\n';
            close = FALSE;
            continue;
         }
         close = FALSE;
         msg[index++] = buffer[ctr];
      }
      msg[index] = '\0';

      for (ctr=0; ctr<=80; ctr++)   /* clear the buffer */
         buffer[ctr] = '\0';

      print_stringptr = buffer;
      print_stringlen = 78;
      print_node(NULL,car(args));
      args = cdr(args);

      for (ctr=0, index=0, close=FALSE; buffer[ctr]; ctr++) {
         if (buffer[ctr]=='[')
            continue;
         if (buffer[ctr]==']') {
            close = TRUE;
            continue;
         }
         if (buffer[ctr]==' ' && close) {
            btn[index++] = '|';
            close = FALSE;
            continue;
         }
         close = FALSE;
         btn[index++] = buffer[ctr];
      }
      btn[index] = '\0';
      FreeVec(buffer);

      longvar = 0L;
      if (args!=NIL) {
         longvar = getint(car(args));
         args = cdr(args);
         if (args!=NIL) {
            tags[i++] = RTGL_Min;      tags[i++] = getint(car(args));
            args = cdr(args);
            if (args!=NIL) {
               tags[i++] = RTGL_Max;      tags[i++] = getint(car(args));
            }
         }
      }
      tags[i++] = RT_ReqPos;        tags[i++] = REQPOS_CENTERWIN;
      tags[i++] = RT_LockWindow;    tags[i++] = TRUE;
      tags[i++] = RT_Window;        tags[i++] = win;
      tags[i++] = RTGL_GadFmt;      tags[i++] = btn;
      tags[i++] = RTGL_TextFmt;     tags[i++] = msg;
      tags[i++] = TAG_DONE;

      ReqToolsBase=(struct ReqToolsBase *)OpenLibrary(REQTOOLSNAME,REQTOOLSVERSION);
      if (ReqToolsBase) {
         choice = rtGetLongA(&longvar,NULL,NULL,tags);
         opchoice = make_intnode(choice);
         opnum = make_intnode(longvar);
         CloseLibrary((APTR)ReqToolsBase);
      }

   }
   return cons(opchoice,cons(opnum,NIL));
}

NODE *lmm_filerequest(NODE *args)
{
   if (NOT_THROWING) {
      int ctr, index;
      char path[108], name[108], pan[216];
      char title[80];
      char buffer[220];
      char *filename = NULL;
      int chosen = -1;

      for (ctr=0;ctr<220;buffer[ctr++]='\0')  ;
      for (ctr=0;ctr<108;path[ctr++]='\0')  ;
      for (ctr=0;ctr<108;name[ctr++]='\0')  ;
      for (ctr=0;ctr<216;pan[ctr++]='\0')  ;
      for (ctr=0;ctr<80;title[ctr++]='\0')  ;

      print_stringptr = buffer;
      print_stringlen = 219;
      print_node(NULL,car(args));
      args = cdr(args);
      if (buffer[0]=='[')
         strncpy(pan,buffer+1,(long)strlen(buffer)-2);
      else
         strncpy(pan,buffer,108L);

      /* split PAN into path and name */
      for (ctr=strlen(pan); ctr>=0; ctr--)
         if (pan[ctr]==':' || pan[ctr]=='/')
            break;
      if (ctr) {
         int limit = ++ctr;
         if (limit>108)
            limit = 108;
         strncpy(path,pan,limit);

         limit = strlen(pan)-ctr;
         if (limit>108)
            limit = 108;
         strncpy(name,pan+ctr,limit);
      } else {
         strcpy(path,"\0");
         strncpy(name,pan,108);
      }

      if (args==NIL)
         strcpy(title,"File Request:");
      else {
         for (ctr=0;ctr<220;buffer[ctr++]='\0')  ;

         print_stringptr = buffer;
         print_stringlen = 82;
         print_node(NULL,car(args));
         args = cdr(args);
         if (buffer[0]=='[')
            strncpy(title,buffer+1,(long)strlen(buffer)-2);
         else
            strncpy(title,buffer,80L);
      }

      ReqToolsBase=(struct ReqToolsBase *)OpenLibrary(REQTOOLSNAME,REQTOOLSVERSION);
      if (ReqToolsBase) {
         struct rtFileRequester *req = rtAllocRequest(RT_FILEREQ,TAG_DONE);

         if (req) {
            rtChangeReqAttr(req,
               RTFI_Dir,   path,
               TAG_END);

            chosen = rtFileRequest(req,name,title,
               RT_ReqPos,     REQPOS_CENTERWIN,
               RT_LockWindow, TRUE,
               RT_Window,     win,
               TAG_DONE );

            {  /* put the path and name back together into PAN */
               int dirlen = strlen(req->Dir);
               strcpy(path,req->Dir);
               strcpy(pan,path);
               if (dirlen)
                  if (path[dirlen-1]!='/' && path[dirlen-1]!=':')
                     strcat(pan,"/");
               strcat(pan,name);
               filename = pan;
            }

            rtFreeRequest(req);
         }
         CloseLibrary((APTR)ReqToolsBase);
      }
      if (filename && chosen)
         if (filename[0])
            return parser(make_static_strnode(filename));
      return NIL;
   }
   return UNBOUND;
}

NODE *lmm_waitclick(NODE *args)
{
   int x, y;

   ModifyIDCMP(win,IDCMP_MOUSEBUTTONS);
   {  /* handle the user actions here */
      struct IntuiMessage *message; /* the message the IDCMP sends us */

      /* useful for interpreting IDCMP messages */
      UWORD code;
      ULONG class;

      FOREVER {
         WaitPort(win->UserPort);
         while (message = GT_GetIMsg(win->UserPort)) {
            code = message->Code;  /* MENUNUM */
            class = message->Class;
            GT_ReplyIMsg(message);
            if (class==IDCMP_MOUSEBUTTONS) {
               if (code==SELECTUP) {
                  x = win->MouseX;
                  y = win->MouseY;
                  goto exit_waitclick;
               }
            }
         }
      }
   }
 exit_waitclick:
   ModifyIDCMP(win,NULL);
   return (cons(make_intnode(x),cons(make_intnode(y),NIL)));
}

NODE *lmm_waitkey(NODE *args)
{
   int inkey;

   ModifyIDCMP(win,IDCMP_VANILLAKEY);
   {  /* handle the user actions here */
      struct IntuiMessage *message; /* the message the IDCMP sends us */

      /* useful for interpreting IDCMP messages */
      UWORD code;
      ULONG class;

      FOREVER {
         WaitPort(win->UserPort);
         while (message = GT_GetIMsg(win->UserPort)) {
            code = message->Code;  /* MENUNUM */
            class = message->Class;
            GT_ReplyIMsg(message);
            if (class==IDCMP_VANILLAKEY) {
               inkey = code;
               goto exit_waitkey;
            }
         }
      }
   }
 exit_waitkey:
   ModifyIDCMP(win,NULL);
   return (make_intnode(inkey));
}

#if FALSE
NODE *lmm_showimage(NODE *args)
{
   int x, y;
   char infilename[216], buffer[218];

   for (x=0; x<216; infilename[x++]='\0') ;
   for (x=0; x<218; buffer[x++]='\0') ;

   print_stringptr = buffer;
   print_stringlen = 217;
   print_node(NULL,car(args));
   if (buffer[0]=='[')
      strncpy(infilename,buffer+1,(long)strlen(buffer)-2);
   else
      strncpy(infilename,buffer,215L);
   args = cdr(args);

   x = getint(car(args));
   args = cdr(args);

   y = getint(car(args));
//   printf("filename {%s} at %d,%d.\n",infilename,x,y);

   {
      struct Object *image;
      ULONG tags[8], i=0L;
      BOOL going=TRUE;

      tags[i++]=GA_Left;            tags[i++]=x;
      tags[i++]=GA_Top;             tags[i++]=y;
//      tags[i++]=ICA_TARGET;         tags[i++]=ICTARGET_IDCMP;
      tags[i++]=TAG_END;

      image = NewDTObjectA(infilename,tags);
      if (image) {
         AddDTObject(win,NULL,image,-1);
         RefreshDTObjectA(image,win,NULL,NULL);
      }
   }

   return(UNBOUND);
}
#endif

/* END OF LISTING */
