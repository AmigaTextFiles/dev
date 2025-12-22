//===========================================================================
//
// Amiga Demo Tutorial - Alain Bocherens [alain@devils.ch]
//
// Nom: c2p.h
//
// Classes: -
//
// Fonction: C2P (chunky 2 planar) specifique 68060
//
//===========================================================================

//---------------------------------------------------------------------------
// Includes
//---------------------------------------------------------------------------
#ifndef C2P_H
#define C2P_H

extern "ASM" void WriteChunkyPixel256_Fast_v12(register __a1 struct BitMap *,register __a0 UBYTE *,
                                        register __d0 LONG,register __d1 LONG,
                                        register __d2 WORD,register __d3 LONG);

#endif
