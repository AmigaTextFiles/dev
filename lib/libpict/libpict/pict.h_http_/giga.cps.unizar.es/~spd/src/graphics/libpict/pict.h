#ifndef PICT_H
#define PICT_H

#include <stdio.h>
#if !defined(WIN32) && !defined(_WIN32)
#include <inttypes.h>
#include <sys/types.h>
#else
typedef signed char			int8_t;
typedef unsigned char		uint8_t;
typedef short int			int16_t;
typedef unsigned short int	uint16_t;
typedef int					int32_t;
typedef unsigned int		uint32_t;
// <sys/types.h>
#include <sys/types.h>
typedef unsigned char   uchar_t;
typedef unsigned short  ushort_t;
typedef unsigned int    uint_t;
typedef unsigned long   ulong_t;
#endif

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#define PICT_MODE_GRAY      0
#define PICT_MODE_CMAP      1
#define PICT_MODE_RGB16     2
#define PICT_MODE_RGB24     3
#define PICT_MODE_RGBA      4

#define PICT_PACKING_ASIS	0
#define PICT_PACKING_RGB	1
#define PICT_PACKING_RGBA	2
#define PICT_PACKING_ARGB	3
#define PICT_PACKING_BGR	4
#define PICT_PACKING_ABGR	5
#define PICT_PACKING_BGRA	6

typedef struct PICT PICT;

int		pict_check_magic(char *);

PICT*	pict_create();
int		pict_destroy(PICT**);

int		pict_get_width(PICT *);
int		pict_get_height(PICT *);
int		pict_get_mode(PICT *);
int		pict_get_channels(PICT *);
int		pict_get_channel_size(PICT *);
int		pict_get_palette_size(PICT *);
int		pict_get_rowbytes(PICT *);
int		pict_get_hres(PICT *);
int		pict_get_vres(PICT *);
int		pict_set_width(PICT *,int);
int		pict_set_height(PICT *,int);
int		pict_set_mode(PICT *,int);

void	pict_read_set_unpack(PICT *,int);
void	pict_read_start(PICT *,FILE *);
int		pict_read_row(PICT *,uint8_t *);
void	pict_read_end(PICT *);

/*
void	pict_start_write(PICT *,FILE *);
void	pict_write_header(PICT *);
int		pict_write_line(PICT *,uint8_t*,int il,int skip);
void	pict_end_write(PICT *);
*/

#ifdef __cplusplus
}
#endif

#endif /* PICT_H */
