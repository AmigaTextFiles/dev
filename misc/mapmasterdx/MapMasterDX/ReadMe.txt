Welcome to MapMasterDX - v1.2

MapMasterDX can be used to create a background scene made
up of individual blocks or tiles. This tool is useful for
those interested in creating backgrounds for classic 2D games.
Some example blocks and maps are included as well as a
simple C source code example of how to use the mapfiles.

Note: Flipped blocks are handled by attribute settings now
	  the previous method is no longer supported. If you
	  already have files created in the old format send
	  me an email. Also read the new section on block
	  attributes below and see "loadatr_funcs.c".
 
-----------------
- Documentation -
-----------------

--------------------------
- User Interface Options -
--------------------------

Input:

LeftClick: - pastes a block or section of blocks into the mapedit display
           - selects a block from the block panel

           Note: You can select a rectangular section of blocks from
                 the panel by left-clicking on the first block
                 and then dragging to another block and releasing.

RightClick: bring up or hide the block selection panel (toggle)

Note: After selecting a block the panel window will be hidden
      again. You can edit very quickly by right clicking and then left
      clicking in combination. A nice bonus is that the block panel
	  doesn't stay overtop your working area. New in v0.9 you can
	  choose "Keep Open" option to have the block window always
	  stay open when selecting blocks.

-------------------
- MapEdit Gadgets -
-------------------

LoadMap: This gadget allows you to load a previously saved map.
         When loading the map all the settings the map was saved
         with are automatically retrieved with the exception of the
         block image which must be loaded manually.

SaveMap: Allows you to save the currently displayed map.

MapWidth: Width in blocks of the map you want to edit.

MapHeight: Height in blocks of the map you want to edit.

Save Format: This is the file format that will be used when you
			 you save the map. Only "MapMaster" format can be
			 re-loaded into the editor, so be careful.

All Layers: When Saving with "All Layers" enabled each of the 4
            layers of mapdata will be saved as seperate mapfiles
            with the added extension ".lx" where x = layer number.

            When loading with "All Layers" enabled, the program
            will automatically load all 4 layers back into the editor.
            (map file selected must have ".lx" filename extension)

            Note:If "All Layers" gadget is disabled when loading or
                 saving maps, only the current selected "Edit:" layer
                 will be saved/loaded.

Attributes: When checked the program will automatically save local map
			and global block attribute settings along with your mapdata.
			1 attribute file is saved with each layer with the filename
			ext ".atr" added. The global block attribute file is saved
			with the same filename as your currently loaded blocks with
            a ".atr" extension as well.

LoadBlocks: This is where you load the image containing your block graphics.
			The image is decoded with the datatypes system so many file formats
			are supported. Please note that currently only 16-24bit images are
			supported. If you load anything 256 colors or less the palette will
			be incorrect. It's a good idea to save a 24bit version of your low
			color blocks if you want to use them with MapMasterDX.

			Note:If an alpha channel is found (primarily PNG files) it will
				 be used as a transparency mask. You can make your blocks
				 show through to the lower layers while editing using this
				 method. This option makes refreshing somewhat slower so
				 turn off some layers while editing if needed. ImageFX can
				 be used to easily make an alpha channel by using the
				 (Alpha->Create->Matte) feature.

BlockWidth:  Width in pixels of an individual block

BlockHeight: Height in pixels of an individual block

BlockGap: Size of gap between blocks in pixels.
          If your blocks are surrounded by an evenly spaced grid
		  you must set an appropriate gap for them to be used correctly.
		  For instance if their is a 1 pixel grid between your blocks
		  in the image then set blockgap to 1. If the blocks are right
		  next to each other without any space between set blockgap to 0.
		  Look at the example blocks for a better idea of this.

LockSettings: This locks the current blockwidth/blockheight/blockgap
			  from being altered by loading a new mapfile. This is useful
			  if you want to load a map using a different set of blocks
			  than it was originally saved with.

X: The X button will clear the current map and start a new blank one
   using the current gadget settings for map and block sizing.
   This gadget is useful when you want to start a new blank project.

