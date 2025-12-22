nbasic_stack = 256
spritemem = 512
sack_x = 0
sack_y = 1
sack_facing = 2
sack_r_attrib = 3
sack_l_attrib = 4
select_still_down = 5
start_still_down = 6
behind_bg = 7
use_physics = 8
ground_height = 9
gravity_dir = 10
gravity_index = 11
nbasic_temp = 12
joy1a = 13
joy1b = 14
joy1select = 15
joy1start = 16
joy1up = 17
joy1down = 18
joy1left = 19
joy1right = 20
clear_background_temp = 21

	.inesprg 1 ;//one PRG bank
	.ineschr 1 ;//one CHR bank
	.inesmir 0 ;//mirroring type 0
	.inesmap 0 ;//memory mapper 0 (none)
	.org $8000
	.bank 0

start:
 jsr vwait_start

		cld
		sei
	 lda #32
 sta 8192
 lda #28
 sta 8193
 jsr clear_background
 jsr vwait
 jsr load_palette
 jsr load_background
 jsr init_vars

mainloop:
 jsr vwait_start
 jsr draw_sack
 jsr vwait_end
 jsr joy_handler
 jmp mainloop

init_vars:
 lda #120
 sta sack_x
 lda #110
 sta sack_y
 lda #1
 sta sack_facing
 lda #0
 sta sack_r_attrib
 lda #64
 sta sack_l_attrib
 lda #0
 sta select_still_down
 lda #0
 sta start_still_down
 lda #0
 sta behind_bg
 lda #0
 sta use_physics
 lda #135
 sta ground_height
 lda #0
 sta gravity_dir
 lda #0
 sta gravity_index
 rts

draw_sack:
 lda #1
 cmp sack_facing
 bne nbasic_autolabel_1
 jmp draw_sack_right

nbasic_autolabel_1:
 jmp draw_sack_left

joy_handler:
 jsr joystick1
 lda #0
 cmp joy1select
 bne nbasic_autolabel_2
 lda #0
 sta select_still_down

nbasic_autolabel_2:
 lda #0
 cmp joy1select
 beq nbasic_autolabel_3
 lda #0
 cmp select_still_down
 bne nbasic_autolabel_4
 lda #0
 cmp behind_bg
 bne nbasic_autolabel_5
 lda #32
 sta sack_r_attrib
 lda #96
 sta sack_l_attrib
 lda #1
 sta behind_bg
 jmp joy_handler_1

nbasic_autolabel_5:
 lda #0
 sta sack_r_attrib
 lda #64
 sta sack_l_attrib
 lda #0
 sta behind_bg

nbasic_autolabel_4:

nbasic_autolabel_3:

joy_handler_1:
 lda joy1select
 sta select_still_down
 lda #0
 cmp joy1start
 bne nbasic_autolabel_6
 lda #0
 sta start_still_down

nbasic_autolabel_6:
 lda #0
 cmp joy1start
 beq nbasic_autolabel_7
 lda #0
 cmp start_still_down
 bne nbasic_autolabel_8
 lda #1
 clc
 adc use_physics
 and #1
 sta use_physics

nbasic_autolabel_8:

nbasic_autolabel_7:

joy_handler_2:
 lda #1
 cmp use_physics
 bne nbasic_autolabel_9
 jmp joy_handler_physics

nbasic_autolabel_9:
 jmp joy_handler_no_physics

joy_handler_no_physics:
 lda joy1right
 clc
 adc sack_x
 sta sack_x
 lda sack_x
 sec
 sbc joy1left
 sta sack_x
 lda joy1down
 clc
 adc sack_y
 sta sack_y
 lda sack_y
 sec
 sbc joy1up
 sta sack_y
 lda #0
 cmp joy1right
 beq nbasic_autolabel_10
 lda #1
 sta sack_facing

nbasic_autolabel_10:
 lda #0
 cmp joy1left
 beq nbasic_autolabel_11
 lda #0
 sta sack_facing

nbasic_autolabel_11:
 rts

joy_handler_physics:
 lda joy1right
 clc
 adc sack_x
 sta sack_x
 lda sack_x
 sec
 sbc joy1left
 sta sack_x
 lda #0
 cmp joy1right
 beq nbasic_autolabel_12
 lda #1
 sta sack_facing

