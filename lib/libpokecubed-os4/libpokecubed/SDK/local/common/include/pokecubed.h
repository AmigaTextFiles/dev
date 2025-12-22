#ifndef POKECUBED_H
#define POKECUBED_H
/*
About: This is an interface class for HCS's in_cube winamp plugin. 
It is intended to be a GP2X in_cube player.

Credits: based on and around in_cube and XMMS_Cube.
CUBE Unifies Binary Entertainment Player for GP2X
*/

#include "xmms_cube/windows.h"
#include "in_cube/wamain.h"
#include <string>

#ifndef BPS // Bits per sample
#define BPS 16
#endif

#define INCUBEBUFFSIZE 512

using namespace std;

class pokecubed
{
    public:
        pokecubed();
        ~pokecubed();

        void init();      // Starrtup
        void deinit();    // Shutdown
        CUBEFILE &getCubeFile();
        string getLoadedFileName();
        bool loadFile(char* filename);
        bool getLoadedFileTitle(char *buffer);
        bool isFilePlayable(char* filename);
        bool isFileLoaded();
        bool isEOF();
        bool getLoopFlag();
        int  getNSamples(signed short *buf, int n);
        int  seek(unsigned int time);
        int  getLength();
        int  getFrequency();
        int  getBitsPerSecond();
        int  getBitsPerSample();
        int  getNumberOfChannels();
        long getNumberOfSamples();
        int  getDecodeTime();

    private:
        bool fileLoaded;                    //  Is the file loaded?
        bool fileEnd;                       //  Is it the EOF?
        unsigned int decodePos;             //  track the position
        char* loadedFile;                   //  Filename
        CUBEFILE cubefile;

};

#endif
