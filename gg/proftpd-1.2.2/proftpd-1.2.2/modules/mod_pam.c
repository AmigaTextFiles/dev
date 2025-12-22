/*
 * ProFTPD: mod_pam -- Support for PAM-style authentication.
 * Copyright (c) 1998, 1999, 2000 Habeeb J. Dihu aka
 *   MacGyver <macgyver@tos.net>, All Rights Reserved.
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
 * PAM module from ProFTPD
 *
 * This module should work equally well under all Linux distributions (which
 * have PAM support), as well as Solaris 2.5 and above.
 *
 * If you have any problems, questions, comments, or suggestions regarding
 * this module, please feel free to contact Habeeb J. Dihu aka MacGyver
 * <macgyver@tos.net>.
 *
 * -- DO NOT MODIFY THE TWO LINES BELOW --
 * $Libraries: -lpam$
 * $Id: mod_pam.c,v 1.29 2001/06/18 17:12:45 flood Exp $
 */

#include "conf.h"
#include "privs.h"

#ifdef HAVE_PAM

#ifdef HAVE_SECURITY_PAM_APPL_H
#include <security/pam_appl.h>
#endif /* HAVE_SECURITY_PAM_APPL_H */

static pam_handle_t *	pamh			= NULL;
static char *		pamconfig		= "ftp";
static char *		pam_user 		= (char *)0;
static char *		pam_pass 		= (char *)0;
static int		pam_user_len		= 0;
static int		pam_pass_len		= 0;
static int		pam_conv_error		= 0;

static int pam_exchange(num_msg, msg, resp, appdata_ptr)
     int num_msg;
     struct pam_message **msg;
     struct pam_response **resp;
     void *appdata_ptr;
{
  int i;
  struct pam_response *response = NULL;
  
  if(num_msg <= 0)
    return PAM_CONV_ERR;
  
  response = calloc(num_msg, sizeof(struct pam_response));
  
  if(response == (struct pam_response *)0)
    return PAM_CONV_ERR;
  
  for(i = 0; i < num_msg; i++) {
    response[i].resp_retcode = 0; /* PAM_SUCCESS; */
    
    switch(msg[i]->msg_style) {
    case PAM_PROMPT_ECHO_ON:
      /* PAM frees response and resp.  If you don't believe this, please read
       * the actual PAM RFCs as well as have a good look at libpam.
       */
      response[i].resp = pam_user ? strdup(pam_user) : NULL;
      break;
      
    case PAM_PROMPT_ECHO_OFF:
      /* PAM frees response and resp.  If you don't believe this, please read
       * the actual PAM RFCs as well as have a good look at libpam.
       */
      response[i].resp = pam_pass ? strdup(pam_pass) : NULL;
      break;
      
    case PAM_TEXT_INFO:
    case PAM_ERROR_MSG:
      /* Ignore it, but pam still wants a NULL response... */
      response[i].resp = NULL;
      break;
      
    default:
      /* Must be an error of some sort... */
      if(response[i].resp != NULL)
	free(response[i].resp);
      
      free(response);
      pam_conv_error = 1;
      return PAM_CONV_ERR;
    }
  }
  
  *resp = response;
  return PAM_SUCCESS;
}

static struct pam_conv pam_conv = {
  &pam_exchange,
  NULL
};

static void modpam_exit(void) {
  int pam_error = 0;

  /* Sanity check.
   */
  if(pamh == NULL)
    return;
  
  /* We need privileges to be able to write to things like lastlog and
   * friends.
   */
  block_signals();
  PRIVS_ROOT;

  /* Give up our credentials, close our session, and finally close out this
   * instance of PAM authentication.
   */
  if((pam_error = pam_setcred(pamh, PAM_DELETE_CRED)) != PAM_SUCCESS)
    log_pri(LOG_NOTICE, "PAM(exit): %s.", pam_strerror(pamh, pam_error));

  if((pam_error = pam_close_session(pamh, PAM_SILENT)) != PAM_SUCCESS)
    log_pri(LOG_NOTICE, "PAM(exit): %s.", pam_strerror(pamh, pam_error));
  
  /* Finished cleaning up.
   */
  pam_end(pamh, pam_error);
  pamh = NULL;
  
  if(pam_user != NULL) {
    bzero(pam_user, pam_user_len);
    free(pam_user);
    pam_user = NULL;
    pam_user_len = 0;
  }
  
  PRIVS_RELINQUISH;
  unblock_signals();
}

