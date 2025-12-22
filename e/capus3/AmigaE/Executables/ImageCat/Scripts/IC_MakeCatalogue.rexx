/*===================================
 $VER: IC_MakeCatalogue 1.0 © NasGûl
 ====================================
 Ce script vous permet a l'aide d'un
 selecteur de fichier ,de créer un nouveau catalogue.
 ==================================*/


suf=GetEnv('IC_STAMP_SUFFIX')

/*======== Image sources =============*/

result=GetFile(0,0,'','','Images a cataloguer','ImageCatScreen','PATGAD|MULTISELECT',fichier,80,200,'~(#?.info|#?'suf')')

IF result~=="" then
    DO
        numfiles=result
        /*======= Fichier de destination ==========*/

        result=GetFile(0,0,'','','Catalogue a créer','ImageCatScreen','PATGAD|SAVE',cata,80,200,'#?.Cat')
        IF result~=="" then
            DO
                x=Open('d',cata.result,'W')
                IF x=1 Then
                    Do
                        DO i=1 TO numfiles
                            CALL WriteLn('d',fichier.i)
                        End
                        Close('d')
                    End
            End
    End
Exit

