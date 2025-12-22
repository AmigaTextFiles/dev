'
'  PaletteED for ACE programmign language, written in ACE by 
'                   Petteri Heikkinen
'                27.01.95 Oulu,  Finland 
'          Thanks to David Benn for ACE language
'
' This programm may be freely distributed and changed without 
' permission from the author. You may also use parts of this
' program in your own products. Hope you can use this!
'
' If need to contact me try these Email addesses:
' pheikkin@paju.oulu.fi, @phoenix.oulu.fi, @zombie.oulu.fi
' or this SMail address:
' 	 Petteri Heikkinen
' 	 Kataja
' 	 89540 Moisiovaara
' 	 Finland
'
' Usage: This programm works just like any other palette-editor.
'        Just try it out!! it should not be too difficult to figure 
'        out what it saves with SData and Save gadgets...

   Main:

   ' Let us open a nice little screen to play with
   screen 1,320,200,4,1
   window 1,"Palette",(0,12)-(200,200),1,1
   
   'some variables
   get_out=0 : i=0 : colour=0 : DIM r(15) : DIM g(15) : DIM b(15) : GadgValue=0

   'Let us read some data and set our palette and r(),g(),b() arrays 
   for i=0 to 15
     read r(i),g(i),b(i)
     palette i,r(i),g(i),b(i)
   next i

   'Data sentences that contain OUR palette
   data 0.87500003 , 0.87500003 , 0.87500003 
   data 0 , 0 , 0 
   data 1 , 1 , 1 
   data 0.56250003 , 0.68750003 , 0.81250003 
   data 0 , 0 , 1 
   data 1 , 0 , 1 
   data 0 , 1 , 1 
   data 0.93750003 , 0.93750003 , 0.93750003 
   data 0.75000003 , 0.75000003 , 0.75000003 
   data 0.56250003 , 0.56250003 , 0.56250003 
   data 0.43750001 , 0.43750001 , 0.43750001 
   data 1 , 1 , 0 
   data 0.87500003 , 0.87500003 , 0 
   data 0.68750003 , 0.68750003 , 0 
   data 0 , 1 , 0 
   data 0 , 0.75000003 , 0 

   'Let us make some GUI-stuff
   gadget 1,1,16,(15,20)-(25,160),5,0			'Slider gadgets to set RGB-values
   gadget 2,1,16,(35,20)-(45,160),5,0
   gadget 3,1,16,(55,20)-(65,160),5,0

   gadget 4,1,"Quit",(95,20)-(155,40),1,1		'gadgets Quit, Next, Previous, Save_palette
   gadget 5,1,"Save",(95,50)-(155,70),1,1		'and Save_Data_palette
   gadget 6,1,"SData",(95,80)-(155,100),1,1
   gadget 7,1,"Next",(95,110)-(155,130),1,1
   gadget 8,1,"Previous",(95,140)-(155,160),1,1

   for i=0 to 15
     line (75,5+10*i)-(85,13+10*i),i,bf			'Drawing the palette for direct access
   next i

   for i=0 to 15
     gadget (i+9),1,"",(74,5+10*i)-(86,14+10*i),1,1 	'gadgets for those previously drawn colours
   next i 
   
   on gadget gosub GadgetEvent
   gadget on 						'event trapping on
 
   while get_out=0					'Test if we are still needed here
     sleep  						'Going to sleep so that multitasking can be more efficient
   wend

 End_of_Program:
   gadget off						'event trapping off
   for i=0 to 23					'cleaning up
     gadget close i
   next i
   window close 1
   screen close 1
   end

 Save_palette:							'asks a filename for palette source
   filename$=filebox$("Save_palette in Palette,r,g,b format")   'and saves edited palette in ACE program sentences
   palette$=" palette"
   open "O",#1,filename$
   for i=0 to 15
     print #1,palette$;i;",";r(i);",";g(i);",";b(i)
   next i
   close #1
   return
 
 Save_Data:							'asks a filename for Data source
   filename$=filebox$("Save_Palette in Data-format")		'and saves edited palette with needed commands
   data$="Data "
   open "O",#1,filename$
   print #1,"'Let us read some data and set our palette and r(),g(),b() arrays "
   print #1,"for i=0 to 15"
   print #1,"  read r(i),g(i),b(i)"
   print #1,"  palette i,r(i),g(i),b(i)"
   print #1,"next i"
   print #1,""
   for i=0 to 15
     print #1,data$;r(i);",";g(i);",";b(i)
   next i
   close #1
   return

 GadgetEvent:
   GadgValue=gadget(3)/16				'Gadget event detected..what is the value of
							'last selected gadget?
   if gadget(1)=1 then					
     r(colour)=GadgValue
     palette colour,r(colour),g(colour),b(colour) 
   end if

   if gadget(1)=2 then
     g(colour)=GadgValue
     palette colour,r(colour),g(colour),b(colour) 
   end if

   if gadget(1)=3 then
     b(colour)=GadgValue
     palette colour,r(colour),g(colour),b(colour) 
   end if

   if gadget(1)=4 then
     get_out=1
   end if

   if gadget(1)=5 then
     gosub Save_palette
   end if

   if gadget(1)=6 then
     gosub Save_Data
   end if

   if gadget(1)=7 then
     colour=colour+1
       gadget mod 1,int(16*r(colour))
       gadget mod 2,int(16*g(colour))
       gadget mod 3,int(16*b(colour))
   end if

   if gadget(1)=8 then
     colour=colour-1
       gadget mod 1,int(16*r(colour))
       gadget mod 2,int(16*g(colour))
       gadget mod 3,int(16*b(colour))
   end if

   for i=0 to 15
     if gadget(1)=9+i then
       colour=i
       gadget mod 1,int(16*r(colour))
       gadget mod 2,int(16*g(colour))
       gadget mod 3,int(16*b(colour))
     end if
   next i

   return
