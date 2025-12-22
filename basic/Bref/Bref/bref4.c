/* Name: bref4.c -- select input
	This is a modification of Anders Bjerin's FileWindow routine.
		Set TAB value to 3 for this listing.
	Invoked from bref.c which is main().
*/

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/libraries.h>
#include <exec/ports.h>
#include <exec/interrupts.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <libraries/dos.h>
#include <libraries/dosextens.h>
#include <intuition/intuition.h>
#include <string.h>

/* #include "FileWindow.h" */
/* Included code for  FileWindow.h */

/* What file_window() will return: */
#define GO      500
#define OPTION  600
#define HELP	 700
#define CANCEL  800
#define QUIT    900
#define PANIC1  1001
#define PANIC2  1002

/* The maximum size of the strings: */
#define DRAWER_LENGTH 100 /*  100 char's incl NULL. */
#define FILE_LENGTH    30 /*   30       -"-         */
#define TOTAL_LENGTH  130 /*  130       -"-         */

/* THE END of FileWindow.h */

#define igncase(c) (isupper(c)? tolower(c) : (c))	/* Ignore case--sort*/

/* Declare the functions we are going to use: */
USHORT FileWindow();
STRPTR right_pos();
APTR save_file_info();
BOOL file_comp();
BOOL directory();
BOOL last_check();
BOOL new_drawer();
BOOL pick_file();
void put_in();
void deallocate_file_info();
void change_device();
void parent();
void request_ok();
void display_list();
void connect_dir_file();
void adjust_string_gadgets();

extern struct IntuitionBase *IntuitionBase;

struct Window *file_window;
struct IntuiMessage *my_gadget_message;

/* Structure for memory allocate of each file/directory */
struct file_info
{
  BYTE name[28];          /* Name of the file/directory, 27 characters. */
  BOOL directory;         /* If it is a directory.                      */
  struct file_info *next; /* Pointer to the next file_info structure.   */
};

struct FileInfoBlock *file_info;
struct FileLock *lock, *Lock();

BOOL file_lock;  /* Have we locked a file?       */
BOOL more_files; /* More files in the directory? */
BOOL first_file; /* First file?                  */

struct file_info *first_pointer; /* Pointing to the first structure. */

/* ********************************************************************* */
/* * IntuiText structures for the requesters                           * */

struct IntuiText text_request={0,2,JAM1,15,5,NULL,NULL,NULL};

struct IntuiText ok_request={0, 2,JAM1,6, 3,NULL,"OK",NULL};

struct IntuiText option1_request={0, 2,JAM1,6, 3,NULL,NULL,NULL};

struct IntuiText option2_request={0, 2,JAM1,6, 3,NULL,NULL,NULL};

/* Values for a 4-letter box: */
SHORT points4[]={0,0,  44,0,  44,14,   0,14,   0,0};

/* Values for a 6-letter box: */
SHORT points6[]={0,0,  60,0,  60,14,   0,14,   0,0};

/* A border for a 4-letter box: */
struct Border border_text4={0, 0,1, 2, JAM1,5,points4,NULL};

/* A border for a 6-letter box: */
struct Border border_text6={0, 0,1, 2, JAM1,5,points6,NULL};

/* ********************************************************************* */
/* * Information for the help gadget */

struct IntuiText text_help = {3,0,JAM1,7,4,NULL,"HELP",NULL};

struct Gadget gadget_help = {NULL,360,40,61,15,GADGHCOMP,RELVERIFY,
	BOOLGADGET,&border_text4,NULL,&text_help,NULL,NULL,0,NULL};

/* ********************************************************************* */
/* * Information for the option gadget */

struct IntuiText text_option = {3,0,JAM1,7,4,NULL,"OPTION",NULL};

struct Gadget gadget_option = {&gadget_help,360,20,61,15,GADGHCOMP,
	RELVERIFY,BOOLGADGET,&border_text6,NULL,&text_option,NULL,NULL,0,NULL};

/*********************************************************************** */
/* * Information for the proportional gadget */

struct Image image_prop;

struct PropInfo prop_info=
{
  AUTOKNOB| /* We want to use the auto-knob. */
  FREEVERT, /* The knob should move vertically. */
  0,0,      /* HorizPot, VertPot: will be initialized later. */
  0,        /* HorizBody                 -"-                 */
  0xFFFF,   /* VertBody: No data to show, maximum. */
  
  0,0,0,0,0,0 /* Intuition sets and maintains these variables. */
};

struct Gadget gadget_proportional={&gadget_option,290, 50, 21, 72,GADGHCOMP,
  GADGIMMEDIATE|FOLLOWMOUSE|RELVERIFY, /* Activation */
  PROPGADGET,               /* GadgetType */
  (APTR) &image_prop,       /* GadgetRender */
  NULL,NULL,NULL,(APTR) &prop_info,NULL,NULL };

UBYTE name_backup[DRAWER_LENGTH];	/* String Gadgets Undo Buffer */

/* ********************************************************************* */
/* * Information for the string gadget "Drawer:"                       * */

UBYTE drawer_name[DRAWER_LENGTH];

/* Values for a 28-letter string box: */
SHORT points28s[]={-7,-4,  200,-4,  200,11,   -7,11,   -7,-4};

