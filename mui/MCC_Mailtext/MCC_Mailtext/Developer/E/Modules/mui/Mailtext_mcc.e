/*

    MCC_Mailtext (C) 1996-1998 by Olaf Peters <olf@gmx.de>

    Registered class of the Magic User Interface

    Mailtext_mcc.m (E version by William Newton <wnewton@zetnet.co.uk>)

*/

OPT MODULE
OPT PREPROCESS
OPT EXPORT

/*** Include stuff ***/

MODULE 'libraries/mui'

/*** MUI Defines ***/


#define MUIC_Mailtext 'Mailtext.mcc'

#define MailtextObject Mui_NewObjectA(MUIC_Mailtext,[TAG_IGNORE,0

#define MUIM_Mailtext_CopyToClip             $8057013c
#define MUIA_Mailtext_IncPercent             $80570103  /* v10 [ISG] */
#define MUIA_Mailtext_Text                   $80570105  /* v10 [ISG] */
#define MUIA_Mailtext_QuoteChars             $80570107  /* v10 [ISG] */
#define MUIA_Mailtext_ForbidContextMenu      $80570136  /* v18 [I..] */
#define MUIA_Mailtext_ActionEMail            $8057013a  /* v19 [..G] */
#define MUIA_Mailtext_ActionURL              $8057013b  /* v18 [..G] */
#define MUIA_Mailtext_DisplayRaw             $80570139  /* v18 [.SG] */
#define MUIA_Mailtext_Wordwrap               $8057013d  /* v18 [.SG] */

