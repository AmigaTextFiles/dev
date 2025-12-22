
; soc04a.s
; a) erklärt Erstellung der Copperliste


DISPLAY_X=$81
DISPLAY_Y=$2C

move.w #((DISPLAY_Y&$00FF)<<8)!((((DISPLAY_X-4)>>2)<<1)&$00FE)!$0001,d0

; vertikal
DISPLAY_Y&$00FF									= $2C & $00FF	= $2C = %00000000.00000000.00000000.00101100 = 44
(DISPLAY_Y&$00FF)<<8							= $2C00				  = %00000000.00000000.00101100.00000000 = 11264

; horizontal
DISPLAY_X-4										= $81-4 = $7D		  = %00000000.00000000.00000000.01111101 = 125		
(DISPLAY_X-4)>>2								= $1F				  = %00000000.00000000.00000000.00011111 = 31	
(((DISPLAY_X-4)>>2)<<1)							= $3E				  = %00000000.00000000.00000000.00111110 = 62 	
((((DISPLAY_X-4)>>2)<<1)&$00FE)					= $3E				  = %00000000.00000000.00000000.00111110 = 62

$2C00!$3E!$0001									= dc.w $2c3F			; für Copper-Wait --> dc.w $2c3F,$fffe



