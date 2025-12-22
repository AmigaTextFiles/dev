#include <stdio.h>
#include "pict.h"

char* modeNames[5] = {
	"GRAY ","CMAP ","RGB16","RGB24","RGBA "
};
int main(int argc, char** argv)
{
	FILE*	f;
	PICT*	p;
	int	t,i,j;
	char	*name;
	uint8_t* buffer;

	buffer = (uint8_t*)malloc(2048);

	for (t=0; t<100; t++)
	{
	for (j=1; j<argc; j++)
	{
		name = argv[j];
		if (!pict_check_magic(name)) continue;

		f = fopen(name,"rb");
		p = pict_create();
		pict_read_start(p,f);
		/*
		printf("%s %1d %2d %5d %5dx%-5d %4dx%-4d %s\n",
				modeNames[pict_get_mode(p)],
				pict_get_channels(p),
				pict_get_channel_size(p),
				pict_get_palette_size(p),
				pict_get_width(p),pict_get_height(p),
				pict_get_hres(p),pict_get_hres(p),
				name);
				*/
	
		for (i=0; i<pict_get_height(p); i++)
			pict_read_row(p,buffer);
		pict_read_end(p);
		pict_destroy(&p);
		fclose(f);
	}
	}
	free(buffer);

	return 0;
}
