/***********************************************************************
 *  avra - Assembler for the Atmel AVR microcontroller series
 *  Copyright (C) 1998-1999 Jon Anders Haugum
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; see the file COPYING.  If not, write to
 *  the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 *  Boston, MA 02111-1307, USA.
 *
 *
 *  Author of avra can be reached at:
 *     email: jonah@omegav.ntnu.no
 *     www: http://www.omegav.ntnu.no/~jonah/el/avra.html
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include "misc.h"
#include "args.h"
#include "avra.h"
#include "device.h"

const char *title = "avra %d.%d (%s)\n"
                    "Copyright (C) 1998-1999 Jon Anders Haugum\n"
                    "   avra comes with NO WARRANTY, to the extent permitted by law.\n"
                    "   You may redistribute copies of avra under the terms\n"
                    "   of the GNU General Public License.\n"
                    "   For more information about these matters, see the files named COPYING.\n";

const char *usage =
	"usage: avra [--define <symbol>[=<value>]] [--listmac]\n"
	"            [--max_errors <number>] [--version] [-h] [--help]\n"
	"            <file to assemble>\n"
	"\n"
	"   --define     : Define symbol.\n"
	"   --listmac    : List macro expansion in listfile\n"
	"   --max_errors : Maximum number of errors before exit (default: 10)\n"
	"   --version    : Version information\n"
	"   --help, -h   : This help text\n"
	"\n"
	"Report bugs to jonah@omegav.ntnu.no\n";



int main(int argc, char *argv[])
	{
	int show_usage = False;
	struct prog_info *pi;
	struct args *args;

	args = alloc_args(ARG_COUNT);
	if(args)
		{
		define_arg(args, ARG_DEFINE,     ARGTYPE_STRING_MULTISINGLE,   0, "define",     NULL);
		define_arg(args, ARG_LISTMAC,    ARGTYPE_BOOLEAN,              0, "listmac",    False);
		define_arg(args, ARG_MAX_ERRORS, ARGTYPE_STRING,               0, "max_errors", "10");
		define_arg(args, ARG_VER,        ARGTYPE_BOOLEAN,              0, "version",    False);
		define_arg(args, ARG_HELP,       ARGTYPE_BOOLEAN,            'h', "help",       False);
		if(read_args(args, argc, argv))
			{
			if(!GET_ARG(args, ARG_HELP) && (argc != 1))
				{
				if(!GET_ARG(args, ARG_VER))
					{
					pi = get_pi(args);
					if(pi)
						{
						assemble(pi);
						free_pi(pi);
						}
					}
				else
					printf(title, VERSION, REVISION, DATESTRING);
				}
			else
				show_usage = True;
			}
		free_args(args);
		}
	else
		{
		show_usage = True;
		printf("\n");
		}
	if(show_usage)
		{
		if(argc == 1)
		        {
			printf(title, VERSION, REVISION, DATESTRING);
			printf("\n");
			}
		printf("%s", usage);
		}
	exit(EXIT_SUCCESS);
	}


void assemble(struct prog_info *pi)
        {
	if(pi->args->first_data)
	        {
		printf("Pass 1...\n");
		if(!load_arg_defines(pi))
		        return;
		if(parse_file(pi, (char *)pi->args->first_data->data, PASS_1))
		        {
			if(pi->error_count == 0)
			        {
				prepare_second_pass(pi);
				if(!load_arg_defines(pi))
				        return;
				if(open_out_files(pi, pi->args->first_data->data))
				        {
					printf("Pass 2...\n");
					parse_file(pi, (char *)pi->args->first_data->data, PASS_2);
					if(pi->error_count)
					        printf("Assembly aborted with %d errors and %d warnings\n", pi->error_count, pi->warning_count);
					else if(pi->warning_count)
					        printf("Assembly complete with no errors (%d warnings)\n", pi->warning_count);
					else
					        printf("Assembly complete with no errors\n");
					close_out_files(pi);
					write_map_file(pi);
					}
				}
			}
		}
	else
	        printf("Error: You need to specify a file to assemble\n");
	}


int load_arg_defines(struct prog_info *pi)
        {
	int i;
	char *expr;
	struct data_list *define;
	struct label *label;

	for(define = GET_ARG(pi->args, ARG_DEFINE); define; define = define->next)
	        {
		expr = get_next_token(define->data, TERM_EQUAL);
		if(expr)
		        {
			if(!get_expr(pi, expr, &i))
			        return(False);
			}
		else
		        i = 1;
		for(label = pi->first_constant; label; label = label->next)
		        if(!nocase_strcmp(label->name, define->data))
			        {
				printf("Error: Can't define symbol %s twice\n", (char *)define->data);
				return(False);
				}
		label = malloc(sizeof(struct label));
		if(!label)
		        {
			print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
			return(False);
			}
		label->next = NULL;
		if(pi->last_constant)
		        pi->last_constant->next = label;
		else
		        pi->first_constant = label;
		pi->last_constant = label;
		label->name = malloc(strlen(define->data) + 1);
		if(!label->name)
		        {
			print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
			return(False);
			}
		strcpy(label->name, define->data);
		label->value = i;
		}
	return(True);
	}


struct prog_info *get_pi(struct args *args)
	{
	struct prog_info *pi;

	pi = (struct prog_info *)calloc(1, sizeof(struct prog_info));
	if(pi)
		{
		pi->args = args;
		pi->device = get_device(NULL);
		pi->list_on = True;
		pi->segment = SEGMENT_CODE;
		pi->dseg_addr = DSEG_START;
		pi->max_errors = atoi(GET_ARG(args, ARG_MAX_ERRORS));
		return(pi);
		}
	return(NULL);
	}


void free_pi(struct prog_info *pi)
	{
	free(pi);
	}


void prepare_second_pass(struct prog_info *pi)
	{
	struct def *def, *temp_def;
	struct label *label, *temp_label;

	pi->segment = SEGMENT_CODE;
	pi->cseg_addr = 0;
	pi->dseg_addr = DSEG_START;
	pi->eseg_addr = 0;

	for(def = pi->first_def; def;)
		{
		temp_def = def;
		def = def->next;
		free(temp_def->name);
		free(temp_def);
		}
	pi->first_def = NULL;	
	pi->last_def = NULL;	

	for(label = pi->first_constant; label;)
		{
		temp_label = label;
		label = label->next;
		free(temp_label->name);
		free(temp_label);
		}
	pi->first_constant = NULL;
	pi->last_constant = NULL;

	for(label = pi->first_variable; label;)
		{
		temp_label = label;
		label = label->next;
		free(temp_label->name);
		free(temp_label);
		}
	pi->first_variable = NULL;
	pi->last_variable = NULL;
	}


void print_msg(struct prog_info *pi, int type, char *fmt, ... )
	{
	va_list args;

	if(type == MSGTYPE_OUT_OF_MEM)
		fprintf(stderr, "Error: Unable to allocate memory!\n");
	else
		{
		va_start(args, fmt);
		fprintf(stderr, "%s: %d: ", pi->fi->include_file->name, pi->fi->line_number);
		if(pi->macro_call)
			fprintf(stderr, "[Macro: %s: %d:] ", pi->macro_call->macro->include_file->name, pi->macro_call->line_index + pi->macro_call->macro->first_line_number);
		switch(type)
			{
			case MSGTYPE_ERROR:
				pi->error_count++;
				fprintf(stderr, "Error: ");
				break;
			case MSGTYPE_WARNING:
				pi->warning_count++;
				fprintf(stderr, "Warning: ");
				break;
			case MSGTYPE_MESSAGE:
				break;
			}
		vfprintf(stderr, fmt, args);
		fprintf(stderr, "\n");
		va_end(args);
		}
	}




