/* this ARexx invokes ed on file/function selected by CTagSel */
sav1=word( arg(1),1 )
sav2=word( arg(1),2 )
if sav1 = 'Bld' then address command 'CTags >tags1.tags -sw #?.(c|cxx|cc)'

/* show a ListView gadget of the functions and get selection */
address command 'CTagSel <tags1.tags'
if RC > 0 then exit RC
selec=getclip('CTagSel')
select
  when sav2 = 'ED' then do
    tempfl=puttemp('m'||word(selec,2))
    address command 'run' sav2 word(selec,3) 'with' tempfl
    end
  when sav2 = 'MEmacs' then
    address command 'run' sav2 word(selec,3) 'goto' word(selec,2)
  otherwise
    address command 'run' sav2 word(selec,3)
  end
exit 0

/* a subroutine to put a string in a temporary work file */
puttemp:
  arg x
  tfil='ram:temp1.txt'
  i=open('temp1',tfil,'W')
  i = writeln('temp1',x)
  i=close('temp1')
  return tfil

