/* EasyGUI BitMapPlugin-Test.e  ©1996 by Sebstian Hesselbarth           */
/*                                                                      */
/* This Plugin is useful for displaying bitmaps in the EasyGUI-         */
/* window ! It is only a beta version, so use it at your own            */
/* risk !!                                                              */
/*                                                                      */
/* Thanks go to :                                                       */
/*   Wouter van Oortmerssen : For AmigaE and EasGUI, of course          */
/*   Joerg Wach             : For founding the EPD ;-)                  */
/*   Daniel van Gerpen &                                                */
/*   Gregor Goldbach        : For keep releasing EPDs  !!               */
/*                                                                      */
/*                                                                      */
/* I think this plugin is easy to use !                                 */
/* The important things are :                                           */
/* Allocating enough memory for the plugin-object (look at source "NEW")*/
/* and handing over the right arguments for the initialisation routine  */
/*                                                                      */
/* e.g.: [PLUGIN, 1, NEW mp.init (bitmap, bitmapwidth, bitmapheight,    */
/*        bitmapdepth)]                                                 */
/*                                                                      */
/* "mp" is a pointer to the "bitmap_plugin"-object                      */
/* "bitmap" is the bitmap you want to draw in to your EasyGUI-window    */
/* "bitmapwidth", "bitmapheight" and "bitmapdepth" are the dimensions of*/
/*  your bitmap ! (x,y and z[colordepth])!!                             */
/*                                                                      */
/* This Module is not completely finished !!!                           */
/* ToDo:                                                                */
/*   - imform Wouter, that I had to add IDCMP_IDCMPUPDATE to the        */
/*     idcmpflags of the EasyGUI-window :-))))                          */
/*   - don't use system-images in scrollbuttons or change the bgcolor to*/
/*     0                                                                */
/*   - create new images for scrollergadgets which are 16*16 pixel or so*/
/*     (looks much better I think !) BUT I need a full description of   */
/*     the BOOPSI-Classes !!! Send them to me or just contact me !      */
/*   - buy a PPC603/604-Powerboard !!! ;->>>>>                          */
/*                                                                      */
/* Here is my address :                                                 */
/*   Sebastian Hesselbarth                                              */
/*   Multhöpen 13                                                       */
/*   31855 Aerzen                                                       */
/*   GERMANY                                                            */
/*                                                                      */      
/*   Tel. 05154/8051                                                    */
/*   email: SOON !!!!                                                   */
/*                                                                      */
/*                                      ciao, Sebastian !               */

MODULE 'tools/plugin_bitmap', 'intuition/screens', 'tools/easygui', 'tools/exceptions', 'graphics/gfx'

DEF mp:PTR TO bitmap_plugin, wbscr:PTR TO screen

PROC main() HANDLE
  IF (wbscr := LockPubScreen ('Workbench'))=NIL THEN Raise ("lock")
  easygui('Plugin Test!',
    [ROWS,
      [TEXT,'EasyGUIs BitMapPlugin-Test',NIL,TRUE,15],
      [PLUGIN,1,NEW mp.init(wbscr.bitmap, wbscr.width, wbscr.height, wbscr.bitmap.depth)],                       
      [SBUTTON,{redraw},'Set 1.Quarter of Workbench']
    ])
Raise (NIL)
EXCEPT
  END mp
  IF wbscr THEN UnlockPubScreen (NIL,wbscr)
  report_exception()
ENDPROC

PROC redraw ()
  mp.setbitmap (wbscr.bitmap, wbscr.width/2, wbscr.height/2, wbscr.bitmap.depth)
ENDPROC
