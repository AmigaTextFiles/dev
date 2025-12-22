/* */

l="rmh.library";if ~show("L",l) then;if ~addlib(l,0,-30) then exit
l="freedb.library";if ~show("L",l) then;if ~addlib(l,0,-30) then exit

parms.0.value="CD0"
if ~ReadArgs("DEVICE") then do
    call PrintFault()
    exit
end

res=FREEDBTOC(parms.0.value,"toc")
if res>0 then do
    say "Can't read TOC of '"parms.0.value"'" CDDBGetString(res)
    exit
end

say "Tracks:" toc.NumTracks "["toc.FirstTrack"-"toc.LastTrack"]"
say " Addrs:" toc.StartAddr"-"toc.EndAddr "["toc.Frames"]"
say "  Time:" format(toc.Min,,0)":"format(toc.Sec,,0)","format(toc.Frame,,0)
say "DiskID:" toc.DiscID
say

do i=0 to toc.NumTracks-1
    say "Track:" toc.i.Track
    say "Addrs:" toc.i.StartAddr"-"toc.i.EndAddr "["toc.i.Frames"]"
    say " Time:" format(toc.i.Min,,0)":"format(toc.i.Sec,,0)","format(toc.i.Frame,,0) "["format(toc.i.StartMin,,0)":"format(toc.i.StartSec,,0)","format(toc.i.StartFrame,,0) format(toc.i.EndMin,,0)":"format(toc.i.EndSec,,0)","format(toc.i.EndFrame,,0)"]"
    say "Flags:" "Audio:"toc.i.Audio "ADR:"toc.i.ADR "CopyPerm:"toc.i.CopyPerm "PreEmphasis:"toc.i.PreEmphasis "4Channels:"toc.i.FourChannels
    say
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
