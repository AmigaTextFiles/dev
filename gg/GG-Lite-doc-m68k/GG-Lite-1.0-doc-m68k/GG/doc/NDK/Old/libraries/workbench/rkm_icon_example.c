;/* rkm_icon_example.c - Execute me to compile me with Lattice 5.04
LC -b1 -cfistq -v -y -j73 rkm_icon_example.c
Blink FROM LIB:c.o,rkm_icon_example.o TO rkm_icon_example LIBRARY LIB:LC.lib,LIB:Amiga.lib
quit
*/

/* RKM_Icon_Example.c - Workbench icon startup, creation, and parsing example
 *
 * Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

#include <exec/types.h>
#include <libraries/dos.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>
#ifdef LATTICE
#include <proto/all.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int CXBRK(void) { return(0); }		/* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }	/* really */
#endif

/* our functions */
void cleanexit(UBYTE *,LONG);
void cleanup(void);
void message(UBYTE *);
BOOL makeIcon(UBYTE *, char **, char *);
BOOL showToolTypes(struct WBArg *);


UBYTE *projname = "RAM:Example_Project";
UBYTE *conwinname = "CON:10/10/620/180/RKM_Icon_Example";

char deftoolname[] = "RKM_Icon_Example";

USHORT IconImageData1[] = {
/* Plane 0 */
    0x0000,0x0000,0x0000,0x3fff,0xffcc,0x0000,0x3fff,0xffcf,
    0x0000,0x3fff,0xffcf,0xc000,0x3803,0xffcf,0xf000,0x3fff,
    0xffc0,0x0000,0x3803,0xffff,0xfc00,0x3fff,0xffff,0xfc00,
    0x3fff,0xffff,0xfc00,0x3f84,0x00c0,0x7c00,0x3fff,0xffff,
    0xfc00,0x3900,0x8000,0x7c00,0x3fff,0xffff,0xfc00,0x3800,
    0x0040,0x7c00,0x3fff,0xffff,0xfc00,0x3fff,0xffff,0xfc00,
    0x3fff,0xfe00,0x7c00,0x3fff,0xffff,0xfc00,0x3fff,0xffff,
    0xfc00,0x0000,0x0000,0x0000,
/* Plane 1 */
    0xffff,0xfffc,0x0000,0xc000,0x0033,0x0000,0xc000,0x0030,
    0xc000,0xc000,0x0030,0x3000,0xc7fc,0x0030,0x0c00,0xc000,
    0x003f,0xff00,0xc7fc,0x0000,0x0300,0xc000,0x0000,0x0300,
    0xc000,0x0000,0x0300,0xc07b,0xff3f,0x8300,0xc000,0x0000,
    0x0300,0xc6ff,0x7fff,0x8300,0xc000,0x0000,0x0300,0xc7ff,
    0xffbf,0x8300,0xc000,0x0000,0x0300,0xc000,0x0000,0x0300,
    0xc000,0x01ff,0x8300,0xc000,0x0000,0x0300,0xc000,0x0000,
    0x0300,0xffff,0xffff,0xff00,
    };

struct Image iconImage1 = 
    {
    0, 0,                /* Top Corner */
    40, 20, 2,           /* Width, Height, Depth */
    &IconImageData1[0],  /* Image Data */
    0x003, 0x000,        /* PlanePick,PlaneOnOff */
    NULL                 /* Next Image */
    };

UBYTE *toolTypes[] = 
    {
    "FILETYPE=text",
    "FLAGS=BOLD|ITALICS",
    NULL
    };

struct DiskObject projIcon = 
    {
    WB_DISKMAGIC,                   /* Magic Number */
    WB_DISKVERSION,                 /* Version */
        {                           /* Embedded Gadget Structure */
        NULL,                       /* Next Gadget Pointer */
        97,12,40,21,                /* Left,Top,Width,Height */
        GADGIMAGE|GADGHBOX,         /* Flags */
        GADGIMMEDIATE|RELVERIFY,    /* Activation Flags */
        BOOLGADGET,                 /* Gadget Type */
        (APTR)&iconImage1,          /* Render Image */
        NULL,                       /* Select Image */
        NULL,                       /* Gadget Text */
        NULL,                       /* Mutual Exclude */
        NULL,                       /* Special Info */
        0,                          /* Gadget ID */
        NULL                        /* User Data */
        },
    WBPROJECT,                      /* Icon Type */
    deftoolname,                    /* Default Tool */
    toolTypes,                      /* Tool Type Array */
    NO_ICON_POSITION,               /* Current X */
    NO_ICON_POSITION,               /* Current Y */
    NULL,                           /* Drawer Structure */
    NULL,                           /* Tool Window */
    4000                            /* Stack Size */
    };


/* Opens and allocations we must clean up */
struct Library *IconBase = NULL;
FILE *conwin = NULL;
LONG olddir = -1;

BOOL FromWb;

