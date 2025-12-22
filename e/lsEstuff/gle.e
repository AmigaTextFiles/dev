OPT MODULE
/* 990719 FINALLY :) made it a class !! ..990804 */

/* very nice class if u dont like GUIengines
   that place the gads by them self. much/easy
   control over the layout.
   It just builds up a gadgetlist!
   No resizeing or such stuff!
   Its automatically font sensitive!
*/

MODULE 'intuition/screens', 'gadtools', 'libraries/gadtools',
       'intuition/intuition', 'utility', 'utility/tagitem'

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


EXPORT OBJECT gle ->buildgadgetlist - data
   PRIVATE
   glist:PTR TO gadget      -> hämta med getglist(gle)
   gpa:PTR TO LONG     ->adress till array av gadpekare.
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
                   -> nåt annat av PlacePix() eller
                   ->tableft/tabup! bla..

   spacex:CHAR     -> mellanrum mellan gadgets vertikalt
   spacey:CHAR     ->         (i pixels)       horisontellt
   ->gadkind:LONG ->the usual..
   ->gadtags:LONG
   gadplacing:INT ->GP_RIGHT, GP_UNDER
   error:LONG
ENDOBJECT

DEF utilitybase, gadtoolsbase

ENUM ER_NONE, ER_VINFO, ER_CCT, ER_UTILLIB, ER_GTLIB


RAISE ER_VINFO IF GetVisualInfoA()=NIL,
      ER_CCT IF CreateContext()=NIL


PROC gle(screen, gpa) OF gle  HANDLE
   DEF glist=NIL
   utilitybase:=OpenLibrary('utility.library', 37)
   IF utilitybase=NIL THEN Raise(ER_UTILLIB)
   gadtoolsbase:=OpenLibrary('gadtools.library', 37)
   IF gadtoolsbase=NIL THEN Raise(ER_GTLIB)
   self.newgad.visualinfo:=GetVisualInfoA(screen,NIL)
   self.gadptr:=CreateContext({glist})
   self.glist:=glist
   self.gpa:=gpa
EXCEPT
SELECT exception
CASE ER_VINFO
   RETURN 'GetVisualInfo()'
CASE ER_CCT
   RETURN 'CreateContext()'
CASE ER_UTILLIB
   RETURN 'utility.library'
CASE ER_GTLIB
   RETURN 'gadtools.library'
ENDSELECT
self.end()
ENDPROC NIL

PROC end() OF gle
   IF self.newgad.visualinfo THEN FreeVisualInfo(self.newgad.visualinfo)
   IF self.glist THEN FreeGadgets(self.glist)
   IF utilitybase THEN CloseLibrary(utilitybase)
   IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
ENDPROC


PROC spaceXY(xspace, yspace) OF gle
   self.spacex:=xspace
   self.spacey:=yspace
ENDPROC xspace, yspace

PROC unitFactorXY(xval, yval) OF gle
   self.unitfactorx:=xval
   self.unitfactory:=yval
ENDPROC xval, yval

PROC mSX() OF gle
   self.cp_x:=self.gui_startx
ENDPROC self.cp_x

PROC mSY() OF gle
   self.cp_y:=self.gui_starty
ENDPROC self.cp_y

PROC mDown(units) OF gle
   self.cp_y:=(self.cp_y)+(units*self.unitfactory)+(units*self.spacey)
ENDPROC self.cp_y

PROC mRight(units) OF gle
   self.cp_x:=(self.cp_x)+(units*self.unitfactorx)+(units*self.spacex)
ENDPROC self.cp_x

PROC mUp(units) OF gle
   self.cp_y:=(self.cp_y)-(units*self.unitfactory)-(units*self.spacey)
ENDPROC self.cp_y

PROC mLeft(units) OF gle
   self.cp_x:=(self.cp_x)-(units*self.unitfactorx)-(units*self.spacex)
ENDPROC self.cp_x


PROC setGUIStartXY(x, y) OF gle
   self.gui_startx:=x
   self.gui_starty:=y
