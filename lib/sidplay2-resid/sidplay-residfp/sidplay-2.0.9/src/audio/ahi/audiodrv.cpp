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

#include "audiodrv.h"
#ifdef   HAVE_AHI

#include <stdio.h>
#ifdef HAVE_EXCEPTIONS
#   include <new>
#endif

#if defined(HAVE_NETBSD)
const char Audio_AHI::AUDIODEVICE[] = "/dev/audio";
#else
const char Audio_AHI::AUDIODEVICE[] = "/dev/dsp";
#endif

Audio_AHI::Audio_AHI()
{
    // Reset everything.
    outOfOrder();
    _swapEndian  = false;
}

Audio_AHI::~Audio_AHI ()
{
    close ();
}

void Audio_AHI::outOfOrder ()
{
    // Reset everything.
    _errorString = "None";
    _audiofd     = -1;
}

float *Audio_AHI::open (AudioConfig &cfg, const char *)
{
    char filename[32];

    if (_audiofd != -1)
    {
        _errorString = "ERROR: Device already in use";
        return NULL;
    }

    snprintf(filename, sizeof(filename), "AUDIO:C/%d/B/16/F/%d", (int)cfg.channels, (int)cfg.frequency);
    if ((_audiofd = ::open (filename, O_WRONLY, 0)) == (-1))
    {
        _errorString = "ERROR: Could not open audio device.";
        goto open_error;
    }

    cfg.bufSize = 2048;
#ifdef HAVE_EXCEPTIONS
    _sampleBuffer = new(std::nothrow) float[cfg.bufSize];
#else
    _sampleBuffer = new float[cfg.bufSize];
#endif

    if (!_sampleBuffer)
    {
        _errorString = "AUDIO: Unable to allocate memory for sample buffers.";
        goto open_error;
    }

    // Setup internal Config
    _settings = cfg;
return _sampleBuffer;

open_error:
    if (_audiofd != -1)
    {
        close ();
        _audiofd = -1;
    }

    perror (AUDIODEVICE);
return NULL;
}

// Close an opened audio device, free any allocated buffers and
// reset any variables that reflect the current state.
void Audio_AHI::close ()
{
    if (_audiofd != (-1))
    {
        ::close (_audiofd);
        delete [] _sampleBuffer;
        outOfOrder ();
    }
}

float *Audio_AHI::write ()
{
    short tmp[_settings.bufSize];

    if (_audiofd == (-1))
    {
        _errorString = "ERROR: Device not open.";
        return NULL;
    }

    for (uint_least32_t n = 0; n < _settings.bufSize; n ++) {
            tmp[n] = _sampleBuffer[n] * (1 << 15);
    }

    ::write (_audiofd, tmp, 2 * _settings.bufSize);
    return _sampleBuffer;
}

#endif // HAVE_AHI
