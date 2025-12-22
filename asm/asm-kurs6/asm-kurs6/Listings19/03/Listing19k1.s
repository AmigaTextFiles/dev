
; Listing19k1.s
; DMA Debugger
;
; (WinUAE 4.9.0 A500 configuration)
; Console-Debugger

1. v			= enable DMA debugger
   v [-1]		= enable DMA debugger
2. v [-2 to -6] = enable visual DMA debugger
3. vo			= DMA debugger off
4. vm			= show status 
5. vm <channel> <sub index>
				= enable/disable toggle.
				  (sub index is not used but must be included)
6. vm <channel> <sub index> <hex rgb>
				= change color of channel.
				  If sub index is zero: all sub index colors are changed.
				   
																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
																				; 1. 																				
>v																				; v			= enable DMA debugger
DMA debugger enabled, mode=1.													
>x																				; leave the debugger																		
																				; no visual mode activ

																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
>v -1																			; v -1		= enable DMA debugger
DMA debugger enabled, mode=1.													; (also v-1 without space possible)
>x																				; leave the debugger																		
																				; no visual mode activ

																				; Shift+F12 open the Debugger
;------------------------------------------------------------------------------
																				; 2.
																				; v [-1 to -6] = enable visual DMA debugger.
>v -2
DMA debugger enabled, mode=2.
>x																				; leave the debugger
																				; visual mode activ

;------------------------------------------------------------------------------
																				; enable and disable the cycle-exact-mode and see the different	!!!
																				; WinUAE/F12 ->chipset
																				; after enabling the visual mode
																				; cycle-exact-mode is enabled = all dma and cpu usage is shown
																				; cycle-exact-mode is disabled = only dma usage is shown

																				; (you can find the option "Cycle-exact (Full)" under Hardware/chipset)
;------------------------------------------------------------------------------
																				; 3.
																				; vo		= DMA debugger off
>vo
DMA debugger disabled

;------------------------------------------------------------------------------
																				from EAB:

																				v	 : enable only, no visual mode.	(same as v -1)	
																				v -1 : enable only, no visual mode.
																				v -2 : enable + visual mode + small visual
																				v -3 : enable + visual mode + doubled horizontal pixels
																				v -4 : enable + visual mode + big
																				v -5 : enable + visual mode + larger overlay with "transparency"
																				v -6 : enable + visual mode + larger overlay with no "transparency"

																				vo	 : disable dma debugger	;  - Visual DMA debugger can be switched off, "vo".

																				colors:								; default
																				yellow			= copper			; 0x...
																				green			= blitter
																				dark green		= blitter line
																				bright green	= blitter fill
																				blue			= bitplane
																				gray			= cpu
																				red				= audio
																				purple			= sprite			; 
																				white			= disk				; 
																				---				= refresh

																				; from EAB
																				- Added separate colors for visual DMA debugger copper wait and special cases
																				 (strobe extra cycle, 0xe0 cycle)

																				2.8.0 Beta 1
																				- DMA debugger blitter color changed, now normal blit,
																				fill blit and line blits are different enough.

																				2.0.0 Beta 18
																				- visual DMA debugger (possibly useless but cool!) different colors
																				mark different DMA channels, "v <val>" to enable, no parameter or
																				-1 = normal,-2 = small visual, -3 = wide and -4 = big.
																				CE-only Current colors: yellow = copper, green = blitter (light=normal, dark=line),
																				blue = bitplane, cpu = gray, audio = red, sprite = white, disk = purple

;------------------------------------------------------------------------------
																				; 4.
																				; from EAB:
																				; Added visual DMA debugger configuration:
																				; DMA channels can be disabled and colors can be changed.
																																							

>vm																				; vm = show status
0,0: 00222222 * -																; ?
1,0: 00444444 * Refresh															; 4x refresh
1,1: 00444444 * Refresh
1,2: 00444444 * Refresh
1,3: 00444444 * Refresh
2,0: 00a25342 * CPU																; 2x cpu
2,1: 00ad98d6 * CPU
3,0: 00eeee00 * Copper															; 3x copper
3,1: 00aaaa22 * Copper
3,2: 00666644 * Copper
4,0: 00ff0000 * Audio															; 4x audio
4,1: 00ff0000 * Audio
4,2: 00ff0000 * Audio
4,3: 00ff0000 * Audio
5,0: 00008888 * Blitter															; 2x blitter
5,1: 000088ff * Blitter
6,0: 000000ff * Bitplane														; 8x bitplane
6,1: 000000ff * Bitplane
6,2: 000000ff * Bitplane
6,3: 000000ff * Bitplane
6,4: 000000ff * Bitplane
6,5: 000000ff * Bitplane
6,6: 000000ff * Bitplane
6,7: 000000ff * Bitplane
7,0: 00ff00ff * Sprite															; 8x sprites	
7,1: 00ff00ff * Sprite
7,2: 00ff00ff * Sprite
7,3: 00ff00ff * Sprite
7,4: 00ff00ff * Sprite
7,5: 00ff00ff * Sprite
7,6: 00ff00ff * Sprite
7,7: 00ff00ff * Sprite
8,0: 00ffffff * Disk															; 3x disk
8,1: 00ffffff * Disk
8,2: 00ffffff * Disk
>

