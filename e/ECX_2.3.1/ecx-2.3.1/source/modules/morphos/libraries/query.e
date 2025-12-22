-> NOREV
OPT MODULE
OPT EXPORT

-> Converted to E by Mattias Böcker 2007

MODULE 'exec/devices'
MODULE 'utility/tagitem'


OBJECT querypathentry
  path:PTR TO CHAR
  pattern:PTR TO CHAR
  flags:LONG
ENDOBJECT

CONST QUERYPATHFLAGF_ALL                     = $1
CONST QUERYPATHFLAGF_DONTFOLLOWSOFTLINKS     = $2

OBJECT querypcimatch
  vendor:LONG
  vendormask:LONG
  device:LONG
  devicemask:LONG
  class:LONG
  classmask:LONG
  subclass:LONG
  subclassmask:LONG
  proginfo:LONG
  proginfomask:LONG
ENDOBJECT

OBJECT querydostypematch
  dostype:LONG
  mask:LONG
ENDOBJECT


OBJECT queryunitid
  unit:PTR TO unit
  id:LONG
ENDOBJECT

/*
 * QueryGetAttr(struct QueryInfo*,ULONG Attr);
 */

CONST QUERYINFOATTR_Dummy = TAG_USER + $01001000

/*
 * return the name from the object which is needed to reference it
 * Data: (char *)
 */
CONST QUERYINFOATTR_NAME              = QUERYINFOATTR_Dummy+0
/*
 * return the id string from the object, including "$VER: "
 * Data: (char *)
 */
CONST QUERYINFOATTR_IDSTRING          = QUERYINFOATTR_Dummy+1
/*
 * return a description string about the object usage
 * Data: (char *)
 */
CONST QUERYINFOATTR_DESCRIPTION       = QUERYINFOATTR_Dummy+2
/*
 * return a copyright string from the object
 * Data: (char *)
 */
CONST QUERYINFOATTR_COPYRIGHT         = QUERYINFOATTR_Dummy+3
/*
 * return an author string from the object
 * Data: (char *)
 */
CONST QUERYINFOATTR_AUTHOR            = QUERYINFOATTR_Dummy+4
/*
 * return a date string from the object
 * Data: (char *)
 */
CONST QUERYINFOATTR_DATE              = QUERYINFOATTR_Dummy+5
/*
 * obsolete, don't reuse
 * Data: -
 */
CONST QUERYINFOATTR_OBSOLETE1         = QUERYINFOATTR_Dummy+6
/*
 * return the version from the object
 * Data: (ULONG)
 */
CONST QUERYINFOATTR_VERSION           = QUERYINFOATTR_Dummy+7
/*
 * return the revision from the object
 * Data: (ULONG)
 */
CONST QUERYINFOATTR_REVISION          = QUERYINFOATTR_Dummy+8
/*
 * return the release tag string from the object
 * Something like "release","alpha","beta" and so on
 * Data: (char *)
 */
CONST QUERYINFOATTR_RELEASETAG        = QUERYINFOATTR_Dummy+9

CONST QUERYINFOATTR_CODETYPE          = QUERYINFOATTR_Dummy+10
/*
 * give me a filename if it's an external object
 */
CONST QUERYINFOATTR_FILENAME          = QUERYINFOATTR_Dummy+11
/*
 * SegList, usually only valid during the lifetime of the QueryInfo (V51)
 * Only exception would be internal filesystems
 * Data: BPTR
 */
CONST QUERYINFOATTR_SEGLIST           = QUERYINFOATTR_Dummy+12

/*
 * QUERYTYPE_#?
 * This type defines where the object was found.
 * It makes no sense to return this type in a QueryTagList or
 * through GetQueryAttr(), as it's the internal type of an
 * object.
 */
CONST QUERYINFOATTR_TYPE              = QUERYINFOATTR_Dummy+13
/*
 * QUERYSUBTYPE_#?
 * This type defines the real object type
 */
CONST QUERYINFOATTR_SUBTYPE           = QUERYINFOATTR_Dummy+14
/*
 * QUERYCLASS_#?
 */
CONST QUERYINFOATTR_CLASS             = QUERYINFOATTR_Dummy+15
/*
 * QUERYSUBCLASS_#?
 */
CONST QUERYINFOATTR_SUBCLASS          = QUERYINFOATTR_Dummy+16
/*
 * Priority
 * Data: LONG
 */
CONST QUERYINFOATTR_PRI               = QUERYINFOATTR_Dummy+17

/*
 * Ptr to
 * ULONG VENDORID, VENDORIDMASK,
 * ULONG DEVICEID, DEVICEIDMASK,
 * ULONG    CLASS, CLASSMASK,
 * ULONG SUBCLASS, SUBCLASSMASK,
 * ULONG PROGINFO, PROGINFOMASK
 * ends with all entries as 0, so you can specify several entries
 */
