
/*

    $VER: corners_plugin 1.1 (25.2.98)

    Author:         Ali Graham ($01)
                    <agraham@hal9000.net.au>

    PLUGIN id:      $07

    Desc.:          Choose between the corners of a rectangle.

    Tags:           PLA_Corners_Width                [I..]
                    PLA_Corners_Height               [I..]
                    PLA_Corners_BoxWidth             [ISG]
                    PLA_Corners_BoxHeight            [ISG]
                    PLA_Corners_ActiveCorner         [ISG]
                    PLA_Corners_FGColor              [ISG]
                    PLA_Corners_BGColor              [ISG]
                    PLA_Corners_Disabled             [ISG]

    Values:         PLV_Corners_CornerNone
                    PLV_Corners_CornerTopLeft
                    PLV_Corners_CornerTopRight
                    PLV_Corners_CornerLowerLeft
                    PLV_Corners_CornerLowerRight


*/

OPT MODULE, OSVERSION=37

->> corners_plugin: Modules

MODULE 'tools/easygui', 'graphics/text',
       'intuition/intuition', 'graphics/rastport',
       'utility', 'utility/tagitem', 'tools/ghost'

-><

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */

->> corners_plugin: Definitions

EXPORT ENUM PLV_Corners_CornerNone=0,
            PLV_Corners_CornerTopLeft,
            PLV_Corners_CornerTopRight,
            PLV_Corners_CornerLowerLeft,
            PLV_Corners_CornerLowerRight

CONST NUM_CORNERS= PLV_Corners_CornerLowerRight

EXPORT OBJECT corners_plugin OF plugin PRIVATE

    width
    height
    box_width
    box_height
    corner
    colour_fg
    colour_bg
    disabled

    mouse_x
    mouse_y

    corners[NUM_CORNERS]:ARRAY OF LONG

ENDOBJECT

OBJECT corner

    x, y, w, h

    rel_x, rel_y

ENDOBJECT

EXPORT ENUM PLA_Corners_Width=$81070001,    -> [I..]
            PLA_Corners_Height,             -> [I..]
            PLA_Corners_BoxWidth,           -> [ISG]
            PLA_Corners_BoxHeight,          -> [ISG]
            PLA_Corners_ActiveCorner,       -> [ISG]
            PLA_Corners_FGColor,            -> [ISG]
            PLA_Corners_BGColor,            -> [ISG]
            PLA_Corners_Disabled            -> [ISG]

-><

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */

->> corners_plugin: corners()

PROC corners(tags:PTR TO tagitem) OF corners_plugin

    DEF a, corner:PTR TO corner

    IF utilitybase

        self.width      :=  GetTagData(PLA_Corners_Width, 32, tags)
        self.height     :=  GetTagData(PLA_Corners_Height, 24, tags)
        self.box_width  :=  GetTagData(PLA_Corners_BoxWidth, 8, tags)
        self.box_height :=  GetTagData(PLA_Corners_BoxHeight, 6, tags)
        self.corner     :=  GetTagData(PLA_Corners_ActiveCorner, PLV_Corners_CornerNone, tags)
        self.colour_fg  :=  GetTagData(PLA_Corners_FGColor, 1, tags)
        self.colour_bg  :=  GetTagData(PLA_Corners_BGColor, 0, tags)
        self.disabled   :=  GetTagData(PLA_Corners_Disabled, FALSE, tags)

    ELSE

        Raise("util")

    ENDIF

    FOR a:=1 TO NUM_CORNERS

        NEW corner
        
        SELECT a

            CASE PLV_Corners_CornerTopLeft

                corner.rel_x:=0
                corner.rel_y:=0

            CASE PLV_Corners_CornerTopRight

                corner.rel_x:=self.width - self.box_width
                corner.rel_y:=0

            CASE PLV_Corners_CornerLowerLeft

                corner.rel_x:=0
                corner.rel_y:=self.height - self.box_height

            CASE PLV_Corners_CornerLowerRight

                corner.rel_x:=self.width - self.box_width
                corner.rel_y:=self.height - self.box_height

        ENDSELECT

        corner.w:=self.box_width
        corner.h:=self.box_height

        self.corners[a-1]:=corner

    ENDFOR

ENDPROC

PROC end() OF corners_plugin

    DEF a, corner:PTR TO corner

    FOR a:=0 TO (NUM_CORNERS-1)

        corner:=self.corners[a]

        END corner

    ENDFOR

ENDPROC

-><

->> corners_plugin: set() & get()

