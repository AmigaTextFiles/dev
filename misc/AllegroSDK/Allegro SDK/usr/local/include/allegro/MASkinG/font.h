// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_FONT_H
#define			MASKING_FONT_H

#include <alfont.h>
#include "bitmap.h"
#include "point.h"
#include "color.h"
#include "error.h"
#include "maskingdll.h"

namespace MAS {
/**
	Class for handling fonts.
	Font is a wrapper class for two kinds of fonts (might change in the future):
	normal Allegro fonts (struct FONT) and AlFont fonts (struct ALFONT_FONT).
	AlFont is an Allegro addon library which is basically a wrapper for the
	FreeType project. The Font class provides a unified API for loading and
	outputting text with many types of fonts including bitmap, BIOS, GRX,
	truetype, type1 fonts and some other formats. There are also other text
	output functions specifically meant for GUI purposes.
*/
class MASKING_DLL_DECLSPEC Font {
	protected:
		/**
			Available font types.
			Currently Font has support for two font structures: normal Allegro
			FONT and AlFont's ALFONT_FONT but only one is loaded at any time.
			The Type enum has actually the following values:
<pre>
       ALLEGRO_FONT         - normal Allegro FONT
       FREETYPE_FONT        - AlFont's ALFONT_FONT
</pre>
		*/
		enum Type { ALLEGRO_FONT, FREETYPE_FONT };

		/**
			The type of the currently loaded underlying font.
		*/
		Type type;

		/*
			Union containg the underlaying low level font. This is probably not
			the best thing from a design point of view and should be replaced
			with a better system (polymorphism?).
		*/
		union {
			ALFONT_FONT *ff;
			FONT *af;
		};

		/**
			The fonts palette. Only aplicable for non-monochrome bitmap fonts.
			The palette is set automatically on every textprint operation if
			necessary.
		*/
		PALETTE pal;

		/**
			Did we actually allocate memory or did we just make a pointer?
			This variable is set to true if the object allocated memory for
			the font itself. If it did then it will be freed when the object
			is destroyed or a new font is loaded, otherwise the "owner" of the
			underlying data is responsible for freeing it.
		*/
		bool allocated;

	public:
		/**
			Default constructor.
			Creates a new font and initializes it with the default Allegro 8x8 font
			or whatever is curently loaded in <i>font</i>.
		*/
		Font();

		/**
			Constructor for making a font with an existing FONT.
			Doesn't copy the data, only makes a pointer!
		*/
		Font(FONT *f);

		/**
			Constructor for making a font with an existing ALFONT_FONT.
			Doesn't copy the data, only makes a pointer!
		*/
		Font(ALFONT_FONT *f);

		/**
			Constructor for making a font by loading it from a file.
			See below for a list of supported formats.
		*/
		Font(const char *f);

		/**
			Copy constructor.
		*/
		Font(const Font& f);

		virtual ~Font();

		/** */Font& Create();
		/** */Font& Create(FONT *f);
		/**
			Create a font from either the default font or an existing FONT or ALFONT_FONT.
			If you create a Font from and existing font, the font data doesn't get copied
			as you might expect but only a pointer is made!
		*/
		Font& Create(ALFONT_FONT *f);

		/** */Font& operator=(FONT *f);
		/** */Font& operator=(ALFONT_FONT *f);
		/**
			Assignment operators.
			These create a font from an existing font by making a pointer (not an actual copy!)
		*/
		Font& operator=(const Font &f);

		/**
			Attempts to load a new font from a disk file.
			If unsuccessull it sets itself to the default Allegro 8x8 font. The file can be
			in one of the following formats:
<pre>
      - bitmap font (either BMP, PCX, LBM or TGA)
      - BIOS 8x8 or 8x16 font (FNT)
      - GRX font (FNT)
      - scripted font (TXT)
      - Impulse Tracker 8x8 font (ITF)
      - any of the formats supported by AlFont (True Type, Type 1, etc.)
</pre>
		*/
		Error Load(const char *f);

		/**
			Destroys the font and sets it to the default Allegro 8x8 font.
		*/
		void Destroy();

		/**
			Reloads the font with the new size.
			This is only valid for scalable fonts such as truetype or type 1. By
			default these fonts are loaded with the height of 8 pixels.
		*/
		int SetSize(int h);

