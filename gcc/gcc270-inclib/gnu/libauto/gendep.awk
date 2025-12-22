/#/	{
	  gsub("_.*","",$1);
	  bases[$1] = substr($2,2);
	  next;
	}

	{ for (i = 1; i <= NF; i++)
	    {
	      printf "%s.o:\tbase.c\n",$i
	      printf "\t$(CC) $(CFLAGS) -c base.c -o %s.o -DLIBRARY_NAME=\"%s.library\" \\\n\t  -DLIBRARY_BASE=%s -DLIBRARY_VERS=__auto_%s_vers\n",$i,$i,bases[$i],$i
	      printf "%s_vers.o:\tvers.c\n",$i
	      printf "\t$(CC) $(CFLAGS) -c vers.c -o %s_vers.o -DLIBRARY_VERS=__auto_%s_vers\n",$i,$i
	      printf "##############################################################################\n"
	    }
	}