PROC set(attr, value) OF corners_plugin

    SELECT attr

        CASE PLA_Corners_BoxWidth

            IF (value <> self.box_width) AND (value < self.width)

                self.box_width:=value

                IF self.disabled=FALSE THEN self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_Corners_BoxHeight

            IF (value <> self.box_height) AND (value < self.height)

                self.box_height:=value

                IF self.disabled=FALSE THEN self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_Corners_ActiveCorner

            IF self.corner<>value

                self.corner:=value

                IF self.disabled=FALSE THEN self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_Corners_FGColor

            IF self.colour_fg<>value

                self.colour_fg:=value

                IF self.disabled=FALSE THEN self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_Corners_BGColor

            IF self.colour_bg<>value

                self.colour_bg:=value

                IF self.disabled=FALSE THEN self.draw(self.gh.wnd)

            ENDIF

        CASE PLA_Corners_Disabled

            IF self.disabled<>value

                self.disabled:=value

                self.draw(self.gh.wnd)

            ENDIF

    ENDSELECT

ENDPROC

PROC get(attr) OF corners_plugin

    SELECT attr

        CASE PLA_Corners_BoxWidth;          RETURN self.box_width,  TRUE
        CASE PLA_Corners_BoxHeight;         RETURN self.box_height, TRUE
        CASE PLA_Corners_ActiveCorner;      RETURN self.corner,     TRUE
        CASE PLA_Corners_FGColor;           RETURN self.colour_fg,  TRUE
        CASE PLA_Corners_BGColor;           RETURN self.colour_bg,  TRUE
        CASE PLA_Corners_Disabled;          RETURN self.disabled,   TRUE

    ENDSELECT

ENDPROC -1, FALSE

-><

->> corners_plugin: draw()
PROC draw(win:PTR TO window) OF corners_plugin

    DEF corner:PTR TO corner, a

    IF win

        SetStdRast(win.rport)

        Box(self.x, self.y, (self.x+(self.xs-1)), (self.y+(self.ys-1)), self.colour_bg)

        IF self.disabled=FALSE

            FOR a:=1 TO NUM_CORNERS

                corner:=self.corners[a-1]

                corner.x:=self.x; corner.y:=self.y

            ENDFOR

            IF self.corner<>PLV_Corners_CornerNone

                corner:=self.corners[self.corner-1]

                corner.draw(self.colour_fg)

            ENDIF

        ELSE

            ghost(win, self.x, self.y, self.xs, self.ys)

        ENDIF

    ENDIF

ENDPROC
-><

->> corners_plugin: min_size() & will_resize()

PROC min_size(font:PTR TO textattr, font_height) OF corners_plugin IS self.width, self.height

PROC will_resize() OF corners_plugin IS FALSE

-><

->> corners_plugin: render()

PROC render(ta:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF corners_plugin

    self.draw(win)

ENDPROC 

-><

->> corners_plugin: message_test() & message_action()

PROC message_test(imsg:PTR TO intuimessage, win:PTR TO window) OF corners_plugin

    IF (imsg.class=IDCMP_MOUSEBUTTONS) AND (imsg.code=SELECTDOWN)

        IF self.inside_box(imsg.mousex, imsg.mousey)

            self.mouse_x:=imsg.mousex
            self.mouse_y:=imsg.mousey

            RETURN TRUE

        ENDIF

    ENDIF

ENDPROC FALSE

PROC message_action(class, qual, code, win:PTR TO window) OF corners_plugin

    DEF corner:PTR TO corner, a

    IF (class=IDCMP_MOUSEBUTTONS) AND (code=SELECTDOWN)

        FOR a:=1 TO NUM_CORNERS

            corner:=self.corners[a-1]

            IF corner.inside(self.mouse_x, self.mouse_y) THEN self.set(PLA_Corners_ActiveCorner, a)

        ENDFOR

    ENDIF

ENDPROC TRUE

-><

/* $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ */

->> corners_plugin: private procedures

PROC inside_box(x_click, y_click) OF corners_plugin

ENDPROC ((x_click >= self.x) AND (x_click <= (self.x + (self.xs -1))) AND
        ((y_click >= self.y) AND (y_click <= (self.y + (self.ys -1)))))

PROC inside(x_click, y_click) OF corner

    x_click:=x_click - self.x
    y_click:=y_click - self.y

ENDPROC ((x_click >= self.rel_x) AND (x_click <= (self.rel_x + self.w)) AND
         (y_click >= self.rel_y) AND (y_click <= (self.rel_y + self.h)))

PROC draw(colour) OF corner IS Box(self.x + self.rel_x, self.y + self.rel_y,
                                   (self.x + self.rel_x + self.w) -1 ,
                                   (self.y + self.rel_y + self.h) - 1,
                                   colour)

-><
