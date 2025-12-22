#include "pictP.h"
#include "io.h"
#include <sys/types.h>

void pict_start_write(PICT *pict,FILE *fp)
{
	int	i;

	pict->fp=fp;
	pict->r = pict->g = pict->b = 0;
	switch(pict->mode)
	{
		case PICT_MODE_GRAY:
			pict->pixtype = 0x98;
			pict->comp = 1;
			pict->r = (pict_byte*)malloc(pict->ncol);
			pict->g = (pict_byte*)malloc(pict->ncol);
			pict->b = (pict_byte*)malloc(pict->ncol);
			for (i=0; i<pict->ncol; i++)
				pict->r[i] = pict->g[i] = pict->b[i] = i;
			break;
		case PICT_MODE_CMAP:
			pict->pixtype = 0x98;
			pict->comp = 1;
			pict->r = (pict_byte*)malloc(pict->ncol);
			pict->g = (pict_byte*)malloc(pict->ncol);
			pict->b = (pict_byte*)malloc(pict->ncol);
			break;
		case PICT_MODE_RGB16:
			pict->pixtype = 0x9A;
			pict->comp = 2;
			break;
		case PICT_MODE_RGB24:
			pict->pixtype = 0x9A;
			pict->comp = 3;
			break;
		case PICT_MODE_RGBA:
			pict->pixtype = 0x9A;
			pict->comp = 4;
			break;
	}
}

void pict_write_header(PICT *pict)
{
	int			i;
	PICTHeader	header;

	for (i=0; i<512; i++) header.info[i] = 0;

	/*
	strcpy(header.info,SCCSlibpict);
	*/
	strcpy(header.info,"PICT");
	header.size = 0x0000;
	header.frame.top = 0;
	header.frame.bottom = pict->h;
	header.frame.left = 0;
	header.frame.right = pict->w;
	header.version[0] = 0x0011;
	header.version[1] = 0x02FF;
	header.header.opcode = 0x0C00;
	header.header.unk1 = 0xFFFE0000;
	header.header.hres.i = 0x48;
	header.header.hres.f = 0x00;
	header.header.vres.i = 0x48;
	header.header.vres.f = 0x00;
	header.header.bbox.top = 0;
	header.header.bbox.bottom = pict->h;
	header.header.bbox.left = 0;
	header.header.bbox.right = pict->w;
	header.header.unk2 = 0;
	header.clip.opcode = 0x0001;
	header.clip.size = 0x000A;
	header.clip.frame.top = 0;
	header.clip.frame.bottom = pict->h;
	header.clip.frame.left = 0;
	header.clip.frame.right = pict->w;

	fwrite(header.info,1,512,pict->fp);
	pict_write_ushort(header.size,pict->fp);
	pict_write_qdrect(&(header.frame),pict->fp);
	pict_write_ushort(header.version[0],pict->fp);
	pict_write_ushort(header.version[1],pict->fp);
	pict_write_ushort(header.header.opcode,pict->fp);
	pict_write_uint(header.header.unk1,pict->fp);
	pict_write_fixed(&(header.header.hres),pict->fp);
	pict_write_fixed(&(header.header.vres),pict->fp);
	pict_write_qdrect(&(header.header.bbox),pict->fp);
	pict_write_uint(header.header.unk2,pict->fp);
	pict_write_ushort(header.clip.opcode,pict->fp);
	pict_write_ushort(header.clip.size,pict->fp);
	pict_write_qdrect(&(header.clip.frame),pict->fp);

	switch(pict->pixtype)
	{
		case 0x98: /* Colormap */
			pict_write_pixmap_info_98(pict);
			break;
		case 0x9A: /* RGB */
			pict_write_pixmap_info_9A(pict);
			break;
	}
/*	fprintf(stderr,"HEND: 0x%0.8x\n",ftell(pict->fp)); */
}

