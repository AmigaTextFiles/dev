REM $INCLUDE exec.bh
LIBRARY OPEN "exec.library"

REM $INCLUDE vlab.bh
LIBRARY OPEN "vlab.library"

REM $INCLUDE cybergraphics.bh
LIBRARY OPEN "cybergraphics.library"


Breite&=640
Hoehe&=200

WINDOW 2,"VLab-Testfenster",(0,0)-(320,200),2

block&=Breite&*Hoehe&
memY&=AllocVec&(block&,MEMF_PUBLIC&)
memU&=AllocVec&(block&,MEMF_PUBLIC&)
memV&=AllocVec&(block&,MEMF_PUBLIC&)
memRGB&=AllocVec&(block&*3&,MEMF_PUBLIC&)

IF memY&=0 OR memU&=0 OR memV&=0 OR memRGB&=0 THEN PRINT "Speichermangel":GOTO Ende

suc=VLab_Custom(VLREG_INPUT%,1)
suc=VLab_Custom(VLREG_FULLFRAME%,0)

WHILE INKEY$=""
suc=VLab_Scan(memY&,memU&,memV&,40,50,Breite&,Hoehe&)
IF suc=FALSE THEN PRINT "Fehler beim Scan":GOTO Ende
VLab_YUVtoRGB memY&,memU&,memV&,memRGB&,block&,YUV411_TO_LORES%

suc=WritePixelArray(memRGB&,0,0,Breite&*3\2,WINDOW(8),0,0,320,200,RECTFMT_RGB%)
WEND

Ende:
 IF memY& THEN FreeVec memY&
 IF memU& THEN FreeVec memU&
 IF memV& THEN FreeVec memV&
 IF memRGB& THEN FreeVec memRGB&