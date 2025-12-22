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
#include "device.h"

enum
	{
	DIRECTIVE_BYTE = 0,
	DIRECTIVE_CSEG,
	DIRECTIVE_DB,
	DIRECTIVE_DEF,
	DIRECTIVE_DEVICE,
	DIRECTIVE_DSEG,
	DIRECTIVE_DW,
	DIRECTIVE_ENDM,
	DIRECTIVE_ENDMACRO,
	DIRECTIVE_EQU,
	DIRECTIVE_ESEG,
	DIRECTIVE_EXIT,
	DIRECTIVE_INCLUDE,
	DIRECTIVE_LIST,
	DIRECTIVE_LISTMAC,
	DIRECTIVE_MACRO,
	DIRECTIVE_NOLIST,
	DIRECTIVE_ORG,
	DIRECTIVE_SET,
	DIRECTIVE_DEFINE,
	DIRECTIVE_UNDEF,
	DIRECTIVE_IFDEF,
	DIRECTIVE_IFNDEF,
	DIRECTIVE_IF,
	DIRECTIVE_ELSE,
	DIRECTIVE_ELIF,
	DIRECTIVE_ENDIF,
	DIRECTIVE_MESSAGE,
	DIRECTIVE_WARNING,
	DIRECTIVE_ERROR,
	DIRECTIVE_COUNT
	};

char *directive_list[] =
	{
	"BYTE",
	"CSEG",
	"DB",
	"DEF",
	"DEVICE",
	"DSEG",
	"DW",
	"ENDM",
	"ENDMACRO",
	"EQU",
	"ESEG",
	"EXIT",
	"INCLUDE",
	"LIST",
	"LISTMAC",
	"MACRO",
	"NOLIST",
	"ORG",
	"SET",
	"DEFINE",
	"UNDEF",
	"IFDEF",
	"IFNDEF",
	"IF",
	"ELSE",
	"ELIF",
	"ENDIF",
	"MESSAGE",
	"WARNING",
	"ERROR"
	};


