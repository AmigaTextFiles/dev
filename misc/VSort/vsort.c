/******************************************************************************
**                                                                           **
** VSort V 1.0                                                               **
**                                                                           **
*******************************************************************************
** Visualisierung von Sortierprozessen                                       **
** by Stefan Kost                                                            **
** 19.04.1995                                                                **
******************************************************************************/

#include "sc:source/vsort/vsort.h"

/* Protos */

void gen_tdat(void);
void draw_tdat(void);
void swap(UWORD i1,UWORD i2);

void BubbleSort(void);
void SelectionSort(void);
void InsertionSort(void);
void ShellSort(void);
void QuickSort(UWORD l,UWORD r);
void MergeSort(UWORD l,UWORD r);
void RadixExchangeSort(UWORD l,UWORD r,WORD b);
UWORD bits(UWORD x,UWORD k);
void HeapSort(void);
void downheap(UWORD n,UWORD k);

void Message(char *title,char *text);
UBYTE Question(char *title,char *text);

void Wait1(void);
void Wait2(void);

void OpenAll(void);
void CloseAll(void);

/* globale Var`s */

UWORD tdat[maxanz],tmp[maxanz];
UBYTE sortmode=0,datamode=1,delayt=0;
UWORD swapct=100,anz=100;

char *strbuf="          ";
ULONG tempvar;
char *tempstr;

/*============================================================================*/

void gen_tdat(void)
{
	register UWORD i;

	switch(datamode)
	{
		case 0:
			for(i=0;i<anz;i++) tdat[i]=i;
			break;
		case 1:
			for(i=0;i<anz;i++) tdat[i]=i;
			for(i=0;i<swapct;i++) swap(rand()%anz,rand()%anz);
			break;
		case 2:
			for(i=1;i<=anz;i++) tdat[i]=anz-i;
			break;
		case 3:
			for(i=1;i<=anz;i++) tdat[i]=anz-i;
			for(i=0;i<swapct;i++) swap(rand()%anz,rand()%anz);
			break;
	}
}

void draw_tdat(void)
{
	register UWORD i;

	SetAPen(&rp,1);
	WaitTOF();SetRast(&rp,0);
	WaitTOF();for(i=0;i<anz;i++) WritePixel(&rp,i,anz-tdat[i]);
}

void swap(UWORD i1,UWORD i2)
{
	UWORD tmp;

	tmp=tdat[i1];tdat[i1]=tdat[i2];tdat[i2]=tmp;
}

/*============================================================================*/

void BubbleSort(void)
{
	register UWORD i,j;

	for(i=0;i<anz;i++)
	{
		for(j=0;j<(anz-1);j++)
		{
			if(tdat[j]>tdat[j+1]) swap(j,j+1);
		}
		draw_tdat();Delay(delayt);
	}
}

void SelectionSort(void)
{
	register UWORD i,j,mp;

	for(i=0;i<anz;i++)
	{
		mp=i;
		for(j=i;j<anz;j++)
		{
			if(tdat[j]<tdat[mp]) mp=j;
		}
		swap(i,mp);
		draw_tdat();Delay(delayt);
	}
}

void InsertionSort(void)
{
	register UWORD i,mp;

	for(i=1;i<anz;i++)
	{
		mp=i;
		while(mp>0 && tdat[mp]<tdat[mp-1])
		{
			swap(mp,mp-1);mp--;
		}
		draw_tdat();Delay(delayt);
	}
}

void ShellSort(void)
{
	register UWORD i,h=1,mp;

	while(h<=(anz/9)) h=3*h+1;
	while(h)
	{
		for(i=h;i<=anz;i++)
		{
			mp=i;
			while(mp!=h-1 && tdat[mp]<tdat[mp-h])
			{
				swap(mp,mp-h);mp--;
			}
			draw_tdat();Delay(delayt);
		}
		h=h/3;
	}
}

void QuickSort(UWORD l,UWORD r)
{
	register UWORD v,i,j;

	if(r>l)
	{
		v=tdat[r];i=l-1;j=r;
		for(;;)
		{
			while(tdat[++i]<v);
			while(tdat[--j]>v);
			if(i>=j) break;
			swap(i,j);
			draw_tdat();Delay(delayt);
		}
		swap(i,r);
		draw_tdat();Delay(delayt);
		QuickSort(l,i-1);
		QuickSort(i+1,r);
	}
}

void MergeSort(UWORD l,UWORD r)
{
	register UWORD i,j,k,m;

	if(r>l)
	{
		m=(r+l)>>1;																/* Mitte bilden */
		draw_tdat();Delay(delayt);
		MergeSort(l,m);															/* Teilfolgen sortieren */
		MergeSort(m+1,r);
		for(i=m+1;i>l;i--) tmp[i-1]=tdat[i-1];									/* in Hilfsfeld übertragen */
		for(j=m;j<r;j++) tmp[r+m-j]=tdat[j+1];
		for(k=l;k<=r;k++) tdat[k]=(tmp[i]<tmp[j]) ? tmp[i++] : tmp[j--];		/* und zusammenmischen */
		draw_tdat();
	}
}

