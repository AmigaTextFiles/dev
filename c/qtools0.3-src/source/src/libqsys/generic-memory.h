/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/*
 * ============================================================================
 * globals
 * ============================================================================
 */
#ifdef	MEM_SIZETRACK
extern int memcounter;
extern int mempeak;
#ifdef	MEM_ANALYSE
extern int memallocs;
extern int mempeakallocs;
#endif
#endif

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */
#undef	TMALLOC
#undef	TFREE
#undef	TSIZE
#undef	TREALLOC
#ifdef	MEM_SIZETRACK
void *tmalloc(register int size);
void tfree(register void *adr);
int tsize(register void *adr);
void *trealloc(register void *adr, register int newsize);
#else
#define tmalloc calloc
#define trealloc realloc
#define tfree free
#endif
#undef	KMALLOC
void *kmalloc(register int size);
#undef	KFREE
void kfree(register void);
#undef	SMALLOC
char *smalloc(register char *in);
#undef	SKMALLOC
char *skmalloc(register char *in);
