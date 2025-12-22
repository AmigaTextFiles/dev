/*********************************************************************
**
**	Gui4Cli Include file
**	$VER: 3.6 (20/8/98)
**	Author : D. Keletsekis - dck@hol.gr
**
**	This file holds some of the Gui4Cli internal structures.
**	You can access them by getting a pointer to the GCmain
**	structure (see end of this file) and following the pointers
**	from there.
**
**	The *GCmain pointer is stored in the "gcmain" field of the
**	Gui4Cli message structure, and you can get it by sending 
**	a GM_LOCK message to Gui4Cli, or when Gui4Cli sends you a
**	message (using the CALL command).
**
**	From *GCmain you can see all the gui files, the events,
**	the listviews, the variables, and most of everything that
**	Gui4Cli holds dear. Why you would ever want to, is an 
**	other matter.. Look at the C examples in this directory
**	for information on how to access & manipulate them.
**
*********************************************************************/

// union used in events & commands, to hold the arguments, which
// can be numbers or strings - LTWH=numbers, Title=string etc..

union commandunion
{  LONG  num;    // if it's a number
   char  *str;   // if it's a string
   APTR  dummy;  // forget it..
};

#define OPT_COUNT  12  // max number of arguments 

/*********************************************************************
     The Gui4Cli message structure - use it to communicate with G4C
*********************************************************************/

struct g4cmsg
{
   struct Message node;	// EXEC message structure

   // When Gui4Cli sends the message :
   // - This will be a pointer to the command name which will
   //   have been converted to upper case. If there are any more
   //   arguments passed, then these will be stored in "args[0-5]"
   // When you send a GM_COMMAND or GM_RUN message to Gui4Cli :
   // - This must point to a string buffer which will contain
   //   the command which you want Gui4Cli to execute.
   // otherwise null..
   UBYTE *com;

   // This will either contain a pointer to struct *GCmain, or 
   // NULL. You get the pointer when Gui4Cli sends you a
   // message (with the CALL command), or when Gui4Cli replies 
   // to a GM_LOCK message that you sent. Otherwise NULL.
   struct GCmain *gcmain;

   // Set this to 392001 which is a "magic" number that Gui4Cli
   // will recognise as being a GC type message.
   LONG  magic;

   // 6 argument strings. When Gui4Cli sends you a message, it
   // will consist of a command (which will be in *com above)
   // and up to 6 arguments. This is where the arguments will
   // be stored (if any) - so, if arg[x] is not NULL, it will
   // contain a pointer to a null terminated string.
   UBYTE *args[6];

   // if you want to return something, then you must store it
   // in a buffer which you MUST get using AllocVec() and point
   // it here. The buffer will be available from within Gui4Cli
   // as internal variable $$CALL.RET
   // IMPORTANT NOTE:
   // If you attach such a buffer, it will be freed by Gui4Cli, 
   // using FreeVec(), before Gui4Cli sends it's next message.
   UBYTE *msgret;

   UBYTE type;		// type of message - see defines below
   LONG  res;		// error status (0 means OK)
   APTR  data;		// null - for future expansion
   APTR  exp;		// null - for future expansion
};

/*********************************************************************
     Message types
     These are the currently available types for the "type" field 
     of the above structure.
*********************************************************************/

// ------------------------------------------------------------------
// A)  If the command is sent by a program to Gui4Cli:
//   The "com" field must point to a valid command line to be 
//   executed by Gui4Cli - only commands which are defined as 
//   "arexx capable" can be executed. The line will be translated,
//   then parsed and executed. Upon returning, the "res"
//   field will hold the return code, if any was set..
// ---------------------- ...
// B)  If sent by Gui4Cli to an outside program, using CALL :
//   "com" will point to the command name, "gcmain" will contain
//   a pointer to the GCmain structure, and if there are any arguments
//   they will be stored in "args[0]"-"args[5]". Upon return, $$RetCode 
//   will be set to the "res" value you have set (if any). 0 means OK
// ------------------------------------------------------------------
#define GM_COMMAND  1

