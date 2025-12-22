/***************************************************************************
**
** MUI - MagicUserInterface
** (c) 1993-1995 Stefan Stuntz
**
** Main Header File
**
** AmigaE Interface by Jan Hendrik Schulz
**
** The comments are mostly taken unchanged from the original C mui.h file.
** Special comments by me are made with ->. See the guide for more infos
** about this file
** 
***************************************************************************/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'exec/libraries', 'exec/lists', 'exec/nodes', 'exec/tasks',
       'utility/hooks',
       'graphics/rastport', 'graphics/text',
       'intuition/intuition', 'intuition/screens', 'intuition/classes'

/***************************************************************************
** Class Tree
****************************************************************************
**
** rootclass                     (BOOPSI's base class)
** +--Notify                     (implements notification mechanism)
** !  +--Family                  (handles multiple children)
** !  !  +--Menustrip            (describes a complete menu strip)
** !  !  +--Menu                 (describes a single menu)
** !  !  \--Menuitem             (describes a single menu item)
** !  +--Application             (main class for all applications)
** !  +--Window                  (handles intuition window related topics)
** !  !  \--Aboutmui             (About window of MUI preferences)
** !  +--Area             