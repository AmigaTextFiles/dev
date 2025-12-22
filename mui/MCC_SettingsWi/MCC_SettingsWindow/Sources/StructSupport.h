
/* Structure Support Functions */


static void Type_Next(UWORD *&des)
{
	switch(*des)
		{
		case SWIS_ARRAY:
			des=&des[2];
			Type_Next(des);
			break;

		case SWIS_STRING:
			des=&des[2];
			break;

		case SWIS_POINTER:
			des=&des[1];
			Type_Next(des);
			break;

		case SWIS_STRUCT:
			des=&des[1];

			while (*des!=(UWORD)SWIS_END)
				{
				Type_Next(des);
				}

			des=&des[1];
			break;

		case SWIS_BYTE:
		case SWIS_WORD:
		case SWIS_LONG:
		case SWIS_EVEN:
		case SWIS_EVEN4:
		default:
			des=&des[1];
			break;
		}
}


static ULONG Type_Check(ULONG &data, UWORD *&des)
{
	ULONG len=0;

	switch(*des)
		{
		case SWIS_BYTE:
			len=1;
			data+=1;
			des=&des[1];
			break;

		case SWIS_WORD:
			len=2;
			data+=2;
			des=&des[1];
			break;

		case SWIS_LONG:
			len=4;
			data+=4;
			des=&des[1];
			break;

		case SWIS_ARRAY:
			{
			ULONG	i,anz;
			UWORD *des2;

			anz=des[1];			/* muß immer >0 sein!!! */
			des=des2=&des[2];

			for (i=0;i<anz;i++)
				{
				des2=des;
				len+=Type_Check(data,des2);
				}

			des=des2;
			break;
			}

		case SWIS_STRING:
			{
			if (des[1]==(UWORD)-1)
				{
				len=strlen((STRPTR)data)+1;
				}
			else
				{
				len=des[1];
				}

			data+=len;
			des=&des[2];
			break;
			}

		case SWIS_POINTER:
			des=&des[1];
			Type_Next(des);
			len=4;
			data+=4;
			break;

		case SWIS_STRUCT:
			des=&des[1];

			while (*des!=(UWORD)SWIS_END)
				{
				len+=Type_Check(data,des);
				}

			des=&des[1];
			break;

		case SWIS_EVEN:
			if (data & 1)
				{
				len+=1;
				data+=1;
				}

			des=&des[1];
			break;

		case SWIS_EVEN4:
			{
			ULONG uneven;

			if (uneven=data & 3)
				{
				len+=uneven;
				data+=uneven;
				}

			des=&des[1];
			break;
			}

		default:
			len=*des;
			des=&des[1];
			break;
		}

	return(len);
}


static ULONG Type_Size(ULONG &data, UWORD *&des)
{
	ULONG len=0;

D2(BUG("%ld: ",*des));

	switch(*des)
		{
		case SWIS_BYTE:
D2(BUG("BYTE: %ld\n",*(UBYTE *)data));
			len=1;
			data+=1;
			des=&des[1];
			break;

		case SWIS_WORD:
D2(BUG("WORD: %ld\n",*(UWORD *)data));
			len=2;
			data+=2;
			des=&des[1];
			break;

		case SWIS_LONG:
D2(BUG("LONG: %ld\n",*(ULONG *)data));
			len=4;
			data+=4;
			des=&des[1];
			break;

		case SWIS_ARRAY:
			{
			ULONG	i,anz;
			UWORD *des2;

D2(BUG("ARRAY\n"));

			anz=des[1];			/* muß immer >0 sein!!! */
			des=des2=&des[2];

			for (i=0;i<anz;i++)
				{
				des2=des;
				len+=Type_Size(data,des2);
				}

			des=des2;
			break;
			}

		case SWIS_STRING:
			{
D2(BUG("STRING: %s\n",data));
			if (des[1]==(UWORD)-1)
				{
				len=strlen((STRPTR)data)+1;
				}
			else
				{
				len=des[1];
				}

			data+=len;
			des=&des[2];
			break;
			}

		case SWIS_POINTER:
			{
D2(BUG("POINTER: %p\n",*(ULONG *)data));

			if (*(ULONG *)data)
				{
				ULONG data2=*(ULONG *)data;

				des=&des[1];
				len=4+((Type_Size(data2,des)+3) & ~3);
				data+=4;
				}
			else
				{
				/* Pointer ist NULL, nur des weiterstellen und data+4 */

				Type_Next(des);
				data+=4;
				}

			break;
			}

		case SWIS_STRUCT:
D2(BUG("STRUCT\n"));
			des=&des[1];

			while (*des!=(UWORD)SWIS_END)
				{
				len+=Type_Size(data,des);
				}

			des=&des[1];
			break;

		case SWIS_EVEN:
D2(BUG("EVEN\n"));
			if (data & 1)
				{
				len+=1;
				data+=1;
				}

			des=&des[1];
			break;

		case SWIS_EVEN4:
			{
			ULONG uneven;

D2(BUG("EVEN4\n"));

			if (uneven=data & 3)
				{
				len+=uneven;
				data+=uneven;
				}

			des=&des[1];
			break;
			}

		default:
			len=*des;
			des=&des[1];
			break;
		}

	return(len);
}


