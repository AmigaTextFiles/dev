/*Useofformroutines:

„CallCRT_FormStarttoclearoutanyexistingformandinitialize.

„AddfieldstotheformwithCRT_FormIntandCRT_FormChars:
ˆline-screenlineforstartofprompt
ˆcol-screencolumnforstartofprompt
ˆlen-screenlengthforcharsorintvalue(max6forint)
ˆheader-headertoleftofinputarea
ˆpChanged-pointertovariable,whichafterCRT_FormRead,will
Œcontain'true'ifthatfieldwaschanged
ˆptr-pointertobufferholdingvalue
ˆcheck-routinetocalltochecknewvalues

„CallCRT_FormRead:
ˆheader-multilineheadertocenterattopofscreen
ˆflags-byteofflags:
ŒFORMHEADERS-displayheadersonthiscall
ŒFORMSKIP-useautoskiponinputfields
ŒFORMINPUT-allowinput(otherwisejustdisplay)
ŒFORMOUTPUT-displayvalues(otherwiseassumetheyarethere)
ˆterminators-stringofcharactersallowedtoterminateinputof
Œafield.Thefollowingshouldbepresenttoenabletheir
Œfunctions,butwillneverbereturned:
CONTROL-R-usedtoforceresetofafield
CONTROL-Z-usedtoforceresetofallfields
ŒThefollowingarenormallypresenttoenabletheirfunctions:
CONTROL-Q-usedtodoaquickexit
ESCAPE-usedtoresetallfieldsandexit
ˆThecharacterreturnedisthecharacterfrom'terminators'thatthe
ˆusertypedwhichcausedanexit.Carriagereturn(CONTROL-M)isthe
ˆmostlikely,i.e.theuserfilledinallfieldsandfellofftheend.
*/

char
„CONTROL_Q='\(0x11)',
„CONTROL_R='\(0x12)',
„CONTROL_Z='\(0x1a)',
„ESCAPE„='\(0x1b)';

*charTERMINATORS="\(CONTROL_Q)\(CONTROL_R)\(CONTROL_Z)\(ESCAPE)";

extern
„_F_initialize()void,
„_F_terminate()void,
„CRT_FormIntOK(intn)bool,
„CRT_FormCharsOK(*charp)bool,
„CRT_FormStart()void,
„CRT_FormInt(ushortline,col,len;*charheader;
*boolpChanged;*intptr;
proc(intn)boolcheck)void,
„CRT_FormChars(ushortline,col,len;*charheader;
’*boolpChanged;*charptr;
“proc(*charp)boolcheck)void,
„CRT_FormRead(*charheader;byteflags;*charterminators)char;

byte
„FORMHEADERS=0x01,
„FORMSKIP=0x02,
„FORMINPUT=0x04,
„FORMOUTPUT=0x08;
