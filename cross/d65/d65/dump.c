/*\
 *  d65 v0.2.0 -- symbolic 65xx disassembler
 *
 *  Copyright (C) 1993, 1994 Marko M\"akel\"a
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
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Contacting the author:
 *
 *   Via Internet E-mail:
 *      <Marko.Makela@FTP.FUNET.FI>
 *
 *   Via Snail Mail:
 *      Marko M\"akel\"a
 *      Sillitie 10 A
 *      FIN-01480 VANTAA
 *      Finland
\*/

#define _DUMP_C_
#include <stdio.h>
#include <stdlib.h>

#include "proto.h"
#include "options.h"
#include "opcodes.h"

#ifndef __STDC__
void
Dump ()
#else
void Dump (void)
#endif
{
  ADDR_T address, addr;
  unsigned counter, size, maxwidth;
  char *lineprefix, *lineinfix;
  table *entry;
  opcodes *instr;

  if (fVerbose)
    fprintf (stderr, "%s: Dumping the source code.\n", prog);

  /* determine the maximum amount of bytes dumped per line */

  maxwidth = listwidth < 2 ? 2 : listwidth;

  for (counter = 0; counter < 256; counter++)
    if (maxwidth < sizes[opset[counter].admode])
      maxwidth = sizes[opset[counter].admode];

  /* create prefix string for lines without address information */
  switch (Options & M_ADDRESSES) {
  case O_ADR_ADRPFIX:
    counter = 5;
    break;

  case O_ADR_ADR_DMP:
    counter = 5 + 3 * maxwidth;
    break;

  default:
    counter = 0;
  }

  lineprefix = malloc (counter + 1);

  if (counter >= 5) {
    lineinfix = lineprefix + 5;

    for (lineprefix[counter] = 0; counter--; lineprefix[counter] = ' ');
  }
  else {
    *lineprefix = 0;
    lineinfix = lineprefix;
  }

  /* print the label definitions */

  for (address = EndAddress < StartAddress ? EndAddress : 0;
       address != StartAddress; address++)
    if (IsLabeled (address))
      fprintf (stdout, "%s%s = $%X\n", lineprefix, Label (address), address);

  if (EndAddress >= StartAddress)
    for (address = EndAddress; address; address++)
      if (IsLabeled (address))
        fprintf (stdout, "%s%s = $%X\n", lineprefix, Label (address), address);

  /* dump the program */

  fprintf (stdout, "%s.ORG $%X\n", lineprefix, StartAddress);

  for (address = StartAddress; (ADDR_T)(address - StartAddress) <
       (ADDR_T)(EndAddress - StartAddress); address += size)
    if (GetMemType (address) == MEM_INSTRUCTION) {
      if (IsLabeled (address)) {
	if (Options & M_ADDRESSES)
	  fprintf (stdout, "%04X %s%s:\n", address,
                   lineinfix, Label (address));
	else
	  fprintf (stdout, "%s:\n", Label (address));
      }

      instr = &opset[Memory[address]];
      size = sizes[instr->admode];

      for (counter = 1; counter < size; counter++) {
        if (IsLabeled (address + counter)) {
	  if (Options & M_ADDRESSES)
	    fprintf (stdout, "%04X %s%s = * + %u\n",
                     (ADDR_T)(address + counter),
		     lineinfix, Label (address + counter), counter);
	  else
	    fprintf (stdout, "%s = * + %u\n",
		     Label (address + counter), counter);
	}

        if (FindNextEntry (NULL, address, ~0, WRN_INSTR_WRITTEN_TO))
          fprintf (stdout, "%s; Instruction opcode accessed.\n", lineprefix);

        entry = NULL;

        while ((entry = FindNextEntry (entry, address + counter, 0, 0)))
          switch (entry->type) {
          case WRN_PARAM_WRITTEN_TO:
            fprintf (stdout, "%s; Instruction parameter accessed.\n",
		     lineprefix);
            break;

          case WRN_PARAM_JUMPED_TO:
            fprintf (stdout, "%s; Instruction parameter jumped to.\n",
		     lineprefix);
            break;
          }
      }

      switch (Options & M_ADDRESSES) {
      case O_ADR_ADRPFIX:
	fprintf (stdout, "%04X ", address);
	break;

      case O_ADR_ADR_DMP:
	fprintf (stdout, "%04X ", address);

	for (counter = 0; counter < size; counter++)
	  fprintf (stdout, "%02X ", Memory[(ADDR_T)(address + counter)]);

	fputs (lineinfix + 3 * counter, stdout);
      }

      fputs ("  ", stdout);

      switch (instr->admode) {
      case accu:
      case impl:
        fprintf (stdout, "%s%s\n", mne[instr->mnemonic],
                 postfix[instr->admode]);
        break;
      case imm:
        addr = Memory[(ADDR_T)(address + 1)];
        fprintf (stdout, "%s #$%X\n", mne[instr->mnemonic], addr);
        break;
      case abs:
      case absx:
      case absy:
      case iabs:
      case iabsx:
        addr = Memory[(ADDR_T)(address + 1)] |
          (Memory[(ADDR_T)(address + 2)] << 8);
        fprintf (stdout, "%s %s%s%s\n", mne[instr->mnemonic],
                 prefix[instr->admode], Label (addr),
                 postfix[instr->admode]);
        break;
      case zp:
      case zpx:
      case zpy:
      case ind:
      case indx:
      case indy:
        addr = Memory[(ADDR_T)(address + 1)];
        fprintf (stdout, "%s %s%s%s\n", mne[instr->mnemonic],
                 prefix[instr->admode], Label (addr),
                 postfix[instr->admode]);
        break;
      case rel:
        addr = address + size +
          (int)(char)Memory[(ADDR_T)(address + 1)];
        fprintf (stdout, "%s %s%s%s\n", mne[instr->mnemonic],
                 prefix[instr->admode], Label (addr),
                 postfix[instr->admode]);
        break;
      case zrel:
        addr = address + size +
          (int)(char)Memory[(ADDR_T)(address + 2)];
        fprintf (stdout, "%s %s, %s\n", mne[instr->mnemonic],
                 Label (Memory[(ADDR_T)(address + 1)]), Label (addr));
        break;
      }
    }
    else if (address != (addr = WordTableEnd (address))) { /* word table */
      for (size = (ADDR_T)(addr - address); size;
	   address += (counter = size > (maxwidth & ~1) ?
                       (maxwidth & ~1) : size), size -= counter) {
	if (IsLabeled (address)) {
	  if (Options & M_ADDRESSES)
	    fprintf (stdout, "%04X %s%s:\n", address, lineinfix,
                     Label (address));
	  else
	    fprintf (stdout, "%s:\n", Label (address));
	}
	for (counter = size > (maxwidth & ~1) ? (maxwidth & ~1) : size,
	     addr = address + 1; --counter; addr++)
	  if (IsLabeled (addr)) {
	    if (Options & M_ADDRESSES)
	      fprintf (stdout, "%04X %s%s = * + %u\n", addr, lineinfix,
		       Label (addr), (ADDR_T)(addr - address));
	    else
	      fprintf (stdout, "%s = * + %u\n", Label (addr),
		       (ADDR_T)(addr - address));
	  }

	if (Options & M_ADDRESSES)
	  fprintf (stdout, "%04X ", address);

	if ((Options & M_ADDRESSES) == O_ADR_ADR_DMP) {
	  for (counter = size > (maxwidth & ~1) ? (maxwidth & ~1) : size,
	       addr = address; counter--; addr++) {
	    fprintf (stdout, "%02X ", Memory[addr]);
	  }
	  fputs (lineinfix + 3 * (size > (maxwidth & ~1) ?
				  (maxwidth & ~1) : size), stdout);
	}

	fprintf (stdout, "  .WORD %s",
		 Label (Memory[address] |
                 (Memory[(ADDR_T)(address + 1)] << 8)));

	for (counter = size > (maxwidth & ~1) ? (maxwidth & ~1) : size,
	     addr = address + 2; counter -= 2; addr += 2)
	  fprintf (stdout, ",%s",
		   Label (Memory[addr] | (Memory[(ADDR_T)(addr + 1)] << 8)));

	fputc ('\n', stdout);
      }
    }
    else { /* data block */
      for (size = 1; size < maxwidth; size++) { /* determine the size */
	addr = address + size; 

	if (GetMemType (addr) == MEM_INSTRUCTION ||
	    addr != WordTableEnd (addr))
	  break;
      }

      if (IsLabeled (address))
	if (Options & M_ADDRESSES)
	  fprintf (stdout, "%04X %s%s:\n", address, lineinfix,
		   Label (address));
	else
	  fprintf (stdout, "%s:\n", Label (address));

      for (counter = size, addr = address + 1; --counter; addr++)
        if (IsLabeled (addr)) {
	  if (Options & M_ADDRESSES)
	    fprintf (stdout, "%04X %s%s = * + %u\n", addr, lineinfix,
		     Label (addr), (ADDR_T)(addr - address));
	  else
	    fprintf (stdout, "%s = * + %u\n", Label (addr),
		     (ADDR_T)(addr - address));
        }

      if (Options & M_ADDRESSES)
	fprintf (stdout, "%04X ", address);

      if ((Options & M_ADDRESSES) == O_ADR_ADR_DMP) {
	for (counter = size, addr = address; counter--; addr++)
	  fprintf (stdout, "%02X ", Memory[addr]);

	fputs (lineinfix + 3 * size, stdout);
      }

      fprintf (stdout, "  .BYTE $%X", Memory[address]);

      for (counter = size, addr = address + 1; --counter; addr++)
	fprintf (stdout, ",$%X", Memory[addr]);

      fputc ('\n', stdout);
    }
}
