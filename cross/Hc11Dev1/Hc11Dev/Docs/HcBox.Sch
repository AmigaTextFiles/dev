Hc11 - Amiga Communication.

$VER: Hc11-Amiga_Communication 1.0 (5-Jul-93)

View this file with a PC style font. See file "BasicA1.Sch" for more
info.

This little circuit will be needed to convert the Amiga RS232 voltage
levels to TTL levels used by the Hc11.

  Gnd                +5vdc
   ³    ÚÄÄÄÂÄÂÄÄÄ¿    ³
   ³ÚC1+´C2+ÀÄÙC1+Ã+C1¿³
   ÃÅÄÄÄ´Gnd   VccÃÄÄÄÅ´
   ³ÀÄÄÄ´C2-   C1-ÃÄÄÄÙ³
   ÀÄ+C1´Vss   VddÃ+C1ÄÙ
AmyTxDÄÄ´         ÃÄÄÄo(1)
AmyRxDÄÄ´         ÃÄ¿ oÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHc11RxD(Port D bit 0)
      ÚÄ´         Ã ÀÄo(2)ÄÄÄÄÄÄÄÄÄÄÄÄÄHc11TxD(Port D bit 1)
      ³ ´         ÃÄ¿
      ÃÄ´         Ã ³
      ³ ´         ÃÄ´
      ³ ÀÄÄIC-01ÄÄÙ ³
      ³             ³
      ÀÄÄÄÄÄÂÄÄÄÄÄÄÄÁÄGnd
            ³
AmyGndÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHc11Gnd

Description
-----------
Gnd	Ground
C1	Electrolytic capacitor 10uF
IC-01	Mc145407P
ooo	SPDT-switch

You will also need a DB25 female connector to connent this to
your Amiga. 

Amiga Serial Connector

Pin       Function
------------------
2	TxD
3	RxD
7	Ground
Connect pins 5,6,8 and 20 to each other.


Set the switch in position 1 for downloading, and in position 2
for running the program. In the final product connect PD0 and
PD1 together. That will make the program run every time you
power up the Hc11.

Also remeber to connect Ground from the Amiga, this circuit and
the Hc11 to each other.

If you want to see if something is happening with the Hc11 when
downloading programs to it you can connect a logic probe or similar
(High impedance LED driver (Transistor)) to the TxD and/or RxD lines.
But remember to do that on the Hc11 side, NOT the Amiga side since
the Amiga uses RS232 (-12vdc to +12vcd) levels and that could
probably damage your probe or at least show fauly readings.

Be careful not to damage your Amiga.
