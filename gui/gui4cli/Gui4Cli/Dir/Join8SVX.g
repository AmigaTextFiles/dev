G4C

; add8svx.g

xonload gui lvid var

guiquit join8svx.g

lvuse $gui $lvid
if $$lv.mode != DIR
   ezreq '$gui $lvid is not\na directory listview!\n' 'Oops!' ''
   return
endif

lvmulti first
if $$lv.line > ''
   file1 = $var
   lvmulti next

   while $$lv.line > ''
      cli 'add8svx $file1 $var'
      lvmulti off
      lvmulti next
   endwhile

endif

extract file1 path path
return $join8svx.g/path


