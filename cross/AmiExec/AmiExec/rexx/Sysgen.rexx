/**************************************************************************** 

$Source: MASTER:Rexx/Sysgen.rexx,v $
$Revision: 4.0 $
$Date: 1996/11/03 09:35:56 $

An ARexx program to perform System Generation.

Copyright © 1992-1996 by W. John Malone.  All rights reserved.

****************************************************************************/
/****************************************************************************
*                                                                           *
*    *NAME                                                                  *
*        Sysgen.rexx - System Generation utility.                           *
*                                                                           *
*     SYNOPSIS                                                              *
*        Sysgen [MODFILE] <modfile> [DOS <dos> | TERM] [FBUG] [BAUD <baud>] *
*               [BLOCKSIZE <blocksize>] [MAKEALL] [LOCATEALL] [DOWNLOADALL] *
*               [QUIET]                                                     *
*                                                                           *
*        Sysgen.rexx MODFILE/A,DOS/K,TERM/S,FBUG/S,BAUD/K/N,BLOCKSIZE/K/N,  *
*                    MAKEALL/S, LOCATEALL/S, DOWNLOADALL/S,QUIET/S          *
*                                                                           *
*     FUNCTION                                                              *
*        A program to perform System Generation.  This program uses the     *
*        Locate utility to locate multiple AmigaDOS load files              *
*        (executables), one after the other.  The resulting S-Record        *
*        (.mx) files are then downloaded to the specified destination,      *
*        usually a serial port connected to an SBC or EPROM programmer.     *
*                                                                           *
*        Aside from generating the .mx files, this program creates a .map   *
*        file which records the starting addresses, lengths, and time of    *
*        last download for the modules.  This map file is used by           *
*        subsequent invocations of this program to reduce unnecessary       *
*        Locate's and downloads.                                            *
*                                                                           *
*     NOTES                                                                 *
*        The downloading itself is performed by a separate Download         *
*        script invoked by this program.  The script invoked is indicated   *
*        by the keywords passed to this program.  Currently supported       *
*        scripts are Download.dos and Download.term.  The former downloads  *
*        to DOS devices such as SER: or files, the latter to the serial     *
*        port being used by the terminal program 'term'.                    *
*                                                                           *
*        Support for additional terminal programs and/or ROM monitors       *
*        requires straightforward modification of this script. See          *
*        procedure Download() herein.                                       *
*                                                                           *
*     INPUTS                                                                *
*        MODFILE - Required parameter.  This is the name of a module        *
*                  list file with the info to control the system            *
*                  generation.  Each non-blank, non-comment line in the     *
*                  file is one of two forms:                                *
*                                                                           *
*                  LOCATION TEXT <tstart> DATA <dstart> DATABURN <dburn>    *
*                                                                           *
*                  Where:                                                   *
*                    tstart  - where to locate the text section of the      *
*                              modules.  Each module's text section is      *
*                              placed one after the other.                  *
*                    dstart  - where to locate the data section of the      *
*                              modules.  Each module's data section is      *
*                              placed one after the other.                  *
*                    dburn   - this specifies where the data section will   *
*                              actually be downloaded to.  At boot time,    *
*                              the data will be copied from dburn to        *
*                              dstart.  i.e. this is the ROM address        *
*                              whereas dstart is the RAM address.           *
*                                                                           *
*                  or,                                                      *
*                                                                           *
*                  MOD <fullname> [REL <release>] [MAKE <makeflag>          *
*                  HOME <home>]                                             *
*                                                                           *
*                  Where:                                                   *
*                    fullname - is the full file name of a standard         *
*                               AmigaDOS load file.                         *
*                    release  - release number required, e.g. 2.1           *
*                               If the version of the module is older than  *
*                               the specified release, the Sysgen aborts.   *
*                    makeflag - '1' means the module is to be made and      *
*                               hence possibly recompiled and linked.       *
*                               The default is to *not* make the            *
*                               module.                                     *
*                    home     - the full pathname of the modules home       *
*                               directory.                                  *
*                                                                           *
*                               Note that if MAKE is provided, HOME         *
*                               must be provided.  The home directory       *
*                               must contain a makefile such that in        *
*                               the directory the command:                  *
*                                                                           *
*                                make <fullname>                            *
*                                                                           *
*                               will construct the module.                  *
*                                                                           *
*        DOS       - Indicates S-Records are to be downloaded using         *
*                    Download.dos script. The parameter is the name of a    *
*                    file or device the S-Record files are to be copied to. *
*                     e.g. SER:.  Mutually exclusive with the TERM switch.  *
*                    If neither DOS nor TERM is provided provided no        *
*                    downloading takes place.  (Though .mx file creation    *
*                    still does.)                                           *
*                                                                           *
*        TERM      - Switch indicating downloading is to be done by         *
*                    invoking script Download.term.                         *
*                                                                           *
*        FBUG      - Switch passed through to Download scripts.  Indicates  *
*                    target system is running FBUG ROM monitor. Without     *
*                    switch target is assumed to be running AmiExec Debug.  *
*                                                                           *
*        BAUD      - This is the baud rate to use for downloading and is    *
*                    passed through to the Download scripts.                *
*                                                                           *
*        BLOCKSIZE - Starting addresses of modules will be aligned on a     *
*                    multiple of the blocksize. (Unless overridden by       *
*                    the LOCATION keyword)  Specify in decimal bytes.       *
*                    The default is 2048 bytes.  This allows individual     *
*                    modules to change slightly in size without requiring   *
*                    all modules to relocate and re-download.               *
*                                                                           *
*        MAKEALL   - Switch indicating all modules are to be made           *
*                    regardless of their individual makeflags.              *
*                                                                           *
*        LOCATEALL - Switch indicating all modules are to be located.  By   *
*                    default, modules are located only if their ".mx"       *
*                    file is out of date, or if preceding modules have      *
*                    grown or shrunk sufficiently so as to change the       *
*                    module's start address.                                *
*                                                                           *
*        DOWNLOADALL - Switch indicating all modules are to be downloaded.  *
*                      By default, only those modules whose .mx files       *
*                      are more recent than their download timestamp are    *
*                      downloaded.                                          *
*                                                                           *
*        QUIET     - Switch suppressing message display.                    *
*                                                                           *
*     RESULTS                                                               *
*        rc - 0 if all went well.  Supposedly appropriate levels of         *
*             DOS errors if something goes wrong.                           *
*                                                                           *
*     BUGS                                                                  *
*        May have problems with modules that lie on 7FFFFFFF.  See          *
*        procedure AddNRoundHex.                                            *
*                                                                           *
*        The V39 Version command broke release number checking as done      *
*        in response to the REL keyword.  The REL keyword is currently      *
*        ineffective under WB3.0+.                                          *
*                                                                           *
*     SEE ALSO                                                              *
*        Locate, Download.dos, Download.term                                *
*                                                                           *
****************************************************************************/