ENDPROC x, y

PROC addGad(kind, id, hsize, vsize, text, tags) OF gle
   self.newgad.gadgetid:=id
   self.newgad.width:=(hsize*self.unitfactorx)+((hsize-1)*self.spacex)
   self.newgad.height:=(vsize*self.unitfactory)+((vsize-1)*self.spacey)
   self.newgad.leftedge:=self.cp_x
   self.newgad.topedge:=self.cp_y
   self.newgad.gadgettext:=text
   self.gadptr:=CreateGadgetA(kind, self.gadptr,
                             self.newgad,tags)
   self.cp_x:=(self.cp_x)+(self.newgad.width)+self.spacex
   self.cp_y:=(self.cp_y)+(self.newgad.height)+self.spacey
   self.gui_maxx:=Max(self.cp_x, self.gui_maxx)
   self.gui_maxy:=Max(self.cp_y, self.gui_maxy)
   IF self.gpa<>NIL THEN self.gpa[id]:=self.gadptr
   self.gadptr.userdata:=kind ->990526
   IF (self.gadplacing = GP_RIGHT) THEN self.mUp(vsize)
   IF (self.gadplacing = GP_UNDER) THEN self.mLeft(hsize)
ENDPROC self.gadptr


PROC getCpX() OF gle IS self.cp_x

PROC getCpY() OF gle IS self.cp_y

PROC getMaxX() OF gle IS self.gui_maxx

PROC getMaxY() OF gle IS self.gui_maxy

PROC gadTextAttr(textattr) OF gle
   self.newgad.textattr:=textattr
ENDPROC

PROC getGList() OF gle IS self.glist

->added 990523-----------------------

PROC gadFlags(flags) OF gle
   self.newgad.flags:=flags
ENDPROC

EXPORT PROC pixPerChar(screen:PTR TO screen)
   DEF testtext, pixperchar
   testtext:='abcdefghijklmnopqrstuvwxyzåäö' +
             'ABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ' +
             '123456789'
   pixperchar:=TextLength(screen.rastport,testtext,67)
   pixperchar:=pixperchar/60
ENDPROC pixperchar

EXPORT PROC copyIMessage(msg:PTR TO intuimessage, imsgcpy:PTR TO intuimessage)
   imsgcpy.code:=msg.code
   imsgcpy.qualifier:=msg.qualifier
   imsgcpy.iaddress:=msg.iaddress
   imsgcpy.class:=msg.class
   imsgcpy.mousex:=msg.mousex
   imsgcpy.mousey:=msg.mousey
ENDPROC

PROC getWinInnerWidth(wnd:PTR TO window) OF gle
   DEF iw
   iw:=wnd.width
   iw:=iw - wnd.borderleft
   iw:=iw - wnd.borderright
   iw:=iw - ((self.spacex) * 2)
ENDPROC iw

PROC getWinInnerHeight(wnd:PTR TO window) OF gle
   DEF ih
   ih:=wnd.height
   ih:=ih - wnd.bordertop
   ih:=ih - wnd.borderbottom
   ih:=ih - ((self.spacey) * 2)
ENDPROC ih

PROC sniffWin(wnd:PTR TO window) OF gle
   self.setGUIStartXY((self.spacex) + wnd.borderleft,
                       (self.spacey) + wnd.bordertop)
ENDPROC

/* du your gadgetcreations here..*/
/* addgad,,bla,,etc... */

PROC finWin(wnd:PTR TO window) OF gle
   DEF width, height
   width:=self.getMaxX() + (self.spacex) + wnd.borderright
   height:=self.getMaxY() + (self.spacey) + wnd.borderbottom
   ChangeWindowBox(wnd, wnd.leftedge,
                        wnd.topedge,
                        width, height)
   Delay(5)
   AddGList(wnd, self.getGList(), -1, -1, NIL)
   RefreshGList(self.getGList(), wnd, NIL, -1)
   Gt_RefreshWindow(wnd, NIL)
ENDPROC


