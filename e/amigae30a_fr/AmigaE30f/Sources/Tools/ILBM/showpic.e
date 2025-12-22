/*

        showpic.e                          Michael Zucchi 1994

        Un simple afficheur d'image IFF ILBM
        Démontre l'utilisation du module ILBM, et le requester de fichier asl

        Ce programme peut être distribué librement seulement au sein des
        propriétaires enregistrés de l'AmigaE.
 */


MODULE 'tools/ilbm', 'tools/ilbmdefs',
        'intuition/intuition',
        'asl', 'libraries/ASL'

DEF scr,
        buffer[256]:ARRAY

PROC main()
DEF ilbm,filename

IF filename:=requestfile('Select picture')
        IF ilbm:=ilbm_New(filename,0)
                ilbm_LoadPicture(ilbm,[ILBML_GETSCREEN,{scr},0])
                ilbm_Dispose(ilbm)      -> plus du tout nécessaire ...

                -> ce n'est juste qu'un exemple!  Dans un application réelle,
                -> utilisez toujours les ports IDCMP et les fenêtres.

                IF scr                  -> seulement si une a été créé.
                        WHILE Mouse()<>1
                                Delay(4)
                        ENDWHILE
                        CloseScreen(scr)
                ENDIF
        ENDIF
ENDIF

ENDPROC

/*
        Affiche une requête de fichier ASL.  Si l'utilisateur choisit un fichier,
        il est étendu à son chemin + nom de fichier.
 */
PROC requestfile(title)
DEF name=0,fr:PTR TO filerequester

IF aslbase:=OpenLibrary('asl.library',36)
        IF fr:=AllocAslRequest(ASL_FILEREQUEST,[ASLFR_TITLETEXT,title,0])
                IF AslRequest(fr,0)

                        -> désolé, un peu d'asm ici. Ben ... comment sinon?
                        -> ca réalise une copie de chaine (strcpy()) ...
                        MOVE.L  fr,A0
                        MOVE.L  8(A0),A0        -> pointeur répertoire de la requête de fichier.
                        MOVE.L  buffer,A1
                cp:     MOVE.B  (A0)+,(A1)+
                        BNE.S   cp

                        AddPart(buffer,fr.file,256)
                        name:=buffer
                ENDIF
                FreeAslRequest(fr)
        ENDIF
        CloseLibrary(aslbase)
ENDIF

ENDPROC name
