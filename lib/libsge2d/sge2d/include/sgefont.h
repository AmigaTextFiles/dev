#ifndef _SGEFONT_H
#define _SGEFONT_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgefont.h
 * @brief Bitmap font handling and effects
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeFont
 * @brief Bitmap font handling and effects
 *
 * Print with bitmap fonts, including animated
 * text effects.
 *
 * Bitmap fonts are wide PNG images having all characters
 * in one row, split by a single pixel line of pink color
 * (0xff00ff).
 *
 * If the font is called myfont.png, there has to be a file
 * called myfont.png.map which lists the characters from
 * the image, so if your image shows the characters
 * SGE, then your map file should read 'SGE'
 *
 * Just have a look at the standard fonts to see how they
 * are done.
 *
 * @{
 */

/**
 * @define SGEFONT_BITMAP
 * @brief font is a sge bitmap font
 */
#define SGEFONT_BITMAP 1

/**
 * @struct SGEBITMAPFONT
 * @brief a bitmap font structure
 */
typedef struct {
	/** @privatesection */
	SDL_Surface *bitmap;
	unsigned char *charmap;
	SGEARRAY *info;
} SGEBITMAPFONT;

/**
 * @struct SGEFONT
 * @brief a font structure
 */
typedef struct {
	/** @brief The type of the font (e.g. SGEFONT_BITMAP) */
	int type;
	/** @brief The alpha of the font, 0 to 255, 255 is fully opaque */
	Uint8 alpha;
	/** @privatesection */
	void *data;
} SGEFONT;

/**
 * @enum SGEFONTFX_TYPES
 * @brief different font effects
 */
enum SGEFONTFX_TYPES {
	/** @brief fade the font in */
	SGEFONTFX_FADE_IN,
	/** @brief fade the font out */
	SGEFONTFX_FADE_OUT,
	/** @brief fade the font in, then out */
	SGEFONTFX_FADE_INOUT,
	/** @brief move the font in */
	SGEFONTFX_MOVE_IN,
	/** @brief move the font out */
	SGEFONTFX_MOVE_OUT,
	/** @brief move the font in, then out */
	SGEFONTFX_MOVE_INOUT,
	/** @brief show a count down */
	SGEFONTFX_COUNTDOWN
};

/**
 * @enum SGEFONTFX_MOVEMENT
 * @brief different move effects
 */
enum SGEFONTFX_MOVEMENT {
	/** @brief move at a constant speed */
	SGEFONTFX_MOVE_LINEAR,
	/** @brief move fast, then slow down until rest */
	SGEFONTFX_MOVE_SLOWDOWN,
	/** @brief accelerate movement */
	SGEFONTFX_MOVE_ACCELERATE,
	/** @brief bounce the font in */
	SGEFONTFX_MOVE_BOUNCE
};

/**
 * @struct SGEFONTFXFADEINFO
 * @brief @b internal, holds information about a current fade state
 */
typedef struct {
	/** @privatesection */
	Uint32 runtime;
	Uint8 fade;
} SGEFONTFXFADEINFO;

/**
 * @struct SGEFONTFXCOUNTDOWNINFO
 * @brief @b internal, holds information about a current count down
 */
typedef struct {
	/** @privatesection */
	Uint32 runtime;
	Sint32 start;
	Sint32 end;
} SGEFONTFXCOUNTDOWNINFO;

/**
 * struct SGEFONTFX
 * @brief holds information about a font effect
 */
typedef struct {
	/** @privatesection */
	int startx, starty;
	int endx, endy;
	Uint32 type;
	Uint32 runtime;
	Uint32 startTime;
	Uint32 finishTime;
	Uint32 charOffset;
	Uint32 finished;
	Uint8 movement;
	SDL_Surface *surface;
	SGEFONT *font;
	void *data;
	void (*updateFunction)(void *);
	void (*freeFunction)(void *);
	char *text;
	SGEARRAY *textSprites;
	Uint32 preDelay;
	Uint32 postDelay;
	Uint8 hideOnPreDelay;
} SGEFONTFX;

/**
 * @struct SGEFONTFXFADEINOUTINFO
 * @brief @b internal, holds information about a in and out fading effect
 */
typedef struct {
	/** @privatesection */
	SGEFONTFX *fadeIn;
	SGEFONTFX *fadeOut;
} SGEFONTFXFADEINOUTINFO;

/**
 * @brief create a new empty font
 * @param type the type of the font
 * @return a pointer to a new @link SGEFONT @endlink
 * @see SGEFONT_BITMAP
 */
SGEFONT *sgeFontNew(int type);

/**
 * @brief create a new font from a file
 * @param f a pointer to a opened sge file archive @link SGEFILE @endlink
 * @param type type of the font
 * @param filename the name of the png file holding the font bitmap
 * @return a pointer to a new @link SGEFONT @endlink
 * @see SGEFONT_BITMAP
 */
SGEFONT *sgeFontNewFile(SGEFILE *f, int type, const char *filename);

/** @private */
SGEFONT *sgeFontNewFileBitmap(SGEFILE *f, const char *filename);

/**
 * @brief destroy a font and free its resources
 * @param f a pointer to a @link SGEFONT @endlink
 */
void sgeFontDestroy(SGEFONT *f);

/**
 * @brief get the height of a line with the font
 * @param f a pointer to a @link SGEFONT @endlink
 * @return the height of a single line in pixels
 */
int sgeFontGetLineHeight(SGEFONT *f);
/** @private */
int sgeFontGetLineHeightBitmap(SGEFONT *f);

/**
 * @brief print a text with the font
 * @param f a pointer to a @link SGEFONT @endlink
 * @param dest a SDL_Surface to print on (e.g. screen)
 * @param x the x position to print the font
 * @param y the y position to print the font
 * @param text the text to print
 */
int sgeFontPrint(SGEFONT *f, SDL_Surface *dest, int x, int y, const char *text);
/** @private */
int sgeFontPrintBitmap(SGEFONT *f, SDL_Surface *dest, int x, int y, const char *text);

/**
 * @brief get the width of a text
 * @param f a pointer to a @link SGEFONT @endlink
 * @param text the text to check the with of
 * @return the width of the text if it would have printed
 */
int sgeFontGetWidth(SGEFONT *f, const char *text);
/** @private */
int sgeFontGetWidthBitmap(SGEFONT *f, const char *text);

/**
 * @brief ignore the alpha channel of a font
 * @param f a pointer to a @link SGEFONT @endlink
 * @see sgeFontUseAlpha
 *
 * faster but prints a background color
 */
void sgeFontIgnoreAlpha(SGEFONT *f);

/**
 * @brief use the alpha channel of a font (default)
 * @param f a pointer to a @link SGEFONT @endlink
 * @see sgeFontIgnoreAlpha
 */
void sgeFontUseAlpha(SGEFONT *f);

/**
 * @brief create a new font effect
 * @param f a pointer to a @link SGEFONT @endlink
 * @param fxtype the effect type @link SGEFONTFX_TYPES @endlink
 * @param movement the movement type @link SGEFONTFX_MOVEMENT @endlink
 * @param runtime how long should the effect take, in miliseconds
 * @param charOffset the offset of the characters in miliseconds, read detail description
 * @param startx the x position to start the effect from
 * @param starty the y position to start the effect from
 * @param endx the x position to end the effect at
 * @param endy the y position to end the effect at
 * @param text the text to make the effect with
 * @return a pointer to a new @link SGEFONTFX @endlink
 *
 * The charOffset defines how much 'behind' the single characters
 * of the text are treated.
 *
 * Setting charOffset to 0 means there is no per character treatment
 * and the full text will only be one big image.
 *
 * Setting charOffset to>0 means that each character is treated as
 * a single image with a delay of charOffset miliseconds.
 *
 * example:
 *
 * Fade the text in from -100, 0 (outside the screen up left) to the bottom
 * of the screen (1, 220), move every single character with a offset of 99
 * in a down slowing movement. The whole effect should take 1000 miliseconds.
 * As we use a offset of 99, it actually takes longer then 1000 miliseconds
 * depending on text length. It takes 1000 miliseconds for the first character
 * and then continues until all characters are on its destination.
 *
 * @code
 * SGEFONTFX *fx=sgeFontFXNew(data->font, SGEFONTFX_FADE_IN, SGEFONTFX_MOVE_SLOWDOWN, 1000, 99, -100, 0, 1, 220, "Look at me, i am fancy");
 * @endcode
 *
 */
SGEFONTFX *sgeFontFXNew(SGEFONT *f, Uint32 fxtype, Uint8 movement, Uint32 runtime, Uint32 charOffset, int startx, int starty, int endx, int endy, const char *text);

/**
 * @brief draw the effect
 * @param fx a pointer to a @link SGEFONTFX @endlink
 */
void sgeFontFXDraw(SGEFONTFX *fx);

/**
 * @brief destroy the effect and free its resources
 * @param fx a pointer to a @link SGEFONTFX @endlink
 */
void sgeFontFXDestroy(SGEFONTFX *fx);

/**
 * @brief set the value range for a count down (or up) effect
 * @param fx a pointer to a @link SGEFONTFX @endlink
 * @param start the start value
 * @param end the end value
 *
 * The end value can be higher then start value for a 'count up'
 * effect
 */
void sgeFontFXCountdownSetValues(SGEFONTFX *fx, Sint32 start, Sint32 end);

/**
 * @brief set the miliseconds to wait before starting the effect
 * @param fx a pointer to a @link SGEFONTFX @endlink
 * @param delay the delay in miliseconds
 * @see sgeFontFXHideOnPreDelay
 */
void sgeFontFXPreDelay(SGEFONTFX *fx, Uint32 delay);

/**
 * @brief hide the effect until pre delay is over
 * @param fx a pointer to a @link SGEFONTFX @endlink
 * @param YES/NO if you want to hide, default is not to hide
 * @see sgeFontFXPreDelay
 */
void sgeFontFXHideOnPreDelay(SGEFONTFX *fx, Uint8 yesno);

/**
 * @brief wait after a effect is finished until it actually is treated as finished
 * @param fx a pointer to a @link SGEFONTFX @endlink
 * @param delay the delay in miliseconds
 * @see sgeFontFXFinished
 */
void sgeFontFXPostDelay(SGEFONTFX *fx, Uint32 delay);

/**
 * @brief force an early finish of a effect
 * @param fx a pointer to a @link SGEFONTFX @endlink
 */
void sgeFontFXSetFinished(SGEFONTFX *fx);

/**
 * @brief check if a effect is finished
 * @param fx a pointer to a @link SGEFONTFX @endlink
 * @return YES/NO if the effect is finished
 *
 * Includes pre and post delay into its calculation.
 *
 * @see sgeFontFXPreDelay
 * @see sgeFontFXPostDelay
 */
int sgeFontFXFinished(SGEFONTFX *fx);

/**
 * @brief change render target (default screen) of the effect
 * @param fx a pointer to a @link SGEFONTFX @endlink
 * @param surface a pointer to a SDL_Surface on which to render the effect
 */
void sgeFontFXSetTarget(SGEFONTFX *fx, SDL_Surface *surface);

/** @privatesection */
SGEFONTFXFADEINFO *sgeFontFXFadeInfoNew(Uint32 runtime);
void sgeFontFXFadeInfoDestroy(SGEFONTFXFADEINFO *fi);
SGEFONTFXFADEINOUTINFO *sgeFontFXFadeInOutInfoNew(SGEFONTFX *fx, Uint32 runtimein, Uint32 runtimeout,Uint8 fade);
void sgeFontFXFadeInOutInfoDestroy(SGEFONTFXFADEINOUTINFO *fi);
SGEFONTFXCOUNTDOWNINFO *sgeFontFXCountdownInfoNew(Uint32 runtime);
void sgeFontFXCountdownInfoDestroy(SGEFONTFXCOUNTDOWNINFO *fi);
int sgeFontFXGetPer10K(SGEFONTFX *fx, Uint32 current, Uint32 runtime, Uint32 currentElement, Uint32 numberOfElements);

void sgeFontFXFadeInUpdate(void *data);
void sgeFontFXFadeInDestroy(void *data);

void sgeFontFXFadeOutUpdate(void *data);
void sgeFontFXFadeOutDestroy(void *data);

void sgeFontFXFadeInOutUpdate(void *data);
void sgeFontFXFadeInOutDestroy(void *data);

void sgeFontFXCountdownUpdate(void *data);
void sgeFontFXCountdownDestroy(void *data);

// }@

#ifdef __cplusplus
}
#endif

#endif
