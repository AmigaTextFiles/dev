/*  $Id: SoundMixer.h,v 1.1 2003/04/26 04:19:06 sarrazip Exp $
    SoundMixer.h - Sound mixer based on the SDL_mixer library

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

#ifndef _H_SoundMixer
#define _H_SoundMixer

#include <SDL/SDL_mixer.h>

#include <string>


namespace flatzebra {


class SoundMixer
{
public:

    class Error
    {
    public:
	Error(const std::string &s) : errMsg(s) {}
	const std::string &what() const { return errMsg; }
    private:
	std::string errMsg;
    };

    SoundMixer(int numChannels = 8) throw(Error);
    /*  Initializes the SDL_mixer system at a rate of 11025 Hz, mono.
	'numChannels' must be the number of channels to be allocated.
	SDL must already have been initialized.
	If the SDL_mixer initialization fails, throws the error message
	as an exception.
	Only one instance of this class should be created.
    */

    ~SoundMixer();
    /*  Shuts down the SDL_mixer system.
    */


    class Chunk
    {
    public:

	Chunk();
	/*  Initializes an empty sound chunk.  Call init() after this.
	*/

	Chunk(const std::string &wavFilename) throw(Error);
	/*  Calls init() with 'wavFilename' and it if returns a (non-empty)
	    error message, throws it as an exception.
	*/

	void init(const std::string &wavFilename) throw(Error);
	/*  Loads the WAV file whose name is given.
	    If the load fails, throws the error message as an exception.
	*/

	~Chunk();
	/*  Frees the resources used by the chunk.
	*/

    private:
	Mix_Chunk *sample;
	friend class SoundMixer;
    };


    void playChunk(Chunk &theSound) throw(Error);
    /*  Schedules 'theSound' to be played now on a free unreserved channel.
	On failure, throws the error message as an exception.
    */


private:

    /*	Forbidden operations:
    */
    SoundMixer(const SoundMixer &x);
    SoundMixer &operator = (const SoundMixer &x);
};


}  // namespace flatzebra


#endif  /* _H_SoundMixer */
