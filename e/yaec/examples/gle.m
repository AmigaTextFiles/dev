EXPORT CONST GLE_SPACEXY=-10, ->[spacex,spacey]
      GLE_GADFLAGS=-20,  ->flags
      GLE_UNITFACTORXY=-30, ->[hpix,vpix]
      GLE_MUP=-40, -> steps in units
      GLE_MDOWN=-50,  ->steps   -"-
      GLE_MLEFT=-60,  ->steps   -""-
      GLE_MRIGHT=-70, ->steps   -""-
      GLE_ADDGAD=-90, -> id
      GLE_SETGUISTARTXY=-110, ->[x,y]
      GLE_PLACE=-130, ->[h,v]
      GLE_PLACEXY=-140, ->[x,y]
      GLE_MSX=-150, -> NIL
      GLE_MSY=-160, -> NIL
      GLE_GADTEXTATTR=-170, ->textattr
      GLE_PLACING=-255,
      GP_RIGHT=-260,
      GP_UNDER=-270

-> EXPORT MACROs

EXPORT MACRO Gadget(kind,id,hsize,vsize,text,tags) IS gle.addGad(kind,id,hsize,vsize,text,tags)
EXPORT MACRO Button(id, width, text) IS gle.addGad( id, BUTTON_KIND, width, 1, text, NIL)
EXPORT MACRO SButton(id, text) IS gle.addGad( id, BUTTON_KIND, -1, 1, text, NIL)
EXPORT MACRO PlacingUnder IS gle.placing( GP_UNDER)
EXPORT MACRO PlacingRight IS gle.placing( GP_RIGHT)
EXPORT MACRO PlacingDiag  IS gle.placing( NIL)
EXPORT MACRO MoveU(steps) IS gle.mUp( steps)
EXPORT MACRO MoveD(steps) IS gle.mDown( steps)
EXPORT MACRO MoveL(steps) IS gle.mLeft( steps)
EXPORT MACRO MoveR(steps) IS gle.mRight( steps)
EXPORT MACRO MoveSX IS gle.mSX()
EXPORT MACRO MoveSY IS gle.mSY()
EXPORT MACRO OpenWin(tags) IS gle.openWin( tags)
EXPORT MACRO PlaceXY(x, y) IS gle.placeXY( x, y)
EXPORT MACRO Place(h, v) IS gle.place( h, v)
EXPORT MACRO GadFlags(flags) IS gle.gadFlags( flags)
EXPORT MACRO GadTextAttr(attr) IS gle.gadTextAttr( attr)
EXPORT MACRO SetGuiStartXY(x, y) IS gle.setGuiStartXY( x, y)
EXPORT MACRO UnitfactorXY(x, y) IS gle.unitfactorXY( x, y)
EXPORT MACRO SpaceXY(x, y) IS gle.spaceXY( x, y)
EXPORT MACRO Handler(proc, gadid) IS gle.eEventHandler( proc, gadid)
EXPORT MACRO HandleEvent(imsgcpy) IS gle.eHandleEvent( imsgcpy)
EXPORT MACRO SetGad(id,val) IS gle.setGad( id,val)
EXPORT MACRO GetGad(id) IS gle.setGad(id)
EXPORT MACRO GetWin() IS gle.getWin()

->990602 ; what did I do then ??
-> 000512-13 ; wrote autodoc : self.library.doc
-> moved opening of gadtools, utility into main()
-> added closing of above libs in close()
-> discovered there wasnt any closing of them before!!
-> found a way to find out the windows titlebar height,
-> BEFORE opening of the window! :) src/rkrm/gadtools/gadtoolsgadgets.e
-> Gonna rename gle.SniffWin() to gle.SniffScreen()..
-> NO, WAIT..hehe.. I can completely remove it instead :)
-> putting the code to do it in gle.Init(); storing height in
-> self.winbordheight. This means gle.FinWin() will dissapear
-> too! Instead we add a Function -> gle.OpenWin() and for
-> the sake of good looks, a CloseWin(). Adding self.window
-> gle.Init() now sets unitfactirXY to a default, based on screenfont !
-> works perfectly !! :)
-> now adding possibility to make buttons auto-sized;
-> pass -1 as width to gle.AddGad().
-> also working on EXPORT MACROs in gle_tags.e
-> removed closewin from functable; better to
-> use gle.Quit() instead.
->000514
-> added gle.GetWin()
-> added gle.eHandleEvent(), GLe_eEventHandler()
-> adding self.a4 : it crashed before because
-> eventhandlers where called from library-environment!
->000529 : Adding AutoLen of gadgets based on the
-> lenght of gadgettext. This is Ofcource just an addition,
-> old style is left untouched! Just use -1 as widthvalue
-> for the gadgets!
-> 000603 : FIXED a bug that didnt update self.gui_maxx/y
-> when moving around with the various move/place functions
-> just addgad did it before.