CONST QUERYINFOATTR_PCIMATCH          = QUERYINFOATTR_Dummy+20
/*
 * Array with DosTypes+Mask the filesystems supports
 * Data = struct QueryDosTypeMatch*
 * must end with a 0
 */
CONST QUERYINFOATTR_FS_DOSTYPEMATCH   = QUERYINFOATTR_Dummy+30
/*
 * Filesystem supports a Startup Argument String(ReadArgs pattern)
 * Data: char *RDArgs Pattern
 */
CONST QUERYINFOATTR_FS_STARTUP        = QUERYINFOATTR_Dummy+31
/*
 * Filesystem supports a Control Argument String(ReadArgs pattern)
 * Data: char *RDArgs Pattern
 */
CONST QUERYINFOATTR_FS_CONTROL        = QUERYINFOATTR_Dummy+32
/*
 * Filesystem supports FSContext
 * Data: Boolean
 */
CONST QUERYINFOATTR_FS_FSCONTEXT      = QUERYINFOATTR_Dummy+33
/*
 * Filesystem's StackSize
 * Data: ULONG
 */
CONST QUERYINFOATTR_FS_STACKSIZE      = QUERYINFOATTR_Dummy+34
/*
 * Filesystem's Globalvec, only valid for an internal filesysentry
 * Data: ULONG
 */
CONST QUERYINFOATTR_FS_GLOBALVEC      = QUERYINFOATTR_Dummy+35
/*
 * Filesystem's SegList
 * Data: void *
 */
CONST QUERYINFOATTR_FS_SEGLIST        = QUERYINFOATTR_Dummy+36


/*
 * Device max allowed Units
 * Data: ULONG
 */
CONST QUERYINFOATTR_DEVICE_UNITS      = QUERYINFOATTR_Dummy+40
/*
 * Device max allowed Luns
 * Data: ULONG
 */
CONST QUERYINFOATTR_DEVICE_LUNS       = QUERYINFOATTR_Dummy+41
/*
 * Device supports New Format UnitIDs(only needed for scsi devices which support wide)
 * Data: ULONG
 */
CONST QUERYINFOATTR_DEVICE_NEWFORMAT  = QUERYINFOATTR_Dummy+42
/*
 * Device supports a RdArgs String through the flags parameter
 * Data: (char*) ReadArgs mask
 */
CONST QUERYINFOATTR_DEVICE_FLAGS_TEMPLATE     = QUERYINFOATTR_Dummy+43
/*
 * Device's Mask parameter
 * Data: ULONG
 */
CONST QUERYINFOATTR_DEVICE_MASK     = QUERYINFOATTR_Dummy+44
/*
 * Device's MaxTransfer parameter
 * Data: ULONG
 */
CONST QUERYINFOATTR_DEVICE_MAXTRANSFER   = QUERYINFOATTR_Dummy+45
/*
 * Device's Unit's OpenDevice ID in appropriate format
 * Data: struct QueryUnitID*
 */
CONST QUERYINFOATTR_DEVICE_UNIT_ID     = QUERYINFOATTR_Dummy+46
/*
 * Device's Unit's UnitID
 * Data: struct QueryUnitID*
 */
CONST QUERYINFOATTR_DEVICE_UNIT_UNIT   = QUERYINFOATTR_Dummy+47
/*
 * Device's Unit's LunID
 * Data: struct QueryUnitID*
 */
CONST QUERYINFOATTR_DEVICE_UNIT_LUN    = QUERYINFOATTR_Dummy+48
/*
 * Device supports a config file with RdArgs format
 * Data: (char*) ReadArgs string
 */
CONST QUERYINFOATTR_DEVICE_CONFIG_TEMPLATE     = QUERYINFOATTR_Dummy+49


/*
 * Net tags
 */
CONST QUERYINFOATTR_NET_LINK          = QUERYINFOATTR_Dummy+100
/*
 * Default IP Frame Type
 */
CONST QUERYINFOATTR_NET_IPTYPE        = QUERYINFOATTR_Dummy+102
/*
 * Default ARP Frame Type
 */
CONST QUERYINFOATTR_NET_ARPTYPE       = QUERYINFOATTR_Dummy+103

/*
 * Language tags
 */

/*
 * Language associated with the object
 * Data: (char*)
 */
CONST QUERYINFOATTR_LANG_LANGUAGE     = QUERYINFOATTR_Dummy+150
/*
 * Language name in english
 * Data: (char*)
 */
CONST QUERYINFOATTR_LANG_LANGUAGE_INT = QUERYINFOATTR_Dummy+151
/*
 * Codepage associated with the object/language (refer to iconv
 * docs for the list of codepages)
 * Data: (char*)
 */
CONST QUERYINFOATTR_LANG_CODEPAGE     = QUERYINFOATTR_Dummy+152

