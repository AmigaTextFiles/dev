#ifndef SSDATELIB_PROTOS_H
#define SSDATELIB_PROTOS_H
/********************************************************************
*      Society                   : PGES
*      Project                   : SSToolLib
*
*      Creation author           : SS
*      Module name               : $RCSfile: SSDateLib_protos.h,v $
*      Module version            : $Revision: 1.1.1.1 $
*      Current version date      : $Date: 2003/04/08 15:03:45 $
*
*      Description               : I/O Tools (stdin, files, ...)
*
*      Host                      : C-ANSI
*      Target                    : C-ANSI
*
*      Programmation language    : C-ANSI
*      Creation date             : Tue Apr 08 15:56:51 2003
*
*      Prefixe                   : ss_
*
*      References                : -
*
*         PGES proprietary and confidential information
*          Copyright (C) PGES - (All rights reserved)
*                ----------------------------------
*
*      CVS history               : 
*         $Log: SSDateLib_protos.h,v $
*         Revision 1.1.1.1  2003/04/08 15:03:45  saragaglia
*         First insertion in CVS.
*         Contains String, Date, and I/O libs
*
*
*******************************************************************/

/*******************************************************************
 * INCLUDES
*******************************************************************/

/*******************************************************************
 * SIGNATURE DES FONCTIONS
*******************************************************************/
#ifdef __cplusplus
extern "C"
{
#endif
  
  extern char* ss_getdate(void);

#ifdef __cplusplus
}
#endif

#endif //#ifndef SSDATELIB_PROTOS_H
