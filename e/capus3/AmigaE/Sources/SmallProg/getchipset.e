-> GetChipSet © NasGûl


MODULE 'graphics/gfxbase'

PROC main()
    DEF g:PTR TO gfxbase
    g:=gfxbase
    IF (g.chiprevbits0 AND GFXF_HR_DENISE)
        WriteF('ECS-Denise (8373)\n')
    ELSE
        WriteF('Normal Denise (8362)\n')
    ENDIF
    IF (g.chiprevbits0 AND GFXF_HR_AGNUS)
        WriteF('ECS-Agnus (8372)\n')
    ELSE
        WriteF('Normal Agnus\n')
    ENDIF
    IF (g.chiprevbits0 AND (GFXF_AA_ALICE OR GFXF_AA_LISA OR GFXF_AA_MLISA))
        IF (g.chiprevbits0 AND GFXF_AA_ALICE)
            WriteF('AA-Alice\n')
        ELSE
            WriteF('Non AA-Alice\n')
        ENDIF
        IF (g.chiprevbits0 AND GFXF_AA_LISA)
            WriteF('AA-Lisa\n')
        ELSE
            WriteF('Non AA-Lisa\n')
        ENDIF
        IF (g.chiprevbits0 AND GFXF_AA_MLISA)
            WriteF('AA-MLisa\n')
        ELSE
            WriteF('Non AA-MLisa\n')
        ENDIF
    ENDIF
ENDPROC



