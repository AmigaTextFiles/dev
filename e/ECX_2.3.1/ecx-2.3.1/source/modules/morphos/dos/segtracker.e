OPT MODULE, EXPORT, PREPROCESS

-> dos/segtracker.e (MorphOS)

MODULE 'exec/types'
MODULE 'exec/semaphores'
MODULE 'exec/nodes'
MODULE 'exec/semaphores'

#define SEG_SEM 'SegTracker'


OBJECT segsem
   semaphore:ss
   find:LONG
   /* Name := seg_Find(address [REG_A0], segnum:PTR TO LONG [REG_A1], offset:PTR TO LONG [REG_A2]) */
   list:mln
ENDOBJECT

OBJECT segarray
   address:LONG
   size:LONG
ENDOBJECT

OBJECT segnode
   node:mln
   name:PTR TO CHAR
   array:segarray
ENDOBJECT
