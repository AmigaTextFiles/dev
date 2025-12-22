/*
 * picasm -- config.c
 *
 * handles configuration fuse setting with the CONFIG-directive
 *
 * Timo Rossi <trossi@iki.fi>
 * 
 */

#include <stdio.h>
#include <string.h>

#include "picasm.h"

/*
 * Check Yes/No (or Disable(d)/Enable(d) or On/Off) strings for CONFIG
 *
 * returns: 0=no, 1=yes, -1=error
 *
 */
static int
config_yes_no(char *s)
{
  if(strcasecmp(s, "yes") == 0 || strcasecmp(s, "on") == 0 ||
     strncasecmp(s, "enable", 6) == 0)
    return 1;
  else if(strcasecmp(s, "no") == 0 || strcasecmp(s, "off") == 0 ||
	  strncasecmp(s, "disable", 7) == 0)
    return 0;
  else
    return -1; /* error */
}

/*
 * selstr consists of NUL-terminated strings with two NULs in the end
 * If str matches one of the components of selstr, the index of
 * that component (starting from zero) is returned,
 * if no match is found, -1 is returned.
 */
static int
strsel(char *selstr, char *str)
{
  int sel = 0;

  while(*selstr != '\0') {
    if(strcasecmp(selstr, str) == 0)
      return sel;

    selstr += strlen(selstr)+1;
    sel++;
  }

  return -1;
}

/*
 * parse the CONFIG directive
 * 
 * (the separate code protections of PIC14000 are not currently,
 *  and neither are the partial protections on some PICs)
 * 
 */
