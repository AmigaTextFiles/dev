#include "sysdeps.h"
#include "m68k.h"
#include "memory.h"
#include "readcpu.h"
#include "newcpu.h"
#include "compiler/compemu.h"
#include "fpu/fpu.h"
#include "cputbl.h"
#define SET_CFLG_ALWAYS(x) SET_CFLG(x)
#define SET_NFLG_ALWAYS(x) SET_NFLG(x)
#define CPUFUNC_FF(x) x##_ff
#define CPUFUNC_NF(x) x##_nf
#define CPUFUNC(x) CPUFUNC_FF(x)
#ifdef NOFLAGS
# include "noflags.h"
#endif

#if !defined(PART_1) && !defined(PART_2) && !defined(PART_3) && !defined(PART_4) && !defined(PART_5) && !defined(PART_6) && !defined(PART_7) && !defined(PART_8)
#define PART_1 1
#define PART_2 1
#define PART_3 1
#define PART_4 1
#define PART_5 1
#define PART_6 1
#define PART_7 1
#define PART_8 1
#endif

#ifdef PART_1
void REGPARAM2 CPUFUNC(op_0_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uae_s8 dst = m68k_dreg(regs, dstreg);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_18_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_28_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_38_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_39_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3c_0)(uae_u32 opcode) /* ORSR */
{
	cpuop_begin();
{	MakeSR();
{	uae_s16 src = get_iword(2);
	src &= 0xFF;
	regs.sr |= src;
	MakeFromSR();
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_58_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	m68k_areg(regs, dstreg) += 2;
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_60_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
{	uae_s16 dst = get_word(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_68_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_70_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s16 dst = get_word(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_78_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_79_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s16 dst = get_word(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_7c_0)(uae_u32 opcode) /* ORSR */
{
	cpuop_begin();
{if (!regs.s) { Exception(8,0); goto endlabel18; }
{	MakeSR();
{	uae_s16 src = get_iword(2);
	regs.sr |= src;
	MakeFromSR();
}}}m68k_incpc(4);
endlabel18: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_80_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_90_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_98_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	m68k_areg(regs, dstreg) += 4;
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a0_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
{	uae_s32 dst = get_long(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a8_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_b0_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{m68k_incpc(6);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 dst = get_long(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_b8_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_b9_0)(uae_u32 opcode) /* OR */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = get_ilong(6);
{	uae_s32 dst = get_long(dsta);
	src |= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(10);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_d0_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s8)get_byte(dsta); upper = (uae_s32)(uae_s8)get_byte(dsta+1);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s8)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel27; }
}
}}}m68k_incpc(4);
endlabel27: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e8_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s8)get_byte(dsta); upper = (uae_s32)(uae_s8)get_byte(dsta+1);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s8)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel28; }
}
}}}m68k_incpc(6);
endlabel28: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_f0_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s8)get_byte(dsta); upper = (uae_s32)(uae_s8)get_byte(dsta+1);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s8)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel29; }
}
}}}}endlabel29: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_f8_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s8)get_byte(dsta); upper = (uae_s32)(uae_s8)get_byte(dsta+1);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s8)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel30; }
}
}}}m68k_incpc(6);
endlabel30: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_f9_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = get_ilong(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s8)get_byte(dsta); upper = (uae_s32)(uae_s8)get_byte(dsta+1);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s8)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel31; }
}
}}}m68k_incpc(8);
endlabel31: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_fa_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_getpc () + 4;
	dsta += (uae_s32)(uae_s16)get_iword(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s8)get_byte(dsta); upper = (uae_s32)(uae_s8)get_byte(dsta+1);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s8)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel32; }
}
}}}m68k_incpc(6);
endlabel32: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_fb_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s8)get_byte(dsta); upper = (uae_s32)(uae_s8)get_byte(dsta+1);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s8)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel33; }
}
}}}}endlabel33: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_100_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src &= 31;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_108_0)(uae_u32 opcode) /* MVPMR */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr memp = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_u16 val = (get_byte(memp) << 8) + get_byte(memp + 2);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((val) & 0xffff);
}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_110_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_118_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_120_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_128_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_130_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_138_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_139_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = get_ilong(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13a_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
	uae_u32 dstreg = 2;
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_getpc () + 2;
	dsta += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13b_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
	uae_u32 dstreg = 3;
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13c_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uae_s8 dst = get_ibyte(2);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_140_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src &= 31;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	m68k_dreg(regs, dstreg) = (dst);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_148_0)(uae_u32 opcode) /* MVPMR */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr memp = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_u32 val = (get_byte(memp) << 24) + (get_byte(memp + 2) << 16)
              + (get_byte(memp + 4) << 8) + get_byte(memp + 6);
	m68k_dreg(regs, dstreg) = (val);
}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_150_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_158_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_160_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_168_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_170_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_178_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_179_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = get_ilong(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_17a_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
	uae_u32 dstreg = 2;
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_getpc () + 2;
	dsta += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_17b_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
	uae_u32 dstreg = 3;
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_180_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src &= 31;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	m68k_dreg(regs, dstreg) = (dst);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_188_0)(uae_u32 opcode) /* MVPRM */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
	uaecptr memp = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	put_byte(memp, src >> 8); put_byte(memp + 2, src);
}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_190_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_198_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1a0_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1a8_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1b0_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1b8_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1b9_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = get_ilong(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1ba_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
	uae_u32 dstreg = 2;
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_getpc () + 2;
	dsta += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1bb_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
	uae_u32 dstreg = 3;
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1c0_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src &= 31;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	m68k_dreg(regs, dstreg) = (dst);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1c8_0)(uae_u32 opcode) /* MVPRM */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
	uaecptr memp = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	put_byte(memp, src >> 24); put_byte(memp + 2, src >> 16);
	put_byte(memp + 4, src >> 8); put_byte(memp + 6, src);
}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1d0_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1d8_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1e0_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1e8_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1f0_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1f8_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1f9_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = get_ilong(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1fa_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
	uae_u32 dstreg = 2;
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_getpc () + 2;
	dsta += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1fb_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 1) & 7);
#else
	uae_u32 srcreg = ((opcode >> 9) & 7);
