/*
=======================================================================

These defines are very cryptic so as to product file names
that work with all file systems, I believe some explanation is needed.

Each #ifdef <tag> produces a <tag>.c file 

Rendering <tags> are of the form:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[primitive type][Special Structure][Render Attributes]

where

[primitive type] = { m, p, q, t }
	m = mesh
	p = polygon
	q = quad
	t = triangle

[Special Structure] = { B, E, NB, B2 }
	B = Batch mode, where all vertices are sent between one
	                glBegin/glEnd pair
	E = External function, used for altering state per primitive
	NB = No batching, one primitive between each glBegin/glEnd pair
	B2 = Batching, two vertices between each glBegin/glEnd pair  

[Render Attributes] = { Fc, Vc, Fn, Vn, T }
	Fc = Facet Colors
	Vc = Vertex Color
	Fn = Facet Normal
	Vn = Vertex Normal
	T  = Texture Coord
	

Event Loop <tags> are of the form:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

e[Mode][Special Functions]

where

[Mode] = { D, I }
	D = Display List
	I = Immediate

[Special Functions] = { M, A, W }
        M = Motion blur via the accumulation buffer
        A = Full scene antialiasing via the accumulation buffer
        W = Walkthru mode
	
=======================================================================
*/



#ifdef eD
    #define DISPLAY_LIST
    #define FUNCTION   evtD
#endif
#ifdef eI
    #define FUNCTION   evtI
#endif

#ifdef eDM
    #define MOTION_BLUR
    #define DISPLAY_LIST
    #define FUNCTION   evtDM
#endif
#ifdef eIM
    #define MOTION_BLUR
    #define FUNCTION   evtIM
#endif
#ifdef eDA
    #define FS_ANTIALIASING
    #define DISPLAY_LIST
    #define FUNCTION   evtDA
#endif
#ifdef eIA
    #define FS_ANTIALIASING
    #define FUNCTION   evtIA
#endif

#ifdef eDMA
    #define MOTION_BLUR
    #define FS_ANTIALIASING
    #define DISPLAY_LIST
    #define FUNCTION   evtDMA
#endif
#ifdef eIMA
    #define MOTION_BLUR
    #define FS_ANTIALIASING
    #define FUNCTION   evtIMA
#endif
#ifdef eDW
    #define DISPLAY_LIST
    #define WALKTHRU
    #define FUNCTION   evtDW
#endif
#ifdef eIW
    #define WALKTHRU
    #define FUNCTION   evtIW
#endif

#ifdef eDMW
    #define MOTION_BLUR
    #define DISPLAY_LIST
    #define WALKTHRU
    #define FUNCTION   evtDMW
#endif
#ifdef eIMW
    #define MOTION_BLUR
    #define WALKTHRU
    #define FUNCTION   evtIMW
#endif
#ifdef eDAW
    #define FS_ANTIALIASING
    #define DISPLAY_LIST
    #define WALKTHRU
    #define FUNCTION   evtDAW
#endif
#ifdef eIAW
    #define FS_ANTIALIASING
    #define WALKTHRU
    #define FUNCTION   evtIAW
#endif

#ifdef eDMAW
    #define MOTION_BLUR
    #define FS_ANTIALIASING
    #define DISPLAY_LIST
    #define WALKTHRU
    #define FUNCTION   evtDMAW
#endif
#ifdef eIMAW
    #define MOTION_BLUR
    #define FS_ANTIALIASING
    #define WALKTHRU
    #define FUNCTION   evtIMAW
#endif

#ifdef pNB
    #define FUNCTION    rmpNB 
#endif

#ifdef pNBFc
    #define FACET_COLOR
    #define FUNCTION    rmpNBFc 
#endif

#ifdef pNBFcT
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpNBFcT 
#endif

#ifdef pNBFn
    #define FACET_NORM
    #define FUNCTION    rmpNBFn 
#endif

#ifdef pNBFnFc
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpNBFnFc 
#endif

#ifdef pNBFnFcT
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpNBFnFcT 
#endif

#ifdef pNBFnT
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpNBFnT 
#endif

#ifdef pNBFnVc
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmpNBFnVc 
#endif

#ifdef pNBFnVcT
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpNBFnVcT 
#endif

#ifdef pNBT
    #define TEXTURE
    #define FUNCTION    rmpNBT 
#endif

#ifdef pNBVc
    #define VERT_COLOR
    #define FUNCTION    rmpNBVc 
#endif

#ifdef pNBVcT
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpNBVcT 
#endif

#ifdef pNBVn
    #define VERT_NORM
    #define FUNCTION    rmpNBVn 
#endif

#ifdef pNBVnFc
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpNBVnFc 
#endif

#ifdef pNBVnFcT
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpNBVnFcT 
#endif

#ifdef pNBVnT
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmpNBVnT 
#endif

#ifdef pNBVnVc
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmpNBVnVc 
#endif

#ifdef pNBVnVcT
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpNBVnVcT 
#endif

#ifdef mNB
    #define FUNCTION    rmmNB 
#endif

#ifdef mNBFc
    #define FACET_COLOR
    #define FUNCTION    rmmNBFc 
#endif

#ifdef mNBFcT
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmNBFcT 
#endif

#ifdef mNBFn
    #define FACET_NORM
    #define FUNCTION    rmmNBFn 
#endif

#ifdef mNBFnFc
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmNBFnFc 
#endif

#ifdef mNBFnFcT
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmNBFnFcT 
#endif

#ifdef mNBFnT
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmNBFnT 
#endif

#ifdef mNBFnVc
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmmNBFnVc 
#endif

#ifdef mNBFnVcT
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmNBFnVcT 
#endif

#ifdef mNBT
    #define TEXTURE
    #define FUNCTION    rmmNBT 
#endif

#ifdef mNBVc
    #define VERT_COLOR
    #define FUNCTION    rmmNBVc 
#endif

#ifdef mNBVcT
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmNBVcT 
#endif

#ifdef mNBVn
    #define VERT_NORM
    #define FUNCTION    rmmNBVn 
#endif

#ifdef mNBVnFc
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmNBVnFc 
#endif

#ifdef mNBVnFcT
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmNBVnFcT 
#endif

#ifdef mNBVnT
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmmNBVnT 
#endif

#ifdef mNBVnVc
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmmNBVnVc 
#endif

#ifdef mNBVnVcT
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmNBVnVcT 
#endif

#ifdef pB
    #define BATCH
    #define FUNCTION    rmpB 
#endif

#ifdef pBFc
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmpBFc 
#endif

#ifdef pBFcT
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpBFcT 
#endif

#ifdef pBFn
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmpBFn 
#endif

#ifdef pBFnFc
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpBFnFc 
#endif

#ifdef pBFnFcT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpBFnFcT 
#endif

#ifdef pBFnT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpBFnT 
#endif

#ifdef pBFnVc
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmpBFnVc 
#endif

#ifdef pBFnVcT
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpBFnVcT 
#endif

#ifdef pBT
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmpBT 
#endif

#ifdef pBVc
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmpBVc 
#endif

#ifdef pBVcT
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpBVcT 
#endif

#ifdef pBVn
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmpBVn 
#endif

#ifdef pBVnFc
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpBVnFc 
#endif

#ifdef pBVnFcT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpBVnFcT 
#endif

#ifdef pBVnT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmpBVnT 
#endif

#ifdef pBVnVc
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmpBVnVc 
#endif

