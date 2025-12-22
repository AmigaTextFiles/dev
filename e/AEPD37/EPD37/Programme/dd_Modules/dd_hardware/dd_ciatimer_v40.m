bel,Or(MUIO_Label_DoubleFrame,key)])
#define KeyLLabel(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned,key)])
#define KeyLLabel1(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned + MUIO_Label_SingleFrame,key)])
#define KeyLLabel2(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame,key)])
#define KeyCLabel(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_Centered,key)])
#define KeyCLabel1(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_Centered + MUIO_Label_SingleFrame,key)])
#define KeyCLabel2(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_Centered + MUIO_Label_DoubleFrame,key)])

#define FreeKeyLabel(label,key)   Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert,key)])
#define FreeKeyLabel1(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_SingleFrame,key)])
#define FreeKeyLabel2(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_DoubleFrame,key)])
#define FreeKeyLLabel(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_LeftAligned,key)])
#define FreeKeyLLabel1(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_LeftAligned + MUIO_Label_SingleFrame,key)])
#define FreeKeyLLabel2(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame,key)])
#define FreeKeyCLabel(label,key)  Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_Centered,key)])
#define FreeKeyCLabel1(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_Centered + MUIO_Label_SingleFrame,key)])
#define FreeKeyCLabel2(label,key) Mui_MakeObjectA(MUIO_Label,[label,Or(MUIO_Label_FreeVert + MUIO_Label_Centered + MUIO_Label_DoubleFrame,key)])



/***************************************************************************
**
** Controlling Objects
** -------------------
**
** set() and get() are two short stubs for BOOPSI GetAttr() and SetAttrsA()
** calls:
**
*