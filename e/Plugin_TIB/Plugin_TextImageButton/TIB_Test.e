MODULE 'tools/easygui', 'tools/plugin_textimagebutton', '*TIB_Images', 'tools/exceptions'

PROC main() HANDLE
  DEF tib1=NIL:PTR TO textimagebutton_plugin,
      tib2=NIL:PTR TO textimagebutton_plugin,
      tib3=NIL:PTR TO textimagebutton_plugin,
      tib4=NIL:PTR TO textimagebutton_plugin,
      tib5=NIL:PTR TO textimagebutton_plugin,
      tib6=NIL:PTR TO textimagebutton_plugin,
      tib7=NIL:PTR TO textimagebutton_plugin,
      tib8=NIL:PTR TO textimagebutton_plugin, a

  easygui('Plugin Test!',
    [ROWS,
      [TEXT,'EasyGUI PLUGIN Test (Sorry, some images are in MWB-Style!)',NIL,TRUE,15],
      [BAR],
      [ROWS,
        [TEXT,'Simple Image Demonstration (Images have their own borders!):',NIL,FALSE,15],
        [COLS,
          [STR,1,NIL,'To make things look very good try to make gadgets the same y-size like the string gadget has! Next thing to include is to choose wheather you want wide (2 pixels) or narrow (1 pixel) borderwidth.', 300, 5],
          [PLUGIN,{a_left} ,NEW tib1.init( left_high() ,left_low() ,[EPTIB_BORDER,FALSE,NIL])],
          [PLUGIN,{a_right},NEW tib2.init( right_high(),right_low(),[EPTIB_BORDER,FALSE,NIL])],
          [PLUGIN,{a_up}   ,NEW tib3.init( up_high()   ,up_low()   ,[EPTIB_BORDER,FALSE,NIL])],
          [PLUGIN,{a_down} ,NEW tib4.init( down_high() ,down_low() ,[EPTIB_BORDER,FALSE,NIL])]
        ],
        [BAR],
        [TEXT,'EPTIB_IPOSUP and EPTIB_IPOSBOTTOM demonstration:',NIL,FALSE,15],
        [COLS, 
          [PLUGIN,{a_noise},NEW tib5.init( noise_high(),noise_low(),[EPTIB_TEXT,'Does not resize',           EPTIB_IMGPOS,EPTIB_IPOSBOTTOM,EPTIB_RESIZE,EPTIB_RESIZENONE,NIL])],
          [PLUGIN,{a_noise},NEW tib6.init( noise_high(),noise_low(),[EPTIB_TEXT,'Will resize X and Y',EPTIB_IMGPOS,EPTIB_IPOSTOP   ,EPTIB_RESIZE,EPTIB_RESIZEX OR EPTIB_RESIZEY,NIL])]
        ],
        [BAR],
        [TEXT,'Colourful example of this Plugin ! (EPTIB_BGNORMAL and EPTIB_BGSELECTED):',NIL,TRUE,15], 
        [COLS,
          [BUTTON,1,'-->-->-->'],
          [PLUGIN,{a_eye},NEW tib7.init( eye(),NIL,[EPTIB_TEXT,'Baumhaustürzylinderschloßschraubenkopf',EPTIB_BGNORMAL,2,EPTIB_BGSELECTED,3,EPTIB_RESIZE,EPTIB_RESIZEX,NIL])],
          [BUTTON,1,'All Buttons should have same y-size!']
        ],
        [BAR],
        [TEXT, 'Click this imagebutton to get more information about further projects of mine:',NIL,TRUE,5],
        [PLUGIN,{a_about},NEW tib8.init (up_high(),down_low(),[EPTIB_BORDER,FALSE,NIL])]
      ],
      [BAR],
      [SBUTTON,0,'Quit!']
    ])
EXCEPT
  END tib1
  END tib2
  END tib3
  END tib4
  END tib5
  END tib6
  END tib7
  END tib8
  report_exception()
ENDPROC

PROC a_left  (info,tib:PTR TO textimagebutton_plugin) IS WriteF('Left-Image pressed !\n')
PROC a_right (info,tib:PTR TO textimagebutton_plugin) IS WriteF('Right-Image pressed !\n')
PROC a_up    (info,tib:PTR TO textimagebutton_plugin) IS WriteF('Up-Image pressed !\n')
PROC a_down  (info,tib:PTR TO textimagebutton_plugin) IS WriteF('Down-Image pressed !\n')
PROC a_eye   (info,tib:PTR TO textimagebutton_plugin) IS WriteF('Eye-Image pressed !\n')
PROC a_noise (info,tib:PTR TO textimagebutton_plugin) IS WriteF('Noise-Image pressed !\n')

PROC a_about (info,tib:PTR TO textimagebutton_plugin)
easygui ('Further Information',
  [ROWS,
    [TEXT,'My name is Sebastian Hesselbarth and I started programming   ',NIL,FALSE,5],
    [TEXT,'some nice PLUGINs for the powerful EasyGUI written by        ',NIL,FALSE,5],
    [TEXT,'Wouter van Oortmerssen ! (Many thanx and greez fly to him !) ',NIL,FALSE,5],
    [BAR],
    [TEXT,'Up till now I wrote two PLUGINs :                            ',NIL,FALSE,5],
    [TEXT,' - Plugin_TextImageButton : To implement Imagebuttons and    ',NIL,FALSE,5],
    [TEXT,'     Buttons with Images AND Text in to EasyGUI !            ',NIL,FALSE,5],
    [TEXT,' - Plugin_Bitmap          : To implement a Bitmap - viewer   ',NIL,FALSE,5],
    [TEXT,'     in to your GUI ! Example copies the WB-Bitmap in to the ',NIL,FALSE,5],
    [TEXT,'     viewer !                                                ',NIL,FALSE,5],
    [BAR],
    [TEXT,'Both PLUGINs are yet not really BETA-tested, so contact me 4 ',NIL,FALSE,5],
    [TEXT,'bug report, suggestions, presents, money :), aso. !          ',NIL,FALSE,5],
    [BAR],
    [TEXT,'The following PLUGINs are planned or already in work to make ',NIL,FALSE,5],
    [TEXT,'EasyGUI as powerful as MU! (or as "MU!" as possible :) )  :  ',NIL,FALSE,5],
    [TEXT,' - ListView - PopUp - Gadget : You click on a popupgadget    ',NIL,FALSE,5],
    [TEXT,'     and a ListViewGadget opens under the stringgadget left  ',NIL,FALSE,5],
    [TEXT,'     to the popupgadget ! (look up in some MU! prgs)         ',NIL,FALSE,5],
    [TEXT,' - FileReqester - PopUp - Gadget : Same as above but a ASL   ',NIL,FALSE,5],
    [TEXT,'     or ReqTools-Requester opens !                           ',NIL,FALSE,5],
    [BAR],
    [TEXT,'Right, that''s it ... to contact me (for common projects,too)',NIL,FALSE,5],
    [TEXT,'write to (sorry, no email yet! :( ):                         ',NIL,FALSE,5],
    [TEXT,'     Sebastian Hesselbarth                                   ',NIL,FALSE,5],
    [TEXT,'     Multhoepen 13                                           ',NIL,FALSE,5],
    [TEXT,'     31855 Aerzen                                            ',NIL,FALSE,5],
    [TEXT,'     GERMANY                                                 ',NIL,FALSE,5],
    [TEXT,'     fON : +49-(0)515-480-51 (05154/8051 GERMANY ONLY!)      ',NIL,FALSE,5],
    [BAR],
    [BUTTON,0,'I will contact you !']
  ])
ENDPROC