/*----------------------------------------------------
  Misc.h
  Version 0.1
  Date: 13.12.1998
  Author: Bodmer Stephan (bodmer2@uni2a.unige.ch)
  Note: Miscellenous help function
-----------------------------------------------------*/
#define MC68000     0
#define MC68010     1
#define MC68020     2
#define MC68030     3
#define MC68040     4
#define MC68060     6

#define MC6888x     10


#ifdef __cplusplus
extern "C" {
#endif
int CheckCPU();
BOOL CheckFPU();
void ConvertDisplayID (char *, int);
BOOL OpenASL (char *title, char *sdir, char *sname , char *filename, char *dir, char *name);
#ifdef __cplusplus
}
#endif