void RadixExchangeSort(UWORD l,UWORD r,WORD b)
{
	register UWORD i,j;

	if(r>l && b>=0)
	{
		i=l;j=r;
		while(j!=i)
		{
			while(!bits(tdat[i],b) && i<j) i++;
			while(bits(tdat[j],b) && j>i) j--;
			swap(i,j);
			draw_tdat();Delay(delayt);
		}
		if(!bits(tdat[r],b)) j++;
		RadixExchangeSort(l,j-1,b-1);
		RadixExchangeSort(j,r,b-1);
	}
}

UWORD bits(UWORD x,UWORD k)
{
	return((UWORD)((x>>k)&~(~0<<1)));
}

void HeapSort(void)
{
	register UWORD k,n=anz-1;

	for(k=(n>>1);k>=0;k--) downheap(n,k);
	draw_tdat();Delay(delayt);
	while(n)
	{
		swap(0,n);
		downheap(--n,0);
		draw_tdat();Delay(delayt);
	}
}

void downheap(UWORD n,UWORD k)
{
	register UWORD j,v;

	v=tdat[k];
	while(k<=(n>>1))
	{
		j=k+k;
		if(j<n && tdat[j]<tdat[j+1]) j++;
		if(v>=tdat[j]) break;
		tdat[k]=tdat[j];k=j;
	}
	tdat[k]=v;
}

/*============================================================================*/

void Message(char *title,char *text)
{
	MUI_RequestA(app1,0,0,title,"_Okay",text,NULL);
}

UBYTE Question(char *title,char *text)
{
	return((UBYTE)MUI_RequestA(app1,0,0,title,"_Okay|_Cancel",text,NULL));
}

/*============================================================================*/

void Wait1(void)
{
	struct IntuiMessage *imsg;
	ULONG iclass;
	USHORT icode;
	UBYTE quit=0;

	while(!quit)
	{
		WaitPort(gfxwin->UserPort);
		while(imsg=GetMsg(gfxwin->UserPort))
		{
			iclass	=imsg->Class;
			icode	=imsg->Code;
			ReplyMsg(imsg);
			switch(iclass)
			{
				case IDCMP_RAWKEY:
					switch(icode)
					{
						case 0x40:		/* Space */
						case 0x43:		/* Enter */
						case 0x44:		/* Return */
							quit=1;break;
					}
					break;
			}
		}
	}
}

void Wait2(void)
{
	struct IntuiMessage *imsg;
	ULONG iclass;
	USHORT icode;
	UBYTE quit=0;

	while(!quit)
	{
		WaitPort(gfxwin->UserPort);
		while(imsg=GetMsg(gfxwin->UserPort))
		{
			iclass	=imsg->Class;
			icode	=imsg->Code;
			ReplyMsg(imsg);
			switch(iclass)
			{
				case IDCMP_RAWKEY:
					switch(icode)
					{
						case 0x40:		/* Space */
						case 0x43:		/* Enter */
						case 0x44:		/* Return */
						case 0x45:		/* ESC */
							quit=1;break;
					}
					break;
				case IDCMP_CLOSEWINDOW:
					quit=1;break;
			}
		}
	}
}

/*============================================================================*/

void OpenAll(void)
{
	srand(time(NULL));
}

void CloseAll(void)
{
	if(main_win)	set(main_win,MUIA_Window_Open,FALSE);
	fail(app1,NULL);
}

/*============================================================================*/

