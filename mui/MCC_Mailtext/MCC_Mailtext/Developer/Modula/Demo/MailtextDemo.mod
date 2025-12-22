MODULE MailtextDemo ;

(*
** $VER: MailtextDemo 1.0 (29.4.96)
**
** Olaf Peters <olf@gmx.de>
**
** $HISTORY:
**
**  28.1.96  1.0   : initial
**
*)

FROM SYSTEM       IMPORT  ADR, ADDRESS, TAG, LONGSET, CAST ;
FROM Arts         IMPORT  Exit ;
FROM AmigaLib     IMPORT  DoMethodA ;
FROM ExecL        IMPORT  Wait ;
FROM MuiMacros    IMPORT  Child ;
FROM MuiSupport   IMPORT  DoMethod ;
FROM UtilityD     IMPORT  tagDone ;

IMPORT
        m  : MuiD,
        ml : MuiL,
        mm : MuiMacros,
        mt : MCCMailtext ;

(* MUI-Tags that are obsolete in MUI v3 *)

CONST mmApplicationInput               = 8042D0F5H; (* V4  *)

CONST
  cTestText = "Testtext for Mailtext CustomClass\n"
             +"\n"
             +"*Bold* /Italics/ _Underline_ #Coloured#\n"
             +"\n"
             +"Quoted Text:\n"
             +"\n"
             +"Quote> *Bold* /Italics/ _Underline_ #Coloured#\n" ;

CONST
  True  = LONGINT(TRUE) ;
  False = LONGINT(FALSE) ;

  cTemplate    = "FILE/A" ;
  cProgName    = "MailtextDemo" ;
  cVersion     = "1.0 (29.4.96)" ;
  cVersionInfo = cProgName + " " + cVersion + " by Olaf Peters" ;
  cVersionID   = "$VER: " + cProgName + " " + cVersion ;
  cGetItIn     = ADR(cVersionID) ;

VAR
  app,
  win,
  mailtext,
  lv,
  grp : ADDRESS ;

  signals   : LONGSET ;
  result    : ADDRESS ;
  running   : BOOLEAN ;

  tags      : ARRAY [0..31] OF LONGINT ;


BEGIN
  app := mm.ApplicationObject(TAG(tags, m.maApplicationCopyright,   ADR("© 1996 by Olaf Peters"),
                                        m.maApplicationAuthor,      ADR("Olaf Peters"),

                                        m.maApplicationTitle,       ADR(cProgName),
                                        m.maApplicationVersion,     ADR(cVersion),
                                        m.maApplicationDescription, ADR("mailtext.mcc Demoprogram."),
                                        m.maApplicationBase,        ADR("MailtextDemo"),
                                        m.maApplicationSingleTask,  FALSE,
                                   tagDone)) ;
  IF app = NIL THEN
    IF ml.mRequestA(NIL, NIL, 0, ADR(cProgName), ADR("**_Okay"), ADR("Cannot create application"), NIL) # 0 THEN END ;
    Exit(20) ;
  END (* IF *) ;

  mailtext := ml.mNewObject(ADR(mt.mcMailtext), TAG(tags, m.maFrame, m.mvFrameInputList,
                                                          m.maFont,  m.mvFontFixed,
                                                          mt.maMailtextText, ADR(cTestText),
                                                    tagDone)) ;

  lv := mm.ListviewObject(TAG(tags, m.maListviewList, mailtext,
                                    m.maListviewInput, FALSE,
                                    m.maListviewMultiSelect, FALSE,
                              tagDone)) ;

  grp  := mm.GroupObject(TAG(tags, Child, lv, tagDone)) ;
  win := mm.WindowObject(TAG(tags, m.maWindowTitle,    ADR("MailtextDemo by Olaf Peters"),
                                   m.maWindowID,       mm.MakeID("SMTC"),
                                   m.maWindowWidth,    m.mvWindowWidthVisible(50),
                                   m.maWindowHeight,   m.mvWindowHeightVisible(75),
                                   mm.WindowContents,  grp,
                             tagDone)) ;

  IF win # NIL THEN
    mm.AddMember(app, win) ;
    mm.NoteClose(app, win, m.mvApplicationReturnIDQuit) ;
  ELSE
    IF ml.mRequestA(app, NIL, 0, ADR(cProgName), ADR("**_Okay"), ADR("Windowinit failed"), NIL) # 0 THEN END ;
    Exit(20) ;
  END (* IF *) ;

  mm.set(win, m.maWindowOpen, True) ;

  running := TRUE ;

  WHILE running DO
    result := DoMethodA(app, TAG(tags, mmApplicationInput, ADR(signals),tagDone)) ;

    CASE result OF
    | m.mvApplicationReturnIDQuit : running := FALSE ;
    ELSE
    END (* CASE *) ;

    IF running AND (signals # LONGSET{}) THEN
      signals := Wait(signals);
    END (* IF *) ;
  END (* WHILE *) ;

CLOSE

  IF app # NIL THEN
    ml.mDisposeObject(app) ;
    app := NIL ;
  END (* IF *) ;
END MailtextDemo .
