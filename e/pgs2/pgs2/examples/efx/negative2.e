/* Simple test effect - Inverts an image using a faster method than negative.e

    Copyright © 1995-1996 Almathera Systems Ltd. All Rights Reserved
    AmigaE version by Dominique Dutoit (eightyfour@hotmail.com)
*/
LIBRARY 'neg.efx',1,1,'negative' IS efxInfo, efxPreRender, efxRender, efxPrefs, efxAbout

MODULE 'pgs', 'efx', 'pgsrexx', 'photogenics/parse', 'photogenics/gio', 'photogenics/efx'

PROC efxInfo()
    RETURN ( EFX_24BIT OR EFX_NOOPTIONS OR EFX_8GREY )
ENDPROC

PROC efxPreRender(g:PTR TO giodata,z) IS EMPTY

PROC efxRender(g:PTR TO giodata,z)
    DEF peeker=0:PTR TO CHAR, poker=0:PTR TO CHAR
    DEF x, y

    dosbase := g.dosbase
    pgsbase := g.pgsbase

    SetProgress( 'Inverting image...', 0 )

    FOR y := g.windY TO g.windY + g.windHeight

        IF Not(Mod(y,64))
            IF ( SetProgress( 0, ( y - g.windY ) *100 / g.windHeight ) <> 1 )
                g.error := GIO_ABORTED
                RETURN g.error
            ENDIF
        ENDIF

        peeker := GetSrcLine( g, y OR PGVM_READONLY )
        poker := GetDestLine( g, y OR PGVM_WRITEONLY )

        IF ( peeker AND poker )
            peeker := peeker + Mul(g.windX,3)
            poker := poker + Mul(g.windX,3)

            FOR x := 0 TO Mul(g.windWidth,3)
                poker[]++ := 255-(peeker[]++)
            ENDFOR
        ENDIF
        IF (peeker) THEN ReleaseSrcLine( g, y OR PGVM_READONLY )
        IF (poker) THEN ReleaseDestLine( g, y OR PGVM_WRITEONLY )
    ENDFOR
ENDPROC g.error

PROC efxPrefs(g:PTR TO giodata,z) IS EMPTY

PROC efxAbout(g:PTR TO giodata,z) IS EMPTY

PROC main() IS EMPTY
