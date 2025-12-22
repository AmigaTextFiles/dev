int DIWSTRT= 0x81;    
int PixelproZeile=320;
int Hoehe=256;
int DIWSTOP=0;         
int DDFSTRT=0;
int DDFSTOP=0;

void setup(){
  ddf_berechnung();
  //ddf_berechnung_all();
}

void ddf_berechnung(){
   println("--- DDF-Berechnung ---");
   println("DIWSTRT-Werte von $00 bis $FF möglich");
   println("DIWSTOP-Werte von $(1)00 bis $(1)FF möglich");
      
  //DDFSTRT=(HSTRT/2)*8,5 AND $FFF8        //  Bsp: ($81/2)-8,5 AND $FFF8    =$38
  //DDFSTOP=DDFSTRT+(PixelproZeile/2-8)    //  $18+(320/2-8)        =$d0 
  
    DDFSTRT=(((DIWSTRT*10/2)-85)/10)& 0xF8;
    DDFSTOP=DDFSTRT+(PixelproZeile/2-8);
    print("DIWSTRT ="+hex(DIWSTRT,2));
    DIWSTOP=DIWSTRT+PixelproZeile;
    print("    DIWSTOP ="+hex(DIWSTOP,3));
    print("   DDFSTRT ="+hex(DDFSTRT,2));  
    print("   DDFSTOP = "+hex(int(DDFSTOP),2)); 
   // print("   Pixel pro Zeile = "+PixelproZeile); 
   // println("   Höhe = "+Hoehe); 
  
}


void ddf_berechnung_all(){
   println("--- DDF-Berechnung ---");
   println("DIWSTRT-Werte von $00 bis $FF möglich");
   println("DIWSTOP-Werte von $(1)00 bis $(1)FF möglich");
       
    for(int i=0x00; i<=0x1FF; i++){
      DDFSTRT=(((i*10/2)-85)/10)& 0xF8; 
      
      if (DDFSTRT >= 0x18 && DDFSTRT <= 0xD8){
        print("DIWSTRT ="+hex(i,3));
        println("   DDFSTRT ="+hex(DDFSTRT,2));
      }
    }    
}