int parse_directive(struct prog_info *pi, int pass)
	{
	int directive, ok = True, i;
	char *next, *data;
	struct file_info *fi_bak;
	struct label *label;
	struct def *def;

	next = get_next_token(pi->fi->scratch, TERM_SPACE);
	for(i = 0; pi->fi->scratch[i] != '\0'; i++)
		pi->fi->scratch[i] = toupper(pi->fi->scratch[i]);
	directive = get_directive_type(pi->fi->scratch + 1);
	if(directive == -1)
		{
		print_msg(pi, MSGTYPE_ERROR, "Unknown directive: %s", pi->fi->scratch);
		return(True);
		}
	switch(directive)
		{
		case DIRECTIVE_BYTE:
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, ".BYTE needs an operand");
				return(True);
				}
			if(pi->segment != SEGMENT_DATA)
				print_msg(pi, MSGTYPE_ERROR, ".BYTE directive can only be used in data segment (.DSEG)");
			get_next_token(next, TERM_END);
			if(!get_expr(pi, next, &i))
				return(False);
			if((pass == PASS_2) && pi->list_line && pi->list_on)
				{
				fprintf(pi->list_file, "%06x      %s", pi->dseg_addr, pi->list_line);
				pi->list_line = NULL;
				}
			pi->dseg_addr += i;
			if(pass == PASS_1)
				pi->dseg_count++;
			break;
		case DIRECTIVE_CSEG:
			pi->segment = SEGMENT_CODE;
			break;
		case DIRECTIVE_DB:
			return(parse_db(pi, next, pass));
			break;
		case DIRECTIVE_DEF:
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, ".DEF needs an operand");
				return(True);
				}
			data = get_next_token(next, TERM_EQUAL);
			if(!(data && (tolower(data[0]) == 'r') && isdigit(data[1])))
				{
				print_msg(pi, MSGTYPE_ERROR, "%s needs a register (e.g. .def BZZZT = r16)", next);
				return(True);
				}
			i = atoi(&data[1]);
			if(i > 31)
				print_msg(pi, MSGTYPE_ERROR, "R%d is not a valid register", i);
			for(def = pi->first_def; def; def = def->next)
				if(!nocase_strcmp(def->name, next))
					{
					def->reg = i;
					return(True);
					}
			def = malloc(sizeof(struct def));
			if(!def)
				{
				print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
				return(False);
				}
			def->next = NULL;
			if(pi->last_def)
				pi->last_def->next = def;
			else
				pi->first_def = def;
			pi->last_def = def;
			def->name = malloc(strlen(next) + 1);
			if(!def->name)
				{
				print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
				return(False);
				}
			strcpy(def->name, next);
			def->reg = i;
			break;
		case DIRECTIVE_DEVICE:
			if(pass == PASS_2)
				return(True);
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, ".DEVICE needs an operand");
				return(True);
				}
			get_next_token(next, TERM_END);
			pi->device = get_device(next);
			if(!pi->device)
				print_msg(pi, MSGTYPE_ERROR, "Unknown device: %s", next);
			break;
		case DIRECTIVE_DSEG:
			pi->segment = SEGMENT_DATA;
			break;
		case DIRECTIVE_DW:
			if(pi->segment == SEGMENT_DATA)
				{
				print_msg(pi, MSGTYPE_ERROR, "Can't use .DW directive in data segment (.DSEG)");
				return(True);
				}
			while(next)
				{
				data = get_next_token(next, TERM_COMMA);
				if(!get_expr(pi, next, &i))
					return(False);
				if((i < -32768) || (i > 65535))
					print_msg(pi, MSGTYPE_ERROR, "Value %d is out of range (-32768 <= k <= 65535)", i);
				if(pi->segment == SEGMENT_EEPROM)
					{
					if(pass == PASS_2)
						{
						write_ee_byte(pi, pi->eseg_addr, (unsigned char)i);
						write_ee_byte(pi, pi->eseg_addr + 1, (unsigned char)(i >> 8));
						}
					pi->eseg_addr += 2;
					if(pass == PASS_1)
						pi->eseg_count += 2;
					}
				else
					{
					if((pass == PASS_2) && pi->hfi)
						write_prog_word(pi, pi->cseg_addr, i);
					pi->cseg_addr++;
					if(pass == PASS_1)
						pi->cseg_count++;
					}
				next = data;
				}
			break;
		case DIRECTIVE_ENDM:
		case DIRECTIVE_ENDMACRO:
			print_msg(pi, MSGTYPE_ERROR, "No .MACRO found before .ENDMACRO");
			break;
		case DIRECTIVE_EQU:
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, ".EQU needs an operand");
				return(True);
				}
			data = get_next_token(next, TERM_EQUAL);
			if(!data)
				{
				print_msg(pi, MSGTYPE_ERROR, "%s needs an expression (e.g. .EQU BZZZT = 0x2a)", next);
				return(True);
				}
			get_next_token(data, TERM_END);
			if(!get_expr(pi, data, &i))
				return(False);
			for(label = pi->first_label; label; label = label->next)
				{
				if(!nocase_strcmp(label->name, next))
					{
					print_msg(pi, MSGTYPE_ERROR, "%s have already been defined as a label", next);
					return(True);
					}
				}
			for(label = pi->first_variable; label; label = label->next)
				if(!nocase_strcmp(label->name, next))
					{
					print_msg(pi, MSGTYPE_ERROR, "%s have already been defined as a .SET variable", next);
					return(True);
					}
			for(label = pi->first_constant; label; label = label->next)
				if(!nocase_strcmp(label->name, next))
					{
					print_msg(pi, MSGTYPE_ERROR, "Can't redefine constant %s, use .SET instead", next);
					return(True);
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
			label->name = malloc(strlen(next) + 1);
			if(!label->name)
				{
				print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
				return(False);
				}
			strcpy(label->name, next);
			label->value = i;
			break;
		case DIRECTIVE_ESEG:
			pi->segment = SEGMENT_EEPROM;
			break;
		case DIRECTIVE_EXIT:
			pi->fi->exit_file = True;
			break;
		case DIRECTIVE_INCLUDE:
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, "Nothing to include");
				return(True);
				}
			next = term_string(pi, next);
			if((pass == PASS_2) && pi->list_line && pi->list_on)
				{
				fprintf(pi->list_file, "          %s", pi->list_line);
				pi->list_line = NULL;
				}
			fi_bak = pi->fi;
			ok = parse_file(pi, next, pass);
			pi->fi = fi_bak;
			break;
		case DIRECTIVE_LIST:
			if(pass == PASS_2)
				pi->list_on = True;
			break;
		case DIRECTIVE_LISTMAC:
			if(pass == PASS_2)
				SET_ARG(pi->args, ARG_LISTMAC, True);
			break;
		case DIRECTIVE_MACRO:
			return(read_macro(pi, next, pass));
			break;
		case DIRECTIVE_NOLIST:
			if(pass == PASS_2)
				pi->list_on = False;
			break;
		case DIRECTIVE_ORG:
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, ".ORG needs an operand");
				return(True);
				}
			get_next_token(next, TERM_END);
			if(!get_expr(pi, next, &i))
				return(False);
			switch(pi->segment)
				{
				case SEGMENT_CODE:
					pi->cseg_addr = i;
					break;
				case SEGMENT_DATA:
					pi->dseg_addr = i;
					break;
				case SEGMENT_EEPROM:
					pi->eseg_addr = i;
				}
			if(pi->fi->label)
				pi->fi->label->value = i;
			break;
		case DIRECTIVE_SET:
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, ".SET needs an operand");
				return(True);
				}
			data = get_next_token(next, TERM_EQUAL);
			if(!data)
				{
				print_msg(pi, MSGTYPE_ERROR, "%s needs an expression (e.g. .SET BZZZT = 0x2a)", next);
				return(True);
				}
			get_next_token(data, TERM_END);
			if(!get_expr(pi, data, &i))
				return(False);
			for(label = pi->first_label; label; label = label->next)
				if(!nocase_strcmp(label->name, next))
					{
					print_msg(pi, MSGTYPE_ERROR, "%s have already been defined as a label", next);
					return(True);
					}
			for(label = pi->first_constant; label; label = label->next)
				if(!nocase_strcmp(label->name, next))
					{
					print_msg(pi, MSGTYPE_ERROR, "%s have already been defined as a .EQU constant", next);
					return(True);
					}
			for(label = pi->first_variable; label; label = label->next)
				if(!nocase_strcmp(label->name, next))
					{
					label->value = i;
					return(True);
					}
			label = malloc(sizeof(struct label));
			if(!label)
				{
				print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
				return(False);
				}
			label->next = NULL;
			if(pi->last_variable)
				pi->last_variable->next = label;
			else
				pi->first_variable = label;
			pi->last_variable = label;
			label->name = malloc(strlen(next) + 1);
			if(!label->name)
				{
				print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
				return(False);
				}
			strcpy(label->name, next);
			label->value = i;
			break;
		case DIRECTIVE_DEFINE:
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, ".DEFINE needs an operand");
				return(True);
				}
			data = get_next_token(next, TERM_SPACE);
			if(data)
				{
				get_next_token(data, TERM_END);
				if(!get_expr(pi, data, &i))
				        return(False);
				}
			else
				i = 1;
			for(label = pi->first_label; label; label = label->next)
				if(!nocase_strcmp(label->name, next))
					{
					print_msg(pi, MSGTYPE_ERROR, "%s have already been defined as a label", next);
					return(True);
					}
			for(label = pi->first_variable; label; label = label->next)
				if(!nocase_strcmp(label->name, next))
					{
					print_msg(pi, MSGTYPE_ERROR, "%s have already been defined as a .SET variable", next);
					return(True);
					}
			for(label = pi->first_constant; label; label = label->next)
				if(!nocase_strcmp(label->name, next))
					{
					print_msg(pi, MSGTYPE_ERROR, "Can't redefine constant %s, use .SET instead", next);
					return(True);
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
			label->name = malloc(strlen(next) + 1);
			if(!label->name)
				{
				print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
				return(False);
				}
			strcpy(label->name, next);
			label->value = i;
			break;
		case DIRECTIVE_UNDEF: // TODO
			break;
		case DIRECTIVE_IFDEF:
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, ".IFDEF needs an operand");
				return(True);
				}
			get_next_token(next, TERM_END);
			if(get_symbol(pi, next, NULL))
				pi->conditional_depth++;
			else
			        {
				if(!spool_conditional(pi, False))
				        return(False);
				}
			break;
		case DIRECTIVE_IFNDEF:
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, ".IFNDEF needs an operand");
				return(True);
				}
			get_next_token(next, TERM_END);
			if(get_symbol(pi, next, NULL))
			        {
				if(!spool_conditional(pi, False))
				        return(False);
				}
			else
				pi->conditional_depth++;
			break;
		case DIRECTIVE_IF:
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, ".IF needs an expression");
				return(True);
				}
			get_next_token(next, TERM_END);
			if(!get_expr(pi, next, &i))
			        return(False);
			if(i)
				pi->conditional_depth++;
			else
			        {
				if(!spool_conditional(pi, False))
				        return(False);
				}
			break;
		case DIRECTIVE_ELSE:
		case DIRECTIVE_ELIF:
		        if(!spool_conditional(pi, True))
			        return(False);
			break;
		case DIRECTIVE_ENDIF:
		        if(pi->conditional_depth == 0)
			        print_msg(pi, MSGTYPE_ERROR, "Too many .ENDIF");
			else
			        pi->conditional_depth--;
			break;
		case DIRECTIVE_MESSAGE:
			if(pass == PASS_1)
				return(True);
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, "No message string supplied");
				return(True);
				}
			next = term_string(pi, next);
			print_msg(pi, MSGTYPE_MESSAGE, next);
			break;
		case DIRECTIVE_WARNING:
			if(pass == PASS_1)
				return(True);
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, "No warning string supplied");
				return(True);
				}
			next = term_string(pi, next);
			print_msg(pi, MSGTYPE_WARNING, next);
			break;
		case DIRECTIVE_ERROR:
			if(pass == PASS_1)
				return(True);
			if(!next)
				{
				print_msg(pi, MSGTYPE_ERROR, "No error string supplied");
				return(True);
				}
			next = term_string(pi, next);
			print_msg(pi, MSGTYPE_ERROR, next);
			break;
		}
	return(ok);
	}


