//update joystick button status
joystick1:
	set $4016 1 //first strobe byte
	set $4016 0 //second strobe byte
	set joy1a		& [$4016] 1
	set joy1b		& [$4016] 1
	set joy1select	& [$4016] 1
	set joy1start	& [$4016] 1
	set joy1up		& [$4016] 1
	set joy1down	& [$4016] 1
	set joy1left	& [$4016] 1
	set joy1right	& [$4016] 1
	return

//wait for the start of the vertical blanking interval
vwait_start:
	asm
		bit $2002
		bpl vwait_start
	endasm
	return

//wait for the end of the vertical blanking interval
vwait_end:
	asm
		bit $2002
		bmi vwait_end
	endasm
	set a 0
	set $2005 a
	set $2005 a
	set $2006 a
	set $2006 a
	return

//wait until screen refresh
vwait:
	gosub vwait_start
	gosub vwait_end
	return

//clear the first background buffer (0)
clear_background:
	gosub vwait
	gosub clear_background_one
	gosub vwait
	gosub clear_background_two
	return

clear_background_one:
	set clear_background_temp $20
	gosub clear_background_helper
	set clear_background_temp $21
	gosub clear_background_helper
	set clear_background_temp $22
	gosub clear_background_helper
	set clear_background_temp $23
	gosub clear_background_helper
	gosub vwait
	return

clear_background_two:
	set clear_background_temp $24
	gosub clear_background_helper
	set clear_background_temp $25
	gosub clear_background_helper
	set clear_background_temp $26
	gosub clear_background_helper
	set clear_background_temp $27
	gosub clear_background_helper
	gosub vwait
	return

clear_background_helper:
	gosub vwait
	set $2006 clear_background_temp
	set $2006 0
	gosub clear_ppu_256
	return

//clear a quarter kilobyte of ppu memory (nametable+attrib)
clear_ppu_256:
	set a 0
	set x 0
	clear_ppu_256_1:
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		set $2007 a
		inc x
		if x <> 16 branchto clear_ppu_256_1
	return

//make all sprites non-visible (offscreen is enough)
clear_spritemem:
	set x 0
	//set a 245
	clear_spritemem_1:
		set [spritemem x] 245
		inc x
		if x <> 0 branchto clear_spritemem_1
	return

clear_palette:
	//wait for start of vblank
	asm
		lda $2002
		bpl clear_palette
	endasm
	set $2006 $3f
	set $2006 0
	set x 0
	clear_palette_1:
		set $2007 $0e
		inc x
		if x <> 32 branchto clear_palette_1
	//wait for end of vblank
	clear_palette_2:
		asm
			lda $2002
			bmi clear_palette_2
			lda #0
			sta $2005
			sta $2005
			sta $2006
			sta $2006
		endasm
	return
