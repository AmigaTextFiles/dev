{ Program:   Reqtools-Demo
  ~~~~~~~~
  Version:   V0.06 / 08.08.94
  ~~~~~~~~
  Meaning:   Demo for the Reqtools-Interface for
  ~~~~~~~~   KickPascal2.12/OS2
             or MaxonPASCAL3 (compile it)

             for Reqtools.library V38 (last 2.2a / V38.1194)

  Copyright: © by the cooperation of
  ~~~~~~~~~~
               PackMAN (Falk Zühlsdorff)

                and

               Janosh (Jan Stötzer)

               for all KP/MP3 Interface / Demos / Includes / Units

             This version is FREEWARE (see © Reqtools.library)

             © Nico François for the reqtools.library


  Author:    this Demo and the Unit are written by PackMAN
  ~~~~~~~
  Address:   PackMAN
  ~~~~~~~~   c/o Falk Zühlsdorff
             Lindenberg 66
             98693 Ilmenau/Thuringia

             Germany

  Comment:   only OS2 or higher now
  ~~~~~~~~                                                           }

PROGRAM RTdemo;

{--------------------------------------------------------------------}

USES REQTOOLS;

CONST   up:=chr(10);
TYPE    mystringtype    = string[400];
        mystringtype2   = string[135];
VAR     FileReq         : p_rtFileRequester;
        FontReq         : p_rtFontRequester;
        InfoReq         : p_rtReqInfo;
        ScrnReq         : p_rtScreenModeRequester;
        Buf             : str;
        FName           : str;
        Num             : long;STATIC;
        Col             : long;STATIC;
        Args            : array[0..5] of long;STATIC;
        HStr            : str;
        HStr2           : string[1000];STATIC;
        ret             : long;STATIC;
        ok              : boolean;STATIC;
        Tags            : array[0..6] of TagItem;STATIC;

        datname,
        Dirname,
        FileName        : string[108];STATIC;
        FTags           : array[0..3] of TagItem;STATIC;
        flist,tempflist : ^rtfilelist;

{--------------------------------------------------------------------}
FUNCTION RTEZ(Text,gadtx:string):long;
VAR tags : array[1..2] of tagitem;STATIC;
BEGIN
 Tags[1]:=TagItem(RT_ReqPos,ReqPos_Pointer);
 Tags[2].ti_tag:=Tag_END;
 RTEZ:=rtEZRequestA(^Text,^gadtx,NIL,NIL,^Tags[1]);
END;
{--------------------------------------------------------------------}
FUNCTION RTEZ1(Text:mystringtype,gadtx:string):long;
VAR tags : array[1..2] of tagitem;STATIC;
BEGIN
 Tags[1]:=TagItem(RT_ReqPos,ReqPos_Pointer);
 Tags[2].ti_tag:=Tag_END;
 RTEZ1:=rtEZRequestA(^Text,^gadtx,NIL,NIL,^Tags[1]);
END;
{--------------------------------------------------------------------}
FUNCTION RTEZ2(Titel:string,text:mystringtype2,gadtx:string,
               pos:byte,x,y:long):long;

VAR tags : array[0..7] of tagitem;STATIC;
BEGIN
   Tags[0]:=TagItem(RTEZ_Reqtitle,Long(^titel));
   Tags[1]:=TagItem(RTGS_GadFmt,long(^gadtx));
   Tags[2]:=TagItem(RT_UnderScore,long('_'));
   Tags[3]:=TagItem(RTGS_Flags,GSREQF_CENTERTEXT
                     or GSREQF_HIGHLIGHTTEXT);
   Tags[4]:=TagItem(RT_ReqPos,pos);{if using left-/topoffset not 0..4}
   Tags[5]:=TagItem(RT_LeftOffset,x);
   Tags[6]:=TagItem(RT_TopOffset,y);
   Tags[7].ti_tag:=Tag_END;
   RTEZ2:=rtEZRequestA(^Text,^gadtx,NIL,NIL,^Tags[0]);
END;
{--------------------------------------------------------------------}

