/*

        picwindow.e                          Michael Zucchi 1994

        Charge une image dans une fenêtre sur le WorkBench (sans couleurs...)
        Démontre l'utilisation du module ILBM - le chargement dans les bitmaps,
        et comment obtenir les informations sur l'image. Il montre aussi le
        requête de fichier asl.

        Ce programme peut être librement distribué au sein des propriétaires
        enregitrés de l'AmigaE.
 */


MODULE 'tools/ilbm', 'tools/ilbmdefs',
        'intuition/intuition',
        'asl', 'libraries/ASL'

DEF bm,win:PTR TO window,
        buffer[256]:ARRAY

PROC main()
DEF ilbm,filename,width,height,bmh:PTR TO bmhd,pi:PTR TO picinfo

IF filename:=requestfile('Select picture')
        IF ilbm:=ilbm_New(filename,0)
                ilbm_LoadPicture(ilbm,[ILBML_GETBITMAP,{bm},0])

                -> prend un pointeur SUR les infos des images, on sort
                ->l'entête bitmap, et lit la taille de l'image.
                pi:=ilbm_PictureInfo(ilbm)
                bmh:=pi.bmhd;
                width:=bmh.w;
                height:=bmh.h;

                -> le gestionnaire ilbm n'est plus nécessaire, on peut le libérer
                ilbm_Dispose(ilbm)

                -> si un bitmap est actuellement ouvert, ouvre une fenêtre, et le 'blit'
                IF bm
                        IF win:=OpenWindowTagList(0,[WA_INNERWIDTH,width,WA_INNERHEIGHT,height,
                                WA_AUTOADJUST,-1,
                                WA_IDCMP,IDCMP_CLOSEWINDOW,
                                WA_FLAGS,WFLG_CLOSEGADGET+WFLG_DRAGBAR+WFLG_DEPTHGADGET,
                                WA_TITLE,filename,
                                WA_SCREENTITLE,'Pic-Window 0.1 1994 Michael Zucchi',0])

                                -> bit dans les dimensions actuelles que l'OS pourrait nous donner (La fenêtre peut ne pas être aussi grande que l'image)
                                BltBitMapRastPort(bm,0,0,win.rport,
                                        win.borderleft,win.bordertop,
                                        win.width-win.borderright-win.borderleft,
                                        win.height-win.borderbottom-win.bordertop,$c0);

                                WaitPort(win.userport)
                                CloseWindow(win)

                        ENDIF
                        ilbm_FreeBitMap(bm)
                ENDIF
        ENDIF
ENDIF

ENDPROC

/*
        Affiche une requête de fichier asl. Si l'utilisateur choisit un fichier,
        son nom est étendu à son chemin entier.
 */
PROC requestfile(title)
DEF name=0,fr:PTR TO filerequester

IF aslbase:=OpenLibrary('asl.library',36)
        IF fr:=AllocAslRequest(ASL_FILEREQUEST,[ASLFR_TITLETEXT,title,0])
                IF AslRequest(fr,0)

                        -> désolé, un peu d'asm ici. Ben ... Sinon comment?
                        -> ça fait une copie de chaine (strcpy()) ...
                        MOVE.L  fr,A0
                        MOVE.L  8(A0),A0        -> pointeur de répertoire de la requête
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
