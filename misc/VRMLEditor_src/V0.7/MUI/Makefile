# Makefile for VRMLEditor
# MUI objects
# V 1.0
# 30 july 98

CC = g++
OPT = -IDH1:Sources/BodySoft/VRMLSupport -IDH1:Sources/BodySoft/MCC/mui -IDH1:Sources/BodySoft/MCC -IDH1:Sources/BodySoft/VRMLEditor -IDH1:Sources/BodySoft/Useful
LOPT =
COPT =
CPU = -m68040
LIB =

VSDIR = DH1:Sources/BodySoft/VRMLSupport/
MCDIR = DH1:Sources/BodySoft/MUICustomClass/

# Cancel automatic compliation
%.o: %.c
        
#Cancel automatic linking
%: %.o
        
# All
all: App.o WI_Add.o WI_CyberGL.o WI_Main.o WI_Prefs.o WI_AsciiText.o WI_Cone.o WI_Coordinate3.o WI_Cube.o WI_Cylinder.o WI_DirectionalLight.o WI_FontStyle.o WI_Groups.o WI_IFS.o WI_ILS.o WI_Info.o WI_Material.o WI_MaterialBinding.o WI_MatrixTransform.o WI_Normal.o WI_NormalBinding.o WI_OrthographicCamera.o WI_PerspectiveCamera.o WI_PointLight.o WI_PointSet.o WI_Rotation.o WI_Scale.o WI_ShapeHints.o WI_Sphere.o WI_SpotLight.o WI_Texture2.o WI_Texture2Transform.o WI_TextureCoordinate2.o WI_Transform.o WI_Translation.o WI_WWWInline.o WI_MeshWriter.o WI_SaveAs.o VRMLEditor_image.o install

# App
App.o: App.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c App.cpp

# Add
WI_Add.o: WI_Add.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Add.cpp

# CyberGL
WI_CyberGL.o: WI_CyberGL.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_CyberGL.cpp

# Main
WI_Main.o: WI_Main.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Main.cpp

# VRMLEditor_image
VRMLEditor_image.o: VRMLEditor_image.c VRMLEditor_image.h
	$(CC) $(CPU) $(COPT) $(OPT) -c VRMLEditor_image.c

# Prefs
WI_Prefs.o: WI_Prefs.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Prefs.cpp

# MeshWriter
WI_MeshWriter.o: WI_MeshWriter.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_MeshWriter.cpp

# SaveAs
WI_SaveAs.o: WI_SaveAs.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_SaveAs.cpp

# AsciiText
WI_AsciiText.o: WI_AsciiText.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_AsciiText.cpp

# Cone
WI_Cone.o: WI_Cone.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Cone.cpp

# Coordinate3
WI_Coordinate3.o: WI_Coordinate3.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Coordinate3.cpp

# Cube
WI_Cube.o: WI_Cube.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Cube.cpp

# Cylinder
WI_Cylinder.o: WI_Cylinder.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Cylinder.cpp

# DirectionalLight
WI_DirectionalLight.o: WI_DirectionalLight.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_DirectionalLight.cpp

# Fontstyle
WI_FontStyle.o: WI_FontStyle.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_FontStyle.cpp

# Groups
WI_Groups.o: WI_Groups.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Groups.cpp

# IFS
WI_IFS.o: WI_IFS.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_IFS.cpp

# ILS
WI_ILS.o: WI_ILS.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_ILS.cpp

# Info
WI_Info.o: WI_Info.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Info.cpp

# Material
WI_Material.o: WI_Material.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Material.cpp

# MaterialBidning
WI_MaterialBinding.o: WI_MaterialBinding.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_MaterialBinding.cpp

# MatrixTransform
WI_MatrixTransform.o: WI_MatrixTransform.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_MatrixTransform.cpp

# Normal
WI_Normal.o: WI_Normal.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Normal.cpp

# NormalBinding
WI_NormalBinding.o: WI_NormalBinding.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_NormalBinding.cpp

# Orthographic
WI_OrthographicCamera.o: WI_OrthographicCamera.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_OrthographicCamera.cpp

# Prespective
WI_PerspectiveCamera.o: WI_PerspectiveCamera.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_PerspectiveCamera.cpp

# PointLight
WI_PointLight.o: WI_PointLight.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_PointLight.cpp

# PointSet
WI_PointSet.o: WI_PointSet.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_PointSet.cpp

# Rotation
WI_Rotation.o: WI_Rotation.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Rotation.cpp

# Scale
WI_Scale.o: WI_Scale.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Scale.cpp

# ShapeHints
WI_ShapeHints.o: WI_ShapeHints.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_ShapeHints.cpp

# Sphere
WI_Sphere.o: WI_Sphere.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Sphere.cpp

# SpotLight
WI_SpotLight.o: WI_SpotLight.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_SpotLight.cpp

# Texture2
WI_Texture2.o: WI_Texture2.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Texture2.cpp

# Texture2Display
#WI_Texture2Display.o: WI_Texture2Display.cpp App.h AppExtern.h
#	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Texture2Display.cpp

# Texture2Transform
WI_Texture2Transform.o: WI_Texture2Transform.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Texture2Transform.cpp

# TextureCoordinate2
WI_TextureCoordinate2.o: WI_TextureCoordinate2.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_TextureCoordinate2.cpp

# Transform
WI_Transform.o: WI_Transform.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Transform.cpp

# Translation
WI_Translation.o: WI_Translation.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_Translation.cpp

# WWWInline
WI_WWWInline.o: WI_WWWInline.cpp App.h AppExtern.h
	$(CC) $(CPU) $(COPT) $(OPT) -c WI_WWWInline.cpp

# install
install:
	ar -r libmuivrmleditor.a *.o

# Other
clean:
	rm *.o
	rm *.rpo

