/*=============================
 $VER: IC_MakeIcon 1.0 © NasGûl
 ==============================
 Ce script vous permet a l'aide d'un sélécteur de fichier
 et de ImageFX de créer vos icônes.
 ============================*/

/*===========================
 suppose  imagefx not running
 ==========================*/
fx=0
dodel=0

/*=== Image contenant la palette a 'locker' ===*/
palettefile=GetEnv('IC_WBPALETTE')

/*=== Nombre de couleurs pour les icones ===*/
/*=== Defini par le tooltype SCREEN_ID   ===*/
/*=== 
        ATTENTION LA LIGNE SUIVANTE EST FAUSE,IC_DEPTH est le nombre
    de plan de bits de l'image ImageCat:ImageCat.Pic,alors que nous
    voulons le nombres de couleur du WB,mais avec ImageCat.Pic en
    8 bitplanes est mon WB en 8 couleurs,ça tombe pile.SI VOTRE WB
    A PLUS OU (MOINS ?) DE COULEURS CHANGER CETTE LIGNE.
===*/
numcolors=GetEnv('IC_DEPTH')

/*=== Résolution des timbres (ATTENTION SI VOUS CHANGER DE RESO) ===*/
l_x=GetEnv('IC_ICONX')
l_y=GetEnv('IC_ICONY')

/*=== suffix des stamps ===*/
suf=GetEnv('IC_STAMP_SUFFIX')

x=ShowList('P','IMAGEFX.1')
IF x=0 Then Call runImageFX()

result=GetFile(0,0,'','','Créer Icônes pour :','ImageCatScreen','PATGAD|MULTISELECT',fichier,80,200,'~(#?.info|#?'suf')')
IF result~=="" Then
    Do
        numfiles=result
        Address 'IMAGEFX.1'
        RequestResponse 'Voulez vous ecraser les icones existants'
        IF rc=0 Then dodel=1
        Palette 8
        LockRange 0 OFF
        LoadPalette palettefile
        LockRange 0 ON        
        Do i=1 To numfiles
            IF dodel=1 THEN Address Command 'Delete >NIL: 'fichier.i'.info'
            x=Exists(fichier.i''suf)
            IF x=0 Then
                baseimage=fichier.i
            Else
                baseimage=fichier.i''suf
            x=Exists(fichier.i'.info')
            IF x=0 Then
                Do
                    LoadBuffer baseimage Force
                    error=result
                    IF error~==0 Then
                        Do
                            Scale l_x l_y
                            Render Mode HIRES
                            Render Colors numcolors
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
    End

IF fx=1 Then Address 'IMAGEFX.1' QUIT FORCE
Address Command 'Delete >nil: t:temp'
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

