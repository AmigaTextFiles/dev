Note: I (Micket) have made some serious changes to pokecubed.*
It wont work with the original CUBE by PokéParadox anymore.
It has been changed into what i'd expect from a library handling GameCube music playback

Old readme:
CUBE Unifies Binary Entertainment Player for GP2X - By PokéParadox
---------------------------

About:

	Game Cube stream player.
	

Why?	Self education really....

Archive Contents:
	It should be a RAR file containing the following:

		CUBE2x.gpe		- CUBE Player program.
		CUBE2X(buff).gpe	- CUBE Player program with buffering.
		changelog.log 		- Sequential list of changes.		
		Readme.txt 		- This file
		todo.txt		- Sequential list of changes that need to be done at some point.

Basic Usage:
	You have to create a gpu script to pass a song to the player. The commandline should look something like:
	./CUBE2x.gpe -f./CUBEFILE.ADX

	You can set it up in Gmenu2X with the following instructions:

	Parameters			-f[selFullPath]
	Selector Directory		Find where you are keeping the music files
	Selector Filter			.adx,.adp,.ast,.dsp

Controls:
	Start		Play/pause
	Vol+		Volume +
	Vol-		Volume -
	Select & Vol+	Pan right
	Select & Vol-	Pan left
	Start & L & R	Quit
	
	(While Paused)
	Vol+		Increase samples
	Vol-		Decrease samples
	Y		Toggle Sample hack/Resampling

Known Issues:
	-Stuttering.
	-No (working) resampling yet.

Info:
	will play ADX,ADP,DSP,AST... etc. Please visit: http://www.hcs64.com/in_cube.html for more info.
		


Disclaimer Thingy:
	This program is used at the users' own risk! I am grateful for people wanting to test software, but no
	trying to sue me because "M% 5+00P1¦) PROGRAMz Fuxored j00R 1337 Bo><" I promise that this program is
	in no way engineered to purposely do any such thing, but if on the offchance it does happen, well you 
	have been warned!


Credits:
        Coding: PokéParadox
	Testing: PokéParadox & TripmonkeyUK (& you too since you downladed this.)
	Thanks to: HCS, nickspoon.

About me:
	PokéParadox, I'm floating around various places on the internet:
	
	Project Infinity - www.projectinfinity.org.uk
	DDRUK - www.ddruk.com
	GP32X - www.gp32x.com
	Halley's Comet Software - www.hcs64.com

	Other Emulation and Scene sites :)

You can contact me at: pokeparadox AT gmail DOT com
				    @        .     <-- You replace the AT and the DOT ;)
