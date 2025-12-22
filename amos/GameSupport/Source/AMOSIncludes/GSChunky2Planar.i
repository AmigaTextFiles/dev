
        STRUCTURE       GSC2PInfo,0

        UWORD   GSC2P_Width             ; Max. Width of chunky buffer
        UWORD   GSC2P_Height            ; Max. Height of chunky buffer

        UWORD   GSC2P_BytesPerRow       ; Bytes in each row of the chunky buffer
        UWORD   GSC2P_Modulo            ; BytesPerRow-Width
        UWORD   GSC2P_BytesPerPixel     ; will be either 1 or 3

        UWORD   GSC2P_TopEdge           ; \
        UWORD   GSC2P_BottomEdge        ;  \ Coordinates to which the
        UWORD   GSC2P_LeftEdge          ;  / conversion will be restricted
        UWORD   GSC2P_RightEdge         ; /  (writable)

        UWORD   GSC2P_Type

        APTR    GSC2P_ColourMap         ; Pointer to the colourmap (or 0)
                                        ; N.B. you may change the entries in the
                                        ; colour table but not this pointer!
        UWORD   GSC2P_ColourMapDirty    ; Non-null if cmap has changed (writable)

        UWORD   GSC2P_DebugMode
        LABEL   GSC2PInfo_Size


