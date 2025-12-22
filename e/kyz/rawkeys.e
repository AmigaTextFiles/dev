-> Raw keycodes
-> WARNING: These are taken from the USA keyboard in the HW manual
-> and will differ in context on different keyboards. Use keymaps!

OPT MODULE
OPT EXPORT

CONST	KEYUP=$80, RAWKEY_MASK=$7f

-> If a key is being pressed, it sends   (keycode)
-> If a key is being unpressed, it sends (keycode OR KEYUP)

ENUM	KEY_BACKQUOTE,			-> $00
	KEY_1,				-> $01
	KEY_2,				-> $02
	KEY_3,				-> $03
	KEY_4,				-> $04
	KEY_5,				-> $05
	KEY_6,				-> $06
	KEY_7,				-> $07
	KEY_8,				-> $08
	KEY_9,				-> $09
	KEY_0,				-> $0a
	KEY_MINUS,			-> $0b
	KEY_EQUALS,			-> $0c
	KEY_BACKSLASH,			-> $0d
					-> no $0e
	KEYPAD_0=$0f,			-> $0f

	KEY_Q,				-> $10
	KEY_W,				-> $11
	KEY_E,				-> $12
	KEY_R,				-> $13
	KEY_T,				-> $14
	KEY_Y,				-> $15
	KEY_U,				-> $16
	KEY_I,				-> $17
	KEY_O,				-> $18
	KEY_P,				-> $19
	KEY_OPEN_BRACKET,		-> $1a
	KEY_CLOSE_BRACKET,		-> $1b
					-> no $1c
	KEYPAD_1=$1d,			-> $1d
	KEYPAD_2,			-> $1e
	KEYPAD_3,			-> $1f

	KEY_A,				-> $20
	KEY_S,				-> $21
	KEY_D,				-> $22
	KEY_F,				-> $23
	KEY_G,				-> $24
	KEY_H,				-> $25
	KEY_J,				-> $26
	KEY_K,				-> $27
	KEY_L,				-> $28
	KEY_SEMICOLON,			-> $29
	KEY_QUOTE,			-> $2a
	UNMAPPED_BESIDE_RETURN,		-> $2b
					-> no $2c
	KEYPAD_4=$2d,			-> $2d
	KEYPAD_5,			-> $2e
	KEYPAD_6,			-> $2f

	UNMAPPED_BESIDE_LEFT_SHIFT,	-> $30
	KEY_Z,				-> $31
	KEY_X,				-> $32
	KEY_C,				-> $33
	KEY_V,				-> $34
	KEY_B,				-> $35
	KEY_N,				-> $36
	KEY_M,				-> $37
	KEY_COMMA,			-> $38
	KEY_PERIOD,			-> $39
	KEY_SLASH,			-> $3a
					-> no $3b
	KEYPAD_PERIOD=$3c,		-> $3c
	KEYPAD_7,			-> $3d
	KEYPAD_8,			-> $3e
	KEYPAD_9,			-> $3f

	KEY_SPACE,			-> $40
	KEY_BACKSPACE,			-> $41
	KEY_TAB,			-> $42
	KEYPAD_ENTER,			-> $43
	KEY_RETURN,			-> $44
	KEY_ESC,			-> $45
	KEY_DEL,			-> $46
					-> no $47
					-> no $48
					-> no $49
	KEYPAD_MINUS=$4a,		-> $4a
					-> no $4b
	CURS_UP=$4c,			-> $4c
	CURS_DOWN,			-> $4d
	CURS_RIGHT,			-> $4e
	CURS_LEFT,			-> $4f

	KEY_F1,				-> $50
	KEY_F2,				-> $51
	KEY_F3,				-> $52
	KEY_F4,				-> $53
	KEY_F5,				-> $54
	KEY_F6,				-> $55
	KEY_F7,				-> $56
	KEY_F8,				-> $57
	KEY_F9,				-> $58
	KEY_F10,			-> $59

	KEYPAD_OPEN_PARENTHESIS,	-> $5a
	KEYPAD_CLOSE_PARENTHESIS,	-> $5b
	KEYPAD_SLASH,			-> $5c
	KEYPAD_STAR,			-> $5d
	KEYPAD_PLUS,			-> $5e
	KEY_HELP,			-> $5f

	KEY_LSHIFT,			-> $60
	KEY_RSHIFT,			-> $61
	KEY_CAPSLOCK,			-> $62
	KEY_CTRL,			-> $63
	KEY_LALT,			-> $64
	KEY_RALT,			-> $65
	KEY_LAMIGA,			-> $66
	KEY_RAMIGA			-> $67

-> aliases
CONST	KEY_TILDE=KEY_BACKQUOTE,

	KEY_UNDERLINE=KEY_MINUS,
	KEY_PLUS=KEY_EQUALS,
	KEY_BAR=KEY_BACKSLASH,
	KEY_PIPE=KEY_BACKSLASH,

	KEY_OPEN_BRACE=KEY_OPEN_BRACKET,
	KEY_CLOSE_BRACE=KEY_CLOSE_BRACKET,

	KEY_COLON=KEY_SEMICOLON,
	KEY_DOUBLEQUOTE=KEY_QUOTE,

	KEY_LESSTHAN=KEY_COMMA,
	KEY_GREATHERTHAN=KEY_PERIOD,
	KEY_DOT=KEY_PERIOD,
	KEY_POINT=KEY_PERIOD,
	KEY_QUESTIONMARK=KEY_SLASH,
	KEY_QUERY=KEY_SLASH,

	KEYPAD_NUMLOCK=KEYPAD_OPEN_PARENTHESIS,
	KEYPAD_SCROLLLOCK=KEYPAD_CLOSE_PARENTHESIS,
	KEYPAD_SYSTEMREQUEST=KEYPAD_SLASH,
	KEYPAD_PRINTSCREEN=KEYPAD_STAR,
	KEYPAD_DIVIDE=KEYPAD_SLASH,
	KEYPAD_MULTIPLY=KEYPAD_STAR,

	KEYPAD_DOT=KEYPAD_PERIOD,
	KEYPAD_POINT=KEYPAD_PERIOD,

	KEY_LEFT_SHIFT=KEY_LSHIFT,
	KEY_RIGHT_SHIFT=KEY_RSHIFT,
	KEY_LEFT_ALT=KEY_LALT,
	KEY_RIGHT_ALT=KEY_RALT,
	KEY_LEFT_AMIGA=KEY_LAMIGA,
	KEY_RIGHT_AMIGA=KEY_RAMIGA
