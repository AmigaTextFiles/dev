/*ÅrequiresÅpreviousÅinclusionÅofÅinclude:exec/io.gÅ*/
uint
ÑGPD_READEVENTá=ÅCMD_NONSTD+0,
ÑGPD_ASKCTYPEà=ÅCMD_NONSTD+1,
ÑGPD_SETCTYPEà=ÅCMD_NONSTD+2,
ÑGPD_ASKTRIGGERÜ=ÅCMD_NONSTD+3,
ÑGPD_SETTRIGGERÜ=ÅCMD_NONSTD+4,

ÑGPTB_DOWNKEYSá=Å0,
ÑGPTF_DOWNKEYSá=Å1Å<<ÅGPTB_DOWNKEYS,
ÑGPTB_UPKEYSâ=Å1,
ÑGPTF_UPKEYSâ=Å1Å<<ÅGPTB_UPKEYS;

type
ÑGamePortTrigger_tÅ=ÅstructÅ{
àuintÅgpt_Keys;
àuintÅgpt_Timeout;
àuintÅgpt_XDelta;
àuintÅgpt_YDelta;
Ñ};

int
ÑGPCT_ALLOCATEDÜ=Å-1,
ÑGPCT_NOCONTROLLERÉ=Å0,
ÑGPCT_MOUSEä=Å1,
ÑGPCT_RELJOYSTICKÑ=Å2,
ÑGPCT_ABSJOYSTICKÑ=Å3,

ÑGPDERR_SETCTYPEÖ=Å1;
