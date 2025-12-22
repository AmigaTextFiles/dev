OBJECT bitmapheader
   width:INT
   height:INT
   left:INT
   top:INT
   depth:CHAR
   masking:CHAR
   compression:CHAR
   pad:CHAR
   transparent:INT
   xaspect:CHAR
   yaspect:CHAR
   pagewidth:INT
   pageheight:INT
ENDOBJECT     
OBJECT  frameinfo
		propertyflags:LONG         
		resolution:LONG
		redbits:CHAR               
		greenbits:CHAR             
		bluebits:CHAR              
		pad:CHAR
		width:LONG                 
		height:LONG                
		depth:LONG                 
		scrn:LONG
		colormap:LONG              
		flags:LONG                 
ENDOBJECT   
OBJECT dtwrite
		dtw_methodid:LONG
		dtw_ginfo:LONG
		dtw_filehandle:LONG
		dtw_mode:LONG
		dtw_attrlist:LONG
ENDOBJECT
OBJECT  dtframebox 
		dtf_methodid:LONG
  		dtf_ginfo:LONG        
  		dtf_contentsinfo:LONG 
  		dtf_frameinfo:LONG    
  		dtf_sizeframeinfo:LONG
  		dtf_frameflags:LONG   
ENDOBJECT     
OBJECT gplayout
	gplmi:LONG	
	ginfo:LONG  
	initial:LONG
ENDOBJECT