PROC place(xunit, yunit) OF gle
   self.mSX()
   self.mSY()
   self.mRight(xunit)
   self.mDown(yunit)
ENDPROC

/* These two has nothing to do with gad creation.. */
/* just nice to have when ya wanna get/set gadgets later.. */
EXPORT PROC setGad(gad:PTR TO gadget, wnd, attr)
   DEF kind, tag
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
   ENDSELECT
   Gt_SetGadgetAttrsA(gad, wnd, NIL, [tag, attr, NIL])
ENDPROC attr

EXPORT PROC getGad(gad:PTR TO gadget, wnd)
   DEF kind, attr, tag
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
   ENDSELECT
   Gt_GetGadgetAttrsA(gad, wnd, NIL, [tag, {attr}, NIL])
ENDPROC attr



PROC placeXY(x, y) OF gle
   self.cp_x:=(self.gui_startx) + x
   self.cp_y:=(self.gui_starty) + y
ENDPROC


/* the biggie... */

PROC buildA(tags) OF gle
   DEF tag:PTR TO tagitem, ti_tag, lptr:PTR TO LONG, ti_data
   WHILE (tag:=NextTagItem({tags}) )
      ti_tag:=tag.tag
      ti_data:=tag.data
      SELECT ti_tag
      CASE GLE_SPACEXY
         lptr:=ti_data
         self.spaceXY(lptr[0], lptr[1])
      CASE GLE_GADFLAGS
         self.gadFlags(ti_data)
      CASE GLE_UNITFACTORXY
         lptr:=ti_data
         self.unitFactorXY(lptr[0], lptr[1])
      CASE GLE_MUP
         self.mUp(ti_data)
      CASE GLE_MDOWN
         self.mDown(ti_data)
      CASE GLE_MLEFT
         self.mLeft(ti_data)
      CASE GLE_MRIGHT
         self.mRight(ti_data)
      CASE GLE_ADDGAD
         lptr:=ti_data
         self.addGad(lptr[0], lptr[1], lptr[2],
                         lptr[3], lptr[4], lptr[5])
      CASE GLE_SETGUISTARTXY
         lptr:=ti_data
         self.setGUIStartXY(lptr[0], lptr[1])
      CASE GLE_PLACE
         lptr:=ti_data
         self.place(lptr[0], lptr[1])
      CASE GLE_PLACEXY
         lptr:=ti_data
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

PROC placing(placing) OF gle
   self.gadplacing:=placing
ENDPROC


EXPORT PROC findGad(glist:PTR TO gadget, id)
   DEF first:PTR TO gadget
   first:=glist.nextgadget
   WHILE first <> NIL
      IF first.gadgetid = id THEN RETURN first
      first := first.nextgadget
   ENDWHILE
ENDPROC NIL

/* Swedish Doc...

->initiering ..gpa=gadptrarray som e allokerad, kan vara NIL.
gle:=init(screen, gpa)

->fria resurser (antagligen vid programslut)
quit(gle)

->sätt mellanrum mellan gadgets
xspace, yspace:=setspace(gle, xspace, yspace)

->sätt 'teckenstorlek'
wf, hf:=setgadsizefactor(gle, wf, hf)

->förflytta 'markören'
cpx:=mleft(gle ,wval)
cpx:=mright(gle, wval)
cpy:=mdown(gle, hval)
cpy:=mup(gle, hval)
sx:=msx(gle)
sy:=msy(gle)

->x och y för msx/y
setstartxy(gle, x, y)

->addera en gad till gadlisten
gad:=addgad(gle, kind, id, wval, hval, gadtxt, flags, tags)

->sätt fonten till nåt annat än standard.
settextattr(gle, textattr)

->hämta hittils största x och y värde för markören.
x:=getmaxx(gle)
y:=getmaxy(gle)

->hämta gadlisten (antagligen till fönsteröppningen)
gadlist:=getglist(gle)

->hämta nuvarande markörs xy-position
x:=getcpx(gle)
y:=getcpy(gle)


*/
