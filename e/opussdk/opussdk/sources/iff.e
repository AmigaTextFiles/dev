/*****************************************************************************

 IFF routines

 *****************************************************************************/

OPT MODULE
OPT EXPORT

MODULE 'dos/dos'

-> File modes
CONST IFF_READ       = MODE_OLDFILE             -> Reading
CONST IFF_WRITE      = MODE_NEWFILE             -> Writing
CONST IFF_CLIP       = $8000                    -> Clipboard flag
CONST IFF_CLIP_READ  = $83ED                    -> Read clipboard
CONST IFF_CLIP_WRITE = $83EE                    -> Write clipboard
CONST IFF_SAFE       = $4000                    -> Safe write
