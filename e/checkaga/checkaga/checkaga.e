/*----------------------------------------------------------------------------*

  EMODULES:other/checkaga

    NAME
      checkaga -- checks if the aga-chipset is present

    SYNOPSIS
      bool:=checkaga()

    FUNCTION
      ``Future Amigas will *NOT* support *ANY* of the new AGA registers.
      If you want your product to work on the next generation of Amigas
      then detect aga before of run, and if is not present exit or use
      ECS, that will be supported as emulation in the new C= low-end
      and high-end machines.  That machines will have probably a
      totally new ChipSet, without any $dffXXX register, and probably
      not bitplane system.

      Even the processor isn't necessarily final.  It is strongly
      rumoured that the Motorola MC68060 is the final member of the
      68000 series, and may not even come out.  Expect Amigas in 2-3
      years to come with RISC chip processors running 680x0 emulation.

      This is my AGA detect routine 101%...  (thanx to DDT/HBT for the
      last 1%) It will detect AGA on the future updated AGA machines.
      Instead making a CMPI.B #$f8,$dff07c on that new AGA machines
      only old chipset will be detected!!!!''

               `The AGA doc (V2.5) for AGA CODERS' by RANDY of COMAX

    INPUTS
      None

    RESULT
      Returns TRUE if the AGA-chipset is present. Returns FALSE
      if the AGA-chipset is not present

 *----------------------------------------------------------------------------*/

OPT MODULE
OPT REG=5

EXPORT PROC checkaga()
    LEA     $DFF000,A3
    MOVE.W  $7C(A3),D0              ;-> DeniseID or LisaID in AGA
    MOVEQ   #30,D2                  ;-> Check 30 times ( prevents old denise random)
    ANDI.W  #%000000011111111,D0    ;-> low byte only
denloop:
    MOVE.W  $7C(A3),D1              ;-> Denise ID (LisaID on AGA)
    ANDI.W  #%000000011111111,D1    ;-> low byte only
    CMP.B   D0,D1                   ;-> same value?
    BNE.S   notaga                  ;-> Not the same value, then OCS Denise!
    DBRA    D2,denloop              ;-> (THANX TO DDT/HBT FOR MULTICHECK HINT)
    ORI.B   #%11110000,D0           ;-> MASK AGA REVISION (will work on new aga)
    CMPI.B  #%11111000,D0           ;-> BIT 3=AGA (this bit will be=0 in AAA!)
    BNE.S   notaga                  ;-> IS THE AGA CHIPSET PRESENT?
    RETURN  TRUE                    ;-> AGA -> Return TRUE
notaga:                             ;-> NOT AGA, BUT IS POSSIBLE AN AAA MACHINE!!
ENDPROC FALSE
