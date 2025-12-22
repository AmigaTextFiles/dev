

/*
 *  This function properly searches resident and disk fonts for the
 *  font.
 *
 */

#include <local/typedefs.h>

#include <local/xmisc.h>

extern struct Library *DiskfontBase;

FONT *
GetFont(name, size)
char *name;
short size;
{
    register FONT *font1;
    TA Ta;
    short libwasopen = (DiskfontBase != NULL);

    Ta.ta_Name	= (ubyte *)name;
    Ta.ta_YSize = size;
    Ta.ta_Style = 0;
    Ta.ta_Flags = 0;

    font1 = OpenFont(&Ta);
    if (font1 == NULL || font1->tf_YSize != Ta.ta_YSize) {
	register FONT *font2;

	if (openlibs(DISKFONT_LIB)) {
	    if (font2 = OpenDiskFont(&Ta)) {
		if (font1)
		    CloseFont(font1);
		font1 = font2;
	    }
	    if (!libwasopen)
		closelibs(DISKFONT_LIB);
	}
    }
    return(font1);
}