#ifdef pBVnVcT
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpBVnVcT 
#endif

#ifdef pB2
    #define BATCH
    #define FUNCTION    rmpB2 
    #define BY_TWO
#endif

#ifdef pB2Fc
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmpB2Fc 
    #define BY_TWO
#endif

#ifdef pB2FcT
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpB2FcT 
    #define BY_TWO
#endif

#ifdef pB2Fn
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmpB2Fn 
    #define BY_TWO
#endif

#ifdef pB2FnFc
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpB2FnFc 
    #define BY_TWO
#endif

#ifdef pB2FnFcT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpB2FnFcT 
    #define BY_TWO
#endif

#ifdef pB2FnT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpB2FnT 
    #define BY_TWO
#endif

#ifdef pB2FnVc
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmpB2FnVc 
    #define BY_TWO
#endif

#ifdef pB2FnVcT
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpB2FnVcT 
    #define BY_TWO
#endif

#ifdef pB2T
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmpB2T 
    #define BY_TWO
#endif

#ifdef pB2Vc
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmpB2Vc 
    #define BY_TWO
#endif

#ifdef pB2VcT
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpB2VcT 
    #define BY_TWO
#endif

#ifdef pB2Vn
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmpB2Vn 
    #define BY_TWO
#endif

#ifdef pB2VnFc
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpB2VnFc 
    #define BY_TWO
#endif

#ifdef pB2VnFcT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpB2VnFcT 
    #define BY_TWO
#endif

#ifdef pB2VnT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmpB2VnT 
    #define BY_TWO
#endif

#ifdef pB2VnVc
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmpB2VnVc 
    #define BY_TWO
#endif

#ifdef pB2VnVcT
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpB2VnVcT 
    #define BY_TWO
#endif

#ifdef mB2
    #define BATCH
    #define FUNCTION    rmmB2 
    #define BY_TWO
#endif

#ifdef mB2Fc
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmmB2Fc 
    #define BY_TWO
#endif

#ifdef mB2FcT
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmB2FcT 
    #define BY_TWO
#endif

#ifdef mB2Fn
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmmB2Fn 
    #define BY_TWO
#endif

#ifdef mB2FnFc
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmB2FnFc 
    #define BY_TWO
#endif

#ifdef mB2FnFcT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmB2FnFcT 
    #define BY_TWO
#endif

#ifdef mB2FnT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmB2FnT 
    #define BY_TWO
#endif

#ifdef mB2FnVc
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmmB2FnVc 
    #define BY_TWO
#endif

#ifdef mB2FnVcT
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmB2FnVcT 
    #define BY_TWO
#endif

#ifdef mB2T
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmmB2T 
    #define BY_TWO
#endif

#ifdef mB2Vc
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmmB2Vc 
    #define BY_TWO
#endif

#ifdef mB2VcT
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmB2VcT 
    #define BY_TWO
#endif

#ifdef mB2Vn
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmmB2Vn 
    #define BY_TWO
#endif

#ifdef mB2VnFc
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmB2VnFc 
    #define BY_TWO
#endif

#ifdef mB2VnFcT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmB2VnFcT 
    #define BY_TWO
#endif

#ifdef mB2VnT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmmB2VnT 
    #define BY_TWO
#endif

#ifdef mB2VnVc
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmmB2VnVc 
    #define BY_TWO
#endif

#ifdef mB2VnVcT
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmB2VnVcT 
    #define BY_TWO
#endif

#ifdef qNB
    #define FUNCTION    rmqNB 
#endif

#ifdef qNBFc
    #define FACET_COLOR
    #define FUNCTION    rmqNBFc 
#endif

#ifdef qNBFcT
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqNBFcT 
#endif

#ifdef qNBFn
    #define FACET_NORM
    #define FUNCTION    rmqNBFn 
#endif

#ifdef qNBFnFc
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqNBFnFc 
#endif

#ifdef qNBFnFcT
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqNBFnFcT 
#endif

#ifdef qNBFnT
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqNBFnT 
#endif

#ifdef qNBFnVc
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmqNBFnVc 
#endif

#ifdef qNBFnVcT
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqNBFnVcT 
#endif

#ifdef qNBT
    #define TEXTURE
    #define FUNCTION    rmqNBT 
#endif

#ifdef qNBVc
    #define VERT_COLOR
    #define FUNCTION    rmqNBVc 
#endif

#ifdef qNBVcT
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqNBVcT 
#endif

#ifdef qNBVn
    #define VERT_NORM
    #define FUNCTION    rmqNBVn 
#endif

#ifdef qNBVnFc
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqNBVnFc 
#endif

#ifdef qNBVnFcT
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqNBVnFcT 
#endif

#ifdef qNBVnT
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmqNBVnT 
#endif

#ifdef qNBVnVc
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmqNBVnVc 
#endif

#ifdef qNBVnVcT
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqNBVnVcT 
#endif

#ifdef qB
    #define BATCH
    #define FUNCTION    rmqB 
#endif

#ifdef qBFc
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmqBFc 
#endif

#ifdef qBFcT
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqBFcT 
#endif

#ifdef qBFn
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmqBFn 
#endif

#ifdef qBFnFc
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqBFnFc 
#endif

#ifdef qBFnFcT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqBFnFcT 
#endif

#ifdef qBFnT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqBFnT 
#endif

#ifdef qBFnVc
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmqBFnVc 
#endif

#ifdef qBFnVcT
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqBFnVcT 
#endif

#ifdef qBT
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmqBT 
#endif

#ifdef qBVc
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmqBVc 
#endif

#ifdef qBVcT
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqBVcT 
#endif

#ifdef qBVn
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmqBVn 
#endif

#ifdef qBVnFc
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqBVnFc 
#endif

#ifdef qBVnFcT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqBVnFcT 
#endif

#ifdef qBVnT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmqBVnT 
#endif

#ifdef qBVnVc
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmqBVnVc 
#endif

#ifdef qBVnVcT
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqBVnVcT 
#endif

#ifdef qB2
    #define BATCH
    #define FUNCTION    rmqB2 
    #define BY_TWO
#endif

#ifdef qB2Fc
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmqB2Fc 
    #define BY_TWO
#endif

#ifdef qB2FcT
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqB2FcT 
    #define BY_TWO
#endif

#ifdef qB2Fn
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmqB2Fn 
    #define BY_TWO
#endif

#ifdef qB2FnFc
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqB2FnFc 
    #define BY_TWO
#endif

#ifdef qB2FnFcT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqB2FnFcT 
    #define BY_TWO
#endif

#ifdef qB2FnT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqB2FnT 
    #define BY_TWO
#endif

#ifdef qB2FnVc
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmqB2FnVc 
    #define BY_TWO
#endif

#ifdef qB2FnVcT
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqB2FnVcT 
    #define BY_TWO
#endif

#ifdef qB2T
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmqB2T 
    #define BY_TWO
#endif

#ifdef qB2Vc
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmqB2Vc 
    #define BY_TWO
#endif

#ifdef qB2VcT
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqB2VcT 
    #define BY_TWO
#endif

#ifdef qB2Vn
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmqB2Vn 
    #define BY_TWO
#endif

#ifdef qB2VnFc
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqB2VnFc 
    #define BY_TWO
#endif

#ifdef qB2VnFcT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqB2VnFcT 
    #define BY_TWO
#endif

#ifdef qB2VnT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmqB2VnT 
    #define BY_TWO
#endif

