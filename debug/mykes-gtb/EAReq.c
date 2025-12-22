/*-- AutoRev header do NOT edit!
*
*   Program         :   EAReq.c
*   Copyright       :   © Copyright 1991 Jaba Development
*   Author          :   Jan van den Baard
*   Creation Date   :   02-Oct-91
*   Current version :   1.00
*   Translator      :   DICE v2.6
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   02-Oct-91     1.00            Ask & Error requesters.
*
*-- REV_END --*/

#include	"defs.h"

extern struct Window        *MainWindow;

struct EasyStruct            ea_EasyS = {
    (long)sizeof( struct EasyStruct ), 0l, 0l, 0l, 0l };

long MyRequest( UBYTE *hail, UBYTE *gadgets, UBYTE *body, ... )
{
    va_list     args;
    long        ret;

    va_start( args, body );

    ea_EasyS.es_Title           =   hail;
    ea_EasyS.es_TextFormat      =   body;
    ea_EasyS.es_GadgetFormat    =   gadgets;

    ret = EasyRequestArgs( MainWindow, &ea_EasyS, 0l, args );

    va_end( args );

    ClearMsgPort( MainWindow->UserPort );

    return( ret );
}
