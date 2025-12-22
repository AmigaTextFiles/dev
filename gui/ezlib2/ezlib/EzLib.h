/* Ezlib header file.
 *
 * This file contains protos and various #defines for use with Ezlib.
 *
 * Dominic Giampaolo © 1991
 */

/* Screens (and BitMaps) */
struct Screen   *CreateScreen(int modes, int depth);

struct BitMap   *GetBitMap(int  depth, int width, int height);

int              FreeBitMap(struct BitMap *bm, int width, int height);

void             KillScreen(struct Screen *screen);


/* Windows */
struct Window   *CreateWindow(struct Screen *screen,
                               SHORT leftedge, SHORT topedge,
                               SHORT width,    SHORT height,
                               ULONG flags,    ULONG idcmp);

struct Window   *MakeWindow(struct Screen *screen,
                             SHORT leftedge, SHORT topedge,
                             SHORT width,    SHORT height);

void             KillWindow(struct Window *window);


/* Gadgets, Create Level calls */
struct Gadget   *CreateBoolGadget(SHORT l_edge,  SHORT t_edge,
                                   USHORT flags, USHORT activation,
                                   char *text,   USHORT id);

struct Gadget   *CreateImgGadget(SHORT l_edge,  SHORT t_edge,
                                  USHORT flags, USHORT activation,
                                  struct Image *img, struct Image *hi_img,
                                  USHORT id);

struct Gadget   *CreateStringGadget(SHORT l_edge, SHORT t_edge, USHORT len,
                                    USHORT flags, USHORT activation,
                                    char *def_string,  USHORT id);

struct Gadget   *CreatePropGadget(SHORT l_edge,  SHORT t_edge,
                                   SHORT width,  SHORT  height,
                                   USHORT flags, USHORT activation,
                                   USHORT kind,  USHORT id);


/* Gadgets, Make Level calls */
struct Gadget   *MakeBoolGadget(struct Window *window,
                                 SHORT l_edge, SHORT t_edge,
                                 char *text,   USHORT id);

struct Gadget   *MakeToggleGadget(struct Window *window,
                                  SHORT l_edge, SHORT t_edge,
                                  char *text,   USHORT id);

struct Gadget   *MakeImgGadget(struct Window *window,
                                SHORT l_edge, SHORT t_edge,
                                struct Image *img, struct Image *hi_img,
                                USHORT id);

struct Gadget   *MakeImgToggle(struct Window *window,
                                SHORT l_edge, SHORT t_edge,
                                struct Image *img, struct Image *hi_img,
                                USHORT id);

struct Gadget   *MakeStringGadget(struct Window *window,
                                  SHORT l_edge, SHORT t_edge, USHORT len,
                                  char *def_string,   USHORT id);

struct Gadget   *MakeIntGadget(struct Window *window,
                                SHORT l_edge, SHORT t_edge, USHORT len,
                                char *def_string,   USHORT id);

struct Gadget   *MakePropGadget(struct Window *window,
                                 SHORT l_edge, SHORT t_edge,
                                 SHORT width,  SHORT height,
                                 SHORT  kind,  USHORT id);

struct Gadget   *MakeVertProp(struct Window *window,
                                SHORT l_edge, SHORT t_edge,
                                SHORT width,  SHORT height,
                                USHORT flags, USHORT activation,
                                USHORT id);

struct Gadget   *MakeHorizProp(struct Window *window,
                                SHORT l_edge, SHORT t_edge,
                                SHORT width,  SHORT height,
                                USHORT flags, USHORT activation,
                                USHORT id);

void             SetPropGadg(struct Window *win, struct Gadget *gadg,
                               int top, int displayed, int max);

int              GetPropValue(struct Gadget *gadg);

int              RealtimeProp(struct Window *win, struct Gadget *gadg,
                                void (*func)(), void *data);

void             KillGadget(struct Window *win, struct Gadget *gadget);



/* Fonts */
struct TextFont *GetFont(char *name, int size);


/* Miscellaneous */
char            *GetString(struct Window *window, char *title, char *defstr);
int              GetYN(struct Window *win, char *text);
int              LacedWB(void);
void             PickHighlightColors(struct Screen *screen);



/* Libraries */
int              OpenLibs( int which_ones);
void             CloseLibs(int which_ones);

/* these define's are for use with OpenLibs() and CloseLibs() */
#define GFX         0x0001
#define INTUI       0x0002
#define INTUITION   0x0002
#define ARP         0x0004
#define DFONT       0x0008
#define DISKFONT    0x0008
#define TRANSLATOR  0x0010
#define ICONBASE    0x0080
#define REXX        0x0100
#define ALL_LIBS    0xffff

/* easier way to set colors on a custom screen */
#define SetColor(screen, num, color) (SetRGB4(&screen->ViewPort, num, (0x0f00&color)>>8, (0x00f0&color)>>4, (0x000f&color) ))
#define BLACK     0x0000
#define WHITE     0x0fff
#define RED       0x0f00
#define GREEN     0x00f0
#define BLUE      0x000f
#define YELLOW    0x0ff0
#define CYAN      0x00ff
#define PINK      0x0f09
#define PURPLE    0x0f0f
#define GREY0     0x0ccc
#define GREY      0x0aaa
#define GREY1     0x0888
#define GREY2     0x0666
#define GREY3     0x0444
#define GOLD      0x0ea1
#define ORANGE    0x0f70
#define INDIGO    0x070e



/* various other tidbits that make life a little easier */

/* print messages to stdout */
#define MSG(a) do { char *tmp = (char *)a; if (Output()) \
                    Write(Output(), tmp, strlen(tmp)); } while(0)

/* Print text in a window via graphics primitives */
#define Print(rp, a) do { char *tmp = (char *)a; \
                       Text(rp, tmp, strlen(tmp)); } while(0)

/* two trivial additions to the graphics primitives */
#define Line(rp, a, b, c, d) do { Move(rp, a, b); Draw(rp, c, d); } while(0)
#define Circle(rp, x, y, rad) (DrawEllipse(rp, x, y, rad, rad))

/* just a quickie to make calls to makescreen() a little more clear */
#define LORES 0x0000

