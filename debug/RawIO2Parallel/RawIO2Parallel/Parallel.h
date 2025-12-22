#ifndef __PARALLEL_H_
#define __PARALLEL_H_

void ParallelIOInit(void);
void *GetParallelIOInitAddr(void)="\tlea\t_ParallelIOInit(pc),a0\n\tmove.l\ta0,d0";
char ParallelPutChar(__reg("d0") c);
void *GetParallelPutCharAddr(void)="\tlea\t_ParallelPutChar(pc),a0\n\tmove.l\ta0,d0";
int ParallelMayGetChar(void);
void *GetParallelMayGetCharAddr(void)="\tlea\tPRawMayGetChar(pc),a0\n\tmove.l\ta0,d0";

#endif
