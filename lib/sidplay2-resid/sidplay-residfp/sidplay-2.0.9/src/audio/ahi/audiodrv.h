/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
// --------------------------------------------------------------------------
// ``AHI'' specific audio driver interface.
// --------------------------------------------------------------------------

#ifndef audio_ahi_h_
#define audio_ahi_h_

#include "config.h"
#ifdef   HAVE_AHI

#ifndef AudioDriver
#define AudioDriver Audio_AHI
#endif

#include <sys/ioctl.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

#include "../AudioBase.h"

class Audio_AHI: public AudioBase
{	
private:  // ------------------------------------------------------- private
    static   const char AUDIODEVICE[];
    volatile int   _audiofd;

    bool _swapEndian;
    void outOfOrder ();

public:  // --------------------------------------------------------- public
    Audio_AHI();
    ~Audio_AHI();

    float *open  (AudioConfig &cfg, const char *name);
    void  close ();
    // Rev 1.2 (saw) - Changed, see AudioBase.h	
    float *reset ()
    {
        if (_audiofd != (-1))
        {
            return _sampleBuffer;
        }
        return NULL;
    }
    float *write ();
    void  pause () {;}
};

#endif // HAVE_AHI
#endif // audio_ahi_h_
