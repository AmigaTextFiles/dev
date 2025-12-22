# Microsoft Developer Studio Project File - Name="regcom" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=regcom - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "regcom.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "regcom.mak" CFG="regcom - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "regcom - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "regcom - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "regcom - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /FR /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /machine:I386
# ADD LINK32 sdl.lib sdlmain.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /machine:I386
# SUBTRACT LINK32 /nodefaultlib

!ELSEIF  "$(CFG)" == "regcom - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /MD /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 sdl.lib sdlmain.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "regcom - Win32 Release"
# Name "regcom - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\src\Button.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Console.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Cursor.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Desktop.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Font.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Fractal.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Game.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Hex.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Main.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Map.cpp
# End Source File
# Begin Source File

SOURCE=.\src\MapView.cpp
# End Source File
# Begin Source File

SOURCE=.\src\RadarView.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Rect.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Screen.cpp
# End Source File
# Begin Source File

SOURCE=.\src\ScrollView.cpp
# End Source File
# Begin Source File

SOURCE=.\src\StringView.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Surface.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Tile.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Unit.cpp
# End Source File
# Begin Source File

SOURCE=.\src\Window.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\src\Button.h
# End Source File
# Begin Source File

SOURCE=.\src\Console.h
# End Source File
# Begin Source File

SOURCE=.\src\Cursor.h
# End Source File
# Begin Source File

SOURCE=.\src\Desktop.h
# End Source File
# Begin Source File

SOURCE=.\src\Font.h
# End Source File
# Begin Source File

SOURCE=.\src\Fractal.h
# End Source File
# Begin Source File

SOURCE=.\src\Game.h
# End Source File
# Begin Source File

SOURCE=.\src\Hex.h
# End Source File
# Begin Source File

SOURCE=.\src\Map.h
# End Source File
# Begin Source File

SOURCE=.\src\MapView.h
# End Source File
# Begin Source File

SOURCE=.\src\Point.h
# End Source File
# Begin Source File

SOURCE=.\src\RadarView.h
# End Source File
# Begin Source File

SOURCE=.\src\Rect.h
# End Source File
# Begin Source File

SOURCE=.\src\Screen.h
# End Source File
# Begin Source File

SOURCE=.\src\ScrollView.h
# End Source File
# Begin Source File

SOURCE=.\src\StringView.h
# End Source File
# Begin Source File

SOURCE=.\src\Surface.h
# End Source File
# Begin Source File

SOURCE=.\src\Tile.h
# End Source File
# Begin Source File

SOURCE=.\src\Unit.h
# End Source File
# Begin Source File

SOURCE=.\src\Window.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# End Group
# End Target
# End Project
