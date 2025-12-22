/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1992 by Torsten Jürgeleit
 *
 *	Name .....: protos.h
 *	Created ..: Wednesday 12-Feb-92 21:24:55
 *	Revision .: 2
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	14-Sep-92   Torsten Jürgeleit      new protos for environment variable
 *					   functions
 *	27-Apr-92   Torsten Jürgeleit      now uses global data structure
 *	12-Feb-92   Torsten Jürgeleit      Created this file!
 *
 ****************************************************************************
 *
 *	Prototypes and pragmas
 *
 * $Revision Header ********************************************************/

	/* Prototypes - main.c */

VOID  _cli_parse(VOID);
VOID  _wb_parse(VOID);
LONG  main(VOID);
SHORT init_resources(struct FarData  *fd);
SHORT action_loop(struct FarData  *fd);
SHORT create_gadgets(struct FarData  *fd);
VOID  read_environment_var(struct FarData  *fd, struct NewWindow  *nw);
VOID  write_environment_var(struct FarData  *fd, struct Window  *win);

	/* Pragmas - main.c */

#pragma regcall(init_resources(a0))
#pragma regcall(action_loop(a0))
#pragma regcall(create_gadgets(a0))
#pragma regcall(read_environment_var(a0,a1))
#pragma regcall(write_environment_var(a0,a1))

	/* Prototypes - msg.c */

SHORT perform_intuition_message(struct FarData  *fd,
						  struct IntuiMessage  *im);
SHORT perform_far_message(struct FarData  *fd, struct FarMessage  *fm);
VOID  delete_message(struct FarMessage  *fm);
VOID  flush_messages(struct FarData  *fd);
SHORT add_text(struct FarData  *fd, BYTE *text);
VOID  free_text_list(struct FarData  *fd);
SHORT save_text_list(struct FarData  *fd);

	/* Pragmas - msg.c */

#pragma regcall(perform_intuition_message(a0,a1))
#pragma regcall(perform_far_message(a0,a1))
#pragma regcall(flush_messages(a0))
#pragma regcall(delete_message(a0))
#pragma regcall(add_text(a0,a1))
#pragma regcall(free_text_list(a0))
#pragma regcall(save_text_list(a0))

	/* Prototypes - req.c */

SHORT show_error(struct FarData  *fd, SHORT status);
VOID  continue_requester(struct FarData  *fd, BYTE *title, BYTE *text);
VOID  intuition_error_requester(BYTE *text);
VOID  about_requester(struct FarData  *fd);
BOOL  ok_cancel_requester(struct FarData  *fd, BYTE *title, BYTE *text);

	/* Pragmas - req.c */

#pragma regcall(show_error(a0,d0))
#pragma regcall(continue_requester(a0,a1,a2))
#pragma regcall(intuition_error_requester(a0))
#pragma regcall(ok_cancel_requester(a0,a1,a2))

	/* Prototypes - serial.c */

SHORT open_serial(struct FarData  *fd);
VOID  close_serial(struct FarData  *fd);
VOID  abort_serial(struct FarData  *fd);
SHORT perform_serial_request(struct FarData  *fd, struct IOExtSer  *sio);

	/* Pragmas - serial.c */

#pragma regcall(open_serial(a0))
#pragma regcall(close_serial(a0))
#pragma regcall(abort_serial(a0))
#pragma regcall(perform_serial_request(a0,a1))