int	pict_write_line(PICT *pict,uint8_t *pixels,int il,int extraskip)
{
	pict_byte	hi,lo;
	int		npacked,i,j;
	pict_byte	*packed,*unpacked,*src,*dst;
	int		skip;

#ifdef HAS_ALLOCA
	unpacked = alloca(pict->w);
	packed = alloca(8*pict->w);
#else
	unpacked = malloc(pict->w);
	packed = malloc(8*pict->w);
#endif

	if (pict->comp<3)
	{
		src = pixels;
		dst = unpacked;
		skip = pict->comp+extraskip;
		for (j=0; j<pict->w; j++,src+=skip) *dst++ = *src;
		npacked = pict_pack(pixels,pict->w*pict->comp,packed);
		packed[npacked++] = 0;
		packed[npacked++] = 0;
	}
	else
	{
		/*
		 * Estado de los datos:
			para aaaa/rrrr/gggg/bbbb/... (normal,il==0)
				shift = pict->w
				stride = 1
			para rgba/rgba/rgba/rgba/... (interleaved, il==1)
				shift = 1
				stride = comp
		*/
		if (il)
		{
			skip = pict->comp+extraskip;
			npacked = 0;
			if (pict->comp==4)
			{
				/* A */
				src = pixels + 3;
				dst = unpacked;
				for (j=0; j<pict->w; j++,src+=skip) *dst++ = *src;
				npacked += pict_pack(unpacked,pict->w,packed+npacked);
			}
			/* R */
			src = pixels + 0;
			dst = unpacked;
			for (j=0; j<pict->w; j++,src+=skip) *dst++ = *src;
			npacked += pict_pack(unpacked,pict->w,packed+npacked);
			/* G */
			src = pixels + 1;
			dst = unpacked;
			for (j=0; j<pict->w; j++,src+=skip) *dst++ = *src;
			npacked += pict_pack(unpacked,pict->w,packed+npacked);
			/* B */
			src = pixels + 2;
			dst = unpacked;
			for (j=0; j<pict->w; j++,src+=skip) *dst++ = *src;
			npacked += pict_pack(unpacked,pict->w,packed+npacked);
		}
		else
		{
			skip = pict->w+extraskip;
			npacked = 0;
			if (pict->comp==4)
			{
				/* A */
				unpacked = pixels + 3*skip;
				npacked += pict_pack(unpacked,pict->w,packed+npacked);
			}
			/* R */
			unpacked = pixels + 0;
			npacked += pict_pack(unpacked,pict->w,packed+npacked);
			/* G */
			unpacked = pixels + skip;
			npacked += pict_pack(unpacked,pict->w,packed+npacked);
			/* B */
			unpacked = pixels + 2*skip;
			npacked += pict_pack(unpacked,pict->w,packed+npacked);
		}
	}

	if (pict->ctrsz==WORD)
	{
		hi = npacked/256;
		fwrite(&hi,1,1,pict->fp);
	}
	lo = npacked%256;
	fwrite(&lo,1,1,pict->fp);
	fwrite(packed,1,npacked,pict->fp);
/*	fprintf(stderr,"%d %x %x\n",pict->ctrsz,hi,lo); */

#ifndef HAS_ALLOCA
	free(packed);
	free(unpacked);
#endif

	return npacked;
}

void	pict_end_write(PICT *pict)
{
	int	pos;

	if (pict->r) free(pict->r);
	if (pict->g) free(pict->g);
	if (pict->b) free(pict->b);

	pos = ftell(pict->fp);
	if (pos%2) fputc(0x00,pict->fp);
	pict_write_ushort(EOP,pict->fp);
}

pict_ushort pict_pack(pict_byte *unpacked,pict_ushort usz,pict_byte *packed)
{
	int		i;
	pict_byte	*u,*p,*lastu;
	pict_char	*cf;
	int		flgz;
	pict_ushort	psz;

	lastu=unpacked+usz;
	psz=0;
	p=packed;
	for (u=unpacked; u<lastu;)
	{
        cf=(pict_char *)(p++);
        *cf=0;
        *p=*u++;

        for(;u<lastu;u++)
        {
            flgz = (*u == *p);
            if( (*cf == -127) || ((*cf==127) && !flgz) )
            {
/*				fprintf(stderr,"b %d\n",*cf); */
                /* Nuevo bloque */
				cf=(pict_char *)++p;
                (*cf) = 0;
                *(++p)=*u;
            }
            else
            {
                if(flgz) /* Mas de bloque rep */
                {
                    (*cf)--;
                    if(*cf>=0) /* camb. nuevo rep */
                    {
						cf=(pict_char *)p;
                        (*cf)=-1;
                        *(++p)=*u;
                    }
                }
                else
                {
                    if(*cf>=0) /* Mas de bloque no rep */
                        (*cf)++;
                    else    /* Nuevo bloque tipo ? */
                    {
/*						fprintf(stderr,"b %d\n",*cf); */
						cf=(pict_char *)++p;
                        (*cf)=0;
                    }

                    *(++p)=*u;
                }
            }
        }

        p++;
    }

	psz = p-packed;
/*	fprintf(stderr,"%d\n",psz); */

    return psz;
}

