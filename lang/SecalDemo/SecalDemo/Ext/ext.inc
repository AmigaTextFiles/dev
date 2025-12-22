/******************************************************************************\
**  $VER: inc/secalext/ext.inc 1.0                                            **
**  Secal Release 1.0                                                         **
**  Secal extension interface definitions                                     **
**  Copyright (c) 1996 Tibor Kulcsar & Jozsef Makrai (TDS Development)        **
\******************************************************************************/


import x_vblankcode as x_VBlankCode:ulong;
import x_vblankcnt as x_VBlankCnt:ulong;


/******************************************************************************\
****                                A U D I O                               ****
\******************************************************************************/


struct x_mus is
	private[52]:byte;
;


/******************************************************************************\
****                             G R A P H I C S                            ****
\******************************************************************************/


struct x_scr is
	private[4]:byte;

	screen:ulong;
	bmps:ulong;
	activebmp:ulong;
	viewport:ulong;
	rastport:ulong;
	bitmap:ulong;
	width,height:word;
	depth:word;
	rowwidth,rowdiff:word;
;


struct x_bmp is
	private[8]:byte;

	bitmap:ulong;
	width,height:word;
	depth:word;
	planes:ulong;
	rowwidth,rowdiff:word;
;


struct x_ani is
	private1[4]:byte;

	width,height:word;
	depth:word;
	numframes:word;

	private2[14]:byte;

	camg:ulong;
	looping:word;
	frame:word;

	private3[4]:byte;
;


struct x_sgrp is
	private1[12]:byte;

	sprarray:ulong;
	sprcount:word;

	private2[2]:byte;

	depth:word;

	private3[4]:byte;
;

def XSF_BGCLEAR=$1;
def XSF_BGIMAGE=$2;
def XSF_BGSAVE=$4;

def XSF_MPLANEMASK=$100;
def XSF_NODBLBUF=$200;


struct x_spr is
	private1[8]:byte;

	group:ulong;
	userdata:ulong;

	on:word;
	x,y:word;

	width,height:word;
	private2[28]:byte;

	sortweight:word;

	count,frame,cycle:word;

	private3[48]:byte;
;


struct x_sgfx is
	width,height:word;
	gfx:ulong;
	fduration,numframes:word;
	cx,cy,cw,ch:word;

	private[12]:byte;
;


/******************************************************************************\
\******************************************************************************/


pattern x_Init is									# D0=SUCCESS
call x_init;
endp;															# X_INIT



pattern x_Done is
call x_done;
endp;															# X_DONE


#*******************************************************************************


pattern x_AudioStart(_chanmask) is				# D0=SUCCESS
d0:=_chanmask;
call x_audiostart;
endp;															# X_AUDIOSTART



pattern x_Mus_New(_modul,_chanmask) is				# A0=MUSIC
safe a0:=_modul; d0:=_chanmask;;
call x_mus_new;
endp;															# X_MUS_NEW



pattern x_Mus_Load(_filename,_chanmask) is			# A0=MUSIC
safe a0:=_filename; d0:=_chanmask;;
call x_mus_load;
endp;															# X_MUS_LOAD



pattern x_Mus_Dispose(_mus) is
a0:=_mus;
call x_mus_dispose;
endp;															# X_MUS_DISPOSE



pattern x_Mus_Play(_mus,_pos) is
safe a0:=_mus; d0:=_pos;;
call x_mus_play;
endp;															# X_MUS_PLAY



pattern x_Mus_Stop(_mus) is
a0:=_mus;
call x_mus_stop;
endp;															# X_MUS_STOP



pattern x_Mus_Continue(_mus) is
a0:=_mus;
call x_mus_continue;
endp;															# X_MUS_CONTINUE



pattern x_Mus_Modify(_mus,_pos,_volume) is
safe a0:=_mus; d0:=_pos; d1:=_volume;;
call x_mus_modify;
endp;															# X_MUS_MODIFY



