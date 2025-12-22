@echo off


set MY_DEV_ROOT=d:\sdlpl
set INCLUDE=
set LIB=



Echo ** Adding settings for: VC++
Echo **
call D:\APPS\MSVC\VC98\BIN\VCVARS32.BAT


Echo ** Adding settings for: SDL_perl
Echo **
set INCLUDE=%INCLUDE%;%MY_DEV_ROOT%



Echo ** Adding settings for: SDL
Echo **
set SDL_HOME=%MY_DEV_ROOT%\sdl
set INCLUDE=%INCLUDE%;%SDL_HOME%\include
set LIB=%LIB%;%SDL_HOME%\lib
set PATH=%SDL_HOME%\dll;%PATH%




Echo ** Adding settings for: OpenGL (MS)
Echo **

set SDL_GL_VENDOR=MESA
set SDL_GL_HOME=%MY_DEV_ROOT%\mesa
rem set SDL_GL_HOME=%MY_DEV_ROOT%\opengl\ms

set INCLUDE=%INCLUDE%;%SDL_GL_HOME%\include
set INCLUDE=%INCLUDE%;%SDL_GL_HOME%\include\gl
set LIB=%LIB%;%SDL_GL_HOME%\lib
set PATH=%SDL_GL_HOME%\lib;%PATH%





Echo ** Adding settings for: SDL_gfx
Echo **
set SDLGFX_HOME=%MY_DEV_ROOT%\SDL_gfx
set INCLUDE=%INCLUDE%;%SDLGFX_HOME%
set LIB=%LIB%;%SDLGFX_HOME%
set PATH=%SDLGFX_HOME%;%PATH%



Echo ** Adding settings for: SDL_sound
Echo **
set SDLSOUND_HOME=%MY_DEV_ROOT%\SDL_sound
set INCLUDE=%INCLUDE%;%SDLSOUND_HOME%
set LIB=%LIB%;%SDLSOUND_HOME%\visualc\win32lib
set PATH=%SDLSOUND_HOME%\visualc\win32bin;%PATH%



Echo ** Adding settings for: SDL_console
Echo **
set SDLCONSOLE_HOME=%MY_DEV_ROOT%\sdl_console
set INCLUDE=%INCLUDE%;%SDLCONSOLE_HOME%\include
set LIB=%LIB%;%SDLCONSOLE_HOME%\lib



Echo ** Adding settings for: SMPEG
Echo **
set SMPEG_HOME=%MY_DEV_ROOT%\smpeg
set INCLUDE=%INCLUDE%;%SMPEG_HOME%\include
set LIB=%LIB%;%SMPEG_HOME%\lib
set PATH=%SMPEG_HOME%\dll;%PATH%


rem sorry, I (ab)use 98...
doskey
