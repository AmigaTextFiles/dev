OPT NATIVE, PREPROCESS
MODULE 'target/exec/libraries', 'target/exec/types'
MODULE 'target/utility/tagitem'
{#include <libraries/id3tag.h>}
NATIVE {LIBRARIES_ID3TAG_H} CONST
  
NATIVE {ID3TAGNAME} CONST
->#define ID3TAGNAME id3tagname
STATIC id3tagname = 'id3tag.library'
NATIVE {ID3TAGVERSION}  CONST ID3TAGVERSION  = 5
NATIVE {ID3TAGREVISION} CONST ID3TAGREVISION = 6

												
  
/* structure for the language id's */ 
NATIVE {ID3Tag_Language} OBJECT id3tag_language
	{id}	id	:/*STRPTR*/ ARRAY OF CHAR /* 3 small letters */
	{fullname}	fullname	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT

 
/* This structure is read only */
NATIVE {ID3TagBase} OBJECT id3tagbase
	{base}	base	:lib
	{genre}	genre	:ARRAY OF /*STRPTR*/ ARRAY OF CHAR /* defined in id3tag v1 */
	/*
	Blues
	Classic Rock
	  ****
	Euro-House
	Dance Hall
	0
	*/
/* id3tag.library v2.4 */
	{buffer}	buffer	:ULONG /* id3tag_lib/buffer (default 128k) */
/* id3tag.library v4.0 */ 
	{genrecount}	genrecount	:VALUE /* count genre in ID3TagBase->genre */
	{revisionv2}	revisionv2	:UINT /* id3tag_lib/revisionv2 (default 3)*/	  
	{padding}	padding	:VALUE /* id3tag_lib/padding (default 128) */
/* id3tag .library v4.1 */	  
	{identificationlevel}	identificationlevel	:INT /* id3tag_lib/identificationlevel (default 2)*/									 
/* id3tag.library v4.2 */
	{language}	language	:PTR TO id3tag_language /* ISO/FDIS 639-2, TC 37 / SC 2  */
	/*
	{"aar","Afar"},
		****
	{"eng","English"}, default
		****
	{"zun","Zuni"},
	{0,0}
	*/
	{languagecount}	languagecount	:VALUE /* count language in ID3TagBase->language */
/* id3tag.library v5.2 */
	{maxpadding}	maxpadding	:VALUE /* id3tag_lib/maxpadding (default 0) */
ENDOBJECT


/* Type for ID3Tag_RemoveType() */
 
NATIVE {ID3Tag_Remove_T1} CONST ID3TAG_REMOVE_T1 = 0 /* agree with ID3Tag_Remove() */
NATIVE {ID3Tag_Remove_T2} CONST ID3TAG_REMOVE_T2 = 1 /* overwrite v1 with space, v2 with NULL */
/* id3tag.libbrary v3.0 */
NATIVE {ID3Tag_Remove_T3} CONST ID3TAG_REMOVE_T3 = 2 /* like ID3Tag_Remove_t1 + the byte to the first mp3frameheader */
NATIVE {ID3Tag_Remove_T4} CONST ID3TAG_REMOVE_T4 = 3 /* remove bytes of id3tag v1 */
NATIVE {ID3Tag_Remove_T5} CONST ID3TAG_REMOVE_T5 = 4 /* id3tag V1 overwrite with Space */
NATIVE {ID3Tag_Remove_T6} CONST ID3TAG_REMOVE_T6 = 5 /* remove bytes of id3tag v2 */
NATIVE {ID3Tag_Remove_T7} CONST ID3TAG_REMOVE_T7 = 6 /* id3tag v2 overwrite with NULL */
	

/* structure for the image */
NATIVE {ID3Tag_Image} OBJECT id3tag_image
	{description}	description	:/*STRPTR*/ ARRAY OF CHAR /* max 64 characters, can be NULL */
	{mime}	mime	:/*STRPTR*/ ARRAY OF CHAR
	/*
		'-->' data is a link to the file
		'image/jpeg' data is binary
		'image/png' data is binary
	*/
	{size}	size	:VALUE /* size of data >0 */
	{data}	data	:APTR /* pointer to the data (binary or URL) */
ENDOBJECT
 
/* tag values, used by ID3Tag_GetAttrs() and ID3Tag_SetAttrs() */
	
NATIVE {ID3Tag_Dummy} CONST ID3TAG_DUMMY = (TAG_USER)
  
NATIVE {ID3Tag_Title}    CONST ID3TAG_TITLE    = (ID3TAG_DUMMY+1) /* STRPTR */
NATIVE {ID3Tag_Artist}   CONST ID3TAG_ARTIST   = (ID3TAG_DUMMY+2) /* STRPTR */
NATIVE {ID3Tag_Album}    CONST ID3TAG_ALBUM    = (ID3TAG_DUMMY+3) /* STRPTR */
NATIVE {ID3Tag_Year}     CONST ID3TAG_YEAR     = (ID3TAG_DUMMY+4) /* STRPTR */
NATIVE {ID3Tag_Comment}  CONST ID3TAG_COMMENT  = (ID3TAG_DUMMY+5) /* STRPTR */
NATIVE {ID3Tag_Genre}    CONST ID3TAG_GENRE    = (ID3TAG_DUMMY+6) /* STRPTR */
NATIVE {ID3Tag_Track}    CONST ID3TAG_TRACK    = (ID3TAG_DUMMY+7) /* LONG */
NATIVE {ID3Tag_Comment2} CONST ID3TAG_COMMENT2 = (ID3TAG_DUMMY+8) /* STRPTR (multiline) */
NATIVE {ID3Tag_Track2}   CONST ID3TAG_TRACK2   = (ID3TAG_DUMMY+9) /* LONG */
/* id3tag.library v3.0 */
NATIVE {ID3Tag_TextWriter}              CONST ID3TAG_TEXTWRITER              = (ID3TAG_DUMMY+10) /* STRPTR */
NATIVE {ID3Tag_EncodedBy}               CONST ID3TAG_ENCODEDBY               = (ID3TAG_DUMMY+11) /* STRPTR */
NATIVE {ID3Tag_Publisher}               CONST ID3TAG_PUBLISHER               = (ID3TAG_DUMMY+12) /* STRPTR */
NATIVE {ID3Tag_OriginalYear}            CONST ID3TAG_ORIGINALYEAR            = (ID3TAG_DUMMY+13) /* STRPTR */
NATIVE {ID3Tag_OriginalArtist}          CONST ID3TAG_ORIGINALARTIST          = (ID3TAG_DUMMY+14) /* STRPTR */
NATIVE {ID3Tag_OriginalTextWriter}      CONST ID3TAG_ORIGINALTEXTWRITER      = (ID3TAG_DUMMY+15) /* STRPTR */
NATIVE {ID3Tag_OriginalAlbum}           CONST ID3TAG_ORIGINALALBUM           = (ID3TAG_DUMMY+16) /* STRPTR */
NATIVE {ID3Tag_OriginalFileName}        CONST ID3TAG_ORIGINALFILENAME        = (ID3TAG_DUMMY+17) /* STRPTR */
NATIVE {ID3Tag_URLArtist}               CONST ID3TAG_URLARTIST               = (ID3TAG_DUMMY+18) /* STRPTR */
NATIVE {ID3Tag_URLPublisher}            CONST ID3TAG_URLPUBLISHER            = (ID3TAG_DUMMY+19) /* STRPTR */
NATIVE {ID3Tag_URLAudiofile}            CONST ID3TAG_URLAUDIOFILE            = (ID3TAG_DUMMY+20) /* STRPTR */
NATIVE {ID3Tag_URLUser}                 CONST ID3TAG_URLUSER                 = (ID3TAG_DUMMY+21) /* STRPTR */
NATIVE {ID3Tag_URLUserDescription}      CONST ID3TAG_URLUSERDESCRIPTION      = (ID3TAG_DUMMY+22) /* STRPTR */
NATIVE {ID3Tag_Composer}                CONST ID3TAG_COMPOSER                = (ID3TAG_DUMMY+23) /* STRPTR */
NATIVE {ID3Tag_BPM}                     CONST ID3TAG_BPM                     = (ID3TAG_DUMMY+24) /* LONG */
NATIVE {ID3Tag_Copyright}               CONST ID3TAG_COPYRIGHT               = (ID3TAG_DUMMY+25) /* STRPTR */
NATIVE {ID3Tag_URLCopyright}            CONST ID3TAG_URLCOPYRIGHT            = (ID3TAG_DUMMY+26) /* STRPTR */
NATIVE {ID3Tag_Subtitle}                CONST ID3TAG_SUBTITLE                = (ID3TAG_DUMMY+27) /* STRPTR */
NATIVE {ID3Tag_Conductor}               CONST ID3TAG_CONDUCTOR               = (ID3TAG_DUMMY+28) /* STRPTR */
NATIVE {ID3Tag_ContentGroupDescription} CONST ID3TAG_CONTENTGROUPDESCRIPTION = (ID3TAG_DUMMY+29) /* STRPTR */
NATIVE {ID3Tag_Accompaniment}           CONST ID3TAG_ACCOMPANIMENT           = (ID3TAG_DUMMY+30) /* STRPTR */
/* id3tag.library v4.1 */
NATIVE {ID3Tag_LyricsText}              CONST ID3TAG_LYRICSTEXT              = (ID3TAG_DUMMY+31) /* STRPTR (multiline) */
NATIVE {ID3Tag_LyricsDescriptor}        CONST ID3TAG_LYRICSDESCRIPTOR        = (ID3TAG_DUMMY+32) /* STRPTR */
/* id3tag.library v4.2 */
NATIVE {ID3Tag_LyricsLanguage}          CONST ID3TAG_LYRICSLANGUAGE          = (ID3TAG_DUMMY+33) /* STRPTR (language id) */
NATIVE {ID3Tag_CommentLanguage}         CONST ID3TAG_COMMENTLANGUAGE         = (ID3TAG_DUMMY+34) /* STRPTR (language id) */
/* id3tag.library v5.0 */
NATIVE {ID3Tag_ImageOther}             CONST ID3TAG_IMAGEOTHER             = (ID3TAG_DUMMY+35) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageCoverFront}        CONST ID3TAG_IMAGECOVERFRONT        = (ID3TAG_DUMMY+36) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageCoverBack}         CONST ID3TAG_IMAGECOVERBACK         = (ID3TAG_DUMMY+37) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageLeaflet}	        CONST ID3TAG_IMAGELEAFLET	        = (ID3TAG_DUMMY+38) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageMedia}             CONST ID3TAG_IMAGEMEDIA             = (ID3TAG_DUMMY+39) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageLeadArtist}        CONST ID3TAG_IMAGELEADARTIST        = (ID3TAG_DUMMY+40) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageArtist}            CONST ID3TAG_IMAGEARTIST            = (ID3TAG_DUMMY+41) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageConductor}         CONST ID3TAG_IMAGECONDUCTOR         = (ID3TAG_DUMMY+42) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageBand}		        CONST ID3TAG_IMAGEBAND		        = (ID3TAG_DUMMY+43) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageComposer}          CONST ID3TAG_IMAGECOMPOSER          = (ID3TAG_DUMMY+44) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageTextWriter}        CONST ID3TAG_IMAGETEXTWRITER        = (ID3TAG_DUMMY+45) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageRecordingLoaction} CONST ID3TAG_IMAGERECORDINGLOACTION = (ID3TAG_DUMMY+46) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageDuringRecording}   CONST ID3TAG_IMAGEDURINGRECORDING   = (ID3TAG_DUMMY+47) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageDuringPerformance} CONST ID3TAG_IMAGEDURINGPERFORMANCE = (ID3TAG_DUMMY+48) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageMovie}             CONST ID3TAG_IMAGEMOVIE             = (ID3TAG_DUMMY+49) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageIllustration}      CONST ID3TAG_IMAGEILLUSTRATION      = (ID3TAG_DUMMY+50) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImageLogo}              CONST ID3TAG_IMAGELOGO              = (ID3TAG_DUMMY+51) /* pointer to ID3Tag_Image or NULL */
NATIVE {ID3Tag_ImagePublisher}         CONST ID3TAG_IMAGEPUBLISHER         = (ID3TAG_DUMMY+52) /* pointer to ID3Tag_Image or NULL */

  
/* This structure is read only */ 
NATIVE {ID3Tag} OBJECT id3tag
/* ID3Tag */
	{version}	version	:UINT
	{revision}	revision	:UINT
	{revision2}	revision2	:UINT
	
   {tagdata}	tagdata	:PTR

