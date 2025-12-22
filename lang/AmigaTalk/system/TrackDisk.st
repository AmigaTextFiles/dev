" -------------------------------------------------------------------- "
" TrackDisk Class allows the user low-level (device) access to any     "
" floppy drives attached to their system (DF0: through DF3:).          "
""
"  WARNING:  You should know what you're doing to the Amiga OS before  "
"            messing with this Class, or any other System Class!       "
" ---------------------------------------------------------------------"
" The following methods are commented out, because turnMotorOff 
  hangs up my system (JTS).
|
  turnMotorOn 
    ^ <primitive 229 17 private>     
|
  turnMotorOff 
    ^ <primitive 229 18 private>   
"
" ---------------------------------------------------------------------"

Class TrackDisk :Device ! private diskName trkNumber !
[
  ejectDisk      "Won't do anything for most Amigas!"

    ^ <primitive 229 16 private>
|
  formatTrack: trackNumber data: theDataBytes

    "DANGER! DANGER, Will Robinson!"

    trkNumber <- trackNumber.

    ^ <primitive 229 19 theDataBytes trackNumber private>
|
  readRawData: trackNumber

    trkNumber <- trackNumber.

    ^ <primitive 229 20 trackNumber private>
|
  writeRawData: rawDataBytes track: trackNumber

    trkNumber <- trackNumber.

    ^ <primitive 229 21 rawDataBytes trackNumber private>.
|
  clearReadBuffer

    <primitive 229 4 private>      
|
  setSyncType: newSyncType

    <primitive 229 5 newSyncType private>
|
  getErrorString

    ^ <primitive 229 8 private> 
|
  getSectorSize

    ^ <primitive 229 12 private>
|
  getTrackSize

    ^ <primitive 229 10 private>
|
  getDeviceType

    ^ <primitive 229 9 private>
|
  getDriveType

    "1 = 3.5in, 2 = 5.25in, 3 = 3.5in spinning at 150 RPM."
    ^ <primitive 229 11 private>
|
  displayDriveType ! type !

    type <- self getDriveType.

    (type == 1)
       ifTrue:  ['3-1/2" Floppy Disk.' print]
       ifFalse: [(type == 2)
                    ifTrue:  ['5-1/4" Floppy Disk.' print]
                    ifFalse: ['3-1/2" Floppy spinning at 150 RPM' print]
                ]
|
  getNumberOfTracks 

    ^ <primitive 229 13 private>
|
  getTotalSectors 

    ^ <primitive 229 14 private>
|
  getTotalSize ! secsize numsecs !

    numsecs <- self getTotalSectors.

    secsize <- self getSectorSize.

    ^ numsecs * secsize
|
  seekTrack: trackNumber 

    trkNumber <- trackNumber.

    ^ <primitive 229 15 trackNumber private>
|
  isDiskPresent 

    ^ <primitive 229 6 private>
|
  isWriteProtected 

    ^ <primitive 229 7 private>
|
  readTrack: trackNumber

    trkNumber <- trackNumber.

    ^ <primitive 229 2 trackNumber private>
    
|
  writeTrack: dataBytesOut track: trackNumber

    trkNumber <- trackNumber.

    ^ <primitive 229 3 dataBytesOut trackNumber private>
|
  displayBytes: byteArray ! size wTitle !

    size   <- self getTrackSize.

    wTitle <- String new.

    wTitle <- 'displayBytes - size = ',(size asString),' Track #: ', (trkNumber asString).

    <primitive 229 22 byteArray wTitle>
|
  new: newDiskName

    private  <- <primitive 229 23 newDiskName>.

    diskName <- newDiskName.

    ^ self
|
  open: newUnitNumber

    <primitive 229 1 newUnitNumber private>
|     
  close

    <primitive 229 0 private>.
    
    <primitive 250 5 0 private>. "NO TURNING BACK FROM HERE!"
    
    ^ nil
]