#ifdef qB2VnVc
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmqB2VnVc 
    #define BY_TWO
#endif

#ifdef qB2VnVcT
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqB2VnVcT 
    #define BY_TWO
#endif

#ifdef tNB
    #define FUNCTION    rmtNB 
#endif

#ifdef tNBFc
    #define FACET_COLOR
    #define FUNCTION    rmtNBFc 
#endif

#ifdef tNBFcT
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtNBFcT 
#endif

#ifdef tNBFn
    #define FACET_NORM
    #define FUNCTION    rmtNBFn 
#endif

#ifdef tNBFnFc
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtNBFnFc 
#endif

#ifdef tNBFnFcT
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtNBFnFcT 
#endif

#ifdef tNBFnT
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtNBFnT 
#endif

#ifdef tNBFnVc
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmtNBFnVc 
#endif

#ifdef tNBFnVcT
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtNBFnVcT 
#endif

#ifdef tNBT
    #define TEXTURE
    #define FUNCTION    rmtNBT 
#endif

#ifdef tNBVc
    #define VERT_COLOR
    #define FUNCTION    rmtNBVc 
#endif

#ifdef tNBVcT
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtNBVcT 
#endif

#ifdef tNBVn
    #define VERT_NORM
    #define FUNCTION    rmtNBVn 
#endif

#ifdef tNBVnFc
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtNBVnFc 
#endif

#ifdef tNBVnFcT
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtNBVnFcT 
#endif

#ifdef tNBVnT
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmtNBVnT 
#endif

#ifdef tNBVnVc
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmtNBVnVc 
#endif

#ifdef tNBVnVcT
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtNBVnVcT 
#endif

#ifdef tB
    #define BATCH
    #define FUNCTION    rmtB 
#endif

#ifdef tBFc
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmtBFc 
#endif

#ifdef tBFcT
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtBFcT 
#endif

#ifdef tBFn
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmtBFn 
#endif

#ifdef tBFnFc
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtBFnFc 
#endif

#ifdef tBFnFcT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtBFnFcT 
#endif

#ifdef tBFnT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtBFnT 
#endif

#ifdef tBFnVc
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmtBFnVc 
#endif

#ifdef tBFnVcT
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtBFnVcT 
#endif

#ifdef tBT
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmtBT 
#endif

#ifdef tBVc
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmtBVc 
#endif

#ifdef tBVcT
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtBVcT 
#endif

#ifdef tBVn
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmtBVn 
#endif

#ifdef tBVnFc
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtBVnFc 
#endif

#ifdef tBVnFcT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtBVnFcT 
#endif

#ifdef tBVnT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmtBVnT 
#endif

#ifdef tBVnVc
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmtBVnVc 
#endif

#ifdef tBVnVcT
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtBVnVcT 
#endif

#ifdef tB2
    #define BATCH
    #define FUNCTION    rmtB2 
    #define BY_TWO
#endif

#ifdef tB2Fc
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmtB2Fc 
    #define BY_TWO
#endif

#ifdef tB2FcT
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtB2FcT 
    #define BY_TWO
#endif

#ifdef tB2Fn
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmtB2Fn 
    #define BY_TWO
#endif

#ifdef tB2FnFc
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtB2FnFc 
    #define BY_TWO
#endif

#ifdef tB2FnFcT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtB2FnFcT 
    #define BY_TWO
#endif

#ifdef tB2FnT
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtB2FnT 
    #define BY_TWO
#endif

#ifdef tB2FnVc
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmtB2FnVc 
    #define BY_TWO
#endif

#ifdef tB2FnVcT
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtB2FnVcT 
    #define BY_TWO
#endif

#ifdef tB2T
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmtB2T 
    #define BY_TWO
#endif

#ifdef tB2Vc
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmtB2Vc 
    #define BY_TWO
#endif

#ifdef tB2VcT
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtB2VcT 
    #define BY_TWO
#endif

#ifdef tB2Vn
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmtB2Vn 
    #define BY_TWO
#endif

#ifdef tB2VnFc
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtB2VnFc 
    #define BY_TWO
#endif

#ifdef tB2VnFcT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtB2VnFcT 
    #define BY_TWO
#endif

#ifdef tB2VnT
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmtB2VnT 
    #define BY_TWO
#endif

#ifdef tB2VnVc
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmtB2VnVc 
    #define BY_TWO
#endif

#ifdef tB2VnVcT
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtB2VnVcT 
    #define BY_TWO
#endif

#ifdef mE
    #define EXTERNAL
    #define FUNCTION    rmmE 
#endif

#ifdef mEFc
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmmEFc 
#endif

#ifdef mEFcT
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmEFcT 
#endif

#ifdef mEFn
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmmEFn 
#endif

#ifdef mEFnFc
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmEFnFc 
#endif

#ifdef mEFnFcT
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmEFnFcT 
#endif

#ifdef mEFnT
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmEFnT 
#endif

#ifdef mEFnVc
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmmEFnVc 
#endif

#ifdef mEFnVcT
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmEFnVcT 
#endif

#ifdef mET
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmmET 
#endif

#ifdef mEVc
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmmEVc 
#endif

#ifdef mEVcT
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmEVcT 
#endif

#ifdef mEVn
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmmEVn 
#endif

#ifdef mEVnFc
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmEVnFc 
#endif

#ifdef mEVnFcT
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmEVnFcT 
#endif

#ifdef mEVnT
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmmEVnT 
#endif

#ifdef mEVnVc
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmmEVnVc 
#endif

#ifdef mEVnVcT
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmEVnVcT 
#endif

#ifdef pE
    #define EXTERNAL
    #define FUNCTION    rmpE 
#endif

#ifdef pEFc
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmpEFc 
#endif

#ifdef pEFcT
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpEFcT 
#endif

#ifdef pEFn
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmpEFn 
#endif

#ifdef pEFnFc
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpEFnFc 
#endif

#ifdef pEFnFcT
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpEFnFcT 
#endif

#ifdef pEFnT
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpEFnT 
#endif

#ifdef pEFnVc
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmpEFnVc 
#endif

#ifdef pEFnVcT
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpEFnVcT 
#endif

#ifdef pET
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmpET 
#endif

#ifdef pEVc
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmpEVc 
#endif

#ifdef pEVcT
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpEVcT 
#endif

#ifdef pEVn
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmpEVn 
#endif

#ifdef pEVnFc
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpEVnFc 
#endif

#ifdef pEVnFcT
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpEVnFcT 
#endif

#ifdef pEVnT
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmpEVnT 
#endif

#ifdef pEVnVc
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmpEVnVc 
#endif

#ifdef pEVnVcT
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpEVnVcT 
#endif

#ifdef qE
    #define EXTERNAL
    #define FUNCTION    rmqE 
#endif

#ifdef qEFc
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmqEFc 
#endif

#ifdef qEFcT
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqEFcT 
#endif

#ifdef qEFn
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmqEFn 
#endif

#ifdef qEFnFc
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqEFnFc 
#endif

#ifdef qEFnFcT
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqEFnFcT 
#endif

#ifdef qEFnT
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqEFnT 
#endif

#ifdef qEFnVc
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmqEFnVc 
#endif

#ifdef qEFnVcT
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqEFnVcT 
#endif

#ifdef qET
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmqET 
#endif

#ifdef qEVc
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmqEVc 
#endif

#ifdef qEVcT
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqEVcT 
#endif

#ifdef qEVn
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmqEVn 
#endif