/* Mpeg Audio Info */
	{norm}	norm	:INT         /* ID3TagMPEGA_VERSION_xxx */
	{layer}	layer	:INT        /* 1..3 */
	{mode}	mode	:INT         /* ID3TagMPEGA_MODE_xxx */
	{bitrate}	bitrate	:VALUE      /* in bps */
	{vbr}	vbr	:INT          /* 0 or 1 */
	{frequency}	frequency	:VALUE    /* in Hz */
	{ms_duration}	ms_duration	:ULONG /* stream duration in second */
	{crc}	crc	:INT          /* 0 or 1 */
	{copyright}	copyright	:INT    /* 0 or 1 */
	{original}	original	:INT     /* 0 or 1 */
	{private_bit}	private_bit	:INT  /* 0 or 1 */
	{emphasis}	emphasis	:INT     /* ID3TagMPEGA_EMPHASIS_xxx */
	{filesize}	filesize	:VALUE     /* in Byte */
								
/* id3tag.library v2.1 */
  
	{id3tagv2size}	id3tagv2size	:VALUE  /* Size of ID3Tag Version 2 */
	{header}	header	:VALUE    /* >= id3tagv2size first MPEGAFrame found*/
/* id3tag.library v5.2 */
 
	{padding}	padding	:VALUE /* use padding size */