MODRET pam_auth(cmd_rec *cmd)
{
  int pam_error = 0, retval = 0, pam_return_type;
  int success = 0;
  config_rec *c;

#ifdef SOLARIS2
  char ttyentry[32];
#endif /* SOLARIS2 */
  
  /* If we haven't been explicitly disabled, enable us by default.
   */
  if(get_param_int(TOPLEVEL_CONF, "AuthPAM", FALSE) == 0)
    return DECLINED(cmd);
  
  /* Figure out our default return style:
   * Whether or not PAM should allow other auth modules a shot at this
   * user or not is controlled by the parameter
   * "AuthPAMAuthoritative".  It defaults to no, which is not the most
   * secure configuration, but allows things like AuthUserFile to work
   * "out of the box".
   */
  if((pam_return_type = get_param_int(TOPLEVEL_CONF,
				      "AuthPAMAuthoritative", FALSE)) == -1) {
    pam_return_type = 0;
  }

  /* Just in case...
   */
  if(cmd->argc != 2)
    return pam_return_type ? ERROR(cmd) : DECLINED(cmd);
  
  /* Allocate our entries...we free these up at the end of the authentication.
   */
  if((pam_user_len = strlen(cmd->argv[0]) + 1) > (PAM_MAX_MSG_SIZE + 1))
    pam_user_len = PAM_MAX_MSG_SIZE + 1;
  pam_user = malloc(pam_user_len);
  if(pam_user == (char *)0)
    return pam_return_type ? ERROR(cmd) : DECLINED(cmd);
  sstrncpy(pam_user, cmd->argv[0], pam_user_len);
  
  if((pam_pass_len = strlen(cmd->argv[1]) + 1) > (PAM_MAX_MSG_SIZE + 1))
    pam_pass_len = PAM_MAX_MSG_SIZE + 1;
  pam_pass = malloc(pam_pass_len);
  if(pam_pass == (char *)0) {
    bzero(pam_user, pam_user_len);
    free(pam_user);
    pam_user = NULL;
    pam_user_len = 0;
    pam_pass_len = 0;
    return pam_return_type ? ERROR(cmd) : DECLINED(cmd);
  }
  
  sstrncpy(pam_pass, cmd->argv[1], pam_pass_len);
  
  /* Check for which PAM config file to use.  Since we have many different
   * potential servers, they may each require a seperate type of PAM
   * authentication.
   */
  if((c = find_config(TOPLEVEL_CONF, CONF_PARAM, "AuthPAMConfig", FALSE)) !=
     NULL)
    pamconfig = c->argv[0];
  
  /* Due to the different types of authentication used, such as shadow
   * passwords, etc. we need root privs for this operation.
   */
  block_signals();
  PRIVS_ROOT;

  /* The order of calls into PAM should be as follows, according to Sun's
   * documentation at http://www.sun.com/software/solaris/pam/:
   *
   * pam_start()
   * pam_authenticate()
   * pam_acct_mgmt()
   * pam_open_session()
   * pam_setcred()
   */
  pam_error = pam_start(pamconfig, pam_user, &pam_conv, &pamh);
  if(pam_error != PAM_SUCCESS)
    goto done;

  /* Set our host environment for PAM modules that check host information.
   */
  if(session.c != NULL)
    pam_set_item(pamh, PAM_RHOST, session.c->remote_name);
  else
    pam_set_item(pamh, PAM_RHOST, "IHaveNoIdeaHowIGotHere");
  
#ifdef SOLARIS2
  /* Set our TTY environment.  This is apparently required for Solaris
   * environments, since unless PAM_RHOST and PAM_TTY are defined, and
   * the string given to PAM_TTY must be of the form (or at least greater
   * than the length of) "/dev/", pam_open_session() will crash and burn
   * a horrible death that took many hours to debug...YUCK.
   *
   * This bug is Sun bugid 4250887, and should be fixed in an update for
   * Solaris.  -- MacGyver
   */
  snprintf(ttyentry, sizeof(ttyentry), "/dev/ftp%02ld", getpid());
  pam_set_item(pamh, PAM_TTY, ttyentry);
#endif /* SOLARIS2 */

  /* Authenticate, and get any credentials as needed.
   */
  pam_error = pam_authenticate(pamh, PAM_SILENT);
  
  if(pam_error != PAM_SUCCESS) {
    switch(pam_error) {
    case PAM_USER_UNKNOWN:
      retval = AUTH_NOPWD;
      break;
      
    default:
      retval = AUTH_BADPWD;
      break;
    }
    
    log_pri(LOG_NOTICE, "PAM(%s): %s.", cmd->argv[0],
	    pam_strerror(pamh, pam_error));
    goto done;
  }
  
  if(pam_conv_error != 0) {
    retval = AUTH_BADPWD;
    goto done;
  }
  
  pam_error = pam_acct_mgmt(pamh, PAM_SILENT);

  if(pam_error != PAM_SUCCESS) {
    switch(pam_error) {
#ifdef PAM_AUTHTOKEN_REQD
    case PAM_AUTHTOKEN_REQD:
      retval = AUTH_AGEPWD;
      break;
#endif /* PAM_AUTHTOKEN_REQD */

    case PAM_ACCT_EXPIRED:
      retval = AUTH_DISABLEDPWD;
      break;
      
    case PAM_USER_UNKNOWN:
      retval = AUTH_NOPWD;
      break;
      
    default:
      retval = AUTH_BADPWD;
      break;
    }
    
    log_pri(LOG_NOTICE, "PAM(%s): %s.", cmd->argv[0],
	    pam_strerror(pamh, pam_error));
    goto done;
  }
  
  /* Open the session.
   */
  pam_error = pam_open_session(pamh, PAM_SILENT);
  
  if(pam_error != PAM_SUCCESS) {
    switch(pam_error) {
    case PAM_SESSION_ERR:
    default:
      retval = AUTH_DISABLEDPWD;
      break;
    }
    
    log_pri(LOG_NOTICE, "PAM(%s): %s.", cmd->argv[0],
	    pam_strerror(pamh, pam_error));
    goto done;
  }
  
  /* Finally, establish credentials.
   */
  pam_error = pam_setcred(pamh, PAM_ESTABLISH_CRED);
  
  if(pam_error != PAM_SUCCESS) {
    switch(pam_error) {
    case PAM_CRED_EXPIRED:
      retval = AUTH_AGEPWD;
      break;
      
    case PAM_USER_UNKNOWN:
      retval = AUTH_NOPWD;
      break;
      
    default:
      retval = AUTH_BADPWD;
      break;
    }
    
    log_pri(LOG_NOTICE, "PAM(%s): %s.", cmd->argv[0],
	    pam_strerror(pamh, pam_error));
    goto done;
  }
  
  success++;
  
 done:
  /* And we're done.  Clean up and relinquish our root privs.
   */
  
  if(!success) {
    pam_end(pamh, pam_error);
    pamh = NULL;
  }
  
  if(pam_pass != NULL) {
    bzero(pam_pass, pam_pass_len);
    free(pam_pass);
    pam_pass = NULL;
    pam_pass_len = 0;
  }
  
  PRIVS_RELINQUISH;
  unblock_signals();
  
  if(!success) {
    if(pam_user != NULL) {
      bzero(pam_user, pam_user_len);
      free(pam_user);
      pam_user = NULL;
      pam_user_len = 0;
    }

    return pam_return_type ? ERROR_INT(cmd, retval) : DECLINED(cmd);
  } else {
    add_exit_handler(modpam_exit);
    return HANDLED(cmd);
  }
}