#ifdef qEVnFc
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqEVnFc 
#endif

#ifdef qEVnFcT
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqEVnFcT 
#endif

#ifdef qEVnT
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmqEVnT 
#endif

#ifdef qEVnVc
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmqEVnVc 
#endif

#ifdef qEVnVcT
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqEVnVcT 
#endif

#ifdef tE
    #define EXTERNAL
    #define FUNCTION    rmtE 
#endif

#ifdef tEFc
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmtEFc 
#endif

#ifdef tEFcT
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtEFcT 
#endif

#ifdef tEFn
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmtEFn 
#endif

#ifdef tEFnFc
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtEFnFc 
#endif

#ifdef tEFnFcT
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtEFnFcT 
#endif

#ifdef tEFnT
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtEFnT 
#endif

#ifdef tEFnVc
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmtEFnVc 
#endif

#ifdef tEFnVcT
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtEFnVcT 
#endif

#ifdef tET
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmtET 
#endif

#ifdef tEVc
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmtEVc 
#endif

#ifdef tEVcT
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtEVcT 
#endif

#ifdef tEVn
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmtEVn 
#endif

#ifdef tEVnFc
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtEVnFc 
#endif

#ifdef tEVnFcT
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtEVnFcT 
#endif

#ifdef tEVnT
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmtEVnT 
#endif

#ifdef tEVnVc
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmtEVnVc 
#endif

#ifdef tEVnVcT
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtEVnVcT 
#endif

#ifdef mE2
    #define BY_TWO
    #define EXTERNAL
    #define FUNCTION    rmmE2 
#endif

#ifdef mE2Fc
    #define BY_TWO
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmmE2Fc 
#endif

#ifdef mE2FcT
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmE2FcT 
#endif

#ifdef mE2Fn
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmmE2Fn 
#endif

#ifdef mE2FnFc
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmE2FnFc 
#endif

#ifdef mE2FnFcT
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmE2FnFcT 
#endif

#ifdef mE2FnT
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmE2FnT 
#endif

#ifdef mE2FnVc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmmE2FnVc 
#endif

#ifdef mE2FnVcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmE2FnVcT 
#endif

#ifdef mE2T
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmmE2T 
#endif

#ifdef mE2Vc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmmE2Vc 
#endif

#ifdef mE2VcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmE2VcT 
#endif

#ifdef mE2Vn
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmmE2Vn 
#endif

#ifdef mE2VnFc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmE2VnFc 
#endif

#ifdef mE2VnFcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmE2VnFcT 
#endif

#ifdef mE2VnT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmmE2VnT 
#endif

#ifdef mE2VnVc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmmE2VnVc 
#endif

#ifdef mE2VnVcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmE2VnVcT 
#endif

#ifdef pE2
    #define BY_TWO
    #define EXTERNAL
    #define FUNCTION    rmpE2 
#endif

#ifdef pE2Fc
    #define BY_TWO
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmpE2Fc 
#endif

#ifdef pE2FcT
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpE2FcT 
#endif

#ifdef pE2Fn
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmpE2Fn 
#endif

#ifdef pE2FnFc
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpE2FnFc 
#endif

#ifdef pE2FnFcT
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpE2FnFcT 
#endif

#ifdef pE2FnT
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpE2FnT 
#endif

#ifdef pE2FnVc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmpE2FnVc 
#endif

#ifdef pE2FnVcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpE2FnVcT 
#endif

#ifdef pE2T
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmpE2T 
#endif

#ifdef pE2Vc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmpE2Vc 
#endif

#ifdef pE2VcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpE2VcT 
#endif

#ifdef pE2Vn
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmpE2Vn 
#endif

#ifdef pE2VnFc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpE2VnFc 
#endif

#ifdef pE2VnFcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpE2VnFcT 
#endif

#ifdef pE2VnT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmpE2VnT 
#endif

#ifdef pE2VnVc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmpE2VnVc 
#endif

#ifdef pE2VnVcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpE2VnVcT 
#endif

#ifdef qE2
    #define BY_TWO
    #define EXTERNAL
    #define FUNCTION    rmqE2 
#endif

#ifdef qE2Fc
    #define BY_TWO
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmqE2Fc 
#endif

#ifdef qE2FcT
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqE2FcT 
#endif

#ifdef qE2Fn
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmqE2Fn 
#endif

#ifdef qE2FnFc
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqE2FnFc 
#endif

#ifdef qE2FnFcT
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqE2FnFcT 
#endif

#ifdef qE2FnT
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqE2FnT 
#endif

#ifdef qE2FnVc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmqE2FnVc 
#endif

#ifdef qE2FnVcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqE2FnVcT 
#endif

#ifdef qE2T
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmqE2T 
#endif

#ifdef qE2Vc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmqE2Vc 
#endif

#ifdef qE2VcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqE2VcT 
#endif

#ifdef qE2Vn
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmqE2Vn 
#endif

#ifdef qE2VnFc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqE2VnFc 
#endif

#ifdef qE2VnFcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqE2VnFcT 
#endif

#ifdef qE2VnT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmqE2VnT 
#endif

#ifdef qE2VnVc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmqE2VnVc 
#endif

#ifdef qE2VnVcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqE2VnVcT 
#endif

#ifdef tE2
    #define BY_TWO
    #define EXTERNAL
    #define FUNCTION    rmtE2 
#endif

#ifdef tE2Fc
    #define BY_TWO
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmtE2Fc 
#endif

#ifdef tE2FcT
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtE2FcT 
#endif

#ifdef tE2Fn
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmtE2Fn 
#endif

#ifdef tE2FnFc
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtE2FnFc 
#endif

#ifdef tE2FnFcT
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtE2FnFcT 
#endif

#ifdef tE2FnT
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtE2FnT 
#endif

#ifdef tE2FnVc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmtE2FnVc 
#endif

#ifdef tE2FnVcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtE2FnVcT 
#endif

#ifdef tE2T
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmtE2T 
#endif

#ifdef tE2Vc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmtE2Vc 
#endif

#ifdef tE2VcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtE2VcT 
#endif

#ifdef tE2Vn
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmtE2Vn 
#endif

#ifdef tE2VnFc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtE2VnFc 
#endif

#ifdef tE2VnFcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtE2VnFcT 
#endif

#ifdef tE2VnT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmtE2VnT 
#endif

#ifdef tE2VnVc
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmtE2VnVc 
#endif

#ifdef tE2VnVcT
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtE2VnVcT 
#endif





/* Start of FUNCTION_CALLS additions  */



#ifdef pC4NB
    #define COLOR4
    #define FUNCTION    rmpC4NB 
#endif

#ifdef pC4NBFc
    #define COLOR4
    #define FACET_COLOR
    #define FUNCTION    rmpC4NBFc 
#endif

#ifdef pC4NBFcT
    #define COLOR4
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4NBFcT 
#endif

#ifdef pC4NBFn
    #define COLOR4
    #define FACET_NORM
    #define FUNCTION    rmpC4NBFn 
#endif

#ifdef pC4NBFnFc
    #define COLOR4
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpC4NBFnFc 
#endif

#ifdef pC4NBFnFcT
    #define COLOR4
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4NBFnFcT 
#endif

#ifdef pC4NBFnT
    #define COLOR4
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4NBFnT 
#endif

#ifdef pC4NBFnVc
    #define COLOR4
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmpC4NBFnVc 
#endif

#ifdef pC4NBFnVcT
    #define COLOR4
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4NBFnVcT 
#endif

