# Microsoft Developer Studio Project File - Name="PhysicalComponents" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=PhysicalComponents - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "PhysicalComponents.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "PhysicalComponents.mak" CFG="PhysicalComponents - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "PhysicalComponents - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "PhysicalComponents - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "PhysicalComponents - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../../build/Release/PhysicalComponents"
# PROP Intermediate_Dir "../../build/Release/PhysicalComponents"
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

!ELSEIF  "$(CFG)" == "PhysicalComponents - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../../build/Debug/PhysicalComponents"
# PROP Intermediate_Dir "../../build/Debug/PhysicalComponents"
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

# Name "PhysicalComponents - Win32 Release"
# Name "PhysicalComponents - Win32 Debug"
# Begin Group "Frames"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Frame.cpp
# End Source File
# Begin Source File

SOURCE=.\Frame.h
# End Source File
# Begin Source File

SOURCE=.\WindowFrame.cpp
# End Source File
# Begin Source File

SOURCE=.\WindowFrame.h
# End Source File
# End Group
# Begin Group "Fills"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Fill.cpp
# End Source File
# Begin Source File

SOURCE=.\Fill.h
# End Source File
# Begin Source File

SOURCE=.\GradientFill.cpp
# End Source File
# Begin Source File

SOURCE=.\GradientFill.h
# End Source File
# Begin Source File

SOURCE=.\TextureFill.cpp
# End Source File
# Begin Source File

SOURCE=.\TextureFill.h
# End Source File
# End Group
# Begin Group "Simple"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Button.cpp
# End Source File
# Begin Source File

SOURCE=.\Button.h
# End Source File
# Begin Source File

SOURCE=.\Label.cpp
# End Source File
# Begin Source File

SOURCE=.\Label.h
# End Source File
# End Group
# Begin Group "Docks"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Dock.cpp
# End Source File
# Begin Source File

SOURCE=.\Dock.h
# End Source File
# Begin Source File

SOURCE=.\HDock.cpp
# End Source File
# Begin Source File

SOURCE=.\HDock.h
# End Source File
# Begin Source File

SOURCE=.\HSplit.cpp
# End Source File
# Begin Source File

SOURCE=.\HSplit.h
# End Source File
# Begin Source File

SOURCE=.\VDock.cpp
# End Source File
# Begin Source File

SOURCE=.\VDock.h
# End Source File
# Begin Source File

SOURCE=.\VSplit.cpp
# End Source File
# Begin Source File

SOURCE=.\VSplit.h
# End Source File
# End Group
# Begin Group "Styles"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Style.cpp
# End Source File
# Begin Source File

SOURCE=.\Style.h
# End Source File
# End Group
# Begin Group "WindowManager"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Window.cpp
# End Source File
# Begin Source File

SOURCE=.\Window.h
# End Source File
# Begin Source File

SOURCE=.\WindowManager.cpp
# End Source File
# Begin Source File

SOURCE=.\WindowManager.h
# End Source File
# End Group
# Begin Group "Actions"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\ActionButton.cpp
# End Source File
# Begin Source File

SOURCE=.\ActionButton.h
# End Source File
# End Group
# Begin Group "Events"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\EventListener.cpp
# End Source File
# Begin Source File

SOURCE=.\EventListener.h
# End Source File
# End Group
# Begin Source File

SOURCE=.\Area.cpp
# End Source File
# Begin Source File

SOURCE=.\Area.h
# End Source File
# Begin Source File

SOURCE=.\Layer.cpp
# End Source File
# Begin Source File

SOURCE=.\Layer.h
# End Source File
# Begin Source File

SOURCE=.\LayoutConstraint.cpp
# End Source File
# Begin Source File

SOURCE=.\LayoutConstraint.h
# End Source File
# Begin Source File

SOURCE=.\mod_physical_components.h
# End Source File
# Begin Source File

SOURCE=.\Projection.cpp
# End Source File
# Begin Source File

SOURCE=.\Projection.h
# End Source File
# End Target
# End Project
