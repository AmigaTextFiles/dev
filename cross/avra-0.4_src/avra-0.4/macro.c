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
#include <string.h>
#include <ctype.h>

#include "misc.h"
#include "args.h"
#include "avra.h"

int read_macro(struct prog_info *pi, char *name, int pass)
	{
	int loopok, i;
	struct macro *macro;
	struct macro_line *macro_line, **last_macro_line;

	if(pass == PASS_1)
		{
		if(!name)
			{
			print_msg(pi, MSGTYPE_ERROR, "Missing macro name");
			return(True);
			}
		get_next_token(name, TERM_END);
		// TODO: Sjekk om navnet er gyldig. Bare isalnum() og '_'
		macro = calloc(1, sizeof(struct macro));
		if(!macro)
			{
			print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
			return(False);
			}
		if(pi->last_macro)
			pi->last_macro->next = macro;
		else
			pi->first_macro = macro;
		pi->last_macro = macro;
		macro->name = malloc(strlen(name) + 1);
		if(!macro->name)
			{
			print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
			return(False);
			}
		strcpy(macro->name, name);
		macro->include_file = pi->fi->include_file;
		macro->first_line_number = pi->fi->line_number;
		last_macro_line = &macro->first_macro_line;
		}
	else if(pi->list_line && pi->list_on) /* pass == PASS_2 */
		{
		fprintf(pi->list_file, "          %s", pi->list_line);
		pi->list_line = NULL;
		}
	loopok = True;
	while(loopok)
		{
		if(fgets(pi->fi->buff, LINEBUFFER_LENGTH, pi->fi->fp))
			{
			pi->fi->line_number++;
			i = 0;
			while(IS_HOR_SPACE(pi->fi->buff[i]) && !IS_END(pi->fi->buff[i])) i++;
			if(pi->fi->buff[i] == '.')
				{
				i++;
				if(!nocase_strncmp(&pi->fi->buff[i], "endm", 4)) // TODO: Vurder å sjekke navnet bedre
					loopok = False;
				}
			if(pass == PASS_1)
				{
				if(loopok)
					{
					macro_line = calloc(1, sizeof(struct macro_line));
					if(!macro_line)
						{
						print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
						return(False);
						}
					*last_macro_line = macro_line;
					last_macro_line = &macro_line->next;
					macro_line->line = malloc(strlen(pi->fi->buff) + 1);
					if(!macro_line->line)
						{
						print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
						return(False);
						}
					strcpy(macro_line->line, pi->fi->buff);
					}
				}
			else if(pi->fi->buff && pi->list_file)
				{
				if(pi->fi->buff[i] == ';')
					fprintf(pi->list_file, "         %s", pi->fi->buff);
				else
					fprintf(pi->list_file, "          %s", pi->fi->buff);
				}
			}
		else
			{
			if(feof(pi->fi->fp))
				{
				print_msg(pi, MSGTYPE_ERROR, "Found no closing .ENDMACRO");
				return(True);
				}
			else
				{
				perror(pi->fi->include_file->name);
				return(False);
				}
			}
		}
	return(True);
	}


struct macro *get_macro(struct prog_info *pi, char *name)
	{
	struct macro *macro;

	for(macro = pi->first_macro; macro; macro = macro->next)	
		if(!nocase_strcmp(macro->name, name))
			return(macro);
	return(NULL);
	}


int expand_macro(struct prog_info *pi, struct macro *macro, char *rest_line, int pass)
	{
	int ok = True, macro_arg_count = 0, i, j;
	char *line, *temp, *macro_args[10];
	char buff[LINEBUFFER_LENGTH];
	struct macro_line *old_macro_line;
	struct macro_call *macro_call;

	if(rest_line)
		{
		line = malloc(strlen(rest_line) + 1);
		if(!line)
			{
			print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
			return(False);
			}
		strcpy(line, rest_line);
		temp = line;
		while(temp)
			{
			macro_args[macro_arg_count++] = temp;
			temp = get_next_token(temp, TERM_COMMA);
			}
		}

	if(pass == PASS_1)
		{
		macro_call = calloc(1, sizeof(struct macro_call));
		if(!macro_call)
			{
			print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
			return(False);
			}
		if(pi->last_macro_call)
			pi->last_macro_call->next = macro_call;
		else
			pi->first_macro_call = macro_call;
		pi->last_macro_call = macro_call;
		macro_call->line_number = pi->fi->line_number;
		macro_call->include_file = pi->fi->include_file;
		macro_call->macro = macro;
		macro_call->prev_on_stack = pi->macro_call;
		if(macro_call->prev_on_stack)
			{
			macro_call->nest_level = macro_call->prev_on_stack->nest_level + 1;
			macro_call->prev_line_index = macro_call->prev_on_stack->line_index;
			}
		}
	else
		{
		for(macro_call = pi->first_macro_call; macro_call; macro_call = macro_call->next)
			{
			if((macro_call->include_file->num == pi->fi->include_file->num)
			   && (macro_call->line_number == pi->fi->line_number))
				{
				if(pi->macro_call)
					{
					/* Find correct macro_call when using recursion and nesting */
					if(macro_call->prev_on_stack == pi->macro_call)
						if((macro_call->nest_level == (pi->macro_call->nest_level + 1))
						   && (macro_call->prev_line_index == pi->macro_call->line_index))
							break;
					}
				else
					break;
				}
			}
		if(pi->list_line && pi->list_on)
			{
			fprintf(pi->list_file, "%06x   +  %s", pi->cseg_addr, pi->list_line);
			pi->list_line = NULL;
			}
		}
	macro_call->line_index = 0;
	pi->macro_call = macro_call;
	old_macro_line = pi->macro_line;
	for(pi->macro_line = macro->first_macro_line; pi->macro_line && ok; pi->macro_line = pi->macro_line->next)
		{
		macro_call->line_index++;
		if(GET_ARG(pi->args, ARG_LISTMAC))
			pi->list_line = buff;
		else
			pi->list_line = NULL;
		for(i = 0, j = 0; pi->macro_line->line[i] != '\0'; i++)
			{
			if(pi->macro_line->line[i] == '@')
				{
				i++;
				if(!isdigit(pi->macro_line->line[i]))
					print_msg(pi, MSGTYPE_ERROR, "@ must be followed by a number");
				else if((pi->macro_line->line[i] - '0') >= macro_arg_count)
					print_msg(pi, MSGTYPE_ERROR, "Missing macro argument (for @%c)", pi->macro_line->line[i]);
				else
					{
					strcpy(&buff[j], macro_args[pi->macro_line->line[i] - '0']);
					j += strlen(macro_args[pi->macro_line->line[i] - '0']);
					}
				}
			else
				buff[j++] = pi->macro_line->line[i];
			}
		buff[j] = '\0';
		ok = parse_line(pi, buff, pass);
		if(ok)
			{
			if((pass == PASS_2) && pi->list_line && pi->list_on)
				fprintf(pi->list_file, "         %s", pi->list_line);
			if(pi->error_count >= pi->max_errors)
				{
				print_msg(pi, MSGTYPE_MESSAGE, "Maximum error count reached. Exiting...");
				break;
				}
			}
		}
	pi->macro_line = old_macro_line;
	pi->macro_call = macro_call->prev_on_stack;
	if(rest_line)
	        free(line);
	return(ok);
	}
