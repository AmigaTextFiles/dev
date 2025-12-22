'
' Pixel Trail code by Peter Cahill, September 98
'
'
' TGE demonstration......





AMTPIXELS=20

Dim X(AMTPIXELS),Y(AMTPIXELS),C(AMTPIXELS)

G Def Palette 0,$0,$111111,$222222,$333333,$444444,$555555,$666666,$777777
G Def Palette 8,$888888,$999999,$AAAAAA,$BBBBBB,$CCCCCC,$DDDDDD,$EEEEEE,$FFFFFF
G Screen Open 0,320,256,16,Glowres


Do 
   MX=G X Mouse
   MY=G Y Mouse
   
   'Update Pixels 
   
   For LOP=1 To AMTPIXELS
      If C(LOP)<>0
         G Plot X(LOP),Y(LOP),C(LOP)
         
         C(LOP)=C(LOP)-1
         Y(LOP)=Y(LOP)+2
         
      Else 
         FREPIXEL=LOP
      End If 
      
   Next LOP
   X(FREPIXEL)=MX
   Y(FREPIXEL)=MY
   C(FREPIXEL)=16 : Rem                               brightest colour 
   
   G Plot X(FREPIXEL),Y(FREPIXEL),C(FREPIXEL)
   G Update 
   G Cls 

   If G Left Click=True Then Exit 
Loop 


G Screen Close 0