;------------------------------------------------------------------------------
																				; 5. vm <channel> <sub index>
																				;				 = enable/disable toggle.
																				;				   (sub index is not used but must be included)

>vm 5 0																			; blitter enable, disable
5,0: 00008888   Blitter
>vm
0,0: 00222222 * -
1,0: 00444444 * Refresh
1,1: 00444444 * Refresh
1,2: 00444444 * Refresh
1,3: 00444444 * Refresh
2,0: 00a25342 * CPU
2,1: 00ad98d6 * CPU
3,0: 00eeee00 * Copper
3,1: 00aaaa22 * Copper
3,2: 00666644 * Copper
4,0: 00ff0000 * Audio
4,1: 00ff0000 * Audio
4,2: 00ff0000 * Audio
4,3: 00ff0000 * Audio
5,0: 00008888   Blitter															; both blitter channel in dma-debugger disabled
5,1: 000088ff   Blitter
6,0: 000000ff * Bitplane
6,1: 000000ff * Bitplane
6,2: 000000ff * Bitplane
6,3: 000000ff * Bitplane
6,4: 000000ff * Bitplane
6,5: 000000ff * Bitplane
6,6: 000000ff * Bitplane
6,7: 000000ff * Bitplane
7,0: 00ff00ff * Sprite
7,1: 00ff00ff * Sprite
7,2: 00ff00ff * Sprite
7,3: 00ff00ff * Sprite
7,4: 00ff00ff * Sprite
7,5: 00ff00ff * Sprite
7,6: 00ff00ff * Sprite
7,7: 00ff00ff * Sprite
8,0: 00ffffff * Disk
8,1: 00ffffff * Disk
8,2: 00ffffff * Disk
;------------------------------------------------------------------------------
>vm 4 0																			; all audio enable, disable
4,0: 00ff0000   Audio
>vm
0,0: 00222222 * -
1,0: 00444444 * Refresh
1,1: 00444444 * Refresh
1,2: 00444444 * Refresh
1,3: 00444444 * Refresh
2,0: 00a25342 * CPU
2,1: 00ad98d6 * CPU
3,0: 00eeee00 * Copper
3,1: 00aaaa22 * Copper
3,2: 00666644 * Copper
4,0: 00ff0000   Audio															; all audio channels in dma-debugger disabled
4,1: 00ff0000   Audio
4,2: 00ff0000   Audio
4,3: 00ff0000   Audio
5,0: 00008888   Blitter
5,1: 000088ff   Blitter
6,0: 000000ff * Bitplane
6,1: 000000ff * Bitplane
6,2: 000000ff * Bitplane
6,3: 000000ff * Bitplane
6,4: 000000ff * Bitplane
6,5: 000000ff * Bitplane
6,6: 000000ff * Bitplane
6,7: 000000ff * Bitplane
7,0: 00ff00ff * Sprite
7,1: 00ff00ff * Sprite
7,2: 00ff00ff * Sprite
7,3: 00ff00ff * Sprite
7,4: 00ff00ff * Sprite
7,5: 00ff00ff * Sprite
7,6: 00ff00ff * Sprite
7,7: 00ff00ff * Sprite
8,0: 00ffffff * Disk
8,1: 00ffffff * Disk
8,2: 00ffffff * Disk
;------------------------------------------------------------------------------
>vm 5 0																			; blitter enable, disable
5,0: 00008888 * Blitter
>vm
0,0: 00222222 * -
1,0: 00444444 * Refresh
1,1: 00444444 * Refresh
1,2: 00444444 * Refresh
1,3: 00444444 * Refresh
2,0: 00a25342 * CPU
2,1: 00ad98d6 * CPU
3,0: 00eeee00 * Copper
3,1: 00aaaa22 * Copper
3,2: 00666644 * Copper
4,0: 00ff0000   Audio
4,1: 00ff0000   Audio
4,2: 00ff0000   Audio
4,3: 00ff0000   Audio
5,0: 00008888 * Blitter															; blitter again enabled
5,1: 000088ff * Blitter
6,0: 000000ff * Bitplane
6,1: 000000ff * Bitplane
6,2: 000000ff * Bitplane
6,3: 000000ff * Bitplane
6,4: 000000ff * Bitplane
6,5: 000000ff * Bitplane
6,6: 000000ff * Bitplane
6,7: 000000ff * Bitplane
7,0: 00ff00ff * Sprite
7,1: 00ff00ff * Sprite
7,2: 00ff00ff * Sprite
7,3: 00ff00ff * Sprite
7,4: 00ff00ff * Sprite
7,5: 00ff00ff * Sprite
7,6: 00ff00ff * Sprite
7,7: 00ff00ff * Sprite
8,0: 00ffffff * Disk
8,1: 00ffffff * Disk
8,2: 00ffffff * Disk
>
;------------------------------------------------------------------------------
>vm 5 1																			; not separated possible
5,1: 000088ff * Blitter
;------------------------------------------------------------------------------
>vm 4
4,0: 00ff0000 * Audio
>vm
0,0: 00222222 * -
1,0: 00444444 * Refresh
1,1: 00444444 * Refresh
1,2: 00444444 * Refresh
1,3: 00444444 * Refresh
2,0: 00a25342 * CPU
2,1: 00ad98d6 * CPU
3,0: 00eeee00 * Copper
3,1: 00aaaa22 * Copper
3,2: 00666644 * Copper
4,0: 00ff0000 * Audio
4,1: 00ff0000 * Audio
4,2: 00ff0000 * Audio
4,3: 00ff0000 * Audio
5,0: 00008888 * Blitter
5,1: 000088ff * Blitter
6,0: 000000ff * Bitplane
6,1: 000000ff * Bitplane
6,2: 000000ff * Bitplane
6,3: 000000ff * Bitplane
6,4: 000000ff * Bitplane
6,5: 000000ff * Bitplane
6,6: 000000ff * Bitplane
6,7: 000000ff * Bitplane
7,0: 00ff00ff * Sprite
7,1: 00ff00ff * Sprite
7,2: 00ff00ff * Sprite
7,3: 00ff00ff * Sprite
7,4: 00ff00ff * Sprite
7,5: 00ff00ff * Sprite
7,6: 00ff00ff * Sprite
7,7: 00ff00ff * Sprite
8,0: 00ffffff * Disk
8,1: 00ffffff * Disk
8,2: 00ffffff * Disk
>

