OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'devices/ahi'


OBJECT ahiaudioctrldrv
  audioctrl:ahiaudioctrl
  flags
  soundfunc
  playerfunc
  playerfreq
  minplayerfreq
  maxplayerfreq
  mixfreq
  channels:INT
  sounds:INT
  driverdata
  mixerfunc
  samplerfunc
  obsolete
  buffsamples
  minbuffsamples
  maxbuffsamples
  buffsize
  bufftype
  pretimer
  posttimer
ENDOBJECT

CONST AHIDB_USERBASE=$800001F4,
      AHISF_ERROR=1,
      AHISF_MIXING=2,
      AHISF_TIMING=4,
      AHISF_KNOWSTEREO=8,
      AHISF_KNOWHIFI=16,
      AHISF_CANRECORD=$20,
      AHISF_CANPOSTPROCESS=$40,
      AHISF_PLAY=1,
      AHISF_RECORD=2,
      AHIACF_VOL=1,
      AHIACF_PAN=2,
      AHIACF_STEREO=4,
      AHIACF_HIFI=8,
      AHIACF_PINGPONG=16,
      AHIACF_RECORD=$20,
      AHIACF_MULTTAB=$40,
      AHIS_UNKNOWN=-1,
      ID_AHIM=$4148494D,
      ID_AUDN=$4155444E,
      ID_AUDD=$41554444,
      ID_AUDM=$4155444D

