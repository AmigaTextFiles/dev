
/*

              MaxonPASCAL3 nach Amiga-E  von Bluebird


*/



MODULE   'reqtools','libraries/reqtools','graphics/text'


CONST    DISKINSERTED=$00008000,
         TAG_DONE=0;

DEF      filereq:          PTR TO rtfilerequester,
         fontreq:          PTR TO rtfontrequester,
         inforeq:          PTR TO rtreqinfo,
         scrnreq:          PTR TO rtscreenmoderequester,
         buffer[70]:       STRING,
         filename[110]:    STRING,
         longnum,color,ret,
         txtatt:           PTR TO textattr;
         

PROC main()

  IF reqtoolsbase:=OpenLibrary('reqtools.library',38)

   WriteF('reqtools Demo\n');
   WriteF('~~~~~~~~~~~~~\n');
   WriteF('This program demonstrates what ''reqtools.library'' \n');
   WriteF('has to offer.\n');
   Delay(75);
   IF CtrlC() THEN CleanUp(0);

   RtEZRequestA('''reqtools.library'' offers several\ndifferent types of requesters:',
                'Let''s see them', NIL, NIL, NIL);

   RtEZRequestA('NUMBER 1:\nThe larch','Be serious!', NIL, NIL, NIL);

   RtEZRequestA('NUMBER 1:\nString requester\nfunction: RtGetString'+'('+')',
                'Show me', NIL, NIL, NIL);


   StrCopy(buffer,'Type in anything');
   ret:=RtGetStringA(buffer, 127, 'Enter anything:', NIL,NIL);
   IF ret=0
    RtEZRequestA('You entered nothing','I''m sorry', NIL, NIL, NIL)
   ELSE
    RtEZRequestA('You entered this string:\n%s', 'So I did', NIL, [buffer], NIL)
   ENDIF

   StrCopy(buffer,'It is possible to have several responses');
   RtGetStringA(buffer, 127, '* New for ReqTools 2.0 *', NIL ,
               [RTGS_GADFMT,' OK | New 2.0 feature | Cancel ',
            RTGS_TEXTFMT,
'These are two new features of ReqTools 2.0:\nText above the entry gadget and more than\none response gadget.',
                TAG_DONE]);


   RtGetStringA(buffer, 127, 'Enter anything:', NIL,
           [RTGS_GADFMT,' _Ok |_Abort|_Cancel',
           RTGS_TEXTFMT,
'New is also the ability to switch off the\nbackfill pattern.  You can also center the\ntext above the entry gadget.\nThese new features are also available in\nthe rtGetLong() requester.',
           RTGS_BACKFILL, FALSE,
           RTGS_FLAGS, GSREQF_CENTERTEXT OR GSREQF_HIGHLIGHTTEXT,
           RT_UNDERSCORE,00000095,
           TAG_DONE]);

   RtEZRequestA('NUMBER 2:\nNumber requester\nfunction: rtGetLong' + '(' + ')',
                'Show me', NIL, NIL, NIL);
   
   ret:=RtGetLongA({longnum}, 'Enter a number:' , NIL,
                   [RTGL_SHOWDEFAULT,FALSE,
                    TAG_DONE]);
   IF (ret=0)
      RtEZRequestA('You entered nothing','I''m sorry', NIL, NIL, NIL)
   ELSE
      RtEZRequestA('The number You entered was: \n%ld','So it was', NIL, [longnum], NIL);
   ENDIF
   RtGetLongA({longnum}, '* New for ReqTools 2.0 *', NIL,
             [RTGL_SHOWDEFAULT,FALSE,
              RTGL_GADFMT,'Ok|V38 feature|Cancel',
              TAG_DONE]);
   
   RtGetLongA({longnum}, 'Enter a number:', NIL,
          [RTGL_SHOWDEFAULT, FALSE,
           RTGL_TEXTFMT,'\nbackfill pattern switched off\n',
           RTGL_FLAGS, GSREQF_CENTERTEXT OR GSREQF_HIGHLIGHTTEXT,
           RTGL_MIN, 0,
           RTGL_MAX, 666,
           TAG_DONE]);

   RtEZRequestA('NUMBER 3:\nNotification requester, the requester\n you''ve been'+
                'using all the time!\nfunction: RtEZRequest'+'('+')',
                'Show me more', NIL, NIL, NIL);

   RtEZRequestA('Simplest usage: some body text and\na single centered gadget.',
                'Got it', NIL, NIL, NIL);

   ret:=RtEZRequestA('You can also use two gadgets to\nask the user something.\n'+
                     'Do you understand?', 'Of course|Not really',NIL, NIL, NIL);


   WHILE ret=0

      ret:=RtEZRequestA('You are not one of the brightest are you?\n'+
                        'We''ll try again...','Ok', NIL, NIL, NIL);

      ret:=RtEZRequestA('You can also use two gadgets to\nask the user something.\n'+
                        'Do you understand?', 'Of course|Not really',NIL, NIL, NIL);
   ENDWHILE


   RtEZRequestA('Great, we''ll continue then.', 'Fine', NIL, NIL, NIL);

   ret:=RtEZRequestA('You can also put up a requester with\nthree choices.\n'+
                     'How do you like the demo so far ?',
                     'Great|So so|Rubbish', NIL, NIL, NIL);

   SELECT ret

      CASE 0;  RtEZRequestA('Too bad, I really hoped you\nwould like it better.',
                            'So what', NIL, NIL, NIL);

      CASE 1;  RtEZRequestA('I''m glad you like it so much.','Fine',NIL,NIL,NIL);

      CASE 2;  RtEZRequestA('Maybe if you run the demo again\nyou''ll REALLY like it.',
                            'Perhaps', NIL, NIL, NIL);
         
   ENDSELECT;
      
   ret:=RtEZRequestA('The number of responses is not limited to three\n'+
                     'as you can see.  The gadgets are labeled with\n'+ 
                     'the "Return" code from EZRequest().\n'+
                     'Pressing "Return" will choose 4, note that\n'+
                     '4''s button text is printed in boldface.',
                     '1|2|3|4|5|0', NIL, NIL,
                     [RTEZ_DEFAULTRESPONSE,4,
                      TAG_DONE]);

   RtEZRequestA('You picked ' + '%ld', 'How true', NIL, [ret], NIL);

   RtEZRequestA ('New for Release 2.0 of ReqTools (V38) is\n'+
                 'the possibility to define characters in the\n'+
                 'buttons as keyboard shortcuts.\n'+ 
                 'As you can see these characters are underlined.\n'+
                 'Note that pressing shift while still holding\n'+ 
                 'down the key will cancel the shortcut.',
                 '_Great|_Fantastic| _Swell|Oh, _Boy',
                 NIL, NIL,[RT_UNDERSCORE,00000095,TAG_DONE]);

   StrCopy(buffer,'five');
   RtEZRequestA('You may also use C-style formatting codes in the body text.\n'+
                'Like this:\n\n'+
                'The number %%ld is written %%s. will give:\n\n'+
                'The number %ld is written %s.\n\n'+
                'if you also pass ''5'' and ''five'' to EZRequest'+'('+')'+'.','_Proceed', NIL, [5,buffer],
                [RT_UNDERSCORE,00000095,TAG_DONE]);

   ret:=RtEZRequestA('It is also possible to pass extra IDCMP flags\n'+
                     'that will satisfy EZRequest'+'('+')'+'. This requester\n'+
                     'has had DISKINSERTED passed to it.\n'+
                     '('+'Try inserting a disk'+')'+'.',
                     '_Continue', NIL, NIL,
                     [RT_IDCMPFLAGS,DISKINSERTED,
                      RT_UNDERSCORE,00000095,
                      TAG_DONE]);

   IF ret=DISKINSERTED
      RtEZRequestA('You inserted a disk.', 'I did', NIL, NIL, NIL)
   ELSE
      RtEZRequestA('You used the ''Continue'' gadget\n'+
                   'to satisfy the requester.', 'I did', NIL, NIL, NIL)
   ENDIF

   RtEZRequestA('Finally, it is possible to specify the position\n'+
                'of the requester.\n'+
                'E.g. at the top left of the screen, like this.\n'+
                'This works for all requesters, not just EZRequest'+'('+')'+'!',
                '_Amazing', NIL, NIL,
                [RT_REQPOS,REQPOS_TOPLEFTSCR,
                 RT_UNDERSCORE,00000095,
                 TAG_DONE]);

   RtEZRequestA('Alternatively, you can center the\n'+
                'requester on the screen.\n' +
                'Check out ''reqtools.doc'' for all the possibilities.',
                'I''ll do that', NIL, NIL,
                [RT_REQPOS,REQPOS_CENTERSCR,TAG_DONE]);

   RtEZRequestA('NUMBER 4:\nFile requester\n'+
                'function: rtFileRequest'+'('+')',
                '_Demonstrate', NIL, NIL,[RT_UNDERSCORE,00000095,TAG_DONE]);



   filereq:=RtAllocRequestA(RT_FILEREQ,NIL);
   

   IF filereq
   
      filename[0]:=0;
      ret:=RtFileRequestA(filereq, filename, 'Pick a file',NIL);
      IF ret<>0
         RtEZRequestA('You picked the file:\n%s\nin directory:\n%s',
                      'Right', NIL, [filename,filereq.dir], NIL)
         
      ELSE
         RtEZRequestA('You didn''t pick a file.', 'No', NIL, NIL, NIL);
     ENDIF

      RtFreeRequest(filereq);

   ELSE
      RtEZRequestA('Out of memory!', 'Oh boy!', NIL, NIL, NIL);
   ENDIF


   RtEZRequestA ('The file requester can be used\nas a directory requester as well.',
                 'Let''s _see that', NIL, NIL, [RT_UNDERSCORE,00000095,TAG_DONE]);

   filereq:=RtAllocRequestA(RT_FILEREQ, NIL);
   IF filereq

         ret:=RtFileRequestA(filereq, filename, 'Pick a directory',
                    [RTFI_FLAGS,FREQF_NOFILES,TAG_DONE]);
         IF ret=1
              RtEZRequestA ('You picked the directory:\n%s','Right', NIL, [filereq.dir], NIL)
         ELSE
              RtEZRequestA ('You didn''t pick a directory.', 'No', NIL, NIL, NIL)
         ENDIF

         RtEZRequestA ('You can also change the Height of the requester', 'Wow', NIL, NIL, NIL);

         ret:=RtFileRequestA(filereq, filename, 'Pick a directory',
                    [RTFI_FLAGS,FREQF_NOFILES,
                     RTFI_HEIGHT,250,
                     TAG_DONE]);

         IF ret=1
              RtEZRequestA ('You picked the directory:\n%s','Right',NIL,[filereq.dir], NIL)
         ELSE
              RtEZRequestA ('You didn''t pick a directory.', 'No', NIL, NIL, NIL)
         ENDIF

         RtEZRequestA ('You can also change the OK_GADGET', 'Great', NIL, NIL, NIL);

         ret:=RtFileRequestA(filereq,filename, 'Remove a directory',
                    [RTFI_FLAGS,FREQF_NOFILES,
                     RTFI_OKTEXT,'_Remove',
                     RT_UNDERSCORE,00000095,
                     TAG_DONE]);
         IF  ret=1
              RtEZRequestA('You picked the directory:\n%s','Right', NIL, [filereq.dir], NIL)
         ELSE
              RtEZRequestA('You didn''t pick a directory.', 'No', NIL, NIL, NIL)
         ENDIF

         RtFreeRequest(filereq);
         filereq:=RtAllocRequestA(RT_FILEREQ, NIL);       
         RtEZRequestA('You can also use it as a Disk-requester', 'Perfect', NIL, NIL, NIL);

         ret:=RtFileRequestA(filereq,filename, 'Unmount a device',
                    [RTFI_VOLUMEREQUEST,VREQF_ALLDISKS OR VREQF_NOASSIGNS,
                     RTFI_OKTEXT,'Un_Mount',
                     RT_UNDERSCORE,00000095,
                     TAG_DONE]);
         IF ret=1
              RtEZRequestA('You picked the device:\n%s','Right',NIL,[filereq.dir],NIL)
         ELSE
              RtEZRequestA('You didn''t pick a device.', 'No', NIL, NIL, NIL)
         ENDIF

      RtFreeRequest(filereq);
      ELSE
          RtEZRequestA('Out of memory!', 'Oh boy!', NIL, NIL, NIL);

      ENDIF

 
   RtEZRequestA ('NUMBER 5:\nFont requester\nfunction: rtFontRequest'+'('+')',
                 'Show', NIL, NIL, NIL);

   fontreq:=RtAllocRequestA(RT_FONTREQ, NIL);
   IF fontreq 

      ret:=RtFontRequestA(fontreq,'Pick a font',
                         [RTFO_FLAGS,FREQF_STYLE OR FREQF_COLORFONTS,
                          TAG_DONE]);

      IF ret<>0 

            txtatt:=fontreq.attr;
            RtEZRequestA('You picked the font:\n%s\nwith size:\n%ld',
                'Right', NIL, [txtatt.name,txtatt.ysize], NIL)
       ELSE
            RtEZRequestA ('You didn''t pick a font','I know', NIL, NIL, NIL);
       ENDIF
       RtFreeRequest(fontreq);
   ELSE
        RtEZRequestA ('Out of memory!', 'Oh boy!', NIL, NIL, NIL);
   ENDIF

   inforeq:=RtAllocRequestA(RT_REQINFO, NIL);
   IF inforeq

      RtEZRequestA ('With rtAllocRequestA'+' ('+' RT_REQINFO '+', NIL )\n'+
                    'you can center the text in the requester', 'Got it',
               inforeq, NIL, [RTEZ_FLAGS,EZREQF_CENTERTEXT,TAG_DONE]);
      RtFreeRequest(inforeq);
   ELSE
      RtEZRequestA ('Out of memory!', 'Oh boy!', NIL, NIL, NIL);
   ENDIF

   RtEZRequestA('NUMBER 6:\nScreenMode requester\nfunction: rtScreenModeRequestA'+'('+')',
                'Proceed', NIL, NIL, NIL);

   scrnreq:=RtAllocRequestA(RT_SCREENMODEREQ, NIL);
   IF scrnreq

     ret:=RtScreenModeRequestA(scrnreq, 'Pick a screenmode',
                              [RTSC_FLAGS,SCREQF_DEPTHGAD OR SCREQF_SIZEGADS OR SCREQF_AUTOSCROLLGAD OR SCREQF_OVERSCANGAD,
                               RT_UNDERSCORE,00000095,
                               TAG_DONE]);

     IF scrnreq.autoscroll THEN StrCopy(buffer,'On') ELSE StrCopy(buffer,'Off');

     IF ret=1
          RtEZRequestA ('You picked this mode:\n'+
                        'ModeID   : 0x%lx\n'+
                        'Size     : %ld x %ld\n'+
                        'Depth    : %ld\n'+
                        'Overscan : %ld\n'+
                        'AutoScroll %s', 'Right', NIL,
                        [scrnreq.displayid,scrnreq.displaywidth,
                         scrnreq.displayheight,scrnreq.displaydepth,
                         scrnreq.overscantype,buffer], NIL);

      ELSE
          RtEZRequestA('You didn''t pick a screen mode.', 'Sorry', NIL, NIL, NIL);
      ENDIF
      RtFreeRequest(scrnreq);
   ELSE
      RtEZRequestA ('Out of memory!', 'Oh boy!', NIL, NIL, NIL);
   ENDIF


   RtEZRequestA ('NUMBER 7:\nPalette requester\n'+
                 'function: rtPaletteRequest'+'('+')',
                 '_Proceed', NIL, NIL,[RT_UNDERSCORE,00000095,TAG_DONE]);

   color:=RtPaletteRequestA('Change palette', NIL, NIL);
   IF color=-1
        RtEZRequestA ('You canceled.\nNo nice colors to be picked ?',
                      'Nah', NIL, NIL, NIL)
   ELSE
        RtEZRequestA ('You picked color number %ld.', 'Sure did', NIL, {color}, NIL)
   ENDIF


   WriteF('\nFinished, hope you enjoyed the demo\n\n');

   CloseLibrary(reqtoolsbase);

  ELSE
      WriteF('Failed to open ''reqtools.library''\n');
  ENDIF

ENDPROC