/* A border for a 28-letter string box: */
struct Border border_text28s={0, 0,1, 2, JAM1,5,points28s,NULL};

struct IntuiText text_drawer={1, 2,JAM1,-69, 0,NULL,"Drawer:",NULL};

struct StringInfo string_drawer={drawer_name,name_backup,0,70,0,
  0,0, 0,NULL,NULL,NULL,};

struct Gadget gadget_drawer=
{ &gadget_proportional,83, 35, 198, 8,
  GADGHCOMP,  RELVERIFY,  STRGADGET,(APTR) &border_text28s,
  NULL,&text_drawer,NULL,(APTR) &string_drawer,NULL,NULL};

/* ********************************************************************* */
/* * Information for the string gadget "File:"                         * */

UBYTE file_name[FILE_LENGTH];

/* Values for a 30-letter string box: */
SHORT points30s[]={-7,-4,  244,-4,  244,11,   -7,11,   -7,-4};

/* A border for a 30-letter string box: */
struct Border border_text30s={0, 0,1, 2, JAM1,5,points30s,NULL};

struct IntuiText text_file={1, 2,JAM1,-53, 0,NULL,"File:",NULL};

struct StringInfo string_file={file_name,name_backup,0,40,0,
  0,0, 0,NULL,NULL,NULL,};

struct Gadget gadget_file={&gadget_drawer,66, 129, 240, 8,GADGHCOMP,
  RELVERIFY,STRGADGET,(APTR) &border_text30s,
  NULL,&text_file,NULL,(APTR) &string_file,NULL,NULL};

/* ********************************************************************* */
/* * Information for the string gadget "Extension"                     * */

UBYTE extension_name[7]; /* 7 characters including NULL. */

/* Values for a 6-letter string box: */
SHORT points6s[]={-7,-4,  57,-4,  57,10,  -7,10,  -7,-4};

/* A border for a 6-letter string box: */
struct Border border_text6s={0,0,1,2,JAM1,5,points6s,NULL};

struct IntuiText text_extension={1, 2,JAM1,-45, 0,NULL,"Ext:",NULL};

struct StringInfo string_extension={extension_name,name_backup,0,7,0,
  0,0, 0,NULL,NULL,NULL,};

struct Gadget gadget_extension=
  {&gadget_file,263, 17, 59, 8,GADGHCOMP,RELVERIFY,STRGADGET,
  (APTR) &border_text6s,NULL,
  &text_extension,NULL,(APTR) &string_extension,NULL,NULL};

/* ********************************************************************* */
/* * Information for the boolean gadget parent "<"                     * */

/* Values for a 1-letter box: */
SHORT points1[]={0,0,  20,0,  20,15,   0,15,   0,0};

/* A border for a 1-letter box: */
struct Border border_text1={0, 0,1, 2, JAM1,5,points1,NULL};

struct IntuiText text_parent={1, 2,JAM1,7,4,NULL,"<",NULL};

struct Gadget gadget_parent=
 {&gadget_extension,290, 31, 21, 16,
  GADGHCOMP,RELVERIFY,BOOLGADGET,(APTR) &border_text1,
  NULL,&text_parent,NULL,NULL,NULL,NULL};

/* ********************************************************************* */
/* * Information for the boolean gadget "ram:"                         * */

struct IntuiText text_ram={1, 2,JAM1,7,4,NULL,"ram:",NULL};

struct Gadget gadget_ram={&gadget_parent,161, 13, 45, 15,
  GADGHCOMP,RELVERIFY,BOOLGADGET,(APTR) &border_text4,
  NULL,&text_ram,NULL,NULL,NULL,NULL};

/* ********************************************************************* */
/* * Information for the boolean gadget "dh0:"                         * */

struct IntuiText text_dh0={1, 2,JAM1,7,4,NULL,"dh0:",NULL};

struct Gadget gadget_dh0={&gadget_ram,110, 13, 45, 15,
  GADGHCOMP,RELVERIFY,BOOLGADGET,(APTR) &border_text4,
  NULL,&text_dh0,NULL,NULL,NULL,NULL};

/* ********************************************************************* */
/* * Information for the boolean gadget "df1:"                         * */

struct IntuiText text_df1={1, 2,JAM1,7,4,NULL,"df1:",NULL};

struct Gadget gadget_df1={&gadget_dh0,59, 13, 45, 15,
  GADGHCOMP,RELVERIFY,BOOLGADGET,(APTR) &border_text4,
  NULL,&text_df1,NULL,NULL,NULL,NULL};

/* ********************************************************************* */
/* * Information for the boolean gadget "df0:"                         * */

struct IntuiText text_df0={1, 2,JAM1,7,4,NULL,"df0:",NULL};

struct Gadget gadget_df0={&gadget_df1,8, 13, 45, 15,
  GADGHCOMP,RELVERIFY,BOOLGADGET,(APTR) &border_text4,
  NULL,&text_df0,NULL,NULL,NULL,NULL};

/* ********************************************************************* */
/* * Information for the boolean gadget "CANCEL"                       * */

struct IntuiText text_cancel={3, 2,JAM1,7,4,NULL,"CANCEL",NULL};

