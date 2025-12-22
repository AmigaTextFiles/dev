rotate()
{
USHORT r;
r=colortable[2];
colortable[2]=colortable[3];
colortable[3]=colortable[4];
colortable[4]=r;
LoadRGB4(&viewport,colortable,(long)8);
}

