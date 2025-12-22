PROGRAM RTDemo;


{$I "Include:Libraries/ReqTools.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:PCQUtils/CStrings.i"}  { sprintf   }
{$I "Include:PCQUtils/Utils.i"}     { OSVersion  EasyReqArgs}

(*
**  This is a strait translation from demo.c
**  in the reqtools archive.
**
**  Check this demo for tips on how to use
**  reqtools in PCQ Pascal.
**
**  You have to link with reqtools.lib
**
**  nils.sjoholm@mailbox.swipnet.se  (Nils Sjoholm)
**
*)


CONST
    DISKINSERTED=$00008000;


VAR
    filereq         : rtFileRequesterPtr;
    fontreq         : rtFontRequesterPtr;
    inforeq         : rtReqInfoPtr;
    scrnreq         : rtScreenModeRequesterPtr;
    filelist        : rtFileListPtr;
    buffer          : String;
    filename        : String;
    dummy           : String;
    longnum         : INTEGER;;
    ret,i           : INTEGER;
    color           : INTEGER;
    ff              : FileInfoBlock;
    tt              : TextAttrPtr;
    values          : ARRAY [0..1] OF INTEGER;

PROCEDURE CleanUp(TheMsg : STRING; ErrCode : INTEGER);
VAR
    i : INTEGER;
BEGIN
    IF RTBase <> NIL THEN CloseLibrary(RTBase);
    IF TheMsg <> NIL THEN i := EasyReqArgs("ReqToolsDemo",TheMsg,"Ok");
    EXIT(ErrCode);
END;

FUNCTION GetScrollValue(value : INTEGER): STRING;
BEGIN
    IF value = 0 THEN GetScrollValue := "Off"
    ELSE GetScrollValue := "On";
END;

