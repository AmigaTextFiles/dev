'**************************************************************************
'**                                                                       *
'**   Support for Standard-Images                                         *
'**                                                                       *
'**   by Steffen "Ironbyte" Leistner, 1995, - FREEWARE -                  *
'**   for MaxonBASIC 3/HisoftBASIC 2 and Kickstart 37+                    *
'**                                                                       *
'**************************************************************************
'**
'** Needs exec.bh-Include and exec.library
'**
'**	Parameters:
'**
'** x% = LeftEdge (Offset)
'** y% = TopEdge (Offset)
'**	w% = Width
'** h% = Height
'**	d% = Planes
'** g& = BitplanedataSize
'** t& = Pointer to BitplaneData (Chipmem, alloc. by StructImage&)
'**	p% = "PlanePick"
'**	o% = "PlaneOff"
'**	n& = Pointer to next Image
'**
'** RESULT = Pointer to Imagestructure without Bitplanedata
'**          or 0& if not enough free Memory
'**          Free it with FreeVec!
'** (See ILBM2BAS-converdet Imagesources for Details)

FUNCTION StructImage& (x%,y%,w%,h%,d%,g&,t&,p%,o%,n&)
	LOCAL imgs&, memb&
	memb& = g& + Image_sizeof%
	imgs& = AllocVec& (memb&, MEMF_CHIP& OR MEMF_CLEAR&)
	IF imgs& THEN
		t& 	= imgs& + Image_sizeof%
		POKEW imgs& + ImageLeftEdge%,	x%
		POKEW imgs& + ImageTopEdge%,	y%
		POKEW imgs& + ImageWidth%,		w%
		POKEW imgs& + ImageHeight%,		h%
		POKEW imgs& + ImageDepth%,		d%
		POKEL imgs& + ImageImageData%,	t&
		POKEB imgs& + ImagePlanePick%,	p%
		POKEB imgs& + ImagePlaneOnOff%,	o%
		POKEL imgs& + NextImage%,		n&
		StructImage& = imgs&
	ELSE
		StructImage& = 0&
	END IF
END FUNCTION