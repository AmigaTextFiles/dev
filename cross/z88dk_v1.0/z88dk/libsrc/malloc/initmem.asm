;
;       Small C+ Library Functions
;
;       Memory Functions
;
;       The routines in this directory are a little kludgey to say the
;       least, but at least they give you a heap from BBC BASIC
;
;       These routines were found on an MSX homepage from the net
;
;       Added to Z88dk archive 1/3/99
;
;       void initmem(size)

                XLIB    initmem
                LIB     getfree
                XDEF    heapblocks
                XDEF    heaplast
                XREF    smc_heap        ;the heap!

;
;       Initialise Memory
;
;       WARNING!! THIS FILE CONTAINS STATIC VARIABLES!!!
;

; Exit: hl=free blocks

.initmem
        pop     bc
        pop     hl      ;heapsize
        push    hl
        push    bc
        push    hl
        ld   hl,1
        ld   (HeapBlocks),hl    ; One free block fot starters
        ld   hl,smc_heap
        ld   (HeapLast),hl
        ld   (smc_heap),hl      ; First block points to itself
        pop     hl              ; heap size
        ld   (smc_heap+2),hl    ; Has size of whole heap
        ret






.heapblocks     defw    0
.heaplast       defw    0