PROCEDURE RTF;
BEGIN
  FileReq:=ptr(rtAllocRequestA(RT_FileReq, Nil));
  IF FileReq<>Nil
  THEN
   BEGIN
    ret:=rtChangeReqAttr(filereq,^Ftags[0]);
    ret:=rtFileRequestA(FileReq,FileName,"Pick a file",NIL);
    IF ret<>0
     THEN
      BEGIN
       DirName:=FileReq^.Dir;
       IF (DirName<>'') AND (DirName[length(DirName)]<>':')
           AND  ((DirName[length(DirName)]<>'/'))
             THEN datname:=DirName+'/'+Filename
             ELSE datname:=DirName+Filename;
       ret:=rtEZ("You entered:"+datname,"Yes")
      END
     ELSE ret:=rtEZ("You entered nothing","I'm sorry");
    rtFreeRequest(FileReq);
   END;
END;
{--------------------------------------------------------------------}

BEGIN

 { since Reqtools.unit V0.06 you must check for yourself if:
   OS2 and you must open the reqtools.library first, but
   there are three simple (and better) functions on it...

   Why: 1) If a Program should use the Reqtools NOT from
           beginning, like my ZMore.
        2) I want not use the "Halt"-Command of KP/MP3
           and for that reason please use the following two
           routines...

   PackMAN 08.08.94   (see also readme for news)                     }

 IF NOT V37
 THEN
  BEGIN
   ErrorReq('Need OS2 or higher','OK',NIL);
   exit;
  END;

 IF NOT OpenReqtools
  THEN
   BEGIN
    CloseLib(IntuitionBase);
    exit;
   END;

 ret:=rtEZ1("Reqtools Demo for Kick-/ MAXONPascal:"+up+
            "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"+up+
            "Version: V0.06 / 08.08.94"+up+up+
            "Written by PackMAN"+up+up+
            "with the Reqtools.library V2.2 (38.1194)"+up+up+
            "'reqtools.library' © by Nico Francois"+up+up+
            "© by the cooperation of"+up+up+
            "  PackMAN (Falk Zühlsdorff)  &"+up+up+
            "  Janosh (Jan Stötzer) Thuringia / GERMANY"+up+up+
            "* Thanx Commodore for the AMIGA-Power *","Yeah !");

 ret:=rtEZ("Reqtools.Library offers"+up+"different types of requesters",
                    "Let's see them");

 ret:=rtEZ('NUMBER 1:'+up+'The larch :-)','Be serious!');

 ret:=rtEZ("Ok, let's be serious..."+up+"NUMBER 1:"+up+
           "String requester function: rtGetString()","Show me");

 Buf:='A little bit of text';
 ret:=rtGetStringA(Buf,127,'Enter anything:',Nil,Nil);
 Args[0]:=long(Buf);
 IF ret=0 THEN
    ret:=rtEZ("You entered nothing","I'm sorry")
  ELSE
    ret:=rtEZRequestA('You entered this string: '\10'%s','So I did',Nil,
                      ^Args[0],Nil);

  Buf:="Cool, heh ?";
  HStr:="It is possible to have several responses";
  Tags[0]:=TagItem(RTGS_TextFmt,long(HStr));
  HStr:=' OK | New 2.0 feature | Fuck it !! ';
  Tags[1]:=TagItem(RTGS_GadFmt,long(HStr));
  Tags[2].ti_tag:=TAG_END;

  ret:=rtGetStringA(Buf,127,"* New for ReqTools 2.0 *",Nil,^Tags[0]);

  case ret of
    2 : ret:=rtEZ("Yeah! This is a new Reqtools 2.0 feature.",
                          "OK");
    0 : ret:=rtEZ("Hey! Why don't you like it ???","Ooops");
    otherwise
  END;

  ret:=rtEZ('NUMBER 2:'+up+'Number requester'+up+
             'function: rtGetLong()','Show me');

  Tags[1]:=TagItem(RTGL_ShowDefault,long(false));

  ret:=rtGetLongA (^Num, "Enter a number:", Nil,^Tags[1]);
  Args[0]:= Num;

  IF ret=0 THEN
    ret:=rtEZ("You entered nothing","I'm sorry")
  ELSE
    ret:=rtEZRequestA('The number You entered was: '\10'%ld' ,
                      'So it was', Nil, ^Args[0], Nil);

  Tags[0]:=TagItem(RTGL_ShowDefault,long(false));
  HStr:="Some text above a Number Gadget";
  Tags[1]:=TagItem(RTGL_TextFmt,long(HStr));
  HStr:='Ok|V38 feature|Cancel';
  Tags[2]:=TagItem(RTGL_GadFmt,long(HStr));
  Tags[3]:=TagItem(TAG_END,0);

  ret:=rtGetLongA (^Num, "* New for ReqTools 2.0 *", Nil,^Tags[0]);

  case ret of
    0 : ret:=rtEZ("Don't you like it or why do you refuse"+up+
                  "to enter a number ??","Argh");
    2 : ret:=rtEZ("Reqtools V38 makes it possible !","So is it");
    otherwise
  END;

  HStr2:="New is also the ability to switch off"+up+
          "the backfill pattern.You can also center"+up+
          "the text above the entry gadget. It's also"+up+
          "possible to allow empty strings to be returned."+up+
          "These new features are also available in"+up+
          "the rtGetLong requester";
  Tags[0]:=TagItem(RTGS_TextFmt,long(^HStr2));
  HStr:="_Great|_Abort";
  Tags[1]:=TagItem(RTGS_GadFmt,long(HStr));
  Tags[2]:=TagItem(RT_UnderScore,long('_'));;
  Tags[3]:=TagItem(RTGS_BackFill,long(false));
  Tags[4]:=TagItem(RTGS_Flags,GSREQF_CENTERTEXT or GSREQF_HIGHLIGHTTEXT);
  Tags[5]:=TagItem(RTGS_AllowEmpty,long(true));
  Tags[6].ti_tag:=TAG_END;

  Buf:="";
  ret:=rtGetStringA(Buf,127,"Enter anything",Nil,^Tags[0]);

  IF ret=0 THEN
    ret:=rtEZ2("What's up?","You selected 'Abort'."+up+
               "Sick in brain, eh??","Excuse me",0,0,0);

  ret:=rtEZ1('NUMBER 3:'+up+'Notification requester, the requester'+up+
             'you have been using all the time!'+up+
             'function: rtEZRequestA()',"Show me more");

  ret:=rtEZ('Simplest usage: some body text and'+up+
            'a single centered gadget.',"Got it");

  ret:=rtEZ('You can also use two gadgets to'+up+'ask the user something.'+
             up+'Do you understand?',"Of course|Not really");

  while ret=0 do BEGIN
    ret:=rtEZ('You are not one of the brightest, are you?'+up+
              'We will try again...',"Ok");
    ret:=rtEZ('You can also use two gadgets to'+up+'ask the user something.'+
             up+'Do you understand?',"Of course|Not really");
  END;

  ret:=rtEZ ("Great, we'll continue THEN.", "Fine");

  ret:=rtEZ ('You can also put up a requester with'+up+'three choices.'+
             up+'How do you like the demo so far ?',"Great|So so|Rubbish");

  case ret of
    0: ret:=rtEZ('Too bad !!!, I really hoped you'+up+
                  'would like it better.',"So what");
    1: ret:=rtEZ('I am glad you like it so much.','Fine');
    2: ret:=rtEZ('Maybe IF you run the demo again'+up+
                  'you will REALLY like it.',"Perhaps");
  END;

  HStr2:="The number of responses is not limited to three"+up+
          "as you can see. The gadget are labeled with the"+up+
          "Returncodes from rtEZRequestA()."+up+up+
          "The »3« is printed in bold face, that means that"+up+
          "it is default response which will be choosen by"+up+
          "pressing the »Return« key.";

  Tags[0]:=TagItem(RTEZ_DefaultResponse,3);
  Tags[1]:=TagItem(TAG_END,0);

  ret :=rtEZRequestA (^HStr2," 1 | 2 | 3 | 4 | 5 | 0 ", Nil, Nil,^Tags[0]);

  Args[0]:=long(ret);
  ret:=rtEZRequestA('You picked %ld',"How true",Nil,^Args[0],Nil);

  Tags[0]:=TagItem(RT_Underscore,long('_'));;
  Tags[1]:=TagItem(TAG_END,0);

  ret:=rtEZRequestA('New for Rel. 2.0 of ReqTools(V38) is'\10'the possibility to define characters in the'\10'buttons as keyboard shortcuts.'\10'As you can see these characters are underlined.',
                    "_Great|_Fantastic|_Swell|Oh _Boy",Nil, Nil,^Tags[0]);

  ret:=rtEZRequestA('Note that pressing shift while still holding'\10'down the key will cancel the shortcut.',
                    "_Great|_Fantastic|_Swell|Oh _Boy",Nil, Nil,^Tags[0]);

  Tags[1]:=TagItem(TAG_END,0);
  Args[0]:=5;
  HStr:="five";
  Args[1]:=long(HStr);

  ret:=rtEZRequestA ("You may also use C-style formatting codes in the body text."\10"Like this:"\10\10"The number %%ld is written %%s. will give:"\10\10"The number %ld is written %s."\10\10"IF you also pass '5' and 'five' to rtEZRequestA().",
                     "_Proceed", Nil, ^Args[0],^Tags[0]);

  Tags[0]:=TagItem(RT_IDCMPFlags,DISKINSERTED);
  Tags[1]:=TagItem(RT_Underscore,long('_'));
  Tags[2]:=TagItem(TAG_END,0);

  ret:=rtEZRequestA ("It is also possible to pass extra IDCMP flags"\10"that will satisfy rtEZRequestA(). This requester"\10"has had DISKINSERTED passed to it."\10"(Try inserting a disk).",
                     "_Continue", Nil, Nil,^Tags[0]);

  IF ret=DISKINSERTED THEN
    ret:=rtEZ("You inserted a disk.","I did")
  ELSE
    ret:=rtEZ("You used the 'Continue' gadget"+up+
               "to satisfy the requester.","I did");

  Tags[0]:=TagItem(RT_ReqPos,REQPOS_TOPLEFTSCR);
  Tags[1]:=TagItem(RT_Underscore,long('_'));
  Tags[2]:=TagItem(TAG_END,0);

  ret:=rtEZRequestA("Finally, it is possible to specify the position"\10"of the requester."\10"E.g. at the top left of the screen, like this."\10"This works for all requesters, not just rtEZRequestA()!",
                    "_Amazing",Nil,Nil,^Tags[0]);

  Tags[0]:=TagItem(RT_ReqPos,REQPOS_CENTERSCR);
  Tags[2]:=TagItem(TAG_END,0);

  ret:=rtEZ2("RTDemo V0.06 by PackMAN",
            "You can also change the windowtitel,"+up+up+
            "(Default: Information)"+up+up+
            "center the text and use the requester"+up+up+
            "on your own position: x=25 / y=20","Fantastic",5,25,20);

  ret:=rtEZRequestA("Alternatively, you can center the"\10"requester on the screen."\10"Check out 'reqtools.doc' for all the possibilities.",
                    "_Yo, I'll do that",Nil,Nil,^Tags[0]);

  Tags[0]:=TagItem(RT_Underscore,long('_'));
  Tags[1]:=TagItem(TAG_END,0);

  ret:=rtEZRequestA("NUMBER 4:"\10"File requester"\10"function: rtFileRequest()",
                    "_Demonstrate",Nil,Nil,^Tags[0]);

