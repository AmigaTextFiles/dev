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

#include "knocker_core.h"



int knocker_get_service_by_port (char *service, int port)
{
  struct servent *service_info;

  service_info = getservbyport (htons (port), "tcp");

  if (!service_info)
    {
      strcpy (service, "unknown");
      return -1;
    }
  else
    {
      strcpy (service, service_info->s_name);
    }

  return 0;
}


int knocker_portscan_by_hostname (char *hostname, int port)
{
  int sockfd;
  struct hostent *hostst;
  struct sockaddr_in host_addr;

  if ((hostst = gethostbyname (hostname)) == NULL)
    {
      /* herror("getbyhostname"); */
      return -1;
    }
  if ((sockfd = socket (AF_INET, SOCK_STREAM, 0)) == -1)
    {
      /* perror("socket"); */
      return -1;
    }

  host_addr.sin_family = AF_INET;
  host_addr.sin_port = htons (port);
  host_addr.sin_addr = *((struct in_addr *) hostst->h_addr);
  bzero (&(host_addr.sin_zero), 8);

  if (!connect
      (sockfd, (struct sockaddr *) &host_addr, sizeof (struct sockaddr)))
    /* here the port is open */
    return PORT_IS_OPEN;

  close (sockfd);

  return PORT_IS_CLOSED;
}


int knocker_get_ip_by_hostname (char *ip, char *hostname)
{
    struct hostent *hostst;

   if ((hostst = gethostbyname (hostname)) == NULL)
    {
      /* herror("getbyhostname"); */

      ip = NULL;

      return -1;
    }

   strcpy (ip, inet_ntoa (*(struct in_addr *) *hostst->h_addr_list));

   return 0;
}