// ------------------------------------------------------------------
// This is the same as GM_COMMAND, Part (A). The difference is that 
// while GM_COMMAND will do the commands synchronously - i.e. the 
// program which sends the command will have to wait until after
// Gui4Cli executes the command to receive the repply, GM_RUN will
// pass the command to Gui4Cli and return and let Gui4Cli get on
// with it asynchronously. The draw back is that you will not know
// when the command finished executing and if it was successful.
// ------------------------------------------------------------------
#define GM_RUN      2

// ------------------------------------------------------------------
// GM_LOCK will freeze Gui4Cli, until a GM_UNLOCK message is
// received. When you send a GM_LOCK message, Gui4Cli will immediately
// reply, storing a pointer to the "GCmain" structure in the message's
// "gcmain" field. It will then wait, doing nothing until a GM_UNLOCK
// message is received. Do what you want and then send GM_UNLOCK.
// ------------------------------------------------------------------
#define GM_LOCK	    5

// ------------------------------------------------------------------
// MUST UNLOCK Gui4Cli after a GM_LOCK message.
// ------------------------------------------------------------------
#define GM_UNLOCK   6

/*********************************************************************
	LV helper structures
	these hold various things for listviews..
*********************************************************************/

// holds listview colors etc

struct styledef
{
   BOOL  usestyle;	// =1 if styles have been specifically set
   WORD  fg;		// foreground pen
   WORD  nbg;           // normal background pen
   WORD  sbg;		// selected background pen
   WORD  shad;		// shadow - signifies to make letters 3D
};

// If a LV loads a DataBase file, it allocates a dbdef struct
// and links it to the "db" member of the fulist struct. All
// field definitions are link-listed to this struct.

struct lvfield	      	// field definition struct (AllocVec)
{
   char name[31];     	// field name
   LONG start;        	// byte in record where field starts
   LONG length;       	// field length
   UBYTE type;        	// field type (N)umber,(C)har or (D)ate
   struct styledef sd;  // full styledef struct
   struct lvfield *next; // pointer to next field or null
   // ----------- private fields below
};

struct dbdef
{
   LONG fieldnum;		// number of fields
   LONG reclength;		// record length
   struct lvfield *topfield;	// linked list of fields (AllocVec)
   // ------------- private fields below
};

/*********************************************************************
      LISTVIEW LINE
      Every line of a listview has a structure like this.
      They are kept in a struct List and given to the LV.
      There is a pointer to this list in struct "fulist".
      The LV shows the text pointed to by node->ln_Name.
      This is set to point to some part of the *start buffer,
      according to how much the list is shifted (left/right)
**********************************************************************/

struct lister 
{ 
  struct Node node;   // a normal exec node for struct List. The ln_Name
                      // field points to the start of the visible text.
  UBYTE *start;       // pointer to the start of the line's text - i.e. the full buffer
  LONG  length;       // line length - buffer is AllocMem (length+1) !!!!
  BOOL Selected;      // 1 = line is selected, 0 = it's not
  struct fulist *fls; // ptr back to parent fulist structure (for hook)
  UBYTE filend;       // pointer to end of filename - for dir listviews
  UBYTE type;         // type of entry - F=file, D=dir etc
};


/*********************************************************************
      LISTVIEW
      This is the main listview structure holding all the information
      needed for all the various types of listviews. A pointer to
      this struct is kept in the EVENT structure of the xLISTVIEW event
**********************************************************************/

struct fulist
{
  struct List *ls;         // the list structure with all the lines
  int    maxlength;        // length of longest line (strlen)
  int    maxnow;           // - not used any more
  LONG   totnum;           // total number of lines
  struct lister *curpt;    // pointer to current record (or null)
  LONG   line;             // line number of current record (-1 if none)
  UBYTE  maxdirlength;     // length of longest dir name (for size alignment)
  char   curdir[140];      // buffer for current dir name (when in DIR mode)  
  int    dirhook;          // gadid of xlvdirhook event or 0
  struct Event *bt;        // point to the xLISTVIEW event
  struct guifile *gf;      // points back to parent gui file
  LONG   magic;            // sanity check - set to 22108
  struct dbdef *db;	   // link field info structure for database LVs 
  struct styledef nsd;     // full styledef struct for normal records
  struct styledef dsd;     // full styledef struct for dir,vol etc
  SHORT  linedist;	   // distance between lines