void pict_write_pixmap_info_98(PICT *pict)
{
	Pixmap98Op	pinfo;
	int			i,idx;
	PICTColorEntry	ce;

	pinfo.opcode = 0x0098;
	pict->rowbyte = pict->w + (pict->w%2);
	pinfo.rowBytes = pict->rowbyte | 0x8000;

	pict->ctrsz = (pict->rowbyte <= 250 ? BYTE : WORD);

	pinfo.bounds.top = 0;
	pinfo.bounds.bottom = pict->h;
	pinfo.bounds.left = 0;
	pinfo.bounds.right = pict->w;
	pinfo.version = 0x0000;
	pinfo.packType = 0x0000;
	pinfo.packSize = 0x00000000;
	pinfo.hres.i = 0x48;
	pinfo.hres.f = 0x00;
	pinfo.vres.i = 0x48;
	pinfo.vres.f = 0x00;
	pinfo.pixelType = 0x0000;
	pinfo.pixelSize = 8;
	pinfo.cmpCount = 1;
	pinfo.cmpSize = 8;
	pinfo.planeBytes = 0x00000000;
	pinfo.pmTable = 0x00000000;
	pinfo.pmReserved = 0x00000000;

	pict_write_ushort(pinfo.opcode,pict->fp);
	pict_write_ushort(pinfo.rowBytes,pict->fp);
	pict_write_qdrect(&pinfo.bounds,pict->fp);
	pict_write_ushort(pinfo.version,pict->fp);
	pict_write_ushort(pinfo.packType,pict->fp);
	pict_write_uint(pinfo.packSize,pict->fp);
	pict_write_fixed(&pinfo.hres,pict->fp);
	pict_write_fixed(&pinfo.vres,pict->fp);
	pict_write_ushort(pinfo.pixelType,pict->fp);
	pict_write_ushort(pinfo.pixelSize,pict->fp);
	pict_write_ushort(pinfo.cmpCount,pict->fp);
	pict_write_ushort(pinfo.cmpSize,pict->fp);
	pict_write_uint(pinfo.planeBytes,pict->fp);
	pict_write_uint(pinfo.pmTable,pict->fp);
	pict_write_uint(pinfo.pmReserved,pict->fp);

	pinfo.colorTable.seed = 0x00000000;
	pinfo.colorTable.flags = 0x0000;
	pinfo.colorTable.size = pict->ncol-1;
	pict_write_uint(pinfo.colorTable.seed,pict->fp);
	pict_write_ushort(pinfo.colorTable.flags,pict->fp);
	pict_write_ushort(pinfo.colorTable.size,pict->fp);
	for (i=0; i<pict->ncol; i++)
	{
		ce.index = i;
		ce.comp[0] = ce.comp[1] = pict->r[i];
		ce.comp[2] = ce.comp[3] = pict->g[i];
		ce.comp[4] = ce.comp[5] = pict->b[i];
		pict_write_ushort(ce.index,pict->fp);
		fwrite(ce.comp,6,1,pict->fp);
	}

	pinfo.srcRect.top = 0;
	pinfo.srcRect.bottom = pict->h;
	pinfo.srcRect.left = 0;
	pinfo.srcRect.right = pict->w;
	pinfo.dstRect.top = 0;
	pinfo.dstRect.bottom = pict->h;
	pinfo.dstRect.left = 0;
	pinfo.dstRect.right = pict->w;
	pinfo.mode = 0x0000;
	pict_write_qdrect(&pinfo.srcRect,pict->fp);
	pict_write_qdrect(&pinfo.dstRect,pict->fp);
	pict_write_ushort(pinfo.mode,pict->fp);
}

