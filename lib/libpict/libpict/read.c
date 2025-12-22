#include "pictP.h"
#include "io.h"
#include <sys/types.h>
#include <stdlib.h>

#define GRAY_TOL	2

static void pict_get_header(PICT *pict);
static void pict_read_pixmap_draw_info(PxDrawInfo*,PICT *pict);
static void pict_read_pixmap_pack_info(PxPackInfo*,PICT *pict);
static void pict_read_pixmap_info_9A(PICT *pict);
static void pict_read_pixmap_ctable_info(PxCTableInfo*,PICT *pict);
static void pict_read_pixmap_info_98(PICT *pict);
static short pict_unpack(uint8_t *dst,uint16_t size,FILE *fp);

void pict_read_start(PICT *pict,FILE *fp)
{
	pict->fp=fp;
	pict->pixtype = pict->mode = 0;
	pict->comp = 0;
	pict->csize = 0;
	pict->ncol = 0;
	pict->r = pict->g = pict->b = 0;
	pict->buffer = 0;
	pict->w = pict->h = 0;

	pict_get_header(pict);
}

void    pict_read_set_unpack(PICT *p,int flag)
{
	p->pack = flag;
}

static void pict_get_header(PICT *pict)
{
	FILE	*f;
	Header	hd;
	short	op;

	f = pict->fp;
	fseek(f,512,SEEK_SET);
	hd.size = pict_get_short(f);
	pict_log_short("size",hd.size);
	hd.frame = pict_get_rect(f);
	pict_log_rect("frame",hd.frame);
	hd.version = pict_get_int(f);
	pict_log_xint("version",hd.version);

	pict->w = hd.frame.right - hd.frame.left;
	pict->h = hd.frame.bottom - hd.frame.top;

	while ((op=pict_get_short(f))!=EOF)
	{
		switch(op)
		{
			case 0x0C00: /* HeaderOp */
				hd.hop.code = op;
				pict_get_int(f);
				hd.hop.hres = pict_get_fixed(f);
				pict_log_fixed("hop.hres",hd.hop.hres);
				hd.hop.vres = pict_get_fixed(f);
				pict_log_fixed("hop.vres",hd.hop.vres);
				hd.hop.bbox = pict_get_rect(f);
				pict_log_rect("hop.bbox",hd.hop.bbox);
				pict_get_int(f);
				break;
			case 0x0001: /* ClipOp */
				hd.clip.code = op;
				hd.clip.size = pict_get_short(f);
				hd.clip.frame = pict_get_rect(f);
				pict_log_rect("clip.frame",hd.clip.frame);
				break;
			case 0x0098:
				pict_read_pixmap_info_98(pict);
				return;
				/*break;*/
			case 0x009A:
				pict_read_pixmap_info_9A(pict);
				return;
				/*break;*/
		}
	}
}