  // ----------- private fields below..
};

/********************************************************************
     IMAGES
     structure used to hold image information
*********************************************************************/
struct imginfo 
{  
   Object                *po;      // the datatype object
   struct BitMapHeader   *bmh;     // the header..
   struct BitMap         *bm;      // the data..
   char                  name[35]; // the name (alias) of this image
   LONG                  count;    // times in use
   struct imginfo        *next;    // next image
};

/*********************************************************************
      VARIABLE
      This is the variables structure. Variables are kept in linked
      list - Each gui file has a pointer to such a list for its own
      private vars. the Global vars pointer is kept in the GCmain struct.
**********************************************************************/

struct var
{ 
   char *name;          // the variable's name (AllocVec)
   char *str;           // the variable's contents (AllocVec)
   struct var *next;    // ptr to next variable in list
   APTR ex;		// for future expansion (NULL now)
};

/*********************************************************************
      CYCLER & RADIO GADGETS
      This structure holds the fields of a cycler or a radio button
      gadget. A pointer to it is kept from the event structure. 
**********************************************************************/

struct cycler
{ 
  char *cyp[13];   // Pointers to cycler/radio strings
  char *var[13];   // Pointers to value to put in $variable
  int  cno;        // Number of strings actually declared (12 max)
  int  height;     // distance between radio buttons (N/A for cyclers)
}; 

/*********************************************************************
      EVENT COMMAND
      This structure holds an event command. They are linked in
      a list with a pointer to the top event command kept in the
      event structure.
**********************************************************************/

struct line
{
  SHORT  type;                         // type of command (see Gui4Cli.def)
  int    progline;                     // line No of the command in the file
  union  commandunion arg[OPT_COUNT];  // the command's arguments
  struct line *next;                   // pointer to next command or NULL
  // -------- private fields below
};

/*********************************************************************
      EVENT
      This is the main event structure. Events are linked in a list
      with a pointer to the top event kept in the guifile structure.
**********************************************************************/

struct Event
{
  union commandunion arg[OPT_COUNT];    // the event's arguments (LTWH etc)
  int ID;                // gadget's internal id - only for Gui4Cli
  int UID;               // GADID of gadget (or 0 if not defined)
  int key;               // Decimal value of Keyboard shortcut
  LONG  val;             // current value of gadget (varies..)
  SHORT type;            // type of gadget (see file Gui4Cli.def)
  char  *file;           // pointer to the event's variable name
  BOOL  onoff;           // 0=gadget is ON, 1=OFF
  LONG progline;         // Line in the file where event is declared
  LONG lastline;         // Line No of last of this events commands
  BOOL  appear;          // whether it appears or not (SHOW|HIDE)
  int   l, t, w, h;      // current ACTUAL (full window) left top width height
  struct guifile *gf;    // pointer to the guifile of this event
  struct Gadget *gad;       // Pointer to the gadget struct - If it's a gadget
  struct DiskObject *dobj;  // Pointer to icon for AppIcons & icons
  struct cycler *cy;        // pointer to cycler struct - also cast into general purpose pointers
  struct fulist *lt;     // pointer to struct if it's a ListView (or NULL)
  struct TextAttr *fta;  // text attribute struct
  struct TextFont *ftf;  // text font struct
  UBYTE  *help;          // pointer to help text or NULL
  struct line *topx;     // first of a linked list of event commands
  struct var *topvar;    // first of list of this event's variables (if defined)
  struct Event *next;   // next in the list of events
  // --------- private fields below here
};


/*********************************************************************
      GUI FILE
      This is the main guifile structure. Guis are linked in a list
      with a pointer to the first gui kept in the G4C structure.
**********************************************************************/