nbasic_autolabel_12:
 lda #0
 cmp joy1left
 beq nbasic_autolabel_13
 lda #0
 sta sack_facing

nbasic_autolabel_13:
 lda #0
 cmp joy1a
 beq nbasic_autolabel_14
 lda ground_height
 cmp sack_y
 bne nbasic_autolabel_15
 lda #1
 sta gravity_dir
 lda #26
 sta gravity_index

nbasic_autolabel_15:

nbasic_autolabel_14:
 lda #1
 cmp gravity_dir
 bne nbasic_autolabel_16
 lda #0
 cmp gravity_index
 bpl nbasic_autolabel_17
 dec gravity_index

nbasic_autolabel_17:
 lda sack_y
 pha
 ldx gravity_index
 lda gravity,x
 sta nbasic_temp
 pla
 sbc nbasic_temp
 sta sack_y
 lda #0
 cmp gravity_index
 bne nbasic_autolabel_18
 lda #0
 sta gravity_dir

nbasic_autolabel_18:

nbasic_autolabel_16:
 lda #0
 cmp gravity_dir
 bne nbasic_autolabel_19
 lda #25
 cmp gravity_index
 bcc nbasic_autolabel_20
 inc gravity_index

nbasic_autolabel_20:
 ldx gravity_index
 lda gravity,x
 adc sack_y
 sta sack_y

nbasic_autolabel_19:
 lda ground_height
 cmp sack_y
 bpl nbasic_autolabel_21
 lda ground_height
 sta sack_y
 lda #0
 sta gravity_index

nbasic_autolabel_21:
 rts

draw_sack_right:
 lda #0
 sta 8195
 lda sack_y
 sta 8196
 lda #32
 sta 8196
 lda sack_r_attrib
 sta 8196
 lda sack_x
 sta 8196
 lda #16
 clc
 adc sack_y
 sta 8196
 lda #34
 sta 8196
 lda sack_r_attrib
 sta 8196
 lda sack_x
 sta 8196
 lda sack_y
 sta 8196
 lda #36
 sta 8196
 lda sack_r_attrib
 sta 8196
 lda #8
 clc
 adc sack_x
 sta 8196
 lda #16
 clc
 adc sack_y
 sta 8196
 lda #38
 sta 8196
 lda sack_r_attrib
 sta 8196
 lda #8
 clc
 adc sack_x
 sta 8196
 rts

draw_sack_left:
 lda #0
 sta 8195
 lda sack_y
 sta 8196
 lda #36
 sta 8196
 lda sack_l_attrib
 sta 8196
 lda sack_x
 sta 8196
 lda #16
 clc
 adc sack_y
 sta 8196
 lda #38
 sta 8196
 lda sack_l_attrib
 sta 8196
 lda sack_x
 sta 8196
 lda sack_y
 sta 8196
 lda #32
 sta 8196
 lda sack_l_attrib
 sta 8196
 lda #8
 clc
 adc sack_x
 sta 8196
 lda #16
 clc
 adc sack_y
 sta 8196
 lda #34
 sta 8196
 lda sack_l_attrib
 sta 8196
 lda #8
 clc
 adc sack_x
 sta 8196
 rts

load_palette:
 lda #63
 sta 8198
 lda #0
 sta 8198
 lda #49
 sta 8199
 lda #26
 sta 8199
 lda #41
 sta 8199
 lda #40
 sta 8199
 lda #63
 sta 8198
 lda #16
 sta 8198
 lda #49
 sta 8199
 lda #14
 sta 8199
 lda #48
 sta 8199
 lda #16
 sta 8199
 rts

load_background:
 jsr vwait
 jsr load_grass_top
 jsr vwait
 jsr load_grass_bottom
 jsr vwait
 jsr load_bottom_bricks
 rts

load_grass_top:
 lda #34
 sta 8198
 lda #101
 sta 8198
 ldy #0

load_grass_top_1:
 lda #2
 sta 8199
 lda #3
 sta 8199
 lda #0
 sta 8199
 lda #0
 sta 8199
 lda #0
 sta 8199
 lda #0
 sta 8199
 lda #0
 sta 8199
 iny
 cpy #4
 beq nbasic_autolabel_22
 jmp load_grass_top_1