{------------------------------------------------------------------------}
{                       *** File Requester ***                           }
{------------------------------------------------------------------------}
Filename:='';
datname:='';
Dirname:='';
FTags[0]:=TagItem(RTFI_Dir,long(^Dirname));
FTags[1].ti_tag:=Tag_Done;
RTF;
ret:=rtEZ("If you selected a file you will"+up+
          "see the buffering of the entry...","Please");
RTF;

ret:=rtEZRequestA("You can also change the height"\10"of the file requester",
                    "Wow",Nil,Nil,Nil);

FileReq:=ptr(rtAllocRequestA(RT_FILEREQ,Nil));

Tags[0]:=TagItem(RTFI_Height,250);
Tags[1]:=TagItem(TAG_END,0);

IF FileReq<>Nil THEN
 BEGIN
  FName:="";
  ret:=0;
  ret:=rtFileRequestA(FileReq,FName,"Pick a file",^Tags[0]);
  IF ret<>0 THEN
   BEGIN
    Args[0]:=long(FName);
    Args[1]:=long(FileReq^.Dir);
    ret:=rtEZRequestA ("You picked the file:"\10"%s"\10"in directory:"\10"%s",
                       "Right",Nil,^Args[0],Nil);
   END
  ELSE
   ret:=rtEZ ("You didn't pick a file.","No");
  rtFreeRequest(FileReq);
 END
  ELSE
   ret:=rtEZ("Out of memory!","Oh boy!");

  ret:=rtEZRequestA("The file requester can be used"\10"as a directory requester as well."\10"You can even change the text"\10"in the 'OK'-Gadget",
                    "Let's see that",Nil,Nil,^Tags[0]);

  FileReq:=ptr(rtAllocRequestA(RT_FileReq,Nil));

  Tags[0]:=TagItem(RTFI_Flags,FREQF_NOFILES);
  HStr:="_Remove";
  Tags[1]:=TagItem(RTFI_OkText,long(HStr));
  Tags[2]:=TagItem(RT_UnderScore,long('_'));
  Tags[3]:=TagItem(TAG_END,0);

  IF FileReq<>Nil THEN BEGIN
    ret:=0;
    ret:=rtFileRequestA(FileReq,FName,"Remove a directory",^Tags[0]);
    Args[0]:=long(FileReq^.Dir);
    IF ret=1 THEN
       ret:=rtEZRequestA ("You picked the directory: %s",
                         "Right",Nil,^Args[0],Nil)
    ELSE
      ret:=rtEZ ("You didn't pick a directory.","No");
    rtFreeRequest(FileReq);
  END ELSE
    ret:=rtEZ ("Out of memory!","Oh boy!");


  

