/*   $VER: 1.0, ©1994 BURGHARD Eric                                      */
/*   Generate E Source of GadToolsBox GUI file with ScrGen and Load it.  */
/*           Change path to your gadtoolsbox gui files.                  */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

path='PROGDEVICE:Tools/GadToolsBox_v2.0c/GUI/'

'REQUEST TITLE="Choose GUI File" PATH="'path'" FILE VAR GUIFILE'
if rc~=0 then do
    'REQUEST STATUS=" Can''t generate source file !"'
    'UNLOCK'
    exit
end
guifile=left(guifile,length(guifile)-4)
address command
'EDEVICE:SrcGen >NIL: 'guifile''
efile=''guifile'.e'
if index(efile,':')~=0 then parse var efile temp ":" efile
do while index(efile,'/')~=0
    parse var efile temp "/" efile
end

'Copy 'guifile'.e EDEVICE:Sources/'efile' QUIET'
'Delete 'guifile'.e QUIET'
address
'REQUEST BODY="Source file generated ! Load Source ?" BUTTON="_Load|_cancel"'
if result==1 then 'OPEN NEW NAME="EDEVICE:Sources/'efile'"'
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

