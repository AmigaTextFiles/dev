/* Prototypes for functions defined in
gcsound.c
 */

int main(void);

struct MsgPort * openport(char * , struct ExecBase * , struct DosLibrary * );

void closeport(struct MsgPort * , struct ExecBase * , struct DosLibrary * );

struct myhandle * findaudio(struct IOAudio * , struct myhandle * );

int docommand(LONG , struct base * , UBYTE * , UBYTE * , UBYTE * , UBYTE * );

struct myhandle * findsample(char * , struct myhandle * );

void get_args(struct myhandle * , struct base * , UBYTE * , UBYTE * , UBYTE * );

void killall(struct base * );

void makeret(struct myhandle * );

void makeupper(UBYTE * );

int playsound(struct myhandle * , struct DosLibrary * , struct ExecBase * );

int setVolSpeed(struct myhandle * );

void abortsound(struct myhandle * );

BOOL getconstant(struct base * );

struct myhandle * loadsample(char * , struct base * );

LONG getchunk(LONG , BPTR , struct DosLibrary * , struct ExecBase * );

void initsample(struct myhandle * , char * , struct base * );

BOOL reload(struct myhandle * );

void freehandle(struct myhandle * );

void remlink(struct myhandle * );

struct RDArgs * readargs(LONG * , LONG , UBYTE * , UBYTE * , struct base * );

void freeargs(struct RDArgs * , struct base * );