struct Gadget gadget_cancel={&gadget_df0,360, 144, 61, 15,
  GADGHCOMP,RELVERIFY,BOOLGADGET,(APTR) &border_text6,
  NULL,&text_cancel,NULL,NULL,NULL,NULL};

/* ********************************************************************* */
/* * Information for the boolean gadget "GO"                         * */

struct IntuiText text_input={3, 2,JAM1,7,4,NULL,"GO",NULL};

struct Gadget gadget_input={&gadget_cancel,8, 144, 61, 15,
  GADGHCOMP,RELVERIFY,BOOLGADGET,(APTR) &border_text4,
  NULL,&text_input,NULL,NULL,NULL,NULL};

UBYTE display_text[8][34];

struct IntuiText text_list[8]=
{
  {1, 0,JAM2,0,0,NULL,display_text[0],&text_list[1]},

  {1, 0,JAM2,0,8,NULL,display_text[1],&text_list[2]},

  {1, 0,JAM2,0,16,NULL,display_text[2],&text_list[3]},

  {1, 0,JAM2,0,24,NULL,display_text[3],&text_list[4]},

  {1, 0,JAM2,0,32,NULL,display_text[4],&text_list[5]},

  {1, 0,JAM2,0,40,NULL,display_text[5],&text_list[6]},

  {1, 0,JAM2,0,48,NULL,display_text[6],&text_list[7]},

  {1, 0,JAM2,0,56,NULL,display_text[7],NULL}
};

struct Gadget gadget_display[8]=
{
  {&gadget_display[1],8, 50, 276, 12,GADGHNONE,GADGIMMEDIATE,
    BOOLGADGET,NULL,NULL,NULL,NULL,NULL,NULL,NULL},

  {&gadget_display[2],8, 62, 276, 8,GADGHNONE,GADGIMMEDIATE,
    BOOLGADGET,NULL,NULL,NULL,NULL,NULL,NULL,NULL},

  {&gadget_display[3],8, 70, 276, 8,GADGHNONE,GADGIMMEDIATE,
    BOOLGADGET,NULL,NULL,NULL,NULL,NULL,NULL,NULL},

  {&gadget_display[4],8, 78, 276, 8,GADGHNONE,GADGIMMEDIATE,
    BOOLGADGET,NULL,NULL,NULL,NULL,NULL,NULL,NULL},

  {&gadget_display[5],8, 86, 276, 8,GADGHNONE,GADGIMMEDIATE,
    BOOLGADGET,NULL,NULL,NULL,NULL,NULL,NULL,NULL},

  {&gadget_display[6],8, 94, 276, 8,GADGHNONE,GADGIMMEDIATE,
    BOOLGADGET,NULL,NULL,NULL,NULL,NULL,NULL,NULL},

  {&gadget_display[7],8, 102, 276, 8,GADGHNONE,GADGIMMEDIATE,
    BOOLGADGET,NULL,NULL,NULL,NULL,NULL,NULL,NULL},

  {&gadget_input,8, 110, 276, 12,GADGHNONE,GADGIMMEDIATE,
    BOOLGADGET,NULL,NULL,NULL,NULL,NULL,NULL,NULL}
};

/* ********************************************************************* */
/* * BIG BOX                                                           * */

/* Values for a big box: */
SHORT points_big_box[]={8,50,  283,50,  283,121,   8,121,   8,50};

/* A border for a 1-letter box: */
struct Border border_big_box={0, 0,1, 2, JAM1,5,points_big_box,NULL};

/* ********************************************************************* */
/* * Information for the window                                          */

struct NewWindow new_file_window={0,0,480, 163,0,1,
  CLOSEWINDOW|  GADGETDOWN|  MOUSEMOVE|  GADGETUP,
  ACTIVATE|  WINDOWDEPTH|  WINDOWDRAG|  WINDOWCLOSE|  SMART_REFRESH,
  &gadget_display[0],NULL,NULL,NULL,NULL,0,0,0,0,WBENCHSCREEN};



/* ******************************************************************* */
			/* Entry point */

