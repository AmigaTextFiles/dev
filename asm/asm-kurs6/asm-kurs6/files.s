Content

Lektion19.s			Tutorial about WinUAE Debugger
Listing19a.s		Action Replay reference map (as a comparison to the WinUAE Debugger)
Listing19b1.s		only output information
Listing19b2.s		data manipulation
Listing19b3.s		search and find
Listing19c1.s		f - debugging an assembler program with a programm breakpoint (GUI-Deb.)
Listing19c2.s		f - debugging an assembler program with a programm breakpoint (Console)	
Listing19c3.s		a - <address> assembler
Listing19c4.s		fp - debugging an assembler program with a programm breakpoint start and run from shell
Listing19c5.s		z - step through one instruction - useful for JSR, DBRA etc.
Listing19c6.s		fo - conditional breakpoint
Listing19d1.s		w - memory watchpoint - general command and possible combinations
Listing19d2.s		w - debugging an assembler program with a memory watchpoint
Listing19d3.s		w - debugging an assembler program with a memory watchpoint freeze		
Listing19e1.s		S - save part of memory as bytes
Listing19e2.s		L - load a part of memory
Listing19f1.s		M<a/b/s> <val> - enable/disable sprite channels 
Listing19g1.s		sp <addr> [<addr2][<size>] Dump sprite information. (sprite - ripping)
Listing19h1.s		vh [<ratio> <lines>]  "Heat map"
Listing19h2.s		vh - Beispiel
Listing19i1.s		fc - scanline 
Listing19i2.s		fs - scanline
Listing19j1.s		C - trainer
Listing19j2.s		D - deep trainer	
Listing19k1.s		v, vm - DMA Debugger
Listing19k2.s		DMA Debugger - cycle exact mode is disabled
Listing19k3.s		DMA Debugger - cycle exact mode enabled CPU und DMA usage
Listing19k4.s		DMA Debugger - blitter cycle sequence
Listing19k5.s		DMA Debugger - bitplane special characters etc.	
Listing19l1.s		Copper Debugger - activation
Listing19l2.s		Copper-Debugger and DMA-Debugger
Listing19l3.s		Copper-Debugger - Copper-Debugger od, and Copper trace ot
Listing19l4.s		Copper-Debugger - Copper trace with DMA-Debugger		
Listing19m1.s		H - History
Listing19n1.s		smc - self modifying code detection
Listing19o1.s		dj [<level bitmask>] - enable joystick/mouse input debugging
Listing19p1.s		il - exception breakpoint mask
Listing19q1.s		wd - illegal acces logger
Listing19r1.s		di - disk logging
Listing19s1.s		rip workbench hand
Listing19s1b.s		show ripped hand
Listing19s2.s		debug reset


based on Lesson 13
Listing13a.s		line 265 - find faster instruction										; replacement instructions
Listing13a2.s		line 295 - find faster instruction										; replacement instructions
					
Listing13b.s		line 431 - bit shift													; simple maths
Listing13b2.s		line 472 - multiplication - factorization into prime factors			; simple maths
Listing13b3.s		line 548 - multiplication - special cases								; simple maths
Listing13b4.s		line 580 - Multiplikation - reset high word from source longword?		; simple maths
Listing13b5.s		line 604 - summarized													; simple maths
Listing13b6.s				 - multiplication - Cycles										; simple maths
		
Listing13c.s		line 645 - influence of the addressing mode for cycle usage				; cycle count
		
Listing13d1a.s		line 988 - precalculated tables (incbin)								; tables
Listing13d1b.s		line 1001 - precalculated tables inside program							; tables
Listing13d2.s		line 1033 - save multiplication by precalculated table (Listing8n2.s)	; tables
Listing13d3.s		line 1145 - optimized routine by precalculated table (Listing1l5b.s)	; tables
	
					line 1230 to 1400 see Listing13gx.s										;
					
Listing13e1a.s		line 1425 - clear memory area - bad method								; optimization clean memory area
Listing13e1b.s		line 1425 - clear memory area - bad method								; optimization clean memory area
Listing13e2.s		line 1439 - clear memory area - bad method	 (improved)					; optimization clean memory area
Listing13e3.s		line 1450 - clear memory area - bad method	 (further improved)			; optimization clean memory area
Listing13e4s		line 1462 - clear memory area - bad method  (further improved)			; optimization clean memory area
Listing13e5s		line 1492 - clear memory area - it gets even better						; optimization clean memory area
Listing13e6s		line 1519 - clear memory area - it gets even better - rept				; optimization clean memory area
			
Listing13f.s		line 1539 - copy block of bytes - slow method							; Code-extension technique
Listing13f2.s		line 1549 - copy block of bytes - faster method							; Code-extension technique					
Listing13f3.s		line 1568 - copy block of bytes - mediated methode 68k/68020+			; Code-extension technique	
		
Listing13g.s		line 1610 - search to the end or find the position						; program flow
Listing13g2.s		line 1230 - like switch case or if then									; program flow
Listing13g3.s		line 1346 - case distinction if positive, negative, zero				; program flow
Listing13g4.s		line 1338 - copy block of bytes - method (program fragment)				; program flow
		
Listing13h.s		line 1626 - 364 Bytes copy block - 1650 cycles							; copy memory area
Listing13h2.s		line 1626 - 364 Bytes copy block - 1624 cycles (rept and variable)		; copy memory area
		
Listing13i.s		line 1660 - load multiple registers at once								; various group
Listing13i2.s		line 1713 - relativ to PC												; various group
Listing13i3.s		line 1811 - relativ to PC												; various group
Listing13i4.s		line 1865 - bits as flags												; various group

Listing13j.s		line 1920 - block with instructions, rept (program fragment)			; optimization on 68020+
Listing13j2.s		line 1957 - wait states													; optimization on 68020+
Listing13j3.s		line 1983 - cnop 0,4 (program fragment)									; optimization on 68020+

Listing13k.s		line 2110 - blitter optimizations (Listing9f1.s)						; blitter optimizations
Listing13k2a.s		line 2157 - blitter optimizations (other solution)						; blitter optimizations
Listing13k2b.s		line 2181 - load characters on memory (quiz solved)						; blitter optimizations
Listing13k3.s		line 2246 - clear memory area - fasted method (CPU and blitter)			; blitter optimizations



