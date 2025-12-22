'GADTOOLS/GADGETS
'Benito Lombardi 1997
''''''''''''''''''
'COMPILER SETTINGS
''''''''''''''''''
REM $DYNAMIC
REM $NOWINDOW
REM $NOLIBRARY
REM $NOBREAK
REM $NOEVENT
REM $NOOVERFLOW
REM $NOVARCHECKS
REM $AUTODIM
REM $UNDERLINES
REM $NOADDICON
REM $ARRAY
REM $STACK
REM $JUMPS
REM $OPTION k 150
''''''''''
DEFINT a-z
'''''''''''''''
'INCLUDE FILES'
'''''''''''''''
'REM $include intuition.bh
'REM $include gadtools.bh
'REM $include graphics.bh
'REM $include exec.bh
'REM $include Blib/ExecSupport.bas
'REM $include utility.bh
'''''''''''
'LIBRARIES'
'''''''''''
LIBRARY "dos.library"
 DECLARE FUNCTION xClose& LIBRARY
 DECLARE FUNCTION Execute& LIBRARY
 DECLARE FUNCTION xOpen& LIBRARY
LIBRARY OPEN "exec.library"
LIBRARY OPEN "gadtools.library",37
LIBRARY OPEN "graphics.library",37
LIBRARY OPEN "intuition.library",37
nil_handle&= xOpen&(SADD("NIL:"+CHR$(0)),1005&)
''''''''''''''''''''''''
'MAIN SCREEN AND WINDOW'
''''''''''''''''''''''''
SCREEN 1,640,200,2,2
WINDOW 1,,(0,0)-(640,200),16+32+128+256,1
Busy.Pointer
Add1.IDCMPFlags
'''''''''''''''''''''''''''''''''''
'ARRAYS/GADGET VARIABLES/FONT/TAGS'
'''''''''''''''''''''''''''''''''''
CONST BUTTONKIND  = 1
CONST CHECKBOXKIND= 2
CONST INTEGERKIND = 3
CONST LISTVIEWKIND= 4
CONST MXKIND      = 5
CONST NUMBERKIND  = 6
CONST CYCLEKIND   = 7
CONST PALETTEKIND = 8
CONST SCROLLERKIND= 9
CONST SLIDERKIND  = 11
CONST STRINGKIND  = 12
CONST TEXTKIND    = 13
'-----
COMMON SHARED act.win&,b.ptr&,gid,rport&
DIM f_gads&(0),m_gads&(20),ng(NewGadget_sizeof\2)
DIM AGadgetTags&(10),GadgetTags&(20)
DIM SHARED c(27),label$(0),p(12),parm(14),txt$(14)
'-----
myscr&= LockPubScreen&(0&)
IF myscr&= 0 THEN
 Error.Trap 1
ELSE
	TAGLIST VARPTR(GadgetTags&(0)),TAG_DONE&
	vi&= GetVisualInfoA&(myscr&,VARPTR(GadgetTags&(0)))
 IF vi&= 0 THEN Error.Trap 2 ELSE POKEL VARPTR(ng(ng_visualInfo\2)),vi&
END IF
'-----
DIM topaz80(4)
Init.TextAttr topaz80(),"topaz.font",8,0,0
font&= OpenFont&(VARPTR(Topaz80(0)))
IF font&= 0 THEN Error.Trap 3
'-----
DIM fbox_tag&(20),rbox_tag&(20)
TAGLIST VARPTR(fbox_tag&(0)),GTBB_FrameType&,1,GT_VisualInfo&,vi&,TAG_DONE&
TAGLIST VARPTR(rbox_tag&(0)),GTBB_Recessed&,1,GT_VisualInfo&,vi&,TAG_DONE&
'-----
'
'''''''''
Main.Menu
'''''''''
'
''''''''''''''''''''
'PROGRAM SUBROUTINES
''''''''''''''''''''
SUB About.Text
STATIC i,j
'-------
WINDOW 2,,(84,23)-(471,175),8+32+128+256,1
WINDOW 2 :act.win&= WINDOW(7) :Add2.IDCMPFlags
SetPointer act.win&,b.ptr&,15&,15&,-7&,-7&
rport&= PEEKL(act.win&+rport)
'-------
f_gad&= 0& :f_list&= 0&
f_gad&= CreateContext&(VARPTR(f_list&))
'-------
c(0)= 40 :REDIM txt$(40)
RESTORE About_Text
FOR i= 0 TO 40 :READ txt$(i) :NEXT
Create.ViewList viewlist&,2
RESTORE ListView_About
'-------
FOR i= 0 TO 14 :parm(i)= 0 :NEXT
REDIM label$(1) :REDIM f_gads&(1)
FOR i= 0 TO 1
 FOR j= 0 TO 8 :READ parm(j) :NEXT :READ label$(i)
 Create.Gadgets f_gad&,f_list&,f_gads&()
NEXT
junk&= AddGList&(act.win&,f_gads&(0),-1&,-1&,0&)
GT_RefreshWindow act.win&,0&
RefreshGList f_gads&(0),act.win&,0&,-1&
'-------
Process.WindowEvents f_gads&()
'-------
WINDOW CLOSE 2
FreeGadgets f_list&
Free.ViewList	viewlist&
EXIT SUB
'-------
ListView_About:
DATA 0,6,212, 16, 12,0,1,0,0,""
DATA 1,6, 19,461,152,0,4,0,1,""
'-------
About_Text:
DATA ""
DATA " This program was written using an A2000 and requires"
DATA " an OS2+. It is FREEWARE and can be freely copied and"
DATA " distributed as long as no monetary gain is involved."
DATA " It is also provided  'as is'  without any express or"
DATA " implied guaranty."
DATA ""
DATA "The program appears to be free of bugs.... but if you"
DATA "experience any, please let me know; also, if you make"
DATA "any significant improvement in the code."
DATA ""
DATA "Credits and thanks are expressed to Nico Francois for"
DATA "LacePointer, and to Stieve Tibbet for the code of the"
DATA "Spinning Clock, which are both used in this program."
DATA ""
DATA "My original purpose was to attach GadTools Gadgets to"
DATA "GimmeZeroZero and Borderless Windows, opened with the"
DATA "HBasic2 WINDOW Command as in GADS.bas. My goal though"
DATA "fell quite short, because I was unable for example to"
DATA "implement properly  a ListView Gadget when it was the"
DATA "sole or very first gadget in the gadget list (see the"
DATA "ABOUT SUB). I had the same problem also with Mutually"
DATA "Exclusive and Scroller Gadgets. Another problem I met"
DATA "was a failure of the ListView and Scroller gadgets to"
DATA "respond to continous activation of their  arrows with"
DATA "the mouse.  Feeling that there must be proper ways to"
DATA "achieve all these features, I tried hard to solve the"
DATA "problems, but did not succeed. I would therefore like"
DATA "very much and appreciate it, to hear from anyone that"
DATA "know the solutions, or were the problems reside."
DATA ""
DATA "I met no difficulty to implement properly, apparently"
DATA "at least, all the gadgets, by including their list in"
DATA "the structure of a Window before opening it, as shown"
DATA "in WGADS.bas. I cosider this, however, to be a defeat"
DATA "of my original purpose and goal."
DATA ""
DATA "      Benito Lombardi"
DATA "      6632 5th Avenue, Pittsburgh, PA 15206. USA."
DATA "      email: <Lomb+@Pitt.edu>"
DATA ""
END SUB

SUB Close.Program (BYVAL et)
SHARED font&,myscr&,m_list&,nil_handle&,setpal,vi&
'-------------
SetPointer WINDOW(7),b.ptr&,15&,15&,-7&,-7&
IF setpal THEN Set.Palettes 2 
IF FEXISTS("CLIPS:file") THEN KILL "CLIPS:file"
IF FEXISTS("CLIPS:0") THEN KILL "CLIPS:0"
'-------------
Dos.Script ":HB2Gads/lacepointer"
FreeRaster b.ptr&,16&,34&
junk&= xClose&(nil_handle&)
'-------------
WINDOW CLOSE 1
SELECT CASE et
=0 :FreeGadgets m_list& :CloseFont font&
 FreeVisualInfo vi& :UnlockPubScreen 0&,myscr&
=1 :EXIT SELECT
=2 :UnlockPubScreen 0&,myscr& :EXIT SELECT
=3 :FreeVisualInfo vi& :UnlockPubScreen 0&,myscr& :EXIT SELECT
=4 :CloseFont font& :FreeVisualInfo vi& :UnlockPubScreen 0&,myscr&
 EXIT SELECT
END SELECT
SCREEN CLOSE 1
STOP
END SUB

SUB Create.File
SHARED check.click,imsgClass&
STATIC gadgets,i,j
'-------
Window.Two
Add1.IDCMPFlags
'-------
f_gad&= 0& :f_list&= 0&
f_gad&= CreateContext&(VARPTR(f_list&))
'-------
FOR i= 0 TO 14 :parm(i)= 0 :NEXT
RESTORE Create_File
REDIM f_gads&(7) :REDIM label$(7)
FOR i= 0 TO 7
	FOR j= 0 TO 8 :READ parm(j) :NEXT :READ label$(i)
 Create.Gadgets f_gad&,f_list&,f_gads&()
NEXT 
junk&= AddGList&(act.win&,f_gads&(0),-1&,-1&,0&)
GT_RefreshWindow act.win&,0&
RefreshGList f_gads&(0),act.win&,0&,-1& 
Print.Notes 4
Process.WindowEvents f_gads&()
'-------
IF gid= 7 THEN WINDOW CLOSE 2 :FreeGadgets f_list& :EXIT SUB
'-------
Set.Attribute GA_Disabled&,TRUE&,f_gads&(6)
Set.Attribute GA_Disabled&,TRUE&,f_gads&(7)
SetAPen rport&,0 :RectFill rport&,7&,154&,464&,167&
SetPointer act.win&,b.ptr&,0,0,0,0
'-------
check.click= -1
FOR i= 0 TO 5
 Activate_Gadgets:
 Set.Attribute GA_Disabled&,FALSE&,f_gads&(i)
 junk&= ActivateGadget&(f_gads&(i),act.win&,0&)
 Process.WindowEvents f_gads&()
 IF imsgClass&= 8 OR imsgClass&= 256 THEN Activate_Gadgets
NEXT
check.click= 0
'-------
FOR i= 0 TO 5 : Get.String txt$(i),f_gads&(i) :NEXT
'-------
junk&= RemoveGList&(act.win&,f_gads&(0),-1&)
o_list&= f_list&
SetRast rport&,0
'-------
f_gad&= 0& :f_list&= 0&
f_gad&= CreateContext&(VARPTR(f_list&))
'-------
parm(14)= 1 :RESTORE Created_File
REDIM f_gads&(7) :REDIM label$(7)
FOR i= 0 TO 7
	FOR j= 0 TO 8 :READ parm(j) :NEXT :READ label$(i)
 Create.Gadgets f_gad&,f_list&,f_gads&()
NEXT 
junk&= AddGList&(act.win&,f_gads&(0),-1&,-1&,0&)
GT_RefreshWindow act.win&,0&
RefreshGList f_gads&(0),act.win&,0&,-1&
Print.Notes 44
Process.WindowEvents f_gads&()
'-------
WINDOW CLOSE 2
FreeGadgets f_list&
FreeGadgets o_list&
OPEN "o",#1,"CLIPS:file"
 FOR i= 0 TO 5 :PRINT #1,txt$(i) :NEXT
CLOSE #1
FOR i= 0 TO 14: txt$(i)= "" :NEXT
EXIT SUB
'-------
Create_File:
DATA 0,221, 63,180,12,0,12,23,1,"Family Name"
DATA 1,221, 75,180,12,0,12,23,1,"Inits & First Name"
DATA 2,221, 87,180,12,0,12,23,1,"Street Address"
DATA 3,221, 99,180,12,0,12,23,1,"City"
DATA 4,221,111,180,12,0,12,23,1,"State/Zip Code"
DATA 5,221,123,180,12,0,12,23,1,"Telephone #"
DATA 6,  8,155, 44,12,0, 1, 0,0,"_O k"
DATA 7,392,155, 72,12,0, 1, 0,0,"_Cancel"
'-------
Created_File:
DATA 0,221, 63,180,12,6,13,23,0,"Family Name:"
DATA 1,221, 75,180,12,6,13,23,0,"Inits & First Name:"
DATA 2,221, 87,180,12,6,13,23,0,"Street Address:"
DATA 3,221, 99,180,12,6,13,23,0,"City:"
DATA 4,221,111,180,12,6,13,23,0,"State/Zip Code:"
DATA 5,221,123,180,12,6,13,23,0,"Telephone #:"
DATA 6,  8,155, 44,12,0, 1, 0,0,"_O K"
DATA 7,421,155, 44,12,0, 1, 0,0,"_O K"
END SUB

SUB Edit.File
SHARED check.click
STATIC gadgets,i,j
'----
IF FEXISTS("CLIPS:file") THEN
 OPEN "i",#1,"CLIPS:file" :FOR i= 0 TO 5 :INPUT #1,txt$(i) :NEXT :CLOSE #1
ELSE
 EXIT SUB
END IF
'----
Window.Two
Add1.IDCMPFlags
'----
f_gad&= 0& :f_list&= 0&
f_gad&= CreateContext&(VARPTR(f_list&))
'----
FOR i= 0 TO 14 :parm(i)= 0 :NEXT :parm(13)= 1
RESTORE Create_File
REDIM f_gads&(5) :REDIM label$(5)
FOR i= 0 TO 5
	FOR j= 0 TO 8 :READ parm(j) :NEXT :parm(8)= 0 :READ label$(i)
 Create.Gadgets f_gad&,f_list&,f_gads&()
NEXT
junk&= AddGList&(act.win&,f_gads&(0),-1&,-1&,0&)
GT_RefreshWindow act.win&,0&
RefreshGList f_gads&(0),act.win&,0&,-1&
Print.Notes 3
check.click= -1
'----
Process.WindowEvents f_gads&()
'----
Raw.Key
check.click= 0
'----
FOR i= 0 TO 5 :Get.String txt$(i),f_gads&(i) :NEXT
'----
junk&= RemoveGList&(act.win&,f_gads&(0),-1&)
o_list&= f_list&
SetRast rport&,0
'----
f_gad&= 0& :f_list&= 0&
f_gad&= CreateContext&(VARPTR(f_list&))
'----
parm(14)= 1 :RESTORE Created_File
REDIM f_gads&(7) :REDIM label$(7)
FOR i= 0 TO 7
	FOR j= 0 TO 8 :READ parm(j) :NEXT :READ label$(i)
	IF i< 6 THEN parm(8)= 1 ELSE parm(8)= 0
 Create.Gadgets f_gad&,f_list&,f_gads&()
NEXT 
junk&= AddGList&(act.win&,f_gads&(0),-1&,-1&,0&)
GT_RefreshWindow act.win&,0&
RefreshGList f_gads&(0),act.win&,0&,-1&
Print.Notes 33
Process.WindowEvents f_gads&()
'----
WINDOW CLOSE 2
FreeGadgets f_list&
FreeGadgets o_list&
OPEN "o",#1,"CLIPS:file"
 FOR i= 0 TO 5 :PRINT #1,txt$(i) :NEXT
CLOSE #1
FOR i= 0 TO 14: txt$(i)= "" :NEXT
END SUB

SUB Main.Menu
SHARED m_list&
STATIC i,j
'---
Bevel.Boxes 0
'---
m_gad&= 0& :m_list&= 0&
m_gad&= CreateContext&(VARPTR(m_list&))
'---
parm(4)= 14 :parm(5)= 0 :parm(6)= 1
FOR i= 7 TO 14 :parm(i)= 0 :NEXT
RESTORE Main_Options
REDIM label$(16) :REDIM m_gads&(16)
FOR i= 0 TO 16 :parm(0)= i
 FOR j= 1 TO 3 :READ parm(j) :NEXT :READ label$(i)
 Create.Gadgets m_gad&,m_list&,m_gads&()
NEXT
'---
junk&= AddGList&(WINDOW(7),m_gads&(0),-1&,-1&,0&)
GT_RefreshWindow WINDOW(7),0&
RefreshGList m_gads&(0),WINDOW(7),0&,-1&
'-
DO
 WINDOW 1 :act.win&= WINDOW(7)
 Process.WindowEvents m_gads&()
 SELECT CASE gid
 = 1 :Palette.Editor
 = 2 :Text.Display
 = 3 :Edit.File
 = 4 :Create.File
 =13 :Close.Program et
 =14 :About.Text
 =REMAINDER :Set.Gadgets
 END SELECT		
 RESTORE Main_Labels :REDIM label$(16)
 FOR i= 0 TO 16 :READ label$(i) :NEXT
LOOP
EXIT SUB
'---
Main_Options:
DATA 148,140,168,"_MX Cycle (SH)"
DATA 324,140,168,"Palette _Editor"
DATA 324,122,168,"Te_xt Display"
DATA 236,122,80,"St_ring"
DATA 148,122,80,"S_tring"
DATA 148,104,80,"Sli_der"
DATA 236,104,80,"S_croller"
DATA 324,104,80,"_Palette"
DATA 412,104,80,"_String"
DATA 412, 86,80,"Listvie_w"
DATA 324, 86,80,"Listvi_ew"
DATA 236, 86,80,"List_view"
DATA 148, 86,80,"_Listview"
DATA 148, 68,80,"_Q u i t"
DATA 236, 68,80,"_About"
DATA 324, 68,80,"Chec_kbox"
DATA 412, 68,80,"_Integer"
'---
Main_Labels:
DATA "_MX Cycle (SH)","Palette _Editor","Te_xt Display","St_ring"
DATA "S_tring","Sli_der","S_croller","_Palette","_String"
DATA "Listvie_w","Listvi_ew","List_view","_Listview"
DATA "_Q u i t","_About","Chec_kbox","_Integer"
END SUB

SUB Palette.Editor
SHARED setpal
STATIC gadgets,i,j,palset
'-------
Window.Two
Add2.IDCMPFlags
'-------
IF palset= 0 THEN palset= 1 :Set.Palettes 0
'-------
f_gad&= 0& :f_list&= 0&
f_gad&= CreateContext&(VARPTR(f_list&))
'-------
FOR i= 0 TO 14 :parm(i)= 0 :NEXT
RESTORE Palette_Editor
REDIM f_gads&(5) :REDIM label$(5)
FOR i= 0 TO 5
	FOR j= 0 TO 13 :READ parm(j) :NEXT :READ label$(i)
 Create.Gadgets f_gad&,f_list&,f_gads&()
NEXT 
junk&= AddGList&(act.win&,f_gads&(0),-1&,-1&,0&)
GT_RefreshWindow act.win&,0&
RefreshGList f_gads&(0),act.win&,0&,-1&
Print.Notes 1
Process.WindowEvents f_gads&()
'-------
IF gid= 0 THEN setpal= 0 :palset= 0 :p(12)= 0 :Set.Palettes 2
WINDOW CLOSE 2
FreeGadgets f_list&
EXIT SUB
'-------
Palette_Editor:
DATA 0,262,141, 56,12,0, 1,0, 0,0, 0,0,0,0,"_Cancel"
DATA 1,139,141, 56,12,0, 1,0, 0,0, 0,0,0,0,"_Use"
DATA 2,177, 72,181,12,0,11,0,15,0, 1,1,1,1,"Red:   "
DATA 3,177, 88,181,12,0,11,0,15,0, 1,1,1,1,"Green:   "
DATA 4,177,104,181,12,0,11,0,15,0, 1,1,1,1,"Blue:   "
DATA 5,111, 48,249,20,0, 8,2, 0,0,40,0,0,0,""
END SUB

SUB Set.Gadgets
SHARED cy$(),cyi$(),mx$(),mxi$(),shi1$(),shi2$()
STATIC gadgets,i,j
'---
Window.Two
Add2.IDCMPFlags
'---
f_gad&= 0& :f_list&= 0&
f_gad&= CreateContext&(VARPTR(f_list&))
'---
which= gid :parm= 8
FOR i= 0 TO 14 :parm(i)= 0 :NEXT
'---
REDIM label$(1) :REDIM f_gads&(1) :RESTORE Button_Gads
FOR i= 0 TO 1
 FOR j= 0 TO parm :READ parm(j) :NEXT :READ label$(i)
 Create.Gadgets f_gad&,f_list&,f_gads&()
NEXT
'---
SELECT CASE which
=0 :String.Array mx$(),mxi$(),0 :String.Array cy$(),cyi$(),1
 String.Array sh1$(),shi1$(),2 :String.Array sh2$(),shi2$(),3
 parm= 7 :parm(11)= 3 :RESTORE MXCySH_Gads
=5 :parm= 13 :RESTORE Slider_Gads
=6 :parm= 13 :RESTORE Scroller_Gads
=7 :parm= 11 :RESTORE Palette_Gads
=8 :parm= 11 :RESTORE String_Gads
=9 :c(0)= 14 :Create.ViewList viewlist&,0
 RESTORE ListView_Gads1
=10 :c(0)= 8 :Create.ViewList viewlist&,0
 parm= 7 :RESTORE ListView_Gads2
=11: c(0)= 9 :Create.ViewList viewlist&,0
 parm= 6 :RESTORE ListView_Gads3
=12 :c(0)= 10 :Create.ViewList viewlist&,0
 RESTORE ListView_Gads4
=15 :parm= 6 :RESTORE CheckBox_Gads
=16 :String.Array mx$(),mxi$(),4
 parm= 12 :RESTORE Integer_Gads
END SELECT
'---
READ gadgets
REDIM PRESERVE label$(gadgets) :REDIM PRESERVE f_gads&(gadgets)
FOR i= 2 TO gadgets
 FOR j= 0 TO parm :READ parm(j) :NEXT :READ label$(i)
 Create.Gadgets f_gad&,f_list&,f_gads&()
NEXT
junk&= AddGList&(act.win&,f_gads&(0),-1&,-1&,0&)
GT_RefreshWindow act.win&,0&
RefreshGList f_gads&(0),act.win&,0&,-1&
Print.Notes which
'---
Process.WindowEvents f_gads&()
'---
WINDOW CLOSE 2
FreeGadgets f_list&
SELECT CASE which
=0 :ERASE cy$,cyi$,mx$,mxi$,sh1$,shi1$,sh2$,shi2$
=9,10,11,12 :Free.ViewList	viewlist&
 IF FEXISTS("CLIPS:list") THEN KILL "CLIPS:list"
=16 :ERASE mx$,mxi$
END SELECT
FOR i= 0 TO 14: txt$(i)= "" :NEXT
EXIT SUB
'---
Button_Gads:
DATA 0,  8,155,44,12,0,1,0,0,"_O K"
DATA 1,421,155,44,12,0,1,0,0,"_O K"
'---
MXCySH_Gads:
DATA 8
DATA 2,321, 77, 0, 0,2, 5,0,"_D"
DATA 3,151, 76,72,12,0, 7,0,"_Cycle"
DATA 4,151, 92,72,12,0,12,4,"(SH)1"
DATA 5,151,108,72,12,0,12,4,"(SH)2"
DATA 6,118,155,40,12,6,13,0,"Added:"
DATA 7,236,155,40,12,6,13,0,"Result:"
DATA 8,370,155,40,12,6,13,0,"Selected:"
'---
Slider_Gads:
DATA 11
DATA  2,171, 43,200, 12,0,11, 0, 99, 0,0,1,1,1,""
DATA  3,171, 59,200, 12,0,11, 0, 99, 0,0,1,1,1,"S_lider"
DATA  4,171, 75,200, 12,0,11, 0, 49, 0,2,1,1,1,"Sl_ider"
DATA  5,171, 91,200, 12,0,11,50, 99,50,1,1,1,1,"Sli_der:   "
DATA  6,171,107,200, 12,0,11,50,149,50,1,1,1,1,"Slid_er:    "
DATA  7,171,135,200, 12,0,11,50,149,50,4,1,1,1,"Slide_r"
DATA  8, 20, 43, 24, 95,0,11,50, 99,50,8,1,1,2,"_S"
DATA  9,428, 43, 24,104,0,11, 0, 49, 0,4,1,1,2,""
DATA 10,151,155, 40, 12,6,13, 0,  0, 0,0,0,0,0,"Result:"
DATA 11,345,155, 40, 12,6,13, 0,  0, 0,0,0,0,0,"Selected:"
'---
Scroller_Gads:
DATA 5
DATA 2,  8,124,430, 10,0,9,1,593,198,12,0,0,1,""
DATA 3,  8,134,430, 10,0,9,1,593,198, 0,0,0,1,""
DATA 4,420, 40, 18, 83,0,9,1,239, 80, 8,0,0,2,""
DATA 5,439, 40, 18,104,0,9,1,239, 80, 0,0,0,2,""
'---
Palette_Gads:
DATA 8
DATA 2, 52, 47,100,12,3, 8, 2,1,0, 0, 0,"One"
DATA 3, 52, 63,100,15,2, 8, 2,2,0,48, 0,"Two"
DATA 4, 52, 95,100,28,4, 8, 2,1,0, 0,12,"_Three"
DATA 5,229, 47, 66,79,0, 8, 2,3,0,31, 0,"_Five"
DATA 6,326, 47, 31,79,4, 8, 2,1,0, 0, 0,"Four"
DATA 7,384, 47, 31,75,3, 8, 2,0,0, 0,15,"Six"
DATA 8,182,155, 40,12,2,13,12,0,0, 0, 0,"Selected"
'---
String_Gads:
DATA 7
DATA 2, 96, 71,116,12,0,12,12,0,0,0,0,"Input1"
DATA 3,314, 71,116,12,0,12,12,0,1,0,0,"_Input2"
DATA 4, 96, 87,116,12,0,12,12,0,0,1,1,"I_nput3"
DATA 5,314, 87,116,12,0,12,12,0,2,0,1,"Input4"
DATA 6,146,103,232,12,6,12,24,0,0,0,0,"_Edit"
DATA 7,146,119,232,12,6,13,24,1,0,0,0,"Result"
'---
ListView_Gads1:
DATA 4
DATA 2, 76,43,120,20,0,4,0,1,"_Lines"
DATA 3, 76,99,120,40,0,4,0,1,"Li_nes"
DATA 4,272,43,120,96,0,4,0,1,"Line_s"
'---
ListView_Gads2:
DATA 3
DATA 2,  0, 0,120,12,0,12,10," "
DATA 3,174,71,120,48,0, 4, 0,"Lines"
'---
ListView_Gads3:
DATA 3
DATA 2, 80,71,120,48,4,4,"Lines"
DATA 3,272,71,120,48,0,4,"_Lines"
'---
ListView_Gads4:
DATA 4
DATA 2, 80, 71,120,48,0, 4,0,0,"Lines"
DATA 3,272, 71,120,48,4, 4,0,0,"_Lines"
DATA 4,217,155,120,12,6,13,0,1,"Selected:"
'---
CheckBox_Gads:
DATA 6
DATA 2,388,58,0,0,0,2,"High"
DATA 3,388,74,0,0,0,2,"Medium"
DATA 4,388,90,0,0,0,2,"Low"
DATA 5,114,58,0,0,0,2,"Loader"
DATA 6,114,90,0,0,0,2,"Percent"
'---
Integer_Gads:
DATA 8
DATA 2,160, 75,100,12,0,3,10,0,10,0,0,1,"Int1"
DATA 3,160, 91,100,12,0,3,10,0,10,0,0,2,"_Int2"
DATA 4,160,107,100,12,0,3,10,0,10,0,1,1,"I_nt3"
DATA 5,160,123,100,12,0,3,10,0,10,0,1,1,"Int4"
DATA 6,126,155,100,12,6,6, 0,0, 0,1,0,0,"Input:"
DATA 7,310,155,100,12,6,6, 0,0, 0,0,0,0,"Result:"
DATA 8,333, 75,  0, 0,0,5, 0,0, 0,0,8,0,"Ops"
'---
END SUB

SUB Text.Display
SHARED check.click
STATIC gadgets,i,j
'---
Window.Two
Add1.IDCMPFlags
'---
f_gad&= 0& :f_list&= 0&
f_gad&= CreateContext&(VARPTR(f_list&))
'---
RESTORE About_Text :txt$= "" 
FOR i= 0 TO 14 :READ txt$(5) :txt$= txt$+txt$(5)+" " :NEXT
txt$= LTRIM$(RTRIM$(txt$)) :txt$= txt$+" "
WHILE INSTR(txt$,"  ") >0
 t= INSTR(txt$,"  ")
 txt$= LEFT$(txt$,t-1)+MID$(txt$,t+1)
WEND :txt$(5)= LEFT$(txt$,49)
'---
FOR i= 0 TO 14 :parm(i)= 0 :NEXT :parm(14)= 1
REDIM label$(5) :REDIM f_gads&(5) :RESTORE Text_Gads
FOR i= 0 TO 5
 FOR j= 0 TO 13 :READ parm(j) :NEXT :READ label$(i)
 Create.Gadgets f_gad&,f_list&,f_gads&()
NEXT
junk&= AddGList&(act.win&,f_gads&(0),-1&,-1&,0&)
GT_RefreshWindow act.win&,0&
RefreshGList f_gads&(0),act.win&,0&,-1&
'---
Set.Attribute GTTX_Text&,SADD(txt$(5)+CHR$(0)),f_gads&(5)
Print.Notes 2 :check.click= -1
Process.WindowEvents f_gads&()
'---
IF gid= 3 THEN Bail_Out
'---
Once_Again:
'---
Set.Attribute GA_Disabled&,TRUE&,f_gads&(0)
Set.Attribute GA_Disabled&,TRUE&,f_gads&(3)
Set.Attribute GA_Disabled&,FALSE&,f_gads&(1)
Set.Attribute GA_Disabled&,FALSE&,f_gads&(2)
Set.Attribute GA_Disabled&,FALSE&,f_gads&(4)
'---
i= 0 :l= LEN(txt$) :pause= 0
WHILE i< l
 Set_Pause:
 '--
 IF pause THEN
  junk&= xWait&(1& << PEEKB(PEEKL(act.win&+UserPort)+mp_SigBit))
 END IF
 imsg&= GT_GetIMsg&(PEEKL(act.win&+UserPort))
 gad&= PEEKL(imsg&+IAddress)
 code= PEEKW(imsg&+IntuiMessageCode)
 GT_ReplyIMsg imsg&
 gid= PEEKW(gad&+gadgetgadgetid)
 '--
 IF gid= 1 THEN
  IF pause= 0 THEN DECR pause ELSE INCR pause
  IF pause THEN GOTO Set_Pause ELSE EXIT IF
 ELSEIF gid= 2 THEN
  EXIT WHILE
	ELSEIF gid= 4 THEN c(0)= code
 END IF
 '--
 junk&= ActivateGadget&(f_gads&(5),act.win&,0&)
 INCR i :txt$(5)= MID$(txt$,i,49)
 Set.Attribute GTTX_Text&,SADD(""+CHR$(0)),f_gads&(5)
 Set.Attribute GTTX_Text&,SADD(txt$(5)+CHR$(0)),f_gads&(5)
 Delay c(0)
WEND
'---
Set.Attribute GA_Disabled&,FALSE&,f_gads&(0)
Set.Attribute GA_Disabled&,FALSE&,f_gads&(3)
Set.Attribute GA_Disabled&,TRUE&,f_gads&(1)
Set.Attribute GA_Disabled&,TRUE&,f_gads&(2)
Set.Attribute GA_Disabled&,TRUE&,f_gads&(4)
'---
Process.WindowEvents f_gads&()
IF gid= 0 THEN 
 Set.Attribute GTTX_Text&,SADD(""+CHR$(0)),f_gads&(5)
 GOTO Once_Again
END IF
'---
Bail_Out:
check.click= 0
WINDOW CLOSE 2
FreeGadgets f_list&
EXIT SUB
'---
Text_Gads:
DATA 0,  8,155, 96,12,0, 1, 0, 0, 0,0,0,0,0,"_Click Here"
DATA 1,128,155, 96,12,0, 1, 0, 1, 0,0,0,0,0,"P a u s e"
DATA 2,249,155, 96,12,0, 1, 0, 1, 0,0,0,0,0,"S t o p"
DATA 3,369,155, 96,12,0, 1, 0, 0, 0,0,0,0,0,"_E x i t"
DATA 4,131, 91,200,12,0,11, 5,15,10,2,1,1,1,""
DATA 5, 43, 63,392,14,0,13, 0, 0, 0,0,0,0,0,""
END SUB

'''''''''''''''''''''''''''''
'GADGETS: CREATE SUB PROGRAMS
'''''''''''''''''''''''''''''
SUB Bevel.Boxes (BYVAL which)
SHARED fbox_tag&(),rbox_tag&()
'-------
SELECT CASE which
=0 :RESTORE Main_Boxes
 FOR i= 0 TO 2 :READ lef&,topp&,vidth&,height&
  DrawBevelBoxA rport&,lef&,topp&,vidth&,height&,VARPTR(fbox_tag&(0))
 NEXT :Prin.T "G A D T O O L S  G A D G E T S",102,0,13
=1 :DrawBevelBoxA rport&,72,36,311,93,VARPTR(fbox_tag&(0))
 DrawBevelBoxA rport&,72,133,311,28,VARPTR(fbox_tag&(0))
=3 :DrawBevelBoxA rport&,52,55,366,88,VARPTR(fbox_tag&(0))
=8 :SetAPen rport&,1 :RectFill rport&,11,41,415,121
 DrawBevelBoxA rport&,8,40,204,83,VARPTR(fbox_tag&(0))
 DrawBevelBoxA rport&,214,40,204,83,VARPTR(fbox_tag&(0))
 c(1) =12 :c(2) =210 :c(3) =218 :c(4) =415 :c(5)=42 :c(6) =121
 FOR i= 7 TO 10 :c(i)= 0 :NEXT
=16 :c(0)= 114 :c(1)= 111 :c(2)= 127 :c(3)= 295
 DrawBevelBoxA rport&,114,110,300,12,VARPTR(rbox_tag&(0))
 DrawBevelBoxA rport&,114,126,300,12,VARPTR(rbox_tag&(0))
END SELECT
EXIT SUB
'-------
Main_Boxes:
DATA   0, 0,640, 20
DATA   0,21,640,179
DATA 132,60,376,102
END SUB

SUB Create.Gadgets (gad&,glist&,gads&())
SHARED AGadgetTags&(),cy$(),GadgetTags&(),mx$()
SHARED ng(),shi1$(),topaz80(),viewlist&
'-----
my.gads= UBOUND(gads&,1)
'-----
gid= parm(0)
flags&= (0& AND parm(5)= 0)+(PLACETEXT_LEFT& AND parm(5)= 1)+ _
 (PLACETEXT_RIGHT& AND parm(5)= 2)+(PLACETEXT_ABOVE& AND parm(5)= 3)+ _
 (PLACETEXT_BELOW& AND parm(5)= 4)+(PLACETEXT_IN& AND parm(5)= 5)+ _
 (NG_HIGHLABEL& AND parm(5)= 6)
gkind= parm(6)
'-----
ng(ng_LeftEdge\2)= parm(1)
ng(ng_TopEdge\2) = parm(2)
ng(ng_Width\2)   = parm(3)
ng(ng_Height\2)  = parm(4)
POKEL VARPTR(ng(ng_TextAttr\2)),VARPTR(topaz80(0))
POKEL VARPTR(ng(ng_GadgetText\2)),SADD(label$(gid)+CHR$(0))
ng(ng_GadgetID\2)= gid
POKEL VARPTR(ng(ng_Flags\2)),flags&
ng(ng_UserData\2)= gkind
'-----
IF gkind= BUTTONKIND THEN
 TAGLIST VARPTR(GadgetTags&(0)), _
  GA_Disabled&, parm(8), _
  GT_Underscore&, "_"%, _
 TAG_DONE&

ELSEIF gkind= CHECKBOXKIND THEN
 TAGLIST VARPTR(GadgetTags&(0)), _
  GTCB_Checked&, parm(7), _
  GA_Disabled&, parm(9), _
 TAG_DONE&

ELSEIF gkind= INTEGERKIND THEN
 item =(GACT_STRINGLEFT& AND parm(12)= 1)+ _
  (GACT_STRINGRIGHT& AND parm(12)= 2)+(GACT_STRINGCENTER& AND parm(12)= 4)
 TAGLIST VARPTR(GadgetTags&(0)), _
  GTIN_Number&, parm(9), _
  GTIN_MaxChars&, parm(7), _
  STRINGA_Justification&, item, _
  STRINGA_ReplaceMode&, parm(13), _
  GA_Disabled&, parm(8), _
  STRINGA_ExitHelp&, parm(14), _
  GA_TabCycle&, parm(11), _
  GT_Underscore&, "_"%, _
 TAG_DONE&

ELSEIF gkind= LISTVIEWKIND THEN
 item&= 16
 IF c(0)= 8 THEN
  TAGLIST VARPTR(AGadgetTags&(0)),GTLV_ShowSelected&,gads&(gid-1),TAG_DONE&
 ELSEIF c(0)= 9 THEN
  TAGLIST VARPTR(AGadgetTags&(0)),GTLV_ShowSelected&,FALSE&,TAG_DONE&
 ELSE
  IF c(0)= 40 THEN item&= 24
  TAGLIST VARPTR(AGadgetTags&(0)),TAG_DONE&
 END IF
 TAGLIST VARPTR(GadgetTags&(0)), _
  GTLV_Labels&, viewlist&, _
  GTLV_Top&, 0, _
  GTLV_ReadOnly&, parm(8), _
  GTLV_ScrollWidth&, item&, _
  LAYOUTA_Spacing&, 0, _
  GT_Underscore&, "_"%, _
 TAG_MORE&, VARPTR(AGadgetTags&(0))

ELSEIF gkind= MXKIND THEN
 TAGLIST VARPTR(GadgetTags&(0)), _
  GTMX_Labels&, VARPTR(mx$(0)), _
  GTMX_Active&, parm(8), _
  GTMX_Spacing&, parm(11), _
  GT_Underscore&, "_"%, _
 TAG_DONE&

ELSEIF gkind= NUMBERKIND THEN
 TAGLIST VARPTR(GadgetTags&(0)), _
  GTNM_Number&, parm(9), _
  GTNM_Border&, parm(10), _
 TAG_DONE& 

ELSEIF gkind= CYCLEKIND THEN
 TAGLIST VARPTR(GadgetTags&(0)), _
  GTCY_Labels&, VARPTR(cy$(0)), _
  GTCY_Active&, parm(8), _
  GA_Disabled&, parm(9), _
  GT_Underscore&, "_"%, _
 TAG_DONE&

ELSEIF gkind= PALETTEKIND THEN
 IF my.gads= 8 THEN
  c(0)= parm(7)+ 1 :IF gid= 4 OR gid= 5 THEN c(gid)= parm(8)
 END IF
 TAGLIST VARPTR(GadgetTags&(0)), _
  GTPA_DEPTH&, parm(7), _
  GTPA_Color&, parm(8), _
  GTPA_ColorOffset&, parm(9), _
  GTPA_IndicatorWidth&, parm(10), _
  GTPA_IndicatorHeight&, parm(11), _
  Ga_Disabled&, parm(12), _
  GT_Underscore&, "_"%, _
 TAG_DONE&

ELSEIF gkind= SCROLLERKIND THEN
 SELECT CASE gid
 =2,4 :TAGLIST VARPTR(AGadgetTags&(0)),GTSC_Arrows&,parm(10),TAG_DONE&
 =3,5 :TAGLIST VARPTR(AGadgetTags&(0)),TAG_DONE&
 END SELECT
 '---- 
 TAGLIST VARPTR(GadgetTags&(0)), _
  GTSC_Top&, parm(7), _
  GTSC_Total&, parm(8), _
  GTSC_Visible&, parm(9), _
  GA_Immediate&, parm(11), _
  GA_RelVerify&, parm(12), _
  PGA_Freedom&, parm(13) , _
  Ga_Disabled&, parm(14), _
 TAG_MORE&, VARPTR(AGadgetTags&(0))

ELSEIF gkind= SLIDERKIND THEN
 item&= (PLACETEXT_LEFT& AND parm(10)= 1)+ _
  (PLACETEXT_RIGHT& AND parm(10)= 2)+ _
  (PLACETEXT_ABOVE& AND parm(10)= 4)+ _
  (PLACETEXT_BELOW& AND parm(10)= 8)
 IF my.gads= 11 THEN
  c(gid)= parm(7) :c(gid+8)= parm(8) :c(gid+16)= c(gid)
  SELECT CASE gid
  =2,3 :ml= 0
  =4,8,9 :ml= 2 :lf$= "%2ld"
  =5 :ml= 2 :lf$= "%02ld"
  =6 :ml= 4 :lf$= "%03ld"
  =7 :ml= 3 :lf$= "%3ld"
  END SELECT
  SELECT CASE gid
  =4 TO 8 
   TAGLIST VARPTR(AGadgetTags&(0)),GTSL_LevelFormat&,lf$, _
    GTSL_LevelPlace&,item&,TAG_DONE&
  =REMAINDER :TAGLIST VARPTR(AGadgetTags&(0)),TAG_DONE&
  END SELECT
 ELSEIF my.gads= 5 AND label$(0)= "_Cancel" THEN
  parm(9)= (p(0) AND gid= 2)+(p(1) AND gid= 3)+(p(2) AND gid= 4)
  ml= 2 :lf$= "%2ld"
  TAGLIST VARPTR(AGadgetTags&(0)),GTSL_LevelFormat&,lf$, _
   GTSL_LevelPlace&,item&,TAG_DONE&
 ELSEIF my.gads= 5 AND label$(0)= "_Click Here" THEN
  c(0)= parm(9) :ml= 2 :lf$= "%2ld"
  TAGLIST VARPTR(AGadgetTags&(0)),GTSL_LevelFormat&,lf$, _
   GTSL_LevelPlace&,item&,TAG_DONE&
 END IF 
 TAGLIST VARPTR(GadgetTags&(0)), _
  GTSL_Min&, parm(7), _
  GTSL_Max&, parm(8), _
  GTSL_Level&, parm(9), _
  GTSL_MaxLevelLen&, ml, _
  GA_Immediate&, parm(11), _
  GA_RelVerify&, parm(12), _
  PGA_Freedom&, parm(13), _
  GA_Disabled&, parm(14),_
  GT_Underscore&, "_"%, _
 TAG_MORE&, VARPTR(AGadgetTags&(0))
 
ELSEIF gkind= STRINGKIND THEN
 item&= (0& AND parm(13)= 0)+(SADD(txt$(gid)+CHR$(0)) AND parm(13)= 1)
 IF LEFT$(label$(gid),4)= "(SH)" THEN
  item&= SADD(shi1$(0)+CHR$(0)) :parm(12)= 1
 END IF
 place&= (GACT_STRINGLEFT& AND parm(9)= 0)+(GACT_STRINGCENTER& AND _
  parm(9)= 1)+(GACT_STRINGRIGHT& AND parm(9)= 2)
 TAGLIST VARPTR(GadgetTags&(0)), _
  GTST_String&, item&, _
  GTST_MaxChars&, parm(7), _
  GA_Disabled&, parm(8), _ 
  GT_Underscore&, "_"%, _
  STRINGA_Justification&, place&, _
  STRINGA_ReplaceMode&, parm(10), _
  GA_TabCycle&, parm(11), _
  STRINGA_ExitHelp&, parm(12), _
 TAG_DONE&

ELSEIF gkind= TEXTKIND THEN
 IF parm(14)= 1 THEN
  TAGLIST VARPTR(GadgetTags&(0)), _
   GTTX_Text&, SADD(txt$(gid)+CHR$(0)), _
   GTTX_Border&, parm(8), _
  TAG_DONE&
 ELSE
  TAGLIST VARPTR(GadgetTags&(0)), _
   GTTX_Text&, "", _
   GTTX_Border&, parm(8), _
   GTTX_CopyText&, TRUE&, _
  TAG_DONE&
 END IF
END IF
'-----
gad&= CreateGadgetA&(gkind,gad&,VARPTR(ng(0)),VARPTR(gadgetTags&(0)))
'-----
IF gad&<> 0 THEN
 gads&(gid)= gad&
ELSE
 SELECT CASE my.gads
 =16 :Error.Trap 4 
 =REMAINDER :WINDOW CLOSE 2
  IF viewlist&<> 0& THEN Free.ViewList	viewlist&
  IF FEXISTS("CLIPS:list") THEN KILL "CLIPS:list"
  IF glist&<> 0& THEN FreeGadgets glist&
  Error.Trap 5
 END SELECT
END IF
END SUB

SUB Init.TextAttr (t(1),FontName$,BYVAL Height,BYVAL style,BYVAL flags)
POKEL VARPTR(t(0))+ta_Name%,SADD(FontName$+CHR$(0))
t(ta_YSize\2)= Height
POKEB VARPTR(t(0))+ta_Style,style
POKEB VARPTR(t(0))+ta_Flags,flags
END SUB

SUB String.Array (ar$(),ari$(),BYVAL which)
STATIC i,off.set
'-----
SELECT CASE which
=0 :RESTORE MX_Items :READ items :c(0)= items
=1,2 :RESTORE CySH_Items :READ items :c(0)= items
=3 :RESTORE SH_Items :READ items :c(4)= items
=4 :RESTORE Op_Items :READ items :c(0)= items
END SELECT
c(1)= 0 :c(2)= 0 :c(3)= 0: c(5)= 0
FOR i= 0 TO items :READ ari$(i) :NEXT
IF which= 2 OR which= 3 THEN
 FOR i= 0 TO items :ari$(i)= ari$(i)+CHR$(0) :NEXT :EXIT SUB
END IF
'-----
off.set= -4
FOR i= 0 TO items
 off.set= off.set+4
 POKEL VARPTR(ar$(0))+off.set,SADD(ari$(i)+CHR$(0))
NEXT
EXIT SUB
'-----
MX_Items:
DATA 3
DATA "_DF0:","DF1:","DF2:","CD0:"
'-----
CySH_Items:
DATA 3
DATA "DF0:","DF1:","DF2:","CD0:"
'-----
SH_Items:
DATA 4
DATA "DF0:","DF1:","DF2:","CD0:",""
'-----
Op_Items:
DATA 3
DATA "+","-","*","/"
END SUB

'''''''''''''''''''''''''''''
'LISTVIEW GADGET SUB PROGRAMS
'''''''''''''''''''''''''''''
SUB Add.Name (listh&,txt$)
STATIC namenode&
namenode&= AllocMem&(node_sizeof,MEMF_CLEAR&)
IF namenode&= 0& THEN Error.Trap 6	
POKEL namenode&+ln_Name,SADD(txt$+CHR$(0))
AddHead listh&,namenode&
END SUB

SUB Create.ViewList (listhead&,BYVAL new)
SHARED viewlist&
STATIC i,listhead&
'-----
IF new= 0 THEN
 c(1)= 0 :RESTORE List_Items
 FOR i= 0 TO c(0) :READ txt$(i) :txt$(i)= txt$(i)+CHR$(0) :NEXT
ELSEIF new= 1 THEN
 OPEN"i",#1,"CLIPS:list" :FOR i= 0 TO c(0) :INPUT #1,txt$(i) :NEXT :CLOSE #1
END IF
'-----
listhead&= AllocMem& (list_sizeof,MEMF_CLEAR&)
NewList listhead&
FOR i= c(0) TO 0 STEP -1 :Add.Name	listhead&,txt$(i) :NEXT
viewlist&= listhead&
EXIT SUB
'-----
List_Items:
DATA "Line #1","Line #2","Line #3","Line #4","Line #5"
DATA "Line #6","Line #7","Line #8","Line #9","Line #10"
DATA "Line #11","Line #12","Line #13","Line #14","Line #15"
END SUB

SUB Free.ViewList (BYVAL listhead&)
STATIC worknode&,nextnode&
worknode&= PEEKL(ListHead&+lh_head)
DO
 nextnode&= PEEKL(worknode&+ln_Succ)
 IF nextnode&= 0 THEN EXIT LOOP
 FreeMem worknode&,node_sizeof
 worknode&= nextnode&
LOOP
FreeMem listhead&,16
END SUB

SUB Window.Two
WINDOW 2,,(84,23)-(471,175),32+128+256,1
WINDOW 2 :act.win&= WINDOW(7)
rport&= PEEKL(act.win&+rport)
END SUB

''''''''''''''''''''''''''
'WINDOW EVENT SUB PROGRAMS
''''''''''''''''''''''''''
SUB Handle.GadgetEvents (BYVAL code,my_gads&())
SHARED c&(),cyi$(),gad&,mxi$(),terminated
'----------------
my.gads= UBOUND(my_gads&,1)
gid= PEEKW(gad&+gadgetgadgetid)
gkind= PEEKW(gad&+gadgetuserdata)
'----------------
SELECT CASE gkind

=BUTTONKIND :terminated= 1 :EXIT SUB

=CHECKBOXKIND :Check.Box gad&,my_gads&() :EXIT SUB

=INTEGERKIND
 c&(gid)= PEEKL(PEEKL(my_gads&(gid)+GadgetSpecialInfo)+StringInfoLongInt)
 Integer.Kind my_gads&() :EXIT SUB  

=LISTVIEWKIND :txt$= txt$(code) :c(27)= code
 IF label$(2)= " " THEN junk&= ActivateGadget&(my_gads&(2),act.win&,0&)
 IF c(0)= 10 THEN txt$(14)= txt$ :c(26)= 1 ELSE SOUND 1400,3,85,1 :EXIT SUB

=MXKIND :c(1)= code :txt$(14)= mxi$(c(1))
 IF mxi$(0)= "+" THEN
  junk&= ActivateGadget&(my_gads&(4),act.win&,0&) :EXIT SUB
 END IF

=NUMBERKINK :EXIT SUB

=CYCLEKIND :c(2)= code :txt$(14)= cyi$(c(2))

=PALETTEKIND
 IF my.gads= 8 THEN
  Palette.Kind code
 ELSEIF my.gads= 5 THEN Edit.Palette code,my_gads&() :EXIT SUB
 END IF

=SCROLLERKIND :Area.Fill code :EXIT SUB

=SLIDERKIND
 IF my.gads= 11 THEN 
  Slider.Kind code
 ELSEIF my.gads= 5 THEN Edit.Palettes code :EXIT SUB
 END IF

=STRINGKIND
 IF LEFT$(label$(gid),4)= "(SH)" THEN
  Exit.Help code,my_gads&()
 ELSEIF label$(gid)= " " THEN
  Edit.ViewList my_gads&(),code :EXIT SUB
 ELSEIF label$(2)= "Input1" THEN
  Input.1 my_gads&(),code :EXIT SUB
 ELSE
  terminated= 1 :EXIT SUB
 END IF

=TEXTKIND :EXIT SUB

END SELECT
IF gkind= STRINGKIND AND txt$(14)= "" THEN c(26)= 1
Result.Selected my_gads&()
END SUB

SUB Handle.VanillaKeys (BYVAL code,my_gads&())
SHARED cyi$(),mxi$(),terminated
STATIC i,my.gads,txl,txu
'---------------
my.gads= UBOUND(my_gads&,1)
'---------------
IF code= 27 THEN terminate= 1 :EXIT SUB
IF code<> 13 THEN
 vl$= "_"+LCASE$(CHR$(code))
 vu$= "_"+UCASE$(CHR$(code))
 FOR i= 0 TO my.gads
  txl= INSTR(label$(i),vl$)
  txu= INSTR(label$(i),vu$) 
  IF txl OR txu THEN gid= i :EXIT FOR
 NEXT
 IF txl= 0 AND txu= 0 THEN EXIT SUB
 '--------------
 vl$= CHR$(code)
 gkind= PEEKW(my_gads&(gid)+gadgetuserdata)
 SELECT CASE gkind

 =BUTTONKIND :terminated= 1 :EXIT SUB

 =CHECKBOXKIND : EXIT SUB
  
 =INTEGERKIND :junk&= ActivateGadget&(my_gads&(gid),act.win&,0&)
  EXIT SUB

 =LISTVIEWKIND
  IF vl$= MAX(LCASE$(vl$),UCASE$(vl$)) THEN
   INCR c(1) :IF c(1) >c(0) THEN c(1)= c(0)
  ELSE
   DECR c(1) :IF c(1)< 0 THEN c(1)= 0
  END IF 
  Set.Attribute GTLV_Top&,c(1),my_gads&(gid)
  EXIT SUB
  
 =MXKIND,CYCLEKIND
  IF vl$= MAX(LCASE$(vl$),UCASE$(vl$)) THEN
   IF gkind= MXKIND THEN
    INCR c(1) :IF c(1) >c(0) THEN c(1)= 0
    txt$(14)= mxi$(c(1)) :item&= GTMX_Active& :item= c(1)
   ELSEIF gkind= CYCLEKIND THEN
    INCR c(2) :IF c(2) >c(0) THEN c(2)= 0
    txt$(14)= cyi$(c(2)) :item&= GTCY_Active& :item= c(2)
   END IF
  ELSE
   IF gkind= MXKIND THEN
    DECR c(1) :IF c(1)< 0 THEN c(1)= c(0)
    txt$(14)= mxi$(c(1)) :item&= GTMX_Active& :item= c(1)
   ELSEIF gkind= CYCLEKIND THEN
    DECR c(2) :IF c(2)< 0 THEN c(2)= c(0)
    txt$(14)= cyi$(c(2)) :item&= GTCY_Active& :item= c(2)
   END IF
  END IF
  Set.Attribute item&,item,my_gads&(gid)
  IF mxi$(0)= "+" THEN EXIT SUB

 =NUMBERKIND :EXIT SUB

 =PALETTEKIND
  IF vl$= MAX(LCASE$(vl$),UCASE$(vl$)) THEN
   INCR c(gid) :IF c(gid) >c(0) THEN c(gid)= 0
  ELSE
   DECR c(gid) :IF c(gid)< 0 THEN c(gid)= c(0)
  END IF 
  Set.Attribute GTPA_Color&,c(gid),my_gads&(gid)
  EXIT SUB
  
 =SCROLLERKIND :EXIT SUB

 =SLIDERKIND
 	IF vl$= MAX(LCASE$(vl$),UCASE$(vl$)) THEN
   INCR c(gid) :IF c(gid) >c(gid+8) THEN c(gid)= c(gid+8)
 	ELSE
   DECR c(gid) :IF c(gid)< c(gid+16) THEN c(gid)= c(gid+16)
 	END IF
 	IF gid= 3 OR gid= 8 THEN c(26)= 0 ELSE c(26)= 3
  txt$(13)= "" :txt$(14)= STR$(c(gid)) :level= c(gid)
		Set.Attribute GTSL_Level&,level,my_gads&(gid)

	=STRINGKIND :junk&= ActivateGadget&(my_gads&(gid),act.win&,0&)
  EXIT SUB

 =TEXTKIND :EXIT SUB

	END SELECT
ELSEIF code= 13 THEN
 c(26)= 0
END IF
Result.Selected my_gads&()
END SUB

SUB Process.WindowEvents (my_gads&())
SHARED check.click,gad&,imsgClass&,terminated
STATIC imsg&
'-----------
IF NOT check.click THEN ClearPointer act.win&
SOUND 1400,3,85,1
terminated= 0
'-----------
WHILE terminated= 0
 junk&= xWait&(1& << PEEKB(PEEKL(act.win&+UserPort)+mp_SigBit))
 DO
  imsg&= GT_GetIMsg(PEEKL(act.win&+UserPort))
  IF imsg&= 0 THEN EXIT LOOP
  '---------
  gad&= PEEKL(imsg&+IAddress)
  imsgClass&= PEEKL(imsg&+Class)
  imsgCode= PEEKW(imsg&+IntuiMessageCode)
  GT_ReplyIMsg imsg&
  '---------
  SELECT CASE imsgClass&
  =IDCMP_MOUSEBUTTONS&,IDCMP_MENUPICK&
   IF check.click THEN EXIT SUB
  =IDCMP_GADGETDOWN&,IDCMP_GADGETUP&,IDCMP_MOUSEMOVE&
   Handle.GadgetEvents imsgCode,my_gads&()
  =IDCMP_VANILLAKEY&
   Handle.VanillaKeys imsgCode,my_gads&()
  =IDCMP_CLOSEWINDOW& :terminated= 1
  =IDCMP_REFRESHWINDOW&
   GT_BeginRefresh act.win& :GT_EndRefresh act.win&,TRUE&
  END SELECT
 LOOP UNTIL terminated
WEND
IF NOT check.click THEN SetPointer act.win&,b.ptr&,15&,15&,-7&,-7&
END SUB

SUB Raw.Key
POKE &HBFEC01,0
DO
 junk&= xWait&(1& << PEEKB(PEEKL(act.win&+UserPort)+mp_SigBit))
 imsg&= GT_GetIMsg&(PEEKL(act.win&+UserPort))
 imsgClass&= PEEKL(imsg&+Class)
 GT_ReplyIMsg imsg&
 IF imsgClass&= IDCMP_VANILLAKEY& THEN
  rawKey= PEEK(&HBFEC01) :IF rawKey= 119 THEN EXIT LOOP
 END IF
LOOP
END SUB

''''''''''''''''''''''''''
'GADGET EVENT SUB PROGRAMS
''''''''''''''''''''''''''
SUB Area.Fill (BYVAL code)
STATIC apen,y&,y1&,x&,x1&
'---------
x&= (c(3) AND gid= 4)+(c(1) AND gid= 5)
x1&=(c(4) AND gid= 4)+(c(2) AND gid= 5)
y&= c(5) :y1&= c(6)
'---------
SELECT CASE gid
=2,3
 IF c(gid+5)< code THEN
  apen= 2
  IF gid= 2 THEN x&= c(3) :x1&= x&+(code\2)
  IF gid= 3 THEN x&= c(1) :x1&= x&+(code\2)
 ELSEIF c(gid+5) >code THEN
  apen= 1
  IF gid= 2 THEN x&= c(3)+(code\2) :x1&= c(4)
  IF gid= 3 THEN x&= c(1)+(code\2) :x1&= c(2)
 END IF
=4,5
 IF c(gid+5)< code THEN
  apen= 2 :y&= c(5) :y1&= y&+(code\2)
 ELSEIF c(gid+5) >code THEN
  apen= 1 :y&= c(5)+(code\2) :y1&= c(6)
 END IF
END SELECT
'---------
SetAPen rport&,apen :RectFill rport&,x&,y&,x1&,y1&
c(gid+5)= code
SetAPen rport&,1
END SUB

SUB Check.Box (BYVAL gad&,my_gads&())
STATIC state,x&,x1&,y&
'---------------------
state= PEEK(PEEKW(gad&+GadgetFlags)+5)
IF state= GFLG_SELECTED& THEN
 SELECT CASE gid
 =2 :SOUND 2800,3,85,1
 =3 :SOUND 1400,3,85,1
 =4 :SOUND  700,3,85,1
 =5,6 :Fill.Area gid
 END SELECT
 SELECT CASE gid
 =2 TO 4 :Set.Attribute GTCB_Checked&,0,my_gads&(gid)
 =5 :Set.Attribute GA_Disabled&,TRUE&,my_gads&(gid)
 END SELECT
ELSE
 IF gid =6 THEN
  x&= c(0)+2 :x1&= c(0)+c(3)+2 :y&= c(2)
  SetAPen& rport&,0 :RectFill rport&,x&,y&,x1&,y&+8
  SetAPen& rport&,1
 END IF
END IF
END SUB

SUB Edit.Palette (BYVAL code,my_gads&())
STATIC i
'-------
p(12)= code
SELECT CASE code
=0 :item&(2)= p(0) :item&(3)= p(1) :item&(4)= p(2)
=1 :item&(2)= p(3) :item&(3)= p(4) :item&(4)= p(5)
=2 :item&(2)= p(6) :item&(3)= p(7) :item&(4)= p(8)
=3 :item&(2)= p(9) :item&(3)= p(10):item&(4)= p(11)
END SELECT
FOR i= 2 TO 4 :Set.Attribute GTSL_Level&,item&(i),my_gads&(i) :NEXT
END SUB

SUB Edit.Palettes (BYVAL code)
kolor= p(12)
SELECT CASE kolor
=0
 SELECT CASE gid
 =2 :p(0)= code
 =3 :p(1)= code
 =4 :p(2)= code
 END SELECT
=1
 SELECT CASE gid
 =2 :p(3)= code
 =3 :p(4)= code
 =4 :p(5)= code
 END SELECT
=2
 SELECT CASE gid
 =2 :p(6)= code
 =3 :p(7)= code
 =4 :p(8)= code
 END SELECT
=3
 SELECT CASE gid
 =2 :p(9) = code
 =3 :p(10)= code
 =4 :p(11)= code
 END SELECT
END SELECT :Set.Palettes 1
END SUB

SUB Edit.ViewList (my_gads&(),BYVAL code)
SHARED viewlist&
'---------------
Get.String txt$,my_gads&(gid) :SOUND 1400,3,85,1
IF gid= 2 THEN
 txt$(c(27))= txt$+CHR$(0)
 OPEN "o",#1,"CLIPS:list"
  FOR i= 0 TO c(0) :PRINT #1,txt$(i) :NEXT
 CLOSE #1 :Free.ViewList	viewlist&
 Create.ViewList viewlist&,1
 Set.Attribute GTLV_Labels&,viewlist&,my_gads&(gid+1)
 IF code= 0 THEN Set.Attribute GTST_String&,SADD(""+CHR$(0)),my_gads&(gid)
END IF
END SUB

SUB Exit.Help (BYVAL code,my_gads&())
SHARED shi1$(),shi2$()
'---------------
IF code= 95 THEN
 SELECT CASE gid
 =4 :INCR c(3) :IF c(3) >c(0) THEN c(3)= 0
  item$ = shi1$(c(3))
 =5 :INCR c(5) :IF c(5) >c(4) THEN c(5)= 0
  item$= shi2$(c(5)) 
 END SELECT :txt$(13)= item$
 Set.Attribute GTST_String&,SADD(item$+CHR$(0)),my_gads&(gid)
 junk&= ActivateGadget&(my_gads&(gid),act.win&,0&)
 Get.String txt$(14),my_gads&(gid)
ELSE
 IF (gid= 5 AND c(5)= c(4) AND c(4)< 5 AND txt$(14)= "") THEN
  Get.String txt$(14),my_gads&(gid)
  IF txt$(14)<> "" THEN
   shi2$(c(5))= txt$(14)+CHR$(0) :c(26)= 2 :txt$(13)= txt$(14)
   junk&= ActivateGadget&(my_gads&(gid),act.win&,0&)
  END IF
 END IF
END IF
END SUB

SUB Fill.Area(BYVAL rect)
SetAPen rport&,3
SELECT CASE rect
=5 :file.size= 500 :x&= c(0) :y&= c(1)
=6 :file.size= 750 :x&= c(0) :y&= c(2)
END SELECT :dt= file.size\c(3)
FOR i= 0 TO c(3)
 Delay dt :INCR x& :RectFill rport&,x&+1,y&,x&+1,y&+8
NEXT
IF rect= 5 THEN
 x&= c(0) :y&= c(1)-1 :x1&= c(0)+300 :y1&= y&+12
 SetAPen rport&,0 :RectFill rport&,x&,y&,x1&,y1&
END IF
END SUB

SUB Get.String (txt$,BYVAL stgad&)
STATIC stgad&
txt$= PEEK$(PEEKL(PEEKL(stgad&+GadgetSpecialInfo)+StringInfoBuffer))
END SUB

SUB Input.1 (my_gads&(),BYVAL code)
IF gid< 6 THEN
 Set.Attribute GTST_String&,SADD(""+CHR$(0)),my_gads&(6)
 Set.Attribute GTTX_Text&,SADD(""+CHR$(0)),my_gads&(7)
END IF
Get.String txt$(gid),my_gads&(gid) :txt$(14)= txt$(gid) :SOUND 1400,3,85,1
IF code= 9 THEN
 t$= txt$(gid)+" " :EXIT SUB
ELSEIF code<> 9 THEN
 IF t$<> "" THEN
  txt$(14)= t$+txt$(14) :t$= ""
  Set.Attribute GTST_String&,SADD(""+CHR$(0)),my_gads&(4)
 END IF
 Set.Attribute GTST_String&,SADD(""+CHR$(0)),my_gads&(gid)
 Set.Attribute GTTX_Text&,SADD(""+CHR$(0)),my_gads&(7)
 Set.Attribute GTST_String&,SADD(txt$(14)+CHR$(0)),my_gads&(6)
 SOUND 1400,3,85,1
END IF
IF gid= 6 THEN
 Set.Attribute GTTX_Text&,SADD(txt$(gid)+CHR$(0)),my_gads&(7)
 SOUND 1400,3,85,1
 Set.Attribute GTST_String&,SADD(""+CHR$(0)),my_gads&(6)
END IF
END SUB

SUB Integer.Kind (my_gads&())
SHARED c&()
'----------
Set.Attribute GTNM_Number&,c&(gid),my_gads&(6)
SELECT CASE gid
=2,3 :Set.Attribute GA_Disabled&,TRUE&,my_gads&(gid)
=4 :junk&= ActivateGadget&(my_gads&(5),act.win&,0&) :EXIT SUB
=5 :op= c(1)
 SELECT CASE op
 =0 :c&= (c&(4)+c&(5))
 =1 :c&= (c&(4)-c&(5))
 =2 :c&= (c&(4)*c&(5))
 =3 :c&= (c&(4)/c&(5))
 END SELECT
 Set.Attribute GTNM_Number&,c&,my_gads&(7) :SOUND 1400,3,85,1
END SELECT
END SUB

SUB Palette.Kind (BYVAL code)
c(gid)= code
SELECT CASE code
=0 :txt$(14)= "Gray"
=1 :txt$(14)= "Black"
=2 :txt$(14)= "White"
=3 :txt$(14)= "Blue"
END SELECT :c(26)= 1
IF gid<> 2 AND gid<> 6 THEN txt$(14)= "    "
END SUB

SUB Result.Selected (my_gads&())
STATIC tgad
'-----
IF txt$(13)<> "" THEN
 txt$(13)= "" :SetAPen rport&,0 :RectFill rport&,111&,136&,355&,146&
END IF
IF LEFT$(txt$(14),1)= "_" THEN
 txt$(14)= MID$(txt$(14),2)
ELSEIF txt$(14)= "" AND c(26)= 1 THEN
 Prin.T "Enter another item if you wish",100,0,144 :c(26)= 0
ELSEIF RIGHT$(txt$(14),1)= CHR$(0) THEN
 txt$(14)= LEFT$(txt$(14),LEN(txt$(14))-1)
END IF
'-----
my.gads= UBOUND(my_gads&,1)
rawKey= PEEK(&HBFEC01)
tgad= my.gads-1
IF rawKey= 119 THEN
 tgad= my.gads
 IF c(26)= 2 THEN tgad= my.gads-2 :c(26)= 0
END IF
IF c(26)= 1 THEN tgad= my.gads :c(26)= 0
'-----
Set.Attribute GTTX_Text&,SADD(""+CHR$(0)),my_gads&(my.gads)
IF my.gads<> 4 THEN
 Set.Attribute GTTX_Text&,SADD(""+CHR$(0)),my_gads&(my.gads-1)
END IF
'-----
IF rawKey<> 119 AND c(26)= 3 THEN c(26)= 0 :EXIT SUB
Set.Attribute GTTX_Text&,SADD(txt$(14)+CHR$(0)),my_gads&(tgad)
IF label$(tgad)= "Selected:" AND txt$(14)<> "" THEN SOUND 1400,3,85,1
END SUB

SUB Set.Attribute (BYVAL item&,BYVAL value&,BYVAL gadget&)
TAGLIST VARPTR(GadgetTags&(0)),item&,value&,TAG_DONE&
GT_SetGadgetAttrsA gadget&,act.win&,0&,VARPTR(GadgetTags&(0))
END SUB

SUB Set.Palettes (BYVAL which)
STATIC i,j,kolor,setpal,wbc()
STATIC color.map&,view.port&
'----------------
view.port&= ViewPortAddress&(act.win&)
color.map&= PEEKL(view.port&+4)
'----------------
SELECT CASE which
=0 :'Get original palettes
 FOR i= 0 TO 3 :wbc(i)= GetRGB4&(color.map&,i) :NEXT
 FOR i=0 TO 3 :wbc$(i)= HEX$(wbc(i)) :NEXT
 c= -1 :IF LEN(wbc$(i))= 1 AND wbc$(i)= "0" THEN wbc$(i)= "000"
 FOR i= 0 TO 3
  FOR j= 1 TO 3 :INCR c :p(c)= VAL("&H"+MID$(wbc$(i),j,1)) :NEXT
 NEXT
=1 :kolor= p(12)
 SELECT CASE kolor
 =0 :SetRGB4 view.port&,0&,p(0),p(1),p(2)
 =1 :SetRGB4 view.port&,1&,p(3),p(4),p(5)
 =2 :SetRGB4 view.port&,2&,p(6),p(7),p(8)
 =3 :SetRGB4 view.port&,3&,p(9),p(10),p(11)
 END SELECT :setpal= -1
=2 :'Restore original palettes
 c= -1 :IF LEN(wbc$(i))= 1 AND wbc$(i)= "0" THEN wbc$(i)= "000"
 FOR i= 0 TO 3
  FOR j= 1 TO 3 :INCR c :p(c)= VAL("&H"+MID$(wbc$(i),j,1)) :NEXT
 NEXT
 SetRGB4 view.port&,0&,p(0),p(1),p(2)
 SetRGB4 view.port&,1&,p(3),p(4),p(5)
 SetRGB4 view.port&,2&,p(6),p(7),p(8)
 SetRGB4 view.port&,3&,p(9),p(10),p(11)
END SELECT
END SUB

SUB Slider.Kind (BYVAL code)
c(gid)= code :txt$(13)= "" :txt$(14)= STR$(code)
IF gid= 2 OR gid= 3 OR gid= 8 OR gid= 9 THEN c(26)= 0 ELSE c(26)= 3
END SUB

'''''''''''''''''''''
'UTILITY SUB PROGRAMS
'''''''''''''''''''''
SUB Add1.IDCMPFlags
junk&= ModifyIDCMP& (act.win&, _
	IDCMP_GADGETUP&+ _
 IDCMP_REFRESHWINDOW&+ _
 IDCMP_VANILLAKEY&)
END SUB

SUB Add2.IDCMPFlags
junk&= ModifyIDCMP& (act.win&, _
 IDCMP_REFRESHWINDOW&+ _
 IDCMP_MOUSEBUTTONS&+ _
	IDCMP_MOUSEMOVE&+ _
	IDCMP_GADGETDOWN&+ _
	IDCMP_GADGETUP&+ _
 IDCMP_MENUPICK&+ _
 IDCMP_CLOSEWINDOW&+ _
 IDCMP_RAWKEY&+ _
 IDCMP_VANILLAKEY&+ _
	IDCMP_INTUITICKS&)
END SUB

SUB Busy.Pointer
STATIC x
'-------
Dos.Script ":HB2Gads/lacepointer"
'-------
b.ptr&= AllocRaster&(16&,34&)
RESTORE Busy_Pointer
FOR x= 0 TO 64 STEP 4
 READ d1,d2
 POKEW b.ptr&+x,d1
 POKEW b.ptr&+2+x,d2
NEXT
SetPointer WINDOW(7),b.ptr&,15&,15&,-7&,-7&
act.win&= WINDOW(7)
rport&= WINDOW(8)
EXIT SUB
'-------
Busy_Pointer:
DATA 0,0
DATA &H400,&H7C0
DATA &H0,&H7C0
DATA &H100,&H380
DATA &H0,&H7E0
DATA &H7C0,&H1FF8
DATA &H1FF0,&H3FEC
DATA &H3FF8,&H7FDE
DATA &H3FF8,&H07FBE
DATA &H7FFC,&HFF7F
DATA &H7EFC,&HFFFF
DATA &H7FFC,&HFFFF
DATA &H3FF8,&H7FFE
DATA &H3FF8,&H7FFE
DATA &H1FF0,&H3FFC
DATA &H7C0,&H1FF8
DATA &H0,&H7E0
DATA 0,0
END SUB

SUB Dos.Script (file$)
SHARED nil_handle&
junk& = Execute&(SADD(file$+CHR$(0)),0&,nil_handle&)
END SUB

SUB Error.Trap (BYVAL et)
WINDOW 1 :CLS :BEEP
SELECT CASE et
=1 :txt$= "COULD NOT LOCK PUBLIC SCREEN"
=2 :txt$= "GetVisualInfo FAILED"
=3 :txt$= "FAILED TO OPEN Topaz 80"
=4 :txt$= "CREATE GADGET FAILED" :et= 4
=5 :txt$= "CREATE GADGET FAILED" :et= 0
=6 :txt$= "OUT OF MEMORY" :et= 0
END SELECT
y= (80-LEN(txt$))\2
LOCATE 12,y :PRINT txt$
LOCATE 22,23
PRINT "PRESS ANY KEY TO CLOSE THE PROGRAM"
SLEEP :CLS
Close.Program et
END SUB

SUB Print.Notes (BYVAL which)
SELECT CASE which
=0 :Prin.T "A: Cycle Gadget. B: Mutually Exclusive Gadget.",100,0,18
 Prin.T "C: String-ExitHelp Gadget (Press the HELP key).",100,0,28
 Prin.T "D: String-ExitHelp Gadget with input.",100,0,38
 Prin.T "Select and press RETURN.",100,0,48
 Prin.T "A",100,77,84  :Prin.T "B",100,391,84
 Prin.T "C",100,77,100 :Prin.T "D",100,77,116
=1 :Bevel.Boxes 1
 Prin.T "Select a color and change its palette.",100,0,18
=2 :Prin.T "'Click Here' to scroll the text in the borderless Text-",100,0,16
 Prin.T "Display Gadget. Use the slider to change the speed,",100,0,26
 Prin.T " 'Pause' to pause and re-start, 'Stop' to stop.",100,0,36
=3 :Bevel.Boxes 3
 Prin.T "Editable String-Gadgets. Select and edit if needed,",100,0,24
 Prin.T "or simply select. Press RETURN.",100,0,34
=33 :Bevel.Boxes 3 :Prin.T "Text Display Gadgets with border.",100,0,29
=4 :Bevel.Boxes 3
 Prin.T "Disabled String-Gadgets. On selecting 'OK', they will",100,0,24
 Prin.T "be successively enabled and activated for input.",100,0,34
=44 :Bevel.Boxes 3
 Prin.T "Text Display Gadgets without border.",100,0,29
=5 :Prin.T "Click on Gadget or press the",100,0,12
 Prin.T "underlined KEY ± SHIFT to make selection.",100,0,22
 Prin.T "Press RETURN to select.",100,0,32
=6 :Bevel.Boxes 8
 Prin.T "The actions of the horizontal and vertical gadgets",100,0,18
 Prin.T "are not coordinated.",100,0,28
=7 :Prin.T "Various Types of Palette Gadgets.",100,0,18
=8 : Prin.T "Input2: string center. Input4: string right.",100,0,16
 Prin.T "Input3&4: Tab Cycle. Input3: also Replace Mode",100,0,26
 Prin.T "(use pointer/arrows to select&replace a character).",100,0,36
 Prin.T "Edit: Edit Gadget. Result: Text Display Gadget.",100,0,46
=9 :Prin.T "Read-only Gadgets.",100,0,18
=10:Prin.T "Listview Gadget with Editable Display Gadget.",100,0,24
 Prin.T "Edit the selected item and press RETURN.",100,0,36
=11 :Prin.T "Listview Gadgets with attached Display Gadget",100,0,24
 Prin.T "for the Selected Item.",100,0,34
=12 :Prin.T "Simple Listview Gadgets.",100,0,24
 Prin.T "Select by clicking on desired item.",100,0,34
=15 :Bevel.Boxes 16 :Prin.T "Loader",100,58,118
 Prin.T "Percent",100,50,134 :Prin.T "0",100,117,146
 Prin.T "50",100,244,146 :Prin.T "100",100,388,146
 Prin.T "Loader and Percent will activate the respective Progress",100,0,18
 Prin.T "Indicator. High, Medium and Low will produce a sound of",100,0,28
 Prin.T "corresponding frequency. Select % and then a sound button.",100,0,38
=16:Prin.T "Int1-Int4: Number Entry Gadgets. Input-Result: Numeric",100,0,18
 Prin.T "Display Gadgets with and without border. Int1-Int2 are",100,0,28
 Prin.T "disabled after an entry. Int2: input from the right.",100,0,38
 Prin.T "Int3 & Int4 TAB Cycle: make an entry in them,",100,0,48
 Prin.T "choose an operator and see the Result.",100,0,58
END SELECT
END SUB

SUB Prin.T (txt$,BYVAL style,BYVAL x&,BYVAL y&)
STATIC apen,bpen,lt
'------------------
apen= style\100 :bpen= style MOD 100 :style= bpen MOD 10 :bpen= bpen\10
lt= LEN(txt$)*8 :IF x&= 0 THEN x&= (PEEKW(act.win&+8)-lt)\2
'------------------
SetAPen rport&,apen :SetBPen rport&,bpen
style&= SetSoftStyle&(rport&,style,255)
Move rport&,x&,y&
Text rport&,SADD(txt$),LEN(txt$)
newstyle&= SetSoftStyle&(rport&,0&,255)
END SUB
'''''''''''''''''''''''''''''''''''''''
