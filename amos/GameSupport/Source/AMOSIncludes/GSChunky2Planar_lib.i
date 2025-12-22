        IFND EXEC_LIBRARIES_I
        INCLUDE "exec/libraries.i"
        ENDC        ; EXEC_NODES_I

        LIBINIT
        LIBDEF  GSInitialiseC2P
        LIBDEF  GSCleanupC2P
        LIBDEF  GSGetC2PInfo
        LIBDEF  GSGoC2P
        LIBDEF  GSGetDisplay
        LIBDEF  GSRestoreDisplay

