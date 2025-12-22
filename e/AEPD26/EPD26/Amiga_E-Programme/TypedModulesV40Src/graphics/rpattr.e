OPT MODULE
OPT EXPORT

CONST ID_SOND=$534F4E44

OBJECT soundprefs
  reserved[4]:ARRAY OF LONG
  displayqueue:INT
  audioqueue:INT
  audiotype:INT  -> This is unsigned
  audiovolume:INT  -> This is unsigned
  audioperiod:INT  -> This is unsigned
  audioduration:INT  