#ifndef  CLIB_AEDOOR_PROTOS_H
#define  CLIB_AEDOOR_PROTOS_H
/*
**	$Filename: clib/asl_protos.h $
**	$Release: V2.4 $
**	$Revision: 1.0 $
**	$Date: 94/12/12 $
**
**	C prototypes. For use with 32 bit integers only.
**
*/
#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  LIBRARIES_AEDOOR_H
#include <libraries/aedoor.h>
#endif

struct DIFace *CreateComm(unsigned long);
void DeleteComm(struct DIFace *);
void SendCmd(struct DIFace *,unsigned long);
void SendStrCmd(struct DIFace *,unsigned long ,char *);
void SendDataCmd(struct DIFace *,unsigned long ,unsigned long );
void SendStrDataCmd(struct DIFace *,unsigned long ,char *,unsigned long );
int  *GetData(struct DIFace *);
char *GetString(struct DIFace *);
char *Prompt(struct DIFace *,unsigned long , char *);
void WriteStr(struct DIFace *,char *,unsigned long );
void ShowGFile(struct DIFace *,char *);
void ShowFile(struct DIFace *,char *);
void SetDT(struct DIFace *,unsigned long ,char *);
void GetDT(struct DIFace *,unsigned long ,char *);
char *GetStr(struct DIFace *,unsigned long , char *);
void CopyStr(struct DIFace *, char *);
long Hotkey(struct DIFace *, char *);
void PreCreateComm(unsigned long);
void PostDeleteComm(unsigned long);

#endif	 /* CLIB_AEDOOR_PROTOS_H */
