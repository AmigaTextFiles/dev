OPT     OSVERSION=37
OPT     LARGE

MODULE  'newgui/newgui'
MODULE  'newgui/pl_register'
MODULE  'newgui/ng_showerror'

CONST   GUI_MAIN = 1

DEF     reg=NIL:PTR TO register,
        gui=NIL:PTR TO LONG,
        gh=NIL:PTR TO guihandle

PROC main() HANDLE
 NEW reg.register(['Page1',NIL,'Page2',NIL,'Page3',NIL,NIL,NIL],0,TRUE,REG_ABOVE,TRUE)
  gui:=[
         [ROWS,[REGISTER,{action},reg],[SPACE],[SLIDE,{ignore},'Colors:',FALSE,1,8,3,5,'']],
         [ROWS,[REGISTER,{action},reg],[SPACE],[CHECK,{ignore},'Ignore case',TRUE,FALSE]],
         [ROWS,[REGISTER,{action},reg],[SPACE],[PALETTE,{ignore},'Palette:',3,5,2,0]]
       ]
   newguiA([
        NG_WINDOWTITLE, 'NewGUI-Register-Plugin',     
        NG_GUIID,       GUI_MAIN,
        NG_GUI,
                gui[],
        NIL,            NIL],{getgui})
EXCEPT DO
 IF (reg<>NIL) THEN END reg
  IF (exception<>0) THEN ng_showerror(exception) 
 CleanUp(exception)
ENDPROC

PROC getgui(guihandle,scr)      IS gh:=guihandle

PROC reset()
 reg.set(0)
ENDPROC

PROC toggle()
  reg.disable(reg.dis=FALSE)
ENDPROC

PROC ignore() IS EMPTY

PROC action()
 DEF    page=0
  page:=reg.get()
   WriteF('index = \d - page = \d\n',page,page+1)
    ng_setattrsA(
       [NG_GUI,         gh,
        NG_CHANGEGUI,   NG_NEWGUI,
        NG_GUIID,       GUI_MAIN,
        NG_NEWDATA,     gui[page],
        NIL,            NIL])
ENDPROC
