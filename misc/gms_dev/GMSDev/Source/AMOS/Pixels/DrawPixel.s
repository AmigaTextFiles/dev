'
' Pixel Trail code by Peter Cahill, September 98
'
'
' TGE demonstration......


G Load Iff "GMS:demos/data/pic.green",0


Do 
X=G X Mouse
Y=G Y Mouse

C=G Pixel(X,Y)

G Plot X,Y,2

G Update 
G Plot X,Y,C

If G Left Click=True Then Exit 

Loop 

G Screen Close 0
