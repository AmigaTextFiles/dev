# Microsoft Developer Studio Project File - Name="Models" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Static Library" 0x0104

CFG=Models - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "Models.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Models.mak" CFG="Models - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Models - Win32 Release" (based on "Win32 (x86) Static Library")
!MESSAGE "Models - Win32 Debug" (based on "Win32 (x86) Static Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "Models - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../../build/Release/Models"
# PROP Intermediate_Dir "../../build/Release/Models"
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

!ELSEIF  "$(CFG)" == "Models - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../../build/Debug/Models"
# PROP Intermediate_Dir "../../build/Debug/Models"
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

# Name "Models - Win32 Release"
# Name "Models - Win32 Debug"
# Begin Group "Elements"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Element.cpp
# End Source File
# Begin Source File

SOURCE=.\Element.h
# End Source File
# Begin Source File

SOURCE=.\Face.cpp
# End Source File
# Begin Source File

SOURCE=.\Face.h
# End Source File
# Begin Source File

SOURCE=.\Line.cpp
# End Source File
# Begin Source File

SOURCE=.\Line.h
# End Source File
# Begin Source File

SOURCE=.\QuadStrip.cpp
# End Source File
# Begin Source File

SOURCE=.\QuadStrip.h
# End Source File
# Begin Source File

SOURCE=.\TriangleFan.cpp
# End Source File
# Begin Source File

SOURCE=.\TriangleFan.h
# End Source File
# Begin Source File

SOURCE=.\Vertex.cpp
# End Source File
# Begin Source File

SOURCE=.\Vertex.h
# End Source File
# End Group
# Begin Group "Meshes"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\LineMesh.cpp
# End Source File
# Begin Source File

SOURCE=.\LineMesh.h
# End Source File
# Begin Source File

SOURCE=.\Mesh.cpp
# End Source File
# Begin Source File

SOURCE=.\Mesh.h
# End Source File
# Begin Source File

SOURCE=.\MeshTextureCoordinates.cpp
# End Source File
# Begin Source File

SOURCE=.\PointMesh.cpp
# End Source File
# Begin Source File

SOURCE=.\PointMesh.h
# End Source File
# End Group
# Begin Group "Primitives"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Box.cpp
# End Source File
# Begin Source File

SOURCE=.\Box.h
# End Source File
# Begin Source File

SOURCE=.\Cone.cpp
# End Source File
# Begin Source File

SOURCE=.\Cone.h
# End Source File
# Begin Source File

SOURCE=.\Cylinder.cpp
# End Source File
# Begin Source File

SOURCE=.\Cylinder.h
# End Source File
# Begin Source File

SOURCE=.\Grid.cpp
# End Source File
# Begin Source File

SOURCE=.\Grid.h
# End Source File
# Begin Source File

SOURCE=.\Ring.cpp
# End Source File
# Begin Source File

SOURCE=.\Ring.h
# End Source File
# Begin Source File

SOURCE=.\Sphere.cpp
# End Source File
# Begin Source File

SOURCE=.\Sphere.h
# End Source File
# Begin Source File

SOURCE=.\Torus.cpp
# End Source File
# Begin Source File

SOURCE=.\Torus.h
# End Source File
# Begin Source File

SOURCE=.\Tube.cpp
# End Source File
# Begin Source File

SOURCE=.\Tube.h
# End Source File
# End Group
# Begin Source File

SOURCE=.\mod_models.h
# End Source File
# Begin Source File

SOURCE=.\ModelInstance.cpp
# End Source File
# Begin Source File

SOURCE=.\ModelInstance.h
# End Source File
# Begin Source File

SOURCE=.\ModelInstanceMatrices.cpp
# End Source File
# End Target
# End Project