		/** */void Textout(Bitmap &bmp, const char *s, const Point &p, const Color &c, const Color &bg, int align) const;
		/** */void TextPrintf(Bitmap &bmp, const Point &p, const Color &c, const Color &bg, int align, const char *format, ...) const;
		/** */void Textout(Bitmap &bmp, const char *s, int x, int y, int c, int bg, int align) const;
		/**
			Wrappers for regular Allegro text output functions.
			They take the same argument list execpt for the font (obviously) and
			the align parameter. Align may be 0 for left alignment 1 for right
			alignment and 2 for centered text.
		*/
		void TextPrintf(Bitmap &bmp, int x, int y, int c, int bg, int align, const char *format, ...) const;

		/** */void GUITextout(Bitmap &bmp, const char *text, const Point &p, const Color &col1, const Color &col2, const Color &bg, int align) const;
		/** */void GUITextout(Bitmap &bmp, const char *text, int x, int y, int col1, int col2, int bg, int align) const;
		/** */int GUITextoutEx(Bitmap &bmp, const char *text, const Point &p, const Color &col1, const Color &col2, const Color &bg, int align) const;
		/**
			Special GUI text output.
			Same as the normal text output functions except that the second color
			is used as a text shadow. The functions appended with Ex also interpret
			the '&' character as an underscore and render the next character with a
			horizontal line below it and return the length in pixels of actually
			renderd text.
		*/
		int GUITextoutEx(Bitmap &bmp, const char *text, int x, int y, int col1, int col2, int bg, int align) const;

		/**
			Returns the length of the text as printed with GUITextoutEx().
		*/
		int GUITextLength(const char *text) const;

		/**
			Prints text word-wrapped on a column with a specified width but unspecified height.
			note: hal = horizontal alignment. Performs horizontal alignment but not vertical.
		*/
		void ColumnPrint(Bitmap &bmp, const char *text, int fg, int bg, int textMode, int x, int y, int w, int hal) const;

		/**
			Prints text word-wrapped in a box with specified width and height.
			Performs horizontal and vertical alignment.
		*/
		void BoxPrint(Bitmap &bmp, const char *text, int fg, int bg, int textMode, int x, int y, int w, int h, int hal, int val) const;

		/**
			Returns the height of the font.
		*/
		int TextHeight() const;

		/**
			Returns the length of the string in pixels.
		*/
		int TextLength(const char *str) const;

		/**
			Returns true if the font supports several fixed sizes.
			Only a few font formats support this.
		*/
		bool IsFixed() const;

		/**
			Returns true if the font is fully scalable.
			Only true-type fonts, type 1 fonts and some others are scalable.
		*/
		bool IsScalable() const;

		/**
			Returns an array of the fixed sizes that the font supports.
		*/
		const int *GetAvailableFixedSizes() const;

		/**
			Returns the number of fixed sizes the font supports.
		*/
		int GetNOfAvailableFixedSizes() const;

		/** */int GetSpacing() const;
		/**
			Functions for getting and setting the extra spacing between characters.
			Only some fonts support this (i.e. the ones that are loaded by AlFont).
		*/
		void SetSpacing(int s);

		/**
			Number of characters that fit on a line.
			Returns number of characters of the string text that fit on this line,
			while performing word-wrapping. Maxwidth is the width of this line.
			Preferredwidth is the actual width of that number of characters, so
			you can calculate the remaining space by substracting preferredwidth
			from maxwidth and align the text as you wish. Treats \n characters as
			hard (=forced) line breaks, so even if more characters fit on a line
			it always stops at a \n.
		*/
		int GetWrapPos(const char *text, int maxwidth, int &preferredwidth) const;

		/**
			Simple wrapper for when you don't need the preferredwidth parameter.
		*/
		int GetWrapPos(const char *text, int maxwidth) const;

		/**
			Returns number of whitespace at the start of text.
			Doesn't count \0 or \n as whitespace.
		*/
		int SkipWhiteSpace(const char *text) const;

		/**
			Counts number of lines needed to print text in an area with width = maxwidth.
			Empty string is 0 lines. Only whitespace is 1 line. Usefull for calculating
			the height of a textbox.
		*/
		int CountLines(const char *text, int maxwidth) const;
};
}

#endif		//MASKING_FONT
