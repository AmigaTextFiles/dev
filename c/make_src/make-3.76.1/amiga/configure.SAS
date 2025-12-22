.key UNINSTALL/S

If <UNINSTALL>
    Delete /make-3.76.1/amiga.c
    Delete /make-3.76.1/amiga.h
    Delete /make-3.76.1/config.h
    Delete /make-3.76.1/SMakeFile
    Delete /make-3.76.1/SCOPTIONS
    Delete /make-3.76.1/glob/SMakeFile
    Delete /make-3.76.1/glob/SCOPTIONS
Else
    makelink from amiga.c to amiga/amiga.c hard force
    makelink from amiga.h to amiga/amiga.h hard force
    makelink from config.h to amiga/config.h hard force
    makelink from SMakeFile to amiga/SMakeFile hard force
    makelink from SCOPTIONS to amiga/SCOPTIONS hard force
    ; glob directory
    makelink from glob/SMakeFile to amiga/glob/SMakeFile hard force
    makelink from glob/SCOPTIONS to amiga/glob/SCOPTIONS hard force
EndIf
