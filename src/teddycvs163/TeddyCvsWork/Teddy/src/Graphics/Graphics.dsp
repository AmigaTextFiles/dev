# Microsoft Developer Studio Project File - Name="Graphics" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=Graphics - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "Graphics.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Graphics.mak" CFG="Graphics - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Graphics - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "Graphics - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "Graphics - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../../build/Release/Graphics"
# PROP Intermediate_Dir "../../build/Release/Graphics"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /YX /FD /c
# ADD CPP /nologo /Zp4 /MD /W3 /Gi /GR /GX /O2 /Ob2 /I ".." /I "." /D "_LIB" /D "NDEBUG" /D "_MBCS" /D "WIN32" /YX /FD /c
# SUBTRACT CPP /Fr
# ADD BASE RSC /l 0x40b /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "Graphics - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../../build/Debug/Graphics"
# PROP Intermediate_Dir "../../build/Debug/Graphics"
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

# Name "Graphics - Win32 Release"
# Name "Graphics - Win32 Debug"
# Begin Group "SDL_GraphicsPrimitives"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\SDL_gfxPrimitives.cpp
# End Source File
# Begin Source File

SOURCE=.\SDL_gfxPrimitives.h
# End Source File
# Begin Source File

SOURCE=.\SDL_gfxPrimitives_font.h
# End Source File
# End Group
# Begin Group "glu"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\glu_mipmap.cpp
# End Source File
# Begin Source File

SOURCE=.\glu_mipmap.h
# End Source File
# End Group
# Begin Source File

SOURCE=.\Color.cpp
# End Source File
# Begin Source File

SOURCE=.\Color.h
# End Source File
# Begin Source File

SOURCE=.\Device.cpp
# End Source File
# Begin Source File

SOURCE=.\Device.h
# End Source File
# Begin Source File

SOURCE=.\Features.cpp
# End Source File
# Begin Source File

SOURCE=.\Features.h
# End Source File
# Begin Source File

SOURCE=.\Font.cpp
# End Source File
# Begin Source File

SOURCE=.\Font.h
# End Source File
# Begin Source File

SOURCE=.\mod_graphics.h
# End Source File
# Begin Source File

SOURCE=.\Texture.cpp
# End Source File
# Begin Source File

SOURCE=.\Texture.h
# End Source File
# Begin Source File

SOURCE=.\TextureConversions.cpp
# End Source File
# Begin Source File

SOURCE=.\View.cpp
# End Source File
# Begin Source File

SOURCE=.\View.h
# End Source File
# Begin Source File

SOURCE=.\ViewClient.cpp
# End Source File
# Begin Source File

SOURCE=.\ViewClient.h
# End Source File
# Begin Source File

SOURCE=.\ViewGL.cpp
# End Source File
# End Target
# End Project
