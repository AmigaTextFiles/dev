author,'Unknown',128)
    IF com THEN AstrCopy(self.comment,com,128) ELSE AstrCopy(self.comment,'None',128)
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC
->fe

PROC main() HANDLE
    DEF res=-1,mask=0,sig,ttypes=NIL,msg,msgtype,msgid

    aslbase:=OpenLibrary('asl.library',37)
    xpkbase:=OpenLibrary('xpkmaster.library',2)
    iconbase:=OpenLibrary('icon.library',37)
    cxbase:=OpenLibrary('commodities.library',37)
    utilitybase:=OpenLibrary('utilit