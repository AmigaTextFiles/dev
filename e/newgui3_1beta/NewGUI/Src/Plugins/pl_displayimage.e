OPT     OSVERSION = 37
OPT     MODULE

MODULE  'intuition/intuition'
MODULE  'newgui/newgui'

EXPORT  CONST   IMAGE = PLUGIN

EXPORT OBJECT displayimage OF plugin
 img    :PTR TO image
ENDOBJECT

PROC displayimage(img:PTR TO image)     OF displayimage 
 self.img:=img
ENDPROC

PROC min_size(ta,fh)                    OF displayimage IS self.img.width,self.img.height

PROC will_resize()                      OF displayimage IS 0

PROC render(ta,x,y,xs,ys,win:PTR TO window) OF displayimage     IS DrawImage(win.rport,self.img,x,y)

PROC clear_render(win:PTR TO window)    OF displayimage IS EraseImage(win.rport,self.img,self.x,self.y)

PROC message_text(class,qual,code,win)  OF displayimage IS FALSE