int	pict_read_row(PICT *p,uint8_t *px)
{
	short	cnt;
	int		pnb,rnb;
	int		i;
	uint8_t *bidx,*pidx;
	int		reverse,prealpha,postalpha,step;

	cnt = (p->ctrsz>1 ? pict_get_short(p->fp) : getc(p->fp));

	if (p->pack==PICT_PACKING_ASIS)
	{
		pnb = pict_unpack(px,cnt,p->fp);
		return pnb;
	}
	pnb = pict_unpack(p->buffer,cnt,p->fp);
	reverse =	(p->pack==PICT_PACKING_BGR)||
				(p->pack==PICT_PACKING_ABGR)||
				(p->pack==PICT_PACKING_BGRA);
	prealpha =	(p->pack==PICT_PACKING_ARGB)||
				(p->pack==PICT_PACKING_ABGR);
	postalpha =	(p->pack==PICT_PACKING_RGBA)||
				(p->pack==PICT_PACKING_BGRA);
	step = 3+(prealpha||postalpha);
	rnb = step*p->w;
	switch (p->mode)
	{
		case PICT_MODE_GRAY:
		case PICT_MODE_CMAP:
			if (!reverse)
			{
				pidx=px;
				bidx=p->buffer; 
				for (i=0; i<p->w; i++,bidx++)
				{
					if (prealpha) *pidx++ = 0;
					*pidx++ = p->r[*bidx];
					*pidx++ = p->g[*bidx];
					*pidx++ = p->b[*bidx];
					if (postalpha) *pidx++ = 0;
				}
			}
			else
			{
				pidx=px;
				bidx=p->buffer; 
				for (i=0; i<p->w; i++,bidx++)
				{
					if (prealpha) *pidx++ = 0;
					*pidx++ = p->b[*bidx];
					*pidx++ = p->g[*bidx];
					*pidx++ = p->r[*bidx];
					if (postalpha) *pidx++ = 0;
				}
			}
			break;
		case PICT_MODE_RGB16:
			if (!reverse)
			{
				pidx=px;
				bidx=p->buffer; 
				for (i=0; i<p->w; i++,bidx+=2)
				{
					if (prealpha) *pidx++ = 0;
					*pidx++ = bidx[0];
					*pidx++ = bidx[1];
					*pidx++ = bidx[1];
					if (postalpha) *pidx++ = 0;
				}
			}
			else
			{
				pidx=px;
				bidx=p->buffer; 
				for (i=0; i<p->w; i++,bidx+=2)
				{
					if (prealpha) *pidx++ = 0;
					*pidx++ = bidx[1];
					*pidx++ = bidx[1];
					*pidx++ = bidx[0];
					if (postalpha) *pidx++ = 0;
				}
			}
			break;
		case PICT_MODE_RGB24:
			if (!reverse)
			{
				pidx=px;
				bidx=p->buffer; 
				if (prealpha)
				{
					for (i=0; i<p->w; i++) pidx[step*i] = 0;
					pidx++;
				}
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				if (postalpha)
				{
					for (i=0; i<p->w; i++) pidx[step*i] = 0;
					pidx++;
				}
			}
			else
			{
				pidx=px;
				if (prealpha)
				{
					for (i=0; i<p->w; i++) pidx[step*i] = 0;
					pidx++;
				}
				bidx=p->buffer+2*p->w; 
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				bidx=p->buffer+p->w; 
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				bidx=p->buffer; 
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				if (postalpha)
				{
					for (i=0; i<p->w; i++) pidx[step*i] = 0;
					pidx++;
				}
			}
			break;
		case PICT_MODE_RGBA:
			if (!reverse)
			{
				pidx=px;
				if (prealpha)
				{
					bidx=p->buffer; 
					for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
					pidx++;
				}
				bidx=p->buffer+p->w; 
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				if (postalpha)
				{
					bidx=p->buffer; 
					for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
					pidx++;
				}
			}
			else
			{
				pidx=px;
				if (prealpha)
				{
					bidx=p->buffer; 
					for (i=0; i<p->w; i++) pidx[step*i] = 0;
					pidx++;
				}
				bidx=p->buffer+3*p->w; 
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				bidx=p->buffer+2*p->w; 
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				bidx=p->buffer+p->w; 
				for (i=0; i<p->w; i++) pidx[step*i] = *bidx++;
				pidx++;
				if (postalpha)
				{
					bidx=p->buffer; 
					for (i=0; i<p->w; i++) pidx[step*i] = 0;
					pidx++;
				}
			}
			break;
	}

	return rnb;
}

void	pict_read_end(PICT *pict)
{
	if (pict->r) free(pict->r);
	if (pict->g) free(pict->g);
	if (pict->b) free(pict->b);
	if (pict->buffer) free(pict->buffer);
}

static void    pict_read_pixmap_pack_info(PxPackInfo* p,PICT *pict)
{
	FILE		*f;
	f = pict->fp;

	p->rowBytes = pict_get_short(f);
    p->rowBytes &= ~0x8000;
	pict_log_short("pack.rowbytes",p->rowBytes);
	p->bounds = pict_get_rect(f);
	pict_log_rect("pack.bounds",p->bounds);
	p->version = pict_get_short(f);
	p->type = pict_get_short(f);
	pict_log_xshort("pack.type",p->type);
	p->size = pict_get_int(f);
	pict_log_int("pack.size",p->size);
	p->hres = pict_get_fixed(f);
	pict_log_fixed("pack.hres",p->hres);
	p->vres = pict_get_fixed(f);
	pict_log_fixed("pack.vres",p->vres);
	p->pixelType = pict_get_short(f);
	p->pixelSize = pict_get_short(f);
	p->cmpCount = pict_get_short(f);
	pict_log_short("pack.cmpCount",p->cmpCount);
	p->cmpSize = pict_get_short(f);
	pict_log_short("pack.cmpSize",p->cmpSize);
	p->planeBytes = pict_get_int(f);
	p->pmTable = pict_get_int(f);
	p->pmReserved = pict_get_int(f);

	pict->w = p->bounds.right - p->bounds.left;
	pict->h = p->bounds.bottom - p->bounds.top;
	pict->hres = p->hres.i;
	pict->vres = p->vres.i;
    pict->rowbytes = p->rowBytes;
	pict->buffer = (uint8_t*)malloc(pict->rowbytes);
	pict->comp = p->cmpCount;
	pict->csize = p->cmpSize;
}

