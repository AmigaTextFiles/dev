#ifndef SSIOLIB_PROTOS_H
#define SSIOLIB_PROTOS_H
/********************************************************************
*      Society                   : PGES
*      Project                   : Circ
*
*      Creation author           : SS
*      Module name               : $RCSfile: SSIoLib_protos.h,v $
*      Module version            : $Revision: 1.2 $
*      Current version date      : $Date: 2003/04/09 14:18:59 $
*
*      Description               : I/O Tools (stdin, files, ...)
*
*      Host                      : C-ANSI
*      Target                    : C-ANSI
*
*      Programmation language    : 
*      Creation date             : Thu Jan 02 14:31:13 2003
*
*      Prefixe                   : ss_
*
*      References                : fclc (usenet)
*
*         PGES proprietary and confidential information
*          Copyright (C) PGES - (All rights reserved)
*                ----------------------------------
*
*      CVS history               : 
*         $Log: SSIoLib_protos.h,v $
*         Revision 1.2  2003/04/09 14:18:59  saragaglia
*         Add : New function ss_fgetline() which read an entire line from a file, allocate a string which contains it, and return it...
*         Modification : changed returned error-codes
*
*         Revision 1.1.1.1  2003/04/08 15:03:45  saragaglia
*         First insertion in CVS.
*         Contains String, Date, and I/O libs
*
*
*******************************************************************/

/*******************************************************************
 * INCLUDES
*******************************************************************/
#include <stdlib.h>

/*******************************************************************
 * SIGNATURE DES FONCTIONS
 *******************************************************************/
#ifdef __cplusplus
extern "C"
{
#endif
  
  extern int ss_getline(char *buf, size_t size);
  extern char* ss_fgetline(FILE *pm_fd);

#ifdef __cplusplus
}
#endif

#endif //#ifndef SSIOLIB_PROTOS_H