/* Pseudo-declare compound variables to avoid confusion. */

/*
 * TYPE
 *
 *    (* Modules contains info parsed from the modfile and mapfile. *)
 *   
 *    Modules = RECORD
 *       m_mod   : BT.DynString;       (* full name of module *)
 *       m_file  : BT.DynString;       (* file part of m_mod *)
 *       m_home  : BT.DynString;       (* home directory of module *)
 *       m_hard  : BOOLEAN             (* location of module is fixed *)
 *       m_text  : LONGINT;            (* start address of module's text *)
 *       m_data  : LONGINT;            (* start address of module's data *)
 *       m_dburn : LONGINT;            (* start of burn address of module's data *)
 *       m_tlen  : LONGINT;            (* length of text section *)
 *       m_dlen  : LONGINT;            (* length of data section *)
 *       m_dnld  : BT.DynString        (* time of last download *)
 *    END;
 *
 *
 *    (* Downloads is an array/list of files requiring downloading. *)
 *
 *    Downloads = RECORD
 *       dl_modDex   : INTEGER;        (* index of module in Modules *)
 *       dl_mx       : BT.DynString;   (* name of mx file to download *)
 *    END         
 *
*/


/* Fetch arguments. */

parse arg argstr

template = 'MODFILE/A,DOS/K,TERM/S,FBUG/S,BAUD/K/N,BLOCKSIZE/K/N,MAKEALL/S,'||,
           'LOCATEALL/S,DOWNLOADALL/S,PROMPT/S,QUIET/S'

Args.modfile = ''; Args.dos = ''; Args.term = 0; Args.fbug = 0; Args.baud = 0
Args.blocksize = 2048; Args.makeall = 0; Args.locateall = 0; 
Args.downloadall = 0; Args.prompt = 0; Args.quiet = 0

