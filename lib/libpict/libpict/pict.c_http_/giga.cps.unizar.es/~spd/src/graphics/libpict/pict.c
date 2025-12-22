#include "pict.h"
#include "pictP.h"
#include <stdlib.h>

int pict_check_magic(char *name)
{
	FILE* f;
	if (!name) return 0;

	f = fopen(name,"rb");
	if (!f) return 0;
	fclose(f);

	return 0;
}

PICT* pict_create()
{
	PICT* p;
	p = (PICT*)malloc(sizeof(PICT));
	p->pack = 1;
	p->r = 0;
	p->g = 0;
	p->b = 0;
	p->buffer = 0;

	return p;
}

int pict_destroy(PICT** pp)
{
	free(*pp);
	*pp = 0;

	return 0;
}

int pict_get_width(PICT *pict)
{
	return pict->w;
}

int pict_get_height(PICT *pict)
{
	return pict->h;
}

int pict_get_hres(PICT *pict)
{
	return pict->hres;
}

int pict_get_vres(PICT *pict)
{
	return pict->vres;
}

int pict_get_mode(PICT *pict)
{
	return pict->mode;
}

int pict_get_channels(PICT *pict)
{
	return pict->comp;
}

int pict_get_channel_size(PICT *pict)
{
	return pict->csize;
}

int pict_get_palette_size(PICT *pict)
{
	return pict->ncol;
}

int pict_get_rowbytes(PICT *pict)
{
	return pict->rowbytes;
}

int pict_set_width(PICT *pict,int w)
{
	pict->w = w;

	return 0;
}

int pict_set_height(PICT *pict,int h)
{
	pict->h = h;

	return 0;
}

int pict_set_mode(PICT *pict,int m)
{
	pict->mode = m;

	return 0;
}

