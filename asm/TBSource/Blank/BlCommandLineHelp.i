
CommandLineHelp:

			;bold and color 31
		print	<13,10,$9b,$31,$3b,$33,$31,$6d>
		print	<"Blank v0.01b.",13,10>,_stdout
		print	<$9b,$33,$3b,$33,$32,$6d>
		print	<"Original code by Jukka Marin, reworked by Tomi Blinnikka.",13,10>,_stdout
		print	<$9b,$30,$3b,$33,$31,$6d,13,10>
		print	<"USAGE: Blank [NN], where NN = 1 - 9999.",13,10>,_stdout
		print	<"Blanks the screen after NN seconds.",13,10>,_stdout
		print	<"Default is 60 seconds (1 minute).",13,10>,_stdout
		print	<$9b,$30,$6d,13,10>
		jmp	cleanup_out

		dc.b	"$VER: Blank 0.01b",0