int get_directive_type(char *directive)
	{
	int i;

	for(i = 0; i < DIRECTIVE_COUNT; i++)
		if(!strcmp(directive, directive_list[i])) return(i);
	return(-1);
	}


char *term_string(struct prog_info *pi, char *string)
	{
	int i;

	if(string[0] != '\"') 
		print_msg(pi, MSGTYPE_ERROR, "String must be enclosed in \"-signs");
	else
		string++;
	for(i = 0; (string[i] != '\"') && !((string[i] == 10) || (string[i] == 13) || (string[i] == '\0')); i++);
	if((string[i] == 10) || (string[i] == 13) || (string[i] == '\0'))
		print_msg(pi, MSGTYPE_ERROR, "String is missing a closing \"-sign");
	string[i] = '\0';
	return(string);
	}


int parse_db(struct prog_info *pi, char *next, int pass)
	{
	int i, count;
	char *data, prev;

	if(pi->segment == SEGMENT_DATA)
		{
		print_msg(pi, MSGTYPE_ERROR, "Can't use .DB directive in data segment (.DSEG)");
		return(True);
		}
	count = 0;
	while(next)
		{
		data = get_next_token(next, TERM_COMMA);
		if(next[0] == '\"')
			{
			next = term_string(pi, next);
			while(*next != '\0')
				{
				count++;
				write_db(pi, *next, &prev, count, pass);
				next++;
				}
			}
		else
			{
			if(!get_expr(pi, next, &i))
				return(False);
			if((i < -128) || (i > 255))
				print_msg(pi, MSGTYPE_ERROR, "Value %d is out of range (-128 <= k <= 255)", i);
			count++;
			write_db(pi, (char)i, &prev, count, pass);
			}
		next = data;
		}
	if(pi->segment == SEGMENT_CODE)
		{
		if((count % 2) == 1)
			{
			if(pass == PASS_2)
				write_prog_word(pi, pi->cseg_addr, prev & 0xff);
			pi->cseg_addr++;
			if(pass == PASS_1)
				pi->cseg_count++;
			}
		}
	return(True);
	}


