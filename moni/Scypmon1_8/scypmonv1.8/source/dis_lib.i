;-------------- dis.library -------------------------------
;by Tobias Walter
;
_LVOGetProcFlags        =       -30     ; ()()
_LVODisAsm              =       -36     ; (code,pc,disLine)(A0/A1/A2)
_LVOGetDisPrefs         =       -42
_LVOConfigReq           =       -48

MAX_INSTRUCTION         =       12
MAX_OPERANDS            =       80
MAX_COMMENT             =       32

                        rsreset
dl_NextLine             rs.l    1
dl_OutFlags             rs.l    1
dl_InFlags              rs.l    1
dl_SpecialFlags         rs.b    1
dl_ByteLen              rs.b    1
dl_Instruction          rs.b    MAX_INSTRUCTION
dl_Operands             rs.b    MAX_OPERANDS
dl_Comment              rs.b    MAX_COMMENT
sizeof_DisLine          rs.b    0

DF_68000 =      $00000001       ; Befehl auf 68000 vorhanden
DF_68010 =      $00000002       ; Befehl auf 68010 vorhanden
DF_68020 =      $00000004       ; Befehl auf 68020 vorhanden
DF_68030 =      $00000008       ; Befehl auf 68030 vorhanden
DF_68040 =      $00000010       ; Befehl auf 68040 vorhanden
DF_68851 =      $00000020       ; Befehl auf 68851 vorhanden
DF_68881 =      $00000040       ; Befehl auf 68881 vorhanden
DF_ImplSize =   $00000080       ; implizite Size anzeigen, z.B. MOVEQ.L
DF_DefaultSize =        $00000100       ; Default-Size nicht anzeigen (taugt nix)
DF_DecOffsets = $00000200       ; dezimale Offsets
DF_DecAbs =     $00000400       ; dezimale Adressen (hehe!)
DF_DecImm =     $00000800       ; dezimale Immediate-Werte
DF_HexMode0 =   $00001000       ; Kennzeichnung von Hexzahlen:
DF_HexMode1 =   $00002000       ; 00 ='$', 01 ='0x', 10 ='&..h' (umpf!), 11 =''
DF_SP_A7 =      $00004000       ; 'SP' statt 'A7'
DF_HS_LO =      $00008000       ; ConditionCode 'HS'/'LO' statt 'CC'/'CS'
DF_DBRA_DBF =   $00010000       ; 'DBRA' statt 'DBF'
DF_ShortInst =  $00020000       ; 'OR' statt 'ORI', 'CMP' statt 'CMPM' usw
DF_Ill_DCW =    $00040000       ; '????' statt 'DC.W $xxxx'
DF_LineX =      $00080000       ; 'LINEA', 'LINEF' statt 'DC.W' (bzw '????')
DF_LowerInst =  $00100000       ; Befehl in Kleinbuchstaben
DF_LowerHex =   $00200000       ; Hexzahlen in Kleinbuchstaben
DF_LowerReg =   $00400000       ; Register in Kleinbuchstaben
DF_SignedAbs =  $00800000       ; Absolute Adressen mit Vorzeichen
DF_AdrPC =      $01000000       ; Adresse(PC) statt Offset(PC)
DF_MotoSyntax = $02000000       ; offizielle Syntax, z.B. (Offset,PC)
DF_NoEACheck =  $04000000       ; EA-Check nicht so streng (für Lattice-Asm)
DF_Bcc_S =      $08000000       ; Bcc.L und .S statt .W und .B (nur <68020)
DF_24BitAdr =   $10000000       ; 24-Bit-Adressen (nur <68020)
DF_UseFlags =   $80000000       ; dl_InFlags statt DisFlags verwenden

DF_TopDefault = DF_68000!DF_LowerInst!DF_LowerHex!DF_SignedAbs!DF_AdrPC
DF_008Default = DF_68000!DF_68010!DF_68020!DF_68030!DF_68881!DF_68851!DF_SP_A7!DF_DBRA_DBF!DF_ShortInst!DF_Ill_DCW!DF_LineX!DF_NoEACheck

DB_68000 =      0               ; Ok
DB_68010 =      1               ; Ok
DB_68020 =      2               ; Ok
DB_68030 =      3               ; Ok
DB_68040 =      4               ; ToDo
DB_68851 =      5               ; Ok
DB_68881 =      6               ; Ok
DB_ImplSize =   7               ; Ok
DB_DefaultSize =        8               ; Ok
DB_DecOffsets = 9               ; Ok
DB_DecAbs =     10              ; Ok
DB_DecImm =     11              ; Ok
DB_HexMode0 =   12              ; Ok
DB_HexMode1 =   13              ; Ok
DB_SP_A7 =      14              ; Ok
DB_HS_LO =      15              ; Ok
DB_DBRA_DBF =   16              ; Ok
DB_ShortInst =  17              ; Ok
DB_Ill_DCW =    18              ; Ok
DB_LineX =      19              ; Ok
DB_LowerInst =  20              ; Ok
DB_LowerHex =   21              ; Ok
DB_LowerReg =   22              ; Ok
DB_SignedAbs =  23              ; Ok
DB_AdrPC =      24              ; Ok
DB_MotoSyntax = 25              ; Ok
DB_NoEACheck =  26              ; Ok
DB_Bcc_S =      27              ; Ok
DB_24BitAdr =   28              ; Ok
DB_UseFlags =   31              ; Special

DISF_IS68000 =  $0001
DISF_IS68010 =  $0002
DISF_IS68020 =  $0004
DISF_IS68030 =  $0008
DISF_IS68881 =  $0100
DISF_IS68851 =  $0200
DISF_ISNIX =    $1000
DISF_OPERAND =  $2000
DISF_COMMENT =  $4000
DISF_GURU =     $8000

DISB_IS68000 =  0
DISB_IS68010 =  1
DISB_IS68020 =  2
DISB_IS68030 =  3
DISB_IS68881 =  8
DISB_IS68851 =  9
DISB_ISNIX =    12
DISB_OPERAND =  13
DISB_COMMENT =  14
DISB_GURU =     15


