String[] text_File_lines = loadStrings("HW-regs.txt");
String[] text1 = new String[114]; String[] text2 = new String[114];
String[] text3 = new String[114]; String[] text4 = new String[114];
String[] text5 = new String[114]; String[] text6 = new String[114];
//------------------------------------------------------------------------------------      
// 000 BLTDDAT     0000    106 BPLCON3     0C00   
println("HWregs:");
for (int j= 0; j < text_File_lines.length; j++) {
  text1[j]=text_File_lines[j].substring(0, 3);    // 000  
  text2[j]=text_File_lines[j].substring(4, 11);   // BLTDDAT
  text3[j]=text_File_lines[j].substring(16, 20);  // 0000  
  text4[j]=text_File_lines[j].substring(24, 27);  // 106  
  text5[j]=text_File_lines[j].substring(28, 35);  // BPLCON3 
  text6[j]=text_File_lines[j].substring(40, 44);  // 0C00
}

for (int j= 0; j < text_File_lines.length; j++) {
  println("dc.w  $"+text1[j]+",$"+text3[j]+" ; "+text2[j]); }

for (int j= 0; j < text_File_lines.length; j++) {
  println("dc.w  $"+text4[j]+",$"+text6[j]+" ; "+text5[j]); }
