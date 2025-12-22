include "inc/exec/types.inc";
include "inc/intuition/intuition.inc";
include "inc/utility/tagitem.inc";

def POINTERA_Dummy = (TAG_USER+$39000);

def POINTERA_BitMap = (POINTERA_Dummy+$01);
def POINTERA_XOffset = (POINTERA_Dummy+$02);
def POINTERA_YOffset = (POINTERA_Dummy+$03);
def POINTERA_WordWidth = (POINTERA_Dummy+$04);
def POINTERA_XResolution = (POINTERA_Dummy+$05);
def POINTERA_YResolution = (POINTERA_Dummy+$06);

def POINTERXRESN_DEFAULT = 0;
def POINTERXRESN_140NS = 1;
def POINTERXRESN_70NS = 2;
def POINTERXRESN_35NS = 3;

def POINTERXRESN_SCREENRES = 4;
def POINTERXRESN_LORES = 5;
def POINTERXRESN_HIRES = 6;

def POINTERYRESN_DEFAULT = 0;
def POINTERYRESN_HIGH = 2;
def POINTERYRESN_HIGHASPECT = 3;
def POINTERYRESN_SCREENRES = 4;
def POINTERYRESN_SCREENRESASPECT = 5;

