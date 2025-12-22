#ifndef MUIDIFFGUI_H
#define MUIDIFFGUI_H
/****************************************************************************
*      Projet                    :  AMuiDiff
*      Fichier                   :  AMuiDiffGui.h
*
*      Nom Prog                  :
*      Version                   :
*      Date de conception        :
*      Dernière modification     :
*
*      Description               :
*
*      Auteurs                   :  Stephane SARAGAGLIA
*
*      Plateforme                :  A1200 Mc68060/PPC603e
*      Systeme                   :  AmigaOS 3.5
*
*      Programming language      :
*
*          Copyright (C) Stephane SARAGAGLIA - (All rights reserved)
*
****************************************************************************/

/****************************************************************************
 * INCLUDES.
 ****************************************************************************/

// --------------------------------------------------------------------------
// MUI LIB
// --------------------------------------------------------------------------
#include <libraries/mui.h>
#include <MUI/TextEditor_mcc.h>

// --------------------------------------------------------------------------
// AmuiDiff
// --------------------------------------------------------------------------
#include "AMD_DiffCmdWrapping_protos.h"
#include "ss_amiga_lib_tools_protos.h"

/****************************************************************************
 * DEFINE.
 ****************************************************************************/
#define AMD_STR_COLORTOKEN_ADD "\33p[6]"
#define AMD_STR_COLORTOKEN_CHG "\33p[2]"
#define AMD_STR_COLORTOKEN_REM "\33p[7]"
#define AMD_STR_SEPARATOR "\33[s:2]\n"


/****************************************************************************
 * TYPES
 ****************************************************************************/
enum { MEN_PROJET=1, MEN_OUVRIR1, MEN_OUVRIR2, MEN_RELOAD1, MEN_RELOAD2, MEN_EDIT1, MEN_EDIT2, MEN_QUITTER, MEN_APROPOS};

typedef struct
{
	amd_diff_type_t  vdc_difftype;
	char             *vdc_chunk;
	unsigned long    vdc_nblines;
	unsigned long    vdc_nblines_max;
}viewbuffer_diff_chunk_t;
  
class AmdFile
{
private:
	char 	*amdf_file_name;
	char 	*amdf_filebuffer;
	char 	*amdf_viewbuffer;
	Object  *amdf_txtscroll;
	Object  *amdf_txtframe;
	Object  *amdf_txttext;
	Object  *amdf_string;
	ULONG   amdf_filebuffersize;
	ULONG   amdf_viewbuffersize;
	ULONG   amdf_viewbuffer_nbcols;

	ss_list_t amdf_viewbuffer_chunks;

public:
	char* get_file_name(void) {return amdf_file_name;}
	LONG  newfile(const char *pm_newfile_name);
	LONG  reallocBufferviewWithSize(unsigned long pm_size);

	long getLineForFileBufferOffset(long pm_offset);

	void updategui_WithFileBuffer(void);
	void updategui_WithViewBuffer(void);

	AmdFile();
	AmdFile(Object *pm_scroll, Object *pm_frame, Object *pm_text, Object *pm_button);
	virtual ~AmdFile();
	long setCursorOnLigne(unsigned long pm_linenumber);
	viewbuffer_diff_chunk_t* addViewBufferChunk(unsigned long pm_begin_line, unsigned long pm_nblines, unsigned long pm_maxnblines, amd_diff_type_t pm_diff_type);
	unsigned long calculateViewBufferSize(void);
	long updateViewBufferWithChunkList(void);
	void setVbNbCols(ULONG pm_nbcols) {amdf_viewbuffer_nbcols = pm_nbcols;}
	ULONG getVbNbColMax(void);
	void resetViewBufferChunkList(void);
	void update_views_with_error(char *pm_file_name);
	BOOL is_scroll(Object *pm_scroll){return(pm_scroll==amdf_txtscroll);}
	char* getFileNameFromStringGadget(void);
	void resetFileNameStringGadget(void);
};

class AmdGui
{
public:
	typedef enum{AMD_ERROR, AMD_OK}amd_state_t;
protected:
	Object  *amd_about_win;
	APTR    amd_app;
	APTR	amd_cy_diff;
	APTR    amd_txt_nbdiffs;
	struct	MUI_CustomClass	*amd_editor_mcc;
	char **	 amd_cy_diff_entries;
	Object  *amd_slider_vue1_vertical;
	Object  *amd_slider_vue2_vertical;
	Object  *amd_str_fichier1;
	Object  *amd_str_fichier2;
	Object	*amd_tb_toolbar1;
	Object	*amd_tb_toolbar2;

	amd_state_t amd_state;

	AmdFile *amd_file1;
	AmdFile *amd_file2;

	ss_list_t diff_cycle_list;

	sslib_filereq_t amd_file_req1;
	sslib_filereq_t amd_file_req2;

	LONG openReqFile(AmdFile *pm_amdf, sslib_filereq_t *pm_filereq);
	LONG openFile(AmdFile *pm_amdf, char *pm_filename);

public:
	typedef enum
	{
		AMD_Dummy = (TAG_USER | ('S'<<16) | ('S'<<8)),
		AMD_FILE1,
		AMD_FILE2,
		AMD_REQ_FILE1,
		AMD_REQ_FILE2,
		AMD_RELOAD1,
		AMD_RELOAD2,
		AMD_EDIT1,
		AMD_EDIT2,
		AMD_DIFF,
		AMD_SWAP
	}idcmp_t;




	AmdGui();
	virtual ~AmdGui();
	APTR    	get_app(void)          {return amd_app;}
	amd_state_t get_state(void) 	   {return amd_state;}
	AmdFile*    get_amdf1(void)        {return amd_file1;}
	AmdFile*    get_amdf2(void)        {return amd_file2;}
	const char* get_filename1(void)    {return ((const char*)(amd_file1->get_file_name()));}
	const char* get_filename2(void)    {return ((const char*)(amd_file2->get_file_name()));}

	char* getFileName1FromStringGadget(void)    {return ((amd_file1 != NULL) ? (amd_file1->getFileNameFromStringGadget()) : NULL);}
	char* getFileName2FromStringGadget(void)    {return ((amd_file2 != NULL) ? (amd_file2->getFileNameFromStringGadget()) : NULL);}

	void resetFileNameStringGadget1(void)    {if(amd_file1 != NULL) amd_file1->resetFileNameStringGadget();}
	void resetFileNameStringGadget2(void)    {if(amd_file2 != NULL) amd_file2->resetFileNameStringGadget();}

	LONG        update_views_with_diff(ss_list_t *pm_diff_list);
	void updategui_WithNbDiff(unsigned long pm_nbdiff);
	long reset_cycle(void);
	long set_cycle(void);
	void freeCycle(void);
	long setCursorOnLigne(unsigned long pm_linenumber);
	ss_list_t* get_cyclelist(void){return(&diff_cycle_list);}
	void makeVerticalSlidersDependent(void);
	void makeVerticalSlidersIndependent(void);
	void openAboutWindow(void);
	void update_views_with_error(char *pm_file_name);
	BOOL is_scroll1(Object *pm_scroll);
	BOOL is_scroll2(Object *pm_scroll);
	LONG openReqFile1(void);
	LONG openReqFile2(void);
	LONG openFile1(char *pm_filename);
	LONG openFile2(char *pm_filename);
	LONG doButton1Shine(void);
	LONG doButton2Shine(void);
	LONG doButton1Background(void);
	LONG doButton2Background(void);
	void resetNbDiffs(void);
};

  

#endif