int main(int argc,char *argv[])
{
	ULONG signals=0l;
	BOOL running=TRUE;

	init();
	OpenAll();

	app1 = ApplicationObject,
		MUIA_Application_Title,			"VisualSort",
		MUIA_Application_Version,		"$VER: VisualSort 1.0 (19.04.95)",
		MUIA_Application_Copyright,		"by Stefan Kost ©1995,",
		MUIA_Application_Author,		"Stefan Kost",
		MUIA_Application_Description,	"Visualisierung von Sortierprozessen",
		MUIA_Application_Base,			"VSORT",

		SubWindow, main_win = WindowObject,
			MUIA_Window_Title, "VisualSort V1.0",
        	MUIA_Window_ID   , MAKE_ID('S','O','M','A'),

	        WindowContents,VGroup,
				Child, HGroup,GroupFrameT("Settings"),
					Child, VGroup,
						Child, Label2("Sorttyp"),
   	   			      	Child, Label2("Datatyp"),
						Child, Label2("Swapct."),
						Child, Label2("   Size"),
						Child, Label2("  Delay"),
					End,
					Child, VGroup,
						Child, main_sorttyp = CycleObject,
							MUIA_Cycle_Entries,sorttyp,
							MUIA_Cycle_Active,ST_BUBBLE,
						End,
						Child, main_datatyp = CycleObject,
							MUIA_Cycle_Entries,datatyp,
							MUIA_Cycle_Active,DT_MERGED,
						End,
						Child, main_swapct = StringObject,StringFrame,End,
						Child, main_anz = StringObject,StringFrame,End,
						Child, main_delay = StringObject,StringFrame,End,
					End,
				End,
				Child, HGroup,GroupFrameT("Control"),
					Child, main_go = SimpleButton("Go"),
					Child, main_exit = SimpleButton("Exit"),
					Child, main_about = SimpleButton("About"),
				End,
			End,
		End,
	End;

	if(!app1) CloseAll();

/*
** Install notification events...
*/

	DoMethod(main_win,		MUIM_Notify,MUIA_Window_CloseRequest,TRUE,			app1,2,	MUIM_Application_ReturnID,ID_EXIT);

	DoMethod(main_go,		MUIM_Notify,MUIA_Pressed,FALSE,						app1,2,	MUIM_Application_ReturnID,ID_GO);
	DoMethod(main_exit,		MUIM_Notify,MUIA_Pressed,FALSE,						app1,2,	MUIM_Application_ReturnID,ID_EXIT);
	DoMethod(main_about,	MUIM_Notify,MUIA_Pressed,FALSE,						app1,2,	MUIM_Application_ReturnID,ID_ABOUT);

	DoMethod(main_sorttyp,	MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime, 		app1,2, MUIM_Application_ReturnID,ID_SORTTYP);
	DoMethod(main_datatyp,	MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime, 		app1,2, MUIM_Application_ReturnID,ID_DATATYP);
	DoMethod(main_swapct,	MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,	app1,2, MUIM_Application_ReturnID,ID_SWAPCT);
	DoMethod(main_anz,		MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,	app1,2, MUIM_Application_ReturnID,ID_ANZ);
	DoMethod(main_delay,	MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,	app1,2, MUIM_Application_ReturnID,ID_DELAY);

	sprintf(strbuf,"%d",anz);	set(main_anz,MUIA_String_Contents,strbuf);
	sprintf(strbuf,"%d",swapct);set(main_swapct,MUIA_String_Contents,strbuf);
	sprintf(strbuf,"%d",delayt);set(main_delay,MUIA_String_Contents,strbuf);

	set(main_win,MUIA_Window_Open,TRUE);
/*
** Cycle chain for keyboard control
*/
	while(running)
	{
		switch(DoMethod(app1,MUIM_Application_Input,&signals))
		{
			case MUIV_Application_ReturnID_Quit:
				running=FALSE;
				break;
			case ID_EXIT:
				if(Question("Exit ?",ques[0])) running=FALSE;
				break;
			case ID_GO:
				if(scr=LockPubScreen(0l))
				{
					wintags[2].ti_Data=anz;
					wintags[3].ti_Data=anz;
					wintags[7].ti_Data=scr;
					if(gfxwin=OpenWindowTagList(0l,wintags))
					{
						set(main_win,MUIA_Window_Sleep,TRUE);
						rp=*gfxwin->RPort;
						gen_tdat();draw_tdat();Wait1();
						switch(sortmode)
						{
							case 0: BubbleSort();break;
							case 1: SelectionSort();break;
							case 2: InsertionSort();break;
							case 3: ShellSort();break;
							case 4: QuickSort(0,anz-1);break;
							case 5: MergeSort(0,anz-1);break;
							case 6: RadixExchangeSort(0,anz-1,16);break;
							case 7: HeapSort();break;
						}
						Wait2();
						set(main_win,MUIA_Window_Sleep,FALSE);
						CloseWindow(gfxwin);
					}
					UnlockPubScreen(0l,scr);
				}
				break;
			case ID_ABOUT:
				Message("About",mess[0]);
				break;

			case ID_SORTTYP:
				get(main_sorttyp,MUIA_Cycle_Active,&tempvar);sortmode=(UBYTE)tempvar;
				break;
			case ID_DATATYP:
				get(main_datatyp,MUIA_Cycle_Active,&tempvar);datamode=(UBYTE)tempvar;
				switch(datamode)
				{
					case 0:	set(main_swapct,MUIA_Disabled,TRUE);break;
					case 1:	set(main_swapct,MUIA_Disabled,FALSE);break;
					case 2:	set(main_swapct,MUIA_Disabled,TRUE);break;
					case 3:	set(main_swapct,MUIA_Disabled,FALSE);break;
				}
				break;
			case ID_SWAPCT:
				get(main_swapct,MUIA_String_Contents,&tempstr);
				swapct=atoi(tempstr);
				break;
			case ID_ANZ:
				get(main_anz,MUIA_String_Contents,&tempstr);
				anz=atoi(tempstr);
				if(anz>maxanz)
				{
					anz=maxanz;sprintf(strbuf,"%d",anz);
					set(main_anz,MUIA_String_Contents,strbuf);
				}
				break;
			case ID_DELAY:
				get(main_delay,MUIA_String_Contents,&tempstr);
				tempvar=atoi(tempstr);
				if(tempvar>255)
				{
					delayt=255;sprintf(strbuf,"%d",delayt);
					set(main_delay,MUIA_String_Contents,strbuf);
				}
				else delayt=(UBYTE)tempvar;
				break;
		}
		if(running && signals) Wait(signals);
	}
	CloseAll();
}
