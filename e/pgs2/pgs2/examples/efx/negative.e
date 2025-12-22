/* Simple test effect - Inverts an image.

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
    DEF r, v, b
    DEF x, y
    DEF i

    dosbase := g.dosbase
    pgsbase := g.pgsbase

    SetProgress( 'Inverting image...', 0 )

    i := g.depth
    SELECT i
        CASE 24
            FOR y := g.windY TO g.windY + g.windHeight
                IF Not( Mod(y,64) )
                    IF ( SetProgress( 0, ( y - g.windY ) *100 / g.windHeight ) <> 1 )
                        g.error := GIO_ABORTED
                        RETURN g.error
                    ENDIF
                ENDIF

                FOR x := g.windX TO g.windX + g.windWidth
                    GetSrcPixel( g, x, y, r, v, b )
                    PutDestPixel( g, x, y, 255 - Char(r), 255 - Char(v), 255 - Char(b))
                ENDFOR
            ENDFOR
        CASE 8
            FOR y := g.windY TO g.windY + g.windHeight
                IF Not( Div(y,64) )
                    IF ( SetProgress( 0, ( y - g.windY ) *100 / g.windHeight ) <> 1 )
                        g.error := GIO_ABORTED
                    ENDIF
                ENDIF

                FOR x := g.windX TO g.windX + g.windWidth
                    r := GetSrcPixel8( g, x, y )
                    PutDestPixel8( g, x, y, 255 - r)
                ENDFOR
            ENDFOR
    ENDSELECT

ENDPROC g.error

PROC efxPrefs(g:PTR TO giodata,z) IS EMPTY

PROC efxAbout(g:PTR TO giodata,z) IS EMPTY

PROC main() IS EMPTY
