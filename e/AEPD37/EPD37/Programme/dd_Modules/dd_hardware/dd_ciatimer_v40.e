--------
**
***************************************************************************/


#define Slider(min,max,level)\
        SliderObject,\
                MUIA_Slider_Min  , min,\
                MUIA_Slider_Max  , max,\
                MUIA_Slider_Level, level,\
                End

#define KeySlider(min,max,level,key)\
        SliderObject,\
                MUIA_Slider_Min  , min,\
                MUIA_Slider_Max  , max,\
                MUIA_Slider_Level, level,\
                MUIA_ControlChar , key,\
                End

#endif



/***************************************************************************
**
** Button to be used for popup objects
**
***************************************************************************/

#define PopButton(img) Mui_MakeObjectA(MUIO_PopButton,[img])



/***************************************************************************
**
** Labeling Objects
** ----------------
**
** Labeling objects, e.g. a group of string gadgets,
**
**   Small: |foo   |
**  Normal: |bar   |
**     Big: |foobar|
**    Huge: |barfoo|
**
** is done using a 2 column group:
**
** ColGroup(2),
**      Child, Label2('Small:' ),
**    Child, StringObject, End,
**      Child, Label2('Normal:'),
**    Child, StringObject, End,
**      Child, Label2('Big:'   ),
**    Child, StringObject, End,
**      Child, Label2('Huge:'  ),
**    Child, StringObject, End,
**    End,
**
** Note that we have three versions of the label macro, depending on
** the frame type of the right hand object:
**
** Label1(): For use with standard frames (e.g. checkmarks).
** Label2(): For use with double high frames (e.g. string gadgets).
** Label() : For use with objects without a frame.
**
** These macros ensure that your label will look fine even if the
** user of your application configured some strange spacing values.
** If you want to use your own labeling, you'll have to pay attention
** on this topic yourself.
**
***************************************************************************/

#define Label(label)   Mui_MakeObjectA(MUIO_Label,[label,0])
#define Label1(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_SingleFrame])
#define Label2(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_DoubleFrame])
#define LLabel(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned])
#define LLabel1(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned + MUIO_Label_SingleFrame])
#define LLabel2(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_LeftAligned + MUIO_Label_DoubleFrame])
#define CLabel(label)  Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_Centered])
#define CLabel1(label) Mui_MakeObjectA(MUIO_Label,[label,MUIO_Label_Centered + MUIO_Label_SingleFrame])
#define CLabel2(lab