pattern x_PlaySound(_start,_length,_repstart,_replen,_channel,_period,_volume) is
push d2\d3\d4;

safe
	a0:=_start; d0.l:=_length; a1:=_repstart; d1.l:=_replen;
	d2:=_channel; d3:=_period; d4:=_volume;
;
call x_playsound;

pop d2\d3\d4;
endp;															# X_PLAYSOUND



pattern x_StopSound(_channel) is
d0:=_channel;
call x_stopsound;
endp;															# X_STOPSOUND



pattern x_ModifySound(_channel,_period,_volume) is
push d2;

safe d0:=_channel; d1:=_period; d2:=_volume;;
call x_modifysound;

pop d2;
endp;															# X_MODIFYSOUND



pattern x_PlaySoundQ(_pri,_start,_length,_repstart,_replen,
	_channel,_period,_volume) is
push d2\d3\d4\d5;

safe
	d0:=_pri; a0:=_start; d1.l:=_length; a1:=_repstart; d2.l:=_replen;
	d3:=_channel; d4:=_period; d5:=_volume;
;
call x_playsoundq;

pop d2\d3\d4\d5;
endp;															# X_PLAYSOUNDQ



pattern x_SetFilter(_state) is
d0:=_state;
call x_setfilter;
endp;															# X_SETFILTER


#*******************************************************************************


#																	D0=SUCCESS

pattern x_GraphicsStart is
call x_graphicsstart;
endp;															# X_GRAPHICSSTART



pattern x_Scr_Open(_mode,_width,_height,_depth,_title,_colors,_taglist) is
#																	A0=SCR
push d2\d3\a2;

safe
	d0.l:=_mode; d1:=_width; d2:=_height; d3:=_depth; a0:=_title;
	a1:=_colors; a2:=_taglist;
;
call x_scr_open;

pop d2\d3\a2;
endp;															# X_SCR_OPEN



pattern x_Scr_Close(_scr) is
a0:=_scr;
call x_scr_close;
endp;															# X_SCR_CLOSE



pattern x_Scr_AddBmp(_scr) is					# D0=SUCCESS
a0:=_scr;
call x_scr_addbmp;
endp;															# X_SCR_ADDBMP



pattern x_Scr_ActivateBmp(_scr,_index,_xoffset,_yoffset) is
safe a0:=_scr; a1.w:=_index; d0:=_xoffset; d1:=_yoffset;;
call x_scr_activatebmp;
endp;															# X_SCR_ACTIVATEBMP



pattern x_Scr_GetBmp(_scr,_index) is				# A0=X_BMP
safe a0:=_scr; d0:=_index;;
call x_scr_getbmp;
endp;															# X_SCR_GETBMP



pattern x_Scr_LoadRGB8(_scr,_colors,_start,_count) is
safe a0:=_scr; a1:=_colors; d0:=_start; d1:=_count;;
call x_scr_loadrgb8;
endp;															# X_SCR_LOADRGB8



pattern x_RGB8Intensity(_source,_count,_dest,_intensity,_target) is
push d2;

safe
	a0:=_source; d0:=_count; a1:=_dest;
	d1:=_intensity; d2.l:=_target;
;
call x_rgb8intensity;

pop d2;
endp;															# X_RGB8INTENSITY



pattern x_Bmp_Alloc(_width,_height,_depth) is			# A0=X_BMP
safe d0:=_width; d1:=_height; a0.w:=_depth;;
call x_bmp_alloc;
endp;															# X_BMP_ALLOC



pattern x_Bmp_Free(_bmp) is
a0:=_bmp;
call x_bmp_free;
endp;															# X_BMP_FREE



pattern x_Ani_New(_animdata,_looping) is        		# A0=X_ANI, A1=RBG8, D0=NUMCOLORS
safe a0:=_animdata; d0:=_looping;;
call x_ani_new;
endp;															# X_ANI_NEW



