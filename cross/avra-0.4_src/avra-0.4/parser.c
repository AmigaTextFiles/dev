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
#include "avra.h"

/*
 * Parses given assembler file
 */

int parse_file(struct prog_info *pi, char *filename, int pass)
	{
	int ok = True, loopok;
	struct file_info *fi;
	struct include_file *include_file;

	fi = malloc(sizeof(struct file_info));
	if(fi)
		{
		pi->fi = fi;
		if(pass == PASS_1)
			{
			include_file = malloc(sizeof(struct include_file));
			if(!include_file)
				{
				print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
				free(fi);
				return(False);
				}
			include_file->next = NULL;
			if(pi->last_include_file)
				{
				pi->last_include_file->next = include_file;
				include_file->num = pi->last_include_file->num + 1;
				}
			else
				{
				pi->first_include_file = include_file;
				include_file->num = 0;
				}
			pi->last_include_file = include_file;
			include_file->name = malloc(strlen(filename) + 1);
			if(!include_file->name)
				{
				print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
				free(fi);
				return(False);
				}
			strcpy(include_file->name, filename);
			}
		else
			{
			for(include_file = pi->first_include_file; include_file; include_file = include_file->next)
				if(!strcmp(include_file->name, filename))
					break;
			}
		if(!include_file)
			{
			print_msg(pi, MSGTYPE_ERROR, "Internal assembler error");
			free(fi);
			return(False);
			}
		fi->include_file = include_file;
		fi->line_number = 0;
		fi->exit_file = False;
		fi->fp = fopen(filename, "r");
		if(fi->fp)
			{
			loopok = True;
			while(loopok && !fi->exit_file)
				{
				if(fgets(fi->buff, LINEBUFFER_LENGTH, fi->fp))
					{
					fi->line_number++;
					pi->list_line = fi->buff;
					ok = parse_line(pi, fi->buff, pass);
					if(ok)
						{
						if((pass == PASS_2) && pi->list_line && pi->list_on)
							fprintf(pi->list_file, "         %s", pi->list_line);
						if(pi->error_count >= pi->max_errors)
							{
							print_msg(pi, MSGTYPE_MESSAGE, "Maximum error count reached. Exiting...");
							loopok = False;
							}
						}
					else
						loopok = False;
					}
				else
					{
					loopok = False;
					if(!feof(fi->fp))
						{
						ok = False;
						perror(filename);
						}
					}
				}
			fclose(fi->fp);
			}
		else
			{
			ok = False;
			perror(filename);
			}
		free(fi);
		}
	else
		{
		ok = False;
		print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
		}
	return(ok);
	}


/*
 * Parses one line
 */

