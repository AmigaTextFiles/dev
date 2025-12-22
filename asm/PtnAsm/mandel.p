********************************************

        incdir  "asminclude:"
        include "lvos/powerpc_lib.i"
        include "lvos/intuition_lib.i"
        include "lvos/graphics_lib.i"
        include "lvos/exec_lib.i"
        include "lvos/dos_lib.i"
        include "powerpc/memoryppc.i"
        include "powerpc/powerpc.i"
        include "powerpc/ppcmacros.i"
        include "intuition/intuition.i"

********************************************


        xdef        _main
        xref        _PowerPCBase
        xref        _DOSBase
        xref        _SysBase

        escapestr   1

lastr:  macro
        save
        section  "strings",data
\@      cstring   "\2"
        restore
        \1    =     &\@
        endm

call_exec: macro
           run68k_xl   _SysBase,\1
           tstw        _d0
           endm

call_int:  macro
           run68k_xl   _IntuitionBase,\1
           tstw        _d0
           endm

call_graf: macro
           run68k_xl   _GfxBase,\1
           tstw        _d0
           endm

call_dos:  macro
           run68k_xl   _DOSBase,\1
           tstw        _d0
           endm

OS_VER     equ      40

********************************************

_main:
        prolog
        *_stack     = stack

        bl          _open_libs
        bl          _init_screen

        bl          _draw
        bl          _display
        bl          _clean_up
        epilog

_exit:
        prolog
        stack       = *_stack
        epilog

********************************************
_display:
        prolog      PP_SIZE+20

        _d7         =  0
.loop:
        _a0         =  *_vp
        _d0         =  _d7
        _d1         =  shiftl(_d7,24)
        _d2         =  _d1
        _d3         =  _d1
        call_graf   SetRGB32

        _d7         =  _d7 + 1
        cmpw(_d7,256)
        blt         .loop

        _a0         =  *_rp
        _d0         =  0
        _d1         =  0
        _d2         =  *_width.w
        _d3         =  *_height.w
        _d4         =  *_width.w
        _a2         =  *_chunky
        _d2         =  _d2 - 1
        _d3         =  _d3 - 1
        call_graf   WriteChunkyPixels


        epilog

********************************************

_error_int:
        lastr       _d1,<Can't open intuition.library\n>
        b           _print_error
_error_gfx:
        lastr       _d1,<Can't open dos.library\n>
        b           _print_error
_error_mem:
        lastr       _d1,<Not enought memory\n>
        b           _print_error
_error_screen:
        lastr       _d1,<Can't open screen\n>
        b           _print_error


_print_error:
        prolog      PP_SIZE+20
        call_dos    PutStr
        b           _exit
        epilog
********************************************
_open_libs:
        prolog      PP_SIZE+20

        lastr       _a1,<intuition.library>
        _d0         =  OS_VER
        call_exec   OpenLibrary
        beq         _error_int
        *_IntuitionBase   =  _d0

        lastr       _a1,<graphics.library>
        _d0         =  OS_VER
        call_exec   OpenLibrary
        beq         _error_gfx
        *_GfxBase   =  _d0


        epilog

********************************************
_init_screen:
        prolog      PP_SIZE+20
        _a0         =     0
        _a1         =     &_screen_tags
        call_int    OpenScreenTagList
        beq         _error_screen
        *_screen    =  _d0

        _d1         =  sc_Width(_d0.w)
        _d2         =  sc_Height(_d0.w)
        _d3         =  _d0 + sc_RastPort
        _d4         =  _d0 + sc_ViewPort

        *_width.w   =  _d1
        *_height.w  =  _d2
        *_rp        =  _d3
        *_vp        =  _d4

        r4          =  _d1 * _d2
        r5          =  MEMF_ANY
        r6          =  0
        callpowerpc AllocVecPPC
        tstw        r3
        beq         _error_mem
        *_chunky    =  r3
        epilog
 
        save
        data

_screen_tags: 
        dc.l     SA_LikeWorkbench,1
        dc.l     SA_Depth,8
        dc.l     SA_Type,CUSTOMSCREEN
        dc.l     SA_AutoScroll,1
        dc.l     TAG_DONE

        restore

********************************************

deltax        fsetr    f29
deltay        fsetr    f28
x             fsetr    f27
y             fsetr    f26
a             fsetr    f25
old_a         fsetr    f24
bi            fsetr    f23
r             fsetr    f22
zero          fsetr    f21
lenght_z      fsetr    f20
temp1         fsetr    f19
temp2         fsetr    f18

chunky        setr     r31
loop_y        setr     r30
loop_x        setr     r29
iterations   setr     r28

_draw:
        prolog

        r3       =  *_width.w
        bl       _citf
        f31      =  f1
        r3       =  *_height.w
        bl       _citf
        f30      =  f1

        x        =  *_min_x.s
        y        =  *_min_y.s
        f1       =  *_max_x.s
        f2       =  *_max_y.s
        chunky   =  *_chunky
        chunky   =  chunky - 1  ;for stbu

        deltax   =  f1 - x
        deltay   =  f2 - y
        deltax   =  deltax / f31
        deltay   =  deltay / f30
        r        =  *_r.s
        zero     =  *_zero.s

        loop_y   =  *_height.w
.loop_y:
        loop_x   =  *_width.w
        x        =  *_min_x.s
.loop_x:
        a        =  zero
        bi       =  zero
        iterations =  0

.loop:
        old_a    =  a

        temp1    =  bi * bi + x
        temp2    =  bi * a + y

        a        =  a * a - temp1
        bi       =  temp2 + temp2

        temp1    =  a*a
        iterations = iterations + 1
        lenght_z =  bi*bi + temp1

        fcmpu(lenght_z,r)
        bgt      .put_pixel

        cmpw(iterations,128)
        bgt      .put_pixel
        b        .loop

.put_pixel:

        1[chunky.b] =  iterations

        x        =  x  +  deltax

        loop_x   =  loop_x - 1
        tstw     loop_x
        bgt+     .loop_x

        y        =  y  +  deltay
        loop_y   =  loop_y - 1
        tstw     loop_y
        bgt+     .loop_y




        epilog

        save
        data

        align.s
_min_x:    dc.s  -2
_max_x:    dc.s  1.25
_min_y:    dc.s  -1.25
_max_y:    dc.s  1.25
_zero:     dc.s  0
_r:        dc.s  4
        restore

_citf:
         lf      f2,_CITF0
         xoris   trash,r3,$8000
         sw      trash,_CITF_TEMP+4
         lf      f1,_CITF_TEMP
         fsub    f1,f1,f2
         blr

         save
         data

_CITF0:         dc.l    $43300000,$80000000
_CITF_TEMP      dc.l    $43300000,0

         restore


********************************************
_close_libs:
        prolog      PP_SIZE+20

        epilog

_clean_up:
        prolog      PP_SIZE+20

        _d1         =  200
        _d0         =  200
        call_dos    Delay

        _d0         =  *_screen
        tstw        _d0
        beq         .1
        mr          _a0,_d0
        call_int    CloseScreen
.1:


        callpowerpc FreeAllMem
        
        bl          _close_libs
        b           _exit
        epilog
********************************************

        bss_f
_stack:          ds.l  1
_IntuitionBase:  ds.l  1
_GfxBase:        ds.l  1
_screen:         ds.l  1
_chunky:         ds.l  1
_vp:             ds.l  1
_rp:             ds.l  1
_height:         ds.w  1
_width:          ds.w  1
