/*
       RexX script to correct AmigaGuide files to run properly with
                               >AutoDoc-It<

                $VER V1.0 by Th.Strauss - First release....

  This File is open for changes, feel free to manipulate and play around
  with  it  as  you like.  When done, add a remark to the Version-String
                     above and send me a copy :-) ...


***  This  worked  fine on my mashine...  if it crashes yours - dont't  ***
***  you  try to make me responsible for it - I just tried to do you a  ***
***  favour :^) Th.Strauss                                              ***

*/

/* Additional note: This is not needed if you do the conversion-prccedure
   correctly. It is important, that the converted .doc files can find the
   includes afterwards. Therefore assign include: (with your C_Header_Files)
   before running AD2HT!)

   Voyager

*/

options results
Address "rexx_ced"
open(guides,"dh2:bla","read")
do until eof(guides)
  file=readln(guides)
  'open' "amigaguide:"file
  if result then do
  'beg of file'
  search for ' Link "'
  found=result
  do while found
    status 55
    line=result
    fp = 2
    lp = 1
    killed=1
    do until fp-lp=0
      fp = index(line, '{', lp)
      if fp>0 then do
        lp = index(line, '}', fp)
        if lp>0 then do
          tochange=substr(line, fp, lp-fp)
          if index(tochange, ".h")>0 then do
            if killed=1 then do
              'beg of line'
              'Delete Line'
              killed=2
            end
            line = insert("include:",line,fp+index(tochange, 'Link "')+4)
          end
        end
        else lp=fp
      end
      else lp=fp
    end
    if killed=2 then text line;
    search for ' Link "'
    found=result
  end
  'save as' "amigaguide:n_"file /* Files are stored as n_<name> */
  end
end
close(file)
exit
