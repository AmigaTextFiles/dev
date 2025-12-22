/************************************************************************/
/*                                                                      */
/*             Protos and pragmas for Comal routines                    */
/*                                                                      */
/*                      version 93.02.09                                */
/*                                                                      */
/*                                                                      */
/*                                                                      */
/************************************************************************/

extern struct ComalStruc *ComalStruc;

/* Protos */
void ErrorNumber(short ErrorCode);
void ErrorText(char *ErrorText);
void ExecBreak(void);
struct Window *LockComalWindow(void);
void UnlockComalWindow(void);
void AddComalDevice(struct IoDevice *Device);
void RemComalDevice(struct IoDevice *Device);
unsigned long ComalWait(unsigned long SignalMask);
void AddExcept(struct ExceptStruc *Except);
void RemExcept(struct ExceptStruc *Except);
void AddSignal(unsigned long SignalMask);
void RemSignal(unsigned long SignalMask);
short GetAccept(char *Str, char *Accept, char *Cancel);

/* Pragmas  */

#pragma libcall ComalStruc ErrorNumber 06 201
#pragma libcall ComalStruc ErrorText 0C 001
#pragma libcall ComalStruc ExecBreak  12 0
#pragma libcall ComalStruc LockComalWindow 18 0
#pragma libcall ComalStruc UnLockComalWindow  1E 0
#pragma libcall ComalStruc AddComalDevice 24 801
#pragma libcall ComalStruc RemComalDevice  2A 801
#pragma libcall ComalStruc ComalWait 30 001
#pragma libcall ComalStruc AddExcept  36 801
#pragma libcall ComalStruc RemExcept 3C 801
#pragma libcall ComalStruc AddSignal  42 001
#pragma libcall ComalStruc RemSignal 48 001
#pragma libcall ComalStruc GetAccept 4E A9803
