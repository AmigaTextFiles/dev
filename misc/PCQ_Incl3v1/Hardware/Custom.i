{
        Custom.i for PCQ Pascal
}

Type

    AudChannel = record
        ac_ptr          : Address;      { ptr to start of waveform data }
        ac_len          : Short;        { length of waveform in words }
        ac_per          : Short;        { sample period }
        ac_vol          : Short;        { volume }
        ac_dat          : Short;        { sample pair }
        ac_pad          : Array [0..1] of Short;        { unused }
    end;
    AudChannelPtr = ^AudChannel;

    SpriteDef = record
        pos             : Short;
        ctl             : Short;
        dataa           : Short;
        datab           : Short;
    end;
    SpriteDefPtr = ^SpriteDef;

    Custom = record
        bltddat         : Short;
        dmaconr         : Short;
        vposr           : Short;
        vhposr          : Short;
        dskdatr         : Short;
        joy0dat         : Short;
        joy1dat         : Short;
        clxdat          : Short;
        adkconr         : Short;
        pot0dat         : Short;
        pot1dat         : Short;
        potinp          : Short;
        serdatr         : Short;
        dskbytr         : Short;
        intenar         : Short;
        intreqr         : Short;
        dskpt           : Address;
        dsklen          : Short;
        dskdat          : Short;
        refptr          : Short;
        vposw           : Short;
        vhposw          : Short;
        copcon          : Short;
        serdat          : Short;
        serper          : Short;
        potgo           : Short;
        joytest         : Short;
        strequ          : Short;
        strvbl          : Short;
        strhor          : Short;
        strlong         : Short;
        bltcon0         : Short;
        bltcon1         : Short;
        bltafwm         : Short;
        bltalwm         : Short;
        bltcpt          : Address;
        bltbpt          : Address;
        bltapt          : Address;
        bltdpt          : Address;
        bltsize         : Short;
        pad2d           : Array [0..2] of Short;
        bltcmod         : Short;
        bltbmod         : Short;
        bltamod         : Short;
        bltdmod         : Short;
        pad34           : Array [0..3] of Short;
        bltcdat         : Short;
        bltbdat         : Short;
        bltadat         : Short;
        pad3b           : Array [0..3] of Short;
        dsksync         : Short;
        cop1lc          : Integer;
        cop2lc          : Integer;
        copjmp1         : Short;
        copjmp2         : Short;
        copins          : Short;
        diwstrt         : Short;
        diwstop         : Short;
        ddfstrt         : Short;
        ddfstop         : Short;
        dmacon          : Short;
        clxcon          : Short;
        intena          : Short;
        intreq          : Short;
        adkcon          : Short;
        aud             : Array [0..3] of AudChannel;
        bplpt           : Array [0..5] of Address;
        pad7c           : Array [0..3] of Short;
        bplcon0         : Short;
        bplcon1         : Short;
        bplcon2         : Short;
        pad83           : Short;
        bpl1mod         : Short;
        bpl2mod         : Short;
        pad86           : Array [0..1] of Short;
        bpldat          : Array [0..5] of Short;
        pad8e           : Array [0..1] of Short;
        sprpt           : Array [0..7] of Address;
        spr             : Array [0..7] of SpriteDef;
        color           : Array [0..31] of Short;
        htotal          : Short;
        hsstop          : Short;
        hbstrt          : Short;
        hbstop          : Short;
        vtotal          : Short;
        vsstop          : Short;
        vbstrt          : Short;
        vbstop          : Short;
        sprhstrt        : Short;
        sprhstop        : Short;
        bplhstrt        : Short;
        bplhstop        : Short;
        hhposw          : Short;
        hhposr          : Short;
        beamcon0        : Short;
        hsstrt          : Short;
        vsstrt          : Short;
        hcenter         : Short;
        diwhigh         : Short;
    end;
    CustomPtr = ^Custom;

CONST
{    defines for beamcon register }
  VARVBLANK     =  $1000;  {    Variable vertical blank enable }
  LOLDIS        =  $0800;  {    long line disable }
  CSCBLANKEN    =  $0400;  {    redirect composite sync }
  VARVSYNC      =  $0200;  {    Variable vertical sync enable }
  VARHSYNC      =  $0100;  {    Variable horizontal sync enable }
  VARBEAM       =  $0080;  {    variable beam counter enable }
  DISPLAYDUAL   =  $0040;  {    use UHRES pointer AND standard pointers }
  DISPLAYPAL    =  $0020;  {    set decodes to generate PAL display }
  VARCSYNC      =  $0010;  {    Variable composite sync enable }
  CSBLANK       =  $0008;  {    Composite blank out to CSY* pin }
  CSYNCTRUE     =  $0004;  {    composite sync TRUE signal }
  VSYNCTRUE     =  $0002;  {    vertical sync TRUE }
  HSYNCTRUE     =  $0001;  {    horizontal sync TRUE }

{    new defines for bplcon0 }
  USE_BPLCON3   =  1;

{    new defines for bplcon2 }
  BPLCON2_ZDCTEN        =  1024; {    colormapped genlock bit }
  BPLCON2_ZDBPEN        =  2048; {    use bitplane as genlock bits }
  BPLCON2_ZDBPSEL0      =  4096; {    three bits to select one }
  BPLCON2_ZDBPSEL1      =  8192; {    of 8 bitplanes in }
  BPLCON2_ZDBPSEL2      =  16384; {    ZDBPEN genlock mode }

{    defines for bplcon3 register }
  BPLCON3_EXTBLNKEN     =  1;  {    external blank enable }
  BPLCON3_EXTBLKZD      =  2;  {    external blank ored into trnsprncy }
  BPLCON3_ZDCLKEN       =  4;  {    zd pin outputs a 14mhz clock}
  BPLCON3_BRDNTRAN      =  16;  {    border is opaque }
  BPLCON3_BRDNBLNK      =  32;  {    border is opaque }



