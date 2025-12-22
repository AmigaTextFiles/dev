-> Bitmap-Plugin by Deniil715!
-> mailto:deniil@algonet.se

OPT MODULE

MODULE 'tools/EasyGUI', 'intuition/intuition'

EXPORT OBJECT bitmapimage OF plugin
PRIVATE
 chipdata:PTR TO INT
 img:PTR TO image
 planes:INT
 pick:CHAR
 onoff:CHAR
ENDOBJECT

PROC bitmapimage(bitmap,datalen,sizex,sizey,depth,planepick,planeonoff) OF bitmapimage
 self.chipdata:=NIL
 self.chipdata:=NewM(datalen,$10002)
 CopyMem(bitmap,self.chipdata,datalen)
 self.img:=[0,0,sizex,sizey,depth,self.chipdata,planepick,planeonoff,NIL]:image
 self.planes:=depth
 self.pick:=planepick
 self.onoff:=planeonoff
 self.xs:=sizex
 self.ys:=sizey
ENDPROC

PROC end() OF bitmapimage
 IF self.chipdata THEN Dispose(self.chipdata)
ENDPROC

PROC will_resize() OF bitmapimage IS FALSE

PROC min_size(ta,fh) OF bitmapimage IS self.xs,self.ys

PROC render(ta,x,y,xs,ys,w:PTR TO window) OF bitmapimage
 DrawImage(w.rport,self.img,x,y)
ENDPROC

PROC clear_render(w:PTR TO window) OF bitmapimage
 EraseImage(w.rport,self.img,self.x,self.y)
ENDPROC
