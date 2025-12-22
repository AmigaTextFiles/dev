#define VDP_REG_FLAGS0 0x80
// Screen sync off
#define VDP_REG_FLAGS0_SYNC 0x01
// Normal or enable stretch screen
#define VDP_REG_FLAGS0_STRETCH 0x02
// Causes graphics change (related to screen addr?)
#define VDP_REG_FLAGS0_CHANGE 0x04
// Shift sprites left by 1 character
#define VDP_REG_FLAGS0_SHIFT 0x08
// Horizontal interupts enable
#define VDP_REG_FLAGS0_HINT 0x10
// Display extra column on LHS of screen
#define VDP_REG_FLAGS0_LHS 0x20
// Top 2 rows of screen horizontal non-scrolling
#define VDP_REG_FLAGS0_LOCKTOP 0x40
// Right side of screen vertical non-scrolling
#define VDP_REG_FLAGS0_LOCKRIGHT 0x80


#define VDP_REG_FLAGS1 0x81
// Double sized pixels in sprites
#define VDP_REG_FLAGS1_DOUBLE 0x01
// 8x16 sprites
#define VDP_REG_FLAGS1_8x16 0x02
// 0?
#define VDP_REG_FLAGS1_BIT2 0x04
// Stretch screen by 6 rows
#define VDP_REG_FLAGS1_STRETCH6 0x08
// Stretch screen by 4 rows
#define VDP_REG_FLAGS1_STRETCH4 0x10
// Vertical interrupts enable
#define VDP_REG_FLAGS1_VINT 0x20
// Screen enable
#define VDP_REG_FLAGS1_SCREEN 0x40
// 0?
#define VDP_REG_FLAGS1_BIT7 0x80

#define VDP_REG_HINT_COUNTER 0x8A

#define JOY_UP 0x01
#define JOY_DOWN 0x02
#define JOY_LEFT 0x04
#define JOY_RIGHT 0x08
#define JOY_FIREA 0x10
#define JOY_FIREB 0x20

extern void __LIB__ load_palette(unsigned char *data, int index, int count);
extern void __LIB__ load_tiles(unsigned char *data, int index, int count, int bpp);
extern void __LIB__ set_bkg_map(unsigned int *data, int x, int y, int w, int h);
extern void __LIB__ scroll_bkg(int x, int y);
extern int __LIB__ get_vcount();
extern int __LIB__ wait_vblank_noint();
extern void __LIB__ set_sprite(int n, int x, int y, int tile);
extern int __LIB__ read_joypad1();
extern int __LIB__ read_joypad2();
extern void __LIB__ set_vdp_reg(int reg, int value);
extern void __LIB__ gotoxy(int x, int y);
extern void __LIB__ aplib_depack(unsigned char *src, unsigned char *dest);
extern void __LIB__ add_raster_int(void *ptr);
extern void __LIB__ add_pause_int(void *ptr);
extern void __LIB__ set_sound_freq(int channel, int freq);
extern void __LIB__ set_sound_volume(int channel, int volume);

extern unsigned char __LIB__ standard_font(); // Note: actually, it's a data pointer, not a procedure, but I couldn't get it to work correctly as data.
