/*

This script takes an autodoc file and prints out the names of the functions
that are described in the following way:

#autodocname filename/
Function1 linestart
Function2 linestart
...
FunctionN linestart

The filename is either the name of the library or the name of the datatype.

With this script you are able to generate your own autodoc reference files
for easy lookup with EE

first draft by Gregor Goldbach in May 1995

*/

options results

PARSE arg filename

linenumber = 0

Open(handle, filename, "R")
zeile = ReadLn(handle)
linenumber = 1

if zeile="TABLE OF CONTENTS" then do
  zeile = ReadLn(handle) /* skip blank line */
  count = 0

  linenumber=2

  do forever
    zeile.count = ReadLn(handle)
    if zeile.count = "" then break
    function.count = SubStr(zeile.count, Index(zeile.count, "/")+1)
    if Left(function.count,2)="--" then count = count-1
    count = count+1
    linenumber = linenumber+1
  end
end

number_of_functions = count

Close(handle)
Open(handle,filename,"R")
do count=1 to number_of_functions
  newline =readln(handle)
end

do count = 0 to number_of_functions-1
  if count=0 then say "#"filename

  newline = ReadLn(handle)
  linenumber = linenumber+1

  do until Compare(Substr(newline, 2,Length(zeile.count)),zeile.count)=0
    newline = ReadLn(handle)
    linenumber = linenumber+1
    if eof(handle) then break
  end

  if ~eof(handle) then say function.count linenumber
end
