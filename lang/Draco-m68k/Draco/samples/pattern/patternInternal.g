type
    PatternCompileError_t = enum {
	pse_ok,
	pse_missingPrimary,
	pse_unexpectedRightParen,
	pse_unexpectedOr,
	pse_missingRightParen,
    },

    PatternState_t = struct {
	*[2]char ps_pattern;
	*[2]ulong ps_compiled;
	*[2]ulong ps_activeStates;
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