void write_db(struct prog_info *pi, char byte, char *prev, int count, int pass)
	{
	if(pi->segment == SEGMENT_EEPROM)
		{
		if(pass == PASS_2)
			write_ee_byte(pi, pi->eseg_addr, byte);
		pi->eseg_addr++;
		if(pass == PASS_1)
			pi->eseg_count++;
		}
	else /* pi->segment == SEGMENT_CODE */
		{
		if((count % 2) == 0)
			{
			if(pass == PASS_2)
				write_prog_word(pi, pi->cseg_addr, (byte << 8) | (*prev & 0xff));
			pi->cseg_addr++;
			if(pass == PASS_1)
				pi->cseg_count++;
			}
		else
			*prev = byte;
		}
	}


int spool_conditional(struct prog_info *pi, int only_endif)
	{
	int current_depth = 0, do_next;

	if(pi->macro_line)
		{
		while((pi->macro_line = pi->macro_line->next))
			{
			pi->macro_call->line_index++;
			if(check_conditional(pi, pi->macro_line->line, &current_depth,  &do_next, only_endif))
				{
				if(!do_next)
					return(True);
				}
			else
				return(False);
			}
		print_msg(pi, MSGTYPE_ERROR, "Found no closing .ENDIF in macro");
		}
	else
		{
		while(fgets(pi->fi->buff, LINEBUFFER_LENGTH, pi->fi->fp))
			{
			pi->fi->line_number++;
			if(check_conditional(pi, pi->fi->buff, &current_depth,  &do_next, only_endif))
				{
				if(!do_next)
					return(True);
				}
			else
				return(False);
			}
		if(feof(pi->fi->fp))
			{
			print_msg(pi, MSGTYPE_ERROR, "Found no closing .ENDIF");
			return(True);
			}
		else
			{
			perror(pi->fi->include_file->name);
			return(False);
			}
		}
	return(True);
	}