pattern x_Ani_Load(_filename,_looping) is        		# A0=X_ANI, A1=RBG8, D0=NUMCOLORS
safe a0:=_filename; d0:=_looping;;
call x_ani_load;
endp;															# X_ANI_LOAD



pattern x_Ani_Dispose(_ani) is
a0:=_ani;
call x_ani_dispose;
endp;															# X_ANI_DISPOSE



pattern x_Ani_DoFrame(_ani,_bmp,_x,_y,_scr) is			# D0=DURATION
push a2;

safe a0:=_ani; a1:=_bmp; d0:=_x; d1:=_y; a2:=_scr;;
call x_ani_doframe;

pop a2;
endp;															# X_ANI_DOFRAME



pattern x_Spr_NewGrp(_sprarray,_sprcnt,_flags,_depth) is	# A0=X_SGRP, 0
safe a0:=_sprarray; d0:=_sprcnt; d1:=_flags; a1.w:=_depth;;
call x_spr_newgrp;
endp;															# X_SPR_NEWGRP



pattern x_Spr_DisposeGrp(_sgrp) is
a0:=_sgrp;
call x_spr_disposegrp;
endp;															# X_SPR_DISPOSEGRP



pattern x_Spr_Draw(_sgrp,_destbmp,_xoffset,_yoffset) is
safe a0:=_sgrp; a1:=_destbmp; d0:=_xoffset; d1:=_yoffset;;
call x_spr_draw;
endp;															# X_SPR_DRAW



pattern x_Spr_Restore(_sgrp,_destbmp,_bgnd,_bgndwidth) is
safe a0:=_sgrp; a1:=_destbmp; d0.l:=_bgnd; d1:=_bgndwidth;;
call x_spr_restore;
endp;															# X_SPR_RESTORE



pattern x_Spr_PrepGfx(_sgfxarray,_sgrp,_count) is		# D0=SUCCESS
safe a0:=_sgfxarray; a1:=_sgrp; d0:=_count;;
call x_spr_prepgfx;
endp;															# X_SPR_PREPGFX



pattern x_Spr_UnPrepGfx(_sgfxarray,_count) is
safe a0:=_sgfxarray; d0:=_count;;
call x_spr_unprepgfx;
endp;															# X_SPR_UNPREPGFX



pattern x_Spr_ChngGfx(_sgfx,_spr,_nextframe) is
safe a0:=_sgfx; a1:=_spr; d0:=_nextframe;;
call x_spr_chnggfx;
endp;															# X_SPR_CHNGGFX



pattern x_Spr_CollChk(_mode,_spr1,_spr2) is			# D0=COLLISION
safe d0:=_mode; a0:=_spr1; a1:=_spr2;;
call x_spr_collchk;
endp;															# X_SPR_COLLCHK



pattern x_Spr_Sort(_sgrp,_customsort) is
safe a0:=_sgrp; d0:=_customsort;;
call x_spr_sort;
endp;															# X_SPR_SORT



pattern x_Spr_CutMsk(_spr,_data,_x,_y,_width,_height) is
push d2\d3;
safe a0:=_spr; a1:=_data; d0:=_x; d1:=_y; d2:=_width; d3:=_height;;
call x_spr_cutmsk;
pop d2\d3;
endp;															# X_SPR_CUTMSK



pattern x_Spr_GrpCutMsk(_sgrp,_data,_x,_y,_width,_height) is
push d2\d3;
safe a0:=_sgrp; a1:=_data; d0:=_x; d1:=_y; d2:=_width; d3:=_height;;
call x_spr_grpcutmsk;
pop d2\d3;
endp;															# X_SPR_GRPCUTMSK



pattern x_Spr_AddBgBuf(_spr,_size) is				# D0=SUCCESS
safe a0:=_spr; d0.l:=_size;;
call x_spr_addbgbuf;
endp;															# X_SPR_ADDBGBUF



