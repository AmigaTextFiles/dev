#ifndef	GRAPHICS_DISPLAY_H
#define	GRAPHICS_DISPLAY_H


#define MODE_640    $8000
#define PLNCNTMSK   $7	    
				    
#define PLNCNTSHFT  12		    
#define PF2PRI	    $40	    
#define COLORON     $0200	    
#define DBLPF	    $400
#define HOLDNMODIFY $800
#define INTERLACE   4		    

#define PFA_FINE_SCROLL       $F
#define PFB_FINE_SCROLL_SHIFT 4
#define PF_FINE_SCROLL_MASK   $F

#define DIW_HORIZ_POS	$7F	   
#define DIW_VRTCL_POS	$1FF	   
#define DIW_VRTCL_POS_SHIFT 7

#define DFTCH_MASK	$FF

#define VPOSRLOF	$8000
#endif	
