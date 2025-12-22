# Microsoft Developer Studio Project File - Name="TinyGL" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=TinyGL - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "TinyGL.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "TinyGL.mak" CFG="TinyGL - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "TinyGL - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "TinyGL - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "TinyGL - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../../build/Release/TinyGL"
# PROP Intermediate_Dir "../../build/Release/TinyGL"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /YX /FD /c
# ADD CPP /nologo /Zp4 /MD /W3 /Gi /GR /GX /O2 /Ob2 /I ".." /I "." /D "_LIB" /D "NDEBUG" /D "_MBCS" /D "WIN32" /YX /FD /c
# SUBTRACT CPP /Z<none> /Fr
# ADD BASE RSC /l 0x40b /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "TinyGL - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../../build/Debug/TinyGL"
# PROP Intermediate_Dir "../../build/Debug/TinyGL"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /YX /FD /GZ /c
# ADD CPP /nologo /Zp4 /MDd /W3 /Gm /Gi /GR /GX /ZI /Od /I ".." /I "." /D "_MBCS" /D "_LIB" /D "_DEBUG" /D "WIN32" /FR /YX /FD /GZ /c
# ADD BASE RSC /l 0x40b /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ENDIF 

# Begin Target

# Name "TinyGL - Win32 Release"
# Name "TinyGL - Win32 Debug"
# Begin Group "Readme"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\LICENCE
# End Source File
# Begin Source File

SOURCE=.\LIMITATIONS
# End Source File
# Begin Source File

SOURCE=.\README
# End Source File
# Begin Source File

SOURCE=.\Readme.txt
# End Source File
# End Group
# Begin Source File

SOURCE=.\gl.h
# End Source File
# Begin Source File

SOURCE=.\gl_api.c
# End Source File
# Begin Source File

SOURCE=.\gl_arrays.c
# End Source File
# Begin Source File

SOURCE=.\gl_clear.c
# End Source File
# Begin Source File

SOURCE=.\gl_clip.c
# End Source File
# Begin Source File

SOURCE=.\gl_error.c
# End Source File
# Begin Source File

SOURCE=.\gl_get.c
# End Source File
# Begin Source File

SOURCE=.\gl_gl.h
# End Source File
# Begin Source File

SOURCE=.\gl_image_util.c
# End Source File
# Begin Source File

SOURCE=.\gl_init.c
# End Source File
# Begin Source File

SOURCE=.\gl_light.c
# End Source File
# Begin Source File

SOURCE=.\gl_list.c
# End Source File
# Begin Source File

SOURCE=.\gl_matrix.c
# End Source File
# Begin Source File

SOURCE=.\gl_misc.c
# End Source File
# Begin Source File

SOURCE=.\gl_msghandling.c
# End Source File
# Begin Source File

SOURCE=.\gl_msghandling.h
# End Source File
# Begin Source File

SOURCE=.\gl_opinfo.h
# End Source File
# Begin Source File

SOURCE=.\gl_oscontext.c
# End Source File
# Begin Source File

SOURCE=.\gl_oscontext.h
# End Source File
# Begin Source File

SOURCE=.\gl_sdlswgl.c
# End Source File
# Begin Source File

SOURCE=.\gl_sdlswgl.h
# End Source File
# Begin Source File

SOURCE=.\gl_select.c
# End Source File
# Begin Source File

SOURCE=.\gl_specbuf.h
# End Source File
# Begin Source File

SOURCE=.\gl_specbuffer.c
# End Source File
# Begin Source File

SOURCE=.\gl_texture.c
# End Source File
# Begin Source File

SOURCE=.\gl_vertex.c
# End Source File
# Begin Source File

SOURCE=.\gl_zbuffer.c
# End Source File
# Begin Source File

SOURCE=.\gl_zbuffer.h
# End Source File
# Begin Source File

SOURCE=.\gl_zdither.c
# End Source File
# Begin Source File

SOURCE=.\gl_zfeatures.h
# End Source File
# Begin Source File

SOURCE=.\gl_zgl.h
# End Source File
# Begin Source File

SOURCE=.\gl_zline.c
# End Source File
# Begin Source File

SOURCE=.\gl_zline.h
# End Source File
# Begin Source File

SOURCE=.\gl_zmath.c
# End Source File
# Begin Source File

SOURCE=.\gl_zmath.h
# End Source File
# Begin Source File

SOURCE=.\gl_ztriangle.c
# End Source File
# Begin Source File

SOURCE=.\gl_ztriangle.h
# End Source File
# End Target
# End Project
