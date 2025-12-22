/*************************************************************
 * Snevl's ARexx implementation of rcsfreeze.sh
 *
 * rcsfreeze - assign a symbolic revision number to a
 * configuration of RCS files
 *
 * $Id$
 *
 * The idea is to run rcsfreeze each time a new version is 
 * checked in. A unique symbolic revision number (C_[number], 
 * where number is increased each time rcsfreeze is run) is 
 * then assigned to the most recent revision of each RCS file
 * of the main trunk.
 *
 * If the command is invoked with an argument, then this
 * argument is used as the symbolic name to freeze a config-
 * uration. The unique identifier is still generated and is 
 * listed in the log file but it will not appear as part of
 * the symbolic revision name in the actual RCS file. A log
 * message is requested from the user which is saved for future
 * references.
 *
 * The shell script works only on all RCS files at one time.
 * It is important that all changed files are checked in (there
 * are no precautions against any error in this respect).
 *
 * file names:
 *    RCS/rcsfreeze.ver	version number
 *    RCS/rscfreeze.log	log messages, most recent first
 ***************************************************************/

parse arg SYMREVNAME

if SYMREVNAME ~= "" then
   if datatype(left(SYMREVNAME,1)) ~= CHAR then do
      say "*** ERROR: Unfortunately, RCS only accepts symbolic names"
      say "           that start with a letter, so" SYMREVNAME
      say "           is not acceptable."
      exit
   end

date=date()
 /* Check whether we have an RCS subdirectory, so we can have */
 /* the right prefix for our paths. */
 /* SNEVL NOTE: This doesn't work if RCS is a file instead of */
 /* a directory. The 'exists()' doesn't know the difference   */
if exists("RCS") then
   RCSDIR = "RCS/"
else
   RCSDIR = ""

/* Version number stuff, log message file */
VERSIONFILE=RCSDIR || "rcsfreeze.ver"
LOGFILE=RCSDIR || "rcsfreeze.log"

/* Initialize, rcsfreeze never run before in the current directory */
if ~exists(VERSIONFILE) then do
   check = open('ver',VERSIONFILE,'w')
   if check ~= 1 then exit
   check = writeln('ver','0')
   check = close('ver')
end

check = open('ver',VERSIONFILE,'r')
if ~check then exit
VERSIONNUMBER = readln('ver')
check = close('ver')

/* Symbolic Revision Number */
SYMREV="C_" || VERSIONNUMBER
/* Allow the user to give a meaningful symbolic name to the revision. */
if SYMREVNAME = "" then 
   SYMREVNAME = SYMREV
   
say "rcsfreeze: Assign a symbolic name/number to entire RCS baseline"
say ""
say "    symbolic revision number computed: " SYMREV
say "    symbolic revision number used:     " SYMREVNAME
say ""
say "these two differ only when rcsfreeze invoked with argument"
say ""
options prompt "OK to use these? (Y/N)"
parse upper pull ans
ans = left(ans,1)
if ans ~= 'Y' then do
   say "Re-issue the rcsfreeze command, giving the symbolic name"
   say "you want to use as the argument to rcsfreeze."
   exit
end

say "give log message, summarizing changes (end with single '.')"

check = open('ver',VERSIONFILE,'w')
VERSIONNUMBER = VERSIONNUMBER + 1
check = writeln('ver',VERSIONNUMBER)
check = close('ver')

/* Stamp the logfile. Because we order the logfile the most recent */
/* first we will have to save everything right now in a temporary file. */
TMPLOG="t:rcsfrz" || address()

check = open('tmp',TMPLOG,'w')

/* Now ask for a log message, continously add to the log file */
outline = "Version:" SYMREVNAME "(" || SYMREV || "), Date:" DATE
check = writeln('tmp',outline)
check = writeln('tmp',"-------------")
options prompt ">"
do forever
  parse pull inline
  if inline = "." then break
  check = writeln('tmp',inline)
end

check = writeln('tmp',"-------------")

if exists(LOGFILE) then do
   check = open('log',LOGFILE,"r")

   do until EOF('log')
      line = readln('log')
      check = writeln('tmp',line)
   end
   check = close('log')
end

check = close('tmp')

'copy' TMPLOG LOGFILE

'delete' TMPLOG

/* Now the real work begins by assigning a symbolic revision number */
/* to each rcs file. Take the most recent version of the main trunk. */

status=0

files = showdir(RCSDIR,'f',' ')
rlogfile = "ram:rlog." || address()
say "Checking for locked files..."
do i=1 to words(files)
   file = word(files,i)
   if right(file,2) = ",v" then do
      'rlog -h' file '>' rlogfile
      check = open('header',rlogfile,'r')
      do while ~eof('header')
        line = readln('header')
        /* get the revision number of the most recent revision */
	 if left(line,5) = 'head:' then do
           rev.i = word(line,2)
	 end 
	 if word(line,1) = 'locks:' then do
           /* make sure no files are checked out */
           locker = word(readln('header'),1)
           if locker ~= "access" then do
              say "rcsfreeze: **** file" file "is locked by" locker
              say "rcsfreeze: **** NO FREEZE DONE ****"
              exit 10
	    end
           break;
	 end 
      end
      check = close('header')
   end
end
say "No files checked out."
say ""
say "Freezing baseline under symbolic name:" SYMREVNAME
do i=1 to words(files)
   file = word(files,i)
   if right(file,2) = ",v" then do
      say "   freezing" file "(" || rev.i || ")"
      'rcs -q -n' || SYMREVNAME || ':' || rev.i file
      status = rc
      if status then break
   end
end
exit status
