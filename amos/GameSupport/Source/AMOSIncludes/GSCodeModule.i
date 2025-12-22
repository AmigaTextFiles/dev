        IFND EXEC_TYPES_I
        INCLUDE "exec/types.i"
        ENDC

        IFND GS_CodeModule_I
GS_CodeModule_I SET     1

        STRUCTURE GSCM_Header,0
        ULONG   GSCMH_Match1 ; should be "GSMo"
        ULONG   GSCMH_Match2 ; should be "dule"

        APTR    GSCMH_Name
        APTR    GSCMH_Author
        APTR    GSCMH_Comment

        FPTR    GSCMH_Initialise
        FPTR    GSCMH_CleanUp

        APTR    GSCMH_FunctionHash
        APTR    GSCMH_AttributeHash

        LABEL   GSCM_Header_Size


MakeFunction    MACRO
        dc.l    \1
        dc.l    \1Name
        ENDM

MakeAttr        MACRO
\1
        dc.l    0
        dc.l    \1Name
        ENDM

        ENDC

