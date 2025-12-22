/*
      TurMite.c        Gary Teachout     September  1989

      lc -L TurMite    To compile and link with Lattice 5.0
*/

 #include <intuition/intuition.h>

 #define FPEN        3
 #define DPEN        3
 #define BPEN        0
 #define PLANES      2
 #define CMAX        4
 #define TOPLINE     11

 struct menubox
 {
   struct MenuItem      item  ;
   struct IntuiText     text  ;
 }  ;

 struct IntuitionBase      *IntuitionBase  ;
 struct GfxBase            *GfxBase  ;

 struct IntuiMessage       *mes  ;
 struct Screen             *screen  ;
 struct Window             *window  ;

 ULONG   class  ;
 USHORT  code  ;

 struct  NewScreen   ns =
 {
   0 , 0 , 320 , 200 , PLANES , DPEN , BPEN , 0 ,
   CUSTOMSCREEN , NULL , NULL , NULL , NULL
 }  ;

 UBYTE   *title[ 2 ] =
 {
   "  TurMite" ,
   "  Edit Field"
 }  ;

 struct TextAttr  stext = { "topaz.font" , 8 , 0 , 0 }  ;

 struct  NewWindow
   nw =
   {
      0 , 0 , 320 , 200 , DPEN , BPEN ,
      MENUPICK | MENUVERIFY | MOUSEBUTTONS ,
      SMART_REFRESH | ACTIVATE | BACKDROP | BORDERLESS ,
      NULL , NULL , NULL , 
      NULL , NULL , 0 , 0 , 0 , 0 , CUSTOMSCREEN
   } ,
   nwr =
   {
      25 , 20 , 270 , 154 , BPEN , DPEN ,
      GADGETDOWN | GADGETUP | MENUVERIFY | RAWKEY ,
      SMART_REFRESH | ACTIVATE ,
      NULL , NULL , "  Rule Tables" , 
      NULL , NULL , 0 , 0 , 0 , 0 , CUSTOMSCREEN
   }  ;

 USHORT chip   pointer[ 20 ] =
 {
   0x0000 , 0x0000 ,
   0x8000 , 0x0000 ,
   0xc000 , 0x0000 ,
   0xa000 , 0x0000 ,
   0x9000 , 0x0000 ,
   0x8800 , 0x0000 ,
   0x8400 , 0x0000 ,
   0x8000 , 0x0000 ,
   0x0000 , 0x0000 ,
   0x0000 , 0x0000
 }  ;

 struct Menu
   menulist[ 2 ] =
   {
      {  NULL , 1   , 0 , 90 , 8  , MENUENABLED , " Control" , NULL } ,
      {  NULL , 1   , 0 , 90 , 8  , MENUENABLED , " Edit" , NULL }
   }  ;

 struct menubox 
   controlmenu[ 9 ] =
   {
      {
         {  NULL , 0 , 0  , 140 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ | CHECKIT ,
            0x02 , NULL , NULL , 'S' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Stop" , NULL } 
      } ,
      {
         {  NULL , 0 , 11 , 140 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ | CHECKIT | CHECKED ,
            0x01 , NULL , NULL , 'G' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Go" , NULL } 
      } ,
      {
         {  NULL , 0 , 22 , 140 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ 
            | CHECKIT | CHECKED | MENUTOGGLE ,
            0 , NULL , NULL , 'F' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Fast" , NULL } 
      } ,
      {
         {  NULL , 0 , 33 , 140 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP ,
            0 , NULL , NULL , 0 , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Restart" , NULL } 
      } ,
      {
         {  NULL , 0 , 44 , 140 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ ,
            0 , NULL , NULL , 'J' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Jumble" , NULL } 
      } ,
      {
         {  NULL , 0 , 55 , 140 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP ,
            0 , NULL , NULL , 0 , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Field Size" , NULL } 
      } ,
      {
         {  NULL , 0 , 66 , 140 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ ,
            0 , NULL , NULL , 'E' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Edit Field" , NULL } 
      } ,
      {
         {  NULL , 0 , 77 , 140 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP ,
            0 , NULL , NULL , 0 , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "New Rule" , NULL } 
      } ,
      {
         {  NULL , 0 , 94 , 140 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ ,
            0 , NULL , NULL , 'Q' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Quit" , NULL } 
      } 
   } ,
   sizesub[ 2 ] =
   {
      {
         {  NULL , 130 , 0  , 135 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ ,
            0 , NULL , NULL , 'L' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 10 , 2 , NULL , "320 * 189" , NULL } 
      } ,
      {
         {  NULL , 130 , 11 , 135 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ,
            0 , NULL , NULL , 'H' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 10 , 2 , NULL , "640 * 389" , NULL } 
      }
   } ,
   restartsub[ 4 ] =
   {
      {
         {  NULL , 130 , 0  , 115 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ ,
            0 , NULL , NULL , '1' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 10 , 2 , NULL , "Black" , NULL } 
      } ,
      {
         {  NULL , 130 , 11 , 115 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ ,
            0 , NULL , NULL , '2' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 10 , 2 , NULL , "Red" , NULL } 
      } ,
      {
         {  NULL , 130 , 22 , 115 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ ,
            0 , NULL , NULL , '3' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 10 , 2 , NULL , "Blue" , NULL } 
      } ,
      {
         {  NULL , 130 , 33 , 115 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ,
            0 , NULL , NULL , '4' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 10 , 2 , NULL , "Yellow" , NULL } 
      }
   } ,
   rulesub[ 2 ] =
   {
      {
         {  NULL , 130 , 0  , 120 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ ,
            0 , NULL , NULL , 'R' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 10 , 2 , NULL , "Random" , NULL } 
      } ,
      {
         {  NULL , 130 , 11 , 120 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ,
            0 , NULL , NULL , 'C' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 10 , 2 , NULL , "Custom" , NULL } 
      }
   } ,
   editmenu[ 3 ] =
   {
      {
         {  NULL , 0 , 0  , 170 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP ,
            0 , NULL , NULL , 0 , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Color" , NULL } 
      } ,
      {
         {  NULL , 0 , 11 , 170 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP ,
            0 , NULL , NULL , 0 , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Blank Field" , NULL } 
      } ,
      {
         {  NULL , 0 , 22 , 170 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ ,
            0 , NULL , NULL , 'C' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Continue" , NULL } 
      } 
   } ,
   colorsub[ 5 ] =
   {
      {
         {  NULL , 130 , 0  , 150 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ | CHECKIT ,
            0x1e , NULL , NULL , 'E' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Black" , NULL } 
      } ,
      {
         {  NULL , 130 , 11 , 150 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ | CHECKIT ,
            0x1d , NULL , NULL , 'R' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Red" , NULL } 
      } ,
      {
         {  NULL , 130 , 22 , 150 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ | CHECKIT ,
            0x1b , NULL , NULL , 'B' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Blue" , NULL } 
      } ,
      {
         {  NULL , 130 , 33 , 150 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ | CHECKIT ,
            0x17 , NULL , NULL , 'Y' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Yellow" , NULL } 
      } ,
      {
         {  NULL , 130 , 44 , 150 , 11 , 
            ITEMTEXT | ITEMENABLED | HIGHCOMP | COMMSEQ | CHECKIT ,
            0x0f , NULL , NULL , 'S' , NULL , NULL } ,
         {  FPEN , BPEN , JAM1 , 25 , 2 , NULL , "Start Point" , NULL } 
      }
   }  ;

 struct Gadget
   tabgadget[ 48 ] =
   {
      {  NULL , 0 , 0 , 12 , 12 ,
         GADGHNONE , GADGIMMEDIATE , BOOLGADGET , 
         NULL , NULL , NULL , 0 , NULL , 0 , NULL   }
   } ,
   congadget[ 4 ] =
   {
      {  NULL , 10  , 120 , 120 , 11 ,
         GADGHCOMP , RELVERIFY , BOOLGADGET , 
         NULL , NULL , NULL , 0 , NULL , 100 , NULL } ,
      {  NULL , 140 , 120 , 120 , 11 ,
         GADGHCOMP , RELVERIFY , BOOLGADGET , 
         NULL , NULL , NULL , 0 , NULL , 101 , NULL } ,
      {  NULL , 10  , 138 , 120 , 11 ,
         GADGHCOMP , RELVERIFY , BOOLGADGET , 
         NULL , NULL , NULL , 0 , NULL , 102 , NULL } ,
      {  NULL , 140 , 138 , 120 , 11 ,
         GADGHCOMP , RELVERIFY , BOOLGADGET , 
         NULL , NULL , NULL , 0 , NULL , 103 , NULL }
   }  ;

 struct IntuiText    context[ 4 ] =
 {
   {  3 , BPEN , JAM1 , 40 , 2 , NULL , "CLEAR" , NULL  } ,
   {  3 , BPEN , JAM1 , 40 , 2 , NULL , "RESET" , NULL  } ,
   {  3 , BPEN , JAM1 , 52 , 2 , NULL , "OK     O" , NULL  } ,
   {  3 , BPEN , JAM1 , 36 , 2 , NULL , "CANCEL   C" , NULL  }
 }  ;

 struct Border    borders[ 2 ] =
 {
   {  0 , 0 , 2 , 0 , JAM1 , 5 } ,
   {  -1 , -1 , 2 , 0 , JAM1 , 5 }
 }  ;

 short   xyborders[ 2 ][ 10 ] =
 {
   {  0 , 0 , 11 , 0 , 11 , 11 , 0 , 11 , 0 , 0  } ,
   {  0 , 0 , 121 , 0 , 121 , 12 , 0 , 12 , 0 , 0  }
 } ;

 UBYTE   digit[ 5 ] = "1234"  ;

 long    wx , wy , wpr , wprm , wt , wll ;
 USHORT  *wp0 , *wp1 , mask1 = 1 , mask0 = 0xfffe , dir , os ,
         stopflag = 0 , fast = 1 , fieldsize = 1  ;


 USHORT /* xxx[ state ][ color ] */
   state[ 4 ][ 4 ] =
   {  {  0 , 2 , 0 , 1  } ,
      {  2 , 0 , 1 , 0  } ,
      {  2 , 0 , 1 , 1  } ,
      {  0 , 0 , 0 , 0  }  }  ,
   color[ 4 ][ 4 ] =
   {  {  3 , 1 , 0 , 3  } ,
      {  1 , 2 , 2 , 0  } ,
      {  0 , 3 , 3 , 1  } ,
      {  0 , 0 , 0 , 0  }  }  ,
   motion[ 4 ][ 4 ] =
   {  {  1 , 1 , 3 , 1  } ,
      {  3 , 1 , 3 , 0  } ,
      {  3 , 1 , 3 , 3  } ,
      {  0 , 0 , 0 , 0  }  }  ;


 char                   *AllocMem()  ;
 struct Screen          *OpenScreen()  ;
 struct Window          *OpenWindow()  ;
 struct IntuiMessage    *GetMsg()  ;

 void    cleanup( void )  ;
 void    turmite( void )  ;
 UBYTE   random( UBYTE )  ;
 void    handlemsg( void )  ;
 void    handlemenu( void )  ;
 void    randrule( void )  ;
 void    stoploop( void )  ;
 void    editmode( void )  ;
 void    field( USHORT )  ;
 void    randomrule( void )  ;
 void    customrule( void )  ;
 void    jumble( void )  ;


 void main()
 {
   short    ii , i , j , k  ;

   IntuitionBase = ( struct IntuitionBase * )
                   OpenLibrary( "intuition.library" , 33 )  ;
   if ( ! IntuitionBase )
      cleanup()  ;

   GfxBase = ( struct GfxBase * )
             OpenLibrary( "graphics.library" , 33 )  ;
   if ( ! GfxBase )
      cleanup()  ;

   borders[ 0 ].XY = &xyborders[ 0 ][ 0 ]  ;
   for ( ii = i = 0 ; i < 3 ; i ++ )
   {
      for ( j = 0 ; j < 4 ; j ++ )
      {
         for ( k = 0 ; k < 4 ; k ++ , ii ++ )
         {
            tabgadget[ ii ] = tabgadget[ 0 ]  ;
            tabgadget[ ii ].LeftEdge = 20 + k * 15 + i * 85  ;
            tabgadget[ ii ].TopEdge = 23 + j * 13  ;
            tabgadget[ ii ].GadgetRender = ( APTR ) &borders[ 0 ]  ;
            tabgadget[ ii ].GadgetID = ii  ;
         }
      }
   }
   for ( i = 0 ; i < 47 ; i ++ )
      tabgadget[ i ].NextGadget = &tabgadget[ i + 1 ]  ;

   borders[ 1 ].XY = &xyborders[ 1 ][ 0 ]  ;
   congadget[ 0 ].GadgetRender = ( APTR ) &borders[ 1 ]  ;
   congadget[ 1 ].GadgetRender = ( APTR ) &borders[ 1 ]  ;
   congadget[ 2 ].GadgetRender = ( APTR ) &borders[ 1 ]  ;
   congadget[ 3 ].GadgetRender = ( APTR ) &borders[ 1 ]  ;
   congadget[ 0 ].GadgetText = &context[ 0 ]  ;
   congadget[ 1 ].GadgetText = &context[ 1 ]  ;
   congadget[ 2 ].GadgetText = &context[ 2 ]  ;
   congadget[ 3 ].GadgetText = &context[ 3 ]  ;

   tabgadget[ 47 ].NextGadget = &congadget[ 0 ]  ;
   congadget[ 0 ].NextGadget = &congadget[ 1 ]  ;
   congadget[ 1 ].NextGadget = &congadget[ 2 ]  ;
   congadget[ 2 ].NextGadget = &congadget[ 3 ]  ;

   nwr.FirstGadget = &tabgadget[ 0 ]  ;

   menulist[ 0 ].FirstItem = &controlmenu[ 0 ].item  ;

   controlmenu[ 0 ].item.ItemFill = ( APTR ) &controlmenu[ 0 ].text  ;
   controlmenu[ 0 ].item.NextItem = &controlmenu[ 1 ].item  ;
   controlmenu[ 1 ].item.ItemFill = ( APTR ) &controlmenu[ 1 ].text  ;
   controlmenu[ 1 ].item.NextItem = &controlmenu[ 2 ].item  ;
   controlmenu[ 2 ].item.ItemFill = ( APTR ) &controlmenu[ 2 ].text  ;
   controlmenu[ 2 ].item.NextItem = &controlmenu[ 3 ].item  ;
   controlmenu[ 3 ].item.ItemFill = ( APTR ) &controlmenu[ 3 ].text  ;
   controlmenu[ 3 ].item.NextItem = &controlmenu[ 4 ].item  ;
   controlmenu[ 4 ].item.ItemFill = ( APTR ) &controlmenu[ 4 ].text  ;
   controlmenu[ 4 ].item.NextItem = &controlmenu[ 5 ].item  ;
   controlmenu[ 5 ].item.ItemFill = ( APTR ) &controlmenu[ 5 ].text  ;
   controlmenu[ 5 ].item.NextItem = &controlmenu[ 6 ].item  ;
   controlmenu[ 6 ].item.ItemFill = ( APTR ) &controlmenu[ 6 ].text  ;
   controlmenu[ 6 ].item.NextItem = &controlmenu[ 7 ].item  ;
   controlmenu[ 7 ].item.ItemFill = ( APTR ) &controlmenu[ 7 ].text  ;
   controlmenu[ 7 ].item.NextItem = &controlmenu[ 8 ].item  ;
   controlmenu[ 8 ].item.ItemFill = ( APTR ) &controlmenu[ 8 ].text  ;

   controlmenu[ 3 ].item.SubItem = &restartsub[ 0 ].item  ;
      restartsub[ 0 ].item.ItemFill = ( APTR ) &restartsub[ 0 ].text  ;
      restartsub[ 0 ].item.NextItem = &restartsub[ 1 ].item  ;
      restartsub[ 1 ].item.ItemFill = ( APTR ) &restartsub[ 1 ].text  ;
      restartsub[ 1 ].item.NextItem = &restartsub[ 2 ].item  ;
      restartsub[ 2 ].item.ItemFill = ( APTR ) &restartsub[ 2 ].text  ;
      restartsub[ 2 ].item.NextItem = &restartsub[ 3 ].item  ;
      restartsub[ 3 ].item.ItemFill = ( APTR ) &restartsub[ 3 ].text  ;

   controlmenu[ 5 ].item.SubItem = &sizesub[ 0 ].item  ;
      sizesub[ 0 ].item.ItemFill = ( APTR ) &sizesub[ 0 ].text  ;
      sizesub[ 0 ].item.NextItem = &sizesub[ 1 ].item  ;
      sizesub[ 1 ].item.ItemFill = ( APTR ) &sizesub[ 1 ].text  ;

   controlmenu[ 7 ].item.SubItem = &rulesub[ 0 ].item  ;
      rulesub[ 0 ].item.ItemFill = ( APTR ) &rulesub[ 0 ].text  ;
      rulesub[ 0 ].item.NextItem = &rulesub[ 1 ].item  ;
      rulesub[ 1 ].item.ItemFill = ( APTR ) &rulesub[ 1 ].text  ;

   menulist[ 1 ].FirstItem = &editmenu[ 0 ].item  ;

   editmenu[ 0 ].item.ItemFill = ( APTR ) &editmenu[ 0 ].text  ;
   editmenu[ 0 ].item.NextItem = &editmenu[ 1 ].item  ;
   editmenu[ 1 ].item.ItemFill = ( APTR ) &editmenu[ 1 ].text  ;
   editmenu[ 1 ].item.NextItem = &editmenu[ 2 ].item  ;
   editmenu[ 2 ].item.ItemFill = ( APTR ) &editmenu[ 2 ].text  ;

   editmenu[ 1 ].item.SubItem = &restartsub[ 0 ].item  ;

   editmenu[ 0 ].item.SubItem = &colorsub[ 0 ].item  ;
      colorsub[ 0 ].item.ItemFill = ( APTR ) &colorsub[ 0 ].text  ;
      colorsub[ 0 ].item.NextItem = &colorsub[ 1 ].item  ;
      colorsub[ 1 ].item.ItemFill = ( APTR ) &colorsub[ 1 ].text  ;
      colorsub[ 1 ].item.NextItem = &colorsub[ 2 ].item  ;
      colorsub[ 2 ].item.ItemFill = ( APTR ) &colorsub[ 2 ].text  ;
      colorsub[ 2 ].item.NextItem = &colorsub[ 3 ].item  ;
      colorsub[ 3 ].item.ItemFill = ( APTR ) &colorsub[ 3 ].text  ;
      colorsub[ 3 ].item.NextItem = &colorsub[ 4 ].item  ;
      colorsub[ 4 ].item.ItemFill = ( APTR ) &colorsub[ 4 ].text  ;

   ns.Font = &stext  ;
   ns.DefaultTitle = title[ 0 ]  ;

   field( 0 )  ;

   SetAPen( window->RPort , 3 )  ;
   Move( window->RPort , 0 , 150 )  ;     
   Text( window->RPort , "Two dimensional Turing machine simulator" , 40 )  ;
   Move( window->RPort , 0 , 164 )  ;
   Text( window->RPort , "by  Gary Teachout" , 17 )  ;

   Delay( 200 )  ;
   jumble()  ;

   for ( ; ; )
   {
      while ( fast )
      {
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         turmite()  ;
         handlemsg()  ;
      }
      while ( ! fast )
      {
         turmite()  ;
         handlemsg()  ;
         WaitTOF()  ;
      }
   }
 }


 void cleanup()  
 {
   if ( window )
   {
      ClearMenuStrip( window )  ;
      CloseWindow( window )  ;
   }

   if ( screen )
      CloseScreen( screen )  ;

   if ( GfxBase )
      CloseLibrary( GfxBase )  ;

   if ( IntuitionBase )
      CloseLibrary( IntuitionBase )  ;

   exit()  ;
 }


 void turmite()
 {
   register USHORT   w0 , w1 , c , nc  ;

   w0 = *wp0  ;
   w1 = *wp1  ;

   c =      ( ( w0 & mask1 ) ? 1 : 0 ) 
         |  ( ( w1 & mask1 ) ? 2 : 0 )  ;

   nc = color[ os ][ c ]  ;
   *wp0 = ( nc & 1 ) ? w0 | mask1 : w0 & mask0  ;
   *wp1 = ( nc & 2 ) ? w1 | mask1 : w1 & mask0  ;

   dir = ( dir + motion[ os ][ c ] ) % CMAX  ;
   switch ( dir )
   {
   case 0 :
      if ( wy > TOPLINE )
      {
         wy --  ;
         wp0 -= wpr  ;
         wp1 -= wpr  ;
      }
      else
      {
         wy = wll  ;
         wp0 += wt  ;
         wp1 += wt  ;
      }
      break  ;
   case 1 :
      if ( mask1 > 1 )
      {
         mask1 = mask1 >> 1  ;
         mask0 = ~ mask1  ;
      }
      else
      {
         mask1 = 0x8000  ;
         mask0 = 0x7fff  ;
         if ( ( wx += 1 ) == wpr )
         {
            wx = 0  ;
            wp0 -= wprm  ;
            wp1 -= wprm  ;
         }
         else
         {
            wp0 ++  ;
            wp1 ++  ;
         }
      }
      break  ;
   case 2 :
      if ( wy < wll )
      {
         wy ++  ;
         wp0 += wpr  ;
         wp1 += wpr  ;
      }
      else
      {
         wy = TOPLINE  ;
         wp0 -= wt  ;
         wp1 -= wt  ;
      }
      break  ;
   case 3 :
      if ( mask1 < 0x8000 )
      {
         mask1 = mask1 << 1  ;
         mask0 = ~ mask1  ;
      }
      else
      {
         mask1 = 0x0001  ;
         mask0 = 0xfffe  ;
         if ( wx == 0 )
         {
            wx = wpr - 1 ;
            wp0 += wprm  ;
            wp1 += wprm  ;
         }
         else
         {
            wx --  ;
            wp0 --  ;
            wp1 --  ;
         }
      }
      break  ;
   }

   os = state[ os ][ c ]  ;
 }

/********************************************************
 void turmite()
 {
   int      c  ;

   c = ReadPixel( window->RPort , posx , posy )  ;

   SetAPen( window->RPort , color[ os ][ c ] )  ;
   WritePixel( window->RPort , posx , posy )  ;

   dir = ( dir + motion[ os ][ c ] ) % CMAX  ;
   switch ( dir )
   {
   case 0 :
      posy = ( posy > TOPLINE ) ? posy - 1 : 199  ;
      break  ;
   case 1 :
      posx = ( posx + 1 ) % 320  ;
      break  ;
   case 2 :
      posy = ( posy < 199 ) ? posy + 1 : TOPLINE  ;
      break  ;
   case 3 :
      posx = ( posx + 319 ) % 320  ;
      break  ;
   }

   os = state[ os ][ c ]  ;
 }
********************************************************/


 UBYTE random( a )
   UBYTE    a  ;
 {
   #define RANDSHIFT      8
   #define RANDTAB        23
   #define RANDCOMP       8388608
   static UBYTE   fp = 1  ;
   static long    v[ RANDTAB ] , rr ;
   short          vi  ;

   if ( fp )
   {
      CurrentTime( &v[ 0 ] , &v[ 1 ] )  ;
      srand( v[ 1 ] )  ;
      for ( vi = 0 ; vi < RANDTAB ; vi ++ )
         v[ vi ] = rand() >> RANDSHIFT  ;
      rr = rand() >> RANDSHIFT  ;
      fp = 0  ;
   }

   vi = RANDTAB * rr / RANDCOMP  ;
   rr = v[ vi ]  ;
   v[ vi ] = rand() >> RANDSHIFT  ;

   return ( UBYTE ) ( ( a * rr ) / RANDCOMP )  ;
 }


 void handlemsg()
 {
   while ( mes = GetMsg( window->UserPort ) )
   {
      class = mes->Class  ;
      code = mes->Code  ;
      ReplyMsg( mes )  ;
      switch ( class )
      {
      case MENUVERIFY :
         Wait( 1 << window->UserPort->mp_SigBit )  ;
         while ( class != MENUPICK )
         {
            if ( mes = GetMsg( window->UserPort ) )
            {
               class = mes->Class  ;
               code = mes->Code  ;
               ReplyMsg( mes )  ;
            }
         }
      case MENUPICK :
         handlemenu()  ;
         break  ;
      }
   }
 }


 void handlemenu()
 {
   if ( ! MENUNUM( code ) )
   {
      switch ( ITEMNUM( code ) )
      {
      case 0 :
         stoploop()  ;
         break  ;
      case 1 :
         stopflag = 0  ;
         break  ;
      case 2 :
         fast = ( fast ) ? 0 : 1  ;
         break  ;
      case 3 :
         SetRast( window->RPort , SUBNUM( code ) )  ;
         wx = ( wpr >> 1 ) - 1  ;
         wy = ( screen->BitMap.Rows >> 1 ) + 6  ;
         wp0 =       ( ( USHORT * ) screen->BitMap.Planes[ 0 ] )
                  +  wx + ( wy * wpr )  ;
         wp1 =       ( ( USHORT * ) screen->BitMap.Planes[ 1 ] )
                  +  wx + ( wy * wpr )  ;
         mask1 = 1  ;
         mask0 = 0xfffe  ;
         dir = 3  ;
         os = 0  ;
         break  ;
      case 4 :
         jumble()  ;
         break  ;
      case 5 :
         field( ( short ) SUBNUM( code ) )  ;
         break  ;
      case 6 :
         editmode()  ;
         break  ;
      case 7 :
         if ( ! SUBNUM( code ) )
            randomrule()  ;
         else
            customrule()  ;
         break  ;
      case 8 : /* quit */
         cleanup()  ;
         break  ;
      }
   }
 }


 void stoploop()
 {
   if ( ! stopflag )
   {
      stopflag = 1  ;
      while ( stopflag )
      {
         Wait( 1 << window->UserPort->mp_SigBit )  ;
         handlemsg()  ;
      }
   }
 }


 void editmode()
 {
   UBYTE    color = 1  ;
   short    x , y , ox , oy , stop = 0  ;

   SetAPen( window->RPort , color )  ;
   SetWindowTitles( window , NULL , title[ 1 ] )  ;
   ClearMenuStrip( window )  ;
   colorsub[ 0 ].item.Flags = colorsub[ 0 ].item.Flags & ( ~ CHECKED )  ;
   colorsub[ 1 ].item.Flags = colorsub[ 1 ].item.Flags | CHECKED  ;
   colorsub[ 2 ].item.Flags = colorsub[ 2 ].item.Flags & ( ~ CHECKED )  ;
   colorsub[ 3 ].item.Flags = colorsub[ 3 ].item.Flags & ( ~ CHECKED )  ;
   colorsub[ 4 ].item.Flags = colorsub[ 4 ].item.Flags & ( ~ CHECKED )  ;
   SetMenuStrip( window , &menulist[ 1 ] )  ;

   SetPointer( window , pointer , 7 , 7 , -1 , 0 )  ;

   while( ! stop )
   {
      Wait( 1 << window->UserPort->mp_SigBit )  ;
      while ( mes = GetMsg( window->UserPort ) )
      {
         class = mes->Class  ;
         code = mes->Code  ;
         ReplyMsg( mes )  ;
         switch ( class )
         {
         case MENUVERIFY :
            Wait( 1 << window->UserPort->mp_SigBit )  ;
            while ( class != MENUPICK )
            {
               if ( mes = GetMsg( window->UserPort ) )
               {
                  class = mes->Class  ;
                  code = mes->Code  ;
                  ReplyMsg( mes )  ;
               }
            }
         case MENUPICK :
            switch ( ITEMNUM( code ) )
            {
            case 0 :
               color = SUBNUM( code )  ;
               if ( color != 4 )
                  SetAPen( window->RPort , color )  ;
               break  ;
            case 1 :
               SetRast( window->RPort , SUBNUM( code ) )  ;
               break  ;
            case 2 :
               stop = 1  ;
               break  ;
            }
            break  ;
         case MOUSEBUTTONS :
            if ( code == SELECTDOWN )
            {
               if ( color != 4 )
               {
                  ox = oy = -1  ;
                  while ( code != SELECTUP )
                  {
                     x = window->MouseX  ;
                     y = window->MouseY  ;
                     if (     ( ( x != ox ) || ( y != oy ) )
                           && ( y >= TOPLINE ) )
                     {
                        WritePixel( window->RPort , x , y )  ;
                        ox = x  ;
                        oy = y  ;
                     }
                     while ( mes = GetMsg( window->UserPort ) )
                     {
                        if ( mes->Class == MOUSEBUTTONS )
                           code = mes->Code  ;
                        ReplyMsg( mes )  ;
                     }
                  }
               }
               else
               {
                  x = ox = window->MouseX  ;
                  y = oy = window->MouseY  ;
                  dir = 3  ;
                  os = 0  ;
                  while ( code != SELECTUP )
                  {
                     x = window->MouseX  ;
                     y = window->MouseY  ;
                     while ( mes = GetMsg( window->UserPort ) )
                     {
                        if ( mes->Class == MOUSEBUTTONS )
                           code = mes->Code  ;
                        ReplyMsg( mes )  ;
                     }
                  }
                  if ( oy >= TOPLINE )
                  {
                     wx = ox >> 4  ;
                     wy = oy  ;
                     wp0 =    ( ( USHORT * ) screen->BitMap.Planes[ 0 ] )
                           +  wx + ( wy * wpr )  ;
                     wp1 =    ( ( USHORT * ) screen->BitMap.Planes[ 1 ] )
                           +  wx + ( wy * wpr )  ;
                     mask1 = 1 << ( 15 - ( ox & 0x000f ) )  ;
                     mask0 = ~ mask1  ;
                     if ( ( x != ox ) || ( y != oy ) )
                     {
                        x = x - ox  ;
                        ox = ( x >= 0 ) ? x : -x  ;
                        y = y - oy  ;
                        oy = ( y >= 0 ) ? y : -y  ;
                        if ( ox >= oy )
                           dir = ( x >= 0 ) ? 1 : 3  ;
                        else
                           dir = ( y >= 0 ) ? 2 : 0  ;
                     }
                  }
               }
            }
            break  ;
         }
      }
   }

   ClearPointer( window )  ;

   ClearMenuStrip( window )  ;
   SetMenuStrip( window , &menulist[ 0 ] )  ;
   SetWindowTitles( window , NULL , title[ 0 ] )  ;
 }


 void field( s )
   USHORT   s  ;
 {
   if ( s == fieldsize )
      return  ;

   if ( window )
   {
      ClearMenuStrip( window )  ;
      CloseWindow( window )  ;
   }

   if ( screen )
      CloseScreen( screen )  ;

   if ( s )
   {
      ns.Width = 640  ;
      ns.Height = 400  ;
      ns.ViewModes = HIRES | LACE  ;
      nw.Width = 640  ;
      nw.Height = 400  ;
   }
   else
   {
      ns.Width = 320  ;
      ns.Height = 200  ;
      ns.ViewModes = 0  ;
      nw.Width = 320  ;
      nw.Height = 200  ;
   }

   screen = OpenScreen( &ns )  ;
   if ( ! screen )
      cleanup()  ;

   SetRGB4( &screen->ViewPort , 0 , 0 , 0 , 0 )  ;
   SetRGB4( &screen->ViewPort , 1 , 15 , 0 , 0 )  ;
   SetRGB4( &screen->ViewPort , 2 , 0 , 0 , 15 )  ;
   SetRGB4( &screen->ViewPort , 3 , 15 , 15 , 0 )  ;

   nw.Screen = screen  ;
   window = OpenWindow( &nw )  ;
   if ( ! window )
      cleanup()  ;

   SetMenuStrip( window , &menulist[ 0 ] ) ;
   SetWindowTitles( window , NULL , title[ 0 ] )  ;
   ShowTitle( screen , TRUE )  ;

   wpr = screen->BitMap.BytesPerRow >> 1  ;
   wprm = wpr - 1  ;
   wt = wpr * ( screen->BitMap.Rows - TOPLINE - 1 )  ;
   wll = screen->BitMap.Rows - 1  ;
   wx = ( wpr >> 1 ) - 1  ;
   wy = ( screen->BitMap.Rows >> 1 ) + 6  ;
   wp0 = ( ( USHORT * ) screen->BitMap.Planes[ 0 ] ) + wx + ( wy * wpr )  ;
   wp1 = ( ( USHORT * ) screen->BitMap.Planes[ 1 ] ) + wx + ( wy * wpr )  ;
   mask1 = 1  ;
   mask0 = 0xfffe  ;

   dir = 3  ;
   os = 0  ;

   fieldsize = s  ;
 }


 void randomrule()
 {
   UBYTE    i , j , s , c , t = 0  ;

   for ( i = 0 ; i < 4 ; i ++ )
   {
      for ( j = 0 ; j < 4 ; j ++ )
      {
         state[ i ][ j ] = 0  ;
         color[ i ][ j ] = 0  ;
         motion[ i ][ j ] = 0  ;
      }
   }
   s = 1 + random( 4 )  ;
   c = 2 + random( 3 )  ;
   while ( ! t )
   {
      for ( i = 0 ; i < s ; i ++ )
      {
         for ( j = 0 ; j < c ; j ++ )
         {
            state[ i ][ j ] = random( s )  ;
            color[ i ][ j ] = random( c )  ;
            motion[ i ][ j ] = random( 4 )  ;
            if ( color[ i ][ j ] >= t )
               t = color[ i ][ j ]  ;
         }
      }
   }
 }


 void customrule()
 {
   struct Window  *w  ;
   struct Gadget  *g  ;
   USHORT   i , temp[ 48 ] , stop = 0 , reset = 1  ;
   ULONG    sig   ;

   if ( fieldsize )
   {
      nwr.LeftEdge = 185  ;
      nwr.TopEdge = 120  ;
   }
   else
   {
      nwr.LeftEdge = 25  ;
      nwr.TopEdge = 20  ;
   }
   nwr.Screen = screen  ;
   w = OpenWindow( &nwr )  ;
   if ( w )
   {
      SetAPen( w->RPort , 1 )  ;
      Move( w->RPort , 7 , 30 )  ;
      Text( w->RPort , "s" , 1 ) ;
      Move( w->RPort , 7 , 38 )  ;
      Text( w->RPort , "t" , 1 ) ;
      Move( w->RPort , 7 , 46 )  ;
      Text( w->RPort , "a" , 1 ) ;
      Move( w->RPort , 7 , 54 )  ;
      Text( w->RPort , "t" , 1 ) ;
      Move( w->RPort , 7 , 62 )  ;
      Text( w->RPort , "e" , 1 ) ;
      Move( w->RPort , 20 , 82 )  ;
      Text( w->RPort , "color" , 5 ) ;

      SetAPen( w->RPort , 3 )  ;
      Move( w->RPort , 20 , 20 )  ;
      Text( w->RPort , "STATE" , 5 ) ;
      Move( w->RPort , 105 , 20 )  ;
      Text( w->RPort , "COLOR" , 5 ) ;
      Move( w->RPort , 190 , 20 )  ;
      Text( w->RPort , "MOTION" , 6 ) ;

      Move( w->RPort , 100 , 86 )  ;
      Text( w->RPort , "1=Black" , 7 ) ;
      Move( w->RPort , 100 , 94 )  ;
      Text( w->RPort , "2=Red" , 5 ) ;
      Move( w->RPort , 100 , 102 )  ;
      Text( w->RPort , "3=Blue" , 6 ) ;
      Move( w->RPort , 100 , 110 )  ;
      Text( w->RPort , "4=Yellow" , 8 ) ;

      Move( w->RPort , 180 , 86 )  ;
      Text( w->RPort , "1=Forward" , 9 ) ;
      Move( w->RPort , 180 , 94 )  ;
      Text( w->RPort , "2=Right" , 7 ) ;
      Move( w->RPort , 180 , 102 )  ;
      Text( w->RPort , "3=Backward" , 10 ) ;
      Move( w->RPort , 180 , 110 )  ;
      Text( w->RPort , "4=Left" , 6 ) ;

      sig =    ( 1 << window->UserPort->mp_SigBit )
            |  ( 1 << w->UserPort->mp_SigBit )  ;

      while ( ! stop )
      {
         if ( reset )
         {
            for ( i = 0 ; i < 16 ; i ++ )
            {
               temp[ i ] = state[ ( i >> 2 ) & 3 ][ i & 3 ]  ;
               Move( w->RPort ,  tabgadget[ i ].LeftEdge + 2 ,
                                 tabgadget[ i ].TopEdge + 9 )  ;
               Text( w->RPort , &digit[ temp[ i ] ] , 1 ) ;
            }
            for ( i = 16 ; i < 32 ; i ++ )
            {
               temp[ i ] = color[ ( i >> 2 ) & 3 ][ i & 3 ]  ;
               Move( w->RPort ,  tabgadget[ i ].LeftEdge + 2 ,
                                 tabgadget[ i ].TopEdge + 9 )  ;
               Text( w->RPort , &digit[ temp[ i ] ] , 1 ) ;
            }
            for ( i = 32 ; i < 48 ; i ++ )
            {
               temp[ i ] = motion[ ( i >> 2 ) & 3 ][ i & 3 ]  ;
               Move( w->RPort ,  tabgadget[ i ].LeftEdge + 2 ,
                                 tabgadget[ i ].TopEdge + 9 )  ;
               Text( w->RPort , &digit[ temp[ i ] ] , 1 ) ;
            }
            reset = 0  ;
         }

         Wait( sig )  ;
         while ( mes = GetMsg( window->UserPort ) )
         {
            if ( ( mes->Class == MENUVERIFY ) && ( mes->Code == MENUHOT ) )
               mes->Code = MENUCANCEL  ;
            ReplyMsg( mes )  ;
         }
         while ( mes = GetMsg( w->UserPort ) )
         {
            class = mes->Class  ;
            code = mes->Code  ;
            g = ( struct Gadget * ) mes->IAddress  ;
            if ( ( mes->Class == MENUVERIFY ) && ( mes->Code == MENUHOT ) )
               mes->Code = MENUCANCEL  ;
            ReplyMsg( mes )  ;
            switch ( class )
            {
            case GADGETUP :
               switch ( g->GadgetID )
               {
               case 100 :
                  for ( i = 0 ; i < 48 ; i ++ )
                  {
                     temp[ i ] = 0  ;
                     Move( w->RPort ,  tabgadget[ i ].LeftEdge + 2 ,
                                       tabgadget[ i ].TopEdge + 9 )  ;
                     Text( w->RPort , &digit[ temp[ i ] ] , 1 ) ;
                  }
                  break  ;
               case 101 :
                  reset = 1  ;
                  break  ;
               case 102 :
                  for ( i = 0 ; i < 16 ; i ++ )
                  {
                     state[ i >> 2 ][ i & 3 ] = temp[ i ]  ;
                     color[ i >> 2 ][ i & 3 ] = temp[ i + 16 ]  ;
                     motion[ i >> 2 ][ i & 3 ] = temp[ i + 32 ]  ;
                  }
               case 103 :
                  stop = 1  ;
                  break  ;
               }
               break  ;
            case GADGETDOWN :
               temp[ g->GadgetID ] = ( temp[ g->GadgetID ] + 1 ) % 4  ;
               Move( w->RPort , g->LeftEdge + 2 , g->TopEdge + 9 )  ;
               Text( w->RPort , &digit[ temp[ g->GadgetID ] ] , 1 ) ;
               break  ;
            case RAWKEY :
               switch ( code )
               {
               case 24 :
                  for ( i = 0 ; i < 16 ; i ++ )
                  {
                     state[ i >> 2 ][ i & 3 ] = temp[ i ]  ;
                     color[ i >> 2 ][ i & 3 ] = temp[ i + 16 ]  ;
                     motion[ i >> 2 ][ i & 3 ] = temp[ i + 32 ]  ;
                  }
               case 51 :
                  stop = 1  ;
                  break  ;
               }
               break  ;
            }
         }
      }

      CloseWindow( w )  ;
   }
 }


 void jumble() 
 {
   short    x , y , xx , yy , px , pr  ;
   USHORT   m  ;
   UBYTE    c  ;

   pr = wpr << 4  ;
   for ( m = mask1 , x = 0 ; m < 0x8000 ; x ++ , m = m << 1 )
      ;
   px = ( wx << 4 ) + x  ;

   for ( c = 0 , y = 0 ; y < 4 ; y ++ )
   {
      for ( x = 0 ; x < 4 ; x ++ )
      {
         if ( color[ x ][ y ] >= c )
            c = color[ x ][ y ] + 1  ;
      }
   }

   for ( y = -5 ; y < 6 ; y ++ )
   {
      yy = wy + y  ;
      if ( yy < TOPLINE )
         yy = ( yy - TOPLINE + wll + 1 ) % ( wll + 1 )  ;
      if ( yy > wll )
         yy = ( yy % ( wll + 1 ) ) + TOPLINE  ;
      for ( x = -5 ; x < 6 ; x ++ )
      {
         xx = ( px + x + pr ) % pr  ;
         SetAPen( window->RPort , random( c ) )  ;
         WritePixel( window->RPort , xx , yy )  ;
      }
   }
 }



