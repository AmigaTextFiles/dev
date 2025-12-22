/*
** get_EAutoGuide.rexx, written by Sven Steiniger
**
** This arexx-skript is based on the ideas of
**  Eric BURGHARD's ged_guideref.rexx.
*/

ARG auto_path

options results

if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'
if rc then exit
options failat 6
signal on syntax

'QUERY WORD VAR WORD'
if word = '' then do
  'REQUEST TITLE="AutoGuide Request" BODY="Type searched keyword" BUTTON="Search|Cancel" STRING VAR word'
  if rc~==0 then do
    'REQUEST STATUS=" No word to search !"'
    'UNLOCK'
    exit
  end
end

if ~show('L','amigaguide.library') then call addlib('amigaguide.library',0,-30)

'REQUEST STATUS=" Scanning E_AutoGuide... Please Wait"'
ADDRESS "REXX"
Open("DirFile",""auto_path"/E_AutoGuide.ref","R")

/* Every line of the .ref file constists of to parts: the keyword and the node.
** The parts are separated with a space.
** The loop scans the .ref file and if he found a match he stores the node.
*/

node=""
do while ~EOF("DirFile") & node=""
  zeile=ReadLn("DirFile")
  parse var zeile pword " " pnode
  if COMPARE(pword,word)=0 then node=pnode
end
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'REQUEST STATUS=""'
if node="" then do
  'REQUEST STATUS="'word' is not referenced"'
  'UNLOCK'
  exit
end

'QUERY SCREEN VAR SCREEN'

if ~show('P','AUTODOCS') then do
  /* No Amigaguide process running. Create new one with port name 'AUTODOCS' */
  cmd = 'run >NIL: amigaguide database "'auto_path'/e_autoguide.guide" DOCUMENT 'node' PORTNAME AUTODOCS PUBSCREEN 'screen''
  ADDRESS COMMAND cmd
end
else do
  /* Amigaguide viewer already running. Signal that we wanna show a new node. */
  cmd = 'Link 'node''
  ADDRESS AUTODOCS cmd
  ADDRESS AUTODOCS 'windowtofront'
end

'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'UNLOCK'
exit