#ifdef pC4NBT
    #define COLOR4
    #define TEXTURE
    #define FUNCTION    rmpC4NBT 
#endif

#ifdef pC4NBVc
    #define COLOR4
    #define VERT_COLOR
    #define FUNCTION    rmpC4NBVc 
#endif

#ifdef pC4NBVcT
    #define COLOR4
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpC4NBVcT 
#endif

#ifdef pC4NBVn
    #define COLOR4
    #define VERT_NORM
    #define FUNCTION    rmpC4NBVn 
#endif

#ifdef pC4NBVnFc
    #define COLOR4
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpC4NBVnFc 
#endif

#ifdef pC4NBVnFcT
    #define COLOR4
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4NBVnFcT 
#endif

#ifdef pC4NBVnT
    #define COLOR4
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4NBVnT 
#endif

#ifdef pC4NBVnVc
    #define COLOR4
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmpC4NBVnVc 
#endif

#ifdef pC4NBVnVcT
    #define COLOR4
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpC4NBVnVcT 
#endif

#ifdef mC4NB
    #define COLOR4
    #define FUNCTION    rmmC4NB 
#endif

#ifdef mC4NBFc
    #define COLOR4
    #define FACET_COLOR
    #define FUNCTION    rmmC4NBFc 
#endif

#ifdef mC4NBFcT
    #define COLOR4
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4NBFcT 
#endif

#ifdef mC4NBFn
    #define COLOR4
    #define FACET_NORM
    #define FUNCTION    rmmC4NBFn 
#endif

#ifdef mC4NBFnFc
    #define COLOR4
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmC4NBFnFc 
#endif

#ifdef mC4NBFnFcT
    #define COLOR4
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4NBFnFcT 
#endif

#ifdef mC4NBFnT
    #define COLOR4
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4NBFnT 
#endif

#ifdef mC4NBFnVc
    #define COLOR4
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmmC4NBFnVc 
#endif

#ifdef mC4NBFnVcT
    #define COLOR4
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4NBFnVcT 
#endif

#ifdef mC4NBT
    #define COLOR4
    #define TEXTURE
    #define FUNCTION    rmmC4NBT 
#endif

#ifdef mC4NBVc
    #define COLOR4
    #define VERT_COLOR
    #define FUNCTION    rmmC4NBVc 
#endif

#ifdef mC4NBVcT
    #define COLOR4
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmC4NBVcT 
#endif

#ifdef mC4NBVn
    #define COLOR4
    #define VERT_NORM
    #define FUNCTION    rmmC4NBVn 
#endif

#ifdef mC4NBVnFc
    #define COLOR4
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmC4NBVnFc 
#endif

#ifdef mC4NBVnFcT
    #define COLOR4
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4NBVnFcT 
#endif

#ifdef mC4NBVnT
    #define COLOR4
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4NBVnT 
#endif

#ifdef mC4NBVnVc
    #define COLOR4
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmmC4NBVnVc 
#endif

#ifdef mC4NBVnVcT
    #define COLOR4
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmC4NBVnVcT 
#endif

#ifdef pC4B
    #define COLOR4
    #define BATCH
    #define FUNCTION    rmpC4B 
#endif

#ifdef pC4BFc
    #define COLOR4
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmpC4BFc 
#endif

#ifdef pC4BFcT
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4BFcT 
#endif

#ifdef pC4BFn
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmpC4BFn 
#endif

#ifdef pC4BFnFc
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpC4BFnFc 
#endif

#ifdef pC4BFnFcT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4BFnFcT 
#endif

#ifdef pC4BFnT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4BFnT 
#endif

#ifdef pC4BFnVc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmpC4BFnVc 
#endif

#ifdef pC4BFnVcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4BFnVcT 
#endif

#ifdef pC4BT
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmpC4BT 
#endif

#ifdef pC4BVc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmpC4BVc 
#endif

#ifdef pC4BVcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpC4BVcT 
#endif

#ifdef pC4BVn
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmpC4BVn 
#endif

#ifdef pC4BVnFc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpC4BVnFc 
#endif

#ifdef pC4BVnFcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4BVnFcT 
#endif

#ifdef pC4BVnT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4BVnT 
#endif

#ifdef pC4BVnVc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmpC4BVnVc 
#endif

#ifdef pC4BVnVcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpC4BVnVcT 
#endif

#ifdef pC4B2
    #define COLOR4
    #define BATCH
    #define FUNCTION    rmpC4B2 
    #define BY_TWO
#endif

#ifdef pC4B2Fc
    #define COLOR4
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmpC4B2Fc 
    #define BY_TWO
#endif

#ifdef pC4B2FcT
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4B2FcT 
    #define BY_TWO
#endif

#ifdef pC4B2Fn
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmpC4B2Fn 
    #define BY_TWO
#endif

#ifdef pC4B2FnFc
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpC4B2FnFc 
    #define BY_TWO
#endif

#ifdef pC4B2FnFcT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4B2FnFcT 
    #define BY_TWO
#endif

#ifdef pC4B2FnT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4B2FnT 
    #define BY_TWO
#endif

#ifdef pC4B2FnVc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmpC4B2FnVc 
    #define BY_TWO
#endif

#ifdef pC4B2FnVcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4B2FnVcT 
    #define BY_TWO
#endif

#ifdef pC4B2T
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmpC4B2T 
    #define BY_TWO
#endif

#ifdef pC4B2Vc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmpC4B2Vc 
    #define BY_TWO
#endif

#ifdef pC4B2VcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpC4B2VcT 
    #define BY_TWO
#endif

#ifdef pC4B2Vn
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmpC4B2Vn 
    #define BY_TWO
#endif

#ifdef pC4B2VnFc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpC4B2VnFc 
    #define BY_TWO
#endif

#ifdef pC4B2VnFcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4B2VnFcT 
    #define BY_TWO
#endif

#ifdef pC4B2VnT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4B2VnT 
    #define BY_TWO
#endif

#ifdef pC4B2VnVc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmpC4B2VnVc 
    #define BY_TWO
#endif

#ifdef pC4B2VnVcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpC4B2VnVcT 
    #define BY_TWO
#endif

#ifdef mC4B2
    #define COLOR4
    #define BATCH
    #define FUNCTION    rmmC4B2 
    #define BY_TWO
#endif

#ifdef mC4B2Fc
    #define COLOR4
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmmC4B2Fc 
    #define BY_TWO
#endif

#ifdef mC4B2FcT
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4B2FcT 
    #define BY_TWO
#endif

#ifdef mC4B2Fn
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmmC4B2Fn 
    #define BY_TWO
#endif

#ifdef mC4B2FnFc
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmC4B2FnFc 
    #define BY_TWO
#endif

#ifdef mC4B2FnFcT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4B2FnFcT 
    #define BY_TWO
#endif

#ifdef mC4B2FnT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4B2FnT 
    #define BY_TWO
#endif

#ifdef mC4B2FnVc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmmC4B2FnVc 
    #define BY_TWO
#endif

#ifdef mC4B2FnVcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4B2FnVcT 
    #define BY_TWO
#endif

#ifdef mC4B2T
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmmC4B2T 
    #define BY_TWO
#endif

#ifdef mC4B2Vc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmmC4B2Vc 
    #define BY_TWO
#endif

#ifdef mC4B2VcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmC4B2VcT 
    #define BY_TWO
#endif

