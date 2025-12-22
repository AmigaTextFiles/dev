type
    PatternCompileError_t = enum {
	pse_ok,
	pse_missingPrimary,
	pse_unexpectedRightParen,
	pse_unexpectedOr,
	pse_missingRightParen,
    },

    PatternState_t = struct {
	*char ps_pattern;
	*ulong ps_compiled;
	*ulong ps_activeStates;
	ulong ps_length;
	bool ps_ignoreCase;
	PatternCompileError_t ps_error;
	[2] byte ps_pad;
	ulong ps_position;
	ulong ps_stateCount;
	char ps_char;
	bool ps_end;
	bool ps_matched;
    };

extern
    OpenPatternLibrary(ulong version)*Library_t,
    Compile(*PatternState_t ps)void,
    Match(*PatternState_t ps; *char subject; ulong subjectLength)bool,
    ClosePatternLibrary()void;