ENDOBJECT


NATIVE {ID3TagMPEGA_VERSION_1} CONST ID3TAGMPEGA_VERSION_1 = 1
NATIVE {ID3TagMPEGA_VERSION_1_STR} CONST ; STATIC id3tagmpega_version_1_str = '1.0'
NATIVE {ID3TagMPEGA_VERSION_2} CONST ID3TAGMPEGA_VERSION_2 = 2
NATIVE {ID3TagMPEGA_VERSION_2_STR} CONST ; STATIC id3tagmpega_version_2_str = '2.0'
NATIVE {ID3TagMPEGA_VERSION_2_5} CONST ID3TAGMPEGA_VERSION_2_5 = 4
NATIVE {ID3TagMPEGA_VERSION_2_5_STR} CONST ; STATIC id3tagmpega_version_2_5_str = '2.5'

NATIVE {ID3TagMPEGA_MODE_STEREO} CONST ID3TAGMPEGA_MODE_STEREO = 0
NATIVE {ID3TagMPEGA_MODE_STEREO_STR} CONST ; STATIC id3tagmpega_mode_stereo_str = 'Stereo'
NATIVE {ID3TagMPEGA_MODE_JOINSTEREO} CONST ID3TAGMPEGA_MODE_JOINSTEREO = 1
NATIVE {ID3TagMPEGA_MODE_JOINSTEREO_STR} CONST ; STATIC id3tagmpega_mode_joinstereo_str = 'Joint stereo'
NATIVE {ID3TagMPEGA_MODE_DUALCHANNEL} CONST ID3TAGMPEGA_MODE_DUALCHANNEL = 2
NATIVE {ID3TagMPEGA_MODE_DUALCHANNEL_STR} CONST ; STATIC id3tagmpega_mode_dualchannel_str = 'Dual channel'
NATIVE {ID3TagMPEGA_MODE_SINGLECHANNEL} CONST ID3TAGMPEGA_MODE_SINGLECHANNEL = 3
NATIVE {ID3TagMPEGA_MODE_SINGLECHANNEL_STR} CONST ; STATIC id3tagmpega_mode_singlechannel_str = 'Mono'

