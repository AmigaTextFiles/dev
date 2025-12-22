lf.comment,c)
    FreeScreenDrawInfo(wd.wscreen,dri)
    CloseFont(font)
ENDPROC

PROC clear_render(u) OF modinfo
    self.visible:=FALSE
    self.window:=NIL
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,wd:PTR TO window) OF modinfo
    IF imsg.class=IDCMP_RAWKEY
        self.rawkey:=imsg.code
        RETURN TRUE
    ENDIF
ENDPROC FALSE

PROC message_action(wd:PTR TO window) OF modinfo
    DEF k
    k:=self.rawkey
    SELECT k
        CASE $19
            play()
        CASE $21
            stop()
        CASE $12
            eject()
        CASE $34
            save()
        CASE $28
            load()
        CASE $45
            RETURN TRUE
        CASE CURSORLEFT
            prev()
        CASE CURSORRIGHT
            next()
    ENDSELECT
ENDPROC FALSE

PROC setname(name=0) OF modinfo
    IF name THEN AstrCopy(self.name,name,128) ELSE AstrCopy(self.name,'No module loaded',128)
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC

PROC setsize(size=0) OF modinfo
    self.size:=size
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC

PROC settype(t=0) OF modinfo
    IF t THEN AstrCopy(self.type,t,128) ELSE AstrCopy(self.type,'None',128)
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC

PROC setauthor(au=0) OF modinfo
    IF au THEN AstrCopy(self.author,au,128) ELSE AstrCopy(self.author,'Unknown',128)
    IF self.visible THEN self.render(self.x,self.y,self.xs,self.ys,self.window)
ENDPROC

PROC