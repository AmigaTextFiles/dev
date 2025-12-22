# Microsoft Developer Studio Project File - Name="VCconfig" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=VCconfig - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "VCconfig.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "VCconfig.mak" CFG="VCconfig - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "VCconfig - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "VCconfig - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "VCconfig - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../../build/Release"
# PROP Intermediate_Dir "../../build/Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /YX /FD /c
# ADD CPP /nologo /Zp4 /MD /W3 /Gi /GR /GX /O2 /Ob2 /I ".." /I "." /D "WIN32" /D "NDEBUG" /D "_MBCS" /D "_LIB" /YX /FD /c
# SUBTRACT CPP /Fr
# ADD BASE RSC /l 0x40b /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LIB32=link.exe -lib
# ADD BASE LIB32 /nologo
# ADD LIB32 /nologo

!ELSEIF  "$(CFG)" == "VCconfig - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../../build/Debug/"
# PROP Intermediate_Dir "../../build/Debug/"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /YX /FD /GZ /c
# ADD CPP /nologo /Zp4 /MDd /W3 /Gm /Gi /GR /GX /ZI /Od /I ".." /I "." /D "WIN32" /D "_DEBUG" /D "_MBCS" /D "_LIB" /FR /YX /FD /GZ /c
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

# Name "VCconfig - Win32 Release"
# Name "VCconfig - Win32 Debug"
# Begin Group "docs"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\doc_diary.h
# End Source File
# Begin Source File

SOURCE=..\doc_links.h
# End Source File
# Begin Source File

SOURCE=..\doc_mainpage.h
# End Source File
# Begin Source File

SOURCE=..\doc_plan.h
# End Source File
# Begin Source File

SOURCE=..\doc_program_flow.h
# End Source File
# End Group
# Begin Group "NonWin32"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\.cvsignore
# End Source File
# Begin Source File

SOURCE=..\acinclude.m4
# End Source File
# Begin Source File

SOURCE=..\autogen.sh
# End Source File
# Begin Source File

SOURCE=..\config.h.in
# End Source File
# Begin Source File

SOURCE=..\configure.in
# End Source File
# Begin Source File

SOURCE=..\distclean.sh
# End Source File
# Begin Source File

SOURCE=..\Doxyfile
# End Source File
# Begin Source File

SOURCE=..\..\fix.sh
# End Source File
# Begin Source File

SOURCE=..\footer.html
# End Source File
# Begin Source File

SOURCE=..\..\getdata.sh
# End Source File
# Begin Source File

SOURCE=..\Makefile.in
# End Source File
# End Group
# Begin Group "readme"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\..\AUTHORS
# End Source File
# Begin Source File

SOURCE=..\..\CHANGES
# End Source File
# Begin Source File

SOURCE=..\..\COPYING
# End Source File
# Begin Source File

SOURCE=..\..\GettingStarted.html
# End Source File
# Begin Source File

SOURCE=..\..\HISTORY
# End Source File
# Begin Source File

SOURCE=..\..\INSTALL
# End Source File
# Begin Source File

SOURCE=..\..\LICENSE.TXT
# End Source File
# Begin Source File

SOURCE=..\..\NEWS
# End Source File
# Begin Source File

SOURCE=..\..\README.TXT
# End Source File
# End Group
# Begin Source File

SOURCE=.\vcconfig.h

!IF  "$(CFG)" == "VCconfig - Win32 Release"

# Begin Custom Build
InputDir=.
WkspDir=.
InputPath=.\vcconfig.h

"$(WkspDir)\config.h" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	copy $(InputDir)\vcconfig.h $(WkspDir)\config.h

# End Custom Build

!ELSEIF  "$(CFG)" == "VCconfig - Win32 Debug"

# Begin Custom Build
InputDir=.
WkspDir=.
InputPath=.\vcconfig.h

"$(WkspDir)\config.h" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	copy $(InputDir)\vcconfig.h $(WkspDir)\config.h

# End Custom Build

!ENDIF 

# End Source File
# End Target
# End Project
