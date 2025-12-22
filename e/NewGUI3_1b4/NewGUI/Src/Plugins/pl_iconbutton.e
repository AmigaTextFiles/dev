/* 
 *  Icon-Plug Version 2.0
 * -====================-
 * 
 * Changes:
 * --------
 *
 * 1.0: = First Release
 *      - Drawed Image with DrawImage()
 *
 * 1.1: = Bugfix inside min_size (wrong height!)
 *
 * 1.2: = Experimental Version with GadTools-Button-Gadget
 *      - Not working correct!
 * 
 * 1.3: = You could choose now the gadget (select-render)
 * 
 * 1.4: = Internal BugFix (Drawing the selected Image at wrong coordinates!)
 * 
 * 1.5: = Changed the Image-Plugin to Icon-Plugin 
 *      - Uses now the Gadget-Structure of the diskobject (PTR)
 *
 * 1.6: = Added the Selectable-Feature
 *
 * 1.7: = Bugfix inside message_test(), now searching for the right mes.iadress
 *
 * 1.8: = Bugfix! Now the Icon is really selectable!
 *      - added self.gad.gadgettype=GTYP_BOOLGADGET-Flag
 *      - added self.gad.activation=GACT_RELVERIFY -Flag
 *      - correcting the Position of the Image (x,y)
 *      - correcting the size of the Image (width,height)
 *
 * 1.9: = Cosmetical changing
 *      - changed the contructurs-name from create() to icon()
 *
 * 2.0: = First NewGUI-Release
 *      - Rewrote the Plugin for NewGUI (Recompiling)
 *      - added the ICON-Constant, makes your Gui-Description more readable!
 *      - Added OPT OSVERSION = 37, the compilers says no longer "Module changed OPT-Direction" or so...(?)
 */

OPT     MODULE
OPT     OSVERSION = 37

MODULE	'newgui/newgui',
	'intuition/intuition'

EXPORT  CONST   ICON = PLUGIN

EXPORT  OBJECT  icon OF plugin
 sel                                            /* Ist das (Image auswählbar?                   */
PRIVATE
 win:PTR TO window                              /* PTR des Windows...                           */
 gad:PTR TO gadget                              /* INITIALISIERTE (!) Gadget-Struktur...        */
ENDOBJECT

PROC icon(gd:PTR TO gadget,sel)       OF icon
 self.gad:=gd                                   /* Gadget (PTR) speichern...                    */
  self.sel:=sel                                 /* Gadget auswählbar?                           */
   self.gad.gadgetid:=0
    self.gad.gadgettype:=GTYP_BOOLGADGET
     self.gad.activation:=GACT_RELVERIFY
ENDPROC

PROC will_resize()               OF icon IS 0 -> Nicht resizeable!

PROC min_size(x,y)               OF icon IS self.gad.width,self.gad.height

PROC render(a,x,y,xs,ys,win:PTR TO window)       OF icon 
 DEF    gad=0:PTR TO gadget
  gad:=self.gad
   gad.leftedge:=x
    gad.topedge:=y
     gad.width:=xs
      gad.height:=ys
  IF self.win=NIL                               /* Wenn der Window-PTR nicht gesetzt ist!       */ 
    AddGadget(win,gad,-1)                       /* Gadget ans Ende der Liste anhängen!          */
   self.win:=win                                /* WindowPTR im Objekt speichern...             */
  ENDIF
   RefreshGadgets(gad,win,0)                    /* Gadget refreshen + zeichnen...               */
ENDPROC TRUE

PROC message_test(msg:PTR TO intuimessage,win)   OF icon
 DEF    class, gad:PTR TO gadget
  IF self.sel=FALSE                             /* Wenn das Gadget nicht angewählt werden darf..*/
   RETURN FALSE                                 /* Prozedur mit FALSE (keine Msg für uns!) verl.*/
  ELSE                                          /* Wenn auswählbar!                             */
   class:=msg.class                             /* Klasse (Art) festlegen                       */
    SELECT class                                /* Wenn Button losgelassen wurde!               */
     CASE       IDCMP_GADGETUP
      gad:=msg.iaddress
       IF gad=self.gad                          /* Wenn der Code = der ID                       */
        RETURN TRUE                             /* Wahr (eine Msg für uns!) zurück!             */
       ENDIF
    ENDSELECT
  ENDIF
ENDPROC FALSE                                   /* Standart -> Keine Msg für uns!               */

PROC message_action(a,b,c,win)        OF icon IS TRUE
