' *********************************************************************
'                  card.resource 53.12 (31.01.2010) by
'              Hyperion Entertainment CVBA/VOF & Amiga Inc
'               HBASIC constants 53.2.0 (25.06.2011)
'
'                    C->HBASIC manual '8-) conversion
'        © Dámaso D. Estévez {correoamidde-aminet000, yahoo, es}
' *********************************************************************
'      Please read the comments/remarks included in resource/card.h
'           and proto/cardres.h files, the autodoc cardres.doc
'       and (NDK 3.5) PCMCIA drawer in the AmigaOS developper kit.
'              -------------------------------------------
'     Por favor, lea los comentarios/notas incluidos en los ficheros
'   resource/card.h y prot/cardres.h, el fichero de autodocumentación
'        cardres.doc y (NDK 3.5) los documentos del cajón PCMCIA
'            en el paquete para desarrolladores del AmigaOS.
' *********************************************************************

REM $underlines

' CardHandle
' -------------------------------------------------
CONST cah_CardNode%             =  0% ' Struct Node embebbed (word aligned) / Estructura Node incrustada (alineación a la palabra)
CONST cah_CardRemoved%          = 14% ' ULONG
CONST cah_CardInserted%         = 18% ' ULONG
CONST cah_CardStatus%           = 22% ' ULONG
CONST cah_CardFlags%            = 26% ' UBYTE
' -------------------------------------------------
CONST CardHandle_sizeof%        = 27%

' DeviceTData
' -------------------------------------------------
CONST dtd_DTsize%               =  0% ' ULONG
CONST dtd_DTspeed%              =  4% ' ULONG
CONST dtd_DTtype%               =  8% ' UBYTE
CONST dtd_DTflags%              =  9% ' UBYTE
' -------------------------------------------------
CONST DeviceTData_sizeof%       = 10%

' CardMemoryMap
' -------------------------------------------------
CONST cmm_CommonMemory%         =  0% ' UBYTE *
CONST cmm_AttributeMemory%      =  4% ' UBYTE *
CONST cmm_IOMemory%             =  8% ' UBYTE *
CONST cmm_CommonMemSize%        = 12% ' ULONG   - v39
CONST cmm_AttributeMemSize%     = 16% ' ULONG   - v39
CONST cmm_IOMemSize%            = 20% ' ULONG   - v39
' -------------------------------------------------
CONST CardMemoryMap_sizeof%     = 24%


' TP_AmigaXIP
' -------------------------------------------------
CONST TPL_CODE%                 =  0% ' UBYTE
CONST TPL_LINK%                 =  1% ' UBYTE
CONST TP_XIPLOC%                =  2% ' UBYTE (four bytes / cuatro octetos)
CONST TP_XIPFLAGS%              =  6% ' UBYTE
CONST TP_XIPRESRV%              =  7% ' UBYTE
' -------------------------------------------------
CONST TP_AmigaXIP_sizeof%       =  8%

' =================================================

' Flags for cah_CardFlags field (OwnCard function)
'                       ---
'               Atributos para el campo
'            cah_CardFlags (función OwnCard)
' -------------------------------------------------

CONST CARDB_RESETREMOVE&        =   0&
CONST CARDF_RESETREMOVE&        =   1& ' (1<<CARDB_RESETREMOVE)

CONST CARDB_IFAVAILABLE&        =   1&
CONST CARDF_IFAVAILABLE&        =   2& ' (1<<CARDB_IFAVAILABLE)

CONST CARDB_DELAYOWNERSHIP&     =   2&
CONST CARDF_DELAYOWNERSHIP&     =   4& ' (1<<CARDB_DELAYOWNERSHIP)

CONST CARDB_POSTSTATUS&         =   3&
CONST CARDF_POSTSTATUS&         =   8& ' (1<<CARDB_POSTSTATUS)