-> 011024 : rewritten to class (again!) for YAEC !

MODULE 'intuition/screens', 'gadtools', 'libraries/gadtools','gadtools', 'libraries/gadtools',
       'intuition/intuition', 'utility', 'utility/tagitem',
       'graphics/text'

EXPORT OBJECT gle ->buildgadgetlist - data
   PRIVATE
   glist:PTR TO gadget      -> hämta med gle_getglist(gle)
   gpa:PTR TO ANY     ->adress till array av gadpekare.
   gadptr:PTR TO gadget
   newgad:newgadget
   ->-------------
   unitfactorx:INT  ->sizefactor  h-unitsize
   unitfactory:INT ->sizefactor  v-unitsize
   gui_startx:INT  -> övre vänstra hörent
   gui_starty:INT  -> att sätta första gaden.
   gui_maxx:INT       -> nedre högra hörnet
   gui_maxy:INT       -> på hela GUI:et.
   cp_x:INT        -> nedre högra hörnet på senaste
   cp_y:INT        -> gaden. eller om den sätts till
                   -> nåt annat av gle_PlacePix() eller
                   ->tableft/tabup! bla..

   spacex:CHAR     -> mellanrum mellan gadgets vertikalt
   spacey:CHAR     ->         (i pixels)       horisontellt
   ->gadkind:LONG ->the usual..
   gadtags:LONG
   gadplacing:INT ->GP_RIGHT, GP_UNDER
   winbordheight:CHAR -> 000513
   window:PTR TO window -> 000513
   screen -> 000513
   ppa:PTR TO LONG
ENDOBJECT

DEF gadtoolsbase
DEF utilitybase

RAISE "LIB" IF OpenLibrary()=NIL

OPT INIT = init_gle()
OPT END = end_gle()

PROC init_gle()
   gadtoolsbase := OpenLibrary('gadtools.library', 37)
   utilitybase := OpenLibrary('utility.library', 37)
   #ifdef DEBUG
   WriteF('init_gle() : gadtoolsbase=$\h, utilitybase=$\h\n',
           gadtoolsbase, utilitybase)
   #endif
ENDPROC

PROC end_gle()
   IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
   IF utilitybase THEN CloseLibrary(utilitybase) 
ENDPROC


EXPORT CONST GLE_ERR_VISUAL = "visu",
      GLE_ERR_CONTEXT = "ctxt",
      GLE_ERR_WIN = "gwin"

PROC gle(screen:PTR TO screen, gpa=NIL, ppa=NIL) (LONG) OF gle
   DEF glist=NIL
   self.newgad.visualinfo:=GetVisualInfoA(screen,NIL)
   IF self.newgad.visualinfo=NIL THEN Raise(GLE_ERR_VISUAL)
   self.gadptr:=CreateContext({glist})
   IF self.gadptr=NIL THEN Raise(GLE_ERR_CONTEXT)
   self.glist:=glist
   self.gpa:=gpa
   self.winbordheight := screen.wbortop+screen.font.ysize+1 -> 000513
   self.setGuiStartXY(6, 2 + self.winbordheight) -> 000513
   self.mSX()
   self.mSY()
   self.unitfactorXY(pixPerChar(screen), 2 + self.winbordheight) -> 000513
   self.screen := screen -> 000513
   self.ppa := ppa
   #ifdef DEBUG
   WriteF('gle.gle() : successful construction\n')
   #endif
ENDPROC


