;
; ** $VER: custom.h 39.1 (18.9.92)
; ** Includes Release 40.15
; **
; ** Offsets of Amiga custom chip registers
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

;
;  * do this to get base of custom registers:
;  * extern struct Custom custom;
;

Structure AudChannel
      *ac_ptr.w ;  ptr to start of waveform data
      ac_len.w ;  length of waveform in words
      ac_per.w ;  sample period
      ac_vol.w ;  volume
      ac_dat.w ;  sample pair
      ac_pad.w[2] ;  unused
EndStructure


Structure SpriteDef
      pos.w
      ctl.w
      dataa.w
      datab.w
EndStructure

Structure Custom
    bltddat.w
    dmaconr.w
    vposr.w
    vhposr.w
    dskdatr.w
    joy0dat.w
    joy1dat.w
    clxdat.w
    adkconr.w
    pot0dat.w
    pot1dat.w
    potinp.w
    serdatr.w
    dskbytr.w
    intenar.w
    intreqr.w
    *dskpt.l
    dsklen.w
    dskdat.w
    refptr.w
    vposw.w
    vhposw.w
    copcon.w
    serdat.w
    serper.w
    potgo.w
    joytest.w
    strequ.w
    strvbl.w
    strhor.w
    strlong.w
    bltcon0.w
    bltcon1.w
    bltafwm.w
    bltalwm.w
    *bltcpt.l
    *bltbpt.l
    *bltapt.l
    *bltdpt.l
    bltsize.w
    pad2d.b
    bltcon0l.b ;  low 8 bits of bltcon0, write only
    bltsizv.w
    bltsizh.w ;  5e
    bltcmod.w
    bltbmod.w
    bltamod.w
    bltdmod.w
    pad34.w[4]
    bltcdat.w
    bltbdat.w
    bltadat.w
    pad3b.w[3]
    deniseid.w ;  7c
    dsksync.w
    cop1lc.l
    cop2lc.l
    copjmp1.w
    copjmp2.w
    copins.w
    diwstrt.w
    diwstop.w
    ddfstrt.w
    ddfstop.w
    dmacon.w
    clxcon.w
    intena.w
    intreq.w
    adkcon.w
    aud.AudChannel[4]
    *bplpt.l[8]
    bplcon0.w
    bplcon1.w
    bplcon2.w
    bplcon3.w
    _BPL1_MOD.w
    _BPL2_MOD.w
    bplcon4.w
    clxcon2.w
    bpldat.w[8]
    *sprpt.l[8]
    spr.SpriteDef[8]
    color.w[32]
    htotal.w
    hsstop.w
    hbstrt.w
    hbstop.w
    vtotal.w
    vsstop.w
    vbstrt.w
    vbstop.w
    sprhstrt.w
    sprhstop.w
    bplhstrt.w
    bplhstop.w
    hhposw.w
    hhposr.w
    beamcon0.w
    hsstrt.w
    vsstrt.w
    hcenter.w
    diwhigh.w ;  1e4
    padf3.w[11]
    fmode.w
EndStructure

;  defines for beamcon register
#VARVBLANK = $1000 ;  Variable vertical blank enable
#LOLDIS  = $0800 ;  long line disable
#CSCBLANKEN = $0400 ;  redirect composite sync
#VARVSYNC = $0200 ;  Variable vertical sync enable
#VARHSYNC = $0100 ;  Variable horizontal sync enable
#VARBEAM = $0080 ;  variable beam counter enable
#DISPLAYDUAL = $0040 ;  use UHRES pointer and standard pointers
#DISPLAYPAL = $0020 ;  set decodes to generate PAL display
#VARCSYNC = $0010 ;  Variable composite sync enable
#CSBLANK = $0008 ;  Composite blank out to CSY* pin
#CSYNCTRUE = $0004 ;  composite sync true signal
#VSYNCTRUE = $0002 ;  vertical sync true
#HSYNCTRUE = $0001 ;  horizontal sync true

;  new defines for bplcon0
#USE_BPLCON3 = 1

;  new defines for bplcon2
#BPLCON2_ZDCTEN  = (1 << 10) ;  colormapped genlock bit
#BPLCON2_ZDBPEN  = (1 << 11) ;  use bitplane as genlock bits
#BPLCON2_ZDBPSEL0 = (1 << 12) ;  three bits to select one
#BPLCON2_ZDBPSEL1 = (1 << 13) ;  of 8 bitplanes in
#BPLCON2_ZDBPSEL2 = (1 << 14) ;  ZDBPEN genlock mode

;  defines for bplcon3 register
#BPLCON3_EXTBLNKEN = (1 << 0) ;  external blank enable
#BPLCON3_EXTBLKZD = (1 << 1) ;  external blank ored into trnsprncy
#BPLCON3_ZDCLKEN = (1 << 2) ;  zd pin outputs a 14mhz clock
#BPLCON3_BRDNTRAN = (1 << 4) ;  border is opaque
#BPLCON3_BRDNBLNK = (1 << 5) ;  border is opaque


