/*
 * Ecompile.ced - version 1.00 (31-Mar-93) (c)1993 Leon Woestenberg
 * ~~~~~~~~~~~~
 *              - Thanks to Wouter van Oortmerssen (for AmigaE of course!)
 *              - Thanks to Rick Younie for previous script adaption!
 *              - Thanks to Jeroen Steenblik for ARexx reference support!
 *
 * Function: Calls the E Compiler from your source editor CygnusEditor.
 * ~~~~~~~~~
 * Features: - Compile your E sources with the touch of a key...
 * ~~~~~~~~~ - Errors are being reported within CygnusEditor! You don't have
 *             to switch screens to see where your coding wrong.
 *
 * Description: Your source is first saved if it was changed since last save.
 * ~~~~~~~~~~~~ Then the E compiler flies over your code. The error report of
 *              the compiler (if there is one :o) is redirected to T:. Then
 *              CEd will jump to the spot of error, showing the errormessages
 *              in a neat requester within CEd!
 *
 * Installation: Just copy this script to your REXX: dir and then add a
 *               ARexx script in CygnusEditor under one of the functionkeys,
 *               which runs this script: 'REXX:Ecompile' That's all folks!
 *
 * Bugs: No real bugs found, but a few things to take notice of:
 * ~~~~~ - This ARexx script interprets Ecompiler 2.1b errormessages properly,
 *         if future Ecompiler outputs different errorreports, this script
 *         needs adaption!
 *
 * Bugreports or/and any ideas to: Leon Woestenberg
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Langenhof 62
 *                                 5071 TP Udenhout
 *                       Internet: leon@stack.urc.tue.nl
 *      Internet Relay Chat (IRC): 'LikeWise' on #amiga
 *
 * Settings: Set the AmigaE Compiler Path properly (See below)
 * ~~~~~~~~~
 * AmigaE Compiler Path */
/* ~~~~~~~~~~~~~~~~~~~~ */
ec = 'run:ec21b >T:Eerror -e'  /* <<<<<<<< Set your personal path here */

signal on error

address 'rexx_ced'
options results

/* find filepath */
/* ~~~~~~~~~~~~~ */

status 19
filepath = result

/* save file if changed */
/* ~~~~~~~~~~~~~~~~~~~~ */

status 18
if result ~= 0 then do
  save filepath
end

/* compile */
/* ~~~~~~~ */

parse var filepath nosuffix '.e'
address command failat 1000000
address command ec nosuffix
exit 0

error:
errorline = rc
jump to line errorline

ok = open(filehandler,'T:Eerror','Read')
if ok = 0 then do
  okay1 'Could not read EC error messagefile.'
  exit 0
end
else do
  linestring=''
  withstring=''
  errorstring=''
  errortext=''
  dummy = readln(filehandler)
  dummy = readln(filehandler)
  do while ~eof(filehandler)
    line  = readln(filehandler)
    subline = substr(line,1,12)
    /* index does the trick :o) */
    /* ~~~~~~~~~~~~~~~~~~~~~~~~ */
    if index(subline,'ERROR:') ~= 0 then do
      parse var line dummy ': ' errorstring
    end
    if index(subline,'WITH:') ~= 0 then do
      parse var line dummy ': ' withstring
      withstring=strip(withstring)
    end
    if index(subline,'LINE ') ~= 0 then do
      parse var line dummy ': ' linestring
      linestring=strip(linestring)
    end
  end
  errortext='Line '||errorline
  if linestring ~= '' then do
    errortext = errortext||': '||linestring
  end
  if errorstring ~= '' then do
    errortext = errortext||'0a'x||'Error: '||errorstring
  end
  if withstring ~= '' then do
    errortext = errortext||'0a'x||'With : '||withstring
  end
  okay1 errortext
end
ok = close(filehandler)
exit 0