void
parse_config(void)
{
  static char symname[256];
  int t;

  for(;;) {
    if(token_type != TOK_IDENTIFIER) {
cfg_error:
      error(1, "CONFIG syntax error");
      return;
    }
    strcpy(symname, token_string);
    get_token();

    /* hmm... this is a little kludge, but as
       the tokenizer now makes 'local id's from
       the valid config strings, this must be used... */
    if(token_type != TOK_LOCAL_ID) {
      if(token_type != TOK_EQUAL) {
	error(1, "'=' expected");
	return;
      }
      get_token();
      if(token_type != TOK_IDENTIFIER)
	goto cfg_error;
    }

    switch(strsel("OSC\0WDT\0CP\0PWRT\0MCLR\0BOD\0MPE\0", symname)) {
      case 0: /* OSC */
        if((t = strsel("LP\0XT\0HS\0RC\0INTRC\0INTRC_CLKOUT\0"
		       "EXTRC\0EXTRC_CLKOUT\0IN\0", token_string)) < 0)
	  goto cfg_error;

	switch(pic_type->fusetype) {
	  case FUSE_12C5XX:
	    if(t >= 2 && t != 4 && t != 6) {
	      error(1, "Invalid oscillator type %s for PIC%s",
		    token_string, pic_type->name);
	      return;
	    }
	    if(t >= 2)
	       t >>= 2;
	    config_fuses = (config_fuses & 0xffc) | t;
	    break;
		
	  case FUSE_12C6XX:
	    if(t == 3 || t >= 8) {
	      error(1, "Invalid oscillator type %s for PIC%s",
		    token_string, pic_type->name);
	      return;
	    }
	    config_fuses = (config_fuses & 0x3ff8) | t;
	    break;
	
	  case FUSE_14000:
	    if(t != 2 && t != 4 && t != 8) { /* accept both IN and INTRC */
	      error(1, "Invalid oscillator type %s for PIC%s",
		    token_string, pic_type->name);
	      return;
	    }
	    config_fuses = (config_fuses & 0x3ffe) | (t != 2);
	    break;

	  case FUSE_16C5X:
	  case FUSE_16F8X:
	  case FUSE_16CXX1:
	  case FUSE_16CXX2:
	  case FUSE_16C55X:
	  case FUSE_16C62X:
	  case FUSE_16C6XA:
	  case FUSE_16C71X:
	  case FUSE_16C715:
	    if(t >= 4) {
	      error(1, "Invalid oscillator type %s for PIC%s",
		    token_string, pic_type->name);
	      return;
	    }
	    config_fuses = (config_fuses & 0x3ffc) | t;
	    break;
        }
	break;

      case 1: /* WDT - watchdog timer */
	if((t = config_yes_no(token_string)) < 0)
	  goto cfg_error;

	switch(pic_type->fusetype) {
	  case FUSE_12C6XX:
	    config_fuses = (config_fuses & 0x3ff7) | (t ? 8 : 0);
	    break;
		
	  default:
	    config_fuses = (config_fuses & 0x3ffb) | (t ? 4 : 0);
	    break;
        }
	break;
	    
      case 2: /* CP - code protect */
	        /* partial protection is not supported */
	if((t = config_yes_no(token_string)) < 0)
	  goto cfg_error;
	
	switch(pic_type->fusetype) {
	  case FUSE_16C5X:
	  case FUSE_12C5XX:
	    config_fuses = (config_fuses & 0xff7) | (t ? 0 : 8);
	    break;
		
	  case FUSE_12C6XX:
	    config_fuses = (config_fuses & 0x009f) | (t ? 0 : 0x3f60);
	    break;
				
	  case FUSE_16CXX1: /* 1 code protect bit */
	    config_fuses = (config_fuses & 0x3fef) | (t ? 0 : 0x10);
	    break;
		
	  case FUSE_16CXX2: /* 2 code protect bits */
	    config_fuses = (config_fuses & 0x3fcf) | (t ? 0 : 0x30);
	    break;
		
	  case FUSE_16F8X:
	    config_fuses = (config_fuses & 0x000f) | (t ? 0 : 0x3ff0);
	    break;
		
	  case FUSE_16C71X:
	    config_fuses = (config_fuses & 0x004f) | (t ? 0 : 0x3fb0);
	    break;
		
	  case FUSE_16C6XA:
	  case FUSE_16C62X: /* 2 code protect bits, replicated */
	  case FUSE_16C55X:
	  case FUSE_16C715:
	    config_fuses = (config_fuses & 0x00cf) | (t ? 0 : 0x3f30);
	    break;
		
	  case FUSE_14000:
	    config_fuses = (config_fuses & 0x3f4f) | (t ? 0 : 0x00b0);
	    break;
        }
	break;

      case 3: /* PWRT - power-up timer */
	if((t = config_yes_no(token_string)) < 0)
	  goto cfg_error;
	
	switch(pic_type->fusetype) {
	  case FUSE_16CXX1:
	  case FUSE_16CXX2:
	    config_fuses = (config_fuses & 0x3ff7) | (t ? 8 : 0);
	    break;
		
	  case FUSE_16C6XA:
	  case FUSE_16C55X:
	  case FUSE_16F8X:
	  case FUSE_16C71X:
	  case FUSE_16C715:
	  case FUSE_16C62X:
	  case FUSE_14000:
	    config_fuses = (config_fuses & 0x3ff7) | (t ? 0 : 8);
	    break;

	  case FUSE_12C6XX:
	    config_fuses = (config_fuses & 0x3fef) | (t ? 0 : 0x10);
	    break;
		
	  case FUSE_16C5X:
	  case FUSE_12C5XX:
	    error(1, "No power-up timer in PIC%s", pic_type->name);
	    return;
	}
	break;

      case 4: /* MCLR - enable/disable MCLR (8-pin PICs) */
	if((t = config_yes_no(token_string)) < 0)
	  goto cfg_error;
	    
	switch(pic_type->fusetype) {
          case FUSE_12C5XX:
	    config_fuses = (config_fuses & 0xfef) | (t ? 0x10 : 0);
	    break;
	    
          case FUSE_12C6XX:
	    config_fuses = (config_fuses & 0x3f7f) | (t ? 0x80 : 0);
	    break;
	    
          default:
	    error(1,"No MCLRE in PIC%s", pic_type->name);
	    return;
        }
	break;
	    
      case 5: /* BOD - brown-out detect */
	if((t = config_yes_no(token_string)) < 0)
	  goto cfg_error;
	    
	switch(pic_type->fusetype) {
	  case FUSE_16C62X:
	  case FUSE_16C6XA:
	  case FUSE_16C71X:
	  case FUSE_16C715:
	    config_fuses = (config_fuses & 0x3fbf) | (t ? 0x40 : 0);
	    break;
		
          default:
	    error(1,"No BODEN in PIC%s", pic_type->name);
	    return;
	}
	break;
	    
      case 6: /* MPE - memory parity error */
	if((t = config_yes_no(token_string)) < 0)
	  goto cfg_error;
	    
	switch(pic_type->fusetype) {
	  case FUSE_16C715:
	    config_fuses = (config_fuses & 0x3f7f) | (t ? 0x80 : 0);
	    break;
		
	  default:
	    error(1,"No MPEEN in PIC%s", pic_type->name);
	    return;
	}
	break;
	    
      default:
	goto cfg_error;
    }
	  
    get_token();
    if(token_type != TOK_COMMA)
      break;

    get_token();
  }
}
