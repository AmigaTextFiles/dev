
SCREEN 1,640,256,2,5
WINDOW 1,"META to WILD Object",,,1

'$INCLUDE BASU:_METAConsts.bas
'$INCLUDE BASU:_METAFindFlag.bas
'$INCLUDE BASU:_CutWord.bas  
'$INCLUDE BASU:_LoadMeta.bas  
'$INCLUDE BASU:_Cut.bas
'$INCLUDE BASU:_Command.bas
'$INCLUDE BASU:_FileReq.bas

FUNCTION Num$(a)
 Num$=Cut$(STR$(INT(a)))
END FUNCTION

METAIN$=FileReq$("WildPJ:support/meta/","Select meta input","#?.meta")
LoadMETA(METAIN$)

'WILDOUT$=FileReq$("WildPJ:support/TestSectors/","Select asm output","#?")
WILDOUT$="RAM:Sector.s"
GOSUB WriteSector
END

WriteSector:
OPEN WILDOUT$ FOR OUTPUT AS 1
PRINT #1,"; Wild Sector source made by META2Wild"
PRINT #1,"; Made on "+TIME$+" of "+DATE$
SECNAME$=METAHaveFlag$("SectorName")
PRINT #1,"; Sector name is "+SECNAME$

TB$=CHR$(9)
EQU$=TB$+"EQU"+TB$
FACE$="FACE_"+SECNAME$
DOT$="DOT_"+SECNAME$
EDGE$="EDGE_"+SECNAME$
TEXT$="TEXTURE_"+SECNAME$
COLOR$="COLOR_"+SECNAME$
DC$=TB$+"Dc."
DCL$=DC$+"l"+TB$
DCW$=DC$+"w"+TB$
DCB$=DC$+"b"+TB$
DSB$=TB$+"Ds.b"+TB$
ORX$=Num$(VAL(METAHaveFlag$("AbsOX")))+"+"+SECNAME$+"_PosX"
ORY$=Num$(VAL(METAHaveFlag$("AbsOY")))+"+"+SECNAME$+"_PosY"
ORZ$=Num$(VAL(METAHaveFlag$("AbsOZ")))+"+"+SECNAME$+"_PosZ"

PRINT #1,""
PRINT #1,"SECTOR_"+SECNAME$
PRINT #1,DCL$+SECNAME$+"_Succ,"+SECNAME$+"_Pred"
PRINT #1,TB$+"QuickRefRel"+TB$+ORX$+","+ORY$+","+ORZ$
PRINT #1,DCL$+SECNAME$+"_Parent"
PRINT #1,DCL$+"0"
PRINT #1,DCB$+"0,0"
PRINT #1,TB$+"ListHeader"+TB$+SECNAME$+"Shell,"+FACE$+Num$(1)+","+FACE$+Num$(NFAC)
PRINT #1,TB$+"ListHeader"+TB$+SECNAME$+"Wire,"+EDGE$+Num$(1)+","+EDGE$+Num$(NEDG)
PRINT #1,TB$+"ListHeader"+TB$+SECNAME$+"Nebula,"+DOT$+Num$(1)+","+DOT$+Num$(NDOT)
PRINT #1,DSB$+"Sphere_SIZE"
Root$=METAHaveFlag$("Root")
PRINT #1,DCL$+FACE$+Num$(VAL(Root$))
PRINT #1,""
PRINT #1,COLOR$+Num$(0)+EQU$+"$FFEEDD"
FOR i=1 TO NTXT
 PRINT #1,TEXT$+Num$(i)+EQU$+"0"
NEXT i
PRINT #1,""
FOR i=1 TO NFAC
 PRINT #1,FACE$+Num$(i)
 SUCC$=FACE$+Num$(i+1):IF i=NFAC THEN SUCC$=SECNAME$+"Shell_Tail"
 PREC$=FACE$+Num$(i-1):IF i=1 THEN PREC$=SECNAME$+"Shell_Head"
 PRINT #1,DCL$+SUCC$+","+PREC$
 PLUS=Face(i,FACPLUS%):IF PLUS<>0 THEN PLUS$=FACE$+Num$(PLUS) ELSE PLUS$="0"
 MINUS=Face(i,FACMINUS%):IF MINUS<>0 THEN MINUS$=FACE$+Num$(MINUS) ELSE MINUS$="0"
 PRINT #1,DCL$+PLUS$+","+MINUS$
 PRINT #1,DCB$+"0,0,BSPTY_FACE,0"
 PRINT #1,DCL$+"0"
 PRINT #1,DCL$+DOT$+Num$(Face(i,FACPA%))+","+DOT$+Num$(Face(i,FACPB%))+","+DOT$+Num$(Face(i,FACPC%))
 PRINT #1,DCL$+EDGE$+Num$(Face(i,FACLA%))+","+EDGE$+Num$(Face(i,FACLB%))+","+EDGE$+Num$(Face(i,FACLC%))
 PRINT #1,DCL$+TEXT$+Num$(Face(i,FACTEX%))
 TXA%=Face(i,FACTXA%):IF TXA%>127 THEN TXA%=TXA%-256
 TYA%=Face(i,FACTYA%):IF TYA%>127 THEN TYA%=TYA%-256
 TXB%=Face(i,FACTXB%):IF TXB%>127 THEN TXB%=TXB%-256
 TYB%=Face(i,FACTYB%):IF TYB%>127 THEN TYB%=TYB%-256
 TXC%=Face(i,FACTXC%):IF TXC%>127 THEN TXC%=TXC%-256
 TYC%=Face(i,FACTYC%):IF TYC%>127 THEN TYC%=TYC%-256
 PRINT #1,DCB$+Num$(TXA%)+","+Num$(TYA%)
 PRINT #1,DCB$+Num$(TXB%)+","+Num$(TYB%)
 PRINT #1,DCB$+Num$(TXC%)+","+Num$(TYC%)
NEXT i
PRINT #1,""
FOR i=1 TO NEDG
 PRINT #1,EDGE$+Num$(i)
 SUCC$=EDGE$+Num$(i+1):IF i=NEDG THEN SUCC$=SECNAME$+"Wire_Tail"
 PREC$=EDGE$+Num$(i-1):IF i=1 THEN PREC$=SECNAME$+"Wire_Head"
 PRINT #1,DCL$+SUCC$+","+PREC$
 PRINT #1,DCL$+DOT$+Num$(Edge(i,EDGPA%))+","+DOT$+Num$(Edge(i,EDGPB%))
 PRINT #1,DCB$+"0,0,0,0" 
 PRINT #1,DCL$+"0"
NEXT i
PRINT #1,""
FOR i=1 TO NDOT
 PRINT #1,DOT$+Num$(i)
 SUCC$=DOT$+Num$(i+1):IF i=NDOT THEN SUCC$=SECNAME$+"Nebula_Tail"
 PREC$=DOT$+Num$(i-1):IF i=1 THEN PREC$=SECNAME$+"Nebula_Head"
 PRINT #1,DCL$+SUCC$+","+PREC$
 PRINT #1,DCL$+Num$(Dot(i,DOTX%))+","+Num$(Dot(i,DOTY%))+","+Num$(Dot(i,DOTZ%))
 PRINT #1,DCL$+COLOR$+Num$(0)
 PRINT #1,DCB$+"0,0"
 PRINT #1,DCL$+"0"
NEXT i
CLOSE 1
RETURN




