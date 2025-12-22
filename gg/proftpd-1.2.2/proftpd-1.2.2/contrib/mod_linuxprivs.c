/*
 * ProFTPD - FTP server daemon
 * Copyright (c) 1997, 1998 Public Flood Software
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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
 *
 * As a special exemption, Public Flood Software/MacGyver aka Habeeb J. Dihu
 * and other respective copyright holders give permission to link this program
 * with OpenSSL, and distribute the resulting executable, without including
 * the source code for OpenSSL in the source distribution.
 */

/*
 * Optional module for Linux 2.1.104 and > ONLY.  Uses the new "capabilities"
 * in 2.1 kernels which allow root to perform fine grained control
 * over system calls which may be performed (essential making root
 * "not-root" in terms of syscalls).  Excellent for security.  See
 * README.linux-privs.  In order to use this module you'll _need_ a
 * a 2.1 kernel.  A psuedo-port of libcap is included with proftpd
 * in the contrib/libcap directory.  From the top-level directory
 * run ./configure --with-modules=mod_linuxprivs
 * This will automatically build libcap and link it to proftpd.
 *
 * This module effectively _completely_ gives up root, except for
 * the bare minimum functionality that is required, after user
 * authentication.  VERY highly recommended for security-consious admins.
 *
 * NOTE: Linux kernels 2.1 are _development_ kernels, and are likely
 * to change over time.  As this happens, we'll try to keep this module
 * up to date.  Additionally, libcap is a tad buggy and not completely
 * standardized.  This should be solved be the time Linux 2.2 is released.
 * In the interim, we've had to "work-around" a few bugs in libcap, which
 * is why a separate static library is included.
 *
 * -- DO NOT MODIFY THE TWO LINES BELOW --
 * $Libraries: -Lcontrib/libcap -lcap$
 * $Directories: contrib/libcap$
 * $Id: mod_linuxprivs.c,v 1.7 2001/06/18 17:12:44 flood Exp $
 */

#include <stdio.h>
#include <stdlib.h>
#ifdef __powerpc__
#define _LINUX_BYTEORDER_GENERIC_H
#endif
#include <linux/capability.h>
#undef WNOHANG
#undef WUNTRACED

#include "conf.h"
#include "privs.h"

#include "../contrib/libcap/include/sys/capability.h"

static cap_t capabilities = 0;
static int use_capabilities = 1;

/* log current capabilities */
static void lp_debug()
{
  cap_t caps;
  char *res;
  ssize_t len;

  caps = cap_get_proc();
  if(!caps) {
    log_pri(LOG_ERR, "Linuxprivs: cap_get_proc failed: %s.", strerror(errno));
    return;
  }

  res = cap_to_text(caps,&len);
  if(!res) {
    log_pri(LOG_ERR,"Linuxprivs: cap_to_text failed: %s.", strerror(errno));
    cap_free(&caps);
    return;
  }

  log_debug(DEBUG1, "Linuxprivs: capabilities '%s'.", res);
  cap_free(&caps);
  free(res);
}

/* create a new capability structure */
static int lp_init_cap()
{
  if( !(capabilities = cap_init()) ) {
    log_pri(LOG_ERR, "Module linuxprivs: cap_init failed: %s.",
	    strerror(errno));
    return -1;
  }
  return 0;
}

/* free the capability structure */
static void lp_free_cap()
{
  cap_free(&capabilities);
}

/* add a capability to a given set */
static int lp_add_cap(cap_value_t cap, cap_flag_t set)
{
  if(cap_set_flag(capabilities, set, 1, &cap, CAP_SET) == -1) {
    log_pri(LOG_ERR, "Linuxprivs: cap_set_flag failed: %s.", strerror(errno));
    return -1;
  }

  return 0;
}

/* send the capabilities to the kernel */
static int lp_set_cap()
{
  if(cap_set_proc(capabilities) == -1) {
    log_pri(LOG_ERR, "Linuxprivs: cap_set_proc failed: %s.", strerror(errno));
    return -1;
  }

  return 0;
}

/* The post cmd handler for "PASS" is only called after PASS has
 * successfully completed, which means authentication is successful,
 * so we can "tweak" our root access down to almost nothing.
 */

MODRET lowerprivs(cmd_rec *cmd)
{
  int ret;

  if(!use_capabilities)
    return DECLINED(cmd);

  block_signals();
  
  /* glibc2.1 is BROKEN, seteuid() no longer lets one set euid to uid,
   * so we can't use PRIVS_ROOT/PRIVS_RELINQUISH.  setreuid() is the
   * workaround.
   */

  if(setreuid(session.uid,0) == -1) {
    log_pri(LOG_ERR, "setreuid: %s.", strerror(errno));
    unblock_signals();
    return DECLINED(cmd);
  }

  /* The only capability we need is CAP_NET_BIND_SERVICE (bind
   * ports < 1024).  Everything else can be discarded.  We set this
   * in CAP_PERMITTED set only, as when we switch away from root
   * we lose CAP_EFFECTIVE anyhow, and must reset it.
   */

  ret = lp_init_cap();
  if(ret != -1)
    ret = lp_add_cap(CAP_NET_BIND_SERVICE,CAP_PERMITTED);
  if(ret != -1)
    ret = lp_set_cap();

  if(setreuid(0,session.uid) == -1) {
    log_pri(LOG_ERR, "setreuid: %s.", strerror(errno));
    unblock_signals();
    end_login(1);
  }
  unblock_signals();

  /* now our ownly capabilities consist of CAP_NET_BIND_SERVICE,
   * however in order to actually be able to bind to low-numbered
   * ports, we need the capability to be in the effective set.
   */

  if(ret != -1)
    ret = lp_add_cap(CAP_NET_BIND_SERVICE,CAP_EFFECTIVE);
  if(ret != -1)
    ret = lp_set_cap();
  if(capabilities)
    lp_free_cap();

  if(ret != -1) {
    /* That's it!  Disable all further id switching */
    session.disable_id_switching = TRUE;
    lp_debug();
  } else
    log_pri(LOG_NOTICE, "Attempt to configure capabilities failed, "
	    "reverting to normal operation.");

  return DECLINED(cmd);
}

static int linuxprivs_init()
{
  /* Attempt to determine if we are running on a kernel that supports
   * linuxprivs, this allows binary distributions to include the module
   * even if it may not work.
   */

  if(!cap_get_proc() && errno == ENOSYS) {
#if 0
    log_debug(DEBUG1, "Linuxprivs: kernel does not support capabilities, disabling.");
#endif
    use_capabilities = 0;
  }

  return 0;
}  

static cmdtable linuxprivs_commands[] = {
  { POST_CMD,	C_PASS,	G_NONE,	lowerprivs,	TRUE, FALSE },
  { 0, NULL }
};

module linuxprivs_module = {
  NULL, NULL,					/* Always NULL */
  0x20,						/* API Version */
  "linuxprivs",					/* Module name */
  NULL,						/* No directive table */
  linuxprivs_commands,				/* Command handler table */
  NULL,						/* No auth table */
  linuxprivs_init,NULL				/* No child init */
};
