# Microsoft Developer Studio Project File - Name="glElite" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=glElite - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "glElite.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "glElite.mak" CFG="glElite - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "glElite - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "glElite - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "glElite - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../../../../TeddyRelease"
# PROP Intermediate_Dir "../../build/Release/glElite"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /Zp4 /MD /W3 /Gi /GR /GX /O2 /Ob2 /I ".." /I "." /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /Fr /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x40b /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo /o"../../build/Release/glElite.bsc"
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib SDLmain.lib SDL.lib /nologo /subsystem:windows /incremental:yes /machine:I386
# SUBTRACT LINK32 /debug

!ELSEIF  "$(CFG)" == "glElite - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../../../../TeddyRelease"
# PROP Intermediate_Dir "../../build/Debug/glElite"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /Zp4 /MDd /W3 /Gm /Gi /GR /GX /ZI /Od /I ".." /I "." /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /FR"../build/Debug/" /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x40b /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo /o"../build/Debug/glElite.bsc"
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib SDLDmain.lib SDLD.lib /nologo /subsystem:windows /debug /machine:I386 /out:"../../../../TeddyRelease/glEliteD.exe" /pdbtype:sept

!ENDIF 

# Begin Target

# Name "glElite - Win32 Release"
# Name "glElite - Win32 Debug"
# Begin Group "PhysicalComponents"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Cabin.cpp
# End Source File
# Begin Source File

SOURCE=.\Cabin.h
# End Source File
# Begin Source File

SOURCE=.\Console.cpp
# End Source File
# Begin Source File

SOURCE=.\Console.h
# End Source File
# Begin Source File

SOURCE=.\ConsoleStream.cpp
# End Source File
# Begin Source File

SOURCE=.\ConsoleStream.h
# End Source File
# Begin Source File

SOURCE=.\ConsoleStreamBuffer.cpp
# End Source File
# Begin Source File

SOURCE=.\ConsoleStreamBuffer.h
# End Source File
# Begin Source File

SOURCE=.\FrontCamera.cpp
# End Source File
# Begin Source File

SOURCE=.\FrontCamera.h
# End Source File
# Begin Source File

SOURCE=.\Hud.cpp
# End Source File
# Begin Source File

SOURCE=.\Hud.h
# End Source File
# Begin Source File

SOURCE=.\Scanner.cpp
# End Source File
# Begin Source File

SOURCE=.\Scanner.h
# End Source File
# Begin Source File

SOURCE=.\Sight.cpp
# End Source File
# Begin Source File

SOURCE=.\Sight.h
# End Source File
# Begin Source File

SOURCE=.\uiPhysicalComponents.cpp
# End Source File
# End Group
# Begin Group "Objects"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\FrontierObjects.cpp
# End Source File
# Begin Source File

SOURCE=.\FrontierObjects.h
# End Source File
# Begin Source File

SOURCE=.\LightwaveObjects.cpp
# End Source File
# Begin Source File

SOURCE=.\LightwaveObjects.h
# End Source File
# Begin Source File

SOURCE=.\PlayerShip.cpp
# End Source File
# Begin Source File

SOURCE=.\PlayerShip.h
# End Source File
# Begin Source File

SOURCE=.\PrimitiveObjects.cpp
# End Source File
# Begin Source File

SOURCE=.\PrimitiveObjects.h
# End Source File
# Begin Source File

SOURCE=.\RoamObjects.cpp
# End Source File
# Begin Source File

SOURCE=.\RoamObjects.h
# End Source File
# Begin Source File

SOURCE=.\uiObjects.cpp
# End Source File
# End Group
# Begin Group "FFE"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\FrontierBitmap.cpp
# End Source File
# Begin Source File

SOURCE=.\FrontierBitmap.h
# End Source File
# Begin Source File

SOURCE=.\FrontierFile.cpp
# End Source File
# Begin Source File

SOURCE=.\FrontierFile.h
# End Source File
# Begin Source File

SOURCE=.\FrontierMesh.cpp
# End Source File
# Begin Source File

SOURCE=.\FrontierMesh.h
# End Source File
# End Group
# Begin Group "Ships"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\ComputerShip.cpp
# End Source File
# Begin Source File

SOURCE=.\ComputerShip.h
# End Source File
# Begin Source File

SOURCE=.\Ship.cpp
# End Source File
# Begin Source File

SOURCE=.\Ship.h
# End Source File
# Begin Source File

SOURCE=.\ShipCamera.cpp
# End Source File
# Begin Source File

SOURCE=.\ShipCamera.h
# End Source File
# Begin Source File

SOURCE=.\ShipControls.cpp
# End Source File
# Begin Source File

SOURCE=.\ShipType.cpp
# End Source File
# Begin Source File

SOURCE=.\ShipType.h
# End Source File
# End Group
# Begin Group "Simulation"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\CollisionGroup.cpp
# End Source File
# Begin Source File

SOURCE=.\CollisionGroup.h
# End Source File
# Begin Source File

SOURCE=.\CollisionInstance.cpp
# End Source File
# Begin Source File

SOURCE=.\CollisionInstance.h
# End Source File
# Begin Source File

SOURCE=.\Simulated.cpp
# End Source File
# Begin Source File

SOURCE=.\Simulated.h
# End Source File
# Begin Source File

SOURCE=.\SimulatedInstance.cpp
# End Source File
# Begin Source File

SOURCE=.\SimulatedInstance.h
# End Source File
# Begin Source File

SOURCE=.\SimulationTimer.cpp
# End Source File
# Begin Source File

SOURCE=.\SimulationTimer.h
# End Source File
# End Group
# Begin Group "ROAM"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\RoamAlgorithm.cpp
# End Source File
# Begin Source File

SOURCE=.\RoamAlgorithm.h
# End Source File
# Begin Source File

SOURCE=.\RoamInstance.cpp
# End Source File
# Begin Source File

SOURCE=.\RoamInstance.h
# End Source File
# Begin Source File

SOURCE=.\RoamSphere.cpp
# End Source File
# Begin Source File

SOURCE=.\RoamSphere.h
# End Source File
# Begin Source File

SOURCE=.\VertexArray.cpp
# End Source File
# Begin Source File

SOURCE=.\VertexArray.h
# End Source File
# End Group
# Begin Group "Win32"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\arch\win32\native_midi.h
# End Source File
# Begin Source File

SOURCE=..\arch\win32\native_midi_win32.c
# End Source File
# End Group
# Begin Source File

SOURCE=.\Action.cpp
# End Source File
# Begin Source File

SOURCE=.\Action.h
# End Source File
# Begin Source File

SOURCE=.\Atmosphere.cpp
# End Source File
# Begin Source File

SOURCE=.\Atmosphere.h
# End Source File
# Begin Source File

SOURCE=.\LogicalUI.cpp
# End Source File
# Begin Source File

SOURCE=.\LogicalUI.h
# End Source File
# Begin Source File

SOURCE=.\mod_application.h
# End Source File
# Begin Source File

SOURCE=.\teddy.cpp
# End Source File
# Begin Source File

SOURCE=.\ui.cpp
# End Source File
# Begin Source File

SOURCE=.\ui.h
# End Source File
# Begin Source File

SOURCE=.\uiActions.cpp
# End Source File
# Begin Source File

SOURCE=.\uiAudio.cpp
# End Source File
# Begin Source File

SOURCE=.\uiPreferences.cpp
# End Source File
# Begin Source File

SOURCE=.\uiUpdate.cpp
# End Source File
# Begin Source File

SOURCE=.\version.h
# End Source File
# End Target
# End Project
