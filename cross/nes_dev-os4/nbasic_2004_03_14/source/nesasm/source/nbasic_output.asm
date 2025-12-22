nbasic_stack = 256
nmi_hit = 0

nmi_wait:
 lda #0
 sta nmi_hit

nmi_wait_1:
 lda #0
 cmp nmi_hit
 beq nmi_wait_1
 rts

nmi:
 pha
 txa
 pha
 tya
 pha
 lda #1
 sta nmi_hit
 pla
 tay
 pla
 tax
 pla
 rti

