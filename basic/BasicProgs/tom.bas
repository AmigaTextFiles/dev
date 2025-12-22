10    dim tom14%(4096),tom13%(2048),tom12%(1024),tom11%(512),tom10%(256)
20    dim note%(12)
30    open "i",#3,"tom.samples"
40    fs%=varptr(tomh%(0)):fl%=8:gosub 290
50    fs%=varptr(tom10%(0)):fl%=1024:gosub 290
60    fs%=varptr(tom11%(0)):fl%=2048:gosub 290
70    fs%=varptr(tom12%(0)):fl%=4096:gosub 290
80    fs%=varptr(tom13%(0)):fl%=8192:gosub 290
90    fs%=varptr(tom14%(0)):fl%=16384:gosub 290
100   close #3
110   per=240:for i=0to 11:note%(i)=per:per=per/2^(1/12):next
120   per%(0)=0
130   period 1,per%
140   vol%(0)=0
150   volume 1,vol%
160   audio 15,1
170   ?"press keys to play"
180   getkey c$
190   key% = asc(c$)-65
200   on int(key%/12)+1 goto 220,230,240,250,260
210   goto 180
220   wave 16384,tom14%:goto 270
230   wave 8192,tom13%:goto 270
240   wave 4096,tom12%:goto 270
250   wave 2048,tom11%:goto 270
260   wave 1024,tom10%
270   chan%=sound(15,1,1,64,note%(key% mod 12))
280   goto 180
290   ?"loading"fl%"bytes...";
300   for fill%=fs% to fs%+fl%-1:get #3,a$:poke fill%,asc(a$):next
310   ?" done"
320   return
