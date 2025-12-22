/* returns the version numbers of the libraries
** (exec, intuition, graphics)
*/

OPT MODULE
OPT PREPROCESS

#define lib_Version 20


/*
** Returns the version of an library or -1 on error.
*/
EXPORT PROC getLibraryVersion(libbase)

       MOVEQ   #-1,D0
       MOVE.L  libbase,D1
       BEQ.S   glv_error
       MOVEA.L D1,A0
       MOVEQ   #0,D0
       MOVE.W  lib_Version(A0),D0
glv_error:

ENDPROC D0


EXPORT PROC getExecVersion() IS getLibraryVersion(execbase)
EXPORT PROC getIntVersion()  IS getLibraryVersion(intuitionbase)
EXPORT PROC getGfxVersion()  IS getLibraryVersion(gfxbase)

