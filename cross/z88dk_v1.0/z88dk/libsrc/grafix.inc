;
;       Z88 Graphics Functions - Small C+ stubbs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;       Define for graphics and other standard library functions



IF !APPZ88
        defc    map_seg = 192
        defc    map_bk  = $4D3
ELSE
        defc    map_seg = 128     ;32768 - hope not too many statics
        defc    map_bk = $4D2
ENDIF

;       Structure for open window       struct *window

DEFVARS 0
{
        windnum ds.b    1
        wind_x  ds.b    1
        wind_y  ds.b    1
        wind_w  ds.b    1       ;width/map width
        wind_d  ds.b    1       ;
        type    ds.b    1       ;
        graph   ds.b    1       ;0=text 1=graphics
}

;       Structure for plotting          struct *pixels

DEFVARS 0
{
        pix_x0  ds.b    1       ;also relative draw
        pix_y0  ds.b    1       ;also relative draw
        pix_x1  ds.b    1       ;also box width
        pix_y1  ds.b    1       ;also box height
        spare   ds.b    1       ;used for distances in scroll
}

;       Structure for relative drawing  struct *draw

DEFVARS 0
{
        draw_x  ds.w    1
        draw_y  ds.w    1
}
