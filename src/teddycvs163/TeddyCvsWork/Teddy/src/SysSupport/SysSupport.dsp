# Microsoft Developer Studio Project File - Name="SysSupport" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=SysSupport - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "SysSupport.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "SysSupport.mak" CFG="SysSupport - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "SysSupport - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "SysSupport - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "SysSupport - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../../build/Release/SysSupport"
# PROP Intermediate_Dir "../../build/Release/SysSupport"
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

!ELSEIF  "$(CFG)" == "SysSupport - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../../build/Debug/SysSupport"
# PROP Intermediate_Dir "../../build/Debug/SysSupport"
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

# Name "SysSupport - Win32 Release"
# Name "SysSupport - Win32 Debug"
# Begin Group "STL wrappers"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\StdList.cpp
# End Source File
# Begin Source File

SOURCE=.\StdList.h
# End Source File
# Begin Source File

SOURCE=.\StdMap.cpp
# End Source File
# Begin Source File

SOURCE=.\StdMap.h
# End Source File
# Begin Source File

SOURCE=.\StdStack.cpp
# End Source File
# Begin Source File

SOURCE=.\StdStack.h
# End Source File
# Begin Source File

SOURCE=.\StdString.cpp
# End Source File
# Begin Source File

SOURCE=.\StdString.h
# End Source File
# Begin Source File

SOURCE=.\StdVector.cpp
# End Source File
# Begin Source File

SOURCE=.\StdVector.h
# End Source File
# End Group
# Begin Source File

SOURCE=.\EndianIn.cpp
# End Source File
# Begin Source File

SOURCE=.\EndianIn.h
# End Source File
# Begin Source File

SOURCE=.\EndianIO.cpp
# End Source File
# Begin Source File

SOURCE=.\EndianIO.h
# End Source File
# Begin Source File

SOURCE=.\EndianOut.cpp
# End Source File
# Begin Source File

SOURCE=.\EndianOut.h
# End Source File
# Begin Source File

SOURCE=.\Exception.cpp
# End Source File
# Begin Source File

SOURCE=.\Exception.h
# End Source File
# Begin Source File

SOURCE=.\FileScan.cpp
# End Source File
# Begin Source File

SOURCE=.\FileScan.h
# End Source File
# Begin Source File

SOURCE=.\MemoryBlock.cpp
# End Source File
# Begin Source File

SOURCE=.\MemoryBlock.h
# End Source File
# Begin Source File

SOURCE=.\Messages.cpp
# End Source File
# Begin Source File

SOURCE=.\Messages.h
# End Source File
# Begin Source File

SOURCE=.\mod_sys_support.h
# End Source File
# Begin Source File

SOURCE=.\Timer.cpp
# End Source File
# Begin Source File

SOURCE=.\Timer.h
# End Source File
# Begin Source File

SOURCE=.\Types.h
# End Source File
# End Target
# End Project
