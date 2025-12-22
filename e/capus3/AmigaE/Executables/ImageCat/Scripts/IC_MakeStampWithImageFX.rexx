/*=========================================
 $VER: IC_MakeStampWithImageFX 1.0 © NasGûl
 ==========================================
 Ce script vous permet,avec un sélécteur de fichier et ImageFX,
  de créer les timbres,les icônes,et le catalogue
 ========================================*/

/*===========================
 suppose  imagefx not running
 ==========================*/
fx=0
dodel=0

/*=== Image contenant la palette a 'locker' ===*/
/*=== Cette image doit être l'image défini par le tooltype IMAGE_PRESENT
      De ImageCat.
 ===*/
palettefile=GetEnv('IC_IMAGE_PRESENT')
wbpalette=GetEnv('IC_WBPALETTE')

/*=== Nombre de couleurs pour les icones ===*/
/*=== Defini par le tooltype SCREEN_ID   ===*/
/*===
    IMPORTANT: en faisant plusieurs essai sur plusieurs images,
    une palette de 64 couleurs en HAM8 donne mieux q'une palette
    de 256 couleurs en 8 bitplanes (en mode NonHAM)
==*/
numcolors=64

/*=== Résolution des timbres (ATTENTION SI VOUS CHANGER DE RESO) ===*/
l_x=GetEnv('IC_WIDTH')
l_y=GetEnv('IC_HEIGHT')

/*=== Resolutions des icones */
ic_x=GetEnv('IC_ICONX')
ic_y=GetEnv('IC_ICONY')

/*==== Nbrs de couleurs de vôtre WB ====*/

numcol=8

/*== stamp ===*/
suf=GetEnv('IC_STAMP_SUFFIX')

x=ShowList('P','IMAGEFX.1')
IF x=0 Then Call runImageFX()

result=GetFile(0,0,'','','Créer Timbre pour :','ImageCatScreen','PATGAD|MULTISELECT',fichier,80,200,'~(#?.info|#?'suf')')
IF result~=="" Then
    Do
        numfiles=result
        Address 'IMAGEFX.1'
        RequestResponse 'Voulez vous ecraser les timbres existants'
        IF rc=0 Then dodel=1
        Palette 8
        LockRange 0 OFF
        LoadPalette palettefile
        LockRange 0 ON        
        Do i=1 To numfiles
            IF dodel=1 THEN Address Command 'Delete >NIL: 'fichier.i''suf
            x=Exists(fichier.i''suf)
            IF x=0 Then
                Do
                    LoadBuffer fichier.i Force
                    error=result
                    IF error~==0 Then
                        Do
                            Scale l_x l_y
                            /*=== a changer selon votre ToolTypes SCREEN_ID ===*/
                            Render Mode HIRES HAM
                            Render Colors numcolors
                            Render Dither 1 0 2

                            Render Go

                            SaveRenderedAs 'ILBM' fichier.i''suf

                            Render Close
                        
                        End
                End
        End
    End
RequestResponse "Voulez vous créer les icônes"
IF rc=0 Then
    Do
        Palette 8
        LockRange 0 OFF
        LoadPalette wbpalette
        LockRange 0 ON
        Do i=1 To numfiles
            x=Exists(fichier.i''suf)
            IF x=0 Then
                baseimage=fichier.i
            Else
                baseimage=fichier.i''suf
            LoadBuffer baseimage Force
            error=result
            IF error~==0 Then
                Do
                    Scale ic_x ic_y

                    Render Mode HIRES
                    Render Colors numcol
                    Render Dither 1 0 2
                    Render Go

                    SaveRenderedAs 'ILBM' 'T:Temp'
                    
                    Render Close
                            
                    Address Command
                    'IFF2Icon T:Temp' To fichier.i Project
                    Address
                        
                End
        End
    End

RequestResponse 'Voulez vous créer un catalogue'
IF rc=0 then
    DO
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
Else
    Nop

IF fx=1 Then Address 'IMAGEFX.1' QUIT FORCE
Exit


runImageFX:
    x=Exists('ImageFX:ImageFX')
    IF x=0 Then Exit
    Address Command 'Run ImageFX:ImageFX WB PubScreen ImageCatScreen'
    Do For 50 While ~Show('Ports','IMAGEFX.1')
        Call Delay 10
    End
    x=ShowList('P','IMAGEFX.1')
    IF x=0 Then Exit
    fx=1
Return 0







