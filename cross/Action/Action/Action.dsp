# Microsoft Developer Studio Project File - Name="Action" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=Action - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "Action.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Action.mak" CFG="Action - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Action - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "Action - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "Action - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386

!ELSEIF  "$(CFG)" == "Action - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir ""
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "Action - Win32 Release"
# Name "Action - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\abstract.c
# End Source File
# Begin Source File

SOURCE=.\action.c
# End Source File
# Begin Source File

SOURCE=.\actionlexer.c
# End Source File
# Begin Source File

SOURCE=.\ASSORT.C
# End Source File
# Begin Source File

SOURCE=.\BINTOASC.C
# End Source File
# Begin Source File

SOURCE=.\codegen.c
# End Source File
# Begin Source File

SOURCE=.\DECL.C
# End Source File
# Begin Source File

SOURCE=.\ESC.C
# End Source File
# Begin Source File

SOURCE=.\gen.c
# End Source File
# Begin Source File

SOURCE=.\HASH.C
# End Source File
# Begin Source File

SOURCE=.\HASHPJW.C
# End Source File
# Begin Source File

SOURCE=.\main.c
# End Source File
# Begin Source File

SOURCE=.\misc.c
# End Source File
# Begin Source File

SOURCE=.\NODEMAN.C
# End Source File
# Begin Source File

SOURCE=.\NODEPROC.C
# End Source File
# Begin Source File

SOURCE=.\STOL.C
# End Source File
# Begin Source File

SOURCE=.\SYMTAB.C
# End Source File
# Begin Source File

SOURCE=.\Temp.c
# End Source File
# Begin Source File

SOURCE=.\VALUE.C
# End Source File
# Begin Source File

SOURCE=.\YYERROR.C
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\action.h
# End Source File
# Begin Source File

SOURCE=.\actionlexer.h
# End Source File
# Begin Source File

SOURCE=.\codegen.h
# End Source File
# Begin Source File

SOURCE=.\DECL.H
# End Source File
# Begin Source File

SOURCE=.\gen.h
# End Source File
# Begin Source File

SOURCE=.\HASH.H
# End Source File
# Begin Source File

SOURCE=.\LABEL.H
# End Source File
# Begin Source File

SOURCE=.\MISC.H
# End Source File
# Begin Source File

SOURCE=.\NODEID.H
# End Source File
# Begin Source File

SOURCE=.\NODEMAN.H
# End Source File
# Begin Source File

SOURCE=.\NODEPROC.H
# End Source File
# Begin Source File

SOURCE=.\SYMTAB.H
# End Source File
# Begin Source File

SOURCE=.\Temp.h
# End Source File
# Begin Source File

SOURCE=.\tokens.h
# End Source File
# Begin Source File

SOURCE=.\VALUE.H
# End Source File
# End Group
# Begin Group "PARSER"

# PROP Default_Filter "syn"
# Begin Source File

SOURCE=.\action.syn

!IF  "$(CFG)" == "Action - Win32 Release"

!ELSEIF  "$(CFG)" == "Action - Win32 Debug"

# PROP Ignore_Default_Tool 1
# Begin Custom Build
InputPath=.\action.syn

"action.c" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	d:\anagram\agcl $(InputPath)

# End Custom Build

!ENDIF 

# End Source File
# End Group
# Begin Group "TESTSRC"

# PROP Default_Filter "ACT"
# Begin Source File

SOURCE=.\example2.act
# End Source File
# Begin Source File

SOURCE=.\TEST1.ACT
# End Source File
# Begin Source File

SOURCE=.\TEST10.ACT
# End Source File
# Begin Source File

SOURCE=.\TEST11.ACT
# End Source File
# Begin Source File

SOURCE=.\TEST12.ACT
# End Source File
# Begin Source File

SOURCE=.\TEST13.ACT
# End Source File
# Begin Source File

SOURCE=.\test14.act
# End Source File
# Begin Source File

SOURCE=.\test15.act
# End Source File
# Begin Source File

SOURCE=.\TEST2.ACT
# End Source File
# Begin Source File

SOURCE=.\test21.act
# End Source File
# Begin Source File

SOURCE=.\TEST3.ACT
# End Source File
# Begin Source File

SOURCE=.\TEST4.ACT
# End Source File
# Begin Source File

SOURCE=.\TEST5.ACT
# End Source File
# Begin Source File

SOURCE=.\TEST6.ACT
# End Source File
# Begin Source File

SOURCE=.\TEST7.ACT
# End Source File
# Begin Source File

SOURCE=.\TEST8.ACT
# End Source File
# Begin Source File

SOURCE=.\TEST9.ACT
# End Source File
# End Group
# Begin Source File

SOURCE=.\output.txt
# End Source File
# End Target
# End Project