static void Type_Copy(ULONG &source, ULONG &dest, ULONG &nextdest,
	UWORD *&des)
{
	switch(*des)
		{
		case SWIS_BYTE:
D2(BUG("Copy BYTE: %ld\n",*(UBYTE *)source));
			*(UBYTE *)dest=*(UBYTE *)source;
			source+=1;
			dest+=1;
			des=&des[1];
			break;

		case SWIS_WORD:
D2(BUG("Copy WORD: %ld\n",*(UWORD *)source));
			*(UWORD *)dest=*(UWORD *)source;
			source+=2;
			dest+=2;
			des=&des[1];
			break;

		case SWIS_LONG:
D2(BUG("Copy LONG: %ld\n",*(ULONG *)source));
			*(ULONG *)dest=*(ULONG *)source;
			source+=4;
			dest+=4;
			des=&des[1];
			break;

		case SWIS_ARRAY:
			{
			ULONG	i,anz;
			UWORD *des2;

D2(BUG("Copy ARRAY\n"));

			anz=des[1];			/* muß immer >0 sein!!! */
			des=des2=&des[2];

			for (i=0;i<anz;i++)
				{
				des2=des;
				Type_Copy(source,dest,nextdest,des2);
				}

			des=des2;

D2(BUG("Copy ARRAY End\n"));

			break;
			}

		case SWIS_STRING:
			{
			ULONG len;

D2(BUG("Copy STRING: %s\n",source));

			if (des[1]==(UWORD)-1)
				{
				len=strlen((STRPTR)source)+1;
				}
			else
				{
				len=des[1];
				}

			memcpy((STRPTR)dest,(STRPTR)source,len);

			source+=len;
			dest+=len;
			des=&des[2];
			break;
			}

		case SWIS_POINTER:
			{
D2(BUG("Copy POINTER\n"));

			if (*(ULONG *)source)
				{
				ULONG source2=*(ULONG *)source;
				ULONG source3=source2;
				ULONG dest2=nextdest;
				UWORD *des2=des=&des[1];

				*(ULONG *)dest=dest2;

				/* neues nextdest berechnen und rekursieren */

				nextdest=(nextdest+Type_Check(source3,des2)+3) & ~3;
				Type_Copy(source2,dest2,nextdest,des);

				source+=4;
				dest+=4;
				}
			else
				{
				/* Pointer ist NULL, nur des weiterstellen und data+4 */

				*(ULONG *)dest=NULL;
				Type_Next(des);
				source+=4;
				dest+=4;
				}

			break;
			}

		case SWIS_STRUCT:

D2(BUG("Copy STRUCT\n"));

			des=&des[1];

			while (*des!=(UWORD)SWIS_END)
				{
				Type_Copy(source,dest,nextdest,des);
				}

			des=&des[1];

D2(BUG("Copy STRUCT End\n"));

			break;

		case SWIS_EVEN:
D2(BUG("Copy EVEN\n"));

			source=(source+1) & ~1;
			dest=(dest+1) & ~1;
			des=&des[1];
			break;

		case SWIS_EVEN4:
D2(BUG("Copy EVEN4\n"));

			source=(source+3) & ~3;
			dest=(dest+3) & ~3;
			des=&des[1];
			break;

		default:
D2(BUG("Copy DEFAULT\n"));
			memcpy((APTR)dest,(APTR)source,*des);
			source+=*des;
			dest+=*des;
			des=&des[1];
			break;
		}
}