/*
 * Below..all custom attrs start
 */
CONST QUERYINFOATTR_CUSTOM            = QUERYINFOATTR_Dummy+$1000

/*
 * Custom tags used by the keymaps
 */
CONST QUERYINFOATTR_CUSTOM_KEYMAP_UNICODECONVTABLE = QUERYINFOATTR_CUSTOM + 1
CONST QUERYINFOATTR_CUSTOM_KEYMAP_CHARSETCONVTABLE = QUERYINFOATTR_CUSTOM + 2


/***********************************************************************************
 *
 * Obtain Tags
 *
 */

CONST QUERYFINDATTR_Dummy                     = TAG_USER +$01001200

/*
 * search for an object with this name
 */
CONST QUERYFINDATTR_NAME                      = QUERYFINDATTR_Dummy+0

/*
 * search for an object with this type
 */
CONST QUERYFINDATTR_TYPE                      = QUERYFINDATTR_Dummy+1

/*
 * search for an object with this subtype
 */
CONST QUERYFINDATTR_SUBTYPE                   = QUERYFINDATTR_Dummy+2

/*
 * search for an object with this class
 */
CONST QUERYFINDATTR_CLASS                     = QUERYFINDATTR_Dummy+3

/*
 * search for an object with this subclass
 */
CONST QUERYFINDATTR_SUBCLASS                  = QUERYFINDATTR_Dummy+4

/*
 * define if the search should happen externally(using DOS paths)
 */
CONST QUERYFINDATTR_EXTERNAL                  = QUERYFINDATTR_Dummy+10

/*
 * define a dos path search table
 */
CONST QUERYFINDATTR_PATHTABLE                 = QUERYFINDATTR_Dummy+11

/*
 * define if the global search table should be used
 */
CONST QUERYFINDATTR_NOGLOBALPATHTABLE         = QUERYFINDATTR_Dummy+12

/*
 * define a custom filter hook
 */
CONST QUERYFINDATTR_FILTERHOOK                = QUERYFINDATTR_Dummy+13

/*
 * define a custom filter pattern
 */
CONST QUERYFINDATTR_FILTERPATTERN             = QUERYFINDATTR_Dummy+14


/*
 * Ptr to
 * ULONG VENDORID, VENDORIDMASK,
 * ULONG DEVICEID, DEVICEIDMASK,
 * ULONG    CLASS, CLASSMASK,
 * ULONG SUBCLASS, SUBCLASSMASK,
 * ULONG PROGINFO, PROGINFOMASK
 * ends with all entries as 0, so you can specify several entries
 */
CONST QUERYFINDATTR_PCIMATCH                  = QUERYFINDATTR_Dummy+20
/*
 * define a dostype for what it should search
 */
CONST QUERYFINDATTR_FS_DOSTYPE                = QUERYFINDATTR_Dummy+21



/*********************************************************************************/

/*
 * Type of a query object
 */

/*
 * No legal type, QueryInfo with such type is equal to nil
 */
CONST QUERYTYPE_NONE         = 0
/*
 * a resident list query element
 */
CONST QUERYTYPE_RESIDENT     = 1
/*
 * a library list query element
 */
CONST QUERYTYPE_LIBRARY      = 2
/*
 * a device query element
 */
CONST QUERYTYPE_DEVICE       = 3
/*
 * a filesystem query element
 */
CONST QUERYTYPE_FILESYSTEM   = 4
/*
 * an external load query element
 */
CONST QUERYTYPE_DOS          = 5

/*
 * SubType of a query object
 * This is the real type of the queryinfo object to
 * define how to open it.
 */
CONST QUERYSUBTYPE_NONE              = 0
CONST QUERYSUBTYPE_LIBRARY           = 1
CONST QUERYSUBTYPE_DEVICE            = 2
CONST QUERYSUBTYPE_HANDLER           = 3
CONST QUERYSUBTYPE_MUICLASS          = 4
CONST QUERYSUBTYPE_KEYMAP            = 5

/*
 * Class of a query object
 */
CONST QUERYCLASS_NONE        = 0
CONST QUERYCLASS_HANDLER     = 1
CONST QUERYCLASS_FILESYSTEM  = 2

CONST QUERYCLASS_DATATYPE    = 10

CONST QUERYCLASS_GRAPHICS    = 20

CONST QUERYCLASS_STORAGE     = 30

CONST QUERYCLASS_NET         = 40

CONST QUERYCLASS_USB         = 50   /* USB Hardware Devices */
CONST QUERYCLASS_USBCLASS    = 51   /* USB Stack Classes */

CONST QUERYCLASS_FIREWIRE    = 60

CONST QUERYCLASS_OBJDATA     = 70

CONST QUERYCLASS_PARALLEL    = 80

CONST QUERYCLASS_SERIAL      = 90

