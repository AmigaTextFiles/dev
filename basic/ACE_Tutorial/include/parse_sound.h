{ 
  << parse a sound file and return 
     offset (in bytes) of sample data 
     start and sampling rate. >>

  Currently handles IFF 8SVX format.
  If format is unknown, a default 
  sampling rate is assumed. 
  
  Author: David J Benn
    Date: 6th,7th April,16th May,
	  30th June,
	  1st,3rd,4th,8th July 1992,
	  7th January 1992
}

library exec

declare function AllocMem& library exec
declare function FreeMem   library exec
declare function xRead&	   library dos

longint offset&,samples_per_second&

SUB parse_sample(f$)
shared offset&,samples_per_second&
const default_rate=10000&
const NOTOK=-1
const OK=0

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
     library close exec
     exit sub
   end if
   close 1
 else
   close 1
   sample_format$="unknown"
   offset&=0
   samples_per_second&=default_rate
   parse_sample=OK
   library close exec
 end if

END SUB

SUB calc_period&(samples_per_second&)
  calc_period& = 3579546 \ samples_per_second&  
END SUB

SUB calc_duration(per&,bytes&)  
  calc_duration=.279365*per&*bytes&/1e6*18.2
END SUB
