G4C

WINBIG 155 73 338 94 'Split a guide into nodes'
wintype 11110001
resinfo 8 640 256
box 0 0 0 0 out button

; =======================================================
;       on load / close
; =======================================================

xonload
setgad splitguide.g 1/2 hide  ; hide lvs
dirname = "Ram:"
guiopen splitguide.g

xonclose
guiquit splitguide.g

; =======================================================
;       guide name gadget
; =======================================================

CTEXT 14 4 "Enter name of guide to be split:" #screen 8 2 0 0001

XTEXTIN 10 16 290 14 "" guidename "" 100
gadid 10
setgad splitguide.g 11 on

XBUTTON 301 16 25 14 "<"
ReqFile -1 -1 300 -30 "Choose a Guide:" LOAD guidename ''
update splitguide.g 10 $guidename

; =======================================================
;       dir name gadget
; =======================================================

CTEXT 12 32 "Enter name of dir to put nodes in:" #screen 8 2 0 0001

XTEXTIN 10 44 290 14 "" dirname "Ram:" 100
gadid 11

XBUTTON 302 44 25 14 "<"
ReqFile -1 -1 300 -30 "Choose or Create a Directory:" DIR dirname ''
update splitguide.g 11 $dirname


; =======================================================
;       status 
; =======================================================

CTEXT 11 62 "Status:" #screen 8 2 0 0001

TEXT 10 74 238 14 "Idle." 40 BOX
gadid 12

; =======================================================
;       listviews for data handling
; =======================================================

XLISTVIEW 0 0 343 72 '' lv1 '' 0 MULTI
gadid 1
XLISTVIEW 0 0 343 72 '' lv2 '' 0 MULTI
gadid 2

; =======================================================
;       The routine that does the actual spliting
; =======================================================

XBUTTON 254 74 74 14 "Split!"
local t

   if $guidename < ' '
   or $dirname < ' '
      ezreq 'Incorrect parameters!' OK ''
      stop
   endif

   ifexists dir '~$dirname'
      makedir '$dirname'
   endif

   update splitguide.g 12 "Loading guide.."
   lvuse splitguide.g 1
   lvchange $guidename
   olddir = $$g4c.dir
   cd $dirname

   ; find 1st node
   gosub splitguide.g gonext @NODE FIRST
   nodeline = $$lv.line
   if $nodeline = ''
      return
   endif

   ; goto after the @database & get & save headers
   update splitguide.g 12 "Processing Header.."
   lvgo #1
   t = $($nodeline - 2)
   if $t > 0
      lvclip cut $($nodeline - 2) paste splitguide.g 2
      lvuse splitguide.g 2
      lvsave CBAG_Header
   endif

   ; find 1st node again..
   gosub splitguide.g gonext @NODE FIRST
   nodeline = $$lv.line

   while $nodeline > ''

      ; get name
      ln = $$lv.rec
      cutvar ln cut word 2 ln
      cutvar ln cut word -1 ln
      extract ln unquote ln
      update splitguide.g 12 "Processing node $ln"
      
      lvgo next
      ++nodeline
      
      gosub splitguide.g gonext @ENDNODE NEXT
      if $$lv.line == ''
         ezreq "ERROR:\nNode: $ln\nNo @EndNode!\n" OK ''
         update splitguide.g 12 "Aborted."
         cd $olddir
         stop   
      endif
      nodeend = $($$lv.line - 1)
      lvgo #$nodeline
      lvclip cut $($nodeend - $nodeline) paste splitguide.g 2
      
      lvuse splitguide.g 2
      lvsave $ln

      ; find next node..
      gosub splitguide.g gonext @NODE NEXT
      nodeline = $$lv.line

   endwhile

   update splitguide.g 12 "Finished."
   cd $olddir

; =======================================================
; 	routine to find the next @command
;	txt  = either @NODE or @ENDNODE
;	smod = either FIRST or NEXT
; =======================================================


xROUTINE gonext txt smod

   lvuse splitguide.g 1
   if $smod == FIRST
      lvsearch $txt ci first
   else
      lvsearch $txt ci next
   endif

   while $$search.pos != 0    ; check that it's the 1st word
   and $$lv.line > ''
      lvsearch $txt ci next
   endwhile







