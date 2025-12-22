G4C

WINBIG 155 73 338 94 'Join nodes into an AmigaGuide'
wintype 11110001
resinfo 8 640 256
box 0 0 0 0 out button

; =======================================================
;       on load / close
; =======================================================

xonload
setgad JoinGuide.g 1/4 hide  ; hide lvs
setgadvalues joinguide.g
sendrexx $cedbar.gc/cedport 'status filename'
path = $$rexxret
extract path path path
guiopen JoinGuide.g
update joinguide.g 10 $path

xonclose
guiquit JoinGuide.g

; =======================================================
;       guide name gadget
; =======================================================

CTEXT 14 4 "Enter name of dir for nodes:" #screen 8 2 0 0001

XTEXTIN 10 16 290 14 "" dirname "" 100
gadid 10
gosub JoinGuide.g prepdir
setgad JoinGuide.g 11 on

XBUTTON 301 16 25 14 "<"
ReqFile -1 -1 300 -30 "Choose a dir:" DIR dirname '$path'
gosub JoinGuide.g prepdir

xroutine prepdir
extract dirname unquote dirname
if $dirname[-1][1] == '/'
   cutvar dirname cut char -1 ''
endif
update JoinGuide.g 10 $dirname

; =======================================================
;       dir name gadget
; =======================================================

CTEXT 12 32 "Enter name for new Guide:" #screen 8 2 0 0001

XTEXTIN 10 44 290 14 "" guidename "Ram:Sample.guide" 100
gadid 11

XBUTTON 302 44 25 14 "<"
ReqFile -1 -1 300 -30 "Choose name for new Guide:" SAVE guidename 'Ram:'
update JoinGuide.g 11 $guidename

; =======================================================
;       status 
; =======================================================

CTEXT 11 62 "Status:" #screen 8 2 0 0001

TEXT 10 74 238 14 "Idle." 40 BOX
gadid 12

; =======================================================
;       listviews for data handling
; =======================================================

XLISTVIEW 0 0 343 72 '' lv1 '' 0 MULTI	; temp
gadid 1
XLISTVIEW 0 0 343 72 '' lv2 '' 0 MULTI	; main file
gadid 2
XLISTVIEW 0 0 343 72 '' file '' 0 DIR	; to get node names
gadid 3
XLISTVIEW 0 0 343 72 '' file '' 0 MULTI	; for the index
gadid 4

; =======================================================
;       The routine that does the actual joining
; =======================================================

XBUTTON 254 74 74 14 "Join!"

   if $guidename < ' '
   or $dirname < ' '
   orifexists dir '~$dirname'
      ezreq 'Incorrect parameters!' OK ''
      stop
   endif
   update joinguide.g 12 'Seting up..'

   olddir = $$g4c.dir
   cd $dirname

   ; initiate index
   lvuse joinguide.g 4
   lvadd '\n@NODE INDEX\n\tGuide INDEX :\n'

   ; initiate main guide
   lvuse joinguide.g 2
   lvadd '@DATABASE\n@INDEX INDEX'

   ; get file list
   lvuse joinguide.g 3
   lvdir #$dirname
   lvmode MULTI

   ; find header
   lvsearch CBAG_Header ci first
   if $$lv.line > ''
      update joinguide.g 12 'Adding header..'
      lvuse joinguide.g 1
      lvchange CBAG_Header
      ; delete previous index entry
      lvsearch @INDEX ci first
      if $$lv.line > ''
         lvdel -1
      endif
      lvgo first
      lvclip cut -1 add joinguide.g 2
      lvuse joinguide.g 3
      lvdel -1
   endif
   
   ; find main
   lvsearch "MAIN " ci first
   while $$lv.line > ''
   and $$search.pos != 0
      lvsearch "MAIN " ci next
   endwhile
   if $$lv.line > ''
      update joinguide.g 12 'Adding node MAIN..'
      lvuse joinguide.g 1
      lvchange MAIN
      lvinsert 0 '@NODE MAIN'
      lvadd '@ENDNODE'
      lvgo first
      lvclip copy -1 add joinguide.g 2
      lvuse joinguide.g 3
      lvdel -1
   else
      update joinguide.g 12 'Could not find node MAIN!'
      stop
   endif
   
   lvuse joinguide.g 3
   lvmode DIR
   lvmulti all
   
   lvmulti first
   while $$lv.type == DIR
      lvmulti next
   endwhile

   while $$lv.line > ''

      lvuse joinguide.g 1
      extract file file file
      if $file == INDEX
         ; nop
      else
         update joinguide.g 12 'Processing node $file'
         lvchange $file
         lvinsert 0 '@NODE $file'
         lvadd '@ENDNODE'
         lvgo first
         lvclip copy -1 add joinguide.g 2
         ; make index entry
         lvuse joinguide.g 4
         lvadd '\t@{" $file " link \"$file\"}'
      endif
      
      lvuse joinguide.g 3
      lvmulti next

   endwhile

   update JoinGuide.g 12 'Adding index..'
   lvuse joinguide.g 4
   lvadd '@ENDNODE\n'
   lvgo first
   lvclip copy -1 add joinguide.g 2

   update JoinGuide.g 12 'Saving $guidename'
   lvuse joinguide.g 2
   lvsave $guidename
   update JoinGuide.g 12 'Freeing resources..'
   lvclear
   lvuse joinguide.g 1 
   lvclear
   lvuse joinguide.g 4
   lvclear

   update JoinGuide.g 12 "Finished."
   cd $olddir

