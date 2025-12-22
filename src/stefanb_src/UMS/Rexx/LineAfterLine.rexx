/* $VER: LineAfterLine.rexx 1.0 */

parse arg filename num

if ~open(file,filename,"R") then exit 20
line = 1
do until eof(file)
  str = readln(file)
  if line = num then say str
  line = line + 1
end
call close(file)
