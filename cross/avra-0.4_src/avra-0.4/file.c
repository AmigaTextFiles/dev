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
#include <time.h>

#include "misc.h"
#include "avra.h"


int open_out_files(struct prog_info *pi, char *filename)
	{
	int length;
	char *buff;
	time_t tp;

	length = strlen(filename);
	buff = malloc(length + 9);
	if(buff)
		{
		strcpy(buff, filename);
		if(length >= 4)
			if(!nocase_strcmp(&buff[length - 4], ".asm"))
				{
				length -= 4;
				buff[length] = '\0';
				}
		strcpy(&buff[length], ".list");
		pi->list_file = fopen(buff, "w");
		if(pi->cseg_count)
			{
			strcpy(&buff[length], ".hex");
			pi->hfi = open_hex_file(buff);
			strcpy(&buff[length], ".obj");
			pi->obj_file = open_obj_file(pi, buff);
			}
		if(pi->eseg_count)
			{
			strcpy(&buff[length], ".eep.hex");
			pi->eep_hfi = open_hex_file(buff);
			}
		free(buff);
		if(pi->list_file && pi->obj_file && (!pi->cseg_count || pi->hfi) && (!pi->eseg_count || pi->eep_hfi))
			{
			if(time(&tp) != -1)
				fprintf(pi->list_file, "\navra   ver. %d.%d  %s %s\n\n", VERSION, REVISION, filename, ctime(&tp));
			return(True);
			}
		else
			close_out_files(pi);
		}
	else
		print_msg(pi, MSGTYPE_OUT_OF_MEM, NULL);
	return(False);
	}


void close_out_files(struct prog_info *pi)
	{
	if(pi->hfi) close_hex_file(pi->hfi);
	if(pi->eep_hfi) close_hex_file(pi->eep_hfi);
	if(pi->list_file)
		{
		if(pi->error_count == 0)
			fprintf(pi->list_file, "\nAssembly complete with no errors.\n");
		fclose(pi->list_file);
		}
	if(pi->obj_file) close_obj_file(pi, pi->obj_file);
	}


struct hex_file_info *open_hex_file(char *filename)
	{
	struct hex_file_info *hfi;

	hfi = calloc(1, sizeof(struct hex_file_info));
	if(hfi)
		{
		hfi->fp = fopen(filename, "wb");
		if(!hfi->fp)
			{
			close_hex_file(hfi);
			hfi = NULL;
			}
		}
	return(hfi);
	}


void close_hex_file(struct hex_file_info *hfi)
	{
	int i;
	unsigned char checksum = 0;

	if(hfi->fp)
		{
		if(hfi->count != 0)
			{
			fprintf(hfi->fp, ":%02X%04X00", hfi->count, hfi->linestart_addr);
			checksum -= hfi->count + ((hfi->linestart_addr >> 8) & 0xff) + (hfi->linestart_addr & 0xff);
			for(i = 0; i < hfi->count; i++)
				{
				fprintf(hfi->fp, "%02X", hfi->hex_line[i]);
				checksum -= hfi->hex_line[i];
				}
			fprintf(hfi->fp, "%02X\x0d\x0a", checksum);
			}
		fprintf(hfi->fp, ":00000001FF\x0d\x0a");		fclose(hfi->fp);
		}
	free(hfi);
	}


void write_ee_byte(struct prog_info *pi, int address, unsigned char data)
	{
	if((pi->eep_hfi->count == 16) || ((address != (pi->eep_hfi->linestart_addr + pi->eep_hfi->count)) && (pi->eep_hfi->count != 0)))
		do_hex_line(pi->eep_hfi);
	if(pi->eep_hfi->count == 0)
		pi->eep_hfi->linestart_addr = address;
	pi->eep_hfi->hex_line[pi->eep_hfi->count++] = data;
	}


void write_prog_word(struct prog_info *pi, int address, int data)
	{
	write_obj_record(pi, address, data);
	address *= 2;
	if((pi->hfi->count == 16) || ((address != (pi->hfi->linestart_addr + pi->hfi->count)) && (pi->hfi->count != 0)))
		do_hex_line(pi->hfi);
	if(pi->hfi->count == 0)
		pi->hfi->linestart_addr = address;
	pi->hfi->hex_line[pi->hfi->count++] = data & 0xff;
	pi->hfi->hex_line[pi->hfi->count++] = (data >> 8) & 0xff;
	}


void do_hex_line(struct hex_file_info *hfi)
	{
	int i;
	unsigned char checksum = 0;

	fprintf(hfi->fp, ":%02X%04X00", hfi->count, hfi->linestart_addr);
	checksum -= hfi->count + ((hfi->linestart_addr >> 8) & 0xff) + (hfi->linestart_addr & 0xff);
	for(i = 0; i < hfi->count; i++)
		{
		fprintf(hfi->fp, "%02X", hfi->hex_line[i]);
		checksum -= hfi->hex_line[i];
		}
	fprintf(hfi->fp, "%02X\x0d\x0a", checksum);
	hfi->count = 0;
	}


FILE *open_obj_file(struct prog_info *pi, char *filename)
	{
	int i;
	FILE *fp;
	struct include_file *include_file;

	fp = fopen(filename, "wb");
	if(fp)
		{
		i = pi->cseg_count * 9 + 26;
		fputc((i >> 24) & 0xff, fp);
		fputc((i >> 16) & 0xff, fp);
		fputc((i >> 8) & 0xff, fp);
		fputc(i & 0xff, fp);
		i = 26;
		fputc((i >> 24) & 0xff, fp);
		fputc((i >> 16) & 0xff, fp);
		fputc((i >> 8) & 0xff, fp);
		fputc(i & 0xff, fp);
		fputc(9, fp);
		i = 0;
		for(include_file = pi->first_include_file; include_file; include_file = include_file->next)
			i++;
		fputc(i, fp);
		fprintf(fp, "AVR Object File");
		fputc('\0', fp);
		}
	return(fp);
	}


void close_obj_file(struct prog_info *pi, FILE *fp)
	{
	struct include_file *include_file;

	for(include_file = pi->first_include_file; include_file; include_file = include_file->next)
		{
		fprintf(fp, "%s", include_file->name);
		fputc('\0', fp);
		}
	fputc('\0', fp);
	fclose(fp);
	}


void write_obj_record(struct prog_info *pi, int address, int data)
	{
	fputc((address >> 16) & 0xff, pi->obj_file);
	fputc((address >> 8) & 0xff, pi->obj_file);
	fputc(address & 0xff, pi->obj_file);
	fputc((data >> 8) & 0xff, pi->obj_file);
	fputc(data & 0xff, pi->obj_file);
	fputc(pi->fi->include_file->num & 0xff, pi->obj_file);
	fputc((pi->fi->line_number >> 8) & 0xff, pi->obj_file);
	fputc(pi->fi->line_number & 0xff, pi->obj_file);
	if(pi->macro_call)
		fputc(1, pi->obj_file);
	else
		fputc(0, pi->obj_file);
	}