if argstr = '?' then do
   say template
   exit 5
   end

if ReadArgs(argstr, template, 'Args.') == 0 then do
   say template
   exit 20
   end


/* Initialization type stuff. */

numeric digits 12                /* pointers can be very big */
Modules. = 0
ID = pragma('ID')


/* Collect info about what to do, and what was done last time. */

call CollectModInfo(Args.modfile)
call CollectMapInfo(Args.modfile||'.map')


/* Make the modules as necessary. */

do i = 1 to Modules.0
   if Args.makeall == 1 | Modules.i.m_make == 1 then do
      if Make(i) ~== 1 then exit(20)
      end
   end


/* Check versions as specified. */

do i = 1 to Modules.0
   if Modules.i.m_rel ~= '' then do
      if CheckRelease(Modules.i.m_mod, Modules.i.m_rel) ~== 1 then do
         say 'Sysgen:' Modules.i.m_mod 'failed CheckRelease.'
         exit(20)
         end
      end
   end


/* Locate the modules as necessary.  Note that LocateNeeded *MUST* be
   called for each module, even if LOCATEALL has been specified, because 
   LocateNeeded fills in the section start addresses. */

error = 0
do i = 1 to Modules.0
   if LocateNeeded(i, Args.blocksize, Args.locateall) == 1 then do
      if Locate(i) ~== 1 then do 
         say 'Sysgen: Locate failed.'      
         error = 20 
         leave 
         end
      end
   end


/* Download the modules as necessary. */

if error == 0 & (Args.dos ~= '' | Args.term == 1) then do
   if DoDownloads() ~== 1 then do
      say 'Sysgen: DoDownloads failed.'
      error = 20
      end
   end


/* Write map file. */

call WriteModsMap(Args.modfile||'.map')


/* Cleanup */

'delete >NIL: T:#?'ID

exit(error)


/*-------------------------------------------------------------------------*/

FileObsolete: procedure

/* Function: Determines if a dependent file is obsolete.

   Inputs:   name1    - the file whose obsolescence is being determined
             name2    - the file that name1 is dependent on
             
   Results:  obsolete - 1 if name1 is older than name2, or if name1 does 
                        not exist. */

parse arg name1, name2

stat1 = statef(name1)

if stat1 ~= '' then do
   stat2 = statef(name2)

   /* Combine the days, minutes, and ticks into one number for comparison. */

   stat1 = word(stat1,5)||right(word(stat1,6), 4, '0')||right(word(stat1,7), 4, '0')
   stat2 = word(stat2,5)||right(word(stat2,6), 4, '0')||right(word(stat2,7), 4, '0')

   if stat1 < stat2 then 
      obsolete = 1 
   else 
      obsolete = 0
   end
else do
   obsolete = 1
   end

return obsolete


/*-------------------------------------------------------------------------*/

AddNRoundHex: procedure

/* Function:  Add and round up two hexadecimal numbers.

   Inputs:    x1 - first hex number string
              x2 - second hex number string
              r  - decimal number - result of addition is to be rounded up 
                   to nearest multiple of r.

   Results:   x  - hex number string which is x1 + x2 rounded up to r
                   multiple.

   Bugs:      Does not work if x1 and x2 are both less than 7FFFFFFF yet
              add to 80000000 or greater.  Tough.  Damn function should
              be in a function library anyway (Hmm - should dig up docs
              on rexxmathlib.library.) */

parse arg x1, x2, r


/* Convert the strings to decimal numbers (ARexx does not accept hex numbers, 
   even ARexx hex, as operands for math.)  Note the unsigned arithmetic kludge. */

x1 = x2c(right(x1, 8, 0))
msb_x1 = bittst(x1, 31)
x1 = c2d(bitand(x1, '7FFFFFFF'x))

x2 = x2c(right(strip(x2), 8, 0))
msb_x2 = bittst(x2, 31)
x2 = c2d(bitand(x2, '7FFFFFFF'x))


/* Add and round the numbers, ignoring the possibility of overflow. */

