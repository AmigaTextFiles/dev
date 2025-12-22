/* */

l="rmh.library";if ~show("L",l) then;if ~addlib(l,0,-30) then exit
l="freedb.library";if ~show("L",l) then;if ~addlib(l,0,-30) then exit

parm.0.value="CD0"
if ~ReadArgs("DEVICE") then do
    call PrintFault()
    exit
end

res=FREEDBGetLocalDisc("disc",parm.0.value)
if res==75 then do
    say FREEDBGetString(res) "["disc.0.discid"]"
    do i=0 to disc.num-1
        say i+1"/"disc.num":" disc.i.categ":" disc.i.artist"/"disc.i.title
    end
    exit
end
if res~=0 then do
    say "Error:" FREEDBGetString(res)
    exit
end

say "DiscID:" disc.DiscID
say " Categ:" disc.Categ
say " Title:" disc.Title
say "Artist:" disc.Artist
say "Tracks:" disc.NumTracks
if disc.Genre~="" then say " Genre:" disc.Genre
if disc.Extd~="" then say "  Extd:" disc.Extd
if disc.Year~=0 then say "  Year:" disc.Year

say

do i=0 to disc.NumTracks-1
    say i+1": Title:" disc.i.Title
    if disc.i.Extd~="" then say i": Extd:" disc.i.Extd
    if disc.i.Artist~="" then say i": Artist:" disc.i.Artist
end
exit

format: procedure
parse arg t,s,c,w
    if arg(2,'o') then s=2
    if arg(3,'o') then c=" "
    if arg(4,'o') then w="R"
    else w=upper(w)
    if w="R" then return right(copies(c,s)||t,s)
    else return left(t||copies(c,s),s)
