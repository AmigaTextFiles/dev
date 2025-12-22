#ifndef ___libsap151___
#define ___libsap151___

#define LIBSAP_INFO "SAP Library ver.1.51 by Adam Bienias"
#define LIBSAP_PORT_INFO "Linux port ver.1.51.1 by Michal Kunikowski"

#define SILENCE_WORD 0x8001

#ifdef __cplusplus
extern "C" {
#endif

#ifdef _MSC_EXTENSIONS
#pragma pack(push)
#pragma pack(1)
#endif

typedef struct {
	int	numOfSongs;
	int	defSong; // zero based index (0....numOfSongs-1)
	char	*commentBuffer;
	int	isStereo;
} sapMUSICstrc;

#ifdef _MSC_EXTENSIONS
#pragma pack(pop)
#endif

sapMUSICstrc *sapLoadMusicFile( char *fname );
void sapPlaySong( int numOfSong );
void sapRenderBuffer( signed short *buffer, int number_of_samples );

#ifdef __cplusplus
}
#endif

// don't delete sapMUSICstrc returned via sapLoadMusicFile!!!
// don't modify or delete commentBuffer pointed by this structure!!!
// if error occurs, then sapLoadMusicFile returns NULL.
// sapRenderBuffer, fills given buffer with n=(number_of_samples) mono
// 8bit unsigned samples.
// example:
//
// sapMUSICstrc *currentFile;
// unsigned char playBuffer[44100];
// int currentSong;
//
// currentFile = sapLoadMusicFile( "music.sap" );
// currentSong = currentFile->defSong;
// again:
// while(key)
// {
//	sapRenderBuffer( &playBuffer, 44100 );
//	__play_buffer( );
// }
// if( key==next_song )
// {
//     currentSong = (currentSong+1) % currentFile->numOfSongs;
//     sapPlaySong( currentSong );
//     goto again;
// }
// No data need to be deleted, bcoz SAP is using only static data
// and is able to play only one song at time

#endif