int parse_line(struct prog_info *pi, char *line, int pass)
	{
	int ok, i, j, k, global_label = False;
	char temp[LINEBUFFER_LENGTH];
	struct label *label = NULL;
	struct macro_call *macro_call;

	/* Find out if there is any relevant code on the line. If not? return */
	i = 0;
	while(IS_HOR_SPACE(line[i]) && !IS_END(line[i])) i++;
	if(IS_END(line[i]))
		return(True);

	strcpy(temp, &line[i]);

	/* Calculate any expression inside a pair of {} */
	for(i = 0, j = 0; temp[j] != '\0'; i++, j++)
		{
		if(temp[j] == '{')
			{
			k = ++j;
			while((temp[j] != '\0') && (temp[j] != '}')) j++;
			if(IS_END(temp[j]))
				{
				print_msg(pi, MSGTYPE_ERROR, "Found no matching }");
				break;
				}
			else
				{
				temp[j] = '\0';
				if(!get_expr(pi, &temp[k], &k))
					return(False);
				sprintf(&pi->fi->scratch[i], "%d", k);
				i = strlen(pi->fi->scratch) - 1;
				}
			}
		else
			pi->fi->scratch[i] = temp[j];
		}

	/* Detect the global keyword for global labels */
	if(!nocase_strncmp(pi->fi->scratch, "global", 6) && IS_HOR_SPACE(pi->fi->scratch[6]))
		{
		global_label = True;
		i = 7;
		while(IS_HOR_SPACE(pi->fi->scratch[i]) && !IS_END(pi->fi->scratch[i])) i++;
		if(IS_END(pi->fi->scratch[i]))
			{
			print_msg(pi, MSGTYPE_ERROR, "Foung no label after global keyword");
			return(True);
			}
		strcpy(pi->fi->scratch, &pi->fi->scratch[i]);
		}

	for(i = 0; IS_LABEL(pi->fi->scratch[i]) || (pi->fi->scratch[i] == ':'); i++)
		if(pi->fi->scratch[i] == ':')
			{
			pi->fi->scratch[i] = '\0';
			if(pass == PASS_1)
				{
				for(macro_call = pi->macro_call; macro_call; macro_call = macro_call->prev_on_stack)
					{
					for(label = pi->macro_call->first_label; label; label = label->next)
						{
						if(!nocase_strcmp(label->name, &pi->fi->scratch[0]))
							{
							print_msg(pi, MSGTYPE_ERROR, "Can't redefine local label %s", &pi->fi->scratch[0]);
							break;
							}
						}
					}
				for(label = pi->first_label; label; label = label->next)
					{
					if(!nocase_strcmp(label->name, &pi->fi->scratch[0]))
						{
						print_msg(pi, MSGTYPE_ERROR, "Can't redefine label %s", &pi->fi->scratch[0]);
						break;
						}
					}
				for(label = pi->first_variable; label; label = label->next)
					if(!nocase_strcmp(label->name, &pi->fi->scratch[0]))
						{
						print_msg(pi, MSGTYPE_ERROR, "%s have already been defined as a .SET variable", &pi->fi->scratch[0]);
						break;
						}
				for(label = pi->first_constant; label; label = label->next)
					if(!nocase_strcmp(label->name, &pi->fi->scratch[0]))
						{
						print_msg(pi, MSGTYPE_ERROR, "%s have already been defined as a .EQU constant", &pi->fi->scratch[0]);
						break;
						}
				label = malloc(sizeof(struct label));
				if(!label)
					{
					print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
					return(False);
					}
				label->next = NULL;
				label->name = malloc(strlen(&pi->fi->scratch[0]) + 1);
				if(!label->name)
					{
					print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
					return(False);
					}
				strcpy(label->name, &pi->fi->scratch[0]);
				switch(pi->segment)
					{
					case SEGMENT_CODE:
						label->value = pi->cseg_addr;
						break;
					case SEGMENT_DATA:
						label->value = pi->dseg_addr;
						break;
					case SEGMENT_EEPROM:
						label->value = pi->eseg_addr;
						break;
					}
				if(pi->macro_call && !global_label)
					{
					if(pi->macro_call->last_label)
						pi->macro_call->last_label->next = label;
					else
						pi->macro_call->first_label = label;
					pi->macro_call->last_label = label;
					}
				else
					{
					if(pi->last_label)
						pi->last_label->next = label;
					else
						pi->first_label = label;
					pi->last_label = label;
					}
				}
			i++;
			while(IS_HOR_SPACE(pi->fi->scratch[i]) && !IS_END(pi->fi->scratch[i])) i++;
			if(IS_END(pi->fi->scratch[i]))
				{
				if((pass == PASS_2) && pi->list_on) // Diff tilpassing
					{
					fprintf(pi->list_file, "          %s", pi->list_line);
					pi->list_line = NULL;
					}
				return(True);
				}
			strcpy(pi->fi->scratch, &pi->fi->scratch[i]);
			break;
			}

	if(pi->fi->scratch[0] == '.')
		{
		pi->fi->label = label;
		ok = parse_directive(pi, pass);
		if((pass == PASS_2) && pi->list_on && pi->list_line) // Diff tilpassing
			{
			fprintf(pi->list_file, "          %s", pi->list_line);
			pi->list_line = NULL;
			}
		return(ok);
		}
	else
		{
		ok = parse_mnemonic(pi, pass);
		return(ok);
		}
	}


/*
 * Get the next token, and terminate the last one
 * Termination identifier is specified
 */

char *get_next_token(char *data, int term)
	{
	int i = 0, j, anti_comma = False;

	switch(term)
		{
		case TERM_END:
			while(!IS_END(data[i])) i++;
			break;
		case TERM_SPACE:
			while(!IS_HOR_SPACE(data[i]) && !IS_END(data[i])) i++;
			break;
		case TERM_COMMA:
			while(((data[i] != ',') || anti_comma)
			      && !(((data[i] == ';') && !anti_comma) || (data[i] == 10) || (data[i] == 13)|| (data[i] == '\0')))
				{
				if((data[i] == '\'') || (data[i] == '"'))
					anti_comma = anti_comma ? False : True;
				i++;
				}
			break;
		case TERM_EQUAL:
			while((data[i] != '=') && !IS_END(data[i])) i++;
			break;
		}
	if(IS_END(data[i]))
		{
		data[i--] = '\0';
		while(IS_HOR_SPACE(data[i])) data[i--] = '\0';
		return(0);
		}
	j = i - 1;
	while(IS_HOR_SPACE(data[j])) data[j--] = '\0';
	data[i++] = '\0';
	while(IS_HOR_SPACE(data[i]) && !IS_END(data[i])) i++;
	if(IS_END(data[i]))
		return(0);
	return(&data[i]);
	}