PROC end() OF gle
   IF self.window THEN CloseWindow(self.window)
   IF self.newgad.visualinfo THEN FreeVisualInfo(self.newgad.visualinfo)
   IF self.glist THEN FreeGadgets(self.glist)
ENDPROC

PROC spaceXY(xspace, yspace) (LONG,LONG) OF gle
   self.spacex:=xspace
   self.spacey:=yspace
ENDPROC xspace, yspace

PROC unitfactorXY(xval, yval) (LONG,LONG) OF gle
   self.unitfactorx:=xval
   self.unitfactory:=yval
ENDPROC xval, yval

PROC mSX() (LONG) OF gle
   self.cp_x:=self.gui_startx
ENDPROC self.cp_x

PROC mSY() (LONG) OF gle
   self.cp_y:=self.gui_starty
ENDPROC self.cp_y

PROC mDown(units) (LONG) OF gle
   self.cp_y:=(self.cp_y)+(units*self.unitfactory)+(units*self.spacey)
   self.computeMaxCoords()
ENDPROC self.cp_y

PROC mRight(units) (LONG) OF gle
   self.cp_x:=(self.cp_x)+(units*self.unitfactorx)+(units*self.spacex)
   self.computeMaxCoords()
ENDPROC self.cp_x

PROC mUp(units) (LONG) OF gle
   self.cp_y:=(self.cp_y)-(units*self.unitfactory)-(units*self.spacey)
ENDPROC self.cp_y

PROC mLeft(units) (LONG) OF gle
   self.cp_x:=(self.cp_x)-(units*self.unitfactorx)-(units*self.spacex)
ENDPROC self.cp_x


PROC setGuiStartXY(x, y) (LONG,LONG) OF gle
   self.gui_startx:=x
   self.gui_starty:=y
   self.computeMaxCoords()
ENDPROC x, y

PROC addGad(kind, id, hsize, vsize, text=NIL, tags=NIL) (PTR TO gadget) OF gle
   IF hsize = -1 THEN hsize := StrLen(text)
   self.newgad.gadgetid:=id
   self.newgad.width:=(hsize*self.unitfactorx)+((hsize-1)*self.spacex)
   self.newgad.height:=(vsize*self.unitfactory)+((vsize-1)*self.spacey)
   self.newgad.leftedge:=self.cp_x
   self.newgad.topedge:=self.cp_y
   self.newgad.gadgettext:=text
   self.newgad.userdata:=kind ->990526,000514
   self.gadptr:=CreateGadgetA(kind, self.gadptr,
                             self.newgad,tags)
   self.cp_x := self.cp_x + self.newgad.width + self.spacex
   self.cp_y := self.cp_y + self.newgad.height + self.spacey
   self.computeMaxCoords()
   IF self.gpa<>NIL THEN self.gpa[id]:=self.gadptr
   IF self.gadplacing = GP_RIGHT THEN self.mUp(vsize)
   IF self.gadplacing = GP_UNDER THEN self.mLeft(hsize)
   #ifdef DEBUG
   WriteF('gle.addGad() : created gad with id \d\n', id)
   #endif
ENDPROC self.gadptr

/* internal */
PRIVATE PROC computeMaxCoords() (VOID) OF gle
   self.gui_maxx:=Max(self.cp_x, self.gui_maxx)
   self.gui_maxy:=Max(self.cp_y, self.gui_maxy)
ENDPROC

PROC getCpX() (LONG) OF gle IS self.cp_x

PROC getCpY() (LONG) OF gle IS self.cp_y

PROC getMaxX() (LONG) OF gle IS self.gui_maxx

PROC getMaxY() (LONG) OF gle IS self.gui_maxy

PROC gadTextAttr(textattr) (VOID) OF gle
   self.newgad.textattr:=textattr
ENDPROC

PROC getGList() (ANY) OF gle IS self.glist

->added 990523-----------------------

PROC gadFlags(flags) (VOID) OF gle
   self.newgad.flags:=flags
ENDPROC

EXPORT PROC pixPerChar(screen:PTR TO screen) (LONG)
   DEF testtext, pixperchar
   testtext:='abcdefghijklmnopqrstuvwxyzåäö' +
             'ABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ' +
             '123456789'
   pixperchar:=TextLength(screen.rastport,testtext,67)
   pixperchar:=pixperchar/60
