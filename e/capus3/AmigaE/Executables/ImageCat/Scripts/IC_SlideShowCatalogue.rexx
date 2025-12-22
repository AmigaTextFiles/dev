/*=======================================
 $VER: IC_SlideShowCatalogue 1.0 © NasGûl
 ======================================*/
Options Results
Options Failat 21
i=0
result=GetFile(0,0,'','','Catalogue a voir','ImageCatScreen','PATGAD',cata,80,200,'#?.Cat')
IF result~=="" Then
    DO
        x=Open('s',cata.result,'R')
        DO ForEver
            IF Eof('s')=1 THen LEAVE
            file.i=Readln('s')
            i:=i+1
        End
        Call Close('s')
    End


Exit result rc