x = x1 + x2
if (r ~= 0) then do
   if (x // r) ~= 0 then do
      x = (x + r) - (x // r)
      end
   end


/* Convert the result back to a hex number. */

x = d2c(x)
if msb_x1 == 1 | msb_x2 == 1 | msb_x == 1 then x = bitset(x, 31)
x = c2x(x)
x = strip(x, 'L', '0')

return x


/*-------------------------------------------------------------------------*/

CollectModInfo: procedure expose Modules.

/* Read the Modules file, and collect the info into the compound variable
   Modules. */

parse arg modfile

if open('file', modfile, 'Read') ~= 1 then do
   say 'Sysgen.CollectModInfo: Bloody hell!  Where''s' modfile'?'
   exit 10
   end

i = 0
do while eof('file') == 0
   str = readln('file')
   if str = '' | left(str, 1) = ';' then iterate

   parse var str 'LOCATION' locstr, 'MOD' mod ., 'REL' release .,
                 ,'MAKE' make 'HOME' home .

   if locstr ~= '' then do
      j = i + 1
      parse var locstr 'TEXT' text ., 'DATA' data ., 'DATABURN' dburn .
      Modules.j.m_hard = 1
      if text = '' then text = 0
      if data = '' then data = 0
      if dburn = '' then dburn = 0
      Modules.j.m_text = strip(text)
      Modules.j.m_data = strip(data)
      Modules.j.m_dburn = strip(dburn)
      end
   else if mod ~= '' then do
      i = i + 1; Modules.0 = i
      Modules.i.m_mod = strip(mod)
      Modules.i.m_home = strip(home)
      Modules.i.m_rel = strip(release)
      Modules.i.m_make = strip(make)

      Modules.i.m_file = FilePart.ext(Modules.i.m_mod)
      end
   end

call close('file')

return


/*-------------------------------------------------------------------------*/

CollectMapInfo: procedure expose Modules.

/* Read the Map file, and collect the info into the compound variable
   Modules. */

parse arg mapfile

if open('file', mapfile, 'Read') ~= 1 then return

i = 0; quit = 0
do while eof('file') == 0 & quit == 0
   str = readln('file')
   if str = '' | left(str, 1) = ';' then iterate

   parse var str mod 'TEXT' text 'DATA' data 'DBURN' dburn 'TLEN' tlen,
                 'DLEN' dlen 'DNLD' time .

   i = i + 1

   if mod ~= Modules.i.m_file then do
      say 'Sysgen.CollectMapInfo: Map file misaligned with Modules file.'
      quit = 1
      end
   else do
      if Modules.i.m_hard ~== 1 then do
         Modules.i.m_text = strip(strip(text), 'L', '0')
         Modules.i.m_data = strip(strip(data), 'L', '0')
         Modules.i.m_dburn = strip(strip(dburn), 'L', '0')
         end
      Modules.i.m_tlen = strip(strip(tlen), 'L', '0')
      Modules.i.m_dlen = strip(strip(dlen), 'L', '0')
      Modules.i.m_dnld = strip(time)
      end
   end

call close('file')

return


/*-------------------------------------------------------------------------*/

WriteModsMap: procedure expose Modules.

parse arg mapfile

if open('file', mapfile, 'Write') ~= 1 then do
   say 'Sysgen.WriteModsMap: Bloody hell!  Where''s' mapfile'?'
   exit 10
   end

maxlen = 0
do i = 1 to Modules.0
   file = Modules.i.m_file
   if length(file) > maxlen then
      maxlen = length(file)
   end

do i = 1 to Modules.0
   str = left(Modules.i.m_file, maxlen) 
   str = str 'TEXT' right(Modules.i.m_text, 8, '0') 
   str = str 'DATA' right(Modules.i.m_data, 8, '0')
   str = str 'DBURN' right(Modules.i.m_dburn, 8, '0')
   str = str 'TLEN' right(Modules.i.m_tlen, 8, '0')
   str = str 'DLEN' right(Modules.i.m_dlen, 8, '0')
   str = str 'DNLD' Modules.i.m_dnld
   call writeln('file', str)
   end

call close('file')

return


/*-------------------------------------------------------------------------*/

Make: procedure expose Modules. Args.

/* Function:  Perform a make of a module.

   Inputs:    modDex  - index into the exposed compound Modules where
                       we can find the name of the module of concern. 

   Results:   success - 1 means successful, 0 not. */

parse arg modDex

if Args.quiet ~= 1 then say 'Making' Modules.modDex.m_mod
'pushcd' Modules.modDex.m_home; 
'Make' Modules.modDex.m_mod; 
if rc = 0 then
   success = 1
else
   success = 0
'popcd'

return success


/*-------------------------------------------------------------------------*/

CheckRelease: procedure expose ID

/* Function: Checks the embedded version number of a module.

   Inputs:   fullname - full name of the module to be checked
             release  - minimal acceptable version number
             
   Results:  ok - 1 means the version is acceptable, 0 not 

   Bugs:     Currently ineffective under WB3.0.  Always returns 1. */


parse arg fullname, release

/* Extract required major and minor version numbers. */

if release = '' then return 1
parse var release reqmaj '.' reqmin .


/* Determine major and minor version numbers of the module. */

'version >T:Sysgen.CheckRelease.'ID fullname FILE
if open('verfile', 'T:Sysgen.CheckRelease.'ID, 'Read') ~= 1 then do
   say 'Sysgen.CheckRelease: Could not open T:Sysgen.CheckRelease'ID
   exit 20
   end

str = readln('verfile'); 
parse var str mod rel .
if rel = '' then return 1              
parse var rel major '.' minor .


/* Compare required vs. actual and set ok as apppropriate. */

if major > reqmaj then
   ok = 1;   
else if major < reqmaj then
   ok = 0
else if minor >= reqmin then 
   ok = 1
else 
   ok = 0
   
call close('verfile')

return ok


/*-------------------------------------------------------------------------*/

LocateNeeded: procedure expose Modules.

/* Function: Determines if a module needs locating.  There are three reasons
             a module may need relocation: (a) the AmigaDOS load file is more 
             recent than the .mx file. (b) Previous modules have grown
             or shrunk sufficiently so as to change the start address of
             the module.  (c) the LOCATEALL switch.

             This procedure has a rather crucial side effect in that as it
             is determining if a Locate is needed, it fills in the module's
             start addresses.  

   Inputs:   modDex     - index into the exposed compound Modules. where info
                          on the module of concern is stored.
             blocksize  - module start addresses are rounded up to the nearest 
                          multiple of this decimal number - unless they have
                          a hard start address.
             locateall  - the LOCATEALL switch.  1 means this function will
                          return 1.  0 means this function will make up its
                          own mind.

   Results:  locate - 1 means a Locate is needed, 0 not needed. */

parse arg modDex, blocksize, locateall

locate = locateall

/* The start and length of module modDex-1 determines the start of module
   modDex - unless module modDex has hard start addresses in which case
   CollectModInfo has already initialized the addresses. */

if Modules.modDex.m_hard == 0 then do
   i = modDex - 1
   tstart = AddNRoundHex(Modules.i.m_text, Modules.i.m_tlen, blocksize)
   dstart = AddNRoundHex(Modules.i.m_data, Modules.i.m_dlen, blocksize)
   dbstart = AddNRoundHex(Modules.i.m_dburn, Modules.i.m_dlen, blocksize)
   if Modules.modDex.m_text ~== tstart | Modules.modDex.m_data ~== dstart | Modules.modDex.m_dburn ~== dbstart then do
      Modules.modDex.m_text = tstart
      Modules.modDex.m_data = dstart
      Modules.modDex.m_dburn = dbstart
      locate = 1
      end
   end


/* Check for obsolete mx file. */

if locate == 0 then do
   mx = Modules.modDex.m_file||'.mx'
   load = Modules.modDex.m_mod
   locate = FileObsolete(mx, load)
   end

return locate


/*-------------------------------------------------------------------------*/

Locate: procedure expose Modules. Args. ID

/* Function: Uses the Locate utility to produce a file of Motorola
             S-Records representing the memory image of a located
             DOS load file.

   Inputs:   modDex    - index into compound Modules. where module name,
                         start addresses etc. can be found.

   Results:  success   - 1 means success, 0 failure. */
                     
parse arg modDex, blocksize


/* Perform the location, redirecting the output of the section lengths
   to a temp file. */

cmd = 'Locate >T:Locate.'ID Modules.modDex.m_mod Modules.modDex.m_file'.mx' 
cmd = cmd 'TEXT' Modules.modDex.m_text 'DATA' Modules.modDex.m_data 
cmd = cmd 'DATABURN' Modules.modDex.m_dburn
if Args.quiet ~== 1 then say 'Locating' Modules.modDex.m_mod
cmd
if rc ~= 0 then return 0


/* Extract the section sizes from the listing file. */

if open('file', 'T:Locate.'ID, 'Read') ~= 1 then do
   say 'Sysgen.Locate: Unable to open T:Locate.ls.'ID
   return 0
   end

str = readln('file')
parse var str 'TEXTLEN' tlen 'DATALEN' dlen
call close('file')


/* Record the section lengths in Modules. */

Modules.modDex.m_tlen = strip(tlen, 'L', ' 0')
Modules.modDex.m_dlen = strip(dlen, 'L', ' 0')

return 1


/*-------------------------------------------------------------------------*/

DownloadNeeded: procedure expose Args. Modules.

/* Function: Determines if a module needs downloading.  A module needs
             downloading if its .mx file is more recent than its last
             download.

   Inputs:   modDex       - index into the exposed compound Modules. where info
                            on the module of concern is stored.

   Results:  download     - 1 means the module needs downloading, 0 not needed. */

parse arg modDex

if Args.downloadall == 1 then return 1 

mx = Modules.modDex.m_file'.mx'
stat = statef(mx)

if stat == '' then do
   say 'Sysgen.DownloadNeeded: Statef failed on' mx
   exit(20)
   end

/* Statef returned the timestamp of the mx file with words 5, 6 and 7
   containing days, minutes and ticks respectively.  The time of the
   last download is recorded as a single number constructed by
   concatenating days and seconds.  Convert the statef result so
   a comparison can be performed. */

t_mxdays = word(stat, 5)
t_mxseconds = word(stat, 6) * 60 + word(stat, 7) % 50
t_mx = t_mxdays||right(t_mxseconds, 5, 0)
 
if t_mx > Modules.modDex.m_dnld then
   download = 1
else
   download = 0

return download


/*-------------------------------------------------------------------------*/

Download: procedure expose Args. Modules. Downloads. ID

/* Function: Downloads modules.  The names of the modules to download are
             provided in the exposed stem variable Downloads. Downloading
             is done by invoking the appropriate Download.#? script as
             indicated by Args. 

   Result:   success    - 1 means success, 0 failure. */


/* Create a temp file containing the termination record. */

'echo > T:S7.mx'ID 'S70500100000EA'


/* Allow user a chance to ensure target is ready. */

if Args.prompt == 1 then do
   modDex = Downloads.1.dl_modDex
   say 'Press ENTER when target is ready to receive modules located at '||,
       Modules.modDex.m_text'.'
   pull
   end


/* Construct a string consisting of the file names to be downloaded.
   Include as the last file the termination record file.  */

files = ''
do i = 1 to Downloads.0
   files = files Downloads.i.dl_mx
   end
files = files 'T:S7.mx'ID


/* Do the downloading by invoking the appropriate script. */

if Args.dos ~= '' then do
   'Download.dos' dos files
   end
else if Args.term == 1 then do
   cmd = 'Download.term'
   if Args.baud > 0  then cmd = cmd 'BAUD' Args.baud
   if Args.fbug == 1 then cmd = cmd 'FBUG'
   cmd files
   end
   

/* Record the time of the download (if it was successful). */

if (rc == 0) then do
   do i = 1 to Downloads.0
      modDex = Downloads.i.dl_modDex
      Modules.modDex.m_dnld = date('INTERNAL')||right(time('SECONDS'), 5, 0)
      end
   success = 1
   end
else do
   say 'Sysgen.Download: Failed.'
   success = 0
   end

return success


/*-------------------------------------------------------------------------*/

DoDownloads: procedure expose Args. Modules. ID

/* Function: Downloads whatever modules need downloading.  Modules are 
             downloaded in batches with a module on a 'hard' location 
             starting a new batch. 

   Result:   success - 1 if successful, 0 on failure

   See Also: DownloadNeeded, Download */


success = 1                               /* assume success */
Downloads.0 = 0                           /* empty */

do i = 1 to Modules.0 while success == 1

   if Modules.i.m_hard == 1 & Downloads.0 > 0 then do
      success = Download()
      Downloads.0 = 0
      end

   if DownloadNeeded(i) == 1 then do
      j = Downloads.0; j = j + 1; Downloads.0 = j
      Downloads.j.dl_modDex = i
      Downloads.j.dl_mx = Modules.i.m_file'.mx'
      end
   end

if Downloads.0 > 0 & success == 1 then
   success = Download()

return success
