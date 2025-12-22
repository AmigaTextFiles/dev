/* Prototypes for functions defined in
wclrtobot.c
 */

int wclrtobot(WINDOW * );

/* Prototypes for functions defined in
flushinp.c
 */

int flushinp(void);

/* Prototypes for functions defined in
wgetstr.c
 */

int wgetstr(WINDOW * , char * );

/* Prototypes for functions defined in
subwin.c
 */

WINDOW * subwin(WINDOW * , unsigned int , unsigned int , unsigned int , unsigned int );

/* Prototypes for functions defined in
mvprintw.c
 */

int mvprintw(short , short , char * , ...);

/* Prototypes for functions defined in
wscanw.c
 */

int wscanw(WINDOW * , char * , char * , char * , char * , char * , char * , char * , char * , char * , char * , char * );

/* Prototypes for functions defined in
scanw.c
 */

int scanw(char * , char * , char * , char * , char * , char * , char * , char * , char * , char * , char * );

/* Prototypes for functions defined in
mvwscanw.c
 */

int mvwscanw(WINDOW * , short , short , char * , char * , char * , char * , char * , char * , char * , char * , char * , char * , char * );

/* Prototypes for functions defined in
mvscanw.c
 */

int mvscanw(short , short , char * , char * , char * , char * , char * , char * , char * , char * , char * , char * , char * );

/* Prototypes for functions defined in
printw.c
 */

int printw(char * , ...);

/* Prototypes for functions defined in
newwin.c
 */

WINDOW * newwin(unsigned int , unsigned int , unsigned int , unsigned int );

/* Prototypes for functions defined in
_creatwin.c
 */

WINDOW * _CreatWindow(int , int , int , int , WINDOW * );

/* Prototypes for functions defined in
touchwin.c
 */

int touchwin(WINDOW * );

/* Prototypes for functions defined in
delwin.c
 */

int delwin(WINDOW * );

/* Prototypes for functions defined in
mvwin.c
 */

int mvwin(WINDOW * , short , short );

/* Prototypes for functions defined in
scroll.c
 */

int scroll(WINDOW * );

/* Prototypes for functions defined in
wsetscrreg.c
 */

int wsetscrreg(WINDOW * , short , short );

/* Prototypes for functions defined in
_scroll.c
 */

int _Scroll(WINDOW * , int , int , int );

/* Prototypes for functions defined in
scrollok.c
 */

int scrollok(WINDOW * , int );

/* Prototypes for functions defined in
wnoutrefresh.c
 */

int wnoutrefresh(WINDOW * );

/* Prototypes for functions defined in
doupdate.c
 */

int doupdate(void);

/* Prototypes for functions defined in
echo.c
 */

int echo(void);

/* Prototypes for functions defined in
noecho.c
 */

int noecho(void);

/* Prototypes for functions defined in
beep.c
 */

int beep(void);

/* Prototypes for functions defined in
wrefresh.c
 */

int wrefresh(WINDOW * );

/* Prototypes for functions defined in
initscr.c
 */

int initscr(void);

/* Prototypes for functions defined in
wgetch.c
 */

int wgetch(WINDOW * );

/* Prototypes for functions defined in
wstandout.c
 */

int wstandout(WINDOW * );

/* Prototypes for functions defined in
keypad.c
 */

int keypad(WINDOW * , char );

/* Prototypes for functions defined in
flash.c
 */

int flash(void);

/* Prototypes for functions defined in
initcolour.c
 */

int init_color(WORD , UWORD , UWORD , UWORD );

/* Prototypes for functions defined in
_data.c
 */

extern struct IntuitionBase * IntuitionBase;

extern struct GfxBase * GfxBase;

extern struct Library * ConsoleDevice;

extern struct IOStdReq ioreq;

extern struct Screen * _CursesScreen;

extern struct Window * _CursesWindow;

extern struct MsgPort * _CursesMsgPort;

extern struct RastPort * _RPort;

extern struct ViewPort * _VPort;

extern BPTR _ifh;

extern BYTEBITS _CursesFlags;

extern int _CursesType;

extern short _CursorCol;

extern short _CursorLine;

extern short _LCursorLine;

extern short _LCursorCol;

extern struct RefreshElement * _HeadRefreshList;

extern WINDOW * stdscr;

extern WINDOW * curscr;

extern int LINES;

extern int COLS;

extern int DEPTH;

extern int _FontHeight;

extern int _FontWidth;

extern int _FontBase;

extern unsigned char _GetchNChars;

extern unsigned char _GetchBufPos;

extern char * __area;

extern char * __capary[128];

extern int __no_caps;

extern char * _clstr;

extern char * _cmstr;

/* Prototypes for functions defined in
startcolour.c
 */

int start_color(void);

/* Prototypes for functions defined in
hascolours.c
 */

int has_colors(void);

/* Prototypes for functions defined in
waddstr.c
 */

int waddstr(WINDOW * , char * );

/* Prototypes for functions defined in
waddch.c
 */

int waddch(WINDOW * , char );

/* Prototypes for functions defined in
winsch.c
 */