Mode: This sets the pasting modes as follows:
	  - Normal:Copy block and all atr settings
	  - Modify ATR:  Only copy non-zero value atr settings
	  - Replace ATR: Copy full atr settings from the src to dst
	  - Flip X: Copy block and set xflip atr
	  - Flip Y: Copy block and set yflip atr
	  - Flip XY: Copy block and set xflip and yflip atr

Edit: These 4 gadgets represent the 4 layers of mapdata available for
	  editing. You must select a layer before you can edit it.
	  The gadget order is from lowest layer on the left to topmost
	  layer on the right. Be careful to always select the intended
	  layer before editing. The "Edit layer" is also the only one saved
	  or loaded unless the "All Layers" gadget is enabled.

Visible: These 4 gadgets represent the 4 layers of mapdata. When enabled
		the respective layer will be displayed. Disabling a layer doesn't
		harm the mapdata instead it just becomes hidden until re-enabled
		again.

Grab Section: If you want to grab a single block or rectangular section
			 from the active layer press the scissors gadget once. Then
			 click on a block in the display or drag out a rectangle to
			 make your selection. Upon completion your cursor shape will
			 change to reflect the size of the section you grabbed. If you
			 want to cancel the grabbing operation right click once. When
			 grabbing local attribute settings are preserved.

Undo: Clicking the Undo gadget will revert the last pasted block
	  back to it's former state. You can hit it multiple times until
	  the Undo buffer is exhausted.

Show ATR: When set to any value except "None" the corresponding atr
		  value held by each block will be displayed overlayed onto
		  the upper left corner of each square. This only works well
		  with blocks sized 16x16 or larger.

----------------------
- BlockPanel Gadgets -
----------------------

Keep Open: This gadget is found on the block select window. When enabled
		   the block window will remain open after selecting a block, you
		   can still open/close the window with a right mouse click though.

Transparent: Set the transparent atr value to 0 or 1.

Collision: Set collision detection atr value to 0 to 255.

AnimFrames: Set animation value to 0 to 31.


--------------------------------------------
QuickKeys (all quick keys are lower case)
--------------------------------------------
arrow keys - Move scrollbars in mapedit view

l : LoadMap

s : SaveMap

b : LoadBlocks

k : lock the block settings

r : Cycle show atr gadget

7 8 9 - : Select edit layer    0 -> 3 (numpad)

4 5 6 + : Select which layers are visible 0 -> 3 (numpad)

u - Undo last block paste

g - Grab a section of blocks from the current active layer


-------------------------------
- Map file format description -
-------------------------------

V1.1 MapMasterDX can save several different file formats
	 here is a simple description of each.

- MapMaster Format:

The map files themselves are currently saved in a very simple
ascii text format that can be edited by hand in a text editor.
Here is a description of how it's organized, each entry is an
int size value seperated by a linebreak:

MapWidth
MapHeight
BlockWidth
BlockHeight
BlockGap
blockID
blockID
blockID
...etc.

The file contains (mapwidth * mapheight) number of block id entries.
Each block id represents the block that was pasted into the mapeditor
using your settings as a reference. The block id can range from 1 to
the last block in your image file. Please look in the source directly
for an example of how to read and write the data. The data is organized
in a left to right order starting from the first map block in the upper
left corner until it reaches the last block in the lower right corner.
(single array of int values)

- Raw 32bit Format:
This is simply all of the mapdata block IDs written
to a binary file as a series of int (4 bytes each) sized values.

- C Source Format:
This writes an int sized array describing the mapdata.

Note:
The mapwidth/mapheight/blockwidth/blockheight/blockgap values
are not written out when Raw32 or C Source is selected. You can
not reload these formats back into MapMaster either.

-------------------------------------
- Attribute file format description -
-------------------------------------

Description of attributes and how to use them:
Attributes exist as a way to save some extra information or
settings along with a block ID. There exists 2 kinds of attribute
data, local and global. Global refers to data attached to the
block image, for instance setting block #5 to be transparent
will then make all additional block #5s you paste down have the
transparent attribute set.

