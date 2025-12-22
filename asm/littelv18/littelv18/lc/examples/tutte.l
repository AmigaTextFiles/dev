;

#include "littel:macrofunctions/dos_lib.fd.mf"

proc main
   var a b
   codestart
   copy 1000 a
   copy 1000000 b
   while b > 1
      select a
      case 100
      case 200
      case 300
      case 400
      case 500
      case 600
      case 700
      case 800
      case 900
      case 1000
         dmf Delay 10
      endselect
      dec b
   endwhile
endproc
end


