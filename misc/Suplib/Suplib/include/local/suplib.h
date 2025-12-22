
/*
 *  SUPLIB.H
 */

extern void asyhandler ARGS((void));
extern void nop ARGS((void));
extern void *NewAsyncOp ARGS((void));
extern void StartAsyncOp ARGS((void *, void (*)(), int, int, int));
extern int CheckAsyncOp ARGS((void *, long));
extern void WaitAsyncOp ARGS((void *, long));
extern void CloseAsyncOp ARGS((void *));
extern __stdargs void PutA4A5 ARGS((void *));
extern __stdargs void CallAMFunc ARGS((void *, void *));

extern void disablebreak   ARGS((void));
extern void enablebreak    ARGS((void));
extern int checkbreak	   ARGS((void));

extern WIN *GetConWindow ARGS((void));
extern char *datetos ARGS((DATESTAMP *, char *, char *));

extern int DeadKeyConvert ARGS((struct IntuiMessage *,ubyte *,int,struct KeyMap *));

extern void *dio_open ARGS((char *, long, long, void *));
extern void dio_dfm ARGS((void *, long));
extern void dio_ddl ARGS((void *, long));
extern void dio_cact ARGS((void *, long));
extern void dio_close ARGS((void *));
extern void dio_closegroup ARGS((void *));
extern void *dio_dup ARGS((void *));
extern int  dio_signal ARGS((void *));
extern void dio_flags ARGS((void *, long, long));
extern void *dio_ctl_to ARGS((void *, long, char *, long, long));
extern void *dio_ctl ARGS((void *, long, char *, long));
extern void *dio_isdone ARGS((void *));
extern void *dio_wait ARGS((void *));
extern void *dio_abort ARGS((void *));

extern char *GetDEnv ARGS((char *));
extern int   SetDEnv ARGS((char *, char *));

extern __stdargs void fhprintf ARGS((BPTR, char *, ... ));

extern FONT *GetFont ARGS((char *, short));
extern void ScanIffFH ARGS((BPTR, long, void *));
extern void ScanIff ARGS((void *, void *, BPTR));
extern long IffRead ARGS((void *, BPTR, char *, long));

extern void InitDeemuNW ARGS((short *, NW *));

/*
 *  LWP.ASM  XXXX
 */

extern void mountrequest ARGS((int));

extern __stdargs long MulDiv ARGS((long,long,long));
extern __stdargs ulong MulDivU ARGS((ulong,ulong,ulong));

extern int openlibs ARGS((uword));
extern void closelibs ARGS((uword));
extern int DoOption ARGS((int, char **, char *, ...));
extern long resetbreak ARGS((void));

extern __stdargs int AutoAllocMiscResource ARGS((long,long));
extern __stdargs void AutoFreeMiscResource ARGS((long));

extern int setfiledate ARGS((char *, DATESTAMP *));

extern __stdargs void SetStackCheck ARGS((long));
extern __stdargs long GetStackCheck ARGS((long));

extern void *xfopen ARGS((char *, char *, long));
extern int xfclose ARGS((void *));
extern long xfseek ARGS((void *, long));
extern int xfgets ARGS((void *, char *, long));
extern long xfread ARGS((void *, char *, long));
extern long xfwrite ARGS((void *, char *, long));

extern XLIST   *llink ARGS((XLIST **, XLIST *));
extern XLIST   *lunlink ARGS((XLIST *));

extern __stdargs void EnqueueLong ARGS ((LIST *, void *, void *, long));
extern __stdargs void EnqueueOffLong ARGS ((LIST *, void *, void *, long, long));
extern __stdargs long SearchFwdList ARGS ((LIST *, long (*)(), long));
extern __stdargs long SearchFwdListOff ARGS ((LIST *, long (*)(), long, long));
extern __stdargs long SearchFwdNode ARGS ((void *, long (*)(), long));
extern __stdargs long SearchFwdNodeOff ARGS ((void *, long (*)(), long, long));
extern __stdargs long SearchRvsNode ARGS ((void *, long (*)(), long));
extern __stdargs long SearchRvsNodeOff ARGS ((void *, long (*)(), long, long));

extern char *DateToS ARGS ((DATESTAMP *, char *, char *));
extern void utos ARGS ((char *, short, short, long));
extern int SetFileDate ARGS ((char *, DATESTAMP *));

/*
 *  from common library
 */

extern __stdargs void BZero ARGS((void *, long));
extern __stdargs int BCmp ARGS((void *, void *, long));
extern __stdargs void BMov ARGS((void *, void *, long));
extern __stdargs void BSet ARGS((void *, long, long));

extern int  MakeRastPortBitMap ARGS((RP *, BM *, short, short, short, long, short));
extern void FreeRastPortBitMap ARGS((RP *));
extern int  MakeBitMap ARGS((BM *, short, short, short, ulong));
extern void FreeBitMap ARGS((BM *));
extern void OpenGfxLibrary ARGS((void));

extern void SetNewScreen ARGS((NS *, ulong, SCR *));
extern int GetStdWidth ARGS((void));
extern int GetStdHeight ARGS((void));
extern void OpenIntuitionLibrary ARGS((void));

extern		 void *GetSucc ARGS((void *));
extern		 void *GetHead ARGS((void *));
extern		 void *GetTail ARGS((void *));
extern		 void *GetPred ARGS((void *));
extern __stdargs void *GetHeadOff ARGS((void *, long));
extern __stdargs void *GetTailOff ARGS((void *, long));
extern __stdargs void *GetSuccOff ARGS((void *, long));
extern __stdargs void *GetPredOff ARGS((void *, long));
extern __stdargs void *RemHeadOff ARGS((void *, long));
extern __stdargs void *RemTailOff ARGS((void *, long));

extern __stdargs long WildCmp ARGS((char *, char *));

extern APTR    GetTaskData ARGS((char *, long));
extern int     FreeTaskData ARGS((char *));

extern __stdargs void	 *DoSyncMsg ARGS((PORT *, void *));
extern __stdargs void	 *WaitMsg ARGS((void *));
extern __stdargs int	 CheckMsg ARGS((void *));
extern __stdargs void	 *CheckPort ARGS((PORT *));
extern __stdargs void	 TaskLock ARGS((void *));
extern __stdargs void	 TaskUnlock ARGS((void *));
extern void    LockAddr ARGS((void *));
extern void    LockAddrB ARGS((int, void *));
extern void    UnlockAddr ARGS((void *));
extern void    UnlockAddrB ARGS((int, void *));
extern __stdargs void	 *FindName2 ARGS((void *, char *));

extern int     FreeTaskData ARGS((char *));
extern APTR    GetTaskData ARGS((char *, long));

extern int     MakeRastPort ARGS((RP *, BM *, long, short));
extern void    FreeRastPort ARGS((RP *));




