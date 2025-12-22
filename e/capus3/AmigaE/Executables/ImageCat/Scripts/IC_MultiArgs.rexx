/*==============================
 $VER: IC_MultiArgs 1.0 © NasGûl
 ===============================
 Ce script est un exemple sur l'utilisation de la
 variable IC_NUMSEL,ce programme crée un fichier
 temporaire T:ImageCatTemp contenant tous les fichiers
 séléctionnés dans la liste,ensuite il ouvre et lit se
 fichier.Si vous voulez ce scripts comme base,rajoutez
 simplement dans la fonction performAction: les commandes
 voulues.
 =============================*/

Parse Arg fichier

numsel=GetEnv('IC_NUMSEL')

IF numsel=1 Then
    Do
        x=Open('s','T:ImageCatTemp','R')
        IF x=0 Then Exit 5
        Do ForEver
            IF Eof('s')=1 Then Leave
            data=Readln('s')
            IF data~=="" Then
                Call performAction(data)
            Else
                Nop
        End
        Call performAction(fichier)
        Call Close('s')
        x=Open('s','T:ImagecatTemp','W')
        Call WriteCh('s','')
        Call Close('s')
    End
Else
    Do

        x=Exists('T:ImageCatTemp')
        IF x=0 Then
            f=Open('d','T:ImageCatTemp','W')
        Else
            f=Open('d','T:ImageCatTemp','A')
        IF f=0 Then Exit 5
        Call WriteLn('d',fichier)
        SetEnv('IC_NUMSEL',numsel-1)
        Call Close('d')
    End
Exit 0


performAction:
    Parse Arg file
    Address Command 'VT 'file
Return 0

