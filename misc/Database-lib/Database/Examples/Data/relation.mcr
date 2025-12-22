open MediaDB ram:Media.dbf
use MediaDB
openindex ram:Media.idx
open AlbumDB ram:album.dbf
use AlbumDB
openindex ram:Id.idx
openindex ram:Medium.idx
openindex ram:Album.idx
setrelation MediaDB Media Medium
use MusicDB
setrelation AlbumDB Id AlbumId
stop
