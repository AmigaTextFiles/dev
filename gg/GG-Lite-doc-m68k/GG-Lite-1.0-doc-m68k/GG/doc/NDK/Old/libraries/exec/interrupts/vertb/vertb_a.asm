
*
* Vertb_a.asm - assembler vertical blank server
* Passed is_Data pointer in A1 (pointer to counter in C code above)
*
        XDEF    _VertBServer
        section code
_VertBServer:
        ADDI.L  #1,(A1) ;increment the counter is_Data points to  
        MOVEQ.L #0,D0   ;set Z flag to continue to process other vb-servers
        RTS
        END