static void Type_Reloc(ULONG &data, UWORD *&des, ULONG reloc)
{
	switch(*des)
		{
		case SWIS_BYTE:
			data+=1;
			des=&des[1];
			break;

		case SWIS_WORD:
			data+=2;
			des=&des[1];
			break;

		case SWIS_LONG:
			data+=4;
			des=&des[1];
			break;

		case SWIS_ARRAY:
			{
			ULONG	i,anz;
			UWORD *des2;

			anz=des[1];			/* muß immer >0 sein!!! */
			des=des2=&des[2];

			for (i=0;i<anz;i++)
				{
				des2=des;
				Type_Reloc(data,des2,reloc);
				}

			des=des2;
			break;
			}

		case SWIS_STRING:
			{
			if (des[1]==(UWORD)-1)
				{
				data+=strlen((STRPTR)data)+1;
				}
			else
				{
				data+=des[1];
				}

			des=&des[2];
			break;
			}

		case SWIS_POINTER:
			{
			if (*(ULONG *)data)
				{
				ULONG data2;

				*(ULONG *)data+=reloc;
				data2=*(ULONG *)data;

				des=&des[1];
				Type_Reloc(data2,des,reloc);
				data+=4;
				}
			else
				{
				/* Pointer ist NULL, nur des weiterstellen und data+4 */

				Type_Next(des);
				data+=4;
				}

			break;
			}

		case SWIS_STRUCT:
			des=&des[1];

			while (*des!=(UWORD)SWIS_END)
				{
				Type_Reloc(data,des,reloc);
				}

			des=&des[1];
			break;

		case SWIS_EVEN:
			if (data & 1)
				{
				data+=1;
				}

			des=&des[1];
			break;

		case SWIS_EVEN4:
			{
			ULONG uneven;

			if (uneven=data & 3)
				{
				data+=uneven;
				}

			des=&des[1];
			break;
			}

		default:
			des=&des[1];
			break;
		}
}



/* Entry Support Functions */


ULONG Entry_Size(ULONG source, UWORD *des)
{
	return((source) ? (Type_Size(source,des)+3) & ~3 : 0);
}

ULONG Entry_SmartCopy(ULONG source, ULONG dest, UWORD *des)
{
	ULONG source1=source;	/* Trashvariable für source */
	UWORD *des1=des;			/* Trashvariable für des */
	ULONG nextdest;

	/* Adresse des nächsten freien Segments berechnen */

	source1=source;
	des1=des;
	nextdest=(dest+Type_Check(source1,des1)+3) & ~3;

	/* Kopieren der gesamten Struktur */

	Type_Copy(source,dest,nextdest,des);

	return(nextdest);
}


void Entry_Reloc(ULONG source, UWORD *des, ULONG reloc)
{
	Type_Reloc(source,des,reloc);
}



/* Complex Support Functions */


struct MUIS_SettingsWindow_ComplexContents *Complex_SmartStore(Object *obj,
	ULONG attr, UWORD *des, void *pool)
{
	struct MUIS_SettingsWindow_ComplexContents *entry=NULL;
	ULONG data,size;

D(BUG("Complex_SmartStore\n"));

	if (obj)
		{
		/* Get a pointer to the entry */

		get(obj,attr,&data);

		/* Bestimmen der Größe des Entries */

		size=Entry_Size(data,des);

		/* Speicher besorgen */

		if (entry=AllocVecPooled(pool,
				sizeof(struct MUIS_SettingsWindow_ComplexContents)+size))
			{
			entry->swc_Size=sizeof(struct MUIS_SettingsWindow_ComplexContents)
				+size;

			/* Relocposition */

			entry->swc_Reloc=(ULONG)entry;

			/* Kopieren */

			if (data)
				{
				Entry_SmartCopy(data,(ULONG)&entry->swc_Entry,des);
				}
			}
		}

D(BUG("Complex_SmartStore End\n"));

	return(entry);
}


void Complex_Store(struct MUIS_SettingsWindow_Item *item, void *pool)
{
	struct MUIS_SettingsWindow_ComplexContents *entry=NULL;

D(BUG("Complex_Store\n"));

	if (item->swi_Obj)
		{
		/* free old entries */

		if (item->swi_Contents)
			{
			FreeVecPooled(pool,(APTR)item->swi_Contents);
			}

		entry=Complex_SmartStore(item->swi_Obj,item->swi_Attr,
			(UWORD *)item->swi_Size,pool);
		}

	item->swi_Contents=(ULONG)entry;

D(BUG("Complex_Store End\n"));
}