static void    pict_read_pixmap_draw_info(PxDrawInfo* di,PICT *pict)
{
	FILE		*f;
	f = pict->fp;

	di->src = pict_get_rect(f);
	di->dst = pict_get_rect(f);
	di->mode = pict_get_short(f);
}

static void pict_read_pixmap_info_9A(PICT *pict)
{
	FILE		*f;
	Pixmap9AOp	pinfo;
	int			i,idx;

	f = pict->fp;

	pinfo.opcode = 0x009A;
	pict->pixtype = 0x9A;

	pinfo.unk = pict_get_int(f);
	pict_read_pixmap_pack_info(&pinfo.pack,pict);
	pict_read_pixmap_draw_info(&pinfo.drawInfo,pict);

	pict->ncol = 0;
	pict->r = pict->g = pict->b = 0;

	switch(pict->comp)
	{
		case 4:
			pict->mode = PICT_MODE_RGBA;
			break;
		case 3:
			pict->mode = PICT_MODE_RGB24;
			break;
		case 2:
			pict->mode = PICT_MODE_RGB16;
			break;
		default:
			pict->mode = PICT_MODE_RGBA;
			fprintf(stderr,"Warning: RGB pict with %d comps\n",pict->comp);
	}

	pict->ctrsz = (pict->rowbytes <= 250 ? 1 : 2);
}

static void    pict_read_pixmap_ctable_info(PxCTableInfo* t,PICT *pict)
{
	FILE		*f;
	int			i;
	PxCTableEntry	ce;

	f = pict->fp;

	t->seed = pict_get_int(f);
	t->flags = pict_get_short(f);
	t->size = pict_get_short(f);
	pict_log_short("ctable.size",t->size);
	pict->ncol = t->size+1;
	pict->r = (uint8_t*)malloc(pict->ncol);
	pict->g = (uint8_t*)malloc(pict->ncol);
	pict->b = (uint8_t*)malloc(pict->ncol);

	for (i=0; i<pict->ncol; i++)
	{
		ce.idx = pict_get_short(f);
		ce.r = pict_get_short(f);
		ce.g = pict_get_short(f);
		ce.b = pict_get_short(f);
		/*
		pict_log_short("ctable.idx",ce.idx);
		pict_log_xshort("ctable.r",ce.r);
		pict_log_xshort("ctable.g",ce.g);
		pict_log_xshort("ctable.b",ce.b);
		*/
		pict->r[ce.idx] = ce.r>>8;
		pict->g[ce.idx] = ce.g>>8;
		pict->b[ce.idx] = ce.b>>8;
	}
}

static void pict_read_pixmap_info_98(PICT *pict)
{
	FILE	*f;
	Pixmap98Op	pinfo;
	int			i;

	f = pict->fp;

	pinfo.opcode = 0x0098;
	pict->pixtype = 0x98;

	pict_read_pixmap_pack_info(&pinfo.pack,pict);
	pict_read_pixmap_ctable_info(&pinfo.ctable,pict);
	pict_read_pixmap_draw_info(&pinfo.drawInfo,pict);

	pict->mode = PICT_MODE_GRAY;
	for (i=0; i<pict->ncol; i++)
	{
		if (abs(pict->r[i]-i)>GRAY_TOL) { pict->mode = PICT_MODE_CMAP; break; }
		if (abs(pict->g[i]-i)>GRAY_TOL) { pict->mode = PICT_MODE_CMAP; break; }
		if (abs(pict->b[i]-i)>GRAY_TOL) { pict->mode = PICT_MODE_CMAP; break; }
	}

	pict->ctrsz = (pict->rowbytes <= 250 ? 1 : 2);
}

static short pict_unpack(uint8_t *dst,uint16_t size,FILE *f)
{
    uint8_t	*u;
	int8_t	rlecode;
    int		left,rb;

    u=dst;
	for (left=size; left>0;)
    {
    	if (feof(f)) return u-dst;
        rlecode = getc(f);
		left--;
        if(rlecode>=0)
        {
			rb = fread(u,1,rlecode+1,f);
			u += rb;
			left -= rb;
        }
        else
        {
			rb = getc(f);
            for(;rlecode<=0;rlecode++) *u++ = rb;
			left--;
        }
    }

    return  u-dst;
}