void pict_write_pixmap_info_9A(PICT *pict)
{
	Pixmap9AOp	pinfo;
	int			i,idx;

	pinfo.opcode = 0x009A;
	pinfo.unused = 0x000000FF;

	pinfo.bounds.top = 0;
	pinfo.bounds.bottom = pict->h;
	pinfo.bounds.left = 0;
	pinfo.bounds.right = pict->w;
	pinfo.version = 0x0000;
	pinfo.cmpCount = pict->comp;
	switch(pict->comp)
	{
		case 4:
			pinfo.packType = 4;
			pinfo.packSize = 0x00000000;
			pinfo.pixelType = 0x0010;
			pinfo.pixelSize = 32;
			pinfo.cmpSize = 8;
			break;
		case 3:
			pinfo.packType = 4;
			pinfo.packSize = 0x00000000;
			pinfo.pixelType = 0x0010;
			pinfo.pixelSize = 32;
			pinfo.cmpSize = 8;
			break;
		case 2:
			fprintf(stderr,"Error: 16bit RGB not implemented");
			exit(1);
		default:
			fprintf(stderr,"Error: wrong component count");
			exit(1);
	}

	pict->rowbyte = (pinfo.pixelSize*pict->w)/8;
	pinfo.rowBytes = pict->rowbyte |= 0x8000;
	pict->ctrsz = (pict->rowbyte <= 250 ? BYTE : WORD);

	pinfo.hres.i = 0x48;
	pinfo.hres.f = 0x00;
	pinfo.vres.i = 0x48;
	pinfo.vres.f = 0x00;
	pinfo.planeBytes = 0x00000000;
	pinfo.pmTable = 0x00000000;
	pinfo.pmReserved = 0x00000000;
	pinfo.srcRect.top = 0;
	pinfo.srcRect.bottom = pict->h;
	pinfo.srcRect.left = 0;
	pinfo.srcRect.right = pict->w;
	pinfo.dstRect.top = 0;
	pinfo.dstRect.bottom = pict->h;
	pinfo.dstRect.left = 0;
	pinfo.dstRect.right = pict->w;
	pinfo.mode = 0x0040;

	pict_write_ushort(pinfo.opcode,pict->fp);
	pict_write_uint(pinfo.unused,pict->fp);
	pict_write_ushort(pinfo.rowBytes,pict->fp);
	pict_write_qdrect(&pinfo.bounds,pict->fp);
	pict_write_ushort(pinfo.version,pict->fp);
	pict_write_ushort(pinfo.packType,pict->fp);
	pict_write_uint(pinfo.packSize,pict->fp);
	pict_write_fixed(&pinfo.hres,pict->fp);
	pict_write_fixed(&pinfo.vres,pict->fp);
	pict_write_ushort(pinfo.pixelType,pict->fp);
	pict_write_ushort(pinfo.pixelSize,pict->fp);
	pict_write_ushort(pinfo.cmpCount,pict->fp);
	pict_write_ushort(pinfo.cmpSize,pict->fp);
	pict_write_uint(pinfo.planeBytes,pict->fp);
	pict_write_uint(pinfo.pmTable,pict->fp);
	pict_write_uint(pinfo.pmReserved,pict->fp);
	pict_write_qdrect(&pinfo.srcRect,pict->fp);
	pict_write_qdrect(&pinfo.dstRect,pict->fp);
	pict_write_ushort(pinfo.mode,pict->fp);
}

void pict_write_ushort(pict_ushort w,FILE *fp)
{
	pict_byte	hl[2];

	hl[0] = w/256; hl[1] = w%256;
	fwrite(hl,1,2,fp);
}

void pict_write_uint(pict_uint l,FILE *fp)
{
	pict_ushort	hi,lo;
	pict_byte	hl[4];

	hi = l/65536; lo = l%65536;
	hl[0] = hi/256; hl[1] = hi%256;
	hl[2] = lo/256; hl[3] = lo%256;
	fwrite(hl,1,4,fp);
}

void pict_write_fixed(pict_fixed *f,FILE *fp)
{
	pict_write_ushort(f->i,fp);
	pict_write_ushort(f->f,fp);
}

void pict_write_qdrect(QDRect *r,FILE *fp)
{
	pict_write_ushort(r->top,fp);
	pict_write_ushort(r->left,fp);
	pict_write_ushort(r->bottom,fp);
	pict_write_ushort(r->right,fp);
}

