/*
 * AmigaOS wrapper routines for GNU CVS, using the RoadShow TCP/IP API
 *
 * Written and adapted by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 *                        Jens Langner <Jens.Langner@light-speed.de>
 *                        Frank Wille <frank@phoenix.owl.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef _AMIGA_H_
#define _AMIGA_H

void amiga_init(int *argc,char ***argv);
int amiga_expandwild(int,char **,char **);
int amiga_piped_child(char **,int *,int *);
void amiga_start_server(int *,int *,char *,char *,char *,char *);
int amiga_close(int);
int amiga_recv(int,void *,int,int);
int amiga_send(int,const void *,int,int);
int amiga_shutdown(int,int);
int amiga_dup(int);
void amiga_shutdown_server_input(int);
void amiga_shutdown_server_output(int);


#define valloc(n) malloc(n)
#define waitpid(a,b,c) (0)  /* @@@ hack */
#define xreadlink(a) (0)

/* required for internal ssh: */
#define close(fd) amiga_close(fd)
#define recv(fd,buff,nbytes,flags) amiga_recv(fd,buff,nbytes,flags)
#define send(fd,buff,nbytes,flags) amiga_send(fd,buff,nbytes,flags)
#define shutdown(fd,how) amiga_shutdown(fd,how)
#define dup(sockfd) amiga_dup(sockfd)

#endif /* _AMIGA_H_ */