USHORT FileWindow(total_file_name )
STRPTR total_file_name;
{
STRPTR extension = "";
SHORT  x=0,y=0;
  int temp1; /* Variable used for loops etc. */
  int file_count; /* How many files/directories there are. */

  ULONG class;  /* Saved IntuiMessage: IDCMP flags. */
  USHORT code;  /*        -"-        : Special code. */
  APTR address; /*        -"-        : The address of the object. */

  int position; /* The number of the first file in the display. */

  BOOL working;     /* Wants the user to quit? */
  BOOL fix_display; /* Should we update the file-display? */

  STRPTR string_pointer; /* Pointer to a string. */
  struct file_info *pointer; /* Pointer to a file_info structure. */

  USHORT operation; /* What operation FileWindow will return. */
  

  file_lock=FALSE; /* We have not locked any file/directory. */
  more_files=FALSE; /* Do not list any files yet. */


  /* Make sure the proportional gadget is at the top, showing 100%: */
  prop_info.VertBody=0xFFFF;
  prop_info.HorizBody=0;
  prop_info.VertPot=0;
  prop_info.HorizPot=0;
  

  /* Copy the extension into the string gadget: */
  strcpy(extension_name, extension);

  /* If there is an extension, the text "Ext:" will be highlighted: */
  if(*extension_name != '\0')
    text_extension.FrontPen=3; /* Orange. (Normal WB colour) */
  else
    text_extension.FrontPen=1; /* White. (Normal WB colour) */


  /* Change some values in the new_file_window structure: */
  new_file_window.LeftEdge=x;
  new_file_window.TopEdge=y;
  new_file_window.Title= "BREF FileWindow";

  /* Open the window: */
  if( (file_window = (struct Window *) OpenWindow(&new_file_window)) == NULL )
  {
    /* We could NOT open the window! */
    return(PANIC1);	/* No msg here; BREF will give error msg */
  }

  /* Draw the big box around the display: */
  DrawBorder(file_window->RPort, &border_big_box, 0, 0);

  /* Allocate memory for the FileInfoBlock: */
  if((file_info=(struct FileInfoBlock *)
    AllocMem(sizeof(struct FileInfoBlock), MEMF_PUBLIC|MEMF_CLEAR))==NULL)
  {
    /* Could not allocate memory for the FileInfoBlock! */
    request_ok("FileWindow--NOT enough memory!");
    return(PANIC2);	/* Since msg given here, no msg in BREF */
  }

  /* Anything in total_file_name? */
  if(*total_file_name != '\0')
  {
    /* Yes--Try to "lock" the file/directory: */
    if((lock=Lock(total_file_name, ACCESS_READ))==NULL)
    {
      /* PROBLEMS! */
      /* File/directory/device did NOT exist! */
    }
    else
    {
      /* Could lock the file/directory! */
      file_lock=TRUE;
  
      /* Get some information of the file/directory: */
      if((Examine(lock, file_info))==NULL)
      {
        /* Could NOT examine the object! */
        request_ok("FileWindow--ERROR reading file/directory!");
      }
      else
      {
        /* Is it a directory or a file? */
        if(directory(file_info))
        {
          /* It is a directory! */

          *file_name='\0'; /* Clear file_name string. */
          /* Copy total_file_name into drawer_name string: */
          strcpy(drawer_name, total_file_name);

          /* Since it is a directory, we will look for more files: */
          more_files=TRUE;
        }
        else
        {
          /* File--Separate the file name from the path: */
          if(string_pointer=right_pos(total_file_name, '/'))
          {
            /* Copy the file name into file_name string: */
            strcpy(file_name, string_pointer+1);
            *string_pointer='\0';
          }
          else
          {
            if(string_pointer=right_pos(total_file_name, ':'))
            {
              /* Copy the file name into file_name string: */
              strcpy(file_name, string_pointer+1);
              *(string_pointer+1)='\0';
            }
            else
            {
              strcpy(file_name, total_file_name);        
              *drawer_name='\0';
              *total_file_name='\0';
            }
          }
          strcpy(drawer_name, total_file_name);

          /* Since it is a file, we will NOT look for more files: */

        } /* Is it a directory? */

      } /* Could we examine the object? */

    } /* Could we "lock" the file/directory? */

  } /* Anything in the total_file_name string? */

  /* Adjust the string gadgets */
  adjust_string_gadgets();

  new_drawer(); /* Start to show us the files. */

  position=0;        /* The display will show the first file. */
  fix_display=FALSE; /* We do not need to fix the display. */
  first_file=TRUE;   /* No files saved. */
  file_count=0;      /* No files saved. */

  working=TRUE;
  do
  {
    /* If all files shown, put task to sleep */
    if(more_files==FALSE)
      Wait(1 << file_window->UserPort->mp_SigBit);

    /* Any gadget activity? */
    while(my_gadget_message = (struct IntuiMessage *)
      GetMsg(file_window->UserPort))
    {
      /* Stay in loop while mouse moving.  Update display when mouse stops*/
      class = my_gadget_message->Class;
      code = my_gadget_message->Code;
      address = my_gadget_message->IAddress;

      ReplyMsg((struct Message *)my_gadget_message);

      switch(class)
      {
        case MOUSEMOVE:
          /* Proportional gadget selected, & mouse is moving. */ 
          /* Update file_display when mouse stops. */
          fix_display=TRUE;
          break;

        case CLOSEWINDOW:	/* User wants to quit. */
          connect_dir_file(total_file_name);
          working=FALSE;
          operation=QUIT;
          break;

        case GADGETDOWN:	/* Gadget selected -- which one? */
           /* File Display */
           for(temp1=0; temp1 < 8; temp1++)
           {
             if(address == (APTR)&gadget_display[temp1])
             {
               /* The user wants to select a file/directory: */
               pick_file(temp1+position);
             }
           }
           break;

        case GADGETUP:	/* Gadget released -- which one? */

           if(address == (APTR)&gadget_input ||	/* GO */
				  address == (APTR)&gadget_file)		/* FILE */
           {
             if(last_check(total_file_name))
             {
               working=FALSE;
               operation=GO;
             }
             break;
           }

           if(address == (APTR)&gadget_cancel)	/* CANCEL */
           {
             connect_dir_file(total_file_name);
             working=FALSE;
             operation=CANCEL;
             break;
           }

           if(address == (APTR)&gadget_df0)	/* df0: */
           {
             change_device("df0:");
             break;
           }

           if(address == (APTR)&gadget_df1)	/* df1: */
           {
             change_device("df1:");
             break;
           }

           if(address == (APTR)&gadget_dh0)	/* dh0: */
           {
             change_device("dh0:");
             break;
           }

           if(address == (APTR)&gadget_ram)	/* ram: */
           {
             change_device("ram:");
             break;
           }

           if(address == (APTR)&gadget_drawer)	/* DRAWER: */
           {
             /* The user has entered something new in the drawer: */
             new_drawer();
             break;
           }

           if(address == (APTR)&gadget_extension)	/* EXTENSION: */
           {
             /* If extension used, text "Ext:" is highlighted */
             if(*extension_name != '\0')
               text_extension.FrontPen=3; /* Orange. (Normal WB colour) */
             else
               text_extension.FrontPen=1; /* White. (Normal WB colour) */

             /* Show the user the colour change: */
             RefreshGadgets(&gadget_extension, file_window, NULL);

             /* Start again to diplay the files, using a new extension. */
             new_drawer();
             break;
           }

           if(address == (APTR)&gadget_parent)		/* PARENT: "<" */
           {
             parent();
             break;
           }

           if(address == (APTR)&gadget_proportional)	/* PROPORTIONAL */
           {
             /* Proportional gadget released, update display */
             fix_display=TRUE;
             break;
           }

           if(address == (APTR)&gadget_option)	/* OPTION */
           {
             connect_dir_file(total_file_name);
             working=FALSE;
             operation=OPTION;
             break;
           }

           if(address == (APTR)&gadget_help)	/* HELP */
           {
             connect_dir_file(total_file_name);
             working=FALSE;
             operation=HELP;
             break;
           }

      }
    }

    if(fix_display)    /* Do we need to update the file display? */
    {
      fix_display=FALSE;

      /* Which file should we start to show in the display? */
      if(file_count > 8)
        position=(int) prop_info.VertPot/(float) 0xFFFF*(file_count-8);
      else
        position=0;

      /* List the files: (Starting with position) */
      display_list(position);
    }


    if(more_files)
    {
      /* Are there more files/dirtectories left to be collected? */    
      if(ExNext(lock, file_info))
      {
        /* List the file/directory if it is: */
        /* 1. A file which has the right extension. */
        /* 2. A directory. */
/*      if(stricmp(extension_name, (file_info->fib_FileName+*/
/*				changed "stricmp" to "strcmp" */
        if(strcmp(extension_name, (file_info->fib_FileName+
           strlen(file_info->fib_FileName)-strlen(extension_name)))==0 ||
           directory(file_info) )
        {
          /* Is this the first file/directory? */
          if(first_file)
          {
            /* first_pointer will point at the first file in our list: */
            first_pointer=(struct file_info *) save_file_info(file_info);
            
            if(first_pointer != NULL)
            {
              /* There are no more elements (for the moment) in our list: */ 
              first_pointer->next=NULL; 
              first_file=FALSE;
            }
            file_count=1;
            position=1;
          }
          else
          {
            /* save_file_info will return a pointer to the allocated */
            /* structure: */
            pointer=(struct file_info *) save_file_info(file_info);
            
            /* If space allocated for file, add it to list */
            if(pointer !=NULL)
            {
              /* Put new structure into list: */
              put_in(first_pointer, pointer);       
              file_count++;
            }
          }
        
          /* If > 8 files/directories, modify proportional gadget */
          if(file_count > 8)
          {
            ModifyProp
            (
              &gadget_proportional,       /* PropGadget */
              file_window,                /* Pointer */
              NULL,                       /* Requester */
              prop_info.Flags,            /* Flags */
              0,                          /* HorizPot */
              prop_info.VertPot,          /* VertPot */
              0,                          /* HorizBody */
              (ULONG) 0xFFFF*8/file_count /* VerBody */
            );            
            position=(int) prop_info.VertPot/(float) 0xFFFF*(file_count-8);
          }
          else
           position=0;


          /* List all the files: */
          display_list(position);
        }
      }
      else
      {
        /* ExNext() failed: */
        
        more_files=FALSE; /* Do not try to list any more files. */

        /* Check what went wrong: */
        /* If error msg NOT "ERROR_NO_MORE_ENTRIES", serious reading error*/
        if(IoErr() != ERROR_NO_MORE_ENTRIES)
        {
          request_ok("FileWindow--ERROR reading file/directory!");
        }
      }
    }
  } while(working);

  /* Clean up and leave: */

  /* This will clear the IDCMP port: */
  while( (my_gadget_message = (struct IntuiMessage *)
           GetMsg(file_window->UserPort)) )
  {
    ReplyMsg((struct Message *)my_gadget_message);
  }

  /* Deallocate the memory we have dynamically allocated: */ 
  deallocate_file_info();

  /* If we have "locked" a file/directory, "unlock" it: */
  if(file_lock)
  {
    UnLock(lock);
    file_lock=FALSE;
  }
  
  /* Deallocate FileInfoBlock: */
  if(file_info) FreeMem(file_info, sizeof(struct FileInfoBlock));

  /* If we have successfully opened the file_window, we close it: */
  if(file_window)
    CloseWindow(file_window);
  
  /* Leave with a message: */
  return(operation);
}

		/* Deallocate the memory we have dynamically allocated: */ 
