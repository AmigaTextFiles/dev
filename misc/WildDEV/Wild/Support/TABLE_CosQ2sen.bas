OPEN "WildPJ:Wild/Tables/CosQ2Sen.table" FOR OUTPUT AS 1
FOR i=0 TO 255
 cosq=(i/255)
 senn=(1-cosq)^.5
 PRINT#1,CHR$(INT(senn*255));
NEXT i
CLOSE 1
 
 
 
 
 
 
 