Local attributes can be set for each and every position in the mapdata
instead of only once per block ID. If block #5's global setting is transparent
and you paste #5 into the mapdata, the local setting becomes transparent.
If you change #5 to be non-transparent afterwards and paste into a new
position the local data for #5 becomes non-transparent but the blocks
you pasted before will remain unaffected. The current global attribute
is always copied to the local attribute when pasting) Attributes are also
preserved when grabbing sections or undoing. If you don't require each block
in the mapdata to have a seperate setting simply ignore the local files and use
only the globals in your program. Global files are saved beside your blockfile
and the locals are saved beside each mapfile layer. (".atr" extension)

The attributes are currently saved into a plain ascii text file with a
custom formatting. An example source code is included to read this data.
You may convert and store the attribute data however you wish at load time
within your program of course. Attribute entries are only saved for blocks
that vary from the default values of 0. Your program may use the values
for any purpose but I have included some basic types that should come in useful.


Description of each attribute setting:

I (IDnum) - New BlockID, attributes set after this are attached to this block
			ID. For global attributes this is a direct ID, for local attributes
			this corresponds to a position in the mapdata array contained within
			the range (mapwidth*mapheight).

T (value)  - Tranparency value: 0 for (OFF) 1 for (ON)

C (value)  - Collision detection value: (1 - 255)

F (value)  - Animation Frames (sequential animation of blocks): (1-31)

X (value)  - If set to 1 this block should be flipped on X when drawn (local only)

Y (value)  - If set to 1 this block should be flipped on Y when drawn (local only)

Q () - End of file

The file "loadatr_funcs.c" has some pre-made functions to read global
attribute data. Modify to suit your needs. If you have any questions
send me an email.


-----------------------------------------------------------------
- Version History -
-----------------------------------------------------------------
December 26 2007: v1.2
- Fixed bug when loading attributes into multiple layers
- Fixed savemap directory not being restored
- Added ShowATR gadget to overlay atr values onto blocks
- Better response to show/hide layer gadgets
- "Modify ATR" pasting mode added
- Fixed bug in pastemode selection
- "Replace Attribute" pasting mode added

December 24 2007: v1.1b
- Fixed version number
- Added local attributes display on edit window

December 23 2007: v1.1
- Added (X + Y + position) coordinates display in edit canvas
- Cursor refreshes on inital click to block select window
- Currently selected block ID is displayed in the block panel
- Gadgets for setting global block attributes added to block panel
- Attribute data is loaded and saved when "Attributes" gadget is enabled
- Fixed crash when 'Clear' gadget was clicked after changing block sizes
- Added 'Grab Section' gadget to copy a section from the edit window
- Cursor shape changes to reflect size of pasting section
- cursor refresh improved
- Flipping modes changed to be set in local map attributes
- Undo and section pasting modified to handle attributes
- Directory paths are now recalled upon restarting the program

July 13 2007: v0.9
- pasting of x and/or y flipped blocks added
- now goes directly to edit mode after loading blocks
- larger possible map sizes (1024x1024)
- setting added to keep block window open while editing
- possible to save as Raw32bit data or C Source code
- doesn't add ".lx" extension to filename if already present
- fixed crash when blank filename was selected
- updated documentation

June 08 2007: v0.8
- cut and paste of rectangular block sections
- multi-layered map editing
- transparency mask for layers (PNG)
- Added a cursor
- Fixed bug causing incorrect block id
- locking of the block settings
- multiple Undo feature
- keyboard shortcuts for several gadgets/functions
- "All Layers" gadget for multi-layer save/load
- Updated documentation
- Numerous other bug fixes
- increased stability

January 13 2007: v0.4 - First public release

-----------
- License -
-----------
MapMasterDX is Copyright © 1997-2007 Kelly Samel / Emerald Games.
MapMasterDX is freely redistributable but may not be sold for any
kind of profit without explicit permission from the Copyright holder.
Mapdata files generated with the software may be used for any purpose
including inclusion in freeware or commercial software. Please ask for
permission if you want to use the example block images in your project.

-----------
- Contact -
-----------

MapMasterDX by Kelly Samel / Emerald Games

Contact: realstar@shaw.ca
Website: http://members.shaw.ca/realstar