void main(int argc, char **argv)
    {
    struct WBStartup *WBenchMsg;
    struct WBArg *wbarg;
    FILE  *file;
    LONG  wLen;
    SHORT i;

    FromWb = (argc==0) ? TRUE : FALSE;
    
    /* Open icon.library */
    if(!(IconBase = OpenLibrary("icon.library",33)))
         cleanexit("Can't open icon.library\n",RETURN_FAIL);

    /* If started from cli, this example will create
     * a small text file RAM:Example_Project, and
     * create an icon for the file which points
     * to this program as its default tool.
     */
    if(!FromWb)
        {
        /* Make a sample project (data) file */
        wLen = -1;
        if(file=fopen(projname,"w"))
            {
            wLen = fprintf(file,"Have a nice day\n");
            fclose(file);
            }
        if(wLen < 0) cleanexit("Error writing data file\n",RETURN_FAIL);
       
        /* Now save/update icon for this data file */
        if(makeIcon(projname, toolTypes, deftoolname))
             {
             printf("%s data file and icon saved.\n",projname); 
             printf("Use Workbench Info to examine the icon.\n");
             printf("Then copy this example (RKM_Icon_Example) to RAM:\n");
             printf("and double-click the %s project icon\n",projname);
             }
        else cleanexit("Error writing icon\n",RETURN_FAIL);
        }

    else  /* Else we are FromWb - ie. we were either
           * started by a tool icon, or as in this case,
           * by being the default tool of a project icon.
           */
        {
        if(!(conwin = fopen(conwinname,"r+")))
             cleanexit("Can't open output window\n",RETURN_FAIL);

        WBenchMsg = (struct WBStartup *)argv;

        /* Note wbarg++ at end of FOR statement steps through wbargs.
         * First arg is our executable (tool).  Any additional args
         * are projects/icons passed to us via either extend select
         * or default tool method.
         */
        for(i=0, wbarg=WBenchMsg->sm_ArgList; 
            i < WBenchMsg->sm_NumArgs; 
            i++, wbarg++)
            {
            /* if there's a directory lock for this wbarg, CD there */
            olddir = -1;
            if((wbarg->wa_Lock)&&(*wbarg->wa_Name)) 
                olddir = CurrentDir(wbarg->wa_Lock);

            showToolTypes(wbarg);
                
            if((i>0)&&(*wbarg->wa_Name)) 
                fprintf(conwin,"In Main. We could open the %s file here\n",
                                 wbarg->wa_Name);
            if(olddir != -1)  CurrentDir(olddir); /* CD back where we were */
            }
        Delay(500);
        }
    cleanup();
    exit(RETURN_OK);
    }

BOOL makeIcon(UBYTE *name, char **newtooltypes, char *newdeftool)
    {
    struct DiskObject *dobj;
    char *olddeftool;
    char **oldtooltypes;
    BOOL success = FALSE;

    if(dobj=GetDiskObject(name))
        {
        /* If file already has an icon, we will save off any fields we
         * need to update, update those fields, put the object, restore
         * the old field pointers and then free the object.  This will 
         * preserve any custom imagery the user has, and the user's
         * current placement of the icon.  If your application does
         * not know where the user currently keeps your application,
         * you should not update his dobj->do_DefaultTool.
         */
         oldtooltypes = dobj->do_ToolTypes;
         olddeftool = dobj->do_DefaultTool;

         dobj->do_ToolTypes = newtooltypes;
         dobj->do_DefaultTool = newdeftool;

         success = PutDiskObject(name,dobj);

         /* we must restore the original pointers before freeing */
         dobj->do_ToolTypes = oldtooltypes;
         dobj->do_DefaultTool = olddeftool;
         FreeDiskObject(dobj);
         }
    /* Else, put our default icon */
    if(!success)  success = PutDiskObject(name,&projIcon);
    return(success);
    }

BOOL showToolTypes(struct WBArg *wbarg)
    {
    struct DiskObject *dobj;
    char **toolarray;
    char *s;
    BOOL success = FALSE;

    fprintf(conwin,"\nWBArg Lock=0x%lx, Name=%s\n",
                           wbarg->wa_Lock,wbarg->wa_Name);

    if((*wbarg->wa_Name) && (dobj=GetDiskObject(wbarg->wa_Name)))
        {
        fprintf(conwin,"  We have read the DiskObject (icon) for this arg\n");
        toolarray = (char **)dobj->do_ToolTypes;

        if(s=(char *)FindToolType(toolarray,"FILETYPE"))
            {
            fprintf(conwin,"    Found tooltype FILETYPE with value %s\n",s);
            }
        if(s=(char *)FindToolType(toolarray,"FLAGS"))
            {
            fprintf(conwin,"    Found tooltype FLAGS with value %s\n",s);
            if(MatchToolValue(s,"BOLD")) 
                fprintf(conwin,"      BOLD flag requested\n");
            if(MatchToolValue(s,"ITALICS")) 
                fprintf(conwin,"      ITALICS flag requested\n");
            }
        /* Free the diskobject we got */
        FreeDiskObject(dobj);
        success = TRUE;
    	}
    else if(!(*wbarg->wa_Name))
        fprintf(conwin,"  Must be a disk or drawer icon\n");
    else 
        fprintf(conwin,"  Can't find DiskObject (icon) for this WBArg\n");
    return(success);
    }


/* Workbench-started programs with no output window
 * will want to display messages in a different manner
 * (requester, window title, etc) if FromWb is TRUE.
 */
void message(UBYTE *s)
    {
    if(FromWb && conwin)  fprintf(conwin,s,strlen(s));
    else if (!FromWb) printf(s);
    }

void cleanexit(UBYTE *s, LONG n)
    {
    if(*s)  message(s);
    cleanup();
    exit(n);
    }

void cleanup()
   {
   if(conwin)     fclose(conwin);
   if(IconBase)  CloseLibrary(IconBase);
   }