BEGIN
    RTBase:=ReqToolsBasePtr(OpenLibrary(REQTOOLSNAME,REQTOOLSVERSION));
    IF(RTBase=NIL) THEN
            CleanUp("You need reqtools.library V38 OR higher!\nPlease install it in your Libs: directory.",0);

    dummy:=AllocString(400);

    sprintf(dummy,"%s%s%s%s","ReqTools 2.0 Demo\n",
                  "~~~~~~~~~~~~~~~~~\n",
                 "'reqtools.library' offers several\n",
                 "different types of requesters:");
    ret:=rtEZRequestA(dummy,"Let's see them", NIL, NIL, NIL);

    ret:=rtEZRequestA("NUMBER 1:\nThe larch :-)",
                     "Be serious!", NIL, NIL, NIL);

    ret:=rtEZRequestA("NUMBER 1:\nString requester\nfunction: rtGetString()",
                     "Show me", NIL, NIL, NIL);

    buffer:=AllocString (128);      { This should alloc'd to maxchars + 1 }

    StrCpy (buffer, "A bit of text");

    ret := rtGetStringA (buffer, 127, "Enter anything:", NIL, NIL);
    IF (ret=0) THEN
        ret := rtEZRequestA("You entered nothing","I'm sorry", NIL, NIL, NIL)
    ELSE
        ret := rtEZRequest("You entered this string:\n'%s'","So I did", NIL, NIL, buffer);

    sprintf(dummy,"%s%s%s","These are two new features of ReqTools 2.0:\n",
                  "Text above the entry gadget and more than\n",
                  "one response gadget.");
    ret := rtGetString (buffer, 127, "Enter anything:", NIL,
                             RTGS_GadFmt, " _Ok |New _2.0 feature!|_Cancel",
                             RTGS_TextFmt,dummy,
                             RT_Underscore, '_',
                             TAG_DONE);

    IF ret=2 THEN
        ret := rtEZRequestA("Yep, this is a new\nReqTools 2.0 feature!",
                       "Oh boy!",NIL,NIL,NIL);

    sprintf(dummy,"%s%s%s%s%s","New is also the ability to switch off the\n",
                               "backfill pattern.  You can also center the\n",
                               "text above the entry gadget.\n",
                               "These new features are also available in\n",
                               "the rtGetLong() requester.");

    ret := rtGetString(buffer, 127, "Enter anything:",NIL,
                               RTGS_GadFmt," _Ok | _Abort |_Cancel",
                               RTGS_TextFmt,dummy,
                               RTGS_BackFill, FALSE,
                               RTGS_Flags, GSREQF_CENTERTEXT + GSREQF_HIGHLIGHTTEXT,
                               RT_Underscore, '_',
                               TAG_DONE);
    IF ret = 2 THEN
        ret := rtEZRequestA("What!! You pressed abort!?!\nYou must be joking :-)",
                             "Ok, Continue",NIL,NIL,NIL);

    ret := rtEZRequestA ("NUMBER 2:\nNumber requester\nfunction: rtGetLong()",
                     "Show me", NIL, NIL, NIL);

    ret := rtGetLong(longnum, "Enter a number:",NIL,
                        RTGL_ShowDefault, FALSE,
                        RTGL_Min, 0,
                        RTGL_Max, 666,
                        TAG_DONE);

    IF(ret=0) THEN
        ret := rtEZRequestA("You entered nothing","I'm sorry", NIL, NIL, NIL)
    ELSE
        ret := rtEZRequest("The number You entered was: \n%ld" ,
                     "So it was", NIL, NIL, longnum);

    sprintf(dummy,"%s%s%s","NUMBER 3:\nNotification requester, the requester\n",
                  "you've been using all the time!\n",
                  "function: rtEZRequestA()");
    ret := rtEZRequestA (dummy,"Show me more", NIL, NIL, NIL);

    ret := rtEZRequestA ("Simplest usage: some body text and\na single centered gadget.",
                       "Got it", NIL, NIL, NIL);

    sprintf(dummy,"%s%s%s","You can also use two gadgets to\n",
                          "ask the user something\n",
                          "Do you understand?");
    ret := 0;
    WHILE ret = 0 DO BEGIN
        ret := rtEZRequestA (dummy,"Of course|Not really", NIL, NIL, NIL);
        IF ret = 0 THEN i := rtEZRequestA ("You are not one of the brightest are you?\nWe'll try again...",
                           "Ok", NIL, NIL, NIL);
    END;

    ret:=rtEZRequestA ("Great, we'll continue then.", "Fine", NIL, NIL, NIL);

    sprintf(dummy,"%s%s%s","You can also put up a requester with\n",
                           "three choices.\n",
                           "How do you like the demo so far ?");
    ret:=rtEZRequestA (dummy,"Great|So so|Rubbish", NIL, NIL, NIL);
    CASE ret OF
        0:  ret:=rtEZRequestA ("Too bad, I really hoped you\nwould like it better.",
                               "So what", NIL, NIL, NIL);

        1:  ret:=rtEZRequestA ("I'm glad you like it so much.","Fine", NIL, NIL, NIL);

        2:  ret:=rtEZRequestA ("Maybe if you run the demo again\nyou'll REALLY like it.",
                               "Perhaps", NIL, NIL, NIL);
        END;

    sprintf(dummy,"%s%s%s%s%s","The number of responses is not limited to three\n",
                               "as you can see.  The gadgets are labeled with\n",
                               "the 'Return' code from rtEZRequestA().\n",
                               "Pressing 'Return' will choose 4, note that\n",
                               "'4's' button text is printed in boldface.");
    ret := rtEZRequestTags(dummy,"1|2|3|4|5|0", NIL, NIL,
                            RTEZ_DefaultResponse, 4,
                            TAG_DONE);

    ret := rtEZRequest("You picked '%ld'.", "How true", NIL, NIL, ret);

    sprintf(dummy,"%s%s%s%s%s%s%s","New for Release 2.0 of ReqTools (V38) is\n",
                   "the possibility to define characters in the\n",
                   "buttons as keyboard shortcuts.\nAs you can see these characters are underlined.\n",
                   "Pressing shift while still holding down the key\nwill cancel the shortcut.\n",
                   "Note that in other requesters a string gadget may\n",
                   "be active.  To use the keyboard shortcuts there\n",
                   "you have to keep the Right Amiga key pressed down.");

    ret := rtEZRequestTags(dummy,"_Great|_Fantastic|_Swell|Oh _Boy",
                          NIL, NIL, RT_UnderScore,'_',TAG_DONE);

    sprintf(dummy,"%s%s%s%s%s","You may also use C-style formatting codes in the body text.\n",
                  "Like this:\n\n",
                  "'The number %%ld is written %%s.' will give:\n\n",
                  "The number %ld is written %s.\n\n",
                  "if you also pass '5' and '\"five\"' to rtEZRequest().");

    values[0]:=5;
    values[1]:=INTEGER("five");
    ret := rtEZRequestTags(dummy,"_Proceed",NIL,@values[0],RT_Underscore,'_',TAG_DONE);

    sprintf(dummy,"%s%s%s%s","It is also possible to pass extra IDCMP flags\n",
                  "that will satisfy rtEZRequest(). This requester\n",
                  "has had DISKINSERTED passed to it.\n",
                  "(Try inserting a disk).");
    ret := rtEZRequestTags(dummy,"_Continue", NIL,NIL,
                               RT_IDCMPFlags, DISKINSERTED,
                                RT_Underscore, '_', TAG_END);

    IF ((ret = DISKINSERTED)) THEN
        ret := rtEZRequestA("You inserted a disk.", "I did", NIL, NIL, NIL)
    ELSE
        ret:=rtEZRequestA("You Used the 'Continue' gadget\nto satisfy the requester.","I did", NIL, NIL, NIL);

    sprintf(dummy,"%s%s%s%s","Finally, it is possible to specify the position\n",
                  "of the requester.\n",
                  "E.g. at the top left of the screen, like this.\n",
                  "This works for all requesters, not just rtEZRequest()!");
    ret := rtEZRequestTags(dummy,"_Amazing", NIL,NIL,
                          RT_ReqPos, REQPOS_TOPLEFTSCR,
                          RT_Underscore, '_', TAG_END);

    sprintf(dummy,"%s%s%s","Alternatively, you can center the\n",
                  "requester on the screen.\n",
                  "Check out 'reqtools.doc' for all the possibilities.");
    ret := rtEZRequestTags(dummy,"I'll do that", NIL,NIL,
                          RT_ReqPos, REQPOS_CENTERSCR, TAG_END);

    ret := rtEZRequestTags("NUMBER 4:\nFile requester\nfunction: rtFileRequest()",
                          "_Demonstrate", NIL, NIL, RT_Underscore,'_',TAG_END);

    filereq := Address(rtAllocRequestA (RT_FILEREQ, NIL));

    IF (filereq<>NIL) THEN BEGIN
        filename := AllocString (80);
        strcpy (filename, "");
        ret := rtFileRequestA (filereq, filename, "Pick a file", NIL);
        IF(ret<>0) THEN
            ret := rtEZRequest("You picked the file:\n%s\nin directory:\n%s",
                                    "Right", NIL, NIL, filename,filereq^.dir)
        ELSE
            ret := rtEZRequestA("You didn't pick a file.", "No", NIL, NIL, NIL);

        sprintf(dummy,"%s%s%s%s","The file requester has the ability\n",
                      "to allow you to pick more than one\n",
                      "file (use Shift to extend-select).\n",
                      "Note the extra gadgets you get.");
        ret := rtEZRequestTags(dummy,"_Interesting", NIL,NIL, RT_Underscore, '_', TAG_END);

        filelist := rtFileRequest(filereq,filename,"Pick some files",
                               RTFI_Flags, FREQF_MULTISELECT, TAG_END);

        IF filelist <> NIL THEN BEGIN
            sprintf(dummy,"%s%s%s%s%s","You selected some files, this is\n",
                          "the first one:\n",
                          "'%s'\n",
                          "All the files are returned as a linked\n",
                          "list (see demo.c and reqtools.h).");
        ret := rtEZRequest(dummy,"Aha", NIL,NIL, filelist^.Name);
            (* Traverse all selected files *)
            (*
            tempflist = flist;
            while (tempflist) {
                DoSomething (tempflist->Name, tempflist->StrLen);
                tempflist = tempflist->Next;
                }
            *)
            (* Free filelist when no longer needed! *)
            rtFreeFileList(filelist);
        END;
        rtFreeRequest(filereq);
    END
    ELSE
        ret := rtEZRequestA("Out of memory!", "Oh boy!", NIL, NIL, NIL);

    ret := rtEZRequestTags("The file requester an be used\nas a directory requester as well.",
                        "Let's _see that", NIL, NIL, RT_Underscore,'_',TAG_END);

    filereq := rtAllocRequestA(RT_FILEREQ, NIL);
    IF (filereq<>NIL) THEN BEGIN
         ret := rtFileRequest(filereq, filename, "Pick a directory",
                              RTFI_Flags, FREQF_NOFILES, TAG_END);
         IF(ret=1) THEN
             ret := rtEZRequest("You picked the directory:\n%s",
                          "Right", NIL, NIL, filereq^.Dir)
         ELSE
             ret := rtEZRequestA("You didn't pick a directory.", "No", NIL, NIL, NIL);

         rtFreeRequest(filereq);
    END
    ELSE
         ret := rtEZRequestA("Out of memory","No",NIL,NIL,NIL);

    ret := rtEZRequestA("NUMBER 5:\nFont requester\nfunction: rtFontRequest()",
                          "Show", NIL, NIL, NIL);

    fontreq := rtAllocRequestA(RT_FONTREQ, NIL);
    IF (fontreq<>NIL) THEN BEGIN
         fontreq^.Flags := FREQF_STYLE OR FREQF_COLORFONTS;
         ret := rtFontRequestA (fontreq, "Pick a font", NIL);
         IF(ret<>0) THEN
             ret := rtEZRequest("You picked the font:\n%s\nwith size:\n%ld",
                                   "Right", NIL, NIL, fontreq^.Attr.ta_Name, fontreq^.Attr.ta_YSize)
         ELSE
             ret := rtEZRequestA("You didn't pick a font","I know", NIL, NIL, NIL);

         rtFreeRequest(fontreq);
    END
    ELSE
         ret := rtEZRequestA("Out of memory!", "Oh boy!", NIL, NIL, NIL);

    ret := rtEZRequestTags("NUMBER 6:\nPalette requester\nfunction: rtPaletteRequest()",
                           "_Proceed", NIL,NIL, RT_Underscore, '_', TAG_END);
    color := rtPaletteRequest("Change palette",NIL,TAG_END);
    IF (color = -1) THEN
        ret := rtEZRequestA("You canceled.\nNo nice colors to be picked ?",
                         "Nah", NIL, NIL, NIL)
    ELSE
        ret := rtEZRequest("You picked color number %ld.", "Sure did",
                         NIL, NIL, color);

    sprintf(dummy,"%s%s%s%s","NUMBER 7: (ReqTools 2.0)\n",
                          "Volume requester\n",
                          "function: rtFileRequest() with\n",
                          "          RTFI_VolumeRequest tag.");
    ret := rtEZRequestTags(dummy,"_Show me", NIL, NIL, RT_Underscore, '_', TAG_END);

    filereq := rtAllocRequestA(RT_FILEREQ,NIL);
    IF (filereq <> NIL) THEN BEGIN
        ret := rtFileRequest(filereq,NIL,"Pick a volume!",
                             RTFI_VolumeRequest,0,TAG_END);
        IF (ret = 1) THEN
            ret := rtEZRequest("You picked the volume:\n'%s'",
                               "Right",NIL,NIL,filereq^.Dir)
        ELSE
            ret := rtEZRequestA("you didn't pick a volume.","I did not",NIL,NIL,NIL);
        rtFreeRequest(filereq);
    END
    ELSE
        ret := rtEZRequestA("Out of memory","Oh boy!",NIL,NIL,NIL);

    sprintf(dummy,"%s%s%s%s","NUMBER 8: (ReqTools 2.0)\n",
                  "Screen mode requester\n",
                  "function: rtScreenModeRequest()\n",
                  "Only available on Kickstart 2.0!");

    ret := rtEZRequestTags(dummy,"_Proceed", NIL, NIL, RT_Underscore, '_', TAG_END);

    IF OSVersion < 37 THEN BEGIN
        sprintf(dummy,"Your Amiga doesn't seem to have\n",
                      "Kickstart 2.0 in ROM so I am not\n",
                      "able to show you the Screen mode\n",
                      "requester.\n",
                      "So upgrade to 2.0 *now* :-)");
        ret := rtEZRequestTags(dummy,"_Allright", NIL, NIL, RT_Underscore, '_', TAG_END);
    END ELSE BEGIN
        scrnreq := rtAllocRequestA (RT_SCREENMODEREQ, NIL);
        IF (scrnreq<>NIL) THEN BEGIN
            ret := rtScreenModeRequest( scrnreq, "Pick a screen mode:",
                                    RTSC_Flags, SCREQF_DEPTHGAD OR SCREQF_SIZEGADS OR
                                    SCREQF_AUTOSCROLLGAD OR SCREQF_OVERSCANGAD,
                                    TAG_END);

            IF(ret=1) THEN BEGIN
                sprintf(dummy,"%s%s%s%s%s%s","You picked this mode:\n",
                                             "ModeID  : 0x%lx\n",
                                             "Size    : %ld x %ld\n",
                                             "Depth   : %ld\n",
                                             "Overscan: %ld\n",
                                             "AutoScroll %s");
                ret := rtEZRequest(dummy,"Right", NIL, NIL,
                                     scrnreq^.DisplayID,
                                     scrnreq^.DisplayWidth,
                                     scrnreq^.DisplayHeight,
                                     scrnreq^.DisplayDepth,
                                     scrnreq^.OverscanType,
                                     GetScrollValue(scrnreq^.AutoScroll));
            END
            ELSE
                ret := rtEZRequestA("You didn't pick a screen mode.", "Sorry", NIL, NIL, NIL);
            rtFreeRequest (scrnreq);
        END
        ELSE
        ret := rtEZRequestA("Out of memory!", "Oh boy!", NIL, NIL, NIL);

    END;
    ret := rtEZRequestTags("That's it!\nHope you enjoyed the demo", "_Sure did", NIL, NIL,
                            RT_Underscore, '_', TAG_END);

    CleanUp(NIL,0);
END.
