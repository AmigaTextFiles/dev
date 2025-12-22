/*=======================================
 $VER: IC_MakeStampWithADPro 1.0 © NasGûl
 ======================================*/


/*=========================
 suppose  adpro not running
 ========================*/
fx=0

/*=== Image contenant la palette a 'locker' ===*/
/*=== Cette image doit être l'image défini par le tooltype IMAGE_PRESENT
      De ImageCat.
 ===*/
palettefile='ImageCat:ImageCat.Pic'

/*=== Nombre de couleurs pour les icones ===*/
/*=== Defini par le tooltype SCREEN_ID   ===*/
numcolor=HAM8

/*=== Résolution des timbres (ATTENTION SI VOUS CHANGER DE RESO) ===*/
l_x=160
l_y=64

x=ShowList('P','ADPro')
IF x=0 Then Call runADpro()
result=GetFile(0,0,'','','Créer Timbre pour :','ImageCatScreen','PATGAD|MULTISELECT',fichier,80,200,'#?')
IF result~=="" Then
    Do
        numfiles=result
        Address 'ADPro'
        OPTIONS RESULTS
        LFORMAT UNIVERSAL
        SFORMAT IFF
        OFORMAT SCALE
        /*=================================*/
        /* On charge est bloque la palette */
        /*=================================*/
        PSTATUS UNLOCKED
        PLOAD  palettefile
        PSTATUS LOCKED

        /*===========================*/
        /* nbrs de couleurs au rendu */
        /*===========================*/
        RENDER numcolor
        
        Do i=1 To numfiles
            x=Exists(fichier.i'.stamp')
            IF x=0 Then
                Do
                    LOAD fichier.i
                    error=rc
                    IF error=0 Then
                        Do
                            ABS_SCALE l_x l_y
                            SCREEN_TYPE 5
                            DITHER 1
                            OPERATE
                            EXECUTE
                            /*====================*/
                            /* on sauve           */
                            /*====================*/
                            SAVE fichier.i'.stamp' 'IMAGE' 'QUIT'
                        End
                End
        End
    End
IF fx=1 Then Address 'ADPro' ADPRO_EXIT
Exit

runADPro:
    x=Exists('ADPro:ADPro')
    IF x=0 Then Exit
    Address Command 'Run ADPro:ADPro'
    Do For 50 While ~Show('Ports','ADPro')
        Call Delay 10
    End
    x=ShowList('P','ADPro')
    IF x=0 Then Exit
    Address 'ADPro' ADPRO_TO_BACK
    fx=1
Return 0