#endif
	uae_u32 dstreg = 3;
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_200_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uae_s8 dst = m68k_dreg(regs, dstreg);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_210_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_218_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_220_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_228_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_230_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_238_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_239_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23c_0)(uae_u32 opcode) /* ANDSR */
{
	cpuop_begin();
{	MakeSR();
{	uae_s16 src = get_iword(2);
	src |= 0xFF00;
	regs.sr &= src;
	MakeFromSR();
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_240_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_250_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_258_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	m68k_areg(regs, dstreg) += 2;
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_260_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
{	uae_s16 dst = get_word(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_268_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_270_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s16 dst = get_word(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_278_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_279_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s16 dst = get_word(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_27c_0)(uae_u32 opcode) /* ANDSR */
{
	cpuop_begin();
{if (!regs.s) { Exception(8,0); goto endlabel96; }
{	MakeSR();
{	uae_s16 src = get_iword(2);
	regs.sr &= src;
	MakeFromSR();
}}}m68k_incpc(4);
endlabel96: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_280_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_290_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_298_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	m68k_areg(regs, dstreg) += 4;
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2a0_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
{	uae_s32 dst = get_long(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2a8_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2b0_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{m68k_incpc(6);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 dst = get_long(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2b8_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2b9_0)(uae_u32 opcode) /* AND */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = get_ilong(6);
{	uae_s32 dst = get_long(dsta);
	src &= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(10);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2d0_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s16)get_word(dsta); upper = (uae_s32)(uae_s16)get_word(dsta+2);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s16)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel105; }
}
}}}m68k_incpc(4);
endlabel105: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2e8_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s16)get_word(dsta); upper = (uae_s32)(uae_s16)get_word(dsta+2);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s16)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel106; }
}
}}}m68k_incpc(6);
endlabel106: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2f0_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s16)get_word(dsta); upper = (uae_s32)(uae_s16)get_word(dsta+2);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s16)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel107; }
}
}}}}endlabel107: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2f8_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s16)get_word(dsta); upper = (uae_s32)(uae_s16)get_word(dsta+2);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s16)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel108; }
}
}}}m68k_incpc(6);
endlabel108: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2f9_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = get_ilong(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s16)get_word(dsta); upper = (uae_s32)(uae_s16)get_word(dsta+2);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s16)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel109; }
}
}}}m68k_incpc(8);
endlabel109: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2fa_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_getpc () + 4;
	dsta += (uae_s32)(uae_s16)get_iword(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s16)get_word(dsta); upper = (uae_s32)(uae_s16)get_word(dsta+2);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s16)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel110; }
}
}}}m68k_incpc(6);
endlabel110: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2fb_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=(uae_s32)(uae_s16)get_word(dsta); upper = (uae_s32)(uae_s16)get_word(dsta+2);
	if ((extra & 0x8000) == 0) reg = (uae_s32)(uae_s16)reg;
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel111; }
}
}}}}endlabel111: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_400_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uae_s8 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((newv) & 0xff);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_410_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_418_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_420_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_428_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_430_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_438_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_439_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_440_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((newv) & 0xffff);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_450_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_458_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	m68k_areg(regs, dstreg) += 2;
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_460_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
{	uae_s16 dst = get_word(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_468_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_470_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_478_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_479_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_480_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (newv);
}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_490_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_498_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	m68k_areg(regs, dstreg) += 4;
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a0_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
{	uae_s32 dst = get_long(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a8_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4b0_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{m68k_incpc(6);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4b8_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4b9_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = get_ilong(6);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(10);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4d0_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=get_long(dsta); upper = get_long(dsta+4);
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel136; }
}
}}}m68k_incpc(4);
endlabel136: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e8_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=get_long(dsta); upper = get_long(dsta+4);
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel137; }
}
}}}m68k_incpc(6);
endlabel137: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4f0_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=get_long(dsta); upper = get_long(dsta+4);
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel138; }
}
}}}}endlabel138: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4f8_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=get_long(dsta); upper = get_long(dsta+4);
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel139; }
}
}}}m68k_incpc(6);
endlabel139: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4f9_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = get_ilong(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=get_long(dsta); upper = get_long(dsta+4);
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel140; }
}
}}}m68k_incpc(8);
endlabel140: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4fa_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_getpc () + 4;
	dsta += (uae_s32)(uae_s16)get_iword(4);
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=get_long(dsta); upper = get_long(dsta+4);
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel141; }
}
}}}m68k_incpc(6);
endlabel141: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4fb_0)(uae_u32 opcode) /* CHK2 */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(2);
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
	{uae_s32 upper,lower,reg = regs.regs[(extra >> 12) & 15];
	lower=get_long(dsta); upper = get_long(dsta+4);
	SET_ZFLG (upper == reg || lower == reg);
	SET_CFLG_ALWAYS (lower <= upper ? reg < lower || reg > upper : reg > upper || reg < lower);
	if ((extra & 0x800) && GET_CFLG) { Exception(6,oldpc); goto endlabel142; }
}
}}}}endlabel142: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_600_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uae_s8 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((newv) & 0xff);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_610_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_618_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_620_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_628_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_630_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_638_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_639_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_640_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((newv) & 0xffff);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_650_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_658_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	m68k_areg(regs, dstreg) += 2;
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_660_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
{	uae_s16 dst = get_word(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_668_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_670_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_678_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_679_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_680_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (newv);
}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_690_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_698_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	m68k_areg(regs, dstreg) += 4;
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6a0_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
{	uae_s32 dst = get_long(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6a8_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6b0_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{m68k_incpc(6);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6b8_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6b9_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = get_ilong(6);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(10);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6c0_0)(uae_u32 opcode) /* RTM */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{m68k_incpc(2);
	op_illg(opcode);
}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6c8_0)(uae_u32 opcode) /* RTM */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{m68k_incpc(2);
	op_illg(opcode);
}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6d0_0)(uae_u32 opcode) /* CALLM */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{m68k_incpc(2);
	op_illg(opcode);
}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6e8_0)(uae_u32 opcode) /* CALLM */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{m68k_incpc(2);
	op_illg(opcode);
}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6f0_0)(uae_u32 opcode) /* CALLM */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{m68k_incpc(2);
	op_illg(opcode);
}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6f8_0)(uae_u32 opcode) /* CALLM */
{
	cpuop_begin();
#ifndef NOFLAGS
{m68k_incpc(2);
	op_illg(opcode);
}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6f9_0)(uae_u32 opcode) /* CALLM */
{
	cpuop_begin();
#ifndef NOFLAGS
{m68k_incpc(2);
	op_illg(opcode);
}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6fa_0)(uae_u32 opcode) /* CALLM */
{
	cpuop_begin();
#ifndef NOFLAGS
{m68k_incpc(2);
	op_illg(opcode);
}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_6fb_0)(uae_u32 opcode) /* CALLM */
{
	cpuop_begin();
#ifndef NOFLAGS
{m68k_incpc(2);
	op_illg(opcode);
}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_800_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src &= 31;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_810_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_818_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_820_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_828_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_830_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_838_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_839_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_83a_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_getpc () + 4;
	dsta += (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_83b_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_83c_0)(uae_u32 opcode) /* BTST */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uae_s8 dst = get_ibyte(4);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_840_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src &= 31;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	m68k_dreg(regs, dstreg) = (dst);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_850_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_858_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_860_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_868_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_870_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_878_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_879_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_87a_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_getpc () + 4;
	dsta += (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_87b_0)(uae_u32 opcode) /* BCHG */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	dst ^= (1 << src);
	SET_ZFLG (((uae_u32)dst & (1 << src)) >> src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_880_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src &= 31;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	m68k_dreg(regs, dstreg) = (dst);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_890_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_898_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8a0_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8a8_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8b0_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8b8_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8b9_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8ba_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_getpc () + 4;
	dsta += (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8bb_0)(uae_u32 opcode) /* BCLR */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst &= ~(1 << src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8c0_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src &= 31;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	m68k_dreg(regs, dstreg) = (dst);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8d0_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8d8_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8e0_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8e8_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8f0_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8f8_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8f9_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8fa_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_getpc () + 4;
	dsta += (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_8fb_0)(uae_u32 opcode) /* BSET */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 dst = get_byte(dsta);
	src &= 7;
	SET_ZFLG (1 ^ ((dst >> src) & 1));
	dst |= (1 << src);
	put_byte(dsta,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a00_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uae_s8 dst = m68k_dreg(regs, dstreg);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a10_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a18_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a20_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a28_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a30_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a38_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a39_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a3c_0)(uae_u32 opcode) /* EORSR */
{
	cpuop_begin();
{	MakeSR();
{	uae_s16 src = get_iword(2);
	src &= 0xFF;
	regs.sr ^= src;
	MakeFromSR();
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a40_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a50_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a58_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	m68k_areg(regs, dstreg) += 2;
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a60_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
{	uae_s16 dst = get_word(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a68_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a70_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s16 dst = get_word(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a78_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a79_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s16 dst = get_word(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
#endif

#ifdef PART_2
void REGPARAM2 CPUFUNC(op_a7c_0)(uae_u32 opcode) /* EORSR */
{
	cpuop_begin();
{if (!regs.s) { Exception(8,0); goto endlabel234; }
{	MakeSR();
{	uae_s16 src = get_iword(2);
	regs.sr ^= src;
	MakeFromSR();
}}}m68k_incpc(4);
endlabel234: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a80_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a90_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_a98_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	m68k_areg(regs, dstreg) += 4;
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_aa0_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
{	uae_s32 dst = get_long(dsta);
	m68k_areg (regs, dstreg) = dsta;
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_aa8_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ab0_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{m68k_incpc(6);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 dst = get_long(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ab8_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ab9_0)(uae_u32 opcode) /* EOR */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = get_ilong(6);
{	uae_s32 dst = get_long(dsta);
	src ^= dst;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(10);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ad0_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s8)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(m68k_dreg(regs, rc))) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_byte(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ad8_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s8)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(m68k_dreg(regs, rc))) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_byte(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ae0_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s8)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(m68k_dreg(regs, rc))) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_byte(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ae8_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s8)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(m68k_dreg(regs, rc))) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_byte(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_af0_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s8)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(m68k_dreg(regs, rc))) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_byte(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_af8_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s8)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(m68k_dreg(regs, rc))) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_byte(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_af9_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s8)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(m68k_dreg(regs, rc))) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_byte(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c00_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uae_s8 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c10_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c18_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c20_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c28_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c30_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c38_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c39_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c3a_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_getpc () + 4;
	dsta += (uae_s32)(uae_s16)get_iword(4);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c3b_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{{	uae_s8 src = get_ibyte(2);
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c40_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c50_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c58_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	m68k_areg(regs, dstreg) += 2;
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c60_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
{	uae_s16 dst = get_word(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c68_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c70_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c78_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c79_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c7a_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_getpc () + 4;
	dsta += (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c7b_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c80_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c90_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_c98_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	m68k_areg(regs, dstreg) += 4;
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ca0_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
{	uae_s32 dst = get_long(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ca8_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cb0_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{m68k_incpc(6);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cb8_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cb9_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = get_ilong(6);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(10);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cba_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_getpc () + 6;
	dsta += (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cbb_0)(uae_u32 opcode) /* CMP */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{{	uae_s32 src = get_ilong(2);
{m68k_incpc(6);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cd0_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s16)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(m68k_dreg(regs, rc))) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_word(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cd8_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	m68k_areg(regs, dstreg) += 2;
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s16)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(m68k_dreg(regs, rc))) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_word(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ce0_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
{	uae_s16 dst = get_word(dsta);
	m68k_areg (regs, dstreg) = dsta;
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s16)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(m68k_dreg(regs, rc))) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_word(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ce8_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s16)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(m68k_dreg(regs, rc))) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_word(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cf0_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s16 dst = get_word(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s16)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(m68k_dreg(regs, rc))) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_word(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cf8_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s16 dst = get_word(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s16)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(m68k_dreg(regs, rc))) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_word(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cf9_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s16 dst = get_word(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s16)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(m68k_dreg(regs, rc))) > ((uae_u16)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_word(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_cfc_0)(uae_u32 opcode) /* CAS2 */
{
	cpuop_begin();
{{	uae_s32 extra = get_ilong(2);
	uae_u32 rn1 = regs.regs[(extra >> 28) & 15];
	uae_u32 rn2 = regs.regs[(extra >> 12) & 15];
	uae_u16 dst1 = get_word(rn1), dst2 = get_word(rn2);
{uae_u32 newv = ((uae_s16)(dst1)) - ((uae_s16)(m68k_dreg(regs, (extra >> 16) & 7)));
{	int flgs = ((uae_s16)(m68k_dreg(regs, (extra >> 16) & 7))) < 0;
	int flgo = ((uae_s16)(dst1)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(m68k_dreg(regs, (extra >> 16) & 7))) > ((uae_u16)(dst1)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG) {
{uae_u32 newv = ((uae_s16)(dst2)) - ((uae_s16)(m68k_dreg(regs, extra & 7)));
{	int flgs = ((uae_s16)(m68k_dreg(regs, extra & 7))) < 0;
	int flgo = ((uae_s16)(dst2)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u16)(m68k_dreg(regs, extra & 7))) > ((uae_u16)(dst2)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG) {
	put_word(rn1, m68k_dreg(regs, (extra >> 22) & 7));
	put_word(rn1, m68k_dreg(regs, (extra >> 6) & 7));
	}}
}}}}	if (! GET_ZFLG) {
	m68k_dreg(regs, (extra >> 22) & 7) = (m68k_dreg(regs, (extra >> 22) & 7) & ~0xffff) | (dst1 & 0xffff);
	m68k_dreg(regs, (extra >> 6) & 7) = (m68k_dreg(regs, (extra >> 6) & 7) & ~0xffff) | (dst2 & 0xffff);
	}
}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e10_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel288; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg);
	put_byte(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg);
{	uae_s8 src = get_byte(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s8)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xff) | ((src) & 0xff);
	}
}}}}}}m68k_incpc(4);
endlabel288: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e18_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel289; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	put_byte(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s8)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xff) | ((src) & 0xff);
	}
}}}}}}m68k_incpc(4);
endlabel289: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e20_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel290; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	put_byte(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, dstreg) = srca;
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s8)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xff) | ((src) & 0xff);
	}
}}}}}}m68k_incpc(4);
endlabel290: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e28_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel291; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	put_byte(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
{	uae_s8 src = get_byte(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s8)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xff) | ((src) & 0xff);
	}
}}}}}}m68k_incpc(8);
endlabel291: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e30_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel292; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	put_byte(dsta,src);
}}}else{{{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 src = get_byte(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s8)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xff) | ((src) & 0xff);
	}
}}}}}}}endlabel292: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e38_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel293; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	put_byte(dsta,src);
}}else{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(6);
{	uae_s8 src = get_byte(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s8)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xff) | ((src) & 0xff);
	}
}}}}}}m68k_incpc(8);
endlabel293: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e39_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel294; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = get_ilong(4);
	put_byte(dsta,src);
}}else{{	uaecptr srca = get_ilong(8);
{	uae_s8 src = get_byte(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s8)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xff) | ((src) & 0xff);
	}
}}}}}}m68k_incpc(12);
endlabel294: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e50_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel295; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg);
	put_word(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg);
{	uae_s16 src = get_word(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s16)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xffff) | ((src) & 0xffff);
	}
}}}}}}m68k_incpc(4);
endlabel295: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e58_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel296; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	put_word(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, dstreg) += 2;
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s16)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xffff) | ((src) & 0xffff);
	}
}}}}}}m68k_incpc(4);
endlabel296: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e60_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel297; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	put_word(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, dstreg) = srca;
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s16)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xffff) | ((src) & 0xffff);
	}
}}}}}}m68k_incpc(4);
endlabel297: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e68_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel298; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	put_word(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
{	uae_s16 src = get_word(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s16)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xffff) | ((src) & 0xffff);
	}
}}}}}}m68k_incpc(8);
endlabel298: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e70_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel299; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	put_word(dsta,src);
}}}else{{{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s16 src = get_word(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s16)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xffff) | ((src) & 0xffff);
	}
}}}}}}}endlabel299: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e78_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel300; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	put_word(dsta,src);
}}else{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(6);
{	uae_s16 src = get_word(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s16)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xffff) | ((src) & 0xffff);
	}
}}}}}}m68k_incpc(8);
endlabel300: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e79_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel301; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = get_ilong(4);
	put_word(dsta,src);
}}else{{	uaecptr srca = get_ilong(8);
{	uae_s16 src = get_word(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = (uae_s32)(uae_s16)src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (m68k_dreg(regs, (extra >> 12) & 7) & ~0xffff) | ((src) & 0xffff);
	}
}}}}}}m68k_incpc(12);
endlabel301: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e90_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel302; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg);
	put_long(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg);
{	uae_s32 src = get_long(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (src);
	}
}}}}}}m68k_incpc(4);
endlabel302: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_e98_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel303; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	put_long(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, dstreg) += 4;
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (src);
	}
}}}}}}m68k_incpc(4);
endlabel303: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ea0_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel304; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	put_long(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, dstreg) = srca;
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (src);
	}
}}}}}}m68k_incpc(4);
endlabel304: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ea8_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel305; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	put_long(dsta,src);
}}else{{	uaecptr srca = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 src = get_long(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (src);
	}
}}}}}}m68k_incpc(8);
endlabel305: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_eb0_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{if (!regs.s) { Exception(8,0); goto endlabel306; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	put_long(dsta,src);
}}}else{{{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 src = get_long(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (src);
	}
}}}}}}}endlabel306: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_eb8_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel307; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	put_long(dsta,src);
}}else{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(6);
{	uae_s32 src = get_long(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (src);
	}
}}}}}}m68k_incpc(8);
endlabel307: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_eb9_0)(uae_u32 opcode) /* MOVES */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel308; }
{{	uae_s16 extra = get_iword(2);
	if (extra & 0x800)
{	uae_u32 src = regs.regs[(extra >> 12) & 15];
{	uaecptr dsta = get_ilong(4);
	put_long(dsta,src);
}}else{{	uaecptr srca = get_ilong(8);
{	uae_s32 src = get_long(srca);
	if (extra & 0x8000) {
	m68k_areg(regs, (extra >> 12) & 7) = src;
	} else {
	m68k_dreg(regs, (extra >> 12) & 7) = (src);
	}
}}}}}}m68k_incpc(12);
endlabel308: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ed0_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s32)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(m68k_dreg(regs, rc))) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_long(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ed8_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	m68k_areg(regs, dstreg) += 4;
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s32)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(m68k_dreg(regs, rc))) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_long(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ee0_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
{	uae_s32 dst = get_long(dsta);
	m68k_areg (regs, dstreg) = dsta;
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s32)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(m68k_dreg(regs, rc))) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_long(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ee8_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s32 dst = get_long(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s32)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(m68k_dreg(regs, rc))) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_long(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ef0_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 dst = get_long(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s32)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(m68k_dreg(regs, rc))) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_long(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ef8_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s32 dst = get_long(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s32)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(m68k_dreg(regs, rc))) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_long(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_ef9_0)(uae_u32 opcode) /* CAS */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s32 dst = get_long(dsta);
{	int ru = (src >> 6) & 7;
	int rc = src & 7;
{uae_u32 newv = ((uae_s32)(dst)) - ((uae_s32)(m68k_dreg(regs, rc)));
{	int flgs = ((uae_s32)(m68k_dreg(regs, rc))) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(m68k_dreg(regs, rc))) > ((uae_u32)(dst)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG){	put_long(dsta,(m68k_dreg(regs, ru)));
}else{m68k_dreg(regs, rc) = dst;
}}}}}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_efc_0)(uae_u32 opcode) /* CAS2 */
{
	cpuop_begin();
{{	uae_s32 extra = get_ilong(2);
	uae_u32 rn1 = regs.regs[(extra >> 28) & 15];
	uae_u32 rn2 = regs.regs[(extra >> 12) & 15];
	uae_u32 dst1 = get_long(rn1), dst2 = get_long(rn2);
{uae_u32 newv = ((uae_s32)(dst1)) - ((uae_s32)(m68k_dreg(regs, (extra >> 16) & 7)));
{	int flgs = ((uae_s32)(m68k_dreg(regs, (extra >> 16) & 7))) < 0;
	int flgo = ((uae_s32)(dst1)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(m68k_dreg(regs, (extra >> 16) & 7))) > ((uae_u32)(dst1)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG) {
{uae_u32 newv = ((uae_s32)(dst2)) - ((uae_s32)(m68k_dreg(regs, extra & 7)));
{	int flgs = ((uae_s32)(m68k_dreg(regs, extra & 7))) < 0;
	int flgo = ((uae_s32)(dst2)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs != flgo) && (flgn != flgo));
	SET_CFLG (((uae_u32)(m68k_dreg(regs, extra & 7))) > ((uae_u32)(dst2)));
	SET_NFLG (flgn != 0);
	if (GET_ZFLG) {
	put_long(rn1, m68k_dreg(regs, (extra >> 22) & 7));
	put_long(rn1, m68k_dreg(regs, (extra >> 6) & 7));
	}}
}}}}	if (! GET_ZFLG) {
	m68k_dreg(regs, (extra >> 22) & 7) = dst1;
	m68k_dreg(regs, (extra >> 6) & 7) = dst2;
	}
}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1000_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1010_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1018_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1020_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1028_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1030_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1038_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1039_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_103a_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_103b_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 src = get_byte(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_103c_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((src) & 0xff);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1080_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1090_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1098_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10a0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10a8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10b0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10b8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10b9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10ba_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10bb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10bc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10c0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10d0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10d8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10e0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10e8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10f0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10f8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10f9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10fa_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10fb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_10fc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1100_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1110_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1118_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1120_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1128_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1130_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1138_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1139_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_113a_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_113b_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_113c_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1140_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1150_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1158_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1160_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1168_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1170_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1178_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1179_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_117a_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_117b_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_117c_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1180_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1190_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_1198_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11a0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11a8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11b0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11b8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11b9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{m68k_incpc(6);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11ba_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11bb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 src = get_byte(srca);
{{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11bc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s8 src = get_ibyte(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11c0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11d0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11d8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11e0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11e8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11f0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11f8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11f9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11fa_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11fb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_11fc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13c0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13d0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13d8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13e0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13e8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13f0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = get_ilong(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13f8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13f9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = get_ilong(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(10);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13fa_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13fb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 src = get_byte(srca);
{	uaecptr dsta = get_ilong(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_13fc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	put_byte(dsta,src);
}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2000_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2008_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2010_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2018_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2020_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2028_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2030_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2038_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2039_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_203a_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_203b_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_203c_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	m68k_dreg(regs, dstreg) = (src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2040_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2048_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2050_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2058_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2060_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2068_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2070_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2078_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2079_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_207a_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_207b_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_207c_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uae_u32 val = src;
	m68k_areg(regs, dstreg) = (val);
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2080_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2088_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2090_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2098_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20a0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20a8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20b0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20b8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20b9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20ba_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20bb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20bc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20c0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20c8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20d0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20d8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20e0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20e8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20f0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20f8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20f9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20fa_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20fb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_20fc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2100_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2108_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2110_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2118_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2120_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2128_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2130_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2138_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2139_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_213a_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_213b_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_213c_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2140_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2148_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2150_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
#endif

#ifdef PART_3
void REGPARAM2 CPUFUNC(op_2158_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2160_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2168_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2170_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2178_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2179_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_217a_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_217b_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_217c_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2180_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2188_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2190_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_2198_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21a0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21a8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21b0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21b8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21b9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{m68k_incpc(6);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21ba_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21bb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
{{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21bc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s32 src = get_ilong(2);
{m68k_incpc(6);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21c0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21c8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21d0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21d8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21e0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21e8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21f0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21f8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21f9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21fa_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21fb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_21fc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23c0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23c8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23d0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23d8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23e0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23e8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23f0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = get_ilong(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23f8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23f9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = get_ilong(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(10);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23fa_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23fb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
{	uaecptr dsta = get_ilong(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_23fc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
{	uaecptr dsta = get_ilong(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
	put_long(dsta,src);
}}}m68k_incpc(10);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3000_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3008_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_areg(regs, srcreg);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3010_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3018_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3020_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3028_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3030_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3038_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3039_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_303a_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_303b_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_303c_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((src) & 0xffff);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3040_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3048_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_areg(regs, srcreg);
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3050_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3058_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3060_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3068_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3070_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3078_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3079_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_307a_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_307b_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_307c_0)(uae_u32 opcode) /* MOVEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uae_u32 val = (uae_s32)(uae_s16)src;
	m68k_areg(regs, dstreg) = (val);
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3080_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3088_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3090_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3098_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30a0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30a8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30b0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30b8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30b9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30ba_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30bb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30bc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30c0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30c8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30d0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30d8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30e0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30e8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30f0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30f8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30f9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30fa_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30fb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_30fc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
	m68k_areg(regs, dstreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3100_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3108_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3110_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3118_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3120_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3128_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3130_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3138_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3139_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_313a_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_313b_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_313c_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
	m68k_areg (regs, dstreg) = dsta;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3140_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3148_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3150_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3158_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3160_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3168_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3170_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3178_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3179_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_317a_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_317b_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_317c_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3180_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3188_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = m68k_areg(regs, srcreg);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3190_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_3198_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31a0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31a8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31b0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31b8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31b9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{m68k_incpc(6);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31ba_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31bb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
{{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31bc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uae_s16 src = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31c0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31c8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31d0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31d8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31e0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31e8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31f0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31f8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31f9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31fa_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31fb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_31fc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33c0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33c8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_areg(regs, srcreg);
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33d0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33d8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33e0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	uaecptr dsta = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33e8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33f0_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = get_ilong(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33f8_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33f9_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = get_ilong(6);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(10);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33fa_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33fb_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
{	uaecptr dsta = get_ilong(0);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_33fc_0)(uae_u32 opcode) /* MOVE */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
{	uaecptr dsta = get_ilong(4);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
	put_word(dsta,src);
}}}m68k_incpc(8);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4000_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xff) | ((newv) & 0xff);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4010_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4018_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4020_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4028_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4030_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4038_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4039_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4040_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s16)(newv)) == 0));
	SET_NFLG (((uae_s16)(newv)) < 0);
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xffff) | ((newv) & 0xffff);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4050_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s16)(newv)) == 0));
	SET_NFLG (((uae_s16)(newv)) < 0);
	put_word(srca,newv);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4058_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s16)(newv)) == 0));
	SET_NFLG (((uae_s16)(newv)) < 0);
	put_word(srca,newv);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4060_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s16)(newv)) == 0));
	SET_NFLG (((uae_s16)(newv)) < 0);
	put_word(srca,newv);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4068_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s16)(newv)) == 0));
	SET_NFLG (((uae_s16)(newv)) < 0);
	put_word(srca,newv);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4070_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s16)(newv)) == 0));
	SET_NFLG (((uae_s16)(newv)) < 0);
	put_word(srca,newv);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4078_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s16)(newv)) == 0));
	SET_NFLG (((uae_s16)(newv)) < 0);
	put_word(srca,newv);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4079_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s16)(newv)) == 0));
	SET_NFLG (((uae_s16)(newv)) < 0);
	put_word(srca,newv);
}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4080_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s32)(newv)) == 0));
	SET_NFLG (((uae_s32)(newv)) < 0);
	m68k_dreg(regs, srcreg) = (newv);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4090_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s32)(newv)) == 0));
	SET_NFLG (((uae_s32)(newv)) < 0);
	put_long(srca,newv);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4098_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s32)(newv)) == 0));
	SET_NFLG (((uae_s32)(newv)) < 0);
	put_long(srca,newv);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40a0_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s32)(newv)) == 0));
	SET_NFLG (((uae_s32)(newv)) < 0);
	put_long(srca,newv);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40a8_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s32)(newv)) == 0));
	SET_NFLG (((uae_s32)(newv)) < 0);
	put_long(srca,newv);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40b0_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s32)(newv)) == 0));
	SET_NFLG (((uae_s32)(newv)) < 0);
	put_long(srca,newv);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40b8_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s32)(newv)) == 0));
	SET_NFLG (((uae_s32)(newv)) < 0);
	put_long(srca,newv);
}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40b9_0)(uae_u32 opcode) /* NEGX */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	uae_u32 newv = 0 - src - (GET_XFLG ? 1 : 0);
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_VFLG ((flgs ^ flgo) & (flgo ^ flgn));
	SET_CFLG (flgs ^ ((flgs ^ flgn) & (flgo ^ flgn)));
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s32)(newv)) == 0));
	SET_NFLG (((uae_s32)(newv)) < 0);
	put_long(srca,newv);
}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40c0_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel645; }
{{	MakeSR();
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xffff) | ((regs.sr) & 0xffff);
}}}m68k_incpc(2);
endlabel645: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40d0_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel646; }
{{	uaecptr srca = m68k_areg(regs, srcreg);
	MakeSR();
	put_word(srca,regs.sr);
}}}m68k_incpc(2);
endlabel646: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40d8_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel647; }
{{	uaecptr srca = m68k_areg(regs, srcreg);
	m68k_areg(regs, srcreg) += 2;
	MakeSR();
	put_word(srca,regs.sr);
}}}m68k_incpc(2);
endlabel647: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40e0_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel648; }
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
	m68k_areg (regs, srcreg) = srca;
	MakeSR();
	put_word(srca,regs.sr);
}}}m68k_incpc(2);
endlabel648: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40e8_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel649; }
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
	MakeSR();
	put_word(srca,regs.sr);
}}}m68k_incpc(4);
endlabel649: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40f0_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel650; }
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
	MakeSR();
	put_word(srca,regs.sr);
}}}}endlabel650: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40f8_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel651; }
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
	MakeSR();
	put_word(srca,regs.sr);
}}}m68k_incpc(4);
endlabel651: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_40f9_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel652; }
{{	uaecptr srca = get_ilong(2);
	MakeSR();
	put_word(srca,regs.sr);
}}}m68k_incpc(6);
endlabel652: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4100_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel653; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel653; }
}}}m68k_incpc(2);
endlabel653: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4110_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel654; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel654; }
}}}}m68k_incpc(2);
endlabel654: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4118_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel655; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel655; }
}}}}m68k_incpc(2);
endlabel655: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4120_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel656; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel656; }
}}}}m68k_incpc(2);
endlabel656: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4128_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel657; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel657; }
}}}}m68k_incpc(4);
endlabel657: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4130_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel658; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel658; }
}}}}}endlabel658: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4138_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel659; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel659; }
}}}}m68k_incpc(4);
endlabel659: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4139_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel660; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel660; }
}}}}m68k_incpc(6);
endlabel660: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_413a_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel661; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel661; }
}}}}m68k_incpc(4);
endlabel661: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_413b_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel662; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel662; }
}}}}}endlabel662: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_413c_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s32 src = get_ilong(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel663; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel663; }
}}}m68k_incpc(6);
endlabel663: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4180_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel664; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel664; }
}}}m68k_incpc(2);
endlabel664: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4190_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel665; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel665; }
}}}}m68k_incpc(2);
endlabel665: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4198_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel666; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel666; }
}}}}m68k_incpc(2);
endlabel666: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41a0_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel667; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel667; }
}}}}m68k_incpc(2);
endlabel667: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41a8_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel668; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel668; }
}}}}m68k_incpc(4);
endlabel668: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41b0_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel669; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel669; }
}}}}}endlabel669: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41b8_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel670; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel670; }
}}}}m68k_incpc(4);
endlabel670: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41b9_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel671; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel671; }
}}}}m68k_incpc(6);
endlabel671: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41ba_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel672; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel672; }
}}}}m68k_incpc(4);
endlabel672: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41bb_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel673; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel673; }
}}}}}endlabel673: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41bc_0)(uae_u32 opcode) /* CHK */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 src = get_iword(2);
{	uae_s16 dst = m68k_dreg(regs, dstreg);
	if ((uae_s32)dst < 0) { SET_NFLG (1); Exception(6,oldpc); goto endlabel674; }
	else if (dst > src) { SET_NFLG (0); Exception(6,oldpc); goto endlabel674; }
}}}m68k_incpc(4);
endlabel674: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41d0_0)(uae_u32 opcode) /* LEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	m68k_areg(regs, dstreg) = (srca);
}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41e8_0)(uae_u32 opcode) /* LEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	m68k_areg(regs, dstreg) = (srca);
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41f0_0)(uae_u32 opcode) /* LEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	m68k_areg(regs, dstreg) = (srca);
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41f8_0)(uae_u32 opcode) /* LEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	m68k_areg(regs, dstreg) = (srca);
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41f9_0)(uae_u32 opcode) /* LEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = get_ilong(2);
{	m68k_areg(regs, dstreg) = (srca);
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41fa_0)(uae_u32 opcode) /* LEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	m68k_areg(regs, dstreg) = (srca);
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_41fb_0)(uae_u32 opcode) /* LEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 1) & 7;
#else
	uae_u32 dstreg = (opcode >> 9) & 7;
#endif
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	m68k_areg(regs, dstreg) = (srca);
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4200_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(0)) == 0);
	SET_NFLG (((uae_s8)(0)) < 0);
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xff) | ((0) & 0xff);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4210_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(0)) == 0);
	SET_NFLG (((uae_s8)(0)) < 0);
	put_byte(srca,0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4218_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(0)) == 0);
	SET_NFLG (((uae_s8)(0)) < 0);
	put_byte(srca,0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4220_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
	m68k_areg (regs, srcreg) = srca;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(0)) == 0);
	SET_NFLG (((uae_s8)(0)) < 0);
	put_byte(srca,0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4228_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(0)) == 0);
	SET_NFLG (((uae_s8)(0)) < 0);
	put_byte(srca,0);
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4230_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(0)) == 0);
	SET_NFLG (((uae_s8)(0)) < 0);
	put_byte(srca,0);
}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4238_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(0)) == 0);
	SET_NFLG (((uae_s8)(0)) < 0);
	put_byte(srca,0);
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4239_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(0)) == 0);
	SET_NFLG (((uae_s8)(0)) < 0);
	put_byte(srca,0);
}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4240_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(0)) == 0);
	SET_NFLG (((uae_s16)(0)) < 0);
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xffff) | ((0) & 0xffff);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4250_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(0)) == 0);
	SET_NFLG (((uae_s16)(0)) < 0);
	put_word(srca,0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4258_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	m68k_areg(regs, srcreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(0)) == 0);
	SET_NFLG (((uae_s16)(0)) < 0);
	put_word(srca,0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4260_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
	m68k_areg (regs, srcreg) = srca;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(0)) == 0);
	SET_NFLG (((uae_s16)(0)) < 0);
	put_word(srca,0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4268_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(0)) == 0);
	SET_NFLG (((uae_s16)(0)) < 0);
	put_word(srca,0);
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4270_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(0)) == 0);
	SET_NFLG (((uae_s16)(0)) < 0);
	put_word(srca,0);
}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4278_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(0)) == 0);
	SET_NFLG (((uae_s16)(0)) < 0);
	put_word(srca,0);
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4279_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(0)) == 0);
	SET_NFLG (((uae_s16)(0)) < 0);
	put_word(srca,0);
}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4280_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(0)) == 0);
	SET_NFLG (((uae_s32)(0)) < 0);
	m68k_dreg(regs, srcreg) = (0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4290_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(0)) == 0);
	SET_NFLG (((uae_s32)(0)) < 0);
	put_long(srca,0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4298_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	m68k_areg(regs, srcreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(0)) == 0);
	SET_NFLG (((uae_s32)(0)) < 0);
	put_long(srca,0);
}}m68k_incpc(2);
	cpuop_end();
}
#endif

#ifdef PART_4
void REGPARAM2 CPUFUNC(op_42a0_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
	m68k_areg (regs, srcreg) = srca;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(0)) == 0);
	SET_NFLG (((uae_s32)(0)) < 0);
	put_long(srca,0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42a8_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(0)) == 0);
	SET_NFLG (((uae_s32)(0)) < 0);
	put_long(srca,0);
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42b0_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(0)) == 0);
	SET_NFLG (((uae_s32)(0)) < 0);
	put_long(srca,0);
}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42b8_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(0)) == 0);
	SET_NFLG (((uae_s32)(0)) < 0);
	put_long(srca,0);
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42b9_0)(uae_u32 opcode) /* CLR */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(0)) == 0);
	SET_NFLG (((uae_s32)(0)) < 0);
	put_long(srca,0);
}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42c0_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	MakeSR();
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xffff) | ((regs.sr & 0xff) & 0xffff);
}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42d0_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	MakeSR();
	put_word(srca,regs.sr & 0xff);
}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42d8_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	m68k_areg(regs, srcreg) += 2;
	MakeSR();
	put_word(srca,regs.sr & 0xff);
}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42e0_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
	m68k_areg (regs, srcreg) = srca;
	MakeSR();
	put_word(srca,regs.sr & 0xff);
}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42e8_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
	MakeSR();
	put_word(srca,regs.sr & 0xff);
}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42f0_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
	MakeSR();
	put_word(srca,regs.sr & 0xff);
}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42f8_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
	MakeSR();
	put_word(srca,regs.sr & 0xff);
}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_42f9_0)(uae_u32 opcode) /* MVSR2 */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = get_ilong(2);
	MakeSR();
	put_word(srca,regs.sr & 0xff);
}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4400_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{{uae_u32 dst = ((uae_s8)(0)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(dst)) < 0;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xff) | ((dst) & 0xff);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4410_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{{uae_u32 dst = ((uae_s8)(0)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(dst)) < 0;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(srca,dst);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4418_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{{uae_u32 dst = ((uae_s8)(0)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(dst)) < 0;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(srca,dst);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4420_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{{uae_u32 dst = ((uae_s8)(0)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(dst)) < 0;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(srca,dst);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4428_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{{uae_u32 dst = ((uae_s8)(0)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(dst)) < 0;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(srca,dst);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4430_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{{uae_u32 dst = ((uae_s8)(0)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(dst)) < 0;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(srca,dst);
}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4438_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{{uae_u32 dst = ((uae_s8)(0)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(dst)) < 0;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(srca,dst);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4439_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{{uae_u32 dst = ((uae_s8)(0)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(0)) < 0;
	int flgn = ((uae_s8)(dst)) < 0;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(srca,dst);
}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4440_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{{uae_u32 dst = ((uae_s16)(0)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(dst)) < 0;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xffff) | ((dst) & 0xffff);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4450_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{{uae_u32 dst = ((uae_s16)(0)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(dst)) < 0;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(srca,dst);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4458_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{{uae_u32 dst = ((uae_s16)(0)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(dst)) < 0;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(srca,dst);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4460_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{{uae_u32 dst = ((uae_s16)(0)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(dst)) < 0;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(srca,dst);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4468_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{{uae_u32 dst = ((uae_s16)(0)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(dst)) < 0;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(srca,dst);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4470_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{{uae_u32 dst = ((uae_s16)(0)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(dst)) < 0;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(srca,dst);
}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4478_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{{uae_u32 dst = ((uae_s16)(0)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(dst)) < 0;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(srca,dst);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4479_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{{uae_u32 dst = ((uae_s16)(0)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(0)) < 0;
	int flgn = ((uae_s16)(dst)) < 0;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(srca,dst);
}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4480_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{{uae_u32 dst = ((uae_s32)(0)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(dst)) < 0;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, srcreg) = (dst);
}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4490_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{{uae_u32 dst = ((uae_s32)(0)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(dst)) < 0;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(srca,dst);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4498_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{{uae_u32 dst = ((uae_s32)(0)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(dst)) < 0;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(srca,dst);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44a0_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{{uae_u32 dst = ((uae_s32)(0)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(dst)) < 0;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(srca,dst);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44a8_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{{uae_u32 dst = ((uae_s32)(0)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(dst)) < 0;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(srca,dst);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44b0_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{{uae_u32 dst = ((uae_s32)(0)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(dst)) < 0;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(srca,dst);
}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44b8_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{{uae_u32 dst = ((uae_s32)(0)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(dst)) < 0;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(srca,dst);
}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44b9_0)(uae_u32 opcode) /* NEG */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{{uae_u32 dst = ((uae_s32)(0)) - ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(0)) < 0;
	int flgn = ((uae_s32)(dst)) < 0;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u32)(src)) > ((uae_u32)(0)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(srca,dst);
}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44c0_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44d0_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44d8_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44e0_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44e8_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44f0_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44f8_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44f9_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44fa_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44fb_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_44fc_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
	MakeSR();
	regs.sr &= 0xFF00;
	regs.sr |= src & 0xFF;
	MakeFromSR();
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4600_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_NFLG (((uae_s8)(dst)) < 0);
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xff) | ((dst) & 0xff);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4610_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_NFLG (((uae_s8)(dst)) < 0);
	put_byte(srca,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4618_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_NFLG (((uae_s8)(dst)) < 0);
	put_byte(srca,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4620_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_NFLG (((uae_s8)(dst)) < 0);
	put_byte(srca,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4628_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_NFLG (((uae_s8)(dst)) < 0);
	put_byte(srca,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4630_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_NFLG (((uae_s8)(dst)) < 0);
	put_byte(srca,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4638_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_NFLG (((uae_s8)(dst)) < 0);
	put_byte(srca,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4639_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(dst)) == 0);
	SET_NFLG (((uae_s8)(dst)) < 0);
	put_byte(srca,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4640_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_NFLG (((uae_s16)(dst)) < 0);
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xffff) | ((dst) & 0xffff);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4650_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_NFLG (((uae_s16)(dst)) < 0);
	put_word(srca,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4658_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_NFLG (((uae_s16)(dst)) < 0);
	put_word(srca,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4660_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_NFLG (((uae_s16)(dst)) < 0);
	put_word(srca,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4668_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_NFLG (((uae_s16)(dst)) < 0);
	put_word(srca,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4670_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_NFLG (((uae_s16)(dst)) < 0);
	put_word(srca,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4678_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_NFLG (((uae_s16)(dst)) < 0);
	put_word(srca,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4679_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_NFLG (((uae_s16)(dst)) < 0);
	put_word(srca,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4680_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	m68k_dreg(regs, srcreg) = (dst);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4690_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	put_long(srca,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4698_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	put_long(srca,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46a0_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	put_long(srca,dst);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46a8_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	put_long(srca,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46b0_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	put_long(srca,dst);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46b8_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	put_long(srca,dst);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46b9_0)(uae_u32 opcode) /* NOT */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
{	uae_u32 dst = ~src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	put_long(srca,dst);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46c0_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel773; }
{{	uae_s16 src = m68k_dreg(regs, srcreg);
	regs.sr = src;
	MakeFromSR();
}}}m68k_incpc(2);
endlabel773: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46d0_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel774; }
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	regs.sr = src;
	MakeFromSR();
}}}}m68k_incpc(2);
endlabel774: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46d8_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel775; }
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
	regs.sr = src;
	MakeFromSR();
}}}}m68k_incpc(2);
endlabel775: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46e0_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel776; }
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
	regs.sr = src;
	MakeFromSR();
}}}}m68k_incpc(2);
endlabel776: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46e8_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel777; }
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
	regs.sr = src;
	MakeFromSR();
}}}}m68k_incpc(4);
endlabel777: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46f0_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel778; }
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
	regs.sr = src;
	MakeFromSR();
}}}}}endlabel778: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46f8_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
{if (!regs.s) { Exception(8,0); goto endlabel779; }
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
	regs.sr = src;
	MakeFromSR();
}}}}m68k_incpc(4);
endlabel779: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46f9_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
{if (!regs.s) { Exception(8,0); goto endlabel780; }
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
	regs.sr = src;
	MakeFromSR();
}}}}m68k_incpc(6);
endlabel780: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46fa_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
{if (!regs.s) { Exception(8,0); goto endlabel781; }
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
	regs.sr = src;
	MakeFromSR();
}}}}m68k_incpc(4);
endlabel781: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46fb_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
{if (!regs.s) { Exception(8,0); goto endlabel782; }
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
	regs.sr = src;
	MakeFromSR();
}}}}}endlabel782: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_46fc_0)(uae_u32 opcode) /* MV2SR */
{
	cpuop_begin();
{if (!regs.s) { Exception(8,0); goto endlabel783; }
{{	uae_s16 src = get_iword(2);
	regs.sr = src;
	MakeFromSR();
}}}m68k_incpc(4);
endlabel783: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4800_0)(uae_u32 opcode) /* NBCD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
{	uae_u16 newv_lo = - (src & 0xF) - (GET_XFLG ? 1 : 0);
	uae_u16 newv_hi = - (src & 0xF0);
	uae_u16 newv;
	int cflg;
	if (newv_lo > 9) { newv_lo -= 6; }
	newv = newv_hi + newv_lo;
	cflg = (newv & 0x1F0) > 0x90;
	if (cflg) newv -= 0x60;
	SET_CFLG (cflg);
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xff) | ((newv) & 0xff);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4808_0)(uae_u32 opcode) /* LINK */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr olda = m68k_areg(regs, 7) - 4;
	m68k_areg (regs, 7) = olda;
{	uae_s32 src = m68k_areg(regs, srcreg);
	put_long(olda,src);
	m68k_areg(regs, srcreg) = (m68k_areg(regs, 7));
{	uae_s32 offs = get_ilong(2);
	m68k_areg(regs, 7) += offs;
}}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4810_0)(uae_u32 opcode) /* NBCD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
{	uae_u16 newv_lo = - (src & 0xF) - (GET_XFLG ? 1 : 0);
	uae_u16 newv_hi = - (src & 0xF0);
	uae_u16 newv;
	int cflg;
	if (newv_lo > 9) { newv_lo -= 6; }
	newv = newv_hi + newv_lo;
	cflg = (newv & 0x1F0) > 0x90;
	if (cflg) newv -= 0x60;
	SET_CFLG (cflg);
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4818_0)(uae_u32 opcode) /* NBCD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	uae_u16 newv_lo = - (src & 0xF) - (GET_XFLG ? 1 : 0);
	uae_u16 newv_hi = - (src & 0xF0);
	uae_u16 newv;
	int cflg;
	if (newv_lo > 9) { newv_lo -= 6; }
	newv = newv_hi + newv_lo;
	cflg = (newv & 0x1F0) > 0x90;
	if (cflg) newv -= 0x60;
	SET_CFLG (cflg);
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4820_0)(uae_u32 opcode) /* NBCD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
{	uae_u16 newv_lo = - (src & 0xF) - (GET_XFLG ? 1 : 0);
	uae_u16 newv_hi = - (src & 0xF0);
	uae_u16 newv;
	int cflg;
	if (newv_lo > 9) { newv_lo -= 6; }
	newv = newv_hi + newv_lo;
	cflg = (newv & 0x1F0) > 0x90;
	if (cflg) newv -= 0x60;
	SET_CFLG (cflg);
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4828_0)(uae_u32 opcode) /* NBCD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uae_u16 newv_lo = - (src & 0xF) - (GET_XFLG ? 1 : 0);
	uae_u16 newv_hi = - (src & 0xF0);
	uae_u16 newv;
	int cflg;
	if (newv_lo > 9) { newv_lo -= 6; }
	newv = newv_hi + newv_lo;
	cflg = (newv & 0x1F0) > 0x90;
	if (cflg) newv -= 0x60;
	SET_CFLG (cflg);
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4830_0)(uae_u32 opcode) /* NBCD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
{	uae_u16 newv_lo = - (src & 0xF) - (GET_XFLG ? 1 : 0);
	uae_u16 newv_hi = - (src & 0xF0);
	uae_u16 newv;
	int cflg;
	if (newv_lo > 9) { newv_lo -= 6; }
	newv = newv_hi + newv_lo;
	cflg = (newv & 0x1F0) > 0x90;
	if (cflg) newv -= 0x60;
	SET_CFLG (cflg);
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4838_0)(uae_u32 opcode) /* NBCD */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
{	uae_u16 newv_lo = - (src & 0xF) - (GET_XFLG ? 1 : 0);
	uae_u16 newv_hi = - (src & 0xF0);
	uae_u16 newv;
	int cflg;
	if (newv_lo > 9) { newv_lo -= 6; }
	newv = newv_hi + newv_lo;
	cflg = (newv & 0x1F0) > 0x90;
	if (cflg) newv -= 0x60;
	SET_CFLG (cflg);
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4839_0)(uae_u32 opcode) /* NBCD */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
{	uae_u16 newv_lo = - (src & 0xF) - (GET_XFLG ? 1 : 0);
	uae_u16 newv_hi = - (src & 0xF0);
	uae_u16 newv;
	int cflg;
	if (newv_lo > 9) { newv_lo -= 6; }
	newv = newv_hi + newv_lo;
	cflg = (newv & 0x1F0) > 0x90;
	if (cflg) newv -= 0x60;
	SET_CFLG (cflg);
	COPY_CARRY;
	SET_ZFLG (GET_ZFLG & (((uae_s8)(newv)) == 0));
	SET_NFLG (((uae_s8)(newv)) < 0);
	put_byte(srca,newv);
}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4840_0)(uae_u32 opcode) /* SWAP */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_u32 dst = ((src >> 16)&0xFFFF) | ((src&0xFFFF)<<16);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	m68k_dreg(regs, srcreg) = (dst);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4848_0)(uae_u32 opcode) /* BKPT */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{m68k_incpc(2);
	op_illg(opcode);
}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4850_0)(uae_u32 opcode) /* PEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uaecptr dsta = m68k_areg(regs, 7) - 4;
	m68k_areg (regs, 7) = dsta;
	put_long(dsta,srca);
}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4868_0)(uae_u32 opcode) /* PEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uaecptr dsta = m68k_areg(regs, 7) - 4;
	m68k_areg (regs, 7) = dsta;
	put_long(dsta,srca);
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4870_0)(uae_u32 opcode) /* PEA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uaecptr dsta = m68k_areg(regs, 7) - 4;
	m68k_areg (regs, 7) = dsta;
	put_long(dsta,srca);
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4878_0)(uae_u32 opcode) /* PEA */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uaecptr dsta = m68k_areg(regs, 7) - 4;
	m68k_areg (regs, 7) = dsta;
	put_long(dsta,srca);
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4879_0)(uae_u32 opcode) /* PEA */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = get_ilong(2);
{	uaecptr dsta = m68k_areg(regs, 7) - 4;
	m68k_areg (regs, 7) = dsta;
	put_long(dsta,srca);
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_487a_0)(uae_u32 opcode) /* PEA */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uaecptr dsta = m68k_areg(regs, 7) - 4;
	m68k_areg (regs, 7) = dsta;
	put_long(dsta,srca);
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_487b_0)(uae_u32 opcode) /* PEA */
{
	cpuop_begin();
#ifndef NOFLAGS
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uaecptr dsta = m68k_areg(regs, 7) - 4;
	m68k_areg (regs, 7) = dsta;
	put_long(dsta,srca);
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4880_0)(uae_u32 opcode) /* EXT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_u16 dst = (uae_s16)(uae_s8)src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(dst)) == 0);
	SET_NFLG (((uae_s16)(dst)) < 0);
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xffff) | ((dst) & 0xffff);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4890_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
{	uaecptr srca = m68k_areg(regs, dstreg);
{	uae_u16 dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
	while (dmask) { put_word(srca, m68k_dreg(regs, movem_index1[dmask])); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { put_word(srca, m68k_areg(regs, movem_index1[amask])); srca += 2; amask = movem_next[amask]; }
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48a0_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
{	uaecptr srca = m68k_areg(regs, dstreg) - 0;
{	uae_u16 amask = mask & 0xff, dmask = (mask >> 8) & 0xff;
	while (amask) { srca -= 2; put_word(srca, m68k_areg(regs, movem_index2[amask])); amask = movem_next[amask]; }
	while (dmask) { srca -= 2; put_word(srca, m68k_dreg(regs, movem_index2[dmask])); dmask = movem_next[dmask]; }
	m68k_areg(regs, dstreg) = srca;
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48a8_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
{	uaecptr srca = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_u16 dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
	while (dmask) { put_word(srca, m68k_dreg(regs, movem_index1[dmask])); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { put_word(srca, m68k_areg(regs, movem_index1[amask])); srca += 2; amask = movem_next[amask]; }
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48b0_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
{m68k_incpc(4);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_u16 dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
	while (dmask) { put_word(srca, m68k_dreg(regs, movem_index1[dmask])); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { put_word(srca, m68k_areg(regs, movem_index1[amask])); srca += 2; amask = movem_next[amask]; }
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48b8_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
{	uae_u16 mask = get_iword(2);
{	uaecptr srca = (uae_s32)(uae_s16)get_iword(4);
{	uae_u16 dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
	while (dmask) { put_word(srca, m68k_dreg(regs, movem_index1[dmask])); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { put_word(srca, m68k_areg(regs, movem_index1[amask])); srca += 2; amask = movem_next[amask]; }
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48b9_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
{	uae_u16 mask = get_iword(2);
{	uaecptr srca = get_ilong(4);
{	uae_u16 dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
	while (dmask) { put_word(srca, m68k_dreg(regs, movem_index1[dmask])); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { put_word(srca, m68k_areg(regs, movem_index1[amask])); srca += 2; amask = movem_next[amask]; }
}}}m68k_incpc(8);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48c0_0)(uae_u32 opcode) /* EXT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_u32 dst = (uae_s32)(uae_s16)src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	m68k_dreg(regs, srcreg) = (dst);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48d0_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
{	uaecptr srca = m68k_areg(regs, dstreg);
{	uae_u16 dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
	while (dmask) { put_long(srca, m68k_dreg(regs, movem_index1[dmask])); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { put_long(srca, m68k_areg(regs, movem_index1[amask])); srca += 4; amask = movem_next[amask]; }
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48e0_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
{	uaecptr srca = m68k_areg(regs, dstreg) - 0;
{	uae_u16 amask = mask & 0xff, dmask = (mask >> 8) & 0xff;
	while (amask) { srca -= 4; put_long(srca, m68k_areg(regs, movem_index2[amask])); amask = movem_next[amask]; }
	while (dmask) { srca -= 4; put_long(srca, m68k_dreg(regs, movem_index2[dmask])); dmask = movem_next[dmask]; }
	m68k_areg(regs, dstreg) = srca;
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48e8_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
{	uaecptr srca = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_u16 dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
	while (dmask) { put_long(srca, m68k_dreg(regs, movem_index1[dmask])); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { put_long(srca, m68k_areg(regs, movem_index1[amask])); srca += 4; amask = movem_next[amask]; }
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48f0_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
{m68k_incpc(4);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_u16 dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
	while (dmask) { put_long(srca, m68k_dreg(regs, movem_index1[dmask])); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { put_long(srca, m68k_areg(regs, movem_index1[amask])); srca += 4; amask = movem_next[amask]; }
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48f8_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
{	uae_u16 mask = get_iword(2);
{	uaecptr srca = (uae_s32)(uae_s16)get_iword(4);
{	uae_u16 dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
	while (dmask) { put_long(srca, m68k_dreg(regs, movem_index1[dmask])); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { put_long(srca, m68k_areg(regs, movem_index1[amask])); srca += 4; amask = movem_next[amask]; }
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_48f9_0)(uae_u32 opcode) /* MVMLE */
{
	cpuop_begin();
#ifndef NOFLAGS
{	uae_u16 mask = get_iword(2);
{	uaecptr srca = get_ilong(4);
{	uae_u16 dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
	while (dmask) { put_long(srca, m68k_dreg(regs, movem_index1[dmask])); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { put_long(srca, m68k_areg(regs, movem_index1[amask])); srca += 4; amask = movem_next[amask]; }
}}}m68k_incpc(8);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_49c0_0)(uae_u32 opcode) /* EXT */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
{	uae_u32 dst = (uae_s32)(uae_s8)src;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(dst)) == 0);
	SET_NFLG (((uae_s32)(dst)) < 0);
	m68k_dreg(regs, srcreg) = (dst);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a00_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a10_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a18_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a20_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a28_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a30_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a38_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a39_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a3a_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a3b_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a3c_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uae_s8 src = get_ibyte(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a40_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a48_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_areg(regs, srcreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a50_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a58_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s16 src = get_word(srca);
	m68k_areg(regs, srcreg) += 2;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a60_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 2;
{	uae_s16 src = get_word(srca);
	m68k_areg (regs, srcreg) = srca;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a68_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a70_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s16 src = get_word(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a78_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a79_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s16 src = get_word(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a7a_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 src = get_word(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a7b_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s16 src = get_word(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a7c_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uae_s16 src = get_iword(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s16)(src)) == 0);
	SET_NFLG (((uae_s16)(src)) < 0);
}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a80_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_dreg(regs, srcreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a88_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a90_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4a98_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s32 src = get_long(srca);
	m68k_areg(regs, srcreg) += 4;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4aa0_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - 4;
{	uae_s32 src = get_long(srca);
	m68k_areg (regs, srcreg) = srca;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4aa8_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ab0_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s32 src = get_long(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ab8_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ab9_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s32 src = get_long(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4aba_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 src = get_long(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4abb_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 src = get_long(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4abc_0)(uae_u32 opcode) /* TST */
{
	cpuop_begin();
{{	uae_s32 src = get_ilong(2);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s32)(src)) == 0);
	SET_NFLG (((uae_s32)(src)) < 0);
}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ac0_0)(uae_u32 opcode) /* TAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s8 src = m68k_dreg(regs, srcreg);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	src |= 0x80;
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xff) | ((src) & 0xff);
}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ad0_0)(uae_u32 opcode) /* TAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	src |= 0x80;
	put_byte(srca,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ad8_0)(uae_u32 opcode) /* TAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	uae_s8 src = get_byte(srca);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	src |= 0x80;
	put_byte(srca,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ae0_0)(uae_u32 opcode) /* TAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
{	uae_s8 src = get_byte(srca);
	m68k_areg (regs, srcreg) = srca;
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	src |= 0x80;
	put_byte(srca,src);
}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ae8_0)(uae_u32 opcode) /* TAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	src |= 0x80;
	put_byte(srca,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4af0_0)(uae_u32 opcode) /* TAS */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	src |= 0x80;
	put_byte(srca,src);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4af8_0)(uae_u32 opcode) /* TAS */
{
	cpuop_begin();
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	src |= 0x80;
	put_byte(srca,src);
}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4af9_0)(uae_u32 opcode) /* TAS */
{
	cpuop_begin();
{{	uaecptr srca = get_ilong(2);
{	uae_s8 src = get_byte(srca);
	CLEAR_CZNV;
	SET_ZFLG (((uae_s8)(src)) == 0);
	SET_NFLG (((uae_s8)(src)) < 0);
	src |= 0x80;
	put_byte(srca,src);
}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c00_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 extra = get_iword(2);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
m68k_incpc(4);
	m68k_mull(opcode, dst, extra);
}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c10_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
m68k_incpc(4);
	m68k_mull(opcode, dst, extra);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c18_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	m68k_areg(regs, dstreg) += 4;
m68k_incpc(4);
	m68k_mull(opcode, dst, extra);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c20_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
{	uae_s32 dst = get_long(dsta);
	m68k_areg (regs, dstreg) = dsta;
m68k_incpc(4);
	m68k_mull(opcode, dst, extra);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c28_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	uae_s32 dst = get_long(dsta);
m68k_incpc(6);
	m68k_mull(opcode, dst, extra);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c30_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_s16 extra = get_iword(2);
{m68k_incpc(4);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 dst = get_long(dsta);
	m68k_mull(opcode, dst, extra);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c38_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
{{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(4);
{	uae_s32 dst = get_long(dsta);
m68k_incpc(6);
	m68k_mull(opcode, dst, extra);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c39_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
{{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = get_ilong(4);
{	uae_s32 dst = get_long(dsta);
m68k_incpc(8);
	m68k_mull(opcode, dst, extra);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c3a_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{{	uae_s16 extra = get_iword(2);
{	uaecptr dsta = m68k_getpc () + 4;
	dsta += (uae_s32)(uae_s16)get_iword(4);
{	uae_s32 dst = get_long(dsta);
m68k_incpc(6);
	m68k_mull(opcode, dst, extra);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c3b_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{{	uae_s16 extra = get_iword(2);
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 dst = get_long(dsta);
	m68k_mull(opcode, dst, extra);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c3c_0)(uae_u32 opcode) /* MULL */
{
	cpuop_begin();
{{	uae_s16 extra = get_iword(2);
{	uae_s32 dst = get_ilong(4);
m68k_incpc(8);
	m68k_mull(opcode, dst, extra);
}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c40_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{	uae_s32 dst = m68k_dreg(regs, dstreg);
m68k_incpc(2);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c50_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
m68k_incpc(2);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c58_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	m68k_areg(regs, dstreg) += 4;
m68k_incpc(2);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c60_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
{	uae_s32 dst = get_long(dsta);
	m68k_areg (regs, dstreg) = dsta;
m68k_incpc(2);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c68_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 dst = get_long(dsta);
m68k_incpc(4);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c70_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 dst = get_long(dsta);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c78_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 dst = get_long(dsta);
m68k_incpc(4);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c79_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{	uaecptr dsta = get_ilong(2);
{	uae_s32 dst = get_long(dsta);
m68k_incpc(6);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c7a_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
	uae_u32 dstreg = 2;
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{	uaecptr dsta = m68k_getpc () + 2;
	dsta += (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 dst = get_long(dsta);
m68k_incpc(4);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c7b_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
	uae_u32 dstreg = 3;
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr dsta = get_disp_ea_020(tmppc, next_iword());
{	uae_s32 dst = get_long(dsta);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c7c_0)(uae_u32 opcode) /* DIVL */
{
	cpuop_begin();
{m68k_incpc(2);
{	uaecptr oldpc = m68k_getpc();
{	uae_s16 extra = get_iword(0);
{	uae_s32 dst = get_ilong(2);
m68k_incpc(6);
	m68k_divl(opcode, dst, extra, oldpc);
}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c90_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = m68k_areg(regs, dstreg);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; amask = movem_next[amask]; }
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4c98_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = m68k_areg(regs, dstreg);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; amask = movem_next[amask]; }
	m68k_areg(regs, dstreg) = srca;
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ca8_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; amask = movem_next[amask]; }
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cb0_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{m68k_incpc(4);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; amask = movem_next[amask]; }
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cb8_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = (uae_s32)(uae_s16)get_iword(4);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; amask = movem_next[amask]; }
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cb9_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = get_ilong(4);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; amask = movem_next[amask]; }
}}}m68k_incpc(8);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cba_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
	uae_u32 dstreg = 2;
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = m68k_getpc () + 4;
	srca += (uae_s32)(uae_s16)get_iword(4);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; amask = movem_next[amask]; }
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cbb_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
	uae_u32 dstreg = 3;
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = (uae_s32)(uae_s16)get_word(srca); srca += 2; amask = movem_next[amask]; }
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cd0_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = m68k_areg(regs, dstreg);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = get_long(srca); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = get_long(srca); srca += 4; amask = movem_next[amask]; }
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cd8_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = m68k_areg(regs, dstreg);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = get_long(srca); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = get_long(srca); srca += 4; amask = movem_next[amask]; }
	m68k_areg(regs, dstreg) = srca;
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ce8_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(4);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = get_long(srca); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = get_long(srca); srca += 4; amask = movem_next[amask]; }
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cf0_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{m68k_incpc(4);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = get_long(srca); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = get_long(srca); srca += 4; amask = movem_next[amask]; }
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cf8_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = (uae_s32)(uae_s16)get_iword(4);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = get_long(srca); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = get_long(srca); srca += 4; amask = movem_next[amask]; }
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cf9_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = get_ilong(4);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = get_long(srca); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = get_long(srca); srca += 4; amask = movem_next[amask]; }
}}}m68k_incpc(8);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cfa_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
	uae_u32 dstreg = 2;
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{	uaecptr srca = m68k_getpc () + 4;
	srca += (uae_s32)(uae_s16)get_iword(4);
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = get_long(srca); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = get_long(srca); srca += 4; amask = movem_next[amask]; }
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4cfb_0)(uae_u32 opcode) /* MVMEL */
{
	cpuop_begin();
#ifndef NOFLAGS
	uae_u32 dstreg = 3;
{	uae_u16 mask = get_iword(2);
	unsigned int dmask = mask & 0xff, amask = (mask >> 8) & 0xff;
{m68k_incpc(4);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
{	while (dmask) { m68k_dreg(regs, movem_index1[dmask]) = get_long(srca); srca += 4; dmask = movem_next[dmask]; }
	while (amask) { m68k_areg(regs, movem_index1[amask]) = get_long(srca); srca += 4; amask = movem_next[amask]; }
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e40_0)(uae_u32 opcode) /* TRAP */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 15);
#else
	uae_u32 srcreg = (opcode & 15);
#endif
{{	uae_u32 src = srcreg;
m68k_incpc(2);
	Exception(src+32,0);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e50_0)(uae_u32 opcode) /* LINK */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr olda = m68k_areg(regs, 7) - 4;
	m68k_areg (regs, 7) = olda;
{	uae_s32 src = m68k_areg(regs, srcreg);
	put_long(olda,src);
	m68k_areg(regs, srcreg) = (m68k_areg(regs, 7));
{	uae_s16 offs = get_iword(2);
	m68k_areg(regs, 7) += offs;
}}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e58_0)(uae_u32 opcode) /* UNLK */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s32 src = m68k_areg(regs, srcreg);
	m68k_areg(regs, 7) = src;
{	uaecptr olda = m68k_areg(regs, 7);
{	uae_s32 old = get_long(olda);
	m68k_areg(regs, 7) += 4;
	m68k_areg(regs, srcreg) = (old);
}}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e60_0)(uae_u32 opcode) /* MVR2USP */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel901; }
{{	uae_s32 src = m68k_areg(regs, srcreg);
	regs.usp = src;
}}}m68k_incpc(2);
endlabel901: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e68_0)(uae_u32 opcode) /* MVUSP2R */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{if (!regs.s) { Exception(8,0); goto endlabel902; }
{{	m68k_areg(regs, srcreg) = (regs.usp);
}}}m68k_incpc(2);
endlabel902: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e70_0)(uae_u32 opcode) /* RESET */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel903; }
{}}m68k_incpc(2);
endlabel903: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e71_0)(uae_u32 opcode) /* NOP */
{
	cpuop_begin();
#ifndef NOFLAGS
{}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e72_0)(uae_u32 opcode) /* STOP */
{
	cpuop_begin();
{if (!regs.s) { Exception(8,0); goto endlabel905; }
{{	uae_s16 src = get_iword(2);
	regs.sr = src;
	MakeFromSR();
	m68k_setstopped(1);
}}}m68k_incpc(4);
endlabel905: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e73_0)(uae_u32 opcode) /* RTE */
{
	cpuop_begin();
{if (!regs.s) { Exception(8,0); goto endlabel906; }
{	uae_u16 newsr; uae_u32 newpc; for (;;) {
{	uaecptr sra = m68k_areg(regs, 7);
{	uae_s16 sr = get_word(sra);
	m68k_areg(regs, 7) += 2;
{	uaecptr pca = m68k_areg(regs, 7);
{	uae_s32 pc = get_long(pca);
	m68k_areg(regs, 7) += 4;
{	uaecptr formata = m68k_areg(regs, 7);
{	uae_s16 format = get_word(formata);
	m68k_areg(regs, 7) += 2;
	newsr = sr; newpc = pc;
	if ((format & 0xF000) == 0x0000) { break; }
	else if ((format & 0xF000) == 0x1000) { ; }
	else if ((format & 0xF000) == 0x2000) { m68k_areg(regs, 7) += 4; break; }
	else if ((format & 0xF000) == 0x3000) { m68k_areg(regs, 7) += 4; break; }
	else if ((format & 0xF000) == 0x7000) { m68k_areg(regs, 7) += 52; break; }
	else if ((format & 0xF000) == 0x8000) { m68k_areg(regs, 7) += 50; break; }
	else if ((format & 0xF000) == 0x9000) { m68k_areg(regs, 7) += 12; break; }
	else if ((format & 0xF000) == 0xa000) { m68k_areg(regs, 7) += 24; break; }
	else if ((format & 0xF000) == 0xb000) { m68k_areg(regs, 7) += 84; break; }
	else { Exception(14,0); goto endlabel906; }
	regs.sr = newsr; MakeFromSR();
}
}}}}}}	regs.sr = newsr; MakeFromSR();
	m68k_setpc_rte(newpc);
}}endlabel906: ;
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e74_0)(uae_u32 opcode) /* RTD */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr pca = m68k_areg(regs, 7);
{	uae_s32 pc = get_long(pca);
	m68k_areg(regs, 7) += 4;
{	uae_s16 offs = get_iword(2);
	m68k_areg(regs, 7) += offs;
	m68k_setpc_rte(pc);
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e75_0)(uae_u32 opcode) /* RTS */
{
	cpuop_begin();
#ifndef NOFLAGS
{	m68k_do_rts();
}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e76_0)(uae_u32 opcode) /* TRAPV */
{
	cpuop_begin();
#ifndef NOFLAGS
{m68k_incpc(2);
	if (GET_VFLG) { Exception(7,m68k_getpc()); goto endlabel909; }
}endlabel909: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e77_0)(uae_u32 opcode) /* RTR */
{
	cpuop_begin();
{	MakeSR();
{	uaecptr sra = m68k_areg(regs, 7);
{	uae_s16 sr = get_word(sra);
	m68k_areg(regs, 7) += 2;
{	uaecptr pca = m68k_areg(regs, 7);
{	uae_s32 pc = get_long(pca);
	m68k_areg(regs, 7) += 4;
	regs.sr &= 0xFF00; sr &= 0xFF;
	regs.sr |= sr; m68k_setpc(pc);
	MakeFromSR();
}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e7a_0)(uae_u32 opcode) /* MOVEC2 */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel911; }
{{	uae_s16 src = get_iword(2);
{	int regno = (src >> 12) & 15;
	uae_u32 *regp = regs.regs + regno;
	if (! m68k_movec2(src & 0xFFF, regp)) goto endlabel911;
}}}}m68k_incpc(4);
endlabel911: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e7b_0)(uae_u32 opcode) /* MOVE2C */
{
	cpuop_begin();
#ifndef NOFLAGS
{if (!regs.s) { Exception(8,0); goto endlabel912; }
{{	uae_s16 src = get_iword(2);
{	int regno = (src >> 12) & 15;
	uae_u32 *regp = regs.regs + regno;
	if (! m68k_move2c(src & 0xFFF, regp)) goto endlabel912;
}}}}m68k_incpc(4);
endlabel912: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4e90_0)(uae_u32 opcode) /* JSR */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	m68k_do_jsr(m68k_getpc() + 2, srca);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ea8_0)(uae_u32 opcode) /* JSR */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
	m68k_do_jsr(m68k_getpc() + 4, srca);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4eb0_0)(uae_u32 opcode) /* JSR */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
	m68k_do_jsr(m68k_getpc() + 0, srca);
}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4eb8_0)(uae_u32 opcode) /* JSR */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
	m68k_do_jsr(m68k_getpc() + 4, srca);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4eb9_0)(uae_u32 opcode) /* JSR */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = get_ilong(2);
	m68k_do_jsr(m68k_getpc() + 6, srca);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4eba_0)(uae_u32 opcode) /* JSR */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
	m68k_do_jsr(m68k_getpc() + 4, srca);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ebb_0)(uae_u32 opcode) /* JSR */
{
	cpuop_begin();
#ifndef NOFLAGS
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
	m68k_do_jsr(m68k_getpc() + 0, srca);
}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ed0_0)(uae_u32 opcode) /* JMP */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	m68k_setpc(srca);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ee8_0)(uae_u32 opcode) /* JMP */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
	m68k_setpc(srca);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ef0_0)(uae_u32 opcode) /* JMP */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
	m68k_setpc(srca);
}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ef8_0)(uae_u32 opcode) /* JMP */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
	m68k_setpc(srca);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4ef9_0)(uae_u32 opcode) /* JMP */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = get_ilong(2);
	m68k_setpc(srca);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4efa_0)(uae_u32 opcode) /* JMP */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = m68k_getpc () + 2;
	srca += (uae_s32)(uae_s16)get_iword(2);
	m68k_setpc(srca);
}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_4efb_0)(uae_u32 opcode) /* JMP */
{
	cpuop_begin();
#ifndef NOFLAGS
{{m68k_incpc(2);
{	uaecptr tmppc = m68k_getpc();
	uaecptr srca = get_disp_ea_020(tmppc, next_iword());
	m68k_setpc(srca);
}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5000_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uae_s8 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((newv) & 0xff);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5010_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5018_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5020_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5028_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5030_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5038_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5039_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = get_ilong(2);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) + ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u8)(~dst)) < ((uae_u8)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
#endif

#ifdef PART_5
void REGPARAM2 CPUFUNC(op_5040_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uae_s16 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((newv) & 0xffff);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5048_0)(uae_u32 opcode) /* ADDA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uae_s32 dst = m68k_areg(regs, dstreg);
{	uae_u32 newv = dst + src;
	m68k_areg(regs, dstreg) = (newv);
}}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5050_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5058_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	m68k_areg(regs, dstreg) += 2;
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5060_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
{	uae_s16 dst = get_word(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5068_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5070_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5078_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5079_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = get_ilong(2);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) + ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u16)(~dst)) < ((uae_u16)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5080_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uae_s32 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (newv);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5088_0)(uae_u32 opcode) /* ADDA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uae_s32 dst = m68k_areg(regs, dstreg);
{	uae_u32 newv = dst + src;
	m68k_areg(regs, dstreg) = (newv);
}}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5090_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5098_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s32 dst = get_long(dsta);
	m68k_areg(regs, dstreg) += 4;
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50a0_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg) - 4;
{	uae_s32 dst = get_long(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50a8_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50b0_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50b8_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50b9_0)(uae_u32 opcode) /* ADD */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = get_ilong(2);
{	uae_s32 dst = get_long(dsta);
{{uae_u32 newv = ((uae_s32)(dst)) + ((uae_s32)(src));
{	int flgs = ((uae_s32)(src)) < 0;
	int flgo = ((uae_s32)(dst)) < 0;
	int flgn = ((uae_s32)(newv)) < 0;
	SET_ZFLG (((uae_s32)(newv)) == 0);
	SET_VFLG ((flgs ^ flgn) & (flgo ^ flgn));
	SET_CFLG (((uae_u32)(~dst)) < ((uae_u32)(src)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_long(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50c0_0)(uae_u32 opcode) /* Scc */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{{	int val = cctrue(0) ? 0xff : 0;
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xff) | ((val) & 0xff);
}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50c8_0)(uae_u32 opcode) /* DBcc */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uae_s16 src = m68k_dreg(regs, srcreg);
{	uae_s16 offs = get_iword(2);
	if (!cctrue(0)) {
	m68k_dreg(regs, srcreg) = (m68k_dreg(regs, srcreg) & ~0xffff) | (((src-1)) & 0xffff);
		if (src) {
			m68k_incpc((uae_s32)offs + 2);
return;
		}
	}
}}}m68k_incpc(4);
endlabel954: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50d0_0)(uae_u32 opcode) /* Scc */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
{	int val = cctrue(0) ? 0xff : 0;
	put_byte(srca,val);
}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50d8_0)(uae_u32 opcode) /* Scc */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg);
	m68k_areg(regs, srcreg) += areg_byteinc[srcreg];
{	int val = cctrue(0) ? 0xff : 0;
	put_byte(srca,val);
}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50e0_0)(uae_u32 opcode) /* Scc */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) - areg_byteinc[srcreg];
	m68k_areg (regs, srcreg) = srca;
{	int val = cctrue(0) ? 0xff : 0;
	put_byte(srca,val);
}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50e8_0)(uae_u32 opcode) /* Scc */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{	uaecptr srca = m68k_areg(regs, srcreg) + (uae_s32)(uae_s16)get_iword(2);
{	int val = cctrue(0) ? 0xff : 0;
	put_byte(srca,val);
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50f0_0)(uae_u32 opcode) /* Scc */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = ((opcode >> 8) & 7);
#else
	uae_u32 srcreg = (opcode & 7);
#endif
{{m68k_incpc(2);
{	uaecptr srca = get_disp_ea_020(m68k_areg(regs, srcreg), next_iword());
{	int val = cctrue(0) ? 0xff : 0;
	put_byte(srca,val);
}}}}
#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50f8_0)(uae_u32 opcode) /* Scc */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = (uae_s32)(uae_s16)get_iword(2);
{	int val = cctrue(0) ? 0xff : 0;
	put_byte(srca,val);
}}}m68k_incpc(4);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50f9_0)(uae_u32 opcode) /* Scc */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uaecptr srca = get_ilong(2);
{	int val = cctrue(0) ? 0xff : 0;
	put_byte(srca,val);
}}}m68k_incpc(6);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50fa_0)(uae_u32 opcode) /* TRAPcc */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uae_s16 dummy = get_iword(2);
	if (cctrue(0)) { Exception(7,m68k_getpc()); goto endlabel962; }
}}m68k_incpc(4);
endlabel962: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50fb_0)(uae_u32 opcode) /* TRAPcc */
{
	cpuop_begin();
#ifndef NOFLAGS
{{	uae_s32 dummy = get_ilong(2);
	if (cctrue(0)) { Exception(7,m68k_getpc()); goto endlabel963; }
}}m68k_incpc(6);
endlabel963: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_50fc_0)(uae_u32 opcode) /* TRAPcc */
{
	cpuop_begin();
#ifndef NOFLAGS
{	if (cctrue(0)) { Exception(7,m68k_getpc()); goto endlabel964; }
}m68k_incpc(2);
endlabel964: ;

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5100_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uae_s8 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xff) | ((newv) & 0xff);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5110_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5118_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s8 dst = get_byte(dsta);
	m68k_areg(regs, dstreg) += areg_byteinc[dstreg];
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5120_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg) - areg_byteinc[dstreg];
{	uae_s8 dst = get_byte(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5128_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5130_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5138_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5139_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = get_ilong(2);
{	uae_s8 dst = get_byte(dsta);
{{uae_u32 newv = ((uae_s8)(dst)) - ((uae_s8)(src));
{	int flgs = ((uae_s8)(src)) < 0;
	int flgo = ((uae_s8)(dst)) < 0;
	int flgn = ((uae_s8)(newv)) < 0;
	SET_ZFLG (((uae_s8)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u8)(src)) > ((uae_u8)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_byte(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5140_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uae_s16 dst = m68k_dreg(regs, dstreg);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	m68k_dreg(regs, dstreg) = (m68k_dreg(regs, dstreg) & ~0xffff) | ((newv) & 0xffff);
}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5148_0)(uae_u32 opcode) /* SUBA */
{
	cpuop_begin();
#ifndef NOFLAGS
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uae_s32 dst = m68k_areg(regs, dstreg);
{	uae_u32 newv = dst - src;
	m68k_areg(regs, dstreg) = (newv);
}}}}m68k_incpc(2);

#endif
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5150_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5158_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg);
{	uae_s16 dst = get_word(dsta);
	m68k_areg(regs, dstreg) += 2;
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5160_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg) - 2;
{	uae_s16 dst = get_word(dsta);
	m68k_areg (regs, dstreg) = dsta;
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(2);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5168_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = m68k_areg(regs, dstreg) + (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5170_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#else
	uae_u32 dstreg = opcode & 7;
#endif
{{	uae_u32 src = srcreg;
{m68k_incpc(2);
{	uaecptr dsta = get_disp_ea_020(m68k_areg(regs, dstreg), next_iword());
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}}	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5178_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = (uae_s32)(uae_s16)get_iword(2);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(4);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5179_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
{{	uae_u32 src = srcreg;
{	uaecptr dsta = get_ilong(2);
{	uae_s16 dst = get_word(dsta);
{{uae_u32 newv = ((uae_s16)(dst)) - ((uae_s16)(src));
{	int flgs = ((uae_s16)(src)) < 0;
	int flgo = ((uae_s16)(dst)) < 0;
	int flgn = ((uae_s16)(newv)) < 0;
	SET_ZFLG (((uae_s16)(newv)) == 0);
	SET_VFLG ((flgs ^ flgo) & (flgn ^ flgo));
	SET_CFLG (((uae_u16)(src)) > ((uae_u16)(dst)));
	COPY_CARRY;
	SET_NFLG (flgn != 0);
	put_word(dsta,newv);
}}}}}}}m68k_incpc(6);
	cpuop_end();
}
void REGPARAM2 CPUFUNC(op_5180_0)(uae_u32 opcode) /* SUB */
{
	cpuop_begin();
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 srcreg = imm8_table[((opcode >> 1) & 7)];
#else
	uae_u32 srcreg = imm8_table[((opcode >> 9) & 7)];
#endif
#ifdef HAVE_GET_WORD_UNSWAPPED
	uae_u32 dstreg = (opcode >> 8) & 7;
#e