'  Return flags from ReleaseCreditCard function
'    Atributos devueltos por ReleaseCreditCard
' ------------------------------------------------
CONST CARDB_REMOVEHANDLE&       =   0&
CONST CARDF_REMOVEHANDLE&       =   1& ' (1<<CARDB_REMOVEHANDLE)

'      Return flags from ReadStatus function
'  Atributos devueltos por la función ReadStatus
' ------------------------------------------------

CONST CARD_STATUSB_CCDET&       =   6&
CONST CARD_STATUSF_CCDET&       =  64& ' (1<<CARD_STATUSB_CCDET)

CONST CARD_STATUSB_BVD1&        =   5&
CONST CARD_STATUSF_BVD1&        =  32& ' (1<<CARD_STATUSB_BVD1)

CONST CARD_STATUSB_SC&          =   5&
CONST CARD_STATUSF_SC&          =  32& ' (1<<CARD_STATUSB_SC)

CONST CARD_STATUSB_BVD2&        =   4&
CONST CARD_STATUSF_BVD2&        =  16& ' (1<<CARD_STATUSB_BVD2)

CONST CARD_STATUSB_DA&          =   4&
CONST CARD_STATUSF_DA&          =  16& ' (1<<CARD_STATUSB_DA)

CONST CARD_STATUSB_WR&          =   3&
CONST CARD_STATUSF_WR&          =   8& ' (1<<CARD_STATUSB_WR)

CONST CARD_STATUSB_BSY&         =   2&
CONST CARD_STATUSF_BSY&         =   4& ' (1<<CARD_STATUSB_BSY)

CONST CARD_STATUSB_IRQ&         =   2&
CONST CARD_STATUSF_IRQ&         =   4& ' (1<<CARD_STATUSB_IRQ)

'               CardProgramVoltage
' -----------------------------------------------
CONST CARD_VOLTAGE_0V&          =   0&
CONST CARD_VOLTAGE_5V&          =   1&
CONST CARD_VOLTAGE_12V&         =   2&

'                CardMiscControl
' -----------------------------------------------
CONST CARD_ENABLEB_DIGAUDIO&    =   1&
CONST CARD_ENABLEF_DIGAUDIO&    =   2& ' (1<<CARD_ENABLEB_DIGAUDIO)

CONST CARD_DISABLEB_WP&         =   3&
CONST CARD_DISABLEF_WP&         =   8& ' (1<<CARD_DISABLEB_WP)

'           ---- From/Desde v39 ----

CONST CARD_INTB_SETCLR&         =   7&
CONST CARD_INTF_SETCLR&         = 128& ' (1<<CARD_INTB_SETCLR)

CONST CARD_INTB_BVD1&           =   5&
CONST CARD_INTF_BVD1&           =  32& ' (1<<CARD_INTB_BVD1)

CONST CARD_INTB_SC&             =   5&
CONST CARD_INTF_SC&             =  32& ' (1<<CARD_INTB_SC)

CONST CARD_INTB_BVD2&           =   4&
CONST CARD_INTF_BVD2&           =  16& ' (1<<CARD_INTB_BVD2)

CONST CARD_INTB_DA&             =   4&
CONST CARD_INTF_DA&             =  16& ' (1<<CARD_INTB_DA)

CONST CARD_INTB_BSY&            =   2&
CONST CARD_INTF_BSY&            =   4& ' (1<<CARD_INTB_BSY)

CONST CARD_INTB_IRQ&            =   2&
CONST CARD_INTF_IRQ&            =   4& ' (1<<CARD_INTB_IRQ)

'                 CardInterface
' ----------------------------------------------
CONST CARD_INTERFACE_AMIGA_0&   =   0&

'                   AmigaXIP
' ----------------------------------------------
CONST CISTPL_AMIGAXIP&          = 145& ' 0x91

CONST XIPFLAGSB_AUTORUN&        =   0&
CONST XIPFLAGSF_AUTORUN&        =   1& ' (1<<XIPFLAGSB_AUTORUN)
