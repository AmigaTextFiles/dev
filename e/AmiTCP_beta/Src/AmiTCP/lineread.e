OPT MODULE
OPT EXPORT

CONST RL_BUFSIZE=1024

OBJECT rl_private
  startp
  bufpointer
  howlong
  buffersize
  line_completed
  selected
  saved:CHAR                -> Needs fiddling to fix alignment and size
  buffer[RL_BUFSIZE]:ARRAY  -> "fiddle lineread.m rl_private buffer 1"
ENDOBJECT                   -> "fiddle lineread.m rl_private fiddle=-1"

ENUM RL_LFNOTREQ, RL_LFREQLF, RL_LFREQNUL

OBJECT lineread
  line:PTR TO CHAR
  lftype
  fd
  private:rl_private        -> No fiddling needed since size will be right
ENDOBJECT
