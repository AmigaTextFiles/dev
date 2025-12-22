/*
**   ((( frumSPlugs )))
** ©1996 Stephen Sinclair
**
** This source may be copied or edited in any
** way you wish.
**
** This file is part of the frumSPlugs package,
** and may only be distributed with it.
*/

/* Test for TextPanel plugin */
-> $VER: TextPanelTest.e V1.0 Stephen Sinclair (96.07.15)

OPT OSVERSION=37
MODULE 'Tools/EasyGUI','Plugins/TextPanel','Intuition/Screens',
       'Graphics/Text'

DEF tpp:PTR TO textpanelplugin

PROC main() HANDLE
  easygui('TextPanelTest',
    [ROWS,
      [TEXT,'TextPanel:',NIL,FALSE,2],

/* Create a demonstration text panel, showing all the different things **
** you can do with the textpanel formatting codes.  It will have the   **
** system default font, a beveled box around it, and a BACKGROUNDPEN   **
** coloured background (which is the default).                         */
      [PLUGIN,0,NEW tpp.textpanelplugin(['\eac\esb\esufrumSPlugs V1.1\esn',NIL,
                                         '\eBAR',NIL,
                                         '\eac©1996 Stephen Sinclair',NIL,
                                         'One of \esbfrumSPlugs''\esb new features:',NIL,
                                         '\eac\ess\ep\cThe Text Panel\esn',[SHINEPEN],
                                         '\eBAR',NIL,
                                         '  The text panel allows you to display',NIL,
                                         'bodies of text for any purpose you want,',NIL,
                                         'for example, \esiAbout\esi windows.',NIL,
                                         '\eBAR',NIL,
                                         '  You can use formatting features such as:',NIL,
                                         '\eac\esbBold\esb \esuUnderlined\esu \esiItalics\esi \ese\ep\cEmbossed \ess\ep\cShadowed\esn',[BACKGROUNDPEN,SHINEPEN],
                                         '\eBAR',NIL,
                                         '\eac\ec\cIn \ec\cAny \ec\cColour \ec\cYou \ec\cWant!\esn',[7,2,1,2,7],
                                         '\eBAR',NIL,
                                         '  All text can be on the',NIL,
                                         'Left,',NIL,
                                         '\earRight,',NIL,
                                         '\eacor Center.',NIL],
                                         NIL,TRUE,BEVEL,PATTERN OR DRAWINFOPENS,[FILLPEN,BACKGROUNDPEN])],
      [BUTTON,0,'Great!']
    ])
EXCEPT DO
  END tpp
  IF exception > 0 THEN WriteF('\s\n',[exception,0])
ENDPROC

CHAR '$VER: TextPanelTest V1.0 Stephen Sinclair (96.07.15)',0