pattern x_Spr_GrpAddBgBuf(_sgrp) is				# D0=SUCCESS
a0:=_sgrp;
call x_spr_grpaddbgbuf;
endp;															# X_SPR_GRPADDBGBUF



pattern x_Spr_AddMskBuf(_spr,_size) is				# D0=SUCCESS
safe a0:=_spr; d0.l:=_size;;
call x_spr_addmskbuf;
endp;															# X_SPR_ADDMSKBUF



pattern x_Spr_GrpAddMskBuf(_sgrp) is				# D0=SUCCESS
a0:=_sgrp;
call x_spr_grpaddmskbuf;
endp;															# X_SPR_GRPADDMSKBUF



pattern x_MakeMask(_source,_dest,_width,_height,_depth,_mplane) is
push d2\d3;
safe a0:=_source; a1:=_dest; d0:=_width; d1:=_height; d2:=_depth; d3:=_mplane;;
call x_makemask;
pop d2\d3;
endp;															# X_MAKEMASK



pattern x_ClrBlit(_dst,_dstw,_width,_height) is
push d2;

safe a0:=_dst; d0:=_dstw; d1:=_width; d2:=_height;;
call x_clrblit;

pop d2;
endp;															# X_CLRBLIT



pattern x_MoveBlit(_src,_srcw,_dst,_dstw,_width,_height) is
push d2\d3;

safe
	a0:=_src; d0:=_srcw; a1:=_dst; d1:=_dstw;
	d2:=_width; d3:=_height;
;
call x_moveblit;

pop d2\d3;
endp;															# X_MOVEBLIT


#-------------------------------------------------------------------------------


pattern x_C2P_4(_chunky,_planar,_cwidth,_cheight,_prowwidth,_prowdiff) is
push d2\d3;
safe
	a0:=_chunky; a1:=_planar; d0:=_cwidth; d1:=_cheight;
	d2:=_prowwidth; d3:=_prowdiff;
;
call x_c2p_4;
pop d2\d3;
endp;															# X_C2P_4


pattern x_C2P_4x(_chunky,_planar,_cwidth,_cheight,_prowwidth,_prowdiff) is
push d2\d3;
safe
	a0:=_chunky; a1:=_planar; d0:=_cwidth; d1:=_cheight;
	d2:=_prowwidth; d3:=_prowdiff;
;
call x_c2p_4x;
pop d2\d3;
endp;															# X_C2P_4X


pattern x_C2P_4xy(_chunky,_planar,_cwidth,_cheight,_prowwidth,_prowdiff) is
push d2\d3;
safe
	a0:=_chunky; a1:=_planar; d0:=_cwidth; d1:=_cheight;
	d2:=_prowwidth; d3:=_prowdiff;
;
call x_c2p_4xy;
pop d2\d3;
endp;															# X_C2P_4XY


pattern x_C2P_6(_chunky,_planar,_cwidth,_cheight,_prowwidth,_prowdiff) is
push d2\d3;
safe
	a0:=_chunky; a1:=_planar; d0:=_cwidth; d1:=_cheight;
	d2:=_prowwidth; d3:=_prowdiff;
;
call x_c2p_6;
pop d2\d3;
endp;															# X_C2P_6


pattern x_C2P_6x(_chunky,_planar,_cwidth,_cheight,_prowwidth,_prowdiff) is
push d2\d3;
safe
	a0:=_chunky; a1:=_planar; d0:=_cwidth; d1:=_cheight;
	d2:=_prowwidth; d3:=_prowdiff;
;
call x_c2p_6x;
pop d2\d3;
endp;															# X_C2P_6X


pattern x_C2P_6xy(_chunky,_planar,_cwidth,_cheight,_prowwidth,_prowdiff) is
push d2\d3;
safe
	a0:=_chunky; a1:=_planar; d0:=_cwidth; d1:=_cheight;
	d2:=_prowwidth; d3:=_prowdiff;
;
call x_c2p_6xy;
pop d2\d3;
endp;															# X_C2P_6XY


