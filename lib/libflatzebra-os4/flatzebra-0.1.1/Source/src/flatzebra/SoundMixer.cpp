/*  $Id: SoundMixer.cpp,v 1.2 2004/04/20 16:22:02 sarrazip Exp $
    SoundMixer.cpp - Sound mixer based on the SDL_mixer library

    flatzebra - Generic 2D Game Engine library
    Copyright (C) 2001, 2002, 2003 Pierre Sarrazin <http://sarrazip.com/>

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
    02111-1307, USA.
*/

#include "SoundMixer.h"

using namespace std;
using namespace flatzebra;


SoundMixer::SoundMixer(int numChannels) throw(Error)
{
    if (Mix_OpenAudio(11025, AUDIO_U8, 1, 128) == -1)
	throw Error("SoundMixer(): " + string(Mix_GetError()));

    Mix_AllocateChannels(numChannels);
}


SoundMixer::~SoundMixer()
{
    Mix_CloseAudio();
}


void
SoundMixer::playChunk(Chunk &theSound) throw(Error)
{
    if (theSound.sample == NULL)
	return;

    /* 
	Apparently, channel 2 has volume 1 by default, instead of
	MIX_MAX_VOLUME like the others.  To be sure, we set the volume
	on the chosen channel to the maximum.
	This solves an apparent problem observed with SDL_mixer 1.2.4.
    */
    int channelNo = Mix_PlayChannel(-1, theSound.sample, 0);

    if (channelNo == -1)
	throw Error("playChunk(): " + string(Mix_GetError()));
    Mix_Volume(channelNo, MIX_MAX_VOLUME);
}


///////////////////////////////////////////////////////////////////////////////


SoundMixer::Chunk::Chunk()
  : sample(NULL)
{
}


SoundMixer::Chunk::Chunk(const string &wavFilename) throw(Error)
{
    init(wavFilename);
}


void
SoundMixer::Chunk::init(const string &wavFilename) throw(Error)
{
    sample = Mix_LoadWAV(wavFilename.c_str());
    if (sample == NULL)
	throw Error("Chunk::init(" + wavFilename + "): " + Mix_GetError());
}


SoundMixer::Chunk::~Chunk()
{
    if (sample != NULL)
	Mix_FreeChunk(sample);
}
