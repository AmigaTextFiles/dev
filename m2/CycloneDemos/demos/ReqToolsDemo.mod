(*#-- BEGIN AutoRevision header, please do NOT edit!
*
*   Program         :   ReqToolsDemo.mod
*   Copyright       :   © 1995 by Marcel Timmermans
*   Author          :   Marcel Timmermans
*   Address         :   A. DekenStraat 22 6836 RM Arnhem
*   Creation Date   :   25-03-1995
*   Current version :   1.0
*   Translator      :   AMC V0.45 (no offical release)
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   25-03-1995     1.0            Demostartion program in Modula-2 for      
*                                 Reqtools library                          
*
*-- END AutoRevision header --*)

MODULE ReqToolsDemo;

FROM SYSTEM   IMPORT ADR,SETREG,REG,ASSEMBLE,ADDRESS,TAG,LONGSET,CAST;
FROM ModulaLib IMPORT kickVersion;
FROM IntuitionD IMPORT IDCMPFlags,IDCMPFlagSet;
FROM UtilityD  IMPORT TagItemPtr,tagEnd;
IMPORT rt:ReqTools;

VAR
    filename:ARRAY[0..40] OF CHAR;
    l:LONGINT;
    adr,adr2:ADDRESS;
    buffer:ARRAY[0..127] OF CHAR;
    tagbuf:ARRAY [0..15] OF LONGINT;  
    longnum:LONGINT;
    ret:LONGINT;
    color:LONGINT;
    filereq: rt.FileRequesterPtr;
    fontreq: rt.FontRequesterPtr;
    scrmodereq: rt.ScreenModeRequesterPtr;


