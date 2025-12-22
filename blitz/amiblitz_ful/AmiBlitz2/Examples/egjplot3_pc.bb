;Lattice symmetry is achieved by setting x and y to periodic
;functions of x and y prior to calculating the z.
;This is an easy way of filling the screen with smoothly fitting pieces.
p2#=2*Pi
Graphics 640,480,32

For i#=0 To 63
  x#=(6*i)/4:x=Sin((p2*x)/6)
  
  For j#=0 To 63
    y#=6-(6*j)/4:y=Sin((p2*y)/6)
    
    z#=Cos(y*y)-x
     a#=Tan(x-y+Cos(x+y))  
    z#=z#;-Cos(a+0.3)
            integer_x#    = Int(z-0.5)      
zz# = z - integer_x#
      
    ;zz.f=frac(xf)
    	If zz<0
    	zz=zz+1
    	EndIf
    	zz=zz*2:If zz>1
    	zz=2-zz
		EndIf
    c%=Int((zz*16+16)-0.5)
    c=c*10
    	If c=256
    	c=256
    	EndIf
    Color c,c*256,c*65536
    Plot i,j
Next:Next
;GetaShape 0,0,0,64,64
;For i=0 To 256 Step 64:For j=0 To 192 Step 64
  ;Blit 0,i,j
;Next:Next
MouseWait
;VWait 50
;SaveBitmap 0,"dh1:fpufalsch2.iff"
