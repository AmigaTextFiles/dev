
-> The address book's graphical user interface.
-> This module performs all interactions
-> between the program and the interface.

OPT MODULE
OPT EXPORT
MODULE 'muse/muse','*person'

-> Events this program responds to
ENUM FINDNEXT=1, CLEARVIEW, INSERT, DELETE, SETSEARCH, RESHOW, START

DEF gads:PTR TO LONG

-> This procedure must be called before the quick gadget access functions
-> The ideal time is during the startup event
PROC init_gads()
DEF gad_labels:PTR TO LONG, t:PTR TO LONG, f
   gad_labels:=['NAME', 'TELEPHONE', 'LINE1', 'LINE2','LINE3',
                               'CITY', 'COUNTY', 'POSTCODE']
   NEW t[8]
   FOR f:=0 TO 7
      t[f]:=get_gadgethandle(gad_labels[f])
   ENDFOR
   gads:=t
ENDPROC

-> This procedure takes a *COPY* of whatever is currently displayed.
-> (I think... - not too sure about the string gadget!)
PROC get_person()
DEF t:PTR TO LONG, f,   -> Temporary input array buffer, and index var.
    p:PTR TO person,    -> This will contain a pointer to a valid person
    field
   NEW t[8]
   FOR f:=0 TO 7
      field:=get_gadget_info(gads[f])
      t[f]:=copy_str(field)
   ENDFOR
   NEW p.mk(t[0],t[1],t[2],t[3],t[4],t[5],t[6],t[7])
   END t[8]
ENDPROC p

PROC copy_str(source)
DEF dest
   dest:=String(StrLen(source)+1)
   StrCopy(dest,source)
ENDPROC dest

PROC display_person(p:PTR TO person)
DEF t:PTR TO LONG, f
   t:=p.flat()
   FOR f:=0 TO 7 DO set_gadgetinfo(gads[f], t[f])
ENDPROC

PROC clear_display()
DEF f
   FOR f:=0 TO 7 DO set_gadgetinfo(gads[f], '')
ENDPROC

PROC address_book_window() IS [
      [NAME,'MAIN'],
      [KEYS, [["q",QUIT],[27,QUIT]]],
      [TITLE, 'The Amazing Address Book Program!'],
      [BOX, [10,10,530,180]],
      [GADGETS,[
   -> These gadgets do NOT need names since we're just using them for events.
         ['STD_IMAGE', [RESHOW, '',    NORMAL, 50, 10, 'MUSE_LOGO']],
         ['STD_IMAGE', [START,'',      NORMAL, 190, 17, 'TO_START']],
         ['STD_IMAGE', [FINDNEXT, '',  NORMAL, 222,17, 'PLAY']],
         ['STD_IMAGE', [CLEARVIEW, '', NORMAL, 254,17, 'NEWVIEW']],
         ['STD_IMAGE', [SETSEARCH, '', NORMAL, 286,17, 'HELP']],
         ['STD_IMAGE', [INSERT, '',    NORMAL, 318,17, 'YES']],
         ['STD_IMAGE', [DELETE, '',    NORMAL, 350,17, 'NO']],

   -> These DO need names however due to the fact they are used for data gathering
         ['STRINGGAD', [0, 'NAME', 'Full Name', 100,50, 200, 80]],
         ['STRINGGAD', [0, 'TELEPHONE', 'Telephone', 400,50, 100, 20]],
         ['STRINGGAD', [0, 'LINE1', 'Address', 100,65, 400, 80]],
         ['STRINGGAD', [0, 'LINE2', '', 100,80, 400, 80]],
         ['STRINGGAD', [0, 'LINE3', '', 100,95, 400, 80]],
         ['STRINGGAD', [0, 'CITY', 'City', 100,110, 200, 40]],
         ['STRINGGAD', [0, 'COUNTY', 'County', 100,125, 200, 40]],
         ['STRINGGAD', [0, 'POSTCODE', 'Post Code', 100,140, 200, 15]]
      ]] -> END OF GADGETS!
]
