'
' Pixel Trail code by Peter Cahill, September 98
'
'
' TGE demonstration......





Set Buffer 10000
Amos To Back 
AMTPIXELS=20
Timer=0
Dim X(AMTPIXELS),Y(AMTPIXELS),C(AMTPIXELS),STX(50000),STY(50000)

G Load Iff "gmsdev:logos/gmslogo-fullscreen.iff",0


Do 
   MX=G X Mouse
   MY=G Y Mouse
MY=MY+Rnd(10)

   STX(POZ)=MX
   STY(POZ)=MY
   Inc POZ
   If POZ=49999 Then Exit 

   
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

   If G Left Click=True Then Exit 

Loop 

'
' Re Draw exerything, the same way to how the user drew it above.
'
'


For A=1 To AMTPIXELS
X(A)=0 : Y(A)=0 : C(A)=0
Next A


G Screen Close 0
G Update 


G Load Iff "gmsdev:logos/gmslogo-fullscreen.iff",0
Wait 100
POZ=0
Do 
   MX=G X Mouse : Rem           *** these are not needed, but retain the same speed
   MY=G Y Mouse
   MX=STX(POZ)
   MY=STY(POZ)
   Inc POZ
   If POZ=49999 Then Exit 

   
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

   If G Left Click=True Then Exit 
Loop 


G Screen Close 0











