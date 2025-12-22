/*---------------------------------------------------*
  Gadgets created with GadgetEd V2.2a
  which is (c) Copyright 1990-91 by Jaba Development
  written by Jan van den Baard
 *---------------------------------------------------*/

SHORT Border0_pairs[] = {
  0,0,0,88,1,87,1,0,380,0 };
SHORT Border1_pairs[] = {
  1,88,380,88,380,1,381,0,381,88 };
SHORT Border2_pairs[] = {
  0,0,0,10,1,9,1,0,370,0 };
SHORT Border3_pairs[] = {
  1,10,370,10,370,1,371,0,371,10 };
SHORT Border4_pairs[] = {
  0,0,0,48,1,47,1,0,369,0 };
SHORT Border5_pairs[] = {
  1,48,369,48,369,1,370,0,370,48 };

struct Border Border_bord[] = {
  1,1,2,0,JAM1,5,(SHORT *)&Border0_pairs,&Border_bord[1],
  1,1,1,0,JAM1,5,(SHORT *)&Border1_pairs,&Border_bord[2],
  6,3,2,0,JAM1,5,(SHORT *)&Border2_pairs,&Border_bord[3],
  6,3,1,0,JAM1,5,(SHORT *)&Border3_pairs,&Border_bord[4],
  7,16,2,0,JAM1,5,(SHORT *)&Border4_pairs,&Border_bord[5],
  7,16,1,0,JAM1,5,(SHORT *)&Border5_pairs,NULL };

struct IntuiText rnd_text[] = {
  1,0,JAM1,95,5,NULL,(UBYTE *)"- PatchGE version 1.0 -",&rnd_text[1],
  1,0,JAM1,11,18,NULL,(UBYTE *)"File____________________:",&rnd_text[2],
  1,0,JAM1,11,27,NULL,(UBYTE *)"Number of gadgets_______:",&rnd_text[3],
  1,0,JAM1,11,36,NULL,(UBYTE *)"Type of gadgets_________:",&rnd_text[4],
  1,0,JAM1,11,45,NULL,(UBYTE *)"Number of texts_________:",&rnd_text[5],
  1,0,JAM1,11,54,NULL,(UBYTE *)"Screen type_____________:",NULL };

struct Gadget rnd = {
  NULL,0,0,1,1,GADGHNONE,NULL,BOOLGADGET,
  (APTR)&Border_bord[0],NULL,&rnd_text[0],NULL,NULL,NULL,NULL };

SHORT QUIT_pairs0[] = {
  0,0,0,18,1,18,1,0,113,0 };

SHORT QUIT_pairs1[] = {
  1,18,113,18,113,1,114,0,114,18 };

struct Border QUIT_bord[] = {
  0,0,2,0,JAM1,5,(SHORT *)&QUIT_pairs0,&QUIT_bord[1],
  0,0,1,0,JAM1,5,(SHORT *)&QUIT_pairs1,NULL };

struct IntuiText QUIT_text = {
  1,0,JAM1,40,6,NULL,(UBYTE *)"Quit",NULL };

#define QUIT_ID    5

struct Gadget QUIT = {
  &rnd,263,68,115,19,
  GADGHCOMP,
  RELVERIFY,
  BOOLGADGET,
  (APTR)&QUIT_bord[0],NULL,
  &QUIT_text,NULL,NULL,QUIT_ID,NULL };

SHORT SAVE_pairs0[] = {
  0,0,0,18,1,18,1,0,113,0 };

SHORT SAVE_pairs1[] = {
  1,18,113,18,113,1,114,0,114,18 };

struct Border SAVE_bord[] = {
  0,0,2,0,JAM1,5,(SHORT *)&SAVE_pairs0,&SAVE_bord[1],
  0,0,1,0,JAM1,5,(SHORT *)&SAVE_pairs1,NULL };

struct IntuiText SAVE_text = {
  1,0,JAM1,6,6,NULL,(UBYTE *)"Save GE Patch",NULL };

#define SAVE_ID    4

struct Gadget SAVE = {
  &QUIT,136,68,115,19,
  GADGHCOMP,
  RELVERIFY,
  BOOLGADGET,
  (APTR)&SAVE_bord[0],NULL,
  &SAVE_text,NULL,NULL,SAVE_ID,NULL };

SHORT LOAD_pairs0[] = {
  0,0,0,18,1,18,1,0,113,0 };

SHORT LOAD_pairs1[] = {
  1,18,113,18,113,1,114,0,114,18 };

struct Border LOAD_bord[] = {
  0,0,2,0,JAM1,5,(SHORT *)&LOAD_pairs0,&LOAD_bord[1],
  0,0,1,0,JAM1,5,(SHORT *)&LOAD_pairs1,NULL };

struct IntuiText LOAD_text = {
  1,0,JAM1,10,6,NULL,(UBYTE *)"Load GE file",NULL };

#define LOAD_ID    3

struct Gadget LOAD = {
  &SAVE,8,68,115,19,
  GADGHCOMP,
  RELVERIFY,
  BOOLGADGET,
  (APTR)&LOAD_bord[0],NULL,
  &LOAD_text,NULL,NULL,LOAD_ID,NULL };

struct NewWindow new_window = {
  117,25,385,91,0,1,
  GADGETUP+CLOSEWINDOW,
  NOCAREREFRESH+SMART_REFRESH+ACTIVATE+RMBTRAP,
  &LOAD,NULL,
  NULL,NULL,NULL,
  150,50,640,256,WBENCHSCREEN };


#define NEWWINDOW   &new_window
#define WDBACKFILL   0
#define FIRSTGADGET &LOAD
#define FIRSTTEXT   &rnd_text[0]
#define FIRSTBORDER &Border_bord[0]
