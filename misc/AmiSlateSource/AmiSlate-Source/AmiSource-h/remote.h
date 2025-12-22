/* remote.h -- analogous drawing functions for the remote entity */
#ifndef REMOTE_H
#define REMOTE_H

/* Codes for Wprint and Wread --direct where to read/write to/from */
#define DEST_FILE 0x0001
#define DEST_PEER 0x0002
#define FROM_FILE 0x0004
#define FROM_PEER 0x0008

BOOL Synch(void);
BOOL RemoteHandler(FILE *fpFile, BOOL BEchoToRemote);
BOOL FillArgs(UWORD uwNext, int nLastArg);
BOOL CheckStandardEscapes(UWORD uwNext);

BOOL OutputAction(UBYTE bFromCode, UWORD uwModeID, UWORD arg1, UWORD arg2, UWORD arg3, UWORD arg4, LONG DestCode);
BOOL Remote_Pen(int nX, int nY);
BOOL Remote_Dot(int nX, int nY);
BOOL Remote_Line(int X1, int Y1, int X2, int Y2);
BOOL Remote_Circle(int X, int Y, int RX, int RY);
BOOL Remote_Square(int X1, int Y1, int X2, int Y2);
BOOL Remote_Poly(void);
BOOL Remote_Flood(int X1, int Y1, UWORD uwExpectedFilledColor);

VOID ReceivedQuitStuff(void);
VOID ResetArgCount(void);
VOID Wprint(UWORD uwWord, LONG DestCode);
VOID SendPalette(void);
VOID RemoteEasyReq(void);
VOID RemoteStringReq(void);
VOID RemoteRexxCommand(void);

UWORD Wread(FILE *fpFile, LONG FromCode);

#endif
