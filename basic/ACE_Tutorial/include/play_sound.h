{ 
  << play a sound file! >>

  Currently handles IFF 8SVX format.
  If format is unknown, a default 
  sampling rate is assumed. 
  
  Author: David J Benn
    Date: 6th,7th April,16th May,
	  30th June,
	  1st,3rd,4th,8th July,
	  22nd November 1992,
	  7th January 1993
}

library exec

declare function AllocMem& library exec
declare function FreeMem   library exec
declare function xRead&	   library dos

const NOTOK=-1
const OK=0

longint offset&,samples_per_second&

SUB parse_sample(f$)
shared offset&,samples_per_second&
const default_rate=10000&

 { if IFF 8SVX sample, return
   offset from start of file to
   sample data and sampling rate in
   samples per second. }

 open "I",1,f$

 '..FORM#### ?
 dummy$ = input$(8,#1)

 '..8SVX ?
 x$ = input$(4,#1)
 if x$="8SVX" then
   sample_format$="IFF 8SVX"

   '..skip VHDR###
   dummy$ = input$(8,#1)

   '..skip ULONGs x 3 
   dummy$ = input$(12,#1)

   '..get sampling rate bytes
   hi%=asc(input$(1,#1))  '..high byte
   lo%=asc(input$(1,#1))  '..low byte
   samples_per_second&=hi%*256 + lo%

   '..find BODY
   '..skip rest of Voice8Header structure
   dummy$ = input$(6,#1)

   offset&=40  '..bytes up to this point
   repeat 
    repeat
      x$=input$(1,#1)
      offset&=offset&+1
    until x$="B" and not eof(1)
    if not eof(1) then
      body$=input$(3,#1)
      offset&=offset&+3
    end if
   until body$="ODY" and not eof(1) 

   if not eof(1) then
     x$=input$(4,#1)  '..skip ####   
     offset&=offset&+4
   else
     close 1
     parse_sample=NOTOK
     exit sub
   end if
   close 1
 else
   close 1
   sample_format$="unknown"
   offset&=0
   samples_per_second&=default_rate
   parse_sample=OK
 end if

END SUB


SUB play_sound(f$)
shared offset&,samples_per_second&
const maxsample=131070
const channel=1

dim   wave_ptr&(100)

'..file size?
open "I",1,f$
f_size&=lof(1)
close 1

if f_size&=0 then 
  play_sound=NOTOK
  library close exec
  exit sub
end if

'..parse the sample
if parse_sample(f$) = NOTOK then
  play_sound=NOTOK
  library close exec
  exit sub
end if
 
'..get the sample bytes
buffer&=AllocMem(f_size&,MEMF_CHIP) '...f_size& bytes of CHIP RAM
if buffer& = NULL then 
  avail&=fre(MEMF_CHIP)  '..max. contiguous CHIP RAM
  play_sound=NOTOK
  library close exec
  exit sub
end if

'..read whole sample
open "I",1,f$  
fh&=handle(1)
if fh&=0 then clean.up
bytes&=xRead(fh&,buffer&,f_size&)
close 1

'..calculate period
per& = 3579546 \ samples_per_second&  
  
'...setup waveform table for voice 0
sz&=f_size&-offset&

if sz& <= maxsample then
  '..play it in one go
  wave channel,buffer&+offset&,sz&
  dur&=.279365*per&*bytes&/1e6*18.2
  sound per&,dur&,,channel
else
  segments&=sz&\maxsample
  buf&=buffer&+offset&

  '..get the segment pointers
  for i&=0 to segments&
    wave_ptr&(i&)=buf&+maxsample*i&
  next

  '..play sample in segments
  for i&=0 to segments&
    if sz& >= maxsample then 
       wave channel,wave_ptr&(i&),maxsample 
       bytes&=maxsample
    else 
       wave channel,wave_ptr&(i&),sz&
       bytes&=sz&
    end if
    dur&=.279365*per&*bytes&/1e6*18.2
    sound per&,dur&,,channel
    sz&=sz&-maxsample
  next   
end if
  
clean.up:
 FreeMem(buffer&,f_size&)
 library close exec

 play_sound=OK

END SUB
