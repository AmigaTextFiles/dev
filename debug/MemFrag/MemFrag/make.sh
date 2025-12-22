#
# Make.sh  - GMD 20 Mar 90
#
#
#  Standard shell script to make a file , and generate the date 
#
echo  "char *MakeDate[] = \"\\" >date.c
date | input a 
echo $a\" ";" >>date.c
date
#
#
make MemFrag
#
#  remove next stuff if you're not GMD !
#
cp D:MemFrag TEMP:
cp MemFrag D:
echo " MemFrag copied to D: and TEMP:"
