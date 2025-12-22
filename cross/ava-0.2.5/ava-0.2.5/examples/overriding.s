/*
  overridings.s

  This example shows how strings cannot be used.
  Uros Platise 1999 (c)
*/

#arch AT90S1200

#define DC	dc.L
#define JOKE	tole        + so + pravila/a - ne

	seg	eeprom.val
	DC	0x1234

; This line WILL PRODUCE ERROR since is only used for testing purposes.
	dc.w	JOKE
