#include <stdio.h>
#include <stdlib.h>

#define ulong unsigned long

FILE *file;
unsigned char buffer[12], *isobuf, *base, *ulimit;
ulong size, pituus, kpl;


int main(int argc, char *argv[])
{
	if ((argc==2)&&(!((*argv[1]=='?')&&(*(char *)(argv[1]+1)==NULL))))
	{
		if (file=fopen(argv[1],"rb+"))
		{
			if (fread(buffer,12,1,file))
			{
				if (('FORM'==(buffer[0]<<24|buffer[1]<<16|buffer[2]<<8|buffer[3]))
						&&('CTLG'==(buffer[8]<<24|buffer[9]<<16|buffer[10]<<8|buffer[11])))
				{
					if ((fseek(file,0,SEEK_END))!=(-1))
					{
						if (-1!=(size=ftell(file)))
						{
							rewind(file);

							if (isobuf=malloc(size))
							{
								if (fread(isobuf,size,1,file))
								{
									base=isobuf;

									while ((base<isobuf+size-7)&&(!((base[0]=='S')&&(base[1]=='T')&&(base[2]=='R')&&(base[3]=='S')))) base++;

									if (base<isobuf+size-7)
									{
										base+=8;
										ulimit=base+(base[-4]<<24|base[-3]<<16|base[-2]<<8|base[-1]);

										while (base+8<ulimit)
										{
											base+=8;

											pituus=base[-4]<<24|base[-3]<<16|base[-2]<<8|base[-1];

											if (base[pituus-1]);
											else
											{
												if ((pituus-1)!=(((pituus-1)>>2)*4))
												{
													pituus--;
													kpl++;

													if ((-1)==(fseek(file,base-4-isobuf,SEEK_SET))) {fprintf (stdout, "Error reading file!\n"); goto jatkuu;}
													if (!(fwrite((char *)(&pituus),4,1,file))) {fprintf (stdout, "Error writing file!\n"); goto jatkuu;}
												}
											}

											base+=((pituus>>2)+1)*4;
										}
										fprintf (stdout, "Fixed %d strings. Operation done.\n",kpl);

									}
									else (fprintf (stderr, "Operation not successful!\n"));

								}
            		else (fprintf (stderr, "Error reading file!\n"));
jatkuu:
								free (isobuf);
							}
							else (fprintf (stderr, "Couldn't allocate memory!\n"));
						}
						else (fprintf (stderr, "Error reading file!\n"));
					}
					else (fprintf (stderr, "Error reading file!\n"));
				}
				else (fprintf (stderr, "File is probably not a catalog!\n"));
			}
			else (fprintf (stderr, "Error reading file!\n"));

			fclose (file);
		}
		else (fprintf (stderr, "Couldn't open file \"%s\"!\n",argv[1]));
	}
	else (fprintf (stderr, "Usage: FixCat CATALOG/A\n"));
}
