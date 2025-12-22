/*
 * $Id$
 *
 * :ts=4
 *
 * AmigaOS wrapper routines for GNU CVS, using the RoadShow TCP/IP API
 *
 * Written and adapted by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 *                        Jens Langner <Jens.Langner@light-speed.de>
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

#ifndef _AMIGA_H
#define _AMIGA_H 1

/****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <utime.h>

#if defined(__GNUC__)
#include <sys/socket.h>
#endif

#include <netinet/in.h>
#include <sys/stat.h>

/****************************************************************************/

#if defined(__SASC)
#define	ntohl(x)	(x)
#define	ntohs(x)	(x)
#define	htonl(x)	(x)
#define	htons(x)	(x)
#endif

/* First we undefine everything and then we redefine it... */

#undef S_IFMT
#undef S_IFDIR
#undef S_IFREG
#undef S_ISLNK
#undef S_ISFIFO
#undef S_ISDIR
#undef S_ISREG
#undef S_ISCHR
#undef S_ISSOCK

#undef S_ISUID
#undef S_ISGID
#undef S_ISVTX

#undef S_IRWXU
#undef S_IRUSR
#undef S_IWUSR
#undef S_IXUSR

#undef S_IRWXG
#undef S_IRGRP
#undef S_IWGRP
#undef S_IXGRP

#undef S_IRWXO
#undef S_IROTH
#undef S_IWOTH
#undef S_IXOTH

#undef S_IFMT
#undef S_IFIFO
#undef S_IFDIR
#undef S_IFBLK
#undef S_IFREG
#undef S_IFLNK
#undef S_IFSOCK

/* redefining */

#define	S_ISUID	0004000		/* set user id on execution */
#define	S_ISGID	0002000		/* set group id on execution */
#define	S_ISVTX	0001000		/* save swapped text even after use */

#define	S_IRWXU	0000700		/* RWX mask for owner */
#define	S_IRUSR	0000400		/* R for owner */
#define	S_IWUSR	0000200		/* W for owner */
#define	S_IXUSR	0000100		/* X for owner */

#define	S_IRWXG	0000070		/* RWX mask for group */
#define	S_IRGRP	0000040		/* R for group */
#define	S_IWGRP	0000020		/* W for group */
#define	S_IXGRP	0000010		/* X for group */

#define	S_IRWXO	0000007		/* RWX mask for other */
#define	S_IROTH	0000004		/* R for other */
#define	S_IWOTH	0000002		/* W for other */
#define	S_IXOTH	0000001		/* X for other */

#define	S_IFMT		0170000 /* type of file */
#define	S_IFIFO		0010000 /* named pipe (fifo) */
#define	S_IFCHR		0020000 /* character special */
#define	S_IFDIR		0040000 /* directory */
#define	S_IFBLK		0060000 /* block special */
#define	S_IFREG		0100000 /* regular */
#define	S_IFLNK		0120000 /* symbolic link */
#define	S_IFSOCK	0140000 /* socket */

#define	S_ISDIR(m)	(((m) & S_IFMT) == S_IFDIR)	/* directory */
#define	S_ISCHR(m)	(((m) & S_IFMT) == S_IFCHR)	/* char special */
#define	S_ISREG(m)	(((m) & S_IFMT) == S_IFREG)	/* regular file */
#define	S_ISLNK(m)	(((m) & S_IFMT) == S_IFLNK)	/* symbolic link */
#define	S_ISFIFO(m)	(((m) & S_IFMT) == S_IFIFO)	/* fifo */
#define	S_ISSOCK(m)	(((m) & S_IFMT) == S_IFSOCK)/* socket */

/****************************************************************************/

unsigned long amiga_umask(unsigned long mask);
int amiga_geteuid(void);
int amiga_getuid(void);
int amiga_getgid(void);
int amiga_getgroups(int gidsetlen, int * gidset);
struct passwd * amiga_getpwuid(int uid);
struct passwd * amiga_getpwnam(char *name);
struct group * amiga_getgrnam(char *name);
int amiga_gethostname(char * name,int namelen);
int amiga_mkdir(const char *name,int mode);
char * amiga_getlogin(void);
int amiga_utime(const char * const name,const struct utimbuf * const time);
int amiga_pclose(FILE * pipe);
FILE * amiga_popen(const char * command, const char * mode);
char * amiga_getpass(const char *prompt);
unsigned amiga_sleep(unsigned seconds);
int amiga_connect(int sockfd,struct sockaddr *name,int namelen);
int amiga_dup(int sockfd);
struct hostent * amiga_gethostbyname(char *name);
struct servent * amiga_getservbyname(char *name,char *proto);
int amiga_recv(int fd,void *buff,int nbytes,int flags);
int amiga_send(int fd,const void * const buff,int nbytes,int flags);
int amiga_shutdown(int fd,int how);
int amiga_socket(int domain,int type,int protocol);
char * amiga_strerror(int code);
void * amiga_valloc(size_t bytes);
int amiga_close(int fd);
int amiga_symlink(const char * const to,const char * const from);
int amiga_readlink(const char * const path,char *buf,int buf_size);
unsigned long amiga_waitpid(unsigned long pid,int *stat_loc,int options);
long amiga_getpid(void);
int amiga_piped_child(char ** argv,int * to_fd_ptr,int * from_fd_ptr);
int amiga_isabsolute(const char * const filename);
char * amiga_last_component(const char * const path);
int amiga_unlink_file_dir(const char * const f);
int amiga_fncmp(const char * const n1,const char * const n2);
void amiga_fnfold(const char * const name);
int amiga_fold_fn_char(int c);
void amiga_expand_wild(int argc,const char ** const argv,int * _argc,char *** _argv);
int amiga_access(const char *name, int modes);
int amiga_chdir(const char *path);
int amiga_creat(const char *name, int prot);
FILE *amiga_fopen(const char *name, const char *modes);
int amiga_fstat(int fd,struct stat * st);
int amiga_lstat(const char *name, struct stat *st);
int amiga_stat(const char *name, struct stat *st);
int amiga_open(const char *name, int mode, ...);
void *amiga_opendir(const char *dir_name);
int amiga_rename(const char *old, const char *new);
int amiga_rmdir(const char *name);
int amiga_unlink(const char *name);
char * amiga_cvs_temp_name(void);
FILE * amiga_cvs_temp_file(char **fname);
int amiga_chmod(char *name,int mode);
unsigned char *amiga_inet_ntoa(struct in_addr iaddr);
char *amiga_getenv(const char *name);
void amiga_abort(void);