void deallocate_file_info()
{
  struct file_info *pointer, *temp_pointer;

  /* Does the first pointer point to an allocated structure? */   
  if(first_pointer)
  {
    /* Save the address of the next structure: */
    pointer=first_pointer->next;
    
    /* Deallocate the first structure: */
    FreeMem( first_pointer, sizeof(struct file_info));

    /* As long as pointer points to an allocated structure: */
    while(pointer)
    {
      /* Save the address of the next structure: */    
      temp_pointer=pointer->next;
      
      FreeMem( pointer, sizeof(struct file_info));
      pointer=temp_pointer;
    }
  }
  
  /* Clear first_pointer: */
  first_pointer=NULL;

  /* Next time we try to list the files, we start with the first_file: */
  first_file=TRUE;
}


/* Allocate memory for the new file/directory, and fills the structure */
/* with information. (name of the object, and if it is a directory.)   */
/* Returns a memory pointer to the allocated structure, or NULL.       */
APTR save_file_info(info)
struct FileInfoBlock *info;
{
  struct file_info *pointer;

  if((pointer=(struct file_info *)
    AllocMem(sizeof(struct file_info), MEMF_PUBLIC|MEMF_CLEAR))==NULL)
  {
    /* We could NOT allocate memory for the structure! */
    request_ok("FileWindow--NOT enough memory!"); /* Inform the user. */
    more_files=FALSE; /* Do not list any more files/directories. */
    return(NULL);
  }
  else
  {
    /* If the file/directory name is not too long, we copy it into the */
    /* new stucture: */
    if(strlen(info->fib_FileName) < 28)
      strcpy(pointer->name, info->fib_FileName);
    else
    {
      /* The file/directory name is too long! */
      /* Inform the user: */
      
      if( directory(info))
        request_ok("FileWindow--Directory name too long!");/* Directory*/
      else    
        request_ok("FileWindow--File name too long!"); /* File. */

      /* Deallocate the structure: */
      FreeMem( pointer, sizeof(struct file_info));
      return(NULL);
    }

    /* Is it a file or a directory? */
    if( directory(info))
      pointer->directory=TRUE; /* It is a directory. */
    else    
      pointer->directory=FALSE; /* It is a file. */
  }
  