int winsch(WINDOW * , char );

/* Prototypes for functions defined in
wdelch.c
 */

int wdelch(WINDOW * );

/* Prototypes for functions defined in
wclear.c
 */

int wclear(WINDOW * );

/* Prototypes for functions defined in
werase.c
 */

int werase(WINDOW * );

/* Prototypes for functions defined in
clearok.c
 */

int clearok(WINDOW * , int );

/* Prototypes for functions defined in
wclrtoeol.c
 */

int wclrtoeol(WINDOW * );

/* Prototypes for functions defined in
wstandend.c
 */

int wstandend(WINDOW * );

/* Prototypes for functions defined in
wattrset.c
 */

int wattrset(WINDOW * , UBYTE );

/* Prototypes for functions defined in
wattron.c
 */

int wattron(WINDOW * , UBYTE );

/* Prototypes for functions defined in
wattroff.c
 */

int wattroff(WINDOW * , UBYTE );

/* Prototypes for functions defined in
cbreak.c
 */

int cbreak(void);

/* Prototypes for functions defined in
nocbreak.c
 */

int nocbreak(void);

/* Prototypes for functions defined in
idlok.c
 */

int idlok(WINDOW * , int );

/* Prototypes for functions defined in
winsertln.c
 */

int winsertln(WINDOW * );

/* Prototypes for functions defined in
wdeleteln.c
 */

int wdeleteln(WINDOW * );

/* Prototypes for functions defined in
nodelay.c
 */

int nodelay(WINDOW * , int );

/* Prototypes for functions defined in
resetty.c
 */

int resetty(void);

/* Prototypes for functions defined in
savetty.c
 */

int savetty(void);

/* Prototypes for functions defined in
resetterm.c
 */

int resetterm(void);

/* Prototypes for functions defined in
fixterm.c
 */

int fixterm(void);

/* Prototypes for functions defined in
saveterm.c
 */

int saveterm(void);

/* Prototypes for functions defined in
baudrate.c
 */

int baudrate(void);

/* Prototypes for functions defined in
nl.c
 */

int nl(void);

/* Prototypes for functions defined in
nonl.c
 */

int nonl(void);

/* Prototypes for functions defined in
box.c
 */

int box(WINDOW * , char , char );

/* Prototypes for functions defined in
mvwprintw.c
 */

int mvwprintw(WINDOW * , short , short , char * , ...);

/* Prototypes for functions defined in
_togcur.c
 */

void _ToggleCursor(int , int );

/* Prototypes for functions defined in
wmove.c
 */

int wmove(WINDOW * , short , short );

/* Prototypes for functions defined in
_zapcur.c
 */

void _ZapCursor(void);

/* Prototypes for functions defined in
_drawcur.c
 */

void _DrawCursor(void);

/* Prototypes for functions defined in
_exit.c
 */

void _CleanExit(int );

/* Prototypes for functions defined in
endwin.c
 */

int endwin(void);

/* Prototypes for functions defined in
mvcur.c
 */

int mvcur(int , int , int , int );

/* Prototypes for functions defined in
wprintw.c
 */

int wprintw(WINDOW * , char * , ...);

/* Prototypes for functions defined in
leaveok.c
 */

int leaveok(WINDOW * , int );

/* Prototypes for functions defined in
winch.c
 */

int winch(WINDOW * );

/* Prototypes for functions defined in
_doecho.c
 */

void _DoEcho(WINDOW * , char );

/* Prototypes for functions defined in
_cleanup.c
 */

void _CleanUp(void);

/* Prototypes for functions defined in
_ansi.c
 */

void _ANSIInit(void);

void _ANSIClear(void);

void _ANSIMove(int , int );

void _ANSIFlash(void);

void _ANSIClearRect(int , int , int , int );

long _RawMode(BPTR );

long _CanonMode(BPTR );

/* Prototypes for functions defined in
gettmode.c
 */

int gettmode(void);

/* Prototypes for functions defined in
longname.c
 */

char * longname(char * , char * );

/* Prototypes for functions defined in
overlay.c
 */

int overlay(WINDOW * , WINDOW * );

/* Prototypes for functions defined in
overwrite.c
 */

int overwrite(WINDOW * , WINDOW * );

/* Prototypes for functions defined in
_mergewin.c
 */

int _mergewin(WINDOW * , WINDOW * , char );

/* Prototypes for functions defined in
setterm.c
 */

int setterm(char * );

/* Prototypes for functions defined in
unctrl.c
 */

char * unctrl(char );

/* Prototypes for functions defined in
tgetent.c
 */

int tgetent(char * , char * );

/* Prototypes for functions defined in
tgetstr.c
 */

char * tgetstr(char * , char ** );

/* Prototypes for functions defined in
tputs.c
 */

int tputs(char * , int , int (* )(char ));

/* Prototypes for functions defined in
tgoto.c
 */

char * tgoto(char * , int , int );

/* Prototypes for functions defined in
tgetnum.c
 */

int tgetnum(char * );

/* Prototypes for functions defined in
tgetflag.c
 */

int tgetflag(char * );