void Complex_Reloc(MUIS_SettingsWindow_ComplexContents *item, UWORD *des)
{
	ULONG reloc;

D(BUG("Complex_Reloc\n"));

	if (item)
		{
		/* Relocation berechnen und neu setzen */

		reloc=(ULONG)item-item->swc_Reloc;
		item->swc_Reloc=(ULONG)item;

		/* Entry relozieren */

		Entry_Reloc((ULONG)&item->swc_Entry,des,reloc);
		}

D(BUG("Complex_Reloc End\n"));
}


struct MUIS_SettingsWindow_ComplexContents *Complex_Duplicate(
	struct MUIS_SettingsWindow_ComplexContents *source,
	UWORD *des, void *pool)
{
	struct MUIS_SettingsWindow_ComplexContents *dest=NULL;

D(BUG("Complex_Duplicate\n"));

	if (dest=AllocVecPooled(pool,source->swc_Size))
		{
		CopyMem(source,dest,source->swc_Size);

		Complex_Reloc(dest,des);
		}

D(BUG("Complex_Duplicate End!\n"));

	return(dest);
}



/* List Support Functions */


struct MUIS_SettingsWindow_ListContents *List_SmartStore(Object *list,
	ULONG type, UWORD *des, void *pool)
{
	ULONG entryanz;
	struct MUIS_SettingsWindow_ListContents *entrytable=NULL;
	ULONG *temptable=NULL;
	ULONG i,size=0;
	ULONG dest;

D(BUG("List_SmartStore\n"));

	if (list)
		{
		/* Get the number of entries */

		get(list,
			type & SWIT_NLIST?MUIA_NList_Entries:MUIA_List_Entries,
			&entryanz);

		/* Alloc mem for temporary table */

		temptable=AllocVecPooled(pool, entryanz*sizeof(ULONG));

		if ((temptable) || entryanz==0)
			{
			/* Bestimmen der Gesamtlänge */

			for (i=0;i<entryanz;i++)
				{
				/* Get list entry */

				DoMethod(list,
					type & SWIT_NLIST?MUIM_NList_GetEntry:MUIM_List_GetEntry,
					i,
					&temptable[i]);

				/* Bestimmen der Größe des Listentries */

				if (temptable[i])
					{
					switch (type & SWIT_TYPES)
						{
						case SWIT_LISTSTANDARD:
							break;

						case SWIT_LISTSTRING:
							if ((ULONG)des!=-1)
								{
								size+=(ULONG)des;
								}
							else
								{
								size+=strlen((STRPTR)temptable[i])+1;
								}

							break;

						case SWIT_LISTSTRUCT:
							size+=((ULONG)des + 3) & ~3;
							break;

						case SWIT_LISTCOMPLEX:
						case SWIT_LISTCUSTOM:
							size+=Entry_Size(temptable[i],des);
							break;
						}
					}
				}

			/* Speicher für alles besorgen, Entries kopieren */

			if (entrytable=AllocVecPooled(pool, sizeof(struct MUIS_SettingsWindow_ListContents)
					+(entryanz+1)*sizeof(ULONG)+size))
				{
				entrytable->swl_Size=sizeof(struct MUIS_SettingsWindow_ListContents)
					+(entryanz+1)*sizeof(ULONG)+size;

				/* Anzahl der Entries */

				entrytable->swl_Count=entryanz;

				/* Relocposition */

				entrytable->swl_Reloc=(ULONG)entrytable;

				/* Zieladresse für Entries */

				dest=(ULONG)entrytable+sizeof(struct MUIS_SettingsWindow_ListContents)
					+(entryanz+1)*sizeof(ULONG);

D2(BUG("Speicher allokiert: %p, 1.Eintrag: %p, Daten: %p\n",entrytable,&entrytable->swl_Entries[0],dest));

				for (i=0;i<entryanz;i++)
					{
					/* Kopieren */

					if (temptable[i])
						{
						/* Zieladresse für Entry */

						entrytable->swl_Entries[i]=dest;

						switch (type & SWIT_TYPES)
							{
							case SWIT_LISTSTANDARD:
								entrytable->swl_Entries[i]=temptable[i];
								break;

							case SWIT_LISTSTRING:
								if ((ULONG)des!=-1)
									{
									memcpy((APTR)dest,(APTR)temptable[i],(ULONG)des);
									dest+=(ULONG)des;
									}
								else
									{
									strcpy((STRPTR)dest,(STRPTR)temptable[i]);
									dest+=strlen((STRPTR)temptable[i])+1;
									}

								break;

							case SWIT_LISTSTRUCT:
								memcpy((APTR)dest,(APTR)temptable[i],(ULONG)des);
								dest+=((ULONG)des + 3) & ~3;
								break;

							case SWIT_LISTCOMPLEX:
							case SWIT_LISTCUSTOM:

D2(BUG("Kopiere Entry: %p -> %p\n",temptable[i],dest));

								dest=Entry_SmartCopy(temptable[i],dest,des);
								break;

							default:
								entrytable->swl_Entries[i]=0;
							}
						}
					}
				}
			}

		/* Zwischenspeicher freigeben */

		if (temptable)
			{
			FreeVecPooled(pool, temptable);
			}
		}

D(BUG("List_SmartStore End\n"));

	return(entrytable);
}


