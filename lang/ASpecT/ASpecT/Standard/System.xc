#include <stdio.h>

void
DEFUN(xx_Systemwrite_string_0,(S,SysI,Ok,SysO),
      TERM S     AND
      TERM SysI  AND
      TERM *Ok   AND
      TERM *SysO)
 { unsigned I,LEN;
   char *SC;
   TERM H=S;
   *SysO = SysI;
   while (LEN=OPN(H)) {
     if (LEN > MAXSTR) {SC = (char *)(H->ARGS[1]); LEN -= MAXSTR;}
     else {SC = (char *) &(H->ARGS[1]); }
     for (I=0; I < LEN; I++) C_OUT(*SC++);
     H = H->ARGS[0];
   }
   SC = (char *)(H->ARGS[1]);
   while (*SC) C_OUT(*SC++);
   free__RUNTIME_string(S);
   *Ok = true;
 }

void
DEFUN(xx_Systemread_char_0,(SysI,Ok,Char,SysO),
      TERM SysI  AND
      TERM *Ok   AND
      TERM *Char AND
      TERM *SysO)
 {
   *SysO = SysI;
   *Char = (TERM)(unsigned) GET_CHAR();
   if ((int)*Char == EOF) *Ok = false;
   else 		  *Ok = true;
 }

void
DEFUN(xx_Systemunread_char_0,(Char,SysI,Ok,SysO),
      TERM Char  AND
      TERM SysI  AND
      TERM *Ok AND
      TERM *SysO)
 {
   *SysO = SysI;
   if (UG_MODE!=0)
      *Ok = false;
   else { 
      *Ok = true;
      UG_CHAR= __tchar((int)Char);
      UG_MODE= 1;
   }
 }
  
XINITIALIZE(System_Xinitialize,__XINIT_System)
