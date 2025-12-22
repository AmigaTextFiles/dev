/*
 * script for aee: show a part of file
 *
 * Parameters:
 *
 * conline    - the definition of the console window, e.g.
 *              CON:0/0/320/142/title/WAIT/CLOSE
 * filename - the file to show
 * startline  - number of line to start with printing; may be FULL; set to
 *              FULL if obmitted
 * endline    - linenumber to stop, ignored when startline=FULL
 *
 * The console will be opened and the desired part will be shown.
 *
 * written on January 19th by Gregor Goldbach
 * placed in the public domain
 */

arg conline filename startline endline

if ~exists(filename) then do
  say 'no file of that name, 'filename' could not be loaded.'
  return 20
end

if startline="" then startline="FULL"

open(conni, conline,"W") /* open the con: window */

Open(text,filename,"R")

if startline="FULL" then do

  do until eof(text)
    zeile=ReadLn(text)
    writeln(conni, zeile)
  end
end
if (endline>startline) then do

  do count=1 to startline  /* skip some lines */
    zeile=readln(text)
  end count

  do c