/****************************************************************************/

#ifndef NO_NAME_REPLACEMENT
#undef creat
#undef access
#undef open
#define open  amiga_open

#undef getenv
#define getenv(name)					amiga_getenv(name)
#undef close
#define close(fd)						amiga_close(fd)
#define inet_ntoa(in_addr)				amiga_inet_ntoa(in_addr)
#define chmod(name,mode)				amiga_chmod(name,mode)
#define cvs_temp_name()					amiga_cvs_temp_name()
#define cvs_temp_file(fname)			amiga_cvs_temp_file(fname)
#define access(name, modes)				amiga_access(name, modes)
#define chdir(path)						amiga_chdir(path)
#define creat(name, prot)				amiga_creat(name, prot)
#define fopen(name, modes)				amiga_fopen(name, modes)
#undef lstat
#define lstat(name, st)					amiga_lstat(name, st)
#define stat(name, st)					amiga_stat(name, st)
#define opendir(dir_name)				amiga_opendir(dir_name)
#define rename(old, new)				amiga_rename(old, new)
#define rmdir(name)						amiga_rmdir(name)
#define unlink(name)					amiga_unlink(name)
#define expand_wild(c,v,_c,_v)			amiga_expand_wild(c,v,_c,_v)
#define isabsolute(filename)			amiga_isabsolute(filename)
#define last_component(path)			amiga_last_component(path)
#define unlink_file_dir(f)				amiga_unlink_file_dir(f)
#define fncmp(n1,n2)					amiga_fncmp(n1,n2)
#define fnfold(name)					amiga_fnfold(name)
#define getpid()						amiga_getpid()
#define waitpid(pid,stat_loc,options)	amiga_waitpid(pid,stat_loc,options)
#define readlink(path,buf,buf_size)		amiga_readlink(path,buf,buf_size)
#define symlink(to,from)				amiga_symlink(to,from)
#define valloc(bytes)					amiga_valloc(bytes)
#define sleep(seconds)					amiga_sleep(seconds)
#define getpass(prompt)					amiga_getpass(prompt)
#define pclose(pipe)					amiga_pclose(pipe)
#define popen(command, mode)			amiga_popen(command,mode)
#define utime(name,time)				amiga_utime(name,time)
#define strerror(code)					amiga_strerror(code)
#define umask(mask)						amiga_umask(mask)
#define geteuid()						amiga_geteuid()
#define getuid()						amiga_getuid()
#define getgid()						amiga_getgid()
#define getgroups(gidsetlen, gidset)	amiga_getgroups(gidsetlen, gidset)
#define getpwuid(uid)					amiga_getpwuid(uid)
#define getpwnam(name)					amiga_getpwnam(name)
#define getgrnam(name)					amiga_getgrnam(name)
#define gethostname(name,namelen)		amiga_gethostname(name,namelen)
#define mkdir(name,mode)				amiga_mkdir(name,mode)
#define getlogin()						amiga_getlogin()
#define connect(sockfd,name,namelen)	amiga_connect(sockfd,name,namelen)
#define dup(sockfd)						amiga_dup(sockfd)
#define gethostbyname(name)				amiga_gethostbyname(name)
#define getservbyname(name,proto)		amiga_getservbyname(name,proto)
#define recv(fd,buff,nbytes,flags)		amiga_recv(fd,buff,nbytes,flags)
#define send(fd,buff,nbytes,flags)		amiga_send(fd,buff,nbytes,flags)
#define shutdown(fd,how)				amiga_shutdown(fd,how)
#define socket(domain,type,protocol)	amiga_socket(domain,type,protocol)
#define fstat(fd,st)					amiga_fstat(fd,st)
#define abort()							amiga_abort()
#endif /* NO_NAME_REPLACEMENT */

/****************************************************************************/

#endif /* _AMIGA_H */
