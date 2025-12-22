# Microsoft Developer Studio Project File - Name="Imports" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=Imports - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "Imports.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Imports.mak" CFG="Imports - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Imports - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "Imports - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "Imports - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../../build/Release/Imports"
# PROP Intermediate_Dir "../../build/Release/Imports"
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

!ELSEIF  "$(CFG)" == "Imports - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../../build/Debug/Imports"
# PROP Intermediate_Dir "../../build/Debug/Imports"
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

# Name "Imports - Win32 Release"
# Name "Imports - Win32 Debug"
# Begin Group "SurfaceBlok"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\LWSurfaceBlok.cpp
# End Source File
# Begin Source File

SOURCE=.\LWSurfaceBlok.h
# End Source File
# Begin Source File

SOURCE=.\LWSurfaceBlokGradient.cpp
# End Source File
# Begin Source File

SOURCE=.\LWSurfaceBlokImageMap.cpp
# End Source File
# Begin Source File

SOURCE=.\LWSurfaceBlokProcedural.cpp
# End Source File
# Begin Source File

SOURCE=.\LWSurfaceBlokShader.cpp
# End Source File
# End Group
# Begin Source File

SOURCE=.\LWClip.cpp
# End Source File
# Begin Source File

SOURCE=.\LWClip.h
# End Source File
# Begin Source File

SOURCE=.\lwdef.h
# End Source File
# Begin Source File

SOURCE=.\LWEnvelope.cpp
# End Source File
# Begin Source File

SOURCE=.\LWEnvelope.h
# End Source File
# Begin Source File

SOURCE=.\LWEnvelopeKey.cpp
# End Source File
# Begin Source File

SOURCE=.\LWEnvelopeKey.h
# End Source File
# Begin Source File

SOURCE=.\LWFile.cpp
# End Source File
# Begin Source File

SOURCE=.\LWFile.h
# End Source File
# Begin Source File

SOURCE=.\LWLayer.cpp
# End Source File
# Begin Source File

SOURCE=.\LWLayer.h
# End Source File
# Begin Source File

SOURCE=.\LWMesh.cpp
# End Source File
# Begin Source File

SOURCE=.\LWMesh.h
# End Source File
# Begin Source File

SOURCE=.\LWSurface.cpp
# End Source File
# Begin Source File

SOURCE=.\LWSurface.h
# End Source File
# Begin Source File

SOURCE=.\LWTexture.cpp
# End Source File
# Begin Source File

SOURCE=.\LWTexture.h
# End Source File
# Begin Source File

SOURCE=.\mod_imports.h
# End Source File
# End Target
# End Project
