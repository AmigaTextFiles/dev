// IW 1 - Instruction-word 1
int VP;        // Bit 8-15   (0x00 - 0xFF  0 bis 255)
int HP;        // Bit 1-7    (0x00 - 0xE2) 2pixelgenau 
int IW1_bit0;  // Bit 0 (Für MOVE auf 0 und für WAIT/SKIP auf 1 setzen)

// IW 2 - Instruction-word 2
int bfd;       // Bit 15
int VE;        // Bit 8-14   (0x00 - 0x7F  0 bis 127)      VE=$07 von dc.w $0107,$87fe  
int HE;        // Bit 1-7    (0x00 - 0xE2) 2pixelgenau 
int IW2_bit0;  // Bit 0 (Für WAIT auf 0 und für SKIP auf 1 setzen)

int VP_dcw, HP_dcw, VE_dcw, HE_dcw;    // Eingabe als "dc.w  $3007,$FFFE"

void setup() { 
  parser();  
  intialisieren();
  ausgabe();
  vertikal();
  horizontal();
}

void parser(){ 
// ---------------------------hier ändern !!!-----------------------------------------
  String copperinstr = "dc.w  $0207,$87fe";    // Eingabe als "dc.w  $3007,$FFFE"
//------------------------------------------------------------------------------------     
  VP_dcw = unhex(copperinstr.substring(7, 9));     // println(hex(VP_dcw,2)); 
  HP_dcw = unhex(copperinstr.substring(9, 11));    // println(hex(HP_dcw,2));
  VE_dcw = unhex(copperinstr.substring(13, 15));   // println(hex(VE_dcw,2));
  HE_dcw = unhex(copperinstr.substring(15, 17));   // println(hex(HE_dcw,2));
  }

void intialisieren(){
   
// z.B. dc.w $0107,$87fe ,   //      dc.w $3007,$FFFE  
//  VP_dcw = 0x31; HP_dcw =0x07; VE_dcw = 0xFF; HE_dcw=0xfe;
// Instruktion-word 1--------------------------------------------------------------
  VP=VP_dcw & 0xFF;         // (0xFF=0b1111.1111)   VP=0x01;
  HP=HP_dcw & 0xFE;         // (0xFE=0b1111.1110)   HP=0x06; 
  IW1_bit0=HP_dcw & 0x01;   // (0x01=0b0000.0001)   IW1_bit0=0x01;
   
// Instruktion-word 2--------------------------------------------------------------  
  bfd=VE_dcw & 0x80;        // (0x80=0b1000.0000)   bfd=0x01;
  VE=VE_dcw & 0x7F;         // (0x7F=0b0111.1111)   VE= ; 
  HE=HE_dcw & 0xFE;         // (0xFE=0b1111.1110)   HE=0xfe;
  IW2_bit0=HE_dcw & 0x01;   // (0x01=0b0000.0001)   IW2_bit0=0x01;
  
  /*
  println("VP "+hex(VP,2));
  println("HP "+hex(HP,2));
  println("IW1_bit0 "+hex(IW1_bit0,2));
  
  println("bfd "+hex(bfd,2));
  println("VE "+hex(VE,2));
  println("HE "+hex(HE,2));
  println("IW2_bit0 "+hex(IW2_bit0,2));
  */
}

void ausgabe() {   // Copperanweisung ausgeben
   println("--- Copperanweisung ---");
   println(" für: dc.w  $"+hex(VP_dcw,2)+hex(HP_dcw,2)+",$"+hex(VE_dcw,2)+hex(HE_dcw,2));

   println(" VP="+hex(VP,2)+
           " dez:"+VP+
           " bin:"+binary(VP,8)+
           " ,HP="+hex(HP,2)+
           " dez:"+HP+
           " bin:"+binary(HP,8)+
           " Bit 0="+IW1_bit0+
           " 0=move, 1=wait oder skip");
           
    if (bfd==0x80) bfd=1;
   
   println(" VE="+hex(VE,2)+
           " dez:"+VE+
           " bin:"+binary(VE,8)+
           " ,HE="+hex(HE,2)+
           " dez:"+HE+
           " bin:"+binary(HE,8)+
           " Bit 0="+IW2_bit0+
           " 0=wait, 1=skip"+
           " bfd: "+hex(bfd,2));
}

