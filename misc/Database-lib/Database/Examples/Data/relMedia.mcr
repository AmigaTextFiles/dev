open MediaDB ram:media.dbf
use MediaDB
openindex Media ram:Media.idx
open AlbumDB ram:album.dbf
use AlbumDB
openindex Id ram:Id.idx
setrelation MediaDB Media Medium
use MusicDB
setrelation AlbumDB Id AlbumId
stop