MODRET set_pam(cmd_rec *cmd)
{
  int b;
  
  CHECK_ARGS(cmd, 1);
  CHECK_CONF(cmd, CONF_ROOT | CONF_VIRTUAL | CONF_GLOBAL);
  
  if((b = get_boolean(cmd, 1)) == -1)
    CONF_ERROR(cmd, "expected boolean argument.");

  add_config_param("AuthPAM", 1, (void *) b);

  return HANDLED(cmd);
}

MODRET set_pamauthoritative(cmd_rec *cmd)
{
  int b;
  
  CHECK_ARGS(cmd, 1);
  CHECK_CONF(cmd, CONF_ROOT | CONF_VIRTUAL | CONF_GLOBAL);
  
  if((b = get_boolean(cmd, 1)) == -1)
    CONF_ERROR(cmd, "expected boolean argument.");

  add_config_param("AuthPAMAuthoritative", 1, (void *) b);

  return HANDLED(cmd);
}

MODRET set_pamconfig(cmd_rec *cmd)
{
  CHECK_ARGS(cmd, 1);
  CHECK_CONF(cmd, CONF_ROOT | CONF_VIRTUAL | CONF_GLOBAL);

  add_config_param_str("AuthPAMConfig", 1, (void *) cmd->argv[1]);
  
  return HANDLED(cmd);
}

static authtable pam_authtab[] = {
  { 0, "auth", pam_auth},
  { 0, NULL, NULL}
};

static conftable pam_conftab[] = {
  { "AuthPAM", set_pam, NULL },
  { "AuthPAMAuthoritative", set_pamauthoritative, NULL },
  { "AuthPAMConfig", set_pamconfig, NULL },
  { NULL, NULL, NULL}
};

module pam_module = {
  NULL,NULL,			/* Always NULL */
  0x20,				/* API Version 2.0 */
  "pam",
  pam_conftab,			/* PAM configuration handler table */
  NULL,				/* No command handler table */
  pam_authtab,			/* PAM authentication handler table */
  NULL,    	    		/* No initialization needed */
  NULL  	        	/* No post-fork "child mode" init */
};

#endif /* HAVE_PAM */