#ifdef mC4B2Vn
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmmC4B2Vn 
    #define BY_TWO
#endif

#ifdef mC4B2VnFc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmC4B2VnFc 
    #define BY_TWO
#endif

#ifdef mC4B2VnFcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4B2VnFcT 
    #define BY_TWO
#endif

#ifdef mC4B2VnT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4B2VnT 
    #define BY_TWO
#endif

#ifdef mC4B2VnVc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmmC4B2VnVc 
    #define BY_TWO
#endif

#ifdef mC4B2VnVcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmC4B2VnVcT 
    #define BY_TWO
#endif

#ifdef qC4NB
    #define COLOR4
    #define FUNCTION    rmqC4NB 
#endif

#ifdef qC4NBFc
    #define COLOR4
    #define FACET_COLOR
    #define FUNCTION    rmqC4NBFc 
#endif

#ifdef qC4NBFcT
    #define COLOR4
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4NBFcT 
#endif

#ifdef qC4NBFn
    #define COLOR4
    #define FACET_NORM
    #define FUNCTION    rmqC4NBFn 
#endif

#ifdef qC4NBFnFc
    #define COLOR4
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqC4NBFnFc 
#endif

#ifdef qC4NBFnFcT
    #define COLOR4
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4NBFnFcT 
#endif

#ifdef qC4NBFnT
    #define COLOR4
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4NBFnT 
#endif

#ifdef qC4NBFnVc
    #define COLOR4
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmqC4NBFnVc 
#endif

#ifdef qC4NBFnVcT
    #define COLOR4
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4NBFnVcT 
#endif

#ifdef qC4NBT
    #define COLOR4
    #define TEXTURE
    #define FUNCTION    rmqC4NBT 
#endif

#ifdef qC4NBVc
    #define COLOR4
    #define VERT_COLOR
    #define FUNCTION    rmqC4NBVc 
#endif

#ifdef qC4NBVcT
    #define COLOR4
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqC4NBVcT 
#endif

#ifdef qC4NBVn
    #define COLOR4
    #define VERT_NORM
    #define FUNCTION    rmqC4NBVn 
#endif

#ifdef qC4NBVnFc
    #define COLOR4
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqC4NBVnFc 
#endif

#ifdef qC4NBVnFcT
    #define COLOR4
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4NBVnFcT 
#endif

#ifdef qC4NBVnT
    #define COLOR4
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4NBVnT 
#endif

#ifdef qC4NBVnVc
    #define COLOR4
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmqC4NBVnVc 
#endif

#ifdef qC4NBVnVcT
    #define COLOR4
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqC4NBVnVcT 
#endif

#ifdef qC4B
    #define COLOR4
    #define BATCH
    #define FUNCTION    rmqC4B 
#endif

#ifdef qC4BFc
    #define COLOR4
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmqC4BFc 
#endif

#ifdef qC4BFcT
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4BFcT 
#endif

#ifdef qC4BFn
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmqC4BFn 
#endif

#ifdef qC4BFnFc
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqC4BFnFc 
#endif

#ifdef qC4BFnFcT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4BFnFcT 
#endif

#ifdef qC4BFnT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4BFnT 
#endif

#ifdef qC4BFnVc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmqC4BFnVc 
#endif

#ifdef qC4BFnVcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4BFnVcT 
#endif

#ifdef qC4BT
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmqC4BT 
#endif

#ifdef qC4BVc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmqC4BVc 
#endif

#ifdef qC4BVcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqC4BVcT 
#endif

#ifdef qC4BVn
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmqC4BVn 
#endif

#ifdef qC4BVnFc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqC4BVnFc 
#endif

#ifdef qC4BVnFcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4BVnFcT 
#endif

#ifdef qC4BVnT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4BVnT 
#endif

#ifdef qC4BVnVc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmqC4BVnVc 
#endif

#ifdef qC4BVnVcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqC4BVnVcT 
#endif

#ifdef qC4B2
    #define COLOR4
    #define BATCH
    #define FUNCTION    rmqC4B2 
    #define BY_TWO
#endif

#ifdef qC4B2Fc
    #define COLOR4
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmqC4B2Fc 
    #define BY_TWO
#endif

#ifdef qC4B2FcT
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4B2FcT 
    #define BY_TWO
#endif

#ifdef qC4B2Fn
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmqC4B2Fn 
    #define BY_TWO
#endif

#ifdef qC4B2FnFc
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqC4B2FnFc 
    #define BY_TWO
#endif

#ifdef qC4B2FnFcT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4B2FnFcT 
    #define BY_TWO
#endif

#ifdef qC4B2FnT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4B2FnT 
    #define BY_TWO
#endif

#ifdef qC4B2FnVc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmqC4B2FnVc 
    #define BY_TWO
#endif

#ifdef qC4B2FnVcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4B2FnVcT 
    #define BY_TWO
#endif

#ifdef qC4B2T
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmqC4B2T 
    #define BY_TWO
#endif

#ifdef qC4B2Vc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmqC4B2Vc 
    #define BY_TWO
#endif

#ifdef qC4B2VcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqC4B2VcT 
    #define BY_TWO
#endif

#ifdef qC4B2Vn
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmqC4B2Vn 
    #define BY_TWO
#endif

#ifdef qC4B2VnFc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqC4B2VnFc 
    #define BY_TWO
#endif

#ifdef qC4B2VnFcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4B2VnFcT 
    #define BY_TWO
#endif

#ifdef qC4B2VnT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4B2VnT 
    #define BY_TWO
#endif

#ifdef qC4B2VnVc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmqC4B2VnVc 
    #define BY_TWO
#endif

#ifdef qC4B2VnVcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqC4B2VnVcT 
    #define BY_TWO
#endif

#ifdef tC4NB
    #define COLOR4
    #define FUNCTION    rmtC4NB 
#endif

#ifdef tC4NBFc
    #define COLOR4
    #define FACET_COLOR
    #define FUNCTION    rmtC4NBFc 
#endif

#ifdef tC4NBFcT
    #define COLOR4
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4NBFcT 
#endif

#ifdef tC4NBFn
    #define COLOR4
    #define FACET_NORM
    #define FUNCTION    rmtC4NBFn 
#endif

#ifdef tC4NBFnFc
    #define COLOR4
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtC4NBFnFc 
#endif

#ifdef tC4NBFnFcT
    #define COLOR4
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4NBFnFcT 
#endif

#ifdef tC4NBFnT
    #define COLOR4
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4NBFnT 
#endif

#ifdef tC4NBFnVc
    #define COLOR4
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmtC4NBFnVc 
#endif

#ifdef tC4NBFnVcT
    #define COLOR4
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4NBFnVcT 
#endif

#ifdef tC4NBT
    #define COLOR4
    #define TEXTURE
    #define FUNCTION    rmtC4NBT 
#endif

#ifdef tC4NBVc
    #define COLOR4
    #define VERT_COLOR
    #define FUNCTION    rmtC4NBVc 
#endif

#ifdef tC4NBVcT
    #define COLOR4
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtC4NBVcT 
#endif

#ifdef tC4NBVn
    #define COLOR4
    #define VERT_NORM
    #define FUNCTION    rmtC4NBVn 
#endif

#ifdef tC4NBVnFc
    #define COLOR4
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtC4NBVnFc 
#endif

#ifdef tC4NBVnFcT
    #define COLOR4
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4NBVnFcT 
#endif

#ifdef tC4NBVnT
    #define COLOR4
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4NBVnT 
#endif

