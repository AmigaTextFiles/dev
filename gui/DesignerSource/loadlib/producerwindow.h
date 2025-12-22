/*********************************************/
/*                                           */
/*       Designer (C) Ian OConnor 1994       */
/*                                           */
/*      Designer Produced C header file      */
/*                                           */
/*********************************************/



#define pwnWinFirstID 0
#define BackgroundFrame 0
#define RecessedFrame 1
#define AbortButton 2
#define FileDisplayGadget 3
#define ActionDisplayGadget 4
#define LinesDisplayGad 5

extern ULONG pwnWinGadgetTags[];
extern UWORD pwnWinGadgetTypes[];
extern struct NewGadget pwnWinNewGadgets[];
extern APTR WaitPointer;
extern UWORD WaitPointerData[];

extern void RendWindowpwnWin( struct Window *Win, void *vi, struct ProducerNode * pwn );
extern int OpenWindowpwnWin( struct ProducerNode * pwn);
extern void CloseWindowpwnWin( struct ProducerNode * pwn );
extern int MakeImages( void );
extern void FreeImages( void );

