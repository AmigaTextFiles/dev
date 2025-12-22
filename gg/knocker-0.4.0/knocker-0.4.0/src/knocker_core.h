/* knocker version 0.4.0
 * Release date: 27 July 2001
 *
 * Project homepage: http://knocker.sourceforge.net
 *
 * Copyright 2001 Gabriele Giorgetti <g.gabriele@europe.com>
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#ifdef HAVE_CONFIG_H
#  include <config.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>

/* if no port numbers are given scan from 1 to KNOCKER_DEFAULT_PORT_RANGE */
#define KNOCKER_DEFAULT_PORT_RANGE 1024
/* maximum port number to scan to */
#define KNOCKER_MAX_PORT_NUMBER 65535

enum
{ PORT_IS_CLOSED, PORT_IS_OPEN };

int knocker_portscan_by_hostname (char *hostname, int port);
int knocker_get_service_by_port (char *service, int port);
int knocker_get_ip_by_hostname (char *ip, char *hostname);

