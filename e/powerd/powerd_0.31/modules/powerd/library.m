OPT    LINK='library.lib'

MODULE	'exec/libraries',
			'exec/semaphores',
			'exec',
			'dos',
			'intuition',
			'graphics'

OBJECT LibGenBase
  library   :Library,
  flags     :BYTE,
  pad       :BYTE,
  segment   :BPTR,
  semaphore :SignalSemaphore

EDEF	ExecBase:PTR TO Library,DOSBase:PTR TO Library,IntuitionBase:PTR TO Library,GfxBase:PTR TO Library