struct guifile
{ 
  LONG   magic;                 // for sanity checks - must be 7225825
  struct Window   *wn;          // pointer to this gui's window (if open)
  struct Screen   *sc;          // ptr to screen (if window's open)
  struct AppMenuItem *appitem;  // ptr to appitem (if any)
  struct Menu *menu;            // menus (if any)
  struct TextAttr *fta;         // text attributes
  struct TextFont *ftf;         // text font
  BPTR cp;                      // console pointer for this gui (if any)
  char scr[31];                 // buffer for screen name
  char imgname[35];             // name of background image (if any)
  char *wntitle;                // ptr to window's title
  char *wow;                    // pointer to win-on-win gui name
  int  wowl, wowt;              // offsets for winonwin
  char fullpath[140];           // full path & filename of gui file
  char name[35];                // just the filename (separate for guirename)
  UWORD wnsmall[4];             // small window sizes LTWH
  char   *path;                 // variable search path
  BOOL   usepath;               // 1=use path, 0=use global (forget it..)
  struct Event *topbt;         // first of list of EVENTs
  struct var *topvar;           // first of list of this gui's variables
  struct guifile *next;         // next gui file
  // ------------- private fields below
};

/*********************************************************************
	MAIN Gui4CLi STRUCTURE
   !!! This is the structure you receive in the msg->gcmain field !!!
   It's main use is to get a pointers to the top gui file (from where
   you can see all events and all commands), or to the current lv
   or to the Global variable list etc...
**********************************************************************/

struct GCmain
{  
   LONG magic;                   // sanity check  (MM_G4C = 4848484)

   struct guifile *topguifile;   // first of a linked list of gui files
   struct Event *curbt;          // current event pointer (for local vars etc)
   struct Event *curgad;	 		// GAD - current gadget pointer (for info)
   struct guifile *curgf;        // GUI - current gui pointer
   struct fulist *curlv;         // LV  - current listview pointer
   struct var *gtopvar;          // linked list of Global variables
   struct imginfo *topimage;     // top of linked list of images

   LONG tab;                     // tabsize
   char *pipebuff;               // pointer to pipe buffer
   LONG grid;                    // grid size for visual edit def=1
   LONG maxtransloop;            // set to 100 - how many times translate can retranslate the buffer before error
   UBYTE  defscreenname[40];     // default screen name (* = front screen)

   // general purpose memory buffers (you can use them for temporary storage)
   char *membuff[5];		// 5 main memory buffers of buffsize length
   LONG buffsize;		// size of buffers

   // These are available for use.. (used internally as flags etc)
   LONG num;                            // SPARE LONG
   char buff[256];                      // SPARE BUFFER
   char *pt, *pt2;                      // SPARE CHARACTER POINTERs
   __aligned struct FileInfoBlock fib;  // SPARE fib
   __aligned BPTR lk;                   // SPARE BPTR

   // for internal variables
   LONG   src_pos;                      // position for searchvar
   LONG   src_length;                   // var length for searchvar
   USHORT red, green, blue;             // Last Palette's RGB values
   LONG   color, totcolors;             // + color number + No of colors
   struct imginfo *curimg;              // current image
   LONG   mx, my;                       // mouse position

   // holding place for the default font (MONOspace)
   struct TextAttr __aligned ta;        // our txtattr for the MONO font
   UBYTE  fontbuff[40];                 // buffer for font name

   // ------------------ private fields below..

};

/*********************************************************************
	Magic numbers
	Some of these are used to check the "sanity" of	Gui4Cli, 
	and others to identify where messages are comming from.
**********************************************************************/

#define MM_PIPE_LAUNCH	6511841 // pipe launch identifier
#define MM_PIPE_DATA	4523666 // pipe data identifier
#define MM_PIPE_RDV     4526789	// magic for pipe rendez-vous struct
#define MM_LAUNCH	7250838 // launch message identifier
#define MM_GFILE	7225825	// gui file sanity check
#define MM_C_GUI	7226625 // c:gui identifier
#define MM_LISTVIEW     22108   // lv sanity check
#define MM_G4C          4848484	// gcmain struct's sanity check
#define MM_OUTSIDER     392001  // the g4cmsg message identifier




