include "inc/utility/tagitem.inc";

def TDECK_Dummy = (TAG_USER+$05000000);

def TDECK_Mode = (TDECK_Dummy+1);
def TDECK_Paused = (TDECK_Dummy+2);
def TDECK_Tape = (TDECK_Dummy+3);
def TDECK_Frames = (TDECK_Dummy+11);
def TDECK_CurrentFrame = (TDECK_Dummy+12);

def BUT_REWIND = 0;
def BUT_PLAY = 1;
def BUT_FORWARD = 2;
def BUT_STOP = 3;
def BUT_PAUSE = 4;
def BUT_BEGIN = 5;
def BUT_FRAME = 6;
def BUT_END = 7;

