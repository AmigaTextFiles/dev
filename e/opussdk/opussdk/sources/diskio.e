/*****************************************************************************

 Disk I/O

 *****************************************************************************/

OPT MODULE
OPT EXPORT

MODULE 'exec/ports', 'devices/trackdisk', 'dos/filehandler', 'dos/dos'

OBJECT diskHandle
    port:PTR TO mp                       -> Message port
    io:PTR TO ioexttd                    -> IO request
    startup:PTR TO filesysstartupmsg     -> Startup message
    geo:PTR TO dosenvec                  -> Disk geometry
    name[32]:ARRAY OF CHAR               -> Disk name
    device[32]:ARRAY OF CHAR             -> Device name
    info:infodata                        -> Disk information
    result:LONG                          -> dh_Info is valid
    root:LONG                            -> Root block
    blockSize:LONG                       -> Block size
    stamp:datestamp                      -> not used
ENDOBJECT

-> Some third-party DOS types
CONST ID_AFS_PRO      = $41465301
CONST ID_AFS_USER     = $41465302
CONST ID_AFS_MULTI    = $6D754146
CONST ID_PFS_FLOPPY   = $50465300
CONST ID_PFS_HARD     = $50465301
