/*
    webmail -- simple pop3/smtp web e-mail cgi
    Copyright (C) 2000-2001 Dan Cahill

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#define NWM_SERVERNAME	"Null Webmail / 0.5.9"
/*
 * APPEND_ADDRESS will let you override the hostname part of return e-mail
 * addresses.  If you don't need it, then don't use it.  You probably will
 * want to use this if the return address domain name is more than two levels.
 */
// #define APPEND_ADDRESS	"@here.somewhere.com"
/*
 * NO_USER_HOSTS will remove the user's ability to define their own host names
 * if it is defined.
 */
// #define NO_USER_HOSTS
#define BASE_IMAGE_URL	"/webmail/"
#define COLOR_EDITFORM	"#E0E0E0"
#define COLOR_FTEXT	"#F0F0F0"
#define COLOR_LINKS	"#0000FF"
#define COLOR_TRIM	"#0000B0"
#define COLOR_TRIMTEXT	"#FFFFFF"
#define MAX_LIST_SIZE	50
#define POP3_HOST	"localhost"
#define SMTP_HOST	"localhost"
#define POP3_PORT	110
#define SMTP_PORT	25
#define MAX_POSTSIZE	33554432 /* 32 MB limit for allowed POST sizes */
#define RAW_MESSAGES
// #define USE_FRAMES
/*
 * If you want to change the language, uncomment the appropriate strings header
 * file here.  #include one, and only one strings file.
 */
#include "i18n/strings-en.h"	// English
//#include "i18n/strings-fr.h"	// French
//#include "i18n/strings-de.h"	// German
//#include "i18n/strings-it.h"	// Italian
