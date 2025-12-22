#ifndef IOBLIX_TOOLLIB_H
#define IOBLIX_TOOLLIB_H 1

#include <exec/types.h>
#include <exec/ports.h>
#include <devices/timer.h>

/* useful functions for MsgPorts and Signals */
BOOL AllocPort( struct MsgPort *port );
void FreePort( struct MsgPort *port );
BYTE AllocSig( BYTE instead );
void FreeSig ( BYTE sig );

/* useful functions for timerequests */
void TimerDelay( struct timerequest *treq,
                 ULONG secs,
                 ULONG mics );
void StartTimer( struct timerequest *treq,
                 ULONG secs,
                 ULONG mics );

/* useful functions for UARTs */
void uart_init( struct IOBlixChipNode *icn,
                struct SerialPrefs *prefs,
                BOOL test );
void uart_deinit( struct IOBlixChipNode *icn );


/* useful functions for Ethernet chip */
void smc_reset( struct EthernetRegisters *ec,
                UWORD ephEnable );
void smc_enable( struct EthernetRegisters *ec,
                 BOOL noFullDuplex,
                 BOOL loop);
void smc_shutdown( struct EthernetRegisters *ec );
void smc_get_mac_address( struct EthernetRegisters *ec,
                          UBYTE *addrBuf );
void smc_set_mac_address( struct EthernetRegisters *ec,
                          UBYTE *addrBuf );

/* little-endian <-> big-endian conversions */
UWORD i2m_word( UWORD d );
ULONG i2m_long( ULONG d );

/* 64bit math functions */
struct Integer64 {
    ULONG i64_Upper;
    ULONG i64_Lower;
};

/* dst += src */
void ASM add64 ( REG(a0) struct Integer64 *dst,
                 REG(a1) struct Integer64 *src );

/* dst -= src */
void ASM sub64 ( REG(a0) struct Integer64 *dst,
                 REG(a1) struct Integer64 *src );

/*
    dst < src       -1
    dst = src        0
    dst > src        1
*/
int ASM cmp64 ( REG(a0) struct Integer64 *dst,
                REG(a1) struct Integer64 *src );

/* useful functions for strings */
void _sprintf( UBYTE *buffer,
               UBYTE *fmt,... );

void ErrorMsg( UBYTE *msg,
               UBYTE *device,
               ULONG unitNum, ... );

#endif