{------------------------------------------------------------------------}
{                       *** Font Requester ***                           }
{------------------------------------------------------------------------}

  ret:=rtEZ("NUMBER 5:"+up+"Font requester"+up+
             "function: rtFontRequest()","Show me !");

  FontReq:=ptr(rtAllocRequestA(RT_FONTREQ,Nil));

  IF FontReq<>Nil THEN BEGIN
    FontReq^.Flags:=FREQF_STYLE or FREQF_COLORFONTS;
    ok:=rtFontRequestA(FontReq,"Selcet a font",Nil);
    IF ok THEN BEGIN
      Args[0]:=long(FontReq^.Attr.ta_Name);
      Args[1]:=long(FontReq^.Attr.ta_YSize);
      ret:=rtEZRequestA("You picked the font:"\10"%s"\10"with size:"\10"%ld Pixels",
                        "That's true",Nil,^Args[0],Nil);
    END ELSE
      ret:=rtEZ("Wasn't there a font you liked ?","Nope");
    rtFreeRequest(FontReq);
  END ELSE
    ret:=rtEZ("Out of memory!","Oh boy!");


{------------------------------------------------------------------------}
{                      *** Palette Requester ***                         }
{------------------------------------------------------------------------}

  Tags[0]:=TagItem(RT_Underscore,long('_'));
  Tags[1]:=TagItem(TAG_END,0);

  ret:=rtEZRequestA ("NUMBER 6:"\10"Palette requester"\10"function: rtPaletteRequest()",
                     "_Proceed",Nil,Nil,^Tags[0]);

  Col:=rtPaletteRequestA("Change palette",Nil,Nil);
  IF Col=-1 THEN
    ret:=rtEZRequestA ("You canceled."\10"No nice colors to be picked ?",
                       "_Nah",Nil,Nil,^Tags[0])
  ELSE
    ret:=rtEZRequestA ("You picked color number %ld.","_Sure did",
                       Nil,^Col,^Tags[0]);