;------------------------------------------------------------------------------
																				; 6. vm <channel> <sub index> <hex rgb>
																				;				 = change color of channel.
																				;				   If sub index is zero: all sub index colors are changed.

>vm 6 0 00ffff00																; change color for all bitplanes
6,0: 00ffff00 * Bitplane								
;------------------------------------------------------------------------------
>vm
0,0: 0000000b * -
1,0: 00444444 * Refresh
1,1: 00444444 * Refresh
1,2: 00444444 * Refresh
1,3: 00444444 * Refresh
2,0: 00a25342 * CPU
2,1: 00ad98d6 * CPU
3,0: 00eeee00 * Copper
3,1: 00aaaa22 * Copper
3,2: 00666644 * Copper
4,0: 00ff0000   Audio
4,1: 00ff0000   Audio
4,2: 00ff0000   Audio
4,3: 00ff0000   Audio
5,0: 00008888 * Blitter
5,1: 000088ff * Blitter
6,0: 00ffff00 * Bitplane														; color for bitplane changed
6,1: 00ffff00 * Bitplane
6,2: 00ffff00 * Bitplane
6,3: 00ffff00 * Bitplane
6,4: 00ffff00 * Bitplane
6,5: 00ffff00 * Bitplane
6,6: 00ffff00 * Bitplane
6,7: 00ffff00 * Bitplane
7,0: 00ff00ff * Sprite
7,1: 00ff00ff * Sprite
7,2: 00ff00ff * Sprite
7,3: 00ff00ff * Sprite
7,4: 00ff00ff * Sprite
7,5: 00ff00ff * Sprite
7,6: 00ff00ff * Sprite
7,7: 00ff00ff * Sprite
8,0: 00ffffff * Disk
8,1: 00ffffff * Disk
8,2: 00ffffff * Disk
>  
;------------------------------------------------------------------------------
>vm 7 1 00aabbcc																; change color for sprite 1
7,0: 00aabbcc * Sprite
>vm
0,0: 00222222 * -
1,0: 00444444 * Refresh
1,1: 00444444 * Refresh
1,2: 00444444 * Refresh
1,3: 00444444 * Refresh
2,0: 00a25342 * CPU
2,1: 00ad98d6 * CPU
3,0: 00eeee00 * Copper
3,1: 00aaaa22 * Copper
3,2: 00666644 * Copper
4,0: 00ff0000 * Audio
4,1: 00ff0000 * Audio
4,2: 00ff0000 * Audio
4,3: 00ff0000 * Audio
5,0: 00008888 * Blitter
5,1: 000088ff * Blitter
6,0: 000000ff * Bitplane
6,1: 000000ff * Bitplane
6,2: 000000ff * Bitplane
6,3: 000000ff * Bitplane
6,4: 000000ff * Bitplane
6,5: 000000ff * Bitplane
6,6: 000000ff * Bitplane
6,7: 000000ff * Bitplane
7,0: 00aabbcc * Sprite			; here 	
7,1: 00ff00ff * Sprite
7,2: 00ff00ff * Sprite
7,3: 00ff00ff * Sprite
7,4: 00ff00ff * Sprite
7,5: 00ff00ff * Sprite
7,6: 00ff00ff * Sprite
7,7: 00ff00ff * Sprite
8,0: 00ffffff * Disk
8,1: 00ffffff * Disk
8,2: 00ffffff * Disk
>
