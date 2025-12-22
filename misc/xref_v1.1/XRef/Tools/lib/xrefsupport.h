/*
** $PROJECT: xrefsupport.lib
**
** $VER: xrefsupport.h 1.2 (09.09.94) 
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 09.09.94 : 001.002 :  ScanWindow added
** 04.09.94 : 001.001 :  initial
*/

/* ------------------------------- define's ------------------------------- */

#define BUFFER_SIZE        1024

enum {
   FTYPE_UNKNOWN,
   FTYPE_HEADER,           /* c header file */
   FTYPE_AUTODOC,          /* commodore autodoc file format */
   FTYPE_DOC,              /* normal ascii document */
   FTYPE_AMIGAGUIDE,       /* commodore amigaguide format */
   FTYPE_MAN,              /* unix manual page format */
   FTYPE_INFO,             /* GNU InfoView file format (not implemented yet!) */
   };

#define SPM_FILE           1
#define SPM_DIR            2

#define TIME_USED          0
#define TIME_EXPECTED      1
#define TIME_LEFT          2

/* ----------------------------- structure's ------------------------------ */

struct Buffer
{
   STRPTR b_Ptr;
   UBYTE b_Buffer[BUFFER_SIZE];
};

struct SaveDefIcon
{
   STRPTR sdi_DefaultIcon;
   STRPTR sdi_DefaultTool;
   STRPTR *sdi_ToolTypes;
   struct Image *sdi_Image;
};

/* scan_pattern() function callback hook message see SPM_#? */

struct spMsg
{
   ULONG Msg;
   struct FileInfoBlock *Fib;
   BPTR FHandle;
   STRPTR Path;
   STRPTR RealPath;
};

struct ScanStat
{
   ULONG ss_Files;
   ULONG ss_Directories;
   ULONG ss_TotalFileSize;

   ULONG ss_ActFiles;
   ULONG ss_ActDirectories;
   ULONG ss_ActTotalFileSize;
};

struct Gauge
{
   struct RastPort *RPort;
   UWORD Left;
   UWORD Top;
   UWORD Right;
   UWORD Bottom;
   UWORD FillPen;
   UWORD LastPixel;
};

struct ScanWindow
{
   struct Window *sw_Window;
   struct TextAttr sw_TextAttr;
   struct TextFont *sw_TextFont;

   UWORD sw_YTop;
   UWORD sw_YStep;
   UWORD sw_XTop;
   UWORD sw_XMax;
   UWORD sw_XTime;
   UWORD sw_YTime;
   UWORD sw_XTimeMax;

   UWORD sw_TextPen;
   UWORD sw_BackPen;

   struct Gauge sw_Total;
   struct Gauge sw_Actual;

   UBYTE sw_FontName[32];
};

struct TimeCalc
{
   ULONG tc_Secs[3];
   ULONG tc_BeginSec;
   ULONG tc_BeginMic;

   ULONG tc_LastSec;
   UWORD tc_TimeCalled;
   UWORD tc_Update;
};

/* --------------------------- extern variables --------------------------- */

extern const STRPTR ftype[];

/* ------------------------- function prototypes -------------------------- */

/* chechsuffix.c */
BOOL checksuffix(STRPTR file,STRPTR suffix);

/* checkentrytype.c */
ULONG checkentrytype(STRPTR name);

/* getfiletype.c */
ULONG getfiletype(BPTR fh,STRPTR file);

/* insertbyname.c */
void insertbyname(struct List *list,struct Node *node);

/* insertbyiname.c */
void insertbyiname(struct List *list,struct Node *node);

/* saveicon.c */
void saveicon(STRPTR file,struct SaveDefIcon *def_icon);

/* showerror.c */
void showerror(STRPTR prgname,STRPTR header,LONG error);

/* writebuffer.c */
void mysprintf(struct Buffer *buf,STRPTR fmt,APTR arg,...);

/* calctextwidth.c */
UWORD calctextwidth(struct RastPort *rp,STRPTR *textarray);

/* convertsuffix.c */
void convertsuffix(ULONG filetype,STRPTR file);

/* getamigaguidenode.c */
void getamigaguidenode(STRPTR *nameptr,STRPTR *titleptr);

/* getmaxdigitwidth.c */
UWORD getmaxdigitwidth(struct RastPort *rp);

/* gauge.c */
void draw_gaugeinit(struct Window *win,struct Gauge *gauge,UBYTE shinepen,UBYTE shadowpen);
void draw_gauge(struct Gauge *gauge,ULONG actual,ULONG maximal);

/* scanpattern.c */
LONG scan_patterns(STRPTR *patterns,struct Hook *callback,APTR userdata);
void getscanstat(STRPTR *patterns,struct ScanStat *stat);

/* scanwindow.c */
BOOL open_scanwindow(struct ScanWindow *swin,STRPTR *texts,STRPTR title,UWORD winwidth);
void close_scanwindow(struct ScanWindow *swin,BOOL abort);
void draw_scanwindowstatus(struct ScanWindow *swin,STRPTR string);
void draw_scanwindowtext(struct ScanWindow *swin,ULONG num,STRPTR string);
void draw_scanwindowtime(struct ScanWindow *swin,ULONG *secs);

/* timecalc.c */
void time_init(struct TimeCalc *time,ULONG update);
void time_calc(struct TimeCalc *time,ULONG actual,ULONG total);