BEGIN
 rt.vEZRequest(ADR("ReqTools 2.0 Demo\n"+
              "~~~~~~~~~~~~~~~~~\n"+
              "'reqtools.library' offers several\ndifferent types of requesters:"),
              ADR("Let's see them"), NIL, NIL, NIL);

 rt.vEZRequest (ADR("NUMBER 1:\nThe larch :-)"),ADR("Be serious!"), NIL, NIL,NIL);

 rt.vEZRequest (ADR("NUMBER 1:\nString requester\nfunction: rt.GetString()"),
              ADR("Show me"),NIL, NIL, NIL);

 buffer:='A bit of text';
 IF ~rt.GetString(ADR(buffer),127,ADR("Enter anything:"), NIL,TAG(tagbuf,tagEnd)) THEN
    rt.vEZRequest (ADR("You entered nothing :-("),ADR("I'm sorry"),NIL, NIL, NIL);
 ELSE
    adr:=TAG(tagbuf,ADR(buffer),tagEnd);
    rt.vEZRequest(ADR("You entered this string:\n'%s'."),
                ADR("So I did"), NIL, NIL, adr);
 END;

 adr:=ADR("These are two new features of ReqTools 2.0:\n"+
            "Text above the entry gadget and more than\n"+
            "one response gadget.");
 adr2:=ADR(" _Ok |New _2.0 feature!|_Cancel");
 IF rt.GetString (ADR(buffer),127,ADR("Enter anything:"),NIL,
                   TAG(tagbuf,rt.gsGadFmt,adr2,
                   rt.gsTextFmt,adr,rt.Underscore,"_",tagEnd)) THEN 
 END;
 adr:=ADR(" _Ok |_Abort|_Cancel");
 adr2:=ADR("New is also the ability to switch off the\n"+
           "backfill pattern.  You can also center the\n"+
           "text above the entry gadget.\n"+
           "These new features are also available in\n"+
           "the rtGetLong() requester.");
 IF rt.GetString (ADR(buffer), 127,ADR("Enter anything:"),NIL,
                  TAG(tagbuf,rt.gsGadFmt,adr,rt.gsTextFmt,adr2,
                  rt.gsBackfill,FALSE,
                  rt.gsFlags,LONGSET{rt.gsReqCenterText,rt.gsReqHighlightText},
                  rt.Underscore,"_",tagEnd)) THEN END;
  rt.vEZRequest (ADR("NUMBER 2:\nNumber requester\nfunction: rt.GetLong()"),
              ADR("Show me"),NIL, NIL, NIL);

  IF NOT rt.GetLong (longnum,ADR("Enter a number:"), NIL,
                     TAG(tagbuf,rt.glShowDefault,FALSE,tagEnd)) THEN
    rt.vEZRequest (ADR("You entered nothing :-("),ADR("I'm sorry"),NIL, NIL, NIL);
  ELSE
    adr:=ADR(longnum);
    rt.vEZRequest (ADR("The number you entered was:\n%ld"),
                ADR("So it was"), NIL, NIL,adr);
  END;

  rt.vEZRequest (ADR("NUMBER 3:\nMessage requester, the requester\n"+
              "you've been using all the time!\nfunction: rt.EZRequest()"),
              ADR("Show me more"),NIL, NIL, NIL);

  rt.vEZRequest (ADR("Simplest usage: some body text and\na single centered gadget."),
              ADR("Got it"),NIL, NIL, NIL);

  WHILE NOT (rt.EZRequest (ADR("You can also use two gadgets to\n"+
                        "ask the user something.\n"+
                        "Do you understand?"),ADR("Of course|Not really"),
                        NIL, NIL, NIL) # 0) DO
    rt.vEZRequest (ADR("You are not one of the brightest are you?\n"+
                "We'll try again..."),
                ADR("Ok"),NIL, NIL, NIL);
  END; (* WHILE *)

  rt.vEZRequest (ADR("Great, we'll continue then."),ADR("Fine"),NIL, NIL, NIL);

  (*$ CaseTab+ *)
  (* Casetabel geneartion has to be on, otherwise compiler run out of 
     registers!
  *)

  CASE rt.EZRequest (ADR("You can also put up a requester with\n"+
                  "three choices.\n"+
                  "How do you like the demo so far ?"),
                  ADR("Great|So so|Rubbish"),NIL, NIL, NIL) OF
    | 0:
      rt.vEZRequest (ADR("Too bad, I really hoped you\nwould like it better."),
                  ADR("So what"),NIL, NIL, NIL);
    | 1:
      rt.vEZRequest (ADR("I'm glad you like it so much."),ADR("Fine"),NIL, NIL, NIL);
    | 2:
      rt.vEZRequest (ADR("Maybe if you run the demo again\n"+
                  "you'll REALLY like it."),
                  ADR("Perhaps"),NIL, NIL, NIL);
  END; (* CASE *)

  ret := rt.EZRequestTags (ADR("The number of responses is not limited to three\n"+
                        "as you can see.  The gadgets are labeled with\n"+
                        "the return code from rt.EZRequest().\n"+
                        "Pressing Return will choose 4, note that\n"+
                        "4's button text is printed in boldface."),
                        ADR("1|2|3|4|5|0"), NIL, NIL,
                        TAG(tagbuf,rt.ezDefaultResponse, 4, tagEnd));
  adr:=ADR(ret);
  rt.vEZRequest (ADR("You picked '%ld'."),ADR("How true"), NIL, NIL,adr);
  rt.vEZRequestTags (ADR("New for Release 2.0 of ReqTools (V38) is\n"+
                  "the possibility to define characters in the\n"+
                  "buttons as keyboard shortcuts.\n"+
                  "As you can see these characters are underlined.\n"+
                  "Pressing shift while still holding down the key\n"+
                  "will cancel the shortcut.\n"+
                  "Note that in other requesters a string gadget may\n"+
                  "be active.  To use the keyboard shortcuts there\n"+
                  "you have to keep the Right Amiga key pressed down."),
                  ADR("_Great|_Fantastic|_Swell|Oh _Boy"),
                  NIL,NIL,
                  TAG(tagbuf,rt.Underscore, '_', tagEnd));

  adr := ADR ("five"); tagbuf[5]:=5; tagbuf[6]:=adr;
  adr2:=ADR(tagbuf[5]);
  rt.vEZRequest (
    ADR("You may also use C-style formatting codes in the body text.\n"+
    "Like this:\n\n"+
    "'The number %%ld is written %%s.' will give:\n\n"+
    "The number %ld is written %s.\n\n"+
    "if you also pass '5' and '\"five\"' to rt.EZRequest()."),
    ADR("_Proceed"), NIL, TAG(tagbuf,rt.Underscore,"_",tagEnd),adr2);

  IF (diskInserted IN CAST (IDCMPFlagSet,rt.EZRequestTags
             (ADR("It is also possible to pass extra IDCMP flags\n"+
              "that will satisfy rt.EZRequest(). This requester\n"+
              "has had DISKINSERTED passed to it.\n"+
              "(Try insert.ing a disk)."),
              ADR("_Continue"), NIL, NIL,
              TAG(tagbuf,rt.IDCMPFlags,IDCMPFlagSet{diskInserted},rt.Underscore,"_",tagEnd)))) THEN
    rt.vEZRequest (ADR("You inserted a disk."),ADR("I did"),NIL, NIL, NIL);
  ELSE
    rt.vEZRequest (ADR("You used the 'Continue' gadget\n"+
                "to satisfy the requester."),ADR("I did"),NIL, NIL, NIL);
  END;

  rt.vEZRequestTags (ADR("Finally, it is possible to specify the position\n"+
              "of the requester.\n"+
              "E.g. at the top left of the screen, like this.\n"+
              "This works for all requesters, not just rt.EZRequest()!"),
              ADR("_Amazing"), NIL, NIL,
              TAG(tagbuf,rt.ReqPos, rt.ReqPosTopLeftScr,rt.Underscore,"_",tagEnd));

  rt.vEZRequestTags (ADR("Alternatively, you can center the\n"+
                  "requester on the screen.\n"+
                  "Check out 'reqtools.doc' for all the possibilities."),
                  ADR("I'll do that"), NIL, NIL,
                  TAG(tagbuf,rt.ReqPos, rt.ReqPosCenterScr,tagEnd));

  adr:=TAG(tagbuf,rt.Underscore,"_",tagEnd);
  rt.vEZRequest (ADR("NUMBER 4:\nFile requester\n"+
              "function: rt.FileRequest()"),ADR("_Demonstrate"),NIL,adr,NIL);
 
  filereq := rt.AllocRequestA (rt.TypeFileReq, NIL);
  IF filereq # NIL THEN
     filename := ""; 
    IF rt.FileRequestA(filereq, ADR(filename),ADR("Pick a file"),TAG(tagbuf,tagEnd)) THEN
      adr:=ADR(filename); adr2:=filereq^.dir;
      adr:=TAG(tagbuf,adr,adr2);
      rt.vEZRequest (ADR("You picked the file:\n'%s'\nin directory:\n'%s'"),
                  ADR("Right"), NIL, NIL,adr);
    ELSE
      rt.vEZRequest (ADR("You didn't pick a file."),ADR("No"),NIL, NIL, NIL);
    END;

    rt.FreeRequest (filereq);
  ELSE
    rt.vEZRequest (ADR("Out of memory!"),ADR("Oh boy!"),NIL, NIL, NIL);
  END;  (* IF filereq # NIL *)

  adr:=TAG(tagbuf,rt.Underscore,"_",tagEnd);
  rt.vEZRequest (ADR("The file requester can be used\n"+
              "as a directory requester as well."),
              ADR("Let's _see that"),NIL,adr,NIL);

  filereq:=rt.AllocRequestA (rt.TypeFileReq, NIL);
  IF filereq # NIL THEN
    IF rt.FileRequestA(filereq, ADR(filename),ADR("Pick a directory"),
               TAG(tagbuf,rt.fiFlags,LONGSET {rt.fReqNoFiles},tagEnd)) THEN
      adr := ADR(filereq^.dir);
      rt.vEZRequest (ADR("You picked the directory:\n'%s'"),
                  ADR("Right"), NIL, NIL, adr);
    ELSE
      rt.vEZRequest (ADR("You didn't pick a directory."),ADR("No"),NIL, NIL, NIL);
    END;
    rt.FreeRequest (filereq);
  ELSE
    rt.vEZRequest (ADR("Out of memory!"),ADR("Oh boy!"),NIL, NIL, NIL);
  END;  (* IF filereq # NIL *)

  fontreq := rt.AllocRequestA (rt.TypeFontReq, NIL);
  IF fontreq # NIL THEN
    fontreq^.flags := LONGSET {rt.fReqStyle, rt.fReqColorFonts};
    IF rt.FontRequest(fontreq,ADR("Pick a font"),TAG(tagbuf,tagEnd)) THEN
      adr := fontreq^.attr.name; adr2 := fontreq^.attr.ySize;
      adr:=TAG(tagbuf,adr, adr2);
      rt.vEZRequest (ADR("You picked the font:\n'%s'\nwith size:\n'%ld'"),
                  ADR("Right"), NIL, NIL, adr);
    ELSE
      adr:=TAG(tagbuf,rt.Underscore,"_",tagEnd);
      rt.vEZRequest (ADR("You canceled.\nWas there no font you liked ?"),
                  ADR("_Nope"),NIL,adr,NIL);
    END;
    rt.FreeRequest (fontreq);
  ELSE
    rt.vEZRequest (ADR("Out of memory!"),ADR("Oh boy!"),NIL, NIL, NIL);
  END;  (* IF fontreq # NIL *)

  adr:=TAG(tagbuf,rt.Underscore,"_",tagEnd);
  rt.vEZRequest (ADR("NUMBER 6:\nPalette requester\nfunction: rt.PaletteRequest()"),
              ADR("_Proceed"),NIL,adr,NIL);
  
  color := rt.PaletteRequest (ADR("Change palette"), NIL,TAG(tagbuf,tagEnd));
  IF color = -1 THEN
    rt.vEZRequest (ADR("You canceled.\nNo nice colors to be picked ?"),
                ADR("Nah"),NIL, NIL, NIL);
  ELSE
    adr:=ADR(color);
    rt.vEZRequest (ADR("You picked color number %ld."),ADR("Sure did"),
                NIL, NIL,adr);
  END;

  adr:=TAG(tagbuf,rt.Underscore,"_",tagEnd);
  rt.vEZRequest (ADR("NUMBER 7: (ReqTools 2.0)\n"+
              "Volume requester\n"+
              "function: rtFileRequest() with\n"+
              "          RTFI_VolumeRequest tag."),
              ADR("_Show me"), NIL,adr,NIL);

  filereq := rt.AllocRequestA (rt.TypeFileReq, NIL);
  IF filereq # NIL THEN

    IF rt.FileRequestA(filereq, NIL, ADR("Pick a volume"),
                       TAG(tagbuf,rt.fiVolumeRequest, 0, tagEnd)) THEN
      adr := ADR(filereq^.dir);
      rt.vEZRequest (ADR("You picked the volume:\n'%s'"),
                  ADR("Right"), NIL, NIL, adr);
    ELSE
      rt.vEZRequest (ADR("You didn't pick a volume."),ADR("I did not"),NIL,NIL,NIL);
    END;

    rt.FreeRequest (filereq);

  ELSE
    rt.vEZRequest (ADR("Out of memory!"),ADR("Oh boy!"), NIL, NIL, NIL);
  END;  (* IF filereq # NIL *)

  adr:=TAG(tagbuf,rt.Underscore,"_",tagEnd);
  rt.vEZRequest (ADR("NUMBER 8: (ReqTools 2.0)\n"+
              "Screen mode requester\n"+
              "function: rtScreenModeRequest()\n"+
              "Only available on Kickstart 2.0!"),
              ADR("_Proceed"), NIL,adr,NIL);

  IF kickVersion < 37 THEN
    adr:=TAG(tagbuf,rt.Underscore,"_",tagEnd);
    rt.vEZRequest (ADR("Your Amiga doesn't seem to have\n"+
                "Kickstart 2.0 in ROM so I am not\n"+
                "able to show you the Screen mode\n"+
                "requester.\n"+
                "So upgrade to 2.0 *now* :-)"),
                ADR("_Allright"), NIL,adr,NIL);
  ELSE
    scrmodereq:=rt.AllocRequestA (rt.TypeScreenModeReq, NIL);
    IF scrmodereq#NIL THEN

      IF rt.ScreenModeRequest (scrmodereq,ADR("Pick a screen mode:"),
                   TAG(tagbuf,rt.scFlags,LONGSET{rt.scReqDepthGad,rt.scReqSizeGads,
                   rt.scReqAutoscrollGad,rt.scReqOverscanGad},tagEnd)) THEN
        IF scrmodereq^.autoScroll#0 THEN adr:=ADR("On");
                                    ELSE adr:=ADR("Off"); END;
        adr2:=TAG(tagbuf,scrmodereq^.displayID,
                  scrmodereq^.displayWidth,
                  scrmodereq^.displayHeight,
                  scrmodereq^.displayDepth,
                  scrmodereq^.overscanType,
                  adr);
        rt.vEZRequest (ADR("You picked this mode:\n"+
                    "ModeID  : 0x%lx\n"+
                    "Size    : %ld x %ld\n"+
                    "Depth   : %ld\n"+
                    "Overscan: %ld\n"+
                    "AutoScroll %s"),
                    ADR("Right"), NIL, NIL,adr2);
      ELSE
        rt.vEZRequest (ADR("You didn't pick a screen mode."),ADR("Nope"),NIL,NIL,NIL);
      END;  (*IF rt.ScreenModeRequest *)

      rt.FreeRequest (scrmodereq);
    ELSE
      rt.vEZRequest (ADR("Out of memory!"),ADR("Oh boy!"),NIL,NIL,NIL);
    END;  (* IF scrmodereq#NIL *)
  END;  (* IF kickVersion < 37 *)
  rt.vEZRequestTags (ADR("That's it!\nHope you enjoyed the demo"),
                  ADR("_Sure did"),NIL,NIL,
                  TAG(tagbuf,rt.Underscore,"_",tagEnd));

END ReqToolsDemo.
