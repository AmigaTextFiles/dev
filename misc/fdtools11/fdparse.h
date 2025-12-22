/* fdparse.h */

#ifndef FDPARSE_H
#define FDPARSE_H

#define IDLEN 255

#include <proto/exec.h>
#include <proto/dos.h>
#include <string.h>

struct fd {
  BPTR  fd_Input;
  ULONG fd_State;
  LONG  fd_Offset;
  ULONG fd_NumParams;
  BYTE  fd_Parameter[14];
  UBYTE fd_BaseName[IDLEN+1];
  UBYTE fd_Function[IDLEN+1];
  BOOL  fd_IsTagFunc;
};

#define FD_PARSING 0
#define FD_READY   1

#define FD_PUBLIC  0
#define FD_PRIVATE 2

#define FD_BIAS    4

#define REG_D(n) (n)
#define REG_A(n) ((n)+8)

#define FD_ERROR    0
#define FD_KEYWORD  1
#define FD_FUNCTION 2
#define FD_COMMENT  3

extern void InitFD(BPTR fdfile,struct fd *fd);
extern int ParseFD(struct fd *fd);
extern BOOL TagCallName(struct fd *fd);
extern BOOL LibCallAlias(struct fd *fd);

#endif