#ifdef tC4NBVnVc
    #define COLOR4
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmtC4NBVnVc 
#endif

#ifdef tC4NBVnVcT
    #define COLOR4
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtC4NBVnVcT 
#endif

#ifdef tC4B
    #define COLOR4
    #define BATCH
    #define FUNCTION    rmtC4B 
#endif

#ifdef tC4BFc
    #define COLOR4
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmtC4BFc 
#endif

#ifdef tC4BFcT
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4BFcT 
#endif

#ifdef tC4BFn
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmtC4BFn 
#endif

#ifdef tC4BFnFc
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtC4BFnFc 
#endif

#ifdef tC4BFnFcT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4BFnFcT 
#endif

#ifdef tC4BFnT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4BFnT 
#endif

#ifdef tC4BFnVc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmtC4BFnVc 
#endif

#ifdef tC4BFnVcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4BFnVcT 
#endif

#ifdef tC4BT
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmtC4BT 
#endif

#ifdef tC4BVc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmtC4BVc 
#endif

#ifdef tC4BVcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtC4BVcT 
#endif

#ifdef tC4BVn
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmtC4BVn 
#endif

#ifdef tC4BVnFc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtC4BVnFc 
#endif

#ifdef tC4BVnFcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4BVnFcT 
#endif

#ifdef tC4BVnT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4BVnT 
#endif

#ifdef tC4BVnVc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmtC4BVnVc 
#endif

#ifdef tC4BVnVcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtC4BVnVcT 
#endif

#ifdef tC4B2
    #define COLOR4
    #define BATCH
    #define FUNCTION    rmtC4B2 
    #define BY_TWO
#endif

#ifdef tC4B2Fc
    #define COLOR4
    #define BATCH
    #define FACET_COLOR
    #define FUNCTION    rmtC4B2Fc 
    #define BY_TWO
#endif

#ifdef tC4B2FcT
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4B2FcT 
    #define BY_TWO
#endif

#ifdef tC4B2Fn
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FUNCTION    rmtC4B2Fn 
    #define BY_TWO
#endif

#ifdef tC4B2FnFc
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtC4B2FnFc 
    #define BY_TWO
#endif

#ifdef tC4B2FnFcT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4B2FnFcT 
    #define BY_TWO
#endif

#ifdef tC4B2FnT
    #define COLOR4
    #define BATCH
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4B2FnT 
    #define BY_TWO
#endif

#ifdef tC4B2FnVc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmtC4B2FnVc 
    #define BY_TWO
#endif

#ifdef tC4B2FnVcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4B2FnVcT 
    #define BY_TWO
#endif

#ifdef tC4B2T
    #define COLOR4
    #define BATCH
    #define TEXTURE
    #define FUNCTION    rmtC4B2T 
    #define BY_TWO
#endif

#ifdef tC4B2Vc
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define FUNCTION    rmtC4B2Vc 
    #define BY_TWO
#endif

#ifdef tC4B2VcT
    #define COLOR4
    #define BATCH
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtC4B2VcT 
    #define BY_TWO
#endif

#ifdef tC4B2Vn
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FUNCTION    rmtC4B2Vn 
    #define BY_TWO
#endif

#ifdef tC4B2VnFc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtC4B2VnFc 
    #define BY_TWO
#endif

#ifdef tC4B2VnFcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4B2VnFcT 
    #define BY_TWO
#endif

#ifdef tC4B2VnT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4B2VnT 
    #define BY_TWO
#endif

#ifdef tC4B2VnVc
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmtC4B2VnVc 
    #define BY_TWO
#endif

#ifdef tC4B2VnVcT
    #define COLOR4
    #define BATCH
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtC4B2VnVcT 
    #define BY_TWO
#endif

#ifdef mC4E
    #define COLOR4
    #define EXTERNAL
    #define FUNCTION    rmmC4E 
#endif

#ifdef mC4EFc
    #define COLOR4
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmmC4EFc 
#endif

#ifdef mC4EFcT
    #define COLOR4
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4EFcT 
#endif

#ifdef mC4EFn
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmmC4EFn 
#endif

#ifdef mC4EFnFc
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmC4EFnFc 
#endif

#ifdef mC4EFnFcT
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4EFnFcT 
#endif

#ifdef mC4EFnT
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4EFnT 
#endif

#ifdef mC4EFnVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmmC4EFnVc 
#endif

#ifdef mC4EFnVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4EFnVcT 
#endif

#ifdef mC4ET
    #define COLOR4
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmmC4ET 
#endif

#ifdef mC4EVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmmC4EVc 
#endif

#ifdef mC4EVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmC4EVcT 
#endif

#ifdef mC4EVn
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmmC4EVn 
#endif

#ifdef mC4EVnFc
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmC4EVnFc 
#endif

#ifdef mC4EVnFcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4EVnFcT 
#endif

#ifdef mC4EVnT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4EVnT 
#endif

#ifdef mC4EVnVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmmC4EVnVc 
#endif

#ifdef mC4EVnVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmC4EVnVcT 
#endif

#ifdef pC4E
    #define COLOR4
    #define EXTERNAL
    #define FUNCTION    rmpC4E 
#endif

#ifdef pC4EFc
    #define COLOR4
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmpC4EFc 
#endif

#ifdef pC4EFcT
    #define COLOR4
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4EFcT 
#endif

#ifdef pC4EFn
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmpC4EFn 
#endif

#ifdef pC4EFnFc
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpC4EFnFc 
#endif

#ifdef pC4EFnFcT
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4EFnFcT 
#endif

#ifdef pC4EFnT
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4EFnT 
#endif

#ifdef pC4EFnVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmpC4EFnVc 
#endif

#ifdef pC4EFnVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4EFnVcT 
#endif

#ifdef pC4ET
    #define COLOR4
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmpC4ET 
#endif

#ifdef pC4EVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmpC4EVc 
#endif

#ifdef pC4EVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpC4EVcT 
#endif

#ifdef pC4EVn
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmpC4EVn 
#endif

#ifdef pC4EVnFc
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpC4EVnFc 
#endif

#ifdef pC4EVnFcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4EVnFcT 
#endif

#ifdef pC4EVnT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4EVnT 
#endif

#ifdef pC4EVnVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmpC4EVnVc 
#endif

#ifdef pC4EVnVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpC4EVnVcT 
#endif

#ifdef qC4E
    #define COLOR4
    #define EXTERNAL
    #define FUNCTION    rmqC4E 
#endif

#ifdef qC4EFc
    #define COLOR4
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmqC4EFc 
#endif

#ifdef qC4EFcT
    #define COLOR4
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4EFcT 
#endif

#ifdef qC4EFn
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmqC4EFn 
#endif

#ifdef qC4EFnFc
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqC4EFnFc 
#endif

#ifdef qC4EFnFcT
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4EFnFcT 
#endif

#ifdef qC4EFnT
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4EFnT 
#endif

#ifdef qC4EFnVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmqC4EFnVc 
#endif

#ifdef qC4EFnVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4EFnVcT 
#endif

#ifdef qC4ET
    #define COLOR4
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmqC4ET 
#endif

#ifdef qC4EVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmqC4EVc 
#endif

#ifdef qC4EVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqC4EVcT 
#endif

#ifdef qC4EVn
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmqC4EVn 
#endif

#ifdef qC4EVnFc
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqC4EVnFc 
#endif

#ifdef qC4EVnFcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4EVnFcT 
#endif

