include "inc/exec/types.inc";

struct CIA is
  ciapra:ubyte;
  pad0[$ff]:ubyte;
  ciaprb:ubyte;
  pad1[$ff]:ubyte;
  ciaddra:ubyte;
  pad2[$ff]:ubyte;
  ciaddrb:ubyte;
  pad3[$ff]:ubyte;
  ciatalo:ubyte;
  pad4[$ff]:ubyte;
  ciatahi:ubyte;
  pad5[$ff]:ubyte;
  ciatblo:ubyte;
  pad6[$ff]:ubyte;
  ciatbhi:ubyte;
  pad7[$ff]:ubyte;
  ciatodlow:ubyte;
  pad8[$ff]:ubyte;
  ciatodmid:ubyte;
  pad9[$ff]:ubyte;
  ciatodhi:ubyte;
  pad10[$ff]:ubyte;
  unusedreg:ubyte;
  pad11[$ff]:ubyte;
  ciasdr:ubyte;
  pad12[$ff]:ubyte;
  ciaicr:ubyte;
  pad13[$ff]:ubyte;
  ciacra:ubyte;
  pad14[$ff]:ubyte;
  ciacrb:ubyte;
;

def CIAICRB_TA = 0;
def CIAICRB_TB = 1;
def CIAICRB_ALRM = 2;
def CIAICRB_SP = 3;
def CIAICRB_FLG = 4;
def CIAICRB_IR = 7;
def CIAICRB_SETCLR = 7;

def CIACRAB_START = 0;
def CIACRAB_PBON = 1;
def CIACRAB_OUTMODE = 2;
def CIACRAB_RUNMODE = 3;
def CIACRAB_LOAD = 4;
def CIACRAB_INMODE = 5;
def CIACRAB_SPMODE = 6;
def CIACRAB_TODIN = 7;

def CIACRBB_START = 0;
def CIACRBB_PBON = 1;
def CIACRBB_OUTMODE = 2;
def CIACRBB_RUNMODE = 3;
def CIACRBB_LOAD = 4;
def CIACRBB_INMODE0 = 5;
def CIACRBB_INMODE1 = 6;
def CIACRBB_ALARM = 7;

def CIAICRF_TA = (1<<CIAICRB_TA);
def CIAICRF_TB = (1<<CIAICRB_TB);
def CIAICRF_ALRM = (1<<CIAICRB_ALRM);
def CIAICRF_SP = (1<<CIAICRB_SP);
def CIAICRF_FLG = (1<<CIAICRB_FLG);
def CIAICRF_IR = (1<<CIAICRB_IR);
def CIAICRF_SETCLR = (1<<CIAICRB_SETCLR);

def CIACRAF_START = (1<<CIACRAB_START);
def CIACRAF_PBON = (1<<CIACRAB_PBON);
def CIACRAF_OUTMODE = (1<<CIACRAB_OUTMODE);
def CIACRAF_RUNMODE = (1<<CIACRAB_RUNMODE);
def CIACRAF_LOAD = (1<<CIACRAB_LOAD);
def CIACRAF_INMODE = (1<<CIACRAB_INMODE);
def CIACRAF_SPMODE = (1<<CIACRAB_SPMODE);
def CIACRAF_TODIN = (1<<CIACRAB_TODIN);

def CIACRBF_START = (1<<CIACRBB_START);
def CIACRBF_PBON = (1<<CIACRBB_PBON);
def CIACRBF_OUTMODE = (1<<CIACRBB_OUTMODE);
def CIACRBF_RUNMODE = (1<<CIACRBB_RUNMODE);
def CIACRBF_LOAD = (1<<CIACRBB_LOAD);
def CIACRBF_INMODE0 = (1<<CIACRBB_INMODE0);
def CIACRBF_INMODE1 = (1<<CIACRBB_INMODE1);
def CIACRBF_ALARM = (1<<CIACRBB_ALARM);

def CIACRBF_IN_PHI2 = 0;
def CIACRBF_IN_CNT = (CIACRBF_INMODE0);
def CIACRBF_IN_TA = (CIACRBF_INMODE1);
def CIACRBF_IN_CNT_TA = (CIACRBF_INMODE0|CIACRBF_INMODE1);

def CIAB_GAMEPORT1 = (7);
def CIAB_GAMEPORT0 = (6);
def CIAB_DSKRDY = (5);
def CIAB_DSKTRACK0 = (4);
def CIAB_DSKPROT = (3);
def CIAB_DSKCHANGE = (2);
def CIAB_LED = (1);
def CIAB_OVERLAY = (0);

def CIAB_COMDTR = (7);
def CIAB_COMRTS = (6);
def CIAB_COMCD = (5);
def CIAB_COMCTS = (4);
def CIAB_COMDSR = (3);
def CIAB_PRTRSEL = (2);
def CIAB_PRTRPOUT = (1);
def CIAB_PRTRBUSY = (0);

def CIAB_DSKMOTOR = (7);
def CIAB_DSKSEL3 = (6);
def CIAB_DSKSEL2 = (5);
def CIAB_DSKSEL1 = (4);
def CIAB_DSKSEL0 = (3);
def CIAB_DSKSIDE = (2);
def CIAB_DSKDIREC = (1);
def CIAB_DSKSTEP = (0);

def CIAF_GAMEPORT1 = (1<<7);
def CIAF_GAMEPORT0 = (1<<6);
def CIAF_DSKRDY = (1<<5);
def CIAF_DSKTRACK0 = (1<<4);
def CIAF_DSKPROT = (1<<3);
def CIAF_DSKCHANGE = (1<<2);
def CIAF_LED = (1<<1);
def CIAF_OVERLAY = (1<<0);

def CIAF_COMDTR = (1<<7);
def CIAF_COMRTS = (1<<6);
def CIAF_COMCD = (1<<5);
def CIAF_COMCTS = (1<<4);
def CIAF_COMDSR = (1<<3);
def CIAF_PRTRSEL = (1<<2);
def CIAF_PRTRPOUT = (1<<1);
def CIAF_PRTRBUSY = (1<<0);

def CIAF_DSKMOTOR = (1<<7);
def CIAF_DSKSEL3 = (1<<6);
def CIAF_DSKSEL2 = (1<<5);
def CIAF_DSKSEL1 = (1<<4);
def CIAF_DSKSEL0 = (1<<3);
def CIAF_DSKSIDE = (1<<2);
def CIAF_DSKDIREC = (1<<1);
def CIAF_DSKSTEP = (1<<0);

