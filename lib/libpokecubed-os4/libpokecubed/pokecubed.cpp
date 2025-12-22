#include "pokecubed.h"
int looptimes = 2;
int fadelength = 2;
int fadelength_samples;
int fadedelay = 0;

pokecubed::pokecubed()  { init(); }
pokecubed::~pokecubed() { deinit(); }

void pokecubed::init()
{
    fileLoaded = false;
    decodePos = 0;
    fileEnd = false;
}

void pokecubed::deinit()
{
    if (fileLoaded)
        CloseCUBEFILE(&cubefile);
    fileLoaded = false;
}

bool pokecubed::loadFile(char* fn)
{
    if(!InitCUBEFILE(fn,&cubefile)) 
        fileLoaded = true;
    if (fileLoaded)
        fadelength_samples = fadelength * cubefile.ch[0].sample_rate;
    return fileLoaded;
}

bool pokecubed::isFilePlayable(char* fn)
{
    static const char *supportedExtensions [] = {
        "dsp","gcm","hps","idsp","spt","spd","mss","mpdsp","ish",
        "ymf","adx","adp","rsd","rsp","ast","afc"
    };

    if (!fn)
        return false;
    const char * pExt = strrchr(fn,'.');
    if (!pExt)
        return false;
    pExt++;
    for (int i=0; i<sizeof(supportedExtensions)/sizeof(supportedExtensions[0]); i++)
        if (strcasecmp(pExt,supportedExtensions[i]) == 0 && loadFile(fn))
            return true;
    return false;
}

int pokecubed::getNSamples(signed short *buff, int n)
{

    if (fileEnd || (decodePos >= cubefile.nrsamples))
    {
        fileEnd = true;
        return 0;
    }

    int foo= 0;
    for (int i=0; i<n; i++) {
        if ((looptimes || cubefile.ch[0].loop_flag) && decodePos+i >= getNumberOfSamples())
            return i;
        
        if (cubefile.ch[0].readloc == cubefile.ch[0].writeloc)
            fillbuffers(&cubefile);

        int pos = i*getNumberOfChannels();
        buff[pos] = cubefile.ch[0].chanbuf[cubefile.ch[0].readloc++];
        if (cubefile.NCH == 2) 
            buff[pos + 1] = cubefile.ch[1].chanbuf[cubefile.ch[1].readloc++];
        if (cubefile.ch[0].readloc >= HEX_8000_DIV_EIGHT_MUL_FOURTEEN)
            cubefile.ch[0].readloc=0;
        if (cubefile.ch[1].readloc >= HEX_8000_DIV_EIGHT_MUL_FOURTEEN) 
            cubefile.ch[1].readloc=0;

        // fade
        if (/*looptimes &&*/ cubefile.ch[0].loop_flag && getNumberOfSamples() - decodePos < fadelength_samples ) 
        {
            int vol = getNumberOfSamples() - decodePos ;
            foo++;
            buff[pos] = (short)((int)buff[pos] * vol / fadelength_samples);
            if (cubefile.NCH==2)
                buff[pos+1]=(short)((int)buff[pos+1] * vol / fadelength_samples);
        }
    }
    decodePos += n;
    printf("foo = %d : left = %d\n",foo,cubefile.nrsamples-decodePos);
    return n;
}

bool pokecubed::getLoadedFileTitle(char* buff)
{
    if (!fileLoaded)
        return false;
    char* end = strrchr(loadedFile,'/');
    if (end)
        strcpy(buff,end+1);
    else
        strcpy(buff,loadedFile);
    return true;
}

int pokecubed::seek(unsigned int s) // Only forward
{
    unsigned int buffstofill = (s * getFrequency()) / INCUBEBUFFSIZE;
    for (int x = buffstofill ; x ; x-- )
    {
        decodePos += INCUBEBUFFSIZE;
        fillbuffers(&cubefile);
    }
    return (int)(buffstofill * INCUBEBUFFSIZE / (getNumberOfChannels() * getFrequency()));
}

CUBEFILE& pokecubed::getCubeFile()      { return cubefile; }
string pokecubed::getLoadedFileName()   { return fileLoaded ? loadedFile : NULL; }
bool pokecubed::isFileLoaded()          { return fileLoaded; }
bool pokecubed::isEOF()                 { return fileEnd; }
bool pokecubed::getLoopFlag()           { return cubefile.ch[0].loop_flag; }
int  pokecubed::getLength()             { return (int)((getNumberOfSamples() * 1000.0) / (getFrequency())); }
int  pokecubed::getFrequency()          { return cubefile.ch[0].sample_rate; }
int  pokecubed::getBitsPerSecond()      { return getFrequency() * getBitsPerSample() * getNumberOfChannels(); }
int  pokecubed::getBitsPerSample()      { return BPS; }
int  pokecubed::getNumberOfChannels()   { return cubefile.NCH; }
long pokecubed::getNumberOfSamples()    { return cubefile.nrsamples; }
int  pokecubed::getDecodeTime()         { return (int)((decodePos * 1000.0) / getFrequency()); }