CONST QUERYCLASS_MUI         = 100

CONST QUERYCLASS_MULTIMEDIA  = 130

CONST QUERYCLASS_INTUITION   = 160
CONST QUERYCLASS_INTUITION_SCREENBAR= 161

CONST QUERYCLASS_PRINTER     = 190
CONST QUERYCLASS_PREFSCLASS  = 220
/*
 * SubClass of a query object
 */

CONST QUERYSUBCLASS_NONE             = 0

CONST QUERYSUBCLASS_STORAGE_SCSI     = 30
CONST QUERYSUBCLASS_STORAGE_IDE      = 31
CONST QUERYSUBCLASS_STORAGE_USB      = 32
CONST QUERYSUBCLASS_STORAGE_FIREWIRE = 33
CONST QUERYSUBCLASS_STORAGE_DVDRW    = 34      /* meta device */

CONST QUERYSUBCLASS_NET_ETHERNET     = 40
CONST QUERYSUBCLASS_NET_PPP          = 41
CONST QUERYSUBCLASS_NET_PPTP         = 42

CONST QUERYSUBCLASS_USB_UHCI         = 90
CONST QUERYSUBCLASS_USB_OHCI         = 91
CONST QUERYSUBCLASS_USB_EHCI         = 92

CONST QUERYSUBCLASS_OBJDATA_ELF      = 100
CONST QUERYSUBCLASS_OBJDATA_HUNK     = 101
CONST QUERYSUBCLASS_OBJDATA_COFF     = 102

CONST QUERYSUBCLASS_SERIAL_RS232     = 200
CONST QUERYSUBCLASS_SERIAL_MODEM     = 201
CONST QUERYSUBCLASS_SERIAL_IRDA      = 202
CONST QUERYSUBCLASS_SERIAL_USB       = 203
CONST QUERYSUBCLASS_SERIAL_BLUETOOTH = 204

CONST QUERYSUBCLASS_HANDLER_CON      = 1000

CONST QUERYSUBCLASS_FILESYSTEM_CD    = 2000
CONST QUERYSUBCLASS_FILESYSTEM_MASSSTORAGE= 2001

CONST QUERYSUBCLASS_MULTIMEDIA_ENCODER= 3000
CONST QUERYSUBCLASS_MULTIMEDIA_DECODER= 3001
CONST QUERYSUBCLASS_MULTIMEDIA_STREAM = 3002
CONST QUERYSUBCLASS_MULTIMEDIA_OUTPUT = 3003
CONST QUERYSUBCLASS_MULTIMEDIA_DEMUXER= 3004
CONST QUERYSUBCLASS_MULTIMEDIA_MUXER  = 3005
CONST QUERYSUBCLASS_MULTIMEDIA_BASIC  = 3006
CONST QUERYSUBCLASS_MULTIMEDIA_FILTER = 3007

CONST QUERYSUBCLASS_INTUITION_BLANKERAPI= 4000

CONST QUERYSUBCLASS_USBCLASS_KEYBOARD   = 10000
CONST QUERYSUBCLASS_USBCLASS_MOUSE      = 10001
CONST QUERYSUBCLASS_USBCLASS_HID        = 10002
CONST QUERYSUBCLASS_USBCLASS_HUB        = 10003
CONST QUERYSUBCLASS_USBCLASS_PRINTER    = 10004
CONST QUERYSUBCLASS_USBCLASS_SERIAL     = 10005
CONST QUERYSUBCLASS_USBCLASS_STORAGE    = 10006
CONST QUERYSUBCLASS_USBCLASS_BLUETOOTH  = 10007
CONST QUERYSUBCLASS_USBCLASS_MIDI       = 10008
CONST QUERYSUBCLASS_USBCLASS_MODEM      = 10009 /* isn't this the same as SERIAL? */
CONST QUERYSUBCLASS_USBCLASS_ETHERNET   = 10010
CONST QUERYSUBCLASS_USBCLASS_WLAN       = 10011

CONST QUERYSUBCLASS_PREFSCLASS_SYSTEM   = 20000
CONST QUERYSUBCLASS_PREFSCLASS_INPUT    = 20001
CONST QUERYSUBCLASS_PREFSCLASS_UI       = 20002
CONST QUERYSUBCLASS_PREFSCLASS_AUDIO    = 20003
CONST QUERYSUBCLASS_PREFSCLASS_NETWORK  = 20004
CONST QUERYSUBCLASS_PREFSCLASS_DEVICES  = 20005
CONST QUERYSUBCLASS_PREFSCLASS_FS       = 20006
CONST QUERYSUBCLASS_PREFSCLASS_INTERNET = 20007

/*
 * Net Link Types used by tunnel devices
 * like PPP
 */

CONST QUERYNETLINK_SANA2     = 0
CONST QUERYNETLINK_SERIAL    = 1
