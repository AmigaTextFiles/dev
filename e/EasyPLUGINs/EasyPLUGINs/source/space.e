
/*

    $VER: space_plugin 1.2 (25.5.98)

    Author:         Ali Graham
                    <agraham@hal9000.net.au>

    Desc.:          Replacement for SPACE with a bit more control over
                    the size.

*/


OPT MODULE, OSVERSION=37

MODULE 'tools/EasyGUI',
       'intuition/intuition',
       'utility', 'utility/tagitem'

EXPORT OBJECT space_plugin OF plugin PRIVATE

    w, h

    rx, ry

ENDOBJECT

-> PROGRAMMER_ID | MODULE_ID
->      $01      |   $05


EXPORT ENUM PLA_Space_Width=$81050001,   ->[I..]
            PLA_Space_Height,            ->[I..]
            PLA_Space_ResizeX,           ->[I..]
            PLA_Space_ResizeY            ->[I..]


PROC space(tags=NIL:PTR TO tagitem) OF space_plugin

    IF utilitybase

        self.w  := GetTagData(PLA_Space_Width, 0, tags)
        self.h  := GetTagData(PLA_Space_Height, 0, tags)
        self.rx := GetTagData(PLA_Space_ResizeX, FALSE, tags)
        self.ry := GetTagData(PLA_Space_ResizeY, FALSE, tags)

    ELSE

        Raise("util")

    ENDIF

ENDPROC

PROC min_size(ta,fh) OF space_plugin IS self.w, self.h

PROC will_resize() OF space_plugin IS ((IF self.rx THEN RESIZEX ELSE NIL) OR (IF self.ry THEN RESIZEY ELSE NIL))

PROC render(ta,x,y,xs,ys,w:PTR TO window) OF space_plugin IS EMPTY