{------------------------------------------------------------------------}
{                          *** Volume-Requester                          }
{------------------------------------------------------------------------}

  ret:=rtEZ("NUMBER 7: The Volume / Disk-Requester","Perfect");

  FileReq:=ptr(rtAllocRequestA(RT_FILEREQ,Nil));

  Tags[0]:=TagItem(RTFI_VolumeRequest,VREQF_ALLDISKS or VREQF_NOASSIGNS);
  HStr:="Un_mount";
  Tags[1]:=TagItem(RTFI_OkText,long(HStr));
  Tags[2]:=TagItem(RT_UnderScore,long('_'));
  Tags[3]:=TagItem(TAG_END,0);

  IF FileReq<>Nil THEN BEGIN
    ret:=0;
    ret:=rtFileRequestA(FileReq, FName, "Unmount a device",^Tags[0]);
    Args[0]:=long(FileReq^.Dir);
    IF ret=1 THEN
      ret:=rtEZRequestA("You picked the device: %s","Right",Nil,^Args[0],Nil)
    ELSE
      ret:=rtEZ("You didn't pick a device.","Ooops");
    rtFreeRequest (FileReq);
  END ELSE
    ret:=rtEZ("Out of memory!","Oh boy!");


{------------------------------------------------------------------------}
{                          *** MultiSelectFileReq ***                    }