NATIVE {ID3TagMPEGA_EMPHASIS_NONE} CONST ID3TAGMPEGA_EMPHASIS_NONE = 0
NATIVE {ID3TagMPEGA_EMPHASIS_NONE_STR} CONST ; STATIC id3tagmpega_emphasis_none_str = 'None'
NATIVE {ID3TagMPEGA_EMPHASIS_50_15ms} CONST ID3TAGMPEGA_EMPHASIS_50_15MS = 1
NATIVE {ID3TagMPEGA_EMPHASIS_50_15ms_STR} CONST ; STATIC id3tagmpega_emphasis_50_15ms_str = '50/15ms'
NATIVE {ID3TagMPEGA_EMPHASIS_CITTJ_17} CONST ID3TAGMPEGA_EMPHASIS_CITTJ_17 = 3
NATIVE {ID3TagMPEGA_EMPHASIS_CITTJ_17_STR} CONST ; STATIC id3tagmpega_emphasis_cittj_17_str = 'CITTj.17'




/*
	ErrorID's
*/

 
NATIVE {ID3TagErr_NoMpegaFile}    CONST ID3TAGERR_NOMPEGAFILE    = 1
NATIVE {ID3TagErr_NoMemory}       CONST ID3TAGERR_NOMEMORY       = 2
NATIVE {ID3TagErr_ObjectNotFound} CONST ID3TAGERR_OBJECTNOTFOUND = 3
NATIVE {ID3TagErr_ObjectInUse}    CONST ID3TAGERR_OBJECTINUSE    = 4
NATIVE {ID3TagErr_ReadWrite}      CONST ID3TAGERR_READWRITE      = 5
NATIVE {ID3TagErr_WriteProtected} CONST ID3TAGERR_WRITEPROTECTED = 6
NATIVE {ID3TagErr_ReadProtected}  CONST ID3TAGERR_READPROTECTED  = 7
NATIVE {ID3TagErr_UnknownTagArg}  CONST ID3TAGERR_UNKNOWNTAGARG  = 8
NATIVE {ID3TagErr_UnknownRemType} CONST ID3TAGERR_UNKNOWNREMTYPE = 9
NATIVE {ID3TagErr_DiskFull}           CONST ID3TAGERR_DISKFULL           = 10
NATIVE {ID3TagErr_DiskNotValidated}   CONST ID3TAGERR_DISKNOTVALIDATED   = 11
NATIVE {ID3TagErr_DiskWriteProtected} CONST ID3TAGERR_DISKWRITEPROTECTED = 12
NATIVE {ID3TagErr_DeleteProtected}    CONST ID3TAGERR_DELETEPROTECTED    = 13
/* id3tag.library v3.0 */
NATIVE {ID3TagErr_UnknownVersion} CONST ID3TAGERR_UNKNOWNVERSION = 14
/* id3tag.library v4.0 */
NATIVE {ID3TagErr_BufferToSmall}  CONST ID3TAGERR_BUFFERTOSMALL  = 15
NATIVE {ID3TagErr_InvalidHeader}  CONST ID3TAGERR_INVALIDHEADER  = 16

			
/*
	tags for ID3Tag_LaunchPrefs()
*/

NATIVE {ID3TagPrefs_Dummy} CONST ID3TAGPREFS_DUMMY = (TAG_USER)
 
NATIVE {ID3TagPrefs_PubScreen} CONST ID3TAGPREFS_PUBSCREEN = (ID3TAGPREFS_DUMMY+1) /* STRPTR */
/* id3tag.library v5.6 */
NATIVE {ID3TagPrefs_Synch} CONST ID3TAGPREFS_SYNCH = (ID3TAGPREFS_DUMMY+2) /* BOOL ( default: FALSE )*/
