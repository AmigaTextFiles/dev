The XC68HC11A1P basic circuit.

$VER: XC68HC11A1P_basic_circuit 1.0 (5-Jul-93)

This file should be viewed with a PC style font like
CleanIBM, or you can use my modified PC font called
Schematic font. Either change font in your favorite text
editor or do "SetFont Schematic 8" from DOS. And then type
or More the file. Remember to copy the Schematic font to
your FONTS: assign.

This schematic shows all that's needed to get a Hc11
microcontroller running. It's based on the XC68HC11A1P the
48 pin DIL version, since that one is probably the Hc11
version that's easiest to play with since you can hook it
up on a breadboard (or protoboard. I'm thinking of the ones
that you just stick the ICs and cables in, no soldering
type boards). But it should apply to any Hc11 with only
minor changes.

Remember that Å means the crossing wires are NOT connected.
Â, ´, Ã and Á means the wires are connected.

              ÚÄÄÄÄÄÄÄÄÄÄÂÄÂÄÄÄÄÄÄÄÄÄÄ¿      Vdd       ÚÄIC-02Ä¿     Vdd
        VddÄR1´1  PA7    ÀÄÙ    Vdd 48ÃÄÄÄÂÄÄÄÁÄÄÂÄÄÂÄÄ´2 Vdd  ³      ³
              ´2  PA6           PD5 47ÃR1Ä´      +  ³  ³  Gnd 3ÃGnd   R1
              ´3  PA5           PD4 46ÃR1Ä´      C2 C3 ³Reset 1ÃÄÄÄÄÄÄ´
              ´4  PA4           PD3 45ÃR1Ä´      ÀÄÄ´  ÀÄÄÄÄÄÄÄÙ      ³
              ´5  PA3           PD2 44ÃR1Ä´        Gnd                ³
       VddÂÄR1´6  PA2       TxD PD1 43ÃR1Ä´                           ³
          ÃÄR1´7  PA1       RxD PD0 42ÃR1Ä´                           ³
          ÀÄR1´8  PA0          /IRQ 41ÃR2Ä´                           ³
              ´9  PB7         /XIRQ 40ÃR2Ä´                           ³
              ´10 PB6        /RESET 39ÃÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
              ´11 PB5           PC7 38ÃR1Ä´                           ³
              ´12 PB4           PC6 37ÃR1Ä´                    Reset  o
              ´13 PB3           PC5 36ÃR1Ä´                    Switch o
              ´14 PB2           PC4 35ÃR1Ä´                    (Push  ³
              ´15 PB1           PC3 34ÃR1Ä´                    type)  ³
              ´16 PB0           PC2 33ÃR1Ä´                           ³
              ´17 PE0           PC1 32ÃR1Ä´                          Gnd
              ´18 PE1           PC0 31ÃR1ÄÙ    ÚÄÂÄÄÂÄÄC1Ä¿
              ´19 PE2          XTAL 30ÃÄÄÄÄÄÄÄÄÙ R3 X1    ³
      GndÂÄ¿  ´20 PE3         EXTAL 29ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÁÄÄC1Ä´
         C4ÀÄÄ´21 Vrl           R/W 28Ã                   ³
   VddÄR4ÁÄÄÄÄ´22 Vrh             E 27Ã                  Gnd
           Gnd´23 Vss            AS 26ÃR1ÄVdd
     VddÄR2ÄÂÄ´24 ModB         ModA 25ÃÄÂÄR2ÄVdd
            ³ ÀÄÄÄÄÄÄÄÄÄIC-01ÄÄÄÄÄÄÄÄÄÙ ³
            ³                           ³
            o Mod B                     o Mod A
            o Switch                    o Switch
            ³                           ³
           Gnd                         Gnd

Vss       0VDC
Vdd       +5VDC
Gnd       Ground
R1        10Kohm
R2        4.7Kohm
R3        1Mohm - 20 Mohm
R4        1Kohm
X1        8Mhz (Max)
C1        5pF - 25pF (Nominal. 18pF, Lower frequency = Lower capacitance)
C2        Electrolytic 4.7uF
C3        .1uF
C4        1uF
oo        SPST switch
IC-01     XC68HC11A1
IC-02     MC 34064 or MC 33064

All port resistors can be left out on a bench project. The only
thing that happens is that the microcontroller  will take a little
more power.

The Resetswitch can be left out in the final product if not needed.

ÉÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
º  Inputs   º                  º
ÌÍÍÍÍÍËÍÍÍÍÍ¹ Mode Description º
ºMod BºMod Aº                  º
ÌÍÍÍÍÍÎÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÇ
º  1  º  0  ºNormal Single Chipº
º  1  º  1  º Normal Expanded  º
º  0  º  0  ºSpecial Bootstrap º
º  0  º  1  º   Special Test   º
ÈÍÍÍÍÍÊÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

If you're not using the bus, which you won't be if you're just strted
with the Hc11, then you should only use the Special Bootstrap mode. So
connect both Mod Switches. You can even leave them out if you like, but
remember to ground the Mod pins if you leave the switch out.

If the RxD and TxD pins are connected to each other the Hc11 will jump
to adress $b600 which is where the EEPROM is located on the A1. So
you'll be able to asemble you program to EEPROM ($b600) and run it by
connecting Tdx and RxD together. There's a switch for this purpose on
my version of the voltage converter that you'll need to connect the
Hc11 to your Amiga. Look at the file containing the voltage converter
for more info.

If the processor doesn't seem to start check that the Reset pin
(39) is in it's high state. Possably remove IC-02 for a while to see
if it works then. IC-02 resets the processor when voltage drops
below 5VDC. The processor will still run at 3VDC at room temperature
but when you power it on and off EEPROM contents may be lost if IC-02
is not present.
