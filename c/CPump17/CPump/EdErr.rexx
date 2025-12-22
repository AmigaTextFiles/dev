/* this ARexx invokes ed on error line selected by CTagSel */
arg errfile

/* show a ListView gadget of the functions and get selection */
address command 'CTagSel <' errfile
if RC > 0 then exit RC
selec=getclip('CTagSel')
tempfl=puttemp('m'||word(selec,4))
address command 'run Ed' word(selec,5) 'with' tempfl
exit 0

/* a subroutine to put a string in a temporary work file */
puttemp:
  arg x
  tfil='ram:temp1.txt'
  i=open('temp1',tfil,'W')
  i = writeln('temp1',x)
  i=close('temp1')
  return tfil