nbasic_autolabel_22:
 rts

load_grass_bottom:
 lda #34
 sta 8198
 lda #128
 sta 8198
 ldy #0

load_grass_bottom_1:
 lda #22
 sta 8199
 lda #23
 sta 8199
 lda #24
 sta 8199
 lda #25
 sta 8199
 lda #22
 sta 8199
 lda #18
 sta 8199
 lda #19
 sta 8199
 iny
 cpy #5
 beq nbasic_autolabel_23
 jmp load_grass_bottom_1

nbasic_autolabel_23:
 rts

load_bottom_bricks:
 lda #34
 sta 8198
 lda #160
 sta 8198
 ldy #0

load_bottom_bricks_1:
 lda #4
 sta 8199
 lda #5
 sta 8199
 iny
 cpy #16
 beq nbasic_autolabel_24
 jmp load_bottom_bricks_1

nbasic_autolabel_24:
 ldy #0

load_bottom_bricks_2:
 lda #20
 sta 8199
 lda #21
 sta 8199
 iny
 cpy #16
 beq nbasic_autolabel_25
 jmp load_bottom_bricks_2

nbasic_autolabel_25:
 rts

gravity:
 .db 0,0,0,0,1,0,1,0,1,0
 .db 1,1,0,1,1,1
 .db 2,1,2,1,2,2,2,3,2,2
 .db 3,3,3,3,3,3

joystick1:
 lda #1
 sta 16406
 lda #0
 sta 16406
 lda 16406
 and #1
 sta joy1a
 lda 16406
 and #1
 sta joy1b
 lda 16406
 and #1
 sta joy1select
 lda 16406
 and #1
 sta joy1start
 lda 16406
 and #1
 sta joy1up
 lda 16406
 and #1
 sta joy1down
 lda 16406
 and #1
 sta joy1left
 lda 16406
 and #1
 sta joy1right
 rts

vwait_start:

		bit $2002
		bpl vwait_start
	 rts

vwait_end:

		bit $2002
		bmi vwait_end
	 lda #0
 sta 8197
 sta 8197
 sta 8198
 sta 8198
 rts

vwait:
 jsr vwait_start
 jsr vwait_end
 rts

clear_background:
 jsr vwait
 jsr clear_background_one
 jsr vwait
 jsr clear_background_two
 rts

clear_background_one:
 lda #32
 sta clear_background_temp
 jsr clear_background_helper
 lda #33
 sta clear_background_temp
 jsr clear_background_helper
 lda #34
 sta clear_background_temp
 jsr clear_background_helper
 lda #35
 sta clear_background_temp
 jsr clear_background_helper
 jsr vwait
 rts

clear_background_two:
 lda #36
 sta clear_background_temp
 jsr clear_background_helper
 lda #37
 sta clear_background_temp
 jsr clear_background_helper
 lda #38
 sta clear_background_temp
 jsr clear_background_helper
 lda #39
 sta clear_background_temp
 jsr clear_background_helper
 jsr vwait
 rts

clear_background_helper:
 jsr vwait
 lda clear_background_temp
 sta 8198
 lda #0
 sta 8198
 jsr clear_ppu_256
 rts

clear_ppu_256:
 lda #0
 ldx #0

clear_ppu_256_1:
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 sta 8199
 inx
 cpx #16
 bne clear_ppu_256_1
 rts

clear_spritemem:
 ldx #0

clear_spritemem_1:
 lda #245
 sta spritemem,x
 inx
 cpx #0
 bne clear_spritemem_1
 rts

clear_palette:

		lda $2002
		bpl clear_palette
	 lda #63
 sta 8198
 lda #0
 sta 8198
 ldx #0

clear_palette_1:
 lda #14
 sta 8199
 inx
 cpx #32
 bne clear_palette_1

clear_palette_2:

			lda $2002
			bmi clear_palette_2
			lda #0
			sta $2005
			sta $2005
			sta $2006
			sta $2006
		 rts

;//jump table points to NMI, Reset, and IRQ start points
	.bank 1
	.org $fffa
	.dw start, start, start
;//include CHR ROM
	.bank 2
	.org $0000
	.incbin "bgdemo.chr"
	.incbin "bgdemo.chr"

