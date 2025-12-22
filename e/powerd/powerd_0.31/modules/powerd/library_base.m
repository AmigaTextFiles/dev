OPT    LINK='library_base.lib'

MODULE    'exec/libraries',
          'exec/semaphores'

OBJECT LibGenBase
  library   :Library,
  flags     :BYTE,
  pad       :BYTE,
  segment   :BPTR,
  semaphore :SignalSemaphore

EDEF	ExecBase:PTR TO Library
