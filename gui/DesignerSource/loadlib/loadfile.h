struct codestore
{
	UBYTE             ProcedureOptions[50];
	UBYTE             CodeOptions[20];
	UBYTE             OpenLibs[30];
	long              VersionLibs[30];
	UBYTE             AbortOnFailLibs[30];
	char              compilername[52];
	char              includeextra[256];
	long              fileversion;
};

struct gadgetstore
{
	long              leftedge;
	long              topedge;
	long              width;
	long              height;
	long              kind;
	char              title[68];
	long              id;
	long              flags;
	char              labelid[68];
	char              fontname[48];
	UWORD             fontysize;
	UBYTE             fontstyle;
	UBYTE             fontflags;
	struct TagItem    tags[15];
	UBYTE             joined;
	UBYTE             pad1;
	char              datas[68];
	long              listfollows;
	long              specialdata;
	char              EditHook[256];
	char              Contents[86];
	long              Contents2;
};

struct textstore
{
	long              leftedge;
	long              topedge;
	UBYTE             placed;
	UBYTE             pad1;
	char              title[68];
	UBYTE             frontpen;
	UBYTE             backpen;
	UBYTE             drawmode;
	UBYTE             pad2;
	char              fontname[48];
	UWORD             fontysize;
	UBYTE             fontstyle;
	UBYTE             fontflags;
	UBYTE             screenfont;
};

struct bevelboxstore
{
	long              leftedge;
	long              topedge;
	long              width;
	long              height;
	UWORD             beveltype;
	char              title[32];
};

struct smallimagestore
{
	long              leftedge;
	long              topedge;
	UBYTE             placed;
	UBYTE             pad1;
	char              title[68];
	char              imagename[68];
};

struct windowstore
{
    UBYTE             codeoptions[20];
    UWORD             dripens[10];
    long              offx;
    long              offy;
    UBYTE             offsetsdone;
    UBYTE             pad1;
    long              nextid;
    UBYTE             useoffsets;
    UBYTE             pad2;
    char              title[68];
    long              leftedge;
    long              topedge;
    long              width;
    long              height;
    char              screentitle[68];
    long              minw;
    long              maxw;
    long              minh;
    long              maxh;
    long              innerw;
    long              innerh;
    char              labelid[68];
    UWORD             zoom[4];
    long              mousequeue;
    long              rptqueue;
    UBYTE             sizegad;
    UBYTE             sizebright;
    UBYTE             sizebbottom;
    UBYTE             dragbar;
    UBYTE             depthgad;
    UBYTE             closegad;
    UBYTE             reportmouse;
    UBYTE             nocarerefresh;
    UBYTE             borderless;
    UBYTE             backdrop;
    UBYTE             gimmezz;
    UBYTE             activate;
    UBYTE             rmbtrap;
    UBYTE             simplerefresh;
    UBYTE             smartrefresh;
    UBYTE             autoadjust;
    UBYTE             menuhelp;
    UBYTE             usezoom;
    UBYTE             customscreen;
    UBYTE             pubscreen;
    UBYTE             pubscreenname;
    UBYTE             pubscreenfallback;
    long              flags;
    char              screenmodeprefs[78];
    struct TextAttr   pad3;
    char              fontname[48];
    UBYTE             idcmplist[25];
    UBYTE             pad4;
    char              menutitle[68];
    struct TextAttr   gadgetfont;
    char              gadgetfontname[48];
    UWORD             fontx;
    UWORD             fonty;
    char              winparams[256];
    UBYTE             extracodeoptions[20];
    UBYTE             moretags[6];
    UBYTE             localeoptions[6];
    char              defpubname[82];
};

struct localestore
{
char getstring[72];
char builtinlanguage[72];
long version;
char basename[72];
long numberofnodes;
};

struct localenodestore
{
char  labl[72];
char  comment[72];
char  str[256];
};

struct tagstore
{
UWORD tagtype;
char  title[68];
long  value;
long  datasize;
long  data;
char  dataname[68];
};

struct screenstore
{
char   labelid[256];
UWORD  left;
UWORD  top;
UWORD  width;
UWORD  height;
UWORD  depth;
UBYTE  overscan;
UBYTE  fonttype;
UBYTE  behind;
UBYTE  quiet;
UBYTE  showtitle;
UBYTE  autoscroll;
UBYTE  bitmap;
UBYTE  createbitmap;
char   title[256];
UBYTE  loctitle;
UBYTE  pad1;
long   idnum;
UWORD  screentype;
char   pubname[256];
UBYTE  dopubsig;
UBYTE  defpens;
UBYTE  fullpalette;
UBYTE  pad2;
struct TextAttr font;
char   fontname[52];
long   sizecolorarray;
UWORD  penarray[31];
UBYTE  errorcode;
UBYTE  sharedpens;
UBYTE  draggable;
UBYTE  exclusive;
UBYTE  interleaved;
UBYTE  likeworkbench;
};

struct imagestorehead
{
char   title[68];
long   leftedge;
long   topedge;
long   width;
long   height;
UWORD  depth;
UBYTE  planepick;
UBYTE  planeonoff;
long   sizedata;
};

struct menustore
{
char  text[68];
char  idlabel[68];
long  frontpen;
struct TextAttr font;
char  fontname[48];
UBYTE defaultfont;
UWORD nexttitle;
UBYTE pad;
UBYTE localmenu;
};

struct titlestore
{
char  idlabel[68];
char  text[68];
UBYTE disabled;
UWORD nextitem;
};

struct itemstore
{
char   idlabel[68];
UBYTE  barlabel;
UBYTE  pad;
char   text[68];
char   graphicname[68];
char   commkey[4];
UBYTE  disabled;
UBYTE  checkit;
UBYTE  menutoggle;
UBYTE  checked;
UBYTE  textprint;
long   exclude;
UWORD  nextsub;
};

struct subitemstore
{
char   idlabel[68];
UBYTE  barlabel;
UBYTE  pad;
char   text[68];
char   graphicname[68];
char   commkey[4];
UBYTE  disabled;
UBYTE  checkit;
UBYTE  menutoggle;
UBYTE  checked;
UBYTE  textprint;
long   exclude;
};