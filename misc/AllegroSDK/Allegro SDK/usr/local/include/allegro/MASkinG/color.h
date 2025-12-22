// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_COLOR_H
#define			MASKING_COLOR_H

#include "maskingdll.h"

namespace MAS {
/**
	Represents an Allegro color.
	It has methods for building colors out of RGB and HSV components and braking
	them down in those components again. There are unctions for converting
	between the RGB and HSV color spaces and for reading a color from a string.
	Also some of the most comonly used colors are available as static data members.
*/
class MASKING_DLL_DECLSPEC Color {
	protected:
		/**
			The underlying Allegro color value.
		*/
		int col;

	public:
		/**
			The default constructor.
			The constructor for making a color from an actual Allegro color value.
		*/
		Color(int c=-1);

		/**
			The constructor for making a color from RGB components.
			All three colours are integers in the range between 0 and 255.
		*/
		Color(int r, int g, int b);

		/**
			The constructors for making a color from HSV components.
			Hue is a value between 0 and 360, while saturation and value are
			between 0 and 1.
		*/
		Color(float h, float s, float v);

		/**
			The constructor for making a color from RGBA components.
			A is the alpha component and must be in the range between 0 and 255.
		*/
		Color(int r, int g, int b, int a);

		/**
			The constructor for making a color from a string description.
			The string must contain RGB components separated with commas or
			semicolons or it can be "-1".

			Examples of constructing a color:
<PRE>
      Color c1(makecol(120, 240, 180));
      Color c2(120, 240, 180);
      Color c3(300.0, 140.0, 45.0));
      Color c4(120, 240, 180, 200);
      Color c5("120,240,180");
</PRE>
		*/
		Color(const char *str);


		/**
			Makes the color from RGB components.
		*/
		void Make(int r, int g, int b);

		/**
			Makes the color from RGBA components.
		*/
		void Make(int r, int g, int b, int a);

		/**
			Read the color from a string.
		*/
		void Make(const char *str);


		/**
			Casts the color to an integer value.
			This allows you to use a Color as if it was an int. That means you can
			use objects of type Color in all Allegro functions that normally take
			int as a color parameter.

			Examples:
<pre>
      clear_to_color(screen, Color::white);
      rectfill(screen, 20, 30, 200, 150, Color(123, 234, 100));
</pre>
		*/
		operator int() const;

		/**
			Assignment operator for creating a color from an Allegro color value.
		*/
		void operator=(int c);

		/**
			Casts a color to a bool value.
			True if it's a valid color, false if it isn't (i.e. less than 0).

			Note: this doesn't work with 32 bit RGBA colors.
		*/
		operator bool() const;


		/**	*/ bool operator==(const Color c) { return col == c.col; }
		/**	*/ bool operator!=(const Color c) { return col != c.col; }
		/**	*/ bool operator==(int c) { return col == c; }
		/**
			Operators for determining the equality of two colours.
		*/
		bool operator!=(int c) { return col != c; }


		/**
			Returns the colour's R component.
		*/
		int r() const;

		/**
			Returns the colour's G component.
		*/
		int g() const;

		/**
			Returns the colour's B component.
		*/
		int b() const;

		/**
			Returns the colour's A component (alpha).
		*/
		int a() const;

		/**
			Sets the colour's R component.
		*/
		void r(int _r);

		/**
			Sets the colour's G component.
		*/
		void g(int _g);

		/**
			Sets the colour's B component.
		*/
		void b(int _b);

		/**
			Sets the colour's B component.
		*/
		void a(int _a);


		/**
			Breaks the colour down to HSV component.
		*/
		void ToHSV(float &h, float &s, float &v) const { rgb_to_hsv(r(), g(), b(), &h, &s, &v); }

		/**
			Breaks the colour down to RGB component.
		*/
		void ToRGB(int &r, int &g, int &b) const { r = getr(col); g = getg(col); b = getb(col); }

		/**
			Converts an RGB representation of a colour to HSV.
		*/
		static void RGBToHSV(int r, int g, int b, float &h, float &s, float &v) { rgb_to_hsv(r,g,b, &h,&s,&v); }

		/**
			Converts an HSV representation of a colour to RGB.
		*/
		static void HSVToRGB(float h, float s, float v, int &r, int &g, int &b) { hsv_to_rgb(h,s,v, &r,&g,&b); }

		/**
			Colorizes the color with the given second color and alpha intensity.
			Colorizing means that you take one color and shift its hue to the hue of
			a second color while leaving the saturation and lightness the same. Alpha
			intensity in this function is the balance between the source and the target
			colors and is a value between 0 and 255. At 0 the original color is not
			modified at all while at 255 the source color's hue is completely changed
			to the target color's hue.
		*/
		void Colorize(const Color &c, int alpha);


		/**	*/ static Color white;
		/**	*/ static Color black;
		/**	*/ static Color red;
		/**	*/ static Color green;
		/**	*/ static Color blue;
		/**	*/ static Color cyan;
		/**	*/ static Color magenta;
		/**	*/ static Color yellow;
		/**	*/ static Color darkgray;
		/**	*/ static Color gray;
		/**	*/ static Color lightgray;
		/**	*/ static Color orange;
		/**	*/ static Color purple;
		/**	*/ static Color brown;
		/**	*/ static Color maroon;
		/**	*/ static Color darkgreen;
		/**
			The most commonly used basic colours.
			Available as public static data members.
		*/
		static Color darkblue;

		/**
			Recreates the common colors.
			When the color depth has changed the static colours need to be
			recreated because the actual color values are dependant on the
			current color depth. This function is automatically called when
			a color depth change occurs.
		*/
		static void OnColorDepthChange();
};
}

#endif			//MASKING_COLOR_H