int check_conditional(struct prog_info *pi, char *buff, int *current_depth, int *do_next, int only_endif)
	{
	int i = 0;
	char *next;

	*do_next = False;
	while(IS_HOR_SPACE(buff[i]) && !IS_END(buff[i])) i++;
	if(buff[i] == '.')
		{
		i++;
		if(!nocase_strncmp(&buff[i], "if", 2))
			(*current_depth)++;
		else if(!nocase_strncmp(&buff[i], "endif", 5))
		        {
			if(*current_depth == 0)
			        return(True);
			(*current_depth)--;
			}
		else if(!only_endif && (*current_depth == 0))
		        {
			if(!nocase_strncmp(&buff[i], "else", 4))
			        {
				pi->conditional_depth++;
			        return(True);
				}
			else if(!nocase_strncmp(&buff[i], "elif", 4))
			        {
				next = get_next_token(&buff[i], TERM_SPACE);
				if(!next)
				        {
					print_msg(pi, MSGTYPE_ERROR, ".ELIF needs an operand");
					return(True);
					}
				get_next_token(next, TERM_END);
				if(!get_expr(pi, next, &i))
				        return(False);
				if(i)
				        pi->conditional_depth++;
				else
				        {
				        if(!spool_conditional(pi, False))
					        return(False);
					}
				return(True);
				}
			}
		}
	*do_next = True;
	return(True);
	}