  /* Return the address of the allocated structure: */
  return( (APTR) pointer);
}


/* Will check a FileInfoBlock if it is a file or a directory. */
/* Return TRUE if it is a directory, FALSE if it is a file.   */
BOOL directory(info)
struct FileInfoBlock *info;
{
  if(info->fib_DirEntryType < 0)
    return(FALSE);
  else
    return(TRUE);
}


/* Put the new structure into the dynamically allocated list at the */
/* right place (sorted alphabetically, directories first):          */
void put_in(a_pointer, pointer)
struct file_info *a_pointer, *pointer;
{
  struct file_info *old_pointer=NULL;

  /* Move slowly down the list and try to fit in the structure: */
  while( a_pointer && file_comp(a_pointer->name, pointer->name) )
  {
    old_pointer=a_pointer;
    a_pointer=a_pointer->next;
  }

  if(a_pointer)
  {
    if(old_pointer)
    {
      /* Put the structure into the list: */
      pointer->next=old_pointer->next;
      old_pointer->next=pointer;
    }
    else
    {
      /* First in the list! */
      pointer->next=first_pointer;
      first_pointer=pointer;
    }
  }
  else
  {
    /* Last int the list: */
    old_pointer->next=pointer;
    pointer->next=NULL;
  }
}


/* This function will return TRUE if the first pointer (a_pointer) */
/* points to a file structure which should come before the second  */
/* pointers file structure.                                        */
/* ORDER:  1. DIRECTORIES  alpha sort.  2. FILES   alpha sort. */

BOOL file_comp(a_pointer, pointer)
struct file_info *a_pointer, *pointer;
{
 char name1[28], name2[28], *cp1, *cp2;

  if(a_pointer->directory == FALSE && pointer->directory)
    return(FALSE);
    
  if(a_pointer->directory == pointer->directory)
  {
/*  if(stricmp(a_pointer->name, pointer->name) <= 0 )*/
/*			changed "stricmp" to "strcmp".  But to function like stricmp, */
/* we need to convert the names to lower case for the sort. */

	/* Convert first name to lower case in name1 */
	for (cp1=a_pointer->name, cp2=name1; *cp2++ = igncase(*cp1); cp1++) ;

	/* Convert second name to lower case in name2 */
	for (cp1=pointer->name, cp2=name2; *cp2++ = igncase(*cp1); cp1++) ;

    if(strcmp(name1, name2) <= 0 )
      return(TRUE);
    else
      return(FALSE);
  } 
  return(TRUE);
}


