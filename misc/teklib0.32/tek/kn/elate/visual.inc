
;=============================================================================
;-----------------------------------------------------------------------------
;
;	elate visual internal
;
;-----------------------------------------------------------------------------
;=============================================================================

	.include 'taort'

;-----------------------------------------------------------------------------

structure
	pointer	vis_buffer
	pointer	vis_buffer2
	pointer vis_pixmap
	pointer vis_pixmap2
	pointer	vis_ave
	pointer	vis_app
	pointer vis_toolkit
	pointer	vis_window
	pointer vis_scrollpane
	pointer vis_content
	pointer	vis_font
	int32	vis_backcolor
	int32	vis_width
	int32	vis_height
	int32	vis_fontwidth
	int32	vis_fontheight
	int32	vis_pixelx
	int32	vis_pixely
	int32	vis_bgcolor
	int32	vis_fgcolor
	int32	vis_textx
	int32	vis_texty

	int32		vis_currentbuttonstate

	int32		vis_pendingevent;
	int32		vis_pendingx;
	int32		vis_pendingy;
	int32		vis_pendingkeycooked;
	int32		vis_pendingresize;
	int32		vis_pendingbuttonstate;
	int32		vis_evtpending;
	
size		vis_size

;-----------------------------------------------------------------------------
;=============================================================================
