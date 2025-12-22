

#define OBJ LA_Member

/* Example */

Context
(
  LA_Screen,Scr,
  LA_Window,Win,
  
  OBJ,Group_Vert
  ( 
    OBJ,GadTools(CYCLE_KIND,Tags yadda),
    OBJ,Group_Horiz
    (
      OBJ,GadTools(LISTVIEW_KIND,Tags),
      OBJ,GadTools(SLIDER_KIND,Tags),
    )
    OBJ,Group_Horiz      
    (
      OBJ,GadTools(BUTTON_KIND,"Add"),
      OBJ,GadTools(BUTTON_KIND,"Delete"),
    )
    OBJ,Group_Horiz      
    (
      OBJ,GadTools(BUTTON_KIND,"Select"),
    )          
  )              
)           
  
