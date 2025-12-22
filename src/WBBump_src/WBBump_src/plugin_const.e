/* ************** */
/* plugin_const.e */
/* ************** */



/*
    WBBump - Bumpmapping on the Workbench!

    Copyright (C) 1999  Thomas Jensen - dm98411@edb.tietgen.dk

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software Foundation,
    Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/

/*
	constant definitions for plugins, Tags, etc.
*/


OPT MODULE


OPT EXPORT


MODULE	'utility/tagitem'


EXPORT CONST	PLUGINTYPE_BUMPER=%00000001

/* this is the tags that plugin versions 1.x must understand */
/* [ISGA] = Init, Set, Get, Action */
				/* width and height of bumpmap buffer */
EXPORT CONST	PLUGINTAG_WIDTH			=	TAG_USER+0,		-> [I G ]
				PLUGINTAG_HEIGHT		=	TAG_USER+1,		-> [I G ]

				/* ReadArgs() like argument string to plugin */
				PLUGINTAG_ARGS			=	TAG_USER+2,		-> [I   ]


				/* Plugin type, for now only PLUGINTYPE_BUMPER is defined */
				PLUGINTAG_TYPE			=	TAG_USER+3,		-> [  G ]


				/* Is this a plugin that modifies an existing buffer? */
				/* if ISMODIFIER is FALSE, inbuf will be a NULL pointer */
				PLUGINTAG_ISMODIFIER	=	TAG_USER+4,		-> [  G ]


				/* The tooltype that this plugin should respond to */
				PLUGINTAG_COMMANDNAME	=	TAG_USER+5,		-> [  G ]

				/* the name of the plugin */
				PLUGINTAG_NAME			=	TAG_USER+6,		-> [  G ]

				/* copright information */
				PLUGINTAG_COPYRIGHT		=	TAG_USER+7,		-> [  G ]

				/* Author name / email */
				PLUGINTAG_AUTHOR		=	TAG_USER+8,		-> [  G ]

				/* description of plugin */
				PLUGINTAG_DESC			=	TAG_USER+9,		-> [  G ]

				/* is the plugin static? */
				/* ie. is the output the same if the input is? */
				/* example: a clock is not static, a blur rutine is */
				PLUGINTAG_ISSTATIC		=	TAG_USER+10,	-> [  G ]

				/* only for non-static plugins: */
				/* does the plugin need update now? */
				PLUGINTAG_NEEDUPDATE	=	TAG_USER+11,	-> [  G ]

				/* does the plugin need update now? */
				PLUGINTAG_LASTERROR		=	TAG_USER+12		-> [  G ]