/* Give this function a string and a character, and it will return a */
/* pointer to the right most occurance character in you string which */
/* match your character.                                             */
STRPTR right_pos(string, sign)
STRPTR string;
char sign;
{
  STRPTR start_pos;
  
  start_pos=string;
  
  /* Go to the end: */
  while(*string != '\0')
    string++;

  /* Start to go backwards and check teh string: */
  while(*string != sign && string > start_pos)
    string--;
    
  if(*string==sign)
    return(string); /* We have found a matching character. */

  return(NULL); /* We could not find a matching character. */
}


/* This function will change to a new device, for example df0:. */
/* Does not return anything.                                    */
void change_device(device)
STRPTR device;
{
  strcpy(drawer_name, device); /* Change the drawer string. */

  adjust_string_gadgets(); /* Adjust the string gadgets. */

  new_drawer(); /* Start to show us the new files/directories */
}


/* When the user or the program has changet the drawer string, this      */
/* function is called, and will do what is necessary to start to collect */
/* the new files/directories from the disk.                              */
/* Returns TRUE if everything is OK, and FALSE if something went wrong.  */
BOOL new_drawer()
{
  STRPTR string_pointer;

  /* Unlock: */
  if(file_lock)
  {
    UnLock(lock);
    file_lock=FALSE;
  }

  /* Deallocate the memory we have dynamically allocated: */ 
  deallocate_file_info();

  /* Change the proportianal gadget: */
  ModifyProp
  (
    &gadget_proportional, /* PropGadget */
    file_window,          /* Pointer */
    NULL,                 /* Requester */
    prop_info.Flags,      /* Flags */
    0,                    /* HorizPot */
    0,                    /* VertPot */
    0,                    /* HorizBody */
    (ULONG) 0xFFFF        /* VerBody */
  );

  /* Clear the display: */
  display_list(0);

  more_files=FALSE;

  /* Try to "lock" the file/directory: */
  if((lock=Lock(drawer_name, ACCESS_READ))==NULL)
  {
    /* We could NOT lock the file/directory/device! */
    /* Inform the user: */
    string_pointer=drawer_name+strlen(drawer_name)-1;
    if(*string_pointer==':')
      request_ok("FileWindow--Device NOT found!");
    else
      request_ok("FileWindow--Device/Directory NOT found!");

    return(FALSE); /* ERROR */
  }
  else
  {
    /* We "locked" the file/directory! */
    file_lock=TRUE;
  }

  /* Now try to get some information from the file/directory: */
  if((Examine(lock, file_info))==NULL)
  {
    /* We could NOT examine the file/directory! */

    request_ok("FileWindow--ERROR reading file/directory!");

    return(FALSE); /* ERROR */
  }

  /* Is it a directory or a file? */
  if(directory(file_info))
  {
    /* It is a directory! */

    /* Since it is a directory, we will look for more files: */
    more_files=TRUE;
  }
  else
  {
    /* It is a file! */
    request_ok("FileWindow--NOT a valid directory name!");
    return(FALSE);
  }  
  return(TRUE);
}


/* The function parent() will try to go backwards one step in the */
/* directory path.                                                */
/* Does not return anything.                                      */
void parent()
{
  STRPTR string_pointer;

  /* Separate the last directory from the path: */
  if(string_pointer=right_pos(drawer_name, '/'))
  {
    /* Take away the last directory: */
    *string_pointer='\0';
  }
  else
  {
    if(string_pointer=right_pos(drawer_name, ':'))
    {
      /* Take away the last directory: */
      /* Only the device ("df0:" for example) left: */
      *(string_pointer+1)='\0';
    }
    else
    {
      /* Strange drawer_name, clear it: */
      *drawer_name='\0';
    }
  }

  /* Since we have messed around with the string gadgets, adjust them: */
  adjust_string_gadgets();
  
  /* Start to show the user the files etc in the new directory: */
  new_drawer();
}


/* You give this function a pointer to an error string, and it will open */
/* a simple requester displaying the message. The requester will go away */
/* first when the user has selected the button "OK".                     */
/* Does not return anything.                                             */
void request_ok(message)
STRPTR message;
{
  text_request.IText=message;
  
  AutoRequest
  (
    file_window,   /* Window */
    &text_request, /* BodyText */
    NULL,          /* PositiveText nothing */
    &ok_request,   /* NegativeText OK */
    NULL,          /* PositiveFlags */
    NULL,          /* NegativeFlags */
    320,           /* Width */
    72             /* Height */
  );
}