#ifdef qC4EVnT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4EVnT 
#endif

#ifdef qC4EVnVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmqC4EVnVc 
#endif

#ifdef qC4EVnVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqC4EVnVcT 
#endif

#ifdef tC4E
    #define COLOR4
    #define EXTERNAL
    #define FUNCTION    rmtC4E 
#endif

#ifdef tC4EFc
    #define COLOR4
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmtC4EFc 
#endif

#ifdef tC4EFcT
    #define COLOR4
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4EFcT 
#endif

#ifdef tC4EFn
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmtC4EFn 
#endif

#ifdef tC4EFnFc
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtC4EFnFc 
#endif

#ifdef tC4EFnFcT
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4EFnFcT 
#endif

#ifdef tC4EFnT
    #define COLOR4
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4EFnT 
#endif

#ifdef tC4EFnVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmtC4EFnVc 
#endif

#ifdef tC4EFnVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4EFnVcT 
#endif

#ifdef tC4ET
    #define COLOR4
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmtC4ET 
#endif

#ifdef tC4EVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmtC4EVc 
#endif

#ifdef tC4EVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtC4EVcT 
#endif

#ifdef tC4EVn
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmtC4EVn 
#endif

#ifdef tC4EVnFc
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtC4EVnFc 
#endif

#ifdef tC4EVnFcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4EVnFcT 
#endif

#ifdef tC4EVnT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4EVnT 
#endif

#ifdef tC4EVnVc
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmtC4EVnVc 
#endif

#ifdef tC4EVnVcT
    #define COLOR4
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtC4EVnVcT 
#endif

#ifdef mC4E2
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FUNCTION    rmmC4E2 
#endif

#ifdef mC4E2Fc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmmC4E2Fc 
#endif

#ifdef mC4E2FcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4E2FcT 
#endif

#ifdef mC4E2Fn
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmmC4E2Fn 
#endif

#ifdef mC4E2FnFc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmC4E2FnFc 
#endif

#ifdef mC4E2FnFcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4E2FnFcT 
#endif

#ifdef mC4E2FnT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4E2FnT 
#endif

#ifdef mC4E2FnVc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmmC4E2FnVc 
#endif

#ifdef mC4E2FnVcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4E2FnVcT 
#endif

#ifdef mC4E2T
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmmC4E2T 
#endif

#ifdef mC4E2Vc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmmC4E2Vc 
#endif

#ifdef mC4E2VcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmC4E2VcT 
#endif

#ifdef mC4E2Vn
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmmC4E2Vn 
#endif

#ifdef mC4E2VnFc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmmC4E2VnFc 
#endif

#ifdef mC4E2VnFcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmmC4E2VnFcT 
#endif

#ifdef mC4E2VnT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmmC4E2VnT 
#endif

#ifdef mC4E2VnVc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmmC4E2VnVc 
#endif

#ifdef mC4E2VnVcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmmC4E2VnVcT 
#endif

#ifdef pC4E2
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FUNCTION    rmpC4E2 
#endif

#ifdef pC4E2Fc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmpC4E2Fc 
#endif

#ifdef pC4E2FcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4E2FcT 
#endif

#ifdef pC4E2Fn
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmpC4E2Fn 
#endif

#ifdef pC4E2FnFc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpC4E2FnFc 
#endif

#ifdef pC4E2FnFcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4E2FnFcT 
#endif

#ifdef pC4E2FnT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4E2FnT 
#endif

#ifdef pC4E2FnVc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmpC4E2FnVc 
#endif

#ifdef pC4E2FnVcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4E2FnVcT 
#endif

#ifdef pC4E2T
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmpC4E2T 
#endif

#ifdef pC4E2Vc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmpC4E2Vc 
#endif

#ifdef pC4E2VcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpC4E2VcT 
#endif

#ifdef pC4E2Vn
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmpC4E2Vn 
#endif

#ifdef pC4E2VnFc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmpC4E2VnFc 
#endif

#ifdef pC4E2VnFcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmpC4E2VnFcT 
#endif

#ifdef pC4E2VnT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmpC4E2VnT 
#endif

#ifdef pC4E2VnVc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmpC4E2VnVc 
#endif

#ifdef pC4E2VnVcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmpC4E2VnVcT 
#endif

#ifdef qC4E2
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FUNCTION    rmqC4E2 
#endif

#ifdef qC4E2Fc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmqC4E2Fc 
#endif

#ifdef qC4E2FcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4E2FcT 
#endif

#ifdef qC4E2Fn
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmqC4E2Fn 
#endif

#ifdef qC4E2FnFc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqC4E2FnFc 
#endif

#ifdef qC4E2FnFcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4E2FnFcT 
#endif

#ifdef qC4E2FnT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4E2FnT 
#endif

#ifdef qC4E2FnVc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmqC4E2FnVc 
#endif

#ifdef qC4E2FnVcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4E2FnVcT 
#endif

#ifdef qC4E2T
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmqC4E2T 
#endif

#ifdef qC4E2Vc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmqC4E2Vc 
#endif

#ifdef qC4E2VcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqC4E2VcT 
#endif

#ifdef qC4E2Vn
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmqC4E2Vn 
#endif

#ifdef qC4E2VnFc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmqC4E2VnFc 
#endif

#ifdef qC4E2VnFcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmqC4E2VnFcT 
#endif

#ifdef qC4E2VnT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmqC4E2VnT 
#endif

#ifdef qC4E2VnVc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmqC4E2VnVc 
#endif

#ifdef qC4E2VnVcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmqC4E2VnVcT 
#endif

#ifdef tC4E2
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FUNCTION    rmtC4E2 
#endif

#ifdef tC4E2Fc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_COLOR
    #define FUNCTION    rmtC4E2Fc 
#endif

#ifdef tC4E2FcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4E2FcT 
#endif

#ifdef tC4E2Fn
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FUNCTION    rmtC4E2Fn 
#endif

#ifdef tC4E2FnFc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtC4E2FnFc 
#endif

#ifdef tC4E2FnFcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4E2FnFcT 
#endif

#ifdef tC4E2FnT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4E2FnT 
#endif

#ifdef tC4E2FnVc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define FUNCTION    rmtC4E2FnVc 
#endif

#ifdef tC4E2FnVcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FACET_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4E2FnVcT 
#endif

#ifdef tC4E2T
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define TEXTURE
    #define FUNCTION    rmtC4E2T 
#endif

#ifdef tC4E2Vc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define FUNCTION    rmtC4E2Vc 
#endif

#ifdef tC4E2VcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtC4E2VcT 
#endif

#ifdef tC4E2Vn
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FUNCTION    rmtC4E2Vn 
#endif

#ifdef tC4E2VnFc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define FACET_COLOR
    #define FUNCTION    rmtC4E2VnFc 
#endif

#ifdef tC4E2VnFcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FACET_COLOR
    #define FUNCTION    rmtC4E2VnFcT 
#endif

#ifdef tC4E2VnT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define TEXTURE
    #define FUNCTION    rmtC4E2VnT 
#endif

#ifdef tC4E2VnVc
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define FUNCTION    rmtC4E2VnVc 
#endif

#ifdef tC4E2VnVcT
    #define COLOR4
    #define BY_TWO
    #define EXTERNAL
    #define VERT_NORM
    #define VERT_COLOR
    #define TEXTURE
    #define FUNCTION    rmtC4E2VnVcT 
#endif
