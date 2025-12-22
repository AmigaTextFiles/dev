#ifndef SID6581_SID6581_H
#define SID6581_SID6581_H

/*
**	$VER: sid6581.h 1.0 (22.07.2003)
**
**	6581sid library structures
**
*/

/* SID handle structure */
struct SIDHandle
{
 long sid_Private1;
 char sid_Enabled;
 char sid_Filter;
 char sid_60Hz;
 char sid_RingQual;
 char sid_SyncQual;
 long sid_Private2;
 char sid_ADSRQual;
 long sid_Private3;
 short sid_IRQRate;
};

#endif /* SID6581_SID6581_H */

