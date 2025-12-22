int
„ND_NoMem„=-2,
„ND_NoAudLib=-3,
„ND_MakeBad‚=-4,
„ND_UnitErr‚=-5,
„ND_CantAlloc=-6,
„ND_Unimplƒ=-7,
„ND_NoWrite‚=-8,
„ND_Expunged=-9,
„ND_PhonErr‚=-20,
„ND_RateErr‚=-21,
„ND_PitchErr=-22,
„ND_SexErrƒ=-23,
„ND_ModeErr‚=-24,
„ND_FreqErr‚=-25,
„ND_VolErrƒ=-26;

uint
„DEFPITCH„=110,
„DEFRATE…=150,
„DEFVOL†=64,
„DEFFREQ…=22200,
„MALEˆ=0,
„FEMALE†=1,
„NATURALF0ƒ=0,
„ROBOTICF0ƒ=1,
„DEFSEX†=MALE,
„DEFMODE…=NATURALF0,

„MINRATE…=40,
„MAXRATE…=400,
„MINPITCH„=65,
„MAXPITCH„=320,
„MINFREQ…=5000,
„MAXFREQ…=28000,
„MINVOL†=0,
„MAXVOL†=64;

type
„IOStdReq=unknown48,

„narrator_rb_t=struct{
ˆIOStdReq_tnw_message;
ˆuintnw_rate,nw_pitch,nw_mode,nw_sex;
ˆ*bytenw_ch_masks;
ˆuintnw_nm_masks,nw_volume,nw_sampfreq;
ˆushortnw_mouths,nw_chanmask,nw_numchan,nw_pad;
„},

„mouth_rb_t=struct{
ˆnarrator_rb_tnr_voice;
ˆushortnr_width,nr_height,nr_shape,nr_pad;
„};