void vertikal(){
   int [] RP = new int [256];              // bei Initialisierung alle 0 - 0 heißt keine Maskierung (0 - bleiben übrig)    
   byte VE_Bit_pruef_maske= 0b0000001;     // VE wird in Schleife jeweils um 1Bit nach rechts verschoben
                                           // und mit diesem Wert verglichen, wird benötigt um die Anzahl
                                           // der Bitstellen zu ermitteln
   byte VE_Bit_stelle=0;                   // VE=$0f =VE=x000.0111, d.h. 3 Stellen sind relevant      
   int bitmaske = 1;                       // 0b0000.0001 
   int bitmaske_shift=0;
   
   int RP_shift=0;                         // geshiftetes RP - Rasterposition
   int VP_shift=0;                         // geshiftetes VP - Vertical position
   int VE_shift=0;                         // geshiftetes VE - Vertical enable
   
   int RP_mask=1;
   int VP_mask=0;
   int VE_mask=0;
// ------------------------------------------------------------------------- 
// VE_Bit Stelle ermitteln an der am weitesten links eine 1 steht 
   VE_shift=VE;
   for(byte i=0;i<8;i++){                  // maximal 8 Stellen
      if(VE_shift==VE_Bit_pruef_maske)   {
       VE_Bit_stelle=byte(i+1);  break;  }
       VE_shift=byte(VE_shift>>1);         // nach rechts verschieben      
   }
//------------------------------------------------------------------------- 
// Berechnungsalgorithmus 
   int shiftwert =7;                      // Shift Startwert 
     
   for(int i=0;i<VE_Bit_stelle;i++){      // äussere Schleife, über Anzahl der relevanten Bitstellen
       bitmaske_shift = bitmaske<<  shiftwert;  // print("bitmaske shift       ");   println(binary(bitmaske_shift));       // Bitmaske = 0b0000.0001
       VP_shift       = VP      <<  shiftwert;  // print("VP shift             ");   println(binary(VP_shift));             // nach ganz links verschieben
       VE_shift       = VE      <<  shiftwert;  // print("VE shift             ");   println(binary(VE_shift));             // nach ganz links verschieben
       
       VP_mask        = VP_shift  &  0x80;       //print("VP mask              ");   println(binary(VP_mask));              // nur Bit 8 ist relevant
       VE_mask        = VE_shift  &  0x80;       //print("VE mask              ");   println(binary(VE_mask));              // nur Bit 8 ist relevant
       
       if       (VE_mask==0x00) ;       // println("alles i.O. - hier gibts nichts zu tun");
       else if  (VE_mask==0x80)  {      // println("VP-Bit beachten");   // Bitzustand von VP muss erfüllt werden
       
       VP_mask     = VP_mask  >> 7;     // ganz nach rechts verschieben
       
       for(int j=0;j<256;j++){          // innere Schleife - über alle 256 (311) möglichen Rasterzeilen           
           // wenn VE-Bit 1 ist muss nun auf das zugehörige VP-Bit geachtet werden         
           RP_shift = j >> i;                       //   print("RP_shift             ");  println(binary(RP_shift));  
            // bei allen Rasterzeilen muss dieses Bit passen, wenn 1 dann 1, wenn 0 dann 0   
           RP_mask  =  RP_shift & bitmaske;         //   print("RP_mask              ");  println(binary(RP_mask));  
                                                    //   print("VP_mask              ");  println(binary(VP_mask)); 
           if(RP_mask == VP_mask){;}                //   println("iO");
               else { RP[j]=1; } // else            //   println("niO");  // wenn Bedingung nicht erfüllt ist, dann löschen 
           } // for            
           } // else if
       shiftwert--;
   } // for
  
// -------------------------------------------------------------------------  
     println("");
     println("--- Alle vertikalen maskierten Positionen ---"); 
   int zaehler = 0;
     for(int i=0; i<256;i++)
     if(RP[i]==0){zaehler++; 
       if (i<0x80){ 
         print(hex(i,2)); print("   "); print(binary(i,8)); print("   dez= "+i);  println("");}
         
       if (i>=0x80){
         print(hex(i,2)); print("   "); print(binary(i,8)); print("   dez= "+i);  println("  Position ab 0x80 kann nicht maskiert werden"); }    
       
   }
  println("Das sind "+zaehler+" Treffer.");  
}


void horizontal(){
   int [] RP = new int [256];
   byte HE_Bit_pruef_maske= 0b0000001;    
   byte HE_Bit_stelle=0;      
   int bitmaske = 1;
   int bitmaske_shift=0;
   
   int RP_shift=0;
   int HP_shift=0;
   int HE_shift=0;
   
   int RP_mask=1;
   int HP_mask=0;
   int HE_mask=0;   

// ------------------------------------------------------------------------- 
// HE_Bit Stelle ermitteln an der am weitesten links eine 1 steht 
   HE_shift=HE;
   for(byte i=0;i<8;i++){  // maximal 8 Stellen
      if(HE_shift==HE_Bit_pruef_maske)   {
       HE_Bit_stelle=byte(i+1);  break;  }
      HE_shift=byte(HE_shift>>1);
   }
//------------------------------------------------------------------------- 
// Berechnungsalgorithmus 
   int shiftwert =7;     
   for(int i=0;i<HE_Bit_stelle;i++){
       bitmaske_shift = bitmaske<<  shiftwert;
       HP_shift       = HP      <<  shiftwert;
       HE_shift       = HE      <<  shiftwert;
       
       HP_mask        = HP_shift  &  0x80;
       HE_mask        = HE_shift  &  0x80;
       
       if       (HE_mask==0x00) ; 
       else if  (HE_mask==0x80) { 
       
       HP_mask     = HP_mask  >> 7;
       
       for(int j=0;j<256;j++){          
           RP_shift = j >> i; 
           RP_mask  =  RP_shift & bitmaske;
           if(RP_mask == HP_mask){;} 
               else { RP[j]=1; }
              } // for            
              } // else if
       shiftwert--;
   } // for  
// -------------------------------------------------------------------------  
     println(); println("--- Alle horizontalen maskierten Positionen ---"); 
   int zaehler = 0;
     for(int i=0; i<256;i++)  if(RP[i]==0) {zaehler++; print(hex(i,2)); print("   "); print(binary(i,8)); println("   dez= "+i);  }
   println("Das sind "+zaehler+" Treffer.");  
}
