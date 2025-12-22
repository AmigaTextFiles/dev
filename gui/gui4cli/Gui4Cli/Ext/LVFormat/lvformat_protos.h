/* Prototypes for functions defined in
lvformat.c
 */

LONG anyname(void);

struct MsgPort * openport(char * , struct ExecBase * , struct DosLibrary * );

void closeport(struct MsgPort * , struct ExecBase * , struct DosLibrary * );

int sendmsg(UBYTE * , LONG , UBYTE * , struct ExecBase * , struct DosLibrary * );

void makeupper(UBYTE * );

BOOL isin(UBYTE , UBYTE * );

int indentlist(struct GCmain * , UBYTE * , struct ExecBase * , struct DosLibrary * );

int unindentlist(struct GCmain * , struct ExecBase * , struct DosLibrary * );

int agclean(struct GCmain * , struct ExecBase * , struct DosLibrary * );

UBYTE * getlink(UBYTE * , UBYTE ** );

UBYTE * nextword(UBYTE * , UBYTE ** );

BOOL agcomp(UBYTE * , UBYTE * , UBYTE * , UBYTE * );

int rewrap(struct GCmain * , LONG , UBYTE * , SHORT , struct ExecBase * , struct DosLibrary * );

LONG justify(UBYTE * , UBYTE * , UBYTE * , LONG , struct ExecBase * , struct DosLibrary * );

LONG centertxt(UBYTE * , UBYTE * , UBYTE * , LONG , struct ExecBase * , struct DosLibrary * );

struct List * getlist(struct ExecBase * , struct DosLibrary * );

int freelist(struct List * , struct ExecBase * , struct DosLibrary * );

int addline(struct fulist * , UBYTE * , LONG , struct ExecBase * , struct DosLibrary * );

struct lister * getlister(UBYTE * , LONG , struct ExecBase * , struct DosLibrary * );

