/* Arexx Script For YAM2.0+ - I don't know if it will work on YAM 1.xx */
/* Script Changed in 08/12/98 - Version 2.0 */

options results
TempFile="T:AFM.tmp"

address 'YAM' 'GetFolderInfo MAX'
a=result
b=0

do b=0 to a-1
  address 'YAM' 'Setmail' b
  address 'YAM' 'GetMailInfo FROM'
  from=upper(result)
   if left(from,6)='AMINET' then do
       address 'YAM' 'GetMailInfo File'
        InputFile=result
         if open(In,InputFile,'r') then do
          if open(Tmp,TempFile,'w') then do
           do until eof(In)
            L=readln(In)
             if substr(L,19,1,"|")=" " & substr(L,30,1,"|")=" " & index(L,"/")>21 & index(L,"/")<26 then do  /* Checks if line is part of Aminet list... */
              call writeln(Tmp,L)
             end
           end
          end
         end
   end
end /*do*/
exit