pattern x_C2P_8(_chunky,_planar,_cwidth,_cheight,_prowwidth,_prowdiff) is
push d2\d3;
safe
	a0:=_chunky; a1:=_planar; d0:=_cwidth; d1:=_cheight;
	d2:=_prowwidth; d3:=_prowdiff;
;
call x_c2p_8;
pop d2\d3;
endp;															# X_C2P_8


pattern x_C2P_8x(_chunky,_planar,_cwidth,_cheight,_prowwidth,_prowdiff) is
push d2\d3;
safe
	a0:=_chunky; a1:=_planar; d0:=_cwidth; d1:=_cheight;
	d2:=_prowwidth; d3:=_prowdiff;
;
call x_c2p_8x;
pop d2\d3;
endp;															# X_C2P_8X


pattern x_C2P_8xy(_chunky,_planar,_cwidth,_cheight,_prowwidth,_prowdiff) is
push d2\d3;
safe
	a0:=_chunky; a1:=_planar; d0:=_cwidth; d1:=_cheight;
	d2:=_prowwidth; d3:=_prowdiff;
;
call x_c2p_8xy;
pop d2\d3;
endp;															# X_C2P_8XY


#*******************************************************************************


pattern x_Randomize is
call x_randomize;
endp;															# X_RANDOMIZE



pattern x_Rnd is                                                # D0=RANDOM
call x_rnd;
endp;															# X_RND


#-------------------------------------------------------------------------------


pattern x_LoadFile(_filename,_memflags) is		# A0=LOADED FILE, D0.L=SIZE
safe a0:=_filename; d0.l:=_memflags;;
call x_loadfile;
endp;															# X_LOADFILE



pattern x_UnLoadFile(_loadedfile) is
a0:=_loadedfile;
call x_unloadfile;
endp;															# X_UNLOADFILE


#-------------------------------------------------------------------------------


pattern x_SetTaskPri(_task,_pri) is				# D0=OLD PRI
safe a0:=_task; d0:=_pri;;
call x_settaskpri;
endp;															# X_SETTASKPRI



pattern x_RevertTaskPri is
call x_reverttaskpri;
endp;															# X_REVERTTASKPRI



pattern x_EasyRequest(_window,_titletxt,_bodytxt,_gadgettxt) is # D0=NUM
safe a0:=_window; a1:=_titletxt; d0.l:=_bodytxt; d1.l:=_gadgettxt;;
call x_easyrequest;
endp;															# X_EASYREQUEST



pattern x_DisplayBeep(_scr) is
a0:=_scr;
call x_displaybeep;
endp;															#X_DISPLAYBEEP



pattern x_Delay(_ticks) is
d0.l:=_ticks;
call x_delay;
endp;															# X_DELAY



pattern x_OwnBlitter is
call x_ownblitter;
endp;															# X_OWNBLITTER



pattern x_DisownBlitter is
call x_disownblitter;
endp;															# X_DISOWNBLITTER



pattern x_WaitBlit is
call x_waitblit;
endp;															# X_WAITBLIT



pattern x_WaitTOF is
call x_waittof;
endp;															# X_WAITTOF



pattern x_VBeamPos is							# D0.L=BEAMPOS
call x_vbeampos;
endp;															# X_VBEAMPOS



pattern x_WBenchToFront is					# D0=SUCCESS
call x_wbenchtofront;
endp;															# X_WBENCHTOFRONT



pattern x_WBenchToBack is					# D0=SUCCESS
call x_wbenchtoback;
endp;															# X_WBENCHTOBACK



pattern x_OpenWorkbench is					# D0=SUCCESS
call x_openworkbench;
endp;															# X_OPENWORKBENCH



pattern x_CloseWorkbench is					# D0=SUCCESS
call x_closeworkbench;
endp;															# X_CLOSEWORKBENCH


/******************************************************************************\
\******************************************************************************/