void List_Store(struct MUIS_SettingsWindow_Item *item, void *pool)
{
	struct MUIS_SettingsWindow_ListContents *entrytable=NULL;

D(BUG("List_Store\n"));

	if (item->swi_Obj)
		{
		/* free old entries */

		if (item->swi_Contents)
			{
			FreeVecPooled(pool, (APTR)item->swi_Contents);
			}

		entrytable=List_SmartStore(item->swi_Obj,item->swi_Type,
			(UWORD *)item->swi_Size, pool);
		}

	item->swi_Contents=(ULONG)entrytable;

D(BUG("List_Store End\n"));
}



void List_SmartReset(Object *list, ULONG type,
	MUIS_SettingsWindow_ListContents *contents, UWORD *des)
{
D(BUG("List_SmartReset\n"));

	/* Liste leeren */

	DoMethod(list,
		type & SWIT_NLIST?MUIM_NList_Clear:MUIM_List_Clear);

	if (contents)
		{
		/* Entries enfügen */

		if (contents->swl_Count>0)
			{
			switch(type & SWIT_TYPES)
				{
				case SWIT_LISTSTANDARD:
				case SWIT_LISTSTRING:
				case SWIT_LISTSTRUCT:
				case SWIT_LISTCOMPLEX:
					DoMethod(list,
						type & SWIT_NLIST?MUIM_NList_Insert:MUIM_List_Insert,
						contents->swl_Entries,
						contents->swl_Count,
						type & SWIT_NLIST?MUIV_NList_Insert_Bottom:MUIV_List_Insert_Bottom);

					break;

				case SWIT_LISTCUSTOM:
					DoMethod(list,
						MUIM_SettingsWindow_CustomInsert,
						contents->swl_Entries,
						contents->swl_Count,
						type & SWIT_NLIST?MUIV_NList_Insert_Bottom:MUIV_List_Insert_Bottom);

					break;
				}
			}
		}

D(BUG("List_SmartReset End\n"));
}


void List_Reset(struct MUIS_SettingsWindow_Item *item)
{
	List_SmartReset(item->swi_Obj,item->swi_Type,(APTR)item->swi_Contents,(UWORD *)item->swi_Size);
}


void List_Reloc(MUIS_SettingsWindow_ListContents *item, ULONG type,
	UWORD *des)
{
	ULONG i,reloc;

D(BUG("List_Reloc\n"));

	switch(type & SWIT_TYPES)
		{
		case SWIT_LISTSTANDARD:
			break;

		case SWIT_LISTSTRING:
		case SWIT_LISTSTRUCT:
			des=NULL;

		case SWIT_LISTCOMPLEX:
		case SWIT_LISTCUSTOM:

			if ((item) && item->swl_Count>0)
				{
				/* Relocation berechnen und neu setzen */

				reloc=(ULONG)item-item->swl_Reloc;
				item->swl_Reloc=(ULONG)item;

				for (i=0;i<item->swl_Count;i++)
					{
					/* Zeiger auf Entry und dann Entry selbst relozieren */

					if (item->swl_Entries[i])
						{
						item->swl_Entries[i]+=reloc;

						if (des)
							{
							Entry_Reloc(item->swl_Entries[i],des,reloc);
							}
						}
					}
				}

			break;
		}

D(BUG("List_Reloc End\n"));
}


struct MUIS_SettingsWindow_ListContents *List_Duplicate(
	struct MUIS_SettingsWindow_ListContents *source,
	ULONG type, UWORD *des, void *pool)
{
	struct MUIS_SettingsWindow_ListContents *dest=NULL;

	if (dest=AllocVecPooled(pool, source->swl_Size))
		{
		CopyMem(source,dest,source->swl_Size);
		List_Reloc(dest,type,des);
		}

	return(dest);
}


