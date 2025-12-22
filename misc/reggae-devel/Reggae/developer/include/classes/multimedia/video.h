/* 
$VER: video.h 51.3 (4.2.2007)
*/

/* video objects methods and attributes */

#ifndef CLASSES_MULTIMEDIA_VIDEO_H
#define CLASSES_MULTIMEDIA_VIDEO_H

#include <classes/multimedia/multimedia.h>

/* formats */

#define MMF_VIDEOMASK            0x00002000
#define MMF_VIDEOBIT             13

#define MMF_VIDEO_BMP            (MMF_VIDEOMASK + 1)
#define MMF_VIDEO_PNG            (MMF_VIDEOMASK + 2)	/* PNG zlib stream */
#define MMF_VIDEO_BITPLANES      (MMF_VIDEOMASK + 3)  /* bitplanes */
#define MMF_VIDEO_GRAY8          (MMF_VIDEOMASK + 4)  /* raw 8-bit grayscale */
#define MMF_VIDEO_GRAY16BE       (MMF_VIDEOMASK + 5)  /* raw 16-bit grayscale, big endian */
#define MMF_VIDEO_RGB24          (MMF_VIDEOMASK + 6)  /* raw RGB, 8 bits per gun */
#define MMF_VIDEO_RGB48BE        (MMF_VIDEOMASK + 7)  /* raw RGB, 16 bits per gun, big endian */
#define MMF_VIDEO_GIF            (MMF_VIDEOMASK + 8)  /* GIF compressed stream */

#define MMF_MAXFORMAT            0x00002FFF

/* methods */

/* attributes */

#define MMA_Video_Width               (MMA_Dummy + 400)
#define MMA_Video_Height              (MMA_Dummy + 401)
#define MMA_Video_BitsPerPixel        (MMA_Dummy + 402)
#define MMA_Video_FrameCount          (MMA_Dummy + 403)
#define MMA_Video_SrcOffsetX          (MMA_Dummy + 404)
#define MMA_Video_SrcOffsetY          (MMA_Dummy + 405)
#define MMA_Video_RastPort            (MMA_Dummy + 406)
#define MMA_Video_DestOffsetX         (MMA_Dummy + 407)
#define MMA_Video_DestOffsetY         (MMA_Dummy + 408)
#define MMA_Video_UseAlpha            (MMA_Dummy + 409)
#define MMA_Video_GlobalAlpha         (MMA_Dummy + 410)
#define MMA_Video_Progressive         (MMA_Dummy + 411)
#define MMA_Video_FinalTouch          (MMA_Dummy + 412)
#define MMA_Video_Palette             (MMA_Dummy + 413)
#define MMA_Video_GammaCorrection     (MMA_Dummy + 414)

/* Mask data right after image (used by bmp.decoder) */

#define MMA_Video_MaskAfterImage      (MMA_Dummy + 499)

/* Bytes per line (modulo) used by bitplane.decoder. */

#define MMA_Video_BytesPerLine        (MMA_Dummy + 498)

#endif /* CLASSES_MULTIMEDIA_PICTURE_H */