ENDPROC pixperchar

EXPORT PROC copyIMessage(msg:PTR TO intuimessage, imsgcpy:PTR TO intuimessage) (PTR TO intuimessage)
   imsgcpy.code:=msg.code
   imsgcpy.qualifier:=msg.qualifier
   imsgcpy.iaddress:=msg.iaddress
   imsgcpy.class:=msg.class
   imsgcpy.mousex:=msg.mousex
   imsgcpy.mousey:=msg.mousey
ENDPROC imsgcpy



PROC place(xunit, yunit) (VOID) OF gle
   self.mSX()
   self.mSY()
   self.mRight(xunit)
   self.mDown(yunit)
ENDPROC

/* These two has nothing to do with gad creation.. */
/* just nice to have when ya wanna get/set gadgets later.. */
PROC setGad(gadid, attr) (ANY) OF gle
   DEF kind, tag, gad:PTR TO gadget
   gad := self.gpa[gadid]
   kind:=gad.userdata
   SELECT kind
   CASE CHECKBOX_KIND
      tag:=GTCB_CHECKED
   CASE CYCLE_KIND
      tag:=GTCY_ACTIVE
   CASE INTEGER_KIND
      tag:=GTIN_NUMBER
   CASE LISTVIEW_KIND
      tag:=GTLV_SELECTED
   CASE MX_KIND
      tag:=GTMX_ACTIVE
   CASE NUMBER_KIND
      tag:=GTNM_NUMBER
   CASE PALETTE_KIND
      tag:=GTPA_COLOR
   CASE SCROLLER_KIND
      tag:=GTSC_VISIBLE
   CASE SLIDER_KIND
      tag:=GTSL_LEVEL
   CASE STRING_KIND
      tag:=GTST_STRING
   CASE TEXT_KIND
      tag:=GTTX_TEXT
   DEFAULT
      RETURN NIL
   ENDSELECT
   GT_SetGadgetAttrsA(gad, self.window, NIL, [tag, attr, NIL])
ENDPROC attr

PROC getGad(gadid) (ANY) OF gle
   DEF kind, attr, tag, gad:PTR TO gadget
   gad := self.gpa[gadid]
   kind:=gad.userdata
   SELECT kind
   CASE CHECKBOX_KIND
      tag:=GTCB_CHECKED
   CASE CYCLE_KIND
      tag:=GTCY_ACTIVE
   CASE INTEGER_KIND
      tag:=GTIN_NUMBER
   CASE LISTVIEW_KIND
      tag:=GTLV_SELECTED
   CASE MX_KIND
      tag:=GTMX_ACTIVE
   CASE NUMBER_KIND
      tag:=GTNM_NUMBER
   CASE PALETTE_KIND
      tag:=GTPA_COLOR
   CASE SCROLLER_KIND
      tag:=GTSC_VISIBLE
   CASE SLIDER_KIND
      tag:=GTSL_LEVEL
   CASE STRING_KIND
      tag:=GTST_STRING
   CASE TEXT_KIND
      tag:=GTTX_TEXT
   DEFAULT
      RETURN NIL
   ENDSELECT
   GT_GetGadgetAttrsA(gad, self.window, NIL, [tag, {attr}, NIL])
ENDPROC attr



PROC placeXY(x, y) (LONG,LONG) OF gle
   self.cp_x:=(self.gui_startx) + x
   self.cp_y:=(self.gui_starty) + y
   self.computeMaxCoords()
ENDPROC x,y


/* the biggie... */

