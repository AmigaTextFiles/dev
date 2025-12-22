
/*
 *  FIFO.H
 *
 *  PUBLIC FIFO STRUCTURES AND DEFINES
 */

#ifndef CLIB_FIFO_PROTOS_H
#define CLIB_FIFO_PROTOS_H

#ifndef LIBRARIES_FIFO_H
#include <libraries/fifo.h>
#endif


FifoHan OpenFifo(char *name, long bytes, long flags);
void CloseFifo(FifoHan fifo, long flags);
long ReadFifo(FifoHan fifo, char **buf, long bytes);
long WriteFifo(FifoHan fifo, char *buf, long bytes);
void RequestFifo(FifoHan fifo, struct Message *msg, long req);
long BufSizeFifo(FifoHan fifo);

#endif

