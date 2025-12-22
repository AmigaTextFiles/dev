/*

    MCC_Mailtext (C) 1996-1998 by Olaf Peters <olf@gmx.de>

    Registered class of the Magic User Interface

    Mailtext_mcc.h

*/

/*** Include stuff ***/

#ifndef MAILTEXT_MCC_H
#define MAILTEXT_MCC_H

#ifndef LIBRARIES_MUI_H
#include "libraries/mui.h"
#endif

/*** MUI Defines ***/

#define MUIC_Mailtext  "Mailtext.mcc"

#define MailtextObject MUI_NewObject(MUIC_Mailtext

#define MUIM_Mailtext_CopyToClip            0x8057013c
#define MUIA_Mailtext_IncPercent            0x80570103  /* v10 [ISG] */
#define MUIA_Mailtext_Text                  0x80570105  /* v10 [ISG] */
#define MUIA_Mailtext_QuoteChars            0x80570107  /* v10 [ISG] */
#define MUIA_Mailtext_ForbidContextMenu     0x80570136  /* v18 [I..] */
#define MUIA_Mailtext_ActionEMail           0x8057013a  /* v19 [..G] */
#define MUIA_Mailtext_ActionURL             0x8057013b  /* v18 [..G] */
#define MUIA_Mailtext_DisplayRaw            0x80570139  /* v18 [.SG] */
#define MUIA_Mailtext_Wordwrap              0x8057013d  /* v18 [.SG] */

#endif /* MAILTEXT_MCC_H */