PROC buildA(tags) (VOID) OF gle
   DEF tag:PTR TO tagitem, ti_tag, lptr:PTR TO LONG, ti_data
   WHILE (tag:=NextTagItem({tags}) )
      ti_tag:=tag.tag
      ti_data:=tag.data
      lptr := ti_data
      SELECT ti_tag
      CASE GLE_SPACEXY
         self.spaceXY(lptr[0], lptr[1])
      CASE GLE_GADFLAGS
         self.gadFlags(ti_data)
      CASE GLE_UNITFACTORXY
         self.unitfactorXY(lptr[0], lptr[1])
      CASE GLE_MUP
         self.mUp(ti_data)
      CASE GLE_MDOWN
         self.mDown(ti_data)
      CASE GLE_MLEFT
         self.mLeft(ti_data)
      CASE GLE_MRIGHT
         self.mRight(ti_data)
      CASE GLE_ADDGAD
         self.addGad(lptr[0], lptr[1], lptr[2],
                         lptr[3], lptr[4], lptr[5])
      CASE GLE_SETGUISTARTXY
         self.setGuiStartXY(lptr[0], lptr[1])
      CASE GLE_PLACE
         self.place(lptr[0], lptr[1])
      CASE GLE_PLACEXY
         self.placeXY(lptr[0], lptr[1])
      CASE GLE_MSX
         self.mSX()
      CASE GLE_MSY
         self.mSY()
      CASE GLE_GADTEXTATTR
         self.gadTextAttr(ti_data)
      CASE GLE_PLACING
         self.placing(ti_data)
      ENDSELECT
   ENDWHILE
ENDPROC

PROC placing(placing) (VOID) OF gle
   self.gadplacing:=placing
ENDPROC


EXPORT PROC findGad(first:PTR TO gadget, id) (PTR TO gadget)
   WHILE first <> NIL
      IF first.gadgetid = id THEN RETURN first
      first := first.nextgadget
   ENDWHILE
ENDPROC NIL

-> 000513

PROC openWin(tags) (PTR TO window) OF gle
   self.window := OpenWindowTagList(NIL,
                     [WA_GADGETS,   self.glist,
                      WA_INNERWIDTH,  self.gui_maxx - 2,
                      WA_INNERHEIGHT, self.gui_maxy - self.winbordheight + 1,
                      ->WA_SIZEGADGET, FALSE,
                      WA_PUBSCREEN, self.screen,
                      TAG_MORE, tags,
                      NIL])
   IF self.window = NIL THEN Raise(GLE_ERR_WIN)
   #ifdef DEBUG
   WriteF('gle.openWin() : successful opening\n')
   #endif
ENDPROC self.window

PROC getWin() (PTR TO window) OF gle IS self.window


-> 000514 : handles gad-evnets. E-ONLY!
PROC eHandleEvent(imsgcpy:PTR TO intuimessage) (VOID) OF gle
   DEF gad:PTR TO gadget, proc, gadval
   gad := imsgcpy.iaddress
   proc := self.ppa[gad.gadgetid]
   gadval := self.getGad(gad.gadgetid)
   IF proc THEN proc(self, gad, gadval)
ENDPROC

PROC eEventHandler(proc, gadid) (VOID) OF gle
   IF self.ppa THEN self.ppa[gadid] := proc -> add handler
ENDPROC

/* Swedish Doc...

->initiering ..gpa=gadptrarray som e allokerad, kan vara NIL.
gle:=gle_init(screen, gpa)

->fria resurser (antagligen vid programslut)
gle_quit(gle)

->sätt mellanrum mellan gadgets
xspace, yspace:=gle_setspace( xspace, yspace)

->sätt 'teckenstorlek'
wf, hf:=gle_setgadsizefactor( wf, hf)

->förflytta 'markören'
cpx:=gle_mleft(gle ,wval)
cpx:=gle_mright( wval)
cpy:=gle_mdown( hval)
cpy:=gle_mup( hval)
sx:=gle_msx(gle)
sy:=gle_msy(gle)

->x och y för gle_msx/y
gle_setstartxy( x, y)

->addera en gad till gadlisten
gad:=gle_addgad( kind, id, wval, hval, gadtxt, flags, tags)

->sätt fonten till nåt annat än standard.
gle_settextattr( textattr)

->hämta hittils största x och y värde för markören.
x:=gle_getmaxx(gle)
y:=gle_getmaxy(gle)

->hämta gadlisten (antagligen till fönsteröppningen)
gadlist:=gle_getglist(gle)

->hämta nuvarande markörs xy-position
x:=gle_getcpx(gle)
y:=gle_getcpy(gle)


*/

