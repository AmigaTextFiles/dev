/* Application created by MUIBuild */

address pages

MUIA_Selected = 0x8042654b
MUIA_Slider_Level = 0x8042ae3a
TRUE = 1

window ID PAGE TITLE """Character Definition""" COMMAND """quit""" PORT PAGES
 group HORIZ
  group
   label SINGLE "Name:"
   label SINGLE "Sex:"
  endgroup
  group
   string ID NAME CONTENT "Frodo"
   cycle ID SEX LABELS "male,female"
  endgroup
 endgroup
 space 2
 group REGISTER LABELS "Race,Class,Armor,Level"
  group FRAME
   radio ID RACE LABELS "Human,Elf,Dwarf,Hobbit,Gnome"
  endgroup
  group FRAME
   radio ID CLAS LABELS "Warrior,Rogue,Bard,Monk,Magician,Archmage"
  endgroup
  group
   group HORIZ
    group
     label SINGLE "Cloak:"
     label SINGLE "Shield:"
     label SINGLE "Gloves:"
     label SINGLE "Helmet:"
    endgroup
    group
     check ID CHK1 ATTRS MUIA_Selected TRUE
     check ID CHK2 ATTRS MUIA_Selected TRUE
     check ID CHK3 ATTRS MUIA_Selected TRUE
     check ID CHK4 ATTRS MUIA_Selected TRUE
    endgroup
   endgroup
  endgroup
  group
   group HORIZ
    group
     label DOUBLE "Experience:"
     label DOUBLE "Strength:"
     label DOUBLE "Dexterity:"
     label DOUBLE "Condition:"
     label DOUBLE "Intelligence:"
    endgroup
    group
     slider ATTRS MUIA_Slider_Level 3
     slider ATTRS MUIA_Slider_Level 42
     slider ATTRS MUIA_Slider_Level 24
     slider ATTRS MUIA_Slider_Level 39
     slider ATTRS MUIA_Slider_Level 74
    endgroup
   endgroup
  endgroup
 endgroup
endwindow
