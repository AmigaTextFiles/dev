include "inc/utility/tagitem.inc";

def ICM_Dummy = ($0401);
def ICM_SETLOOP = ($0402);
def ICM_CLEARLOOP = ($0403);
def ICM_CHECKLOOP = ($0404);

def ICA_Dummy = (TAG_USER+$40000);

def ICA_TARGET = (ICA_Dummy+1);
def ICA_MAP = (ICA_Dummy+2);
def ICSPECIAL_CODE = (ICA_Dummy+3);

def ICTARGET_IDCMP = (~0);

