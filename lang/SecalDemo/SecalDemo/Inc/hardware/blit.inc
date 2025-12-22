def HSIZEBITS = 6;
def VSIZEBITS = 16-HSIZEBITS;
def HSIZEMASK = $3f;
def VSIZEMASK = $3ff;

def MINBYTESPERROW = 128;
def MAXBYTESPERROW = 4096;

def ABC = $80;
def ABNC = $40;
def ANBC = $20;
def ANBNC = $10;
def NABC = $8;
def NABNC = $4;
def NANBC = $2;
def NANBNC = $1;

def A_OR_B = (ABC|ANBC|NABC|ABNC|ANBNC|NABNC);
def A_OR_C = (ABC|NABC|ABNC|ANBC|NANBC|ANBNC);
def A_XOR_C = (NABC|ABNC|NANBC|ANBNC);
def A_TO_D = (ABC|ANBC|ABNC|ANBNC);

def BC0B_DEST = 8;
def BC0B_SRCC = 9;
def BC0B_SRCB = 10;
def BC0B_SRCA = 11;
def BC0F_DEST = $100;
def BC0F_SRCC = $200;
def BC0F_SRCB = $400;
def BC0F_SRCA = $800;

def BC1F_DESC = 2;

def DEST = $100;
def SRCC = $200;
def SRCB = $400;
def SRCA = $800;

def ASHIFTSHIFT = 12;
def BSHIFTSHIFT = 12;

def LINEMODE = $1;
def FILL_OR = $8;
def FILL_XOR = $10;
def FILL_CARRYIN = $4;
def ONEDOT = $2;
def OVFLAG = $20;
def SIGNFLAG = $40;
def BLITREVERSE = $2;

def SUD = $10;
def SUL = $8;
def AUL = $4;

def OCTANT8 = 24;
def OCTANT7 = 4;
def OCTANT6 = 12;
def OCTANT5 = 28;
def OCTANT4 = 20;
def OCTANT3 = 8;
def OCTANT2 = 0;
def OCTANT1 = 16;

struct bltnode is
  n:ulong;
  function:ulong;
  stat:byte;
  blitsize:word;
  beamsync:word;
  cleanup:ulong;
;

def CLEANUP = $40;
def CLEANME = CLEANUP;

