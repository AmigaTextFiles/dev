n and may need a lot of stack space.

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
stc.library/FreeFileBuffer

    NAME
        FreeFileBuffer -- Frees memory allocated with AllocFileBuffer(),
                       NewAllocFileBuffer() or AllocMemBuffer()

    SYNOPSIS
        FreeFileBuffer( filebuffer )
        -66             A1

        void FreeFileBuffer( APTR filebuffer );

    FUNCTION
        Frees memory allocated with AllocFileBuffer(), NewAllocFileBuffer()
        or AllocMemBuffer().

    INPUTS
        filebuffer = pointer buffer

    SEE ALSO
        AllocFileBuffer(), NewAllocFileBuffer(), AllocMemBuffer()

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
stc.library/LoadFileBuffer

    NAME
        LoadFileBuffer -- Load file into filebuffer

    SYNOPSIS
        length = LoadFileBuffer( filebuffer )
        D0       -72             A0

        ULONG LoadFileBuffer( APTR filebuffer );

    FUNCTION
        Loads a file into buffer. Buffer must have been allocated with
        AllocFileBuffer() or NewAllocFileBuffer().
        This function takes auto