{                      New since V0.04 © by PackMAN  02.06.94               }
{------------------------------------------------------------------------}
ret:=rtEZ1("NUMBER 8: The MultiSelectFileRequester"+up+up+
           "          The file requester has the ability"+up+
           "          to allow you to pick more than one"+up+
           "          file (use SHIFT to extended-select)."+up+
           "          Note the extra gadgets you get." ,"Interesting");
Fname:='';
datname:='';
Dirname:='';
FTags[0]:=TagItem(RTFI_Dir,long(^Dirname));
FTags[1].ti_tag:=Tag_Done;
FTags[2]:=TagItem(RTFI_Flags,FREQF_MULTISELECT);
FTags[3].ti_tag:=Tag_Done;

FileReq:=ptr(rtAllocRequestA(RT_FileReq, Nil));
IF FileReq<>Nil
 THEN
  BEGIN
   ret:=rtChangeReqAttr(filereq,^Ftags[0]);
{*}flist:=ptr(rtFileRequestA(FileReq,FName,"Pick some files",^Ftags[2]));
   IF flist<>NIL
    THEN
     BEGIN
      tempflist:=flist;
      ret:=rtEZ1("You selected some files, this is"+up+
                  "the first one: "+tempflist^.name+up+
                  "All the files are returned as a linked"+up+
                  "list (see RTDemo.p or demo.c)","Aha");
      END
     ELSE ret:=rtEZ("You didn`t pick some files","I don`t no why !");

  {tempflist:=flist;

    WHILE tempflist<>NIL DO   {a routine to understand, not used here}
     BEGIN
      writeln(tempflist^.name);
      tempflist:=tempflist^.next;
     END;
   }
    rtFreeFileList(Flist);
    rtFreeRequest(FileReq);
   END
  ELSE ret:=rtEZ("Out of memory!","Oh boy!");

{------------------------------------------------------------------------}
{                     *** Screenmode Requester ***                       }
{------------------------------------------------------------------------}

  ret:=rtEZ("NUMBER 9:"+up+"ScreenMode requester"+up+
            "function: rtScreenModeRequestA()","Proceed");

  ScrnReq:=ptr(rtAllocRequestA(RT_SCREENMODEREQ,Nil));
  IF ScrnReq<>Nil THEN
   BEGIN
    Tags[0]:=TagItem(RTSC_Flags,SCREQF_DEPTHGAD or SCREQF_SIZEGADS or
                          SCREQF_AUTOSCROLLGAD or SCREQF_OVERSCANGAD);
    Tags[1]:=TagItem(RT_UnderScore,long('_'));
    Tags[2]:=TagItem(TAG_END,0);

    ok:=rtScreenModeRequestA(ScrnReq,"Pick a screenmode",^Tags[0]);

    Args[0]:=long(ScrnReq^.DisplayID);
    Args[1]:=long(ScrnReq^.DisplayWidth);
    Args[2]:=long(ScrnReq^.DisplayHeight);
    Args[3]:=long(ScrnReq^.DisplayDepth);
    Args[4]:=long(ScrnReq^.OverscanType);
    IF (Boolean(ScrnReq^.AutoScroll)) THEN BEGIN
      HStr:="On";
      Args[5]:=long(HStr)
    END ELSE BEGIN
      HStr:="Off";
      Args[5]:=long(HStr);
    END;
    IF ok THEN
      ret:=rtEZRequestA("You picked this mode:"\10"ModeID    : 0x%lx"\10"Size      : %ld x %ld"\10"Depth     : %ld"\10"Overscan  : %ld"\10"AutoScroll: %s",
                        "Right",Nil,^Args[0],Nil)
    ELSE
      ret:=rtEZ("You didn't pick a screen mode.","Sorry");
    rtFreeRequest(ScrnReq);
  END ELSE
    ret:=rtEZ("Out of memory!","Oh boy!");



  ret:=rtEZ("Finishing the Demo V0.06... Hope you enjoyed it.",
                    "Really Great !");

  IF RTBase<>NIL        THEN CloseLibrary(RTBase);
  IF IntuitionBase<>NIL THEN CloseLib    (IntuitionBase);
END.











