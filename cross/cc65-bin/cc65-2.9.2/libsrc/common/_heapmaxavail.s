;
; Ullrich von Bassewitz, 2003-02-01
;
; Return the size of the largest free block on the heap.
;
; size_t __fastcall__ _heapmaxavail (void);
;
;

	.importzp    	ptr1, ptr2
	.import	     	__hptr, __hfirst, __hlast, __hend
       	.export	     	__heapmaxavail

        .include        "_heap.inc"

       	.macpack	generic

;-----------------------------------------------------------------------------
; Code

__heapmaxavail:

; size_t Size = (_hend - _hptr) * sizeof (*_hend);

        lda     __hend
        sub     __hptr
        sta     ptr2
        lda     __hend+1
        sbc     __hptr+1
        sta     ptr2+1

; struct freeblock* F = _hfirst;

        lda     __hfirst
        sta     ptr1
        lda     __hfirst+1
@L1:    sta     ptr1+1

; while (F) {

        ora     ptr1
        beq     @L3             ; Jump if end of free list reached

; if (Size < F->size) {

        ldy     #freeblock_size
        lda     ptr2
        sub     (ptr1),y
        iny
        lda     ptr2+1
        sbc     (ptr1),y
        bcs     @L2

; Size = F->size;

        ldy     #freeblock_size
        lda     (ptr1),y
        sta     ptr2
        iny
        lda     (ptr1),y
        sta     ptr2+1

; F = F->next;

@L2:    iny                             ; Points to F->next
        lda     (ptr1),y
        tax
        iny
        lda     (ptr1),y
        stx     ptr1
        jmp     @L1

; return Size;

@L3:    lda     ptr2
        ldx     ptr2+1
        rts

