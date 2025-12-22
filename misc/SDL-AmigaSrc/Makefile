# Makefile for gcc version of SDL

DEFINES= DEFINE=ENABLE_CYBERGRAPHICS DEFINE=inline=__inline DEFINE=ENABLE_AHI DEFINE=NO_SIGNAL_H
# DEFINE=HAVE_OPENGL
INCLUDES= IDIR=../include
CFLAGS = VERBOSE DEBUG=FULL CPU=68020 CODE=FAR DATA=NEAR
GCCFLAGS = -O2 -fomit-frame-pointer
GLFLAGS = -resident -DSHARED_LIB
# -DNO_AMIGADEBUG

#-I. -I../include -noixemul
GCCDEFINES = -DENABLE_CYBERGRAPHICS -DENABLE_AHI -DNO_SIGNAL_H

MOBJS =  SDL_error.mo SDL_fatal.mo SDL_RLEaccel.mo SDL_blit.mo SDL_blit_0.mo \
   SDL_blit_1.mo SDL_blit_A.mo SDL_blit_N.mo \
   SDL_bmp.mo SDL_cursor.mo SDL_pixels.mo SDL_surface.mo SDL_stretch.mo \
   SDL_yuv.mo SDL_yuv_sw.mo SDL_yuv_mmx.mo SDL_video.mo SDL_audio.mo \
   SDL_audiocvt.mo SDL_audiomem.mo SDL_mixer.mo SDL_wave.mo SDL_ahiaudio.mo \
   SDL_systimer.mo SDL_timer.mo SDL_joystick.mo \
   SDL_sysjoystick.mo SDL_cdrom.mo SDL_syscdrom.mo SDL_quit.mo SDL_active.mo \
   SDL_keyboard.mo SDL_mouse.mo SDL_resize.mo SDL_rwops.mo SDL_endian.mo SDL.mo \
   SDL_events.mo SDL_sysmutex.mo SDL_syssem.mo SDL_systhread.mo SDL_thread.mo \
   SDL_syscond.mo SDL_cgxvideo.mo SDL_cgxmodes.mo SDL_cgximage.mo SDL_amigaevents.mo \
   SDL_amigamouse.mo SDL_cgxgl.mo SDL_cgxwm.mo SDL_cgxyuv.mo SDL_cgxaccel.mo SDL_cgxgl_wrapper.mo \
   SDL_gamma.mo


OBJS = SDL_error.o SDL_fatal.o SDL_RLEaccel.o SDL_blit.o SDL_blit_0.o  \
   SDL_blit_1.o SDL_blit_A.o SDL_blit_N.o \
   SDL_bmp.o SDL_cursor.o SDL_pixels.o SDL_surface.o SDL_stretch.o \
   SDL_yuv.o SDL_yuv_sw.o SDL_yuv_mmx.o SDL_video.o SDL_audio.o \
   SDL_audiocvt.o SDL_audiomem.o SDL_mixer.o SDL_wave.o SDL_ahiaudio.o \
   SDL_systimer.o SDL_timer.o SDL_joystick.o \
   SDL_sysjoystick.o SDL_cdrom.o SDL_syscdrom.o SDL_quit.o SDL_active.o \
   SDL_keyboard.o SDL_mouse.o SDL_resize.o SDL_rwops.o SDL_endian.o SDL.o \
   SDL_events.o SDL_sysmutex.o SDL_syssem.o SDL_systhread.o SDL_thread.o \
   SDL_syscond.o SDL_cgxvideo.o SDL_cgxmodes.o SDL_cgximage.o SDL_amigaevents.o \
   SDL_amigamouse.o SDL_cgxgl.o SDL_cgxwm.o SDL_cgxyuv.o SDL_cgxaccel.o SDL_cgxgl_wrapper.o \
   SDL_gamma.o

GOBJS =  SDL_error.go SDL_fatal.go SDL_RLEaccel.go SDL_blit.go SDL_blit_0.go \
   SDL_blit_1.go SDL_blit_A.go SDL_blit_N.go \
   SDL_bmp.go SDL_cursor.go SDL_pixels.go SDL_surface.go SDL_stretch.go \
   SDL_yuv.go SDL_yuv_sw.go SDL_yuv_mmx.go SDL_video.go SDL_audio.go \
   SDL_audiocvt.go SDL_audiomem.go SDL_mixer.go SDL_wave.go SDL_ahiaudio.go \
   SDL_systimer.go SDL_timer.go SDL_joystick.go \
   SDL_sysjoystick.go SDL_cdrom.go SDL_syscdrom.go SDL_quit.go SDL_active.go \
   SDL_keyboard.go SDL_mouse.go SDL_resize.go SDL_rwops.go SDL_endian.go SDL.go \
   SDL_events.go SDL_sysmutex.go SDL_syssem.go SDL_systhread.go SDL_thread.go \
   SDL_syscond.go SDL_cgxvideo.go SDL_cgxmodes.go SDL_cgximage.go SDL_amigaevents.go \
   SDL_amigamouse.go SDL_cgxgl.go SDL_cgxwm.go SDL_cgxyuv.go SDL_cgxaccel.go SDL_cgxgl_wrapper.go \
   SDL_gamma.go SDL_lutstub.ll

