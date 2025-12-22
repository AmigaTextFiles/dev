
CommandLineHelp:

			;bold and color 31
		print	<13,10,$9b,$31,$3b,$33,$31,$6d>
		print	<"NBBS Intuition Interfaced SetUp Program, IISUP",13,10>,_stdout
		print	<$9b,$33,$3b,$33,$32,$6d>
		print	<"(C)opyright 1991 Tomi Blinnikka",13,10>,_stdout
		print	<$9b,$30,$3b,$33,$31,$6d,13,10>
		print	<"Usage: Config [Filename]",13,10>,_stdout
		print	<"Where [Filename] is the name of the config file",13,10>,_stdout
		print	<$9b,$30,$6d,13,10>
		jmp	ShutDown