/* This function will display the files etc which are inside the */
/* directory, starting with the file number start_pos.           */
/* Does not return anything.                                     */
void display_list(start_pos)
int start_pos;
{
  struct file_info *pointer;
  int pos, temp1;
                  /* 123456789012345678901234567890123 */
  char empty_name[]="                                 ";
  STRPTR string_pointer;
  BOOL clear;
  
  pos=0;
  
  /* Does it exist any files at all? */
  if(first_pointer)
  {
    pointer=first_pointer;

    /* Go through the list until you have found the file/directory */
    /* which should be shown first:                                */
    while(pointer && pos < start_pos)
    {
      pos++;
      pointer=pointer->next;
    }
    
    /* Try to show the eight files: */
    pos=0;
    while(pointer && pos < 8)
    {
      strcpy(display_text[pos], pointer->name);
      
      clear=FALSE;
      temp1=0;
      string_pointer=display_text[pos];

      if(pointer->directory)
      {
        /* It is a directory: */
        text_list[pos].FrontPen=3; /* Highlight it. */

        /* Clear everything after the name, and add the string "(Dir)". */
        while(temp1 < 28)
        {
          if(*string_pointer=='\0')
            clear=TRUE;
          if(clear)
            *string_pointer=' ';
          string_pointer++;
          temp1++;
        }
        *string_pointer='\0';
        strcat(display_text[pos], "(Dir)");
      }
      else
      {
        /* It is a file: */
        text_list[pos].FrontPen=1; /* Normal colour. */

        /* Clear everything after the name: */
        while(temp1 < 33)
        {
          if(*string_pointer=='\0')
            clear=TRUE;
          if(clear)
            *string_pointer=' ';
          string_pointer++;
          temp1++;
        }
        *string_pointer='\0';
      }      
      pos++;
      pointer=pointer->next; /* Next. */
    }
  }

  /* If there are less than eight files, show clear the rest of the */
  /* display: */
  while(pos < 8)
  {
    strcpy(display_text[pos], empty_name);
    pos++;
  }
  
  /* Show the user the new display: */
  PrintIText(file_window->RPort, text_list, 13+3, 53+1);
}


/* The user has selected a file or a directory. If it is a file put it */
/* into the file string, otherwise put it into the drawer string.      */
/* Returns TRUE if everything went OK, FALSE if there was a problem.   */
BOOL pick_file(file_pos)
int file_pos;
{
  struct file_info *pointer=NULL;
  STRPTR string_pointer;
  int pos=0;
  
  /* Go through the allocated list untill we find the file/directory: */
  if(first_pointer)
  {
    pointer=first_pointer;
    
    while(pointer && pos < file_pos)
    {
      pos++;
      pointer=pointer->next;
    }
  }

  /* Have we found the file/directory? */
  if(pointer)
  {
    if(pointer->directory)
    {
      /* It is a directory! */
      
      /* Is the drawer_name string long enough? */
      /* (+2: 1 for the NULL ('\0') character, 1 for the '\' character) */
      if((strlen(pointer->name)+strlen(drawer_name)+2) <= DRAWER_LENGTH)
      {
        /* YES!, there is enough room for it. */
        string_pointer=drawer_name+strlen(drawer_name)-1;
        if(*string_pointer==':'  || *string_pointer=='\0' )
          strcat(drawer_name, pointer->name);
        else
        {
          /* We need to add a '/' before we can add the directory. */
          strcat(drawer_name, "/");
          strcat(drawer_name, pointer->name);
        }
        
        /* Adjust the string gadgets: */
        adjust_string_gadgets();
      }
      else
      {
        /* The drawer_name is NOT big enough! */
        request_ok("FileWindow--Too long drawer string");
        return(FALSE); /* ERROR */
      }
      new_drawer();
      return(TRUE); /* OK */
    }
    else
    {
      /* It is a File! */
      /* Is the file_name string long enough? */
      /* (+1 for the NULL ('\0') character.) */
      if((strlen(pointer->name)+1) <= FILE_LENGTH)
      {
        strcpy(file_name, pointer->name);
        adjust_string_gadgets();
      }
      else
      {
        /* The file_name is NOT big enough! */
        request_ok("FileWindow--File name too long!");
        return(FALSE); /* ERROR */
      }
      return(TRUE); /* OK */
    }
  }
}


/* Adjust the string gadgets, so the user can */
/* at least see the last 28/22 characters.    */
/* Does not return anything.                  */
void adjust_string_gadgets()
{
  int length;

  length=strlen(file_name);        

  if(length > 28)
    string_file.DispPos=length-28;
  else
    string_file.DispPos=0;

  string_file.BufferPos=string_file.DispPos;

  length=strlen(drawer_name);        

  if(length > 22)
    string_drawer.DispPos=length-22;
  else
    string_drawer.DispPos=0;

  string_drawer.BufferPos=string_drawer.DispPos;

  /* Display the changes. */
  RefreshGadgets(&gadget_file, file_window, NULL);
}


/* Returns TRUE if there exist a file name, otherwise FALSE. */
BOOL last_check(name)
STRPTR name;
{
  if(*file_name == '\0')
  {
    /* No file name! */
    request_ok("FileWindow--NO filename selected!");
    return(FALSE);
  }
  else
  {
    /* Change the total_file_name. Drawer + File. */
    connect_dir_file(name);
  }
  return(TRUE);
}


/* This function will connect the drawer string with the file string. */
/* Does not return anything.                                          */
void connect_dir_file(name)
STRPTR name;
{
  STRPTR string_pointer;
  
  strcpy(name, drawer_name); /* Copy the drawer string into name. */

  /* Does it exist a file name? */
  if(*file_name != '\0')
  {
    /* Yes! */
    string_pointer=drawer_name+strlen(drawer_name)-1;
    if(*string_pointer==':'  || *string_pointer=='\0' )
    {
      strcat(name, file_name); /* Add the file name. */
    }
    else
    {
      strcat(name, "/"); /* Add a '\'. */
      strcat(name, file_name); /* Add the file name. */
    }
  }
}	/* THE END */