LOBJS =  SDL_error.lo SDL_fatal.lo SDL_RLEaccel.lo SDL_blit.lo SDL_blit_0.lo \
   SDL_blit_1.lo SDL_blit_A.lo SDL_blit_N.lo \
   SDL_bmp.lo SDL_cursor.lo SDL_pixels.lo SDL_surface.lo SDL_stretch.lo \
   SDL_yuv.lo SDL_yuv_sw.lo SDL_yuv_mmx.lo SDL_video.lo SDL_audio.lo \
   SDL_audiocvt.lo SDL_audiomem.lo SDL_mixer.lo SDL_wave.lo SDL_ahiaudio.lo \
   SDL_systimer.lo SDL_timer.lo SDL_joystick.lo \
   SDL_sysjoystick.lo SDL_cdrom.lo SDL_syscdrom.lo SDL_quit.lo SDL_active.lo \
   SDL_keyboard.lo SDL_mouse.lo SDL_resize.lo SDL_rwops.lo SDL_endian.lo SDL.lo \
   SDL_events.lo SDL_sysmutex.lo SDL_syssem.lo SDL_systhread.lo SDL_thread.lo \
   SDL_syscond.lo SDL_cgxvideo.lo SDL_cgxmodes.lo SDL_cgximage.lo SDL_amigaevents.lo \
   SDL_amigamouse.lo SDL_cgxgl.lo SDL_cgxwm.lo SDL_cgxyuv.lo SDL_cgxaccel.lo SDL_cgxgl_wrapper.lo \
   SDL_gamma.lo SDL_amigastub.lo SDL_lutstubrel.ll

WOBJS =  SDL_error.wo SDL_fatal.wo SDL_RLEaccel.wo SDL_blit.wo SDL_blit_0.wo \
   SDL_blit_1.wo SDL_blit_A.wo SDL_blit_N.wo \
   SDL_bmp.wo SDL_cursor.wo SDL_pixels.wo SDL_surface.wo SDL_stretch.wo \
   SDL_yuv.wo SDL_yuv_sw.wo SDL_yuv_mmx.wo SDL_video.wo SDL_audio.wo \
   SDL_audiocvt.wo SDL_audiomem.wo SDL_mixer.wo SDL_wave.wo SDL_ahiaudio.wo \
   SDL_systimer.wo SDL_timer.wo SDL_joystick.wo \
   SDL_sysjoystick.wo SDL_cdrom.wo SDL_syscdrom.wo SDL_quit.wo SDL_active.wo \
   SDL_keyboard.wo SDL_mouse.wo SDL_resize.wo SDL_rwops.wo SDL_endian.wo SDL.wo \
   SDL_events.wo SDL_sysmutex.wo SDL_syssem.wo SDL_systhread.wo SDL_thread.wo \
   SDL_syscond.wo SDL_cgxvideo.wo SDL_cgxmodes.wo SDL_cgximage.wo SDL_amigaevents.wo \
   SDL_amigamouse.wo SDL_cgxgl.wo SDL_cgxwm.wo SDL_cgxyuv.wo SDL_cgxaccel.wo SDL_cgxgl_wrapper.wo \
   SDL_gamma.wo
   
%.go: %.c
	gcc $(GCCFLAGS) $(GCCDEFINES) -o $@ -c $*.c

%.lo: %.c
	gcc $(GCCFLAGS) $(GLFLAGS) $(GCCDEFINES) -o $@ -c $*.c

%.so: %.c
	sc $(CFLAGS) $(DEFINES) LIBCODE NOSTACKCHECK $(INCLUDES) OBJNAME $@  $*.c

%.ll: %.s
	as -m68010 -o $@ $*.s

%.mo: %.c
	ppc-morphos-gcc $(GCCFLAGS) $(GCCDEFINES) -Isf0:ggmorphos/os-include/ -DMORPHOS -o $@ -c $*.c

%.o: %.c
	SC $(CFLAGS) $(DEFINES) $(INCLUDES) $*.c

%.wo: %.c
	ppc-amigaos-gcc -warpup $(GCCFLAGS) $(GCCDEFINES) -DWARPOS -DNO_AMIGADEBUG -o $@ -c $*.c

all: SDL.library libSDL.a libSDLstub.a libSDL_mos.a SDL.lib 

libSDLstub.a: SDLstub.go
	ar cru libSDLstub.a SDLstub.go
	ranlib libSDLstub.a

SDL.lib: $(OBJS)
	-rm -f sdl.lib
	sc OBJLIB=SDL.lib $(OBJS) NODEBUG

SDL.library: $(LOBJS)
	gcc -v -s -resident -nostdlib gg:lib/libnix/libinitr.o $(LOBJS) gg:lib/gcc-lib/m68k-amigaos/2.95.3/libgcc.a gg:lib/libb/libnix/libnix.a  gg:lib/libb/libnix/libm.a -o $@ -ldebug

# gg:lib/libb/libnix/libnix.a gg:lib/libb/libnix/libstubs.a  gg:lib/libb/libnix/libm.a -o $@ -ldebug

#	slink to $@ LIBFD SDL.fd lib lib:sc.lib lib:scm.lib lib:debug.lib noicons libversion 1 librevision 2 smalldata stripdebug libprefix _LIB from lib:libent.o lib:libinitr.o $(OBJS) SDL_amigasas.so
#	gcc -v -fbaserel -nostartfiles -noixemul gg:lib/libnix/libinitr.o $(LOBJS) -o $@ -lm -ldebug
#	gcc -v -s -resident -nostdlib gg:lib/libnix/libinitr.o $(LOBJS) -o $@ -ldebug

libSDL.a: $(GOBJS)
	-rm -f libSDL.a
	ar cru libSDL.a $(GOBJS)
	ranlib libSDL.a

libSDL_mos.a: $(MOBJS)
	-rm -f libSDL_mos.a
	ppc-morphos-ar cru libSDL_mos.a $(MOBJS)
	ppc-morphos-ranlib libSDL_mos.a

libSDL_wos.a: $(WOBJS)
	-rm -f lib/libSDL_wos.a
	ppc-amigaos-ar cru libSDL_wos.a $(WOBJS)
	ppc-amigaos-ranlib libSDL_wos.a
 
clean:
	-rm -f *.o *.go *.lo *.mo *.ll *.wo *.so

