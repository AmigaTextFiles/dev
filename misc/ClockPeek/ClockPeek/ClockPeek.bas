Rem HiSoft Power BASIC clock test
Rem Simon N Goodwin December 1999

Rem For A500, most A2000 & A1200s
Rem with OKI or MSM 6242 RT clock

base&=&hDC0001 ' &hD80001 on A2000A
bus%=32 ' 32 for A1200, 16 if older

locate 2,2:print "Tap LMB to quit"
repeat pollster
  for i=0 to 1.5*bus% step bus%/8
  locate 2,66-i
    print 15 and peek(i+base&);
  next i
  if mouse(0) then exit pollster
end repeat pollster
system  

