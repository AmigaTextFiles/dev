/* $VER: 0.9, ©1994 BURGHARD Eric.                  */
/*   Find reference of requested word under GOLDED  */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (left(address(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

if exists("ENV:OldFunc") then do
  ok=open(readhandle,"ENV:OldFunc","read")
  oldfunc=readln(readhandle)
  ok=close(readhandle)
end
else oldfunc=""
'REQUEST TITLE="Autodocs Help" BODY="Type searched name" BUTTON="Search|Cancel" STRING OLD="'oldfunc'" VAR WORD'
if rc~==0 then do
  'UNLOCK'
  exit
end

address command 'SetEnv OldFunc 'result''

if word = '' then do
    'UNLOCK'
    exit
end

if word='main' then address command 'Run >NIL: AmigaGuide Autodocs.guide'
else do

  if ~show('L','amigaguide.library') then call addlib('amigaguide.library',0,-30)

  xrfline = GetXRef("OpenWindow()")
  if xrfline = 10 then do
     'REQUEST STATUS=" Loading Autodocs.xref... Please Wait"'
     ok = LoadXRef(autodocs.xref)
     'REQUEST STATUS=""'
  end

  xref = 0
  symbol = ""
  node = ""
  line = 0
  function = word

  xrfline = GetXRef(function)
  if xrfline = 10 then do
    function = word||"()"
    xrfline = GetXRef(function)
    if xrfline = 10 then do
       function = word
    end
    else do
        parse var xrfline '"' symbol '" "' node '" ' type ' ' line
        xref = 1
    end
  end
  else do
      parse var xrfline '"' symbol '" "' node '" ' type ' ' line
      xref = 1
  end

  if ~show('P','AUTODOCS') then do
    if xref = 0 then do
      if Exists('GUIDEDEVICE:AutoDocs/'function'') then cmd = 'Run >NIL: AmigaGuide 'function' PORTNAME AUTODOCS'
      else do
        'REQUEST STATUS="'||word||' is not referenced"'
        'UNLOCK'
        exit
      end
    end
    else cmd = 'Run >NIL: AmigaGuide DOCUMENT 'function' PORTNAME AUTODOCS LINE 'line''
    ADDRESS COMMAND cmd
  end
  else do
    if xref = 0 then do
      if exists('GUIDEDEVICE:AutoDocs/'function'') then cmd = 'Link 'function'/main 'line''
      else do
        'REQUEST STATUS="'||word||' is not referenced"'
        'UNLOCK'
        exit
      end
    end
    else cmd = "Link 'function' 'line'"
    ADDRESS AUTODOCS cmd
    ADDRESS AUTODOCS 'windowtofront'
  end
end
'UNLOCK'
exit

SYNTAX:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

