/**/

l="rmh.library";if ~show("L",l) then;if ~addlib(l,0,-30) then exit
l="freedb.library";if ~show("L",l) then;if ~addlib(l,0,-30) then exit

if ~ReadArgs("ID/K,C=CATEG/K,T=TITLE/K,A=ARTIST/K,TI=TITLES/K") then do
    call PrintFault()
    exit
end

if parm.0.flag then ma.DiscID=parm.0.value
if parm.1.flag then ma.Categ=parm.1.value
if parm.2.flag then ma.Title=parm.2.value
if parm.3.flag then ma.Artist=parm.3.value
if parm.4.flag then ma.TTITLES=parm.4.value

call FreeDBMatch("ma")
do i=0 to ma.num-1
    say i":" "DiscID:"ma.i.DiscID "Categ:"ma.i.Categ "Title:"ma.i.Title "Artist:"ma.i.Artist
end

