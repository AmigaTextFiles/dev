/*
**  $Filename: VisualArts_protos.h $
**  $Includes, V2.5 $
**  $Date: 95/04/25$
**
**
**  (C) 1994-95 Danny Y. Wong  			
**  All Rights Reserved
**
**  DO NOT MODIFY
*/


/*  Visual Arts function prototypes. All are in the VisualArts.lib 
*/

extern void DrawBox(struct Window *Wind, int Left, int Top, int Wid, int Hi, UBYTE APen, short Pattern );
extern void DrawFBox(struct Window *Wind, int Left, int Top, int Wid, int Hi, UBYTE APen, short Pattern, UBYTE Outline, short Fill );
extern void DrawLine(struct Window *Wind, int Left, int Top, int Wid, int Hi, UBYTE APen, short Pattern );
extern void DrawNCircle(struct Window *Wind, int Left, int Top, int Right, int Bottom, UBYTE APen);
extern void DrawFCircle(struct Window *Wind, int Left, int Top, int Right, int Bottom, UBYTE APen, short Pattern, UBYTE Outline, short Fill );
extern void SetRPortFill(struct Window *Wind, short Type);
extern void ButtonSelected(struct Window *wind, struct Gadget *gad);
extern int AddNewNode(struct List *list, char name[]);
extern int DeleteNode(struct List *list, char name[]);
extern struct List *GetNewList(void);
extern struct NameNode *FindNodeName(struct List *list, char name[]);
extern struct NameNode *FindNodeNo(struct List *list, UWORD index);
extern void FreeList(struct List *list);
extern APTR   VisualInfo;
extern struct Screen *Scr;
extern  struct WindowNode *AddWindowNode(struct List *list, char name[], APTR handler);
extern int DelWindowNode(struct List *list, char name[]);
extern struct WindowNode *FindWindowNode(struct List *list, char name[]);
extern void FreeWindowList(struct List *list);
extern void ReMakeWindowID(struct List *list);
extern void closeRexxPort(void);
extern void handlerRexxPort(void);
extern struct RexxMsg *asyncRexxCmd(char *s);
extern void replyRexxCmd(register struct RexxMsg *msg, register long primary,
                  register long secondary, register char *string);
extern long InitRexxPort(char *s, struct rexxCommandList *rcl,
                  char *exten, int (*uf)());
extern int dispatchRexx(register struct RexxMsg *msg, register struct rexxCommandList *dat, char *p);
extern Object *NewImageObject(ULONG which);
extern struct Gadget *NewPropObject(ULONG freedom, Tag tag1, ...);
extern struct Gadget *NewButtonObject(Object *image, Tag tag1, ...);
extern int SysISize(void);
extern int VA_GadLayout(struct Window *window, struct Gadget *glist,
                  struct Gadget *projgadgets[],
                  ULONG fsgads[], WORD gadtypes[],
                  struct NewGadget *gadgets, ULONG tags[],
                  struct List *lists[], UBYTE *projvars[]);
extern int VA_GadLayoutA(struct Window *window, struct Gadget *glist,
                  struct Gadget *projgadgets[],
                  ULONG fsgads[], WORD gadtypes[],
                  struct NewGadget *gadgets, ULONG tags[],
                  struct List *lists[], UBYTE *projvars[]);
void InitLayoutVars(ULONG types[], UBYTE *vars[]);

/* console functions */
extern int OpenConsole( struct IOStdReq *writerequest,
                        struct IOStdReq *readrequest,
                        struct Window *window);
extern int ConPutChar(struct IOStdReq *request, char character);
extern int ConPutStr(struct IOStdReq *request, char *string);
extern int QueueRead(struct IOStdReq *request, char *whereto);

/*  speech functions */
extern int InitSpeech(void);
extern void DeInitSpeech(void);
extern int Speak(char sentence[], short vol, short rate, short sex);

/* serial interface functions */
extern int SetParams(
   struct IOExtSer *io,
   unsigned long rbuf_len,
   unsigned char rlen,
   unsigned char wlen,
   unsigned long brk,
   unsigned long baud,
   unsigned char sf,
   unsigned long ta0,
   unsigned long ta1 );
extern int QueueSerRead(struct IOExtSer *request, char *whereto);
extern int SerPutChar(struct IOExtSer *request, char character);
extern int SerPutString(struct IOExtSer *request, char *string);
extern int OpenSerial(struct IOExtSer *readrequest, struct IOExtSer *writerequest);

/* clip board functions */
extern BOOL CBReadLine(long device, char *string);
extern BOOL CBWriteLine(long device, char *string);

/* ASL font and file requester */
extern BOOL ASLGetFontName(struct TextAttr *textAttr,
                struct Window *window,
                int left, int top, int width, int height, ULONG flags);
extern BOOL ASLGetFileName(char *filename, struct Window *window,
                   int left, int top, int width, int height,
                   char *title,
                   char *path,
                   ULONG flags);
extern LONG VARequester(struct Window *wind, char *title, char *format, 
                 char *choices, BOOL beep);
extern BOOL ASLGetScrMode(struct ScreenModeRequester *scrmodereq,
                struct Window *window,
                int left, int top, int width, int height, ULONG flags);

