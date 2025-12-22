ShowModule v1.10 (c) 1992 $#%!
now showing: "ddd.m"
NOTE: don't use this output in your code, use the module instead.

##base _dddbase
##bias 30
##public
Init3DBase()()
CheckIf3DFile(a)(D0)
ReadFile3D(a,b)(A0,D0)
SaveGeoFile(a,b)(A0,D0)
SaveDxfFile(a,b)(A0,D0)
SaveRayFile(a,b)(A0,D0)
SavePovFile(a,b)(A0,D0)
SaveBinFile(a,b,c)(A0,D1,D0)
Rem3DBase(a)(D0)
UpdateCenterBase3D(a)(D0)
BuildMinMax(a,b,c)(A0,D1,D0)
FormatBase3DWithScreen(a,b)(A0,D0)
FormatBase3DWithWindow(a,b)(A0,D0)
DrawBase3D(a,b)(A0,D0)
DrawObject3D(a,b,c)(A0,D1,D0)
DrawObjectFace(a,b,c,d,e,f,g)(A2,A1,A0,D3,D2,D1,D0)
ClearDrawingArea(a,b)(A0,D0)
Conv3DObj2Vect(a,b,c,d,e)(A1,A0,D2,D1,D0)
Conv3DObj2VectLib(a,b,c,d,e)(A1,A0,D2,D1,D0)
RenderVectorObject(a,b,c,d,e,f,g,h,i)(A3,A2,A1,A0,D4,D3,D2,D1,D0)
GetColor(a,b,c,d,e)(A1,A0,D2,D1,D0)
MakeObject(a,b,c,d,e,f,g)(A2,A1,A0,D3,D2,D1,D0)
PrimCube(a,b,c)(A0,D1,D0)
RotateBase3D(a,b)(A0,D0)
RotateBase(a,b,c)(A0,D1,D0)
RotateObject3D(a,b,c,d)(A1,A0,D1,D0)
CentreBase3D(a)(D0)
CentreObject3D(a,b)(A0,D0)
BoundedObject3D(a,b,c,d)(A1,A0,D1,D0)
BoundedAllObject3D(a,b)(A0,D0)
SelectObject3D(a,b,c,d)(A1,A0,D1,D0)
SelectAllObject3D(a,b)(A0,D0)
##end

