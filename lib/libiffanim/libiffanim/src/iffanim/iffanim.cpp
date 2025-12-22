#include <fstream>

#include "iffanim.h"


/******************************************************************************/
IffAnim::IffAnim()
{
 InitAttributes();
}


/******************************************************************************/
IffAnim::~IffAnim()
{
 Close();
}


/******************************************************************************/
//free buffers
void IffAnim::Close()
{
 if(!(file_loaded))
   return;
    
 //free display ready image buffer
 if(disp_frame != NULL)
   delete[] (char*)disp_frame;
 if(disp_cmap != NULL)
   delete[] (char*)disp_cmap;

 if(prev_disp_frame != NULL)
   delete[] (char*)prev_disp_frame;
 if(prev_disp_cmap != NULL)
   delete[] (char*)prev_disp_cmap;

 //delete curframe and prevframe
 if(curframe != NULL)
   delete[] (char*)curframe;
 if(prevframe != NULL)
   delete[] (char*)prevframe;

 //delete every frame in the list
 for(int i = 0; i < nframes; i++)
 {
   if(frame[i].data != NULL)
     delete[] (char*)frame[i].data;
   if(frame[i].cmap != NULL)
     delete[] (char*)frame[i].cmap;
 }
 //delete frame list
 if(frame != NULL)
   delete[] frame;

 //delete audio data and lists
 if(audio.dataoffset != NULL)
   delete[] audio.dataoffset;
 if(audio.data != NULL) {
   delete[] audio.data;
 }

 InitAttributes();    //reset (init) buffer related attributes
}


/******************************************************************************/
//open and read anim file to memory, init to first frame
int IffAnim::Open(char *fname)
{
 fstream file;

 //make sure no file is opened and buffers are deleted
 Close();

 //set default attributes
 SetLoopAnim(false);  // so when looping after the last frame, frame 2 follows 
 SetLoop(true);       // so the "next frame" of the last frame is the first frame

 //open file
 file.open(fname, ios::in | ios::binary);
 if(file.is_open() == false) {        
   sprintf(errorstring,"Can't open file\n");
   return -1;
 }

 //count number of frames, verify file structure
 nframes = GetNumFrames(&file);
 if(nframes <= 0) {
   sprintf(errorstring,"%s%s",errorstring,"No frame found\n");
   return -1;
 }

 //load frames to memory (fills frame list), set format specs
 if(ReadFrames(&file) == -1) {
   sprintf(errorstring,"%s%s",errorstring,"Couldn't load animation\n");
   Close();
   return -1;
 }

 //allocate buffer for delta decoded frame (a scanline is a multiple of 16 bit in an ILBM chunk)
 int pitch_16 = (w + 1) / 2 * 2;
 curframe =  new char[pitch_16 * bpp * h];
 prevframe = new char[pitch_16 * bpp * h]; 
 
 if((curframe == NULL) || (prevframe == NULL))
   return -1;

 //determine display format
 if(bpp <= 8 && ham == false)
   disp_bpp = 8;
 else
   disp_bpp = 24;

 //allocate buffer for display frame
 disp_pitch = (((w * disp_bpp / 8) + (IFFANIM_PITCH - 1)) / IFFANIM_PITCH) * IFFANIM_PITCH;  // pitch of scanline: rounding up to next multiple of IFFANIM_PITCH bytes
 disp_frame = new char[disp_pitch * h];
 prev_disp_frame = new char[disp_pitch * h];

 //allocate buffer for display "cmap", if color map is neccessary
 if(disp_bpp <= 8) {
   disp_cmap = new char[(1 << disp_bpp ) * 4];  // 4 byte color entry per color
   prev_disp_cmap = new char[(1 << disp_bpp ) * 4];
 }
 PrintInfo();  //create info string

 file_loaded = true;

 Reset();  //init to first frame
 return 0;
}


/******************************************************************************/
bool IffAnim::is_open()
{
 return file_loaded;
}


/******************************************************************************/
char *IffAnim::GetError()
{
 return errorstring;
}


/******************************************************************************/
//init member variables to state before anim file is loaded, a file must not be loaded
void IffAnim::InitAttributes()
{
 num_disp_frames = 0;
     
 file_loaded = false;
 sprintf(formatinfo,"");   //clears information text string
 disp_frame = NULL;
 disp_cmap = NULL;
 curframe = NULL;
 prevframe = NULL;
 frame = NULL;
 
 disp_frame = NULL;
 disp_cmap  = NULL;
 prev_disp_frame = NULL;
 prev_disp_cmap  = NULL;
 
 audio.data = NULL;
 audio.dataoffset = NULL;
 audio.datasize = 0;
 audio.freq = 0;
 audio.nch = 0;
}






/******************************************************************************/
//src must be in original bitplanar format, destination is chunky
//cmap pointer must point to existing palette (R,G,B format)
//"hambits" must be 6 or 8
int IffAnim::ConvertHamTo24bpp(void *dst_, void *src_,  void *cmap_, int w, int h, int hambits, int dst_pitch)
{
   

 int i,j,k;        //loop counter
 int data, mode;   //parts of a HAM value
 
 static char colbuf[3];    //color component buffer: R,G,B
 
 unsigned char *dstL = (unsigned char*)dst_; //start of current line in destination
 unsigned char *srcL = (unsigned char*)src_; //start of current line in source
 unsigned char *src,*dst;                    //working pointers
 
 int bitpos;               //bit position in a plane of the soure data
 char* cmap = (char*)cmap_;
 
 int bitplane_pitch = (w + 15) / 16 * 2;     //pitch of a bitplane multiple of 16 bit  in bytes
 int src_pitch = bitplane_pitch * hambits;   //pitch of line of bitplanes
 
 int modeshift = hambits - 2;           //to shift mode bits into correct useful position
 int datamask =  (1 << modeshift) - 1;  //to mask mode bits
 int datashift = 10 - hambits;          //to shift the data to upper bits for 8bit color component value


 if((hambits != 8) && (hambits != 6))
   return -1;


 for(j = 0; j < h; j++) // for every line
 {
   dst = dstL;
   memcpy(colbuf, cmap, 3);  //set to border color (index 0)
   for(i = 0; i < w; i++)    //for every pixel of line
   {

     data = 0;
     bitpos = i;
     src = srcL + (bitpos / 8);     //position of the first byte to read
     bitpos = 7 - (bitpos & 0x7);
     for(k = 0; k < hambits; k++)
     {
       data |= ((*src >> bitpos) & 0x1) << k;  //shift to bit position 0, then to it's right position
       src += bitplane_pitch;
     }

     mode = data >> modeshift;   //upper 2 bits
     data = data & datamask;     //lower 6 bits

     //change color component
     switch(mode) {
       case 0x0: memcpy(colbuf, cmap + (data * 3), 3); break; //RGB values from color map
       case 0x1: colbuf[2] = data << datashift; break;    //change blue upper bits
       case 0x2: colbuf[0] = data << datashift; break;    //change red upper bits
       case 0x3: colbuf[1] = data << datashift; break;    //change green upper bits
     }
     memcpy(dst, colbuf, 3); //write RGB color to dst
     dst += 3;
   }
   dstL += dst_pitch;
   srcL += src_pitch;
 } 
 return 0;
}


/******************************************************************************/
//convert a bitplanar frame to chunky
//converts also bits per pixel (low to high only, make sure: bitssrc <= bitsdst)
int IffAnim::BitplanarToChunky(void *dst_, void *src_,  int w, int h, int bitssrc, int bitsdst, int dst_pitch)
{
 unsigned char *dst = (unsigned char *)dst_;
 unsigned char *src = (unsigned char *)src_;

 int i,j,k;
 int bitval;     //for storing a bit
 int srcBitOfs;  //offset from beginning of line of source in bits
 int dstBitOfs;  //offset from beginning of line of dest. in bits

 int downshift;

 int BitPlaneRowLen = ((w + 15) >> 4) << 4; //for single bitplane, in bits
 
 int LineLenSrc = (BitPlaneRowLen >> 3) * bitssrc; //in bytes
 int LineLenDst = disp_pitch;    //in bytes
 
 //number of padding bits per pixel (for bpp conversion)
 int padbits = bitsdst - bitssrc;

 //all lines
 for(k = 0; k < h; k++)
 {
     //a line
     memset(dst, 0, LineLenDst);
     dstBitOfs = 0;
     for(j = 0; j < w; j++) {
  
        //for all bits of a pixel
        srcBitOfs = j;
        downshift = 7 - (srcBitOfs & 0x7);   //bit order in a bitplane byte: 0x1 masks bit 7, 0x80 masks bit 0 of color index
        for(i = 0; i < bitssrc; i++) {

            bitval = (src[srcBitOfs >> 3] >> downshift)  &  0x1;   //get bit from bitplane
            dst[dstBitOfs >> 3] |= bitval << i;                    //write bit to chunky buffer
            dstBitOfs++; 
            srcBitOfs += BitPlaneRowLen;
        }
        dstBitOfs += padbits;
     }

     src += LineLenSrc;
     dst += LineLenDst;
 }
}



/******************************************************************************/
//decode RLE ("byterun" aka "packer", aka "PackBits" on Macintosh) compressed line
//normally only the first frame is packed with it (except delta method 0 or 1)
//mask plane is ignored (if available)
int IffAnim::DecodeByteRun(void *dst_, void *data_, int datasize, int w, int h, int bpp, int mask)
{
 int i,j;

 char *dst = (char *)dst_;   //destination (uncompressed)
 signed char *src = (signed char *)data_;  //byte code (compressed)
 
 int planepitch;     //pitch of a bitplane
 int linepitch;      //pitch of a scanline with mask plane

 int n,val;
 int posdst;         //write position in dst
 int possrc;         //read position in src
 
 
 planepitch = (w + 15) / 16 * 2;   //pitch of a plane
 linepitch = planepitch * bpp;     //pitch of a line without mask
 if(mask == 1)
   linepitch += planepitch;        //add mask plane pitch to line pitch
 
 if((dst == NULL) || (src == NULL))
   return -1;

 possrc = 0;   //position in src buffer

 //for each line decode to dst buffer
 for(i = 0; i < h; i++)
 {
   posdst = 0;

   j = planepitch * bpp;  //number of bytes for the scanline to decode (without mask)

   //while scanline data is not decoded
   while(j > 0)
   {
     n = src[possrc++];   //get type
     if(n >= 0) {         //copy number of bytes
       n = n + 1;
       if(n > j)          //overflow protection
         memcpy(dst + posdst, src + possrc, j);
       else
         memcpy(dst + posdst, src + possrc, n);
       possrc += n;
     }
     else if(n != -128) { //multiple times the same byte value
       n = -n + 1;
       val = src[possrc++];
       if(n > j)         //overflow protection
         memset(dst + posdst, val, j);
       else
         memset(dst + posdst, val, n);
     }
     posdst += n;
     j -= n;
   }
   dst += planepitch * bpp;                 //set pointer to beginning of next line
 }

 return 0;
}


/******************************************************************************/
// Decode Byte Vertical Delta compression (compression 5)
int IffAnim::DecodeByteVerticalDelta(char *dst, void *data_, int w, int bpp)
{
 unsigned char *data = (unsigned char *)data_;
 int i,j,k;       //loop counter
 int ofsdst;      //offset in destination buffer
 int ofssrc;      //offset in compressed data (delta chunk)
 int op, val;     //holds opcode , data value

 //width of a plane within a line in bytes (number of columns in a plane)
 int ncolumns = ((w + 15) / 16) * 2;
 
 //total len of a line in destination buffer, in bytes
 int dstpitch = ncolumns * bpp;


 //for every plane
 for(k = 0; k < bpp; k++)
 {
    //get offset (pointer) to compressed opcodes and data of current plane
    ofssrc = k * 4;
    ofssrc = (data[ofssrc] << 24) | (data[ofssrc + 1] << 16) | (data[ofssrc + 2] << 8) | data[ofssrc + 3];
    
    if(ofssrc)   //no change in plane if pointer index is 0
    {
       //for each column of a plane (column: a byte from every line -> vertically)
       for(j = 0; j < ncolumns; j++) 
       {
          ofsdst = j + k * ncolumns;   //set dst offset for current column, a column starts in the first scanline
           
          //get number of ops for the column and interpret
          for(i = data[ofssrc++]; i > 0; i--)
          {           
             op = data[ofssrc++];      //get opcode

             //if SAME_OP, opcode 0
             if(op == 0) {
                op =  data[ofssrc++];  //number of same bytes
                val = data[ofssrc++];
                while(op) {
                   dst[ofsdst] = val;
                   ofsdst += dstpitch;
                   op--;
                }
             }
             //if SKIP_OP, high bit is 0
             else if(op < 0x80)
                ofsdst += op * dstpitch;

             //if UNIQ_OP, high bit is set
             else {
                op &= 0x7f;  //set high bit to 0
                while(op) {
                   dst[ofsdst] = data[ofssrc++];
                   ofsdst += dstpitch;
                   op--;
                }
             }  
             
          } //end for all ops
       }  //end for all columns
    }
 } // end for all planes
}


/******************************************************************************/
//decode delta 7 long or short
int IffAnim::DecodeLSVerticalDelta7(char *dst, void *data_, int w, int bpp, bool long_data)
{
 unsigned char *data = (unsigned char *)data_;  //source buffer
 int i,j;

 uint32_t p_da;     //offset to data in source
 uint32_t p_op;     //offset to opcode in source buffer
 
 int ofsdst;        //offset in destination buffer in bytes
 int op;            //holds opcode
 int opcnt;         //op counter
 int16_t val16;     //holds 16 bit data
 int32_t val32;     //holds 32 bit data
 
 int t;             //help variable

 int ncolumns;      //number of columns per bitplane (total number of columns for "long" data), each with size "wordsize"
 int wordsize;      //bytes for one data word: 32 (long) or 16 bit (short)
 int dstpitch;      //length of a scanline in destination buffer in bytes
 bool half = false; //last column maybe only with 16 instead of 32 bits


 if(long_data) {
   wordsize = 4;              
   ncolumns = (w + 31) / 32;
   if(((w + 15) / 16 * 2) != ((w + 31) / 32 * 4))   //relating to the width of a video frame, possibly for the last column of each plane one must copy only 16 bit words, 
     half = true;
 }
 else {
   wordsize = 2;
   ncolumns = (w + 15) / 16;
 }

 dstpitch = ((w + 15) / 16 * 2) * bpp;


 //for every plane
 for(i = 0; i < bpp; i++)
 {

   //get 32 bit offsets (pointers) to data and opcodes for the current plane, stored as Big Endian
   t = i * 4;
   p_op = (data[t] << 24) | (data[t + 1] << 16) | (data[t + 2] << 8) | data[t + 3];
   p_da = (data[t + 32] << 24) | (data[t + 33] << 16) | (data[t + 34] << 8) | data[t + 35];

   if(p_op)  //if opcode pointer index not 0 => plane is modified
   {
                
     //for each column
     for(j = 0; j < ncolumns; j++)
     {
        //set dst byte start offset for current column, a column starts in the first scanline
        ofsdst = (j + i * ncolumns) * wordsize;

        //correct if last column has only 16 bit
        if(half) ofsdst -= (2 * i);

        //get number of ops for the column
        opcnt = data[p_op++];

        //interpret all ops of the column
        while(opcnt)
        {
          op = data[p_op++];   //fetch opcode

          if((wordsize == 2) || (half && ((j + 1) == ncolumns)))    //2 bytes per data word, or 16 bit of last column with 32 bit byte wordsize
          {
             //SAME_OP, opcode is 0
             if(op == 0) {
               op = data[p_op++];   //number of same words
               val16 = *((int16_t*)(data + p_da));  //get data word
               p_da += wordsize;
               while(op) {
                 *((int16_t*)(dst + ofsdst)) = val16;
                 ofsdst += dstpitch;
                 op--;
               }
             }

             //SKIP_OP, high bit is not set
             else if(op < 128)
               ofsdst += dstpitch * op;


             //UNIQ_OP, high bit is set 
             else {
               op &= 0x7f;  //mask out high bit and use as counter
               while(op) {
                  *((int16_t*)(dst + ofsdst)) = *((int16_t*)(data + p_da));
                  p_da += wordsize;
                  ofsdst += dstpitch;
                  op--;
               }
             }
            
          }
          else    //4 bytes per data word
          {
             //SAME_OP, opcode is 0
             if(op == 0) {
               op = data[p_op++];   //number of same words
               val32 = *((int32_t*)(data + p_da));  //get data word
               p_da += 4;
               while(op) {
                 *((int32_t*)(dst + ofsdst)) = val32;
                 ofsdst += dstpitch;
                 op--;
               }
             }

             //SKIP_OP, high bit is not set
             else if(op < 128)
               ofsdst += dstpitch * op;

             //UNIQ_OP, high bit is set 
             else {
               op &= 0x7f;
               while(op) {
                  *((int32_t*)(dst + ofsdst)) = *((int32_t*)(data + p_da));
                  p_da += 4;
                  ofsdst += dstpitch;
                  op--;
               }
             }
 
          } //end else

          opcnt--;
        } //end for number of ops
     }
   }
    
 }

 return 0;
}






/******************************************************************************/
// decompress delta mode 8 long or short
int IffAnim::DecodeLSVerticalDelta8(char *dst, void *data_, int w, int bpp, bool long_data)
{
 unsigned char *data = (unsigned char *)data_;  //source buffer
 int i,j;

 uint32_t p_op;       //offset to opcode in source buffer
 
 int ofsdst;          //offset in destination buffer in bytes
 uint32_t op;         //holds opcode
 unsigned int opcnt;  //op counter
 int16_t val16;       //holds 16 bit data
 int32_t val32;       //holds 32 bit data
 
 int t;               //help variable

 int ncolumns;        //number of columns per bitplane (total number of columns for "long" data), each with size "wordsize"
 int wordsize;        //bytes for one data word: 32 (long) or 16 bit (short)
 int dstpitch;        //length of a scanline in destination buffer in bytes
 bool half = false;   //last column maybe only with 16 instead of 32 bits


 if(long_data) {
   wordsize = 4;              
   ncolumns = (w + 31) / 32;
   if(((w + 15) / 16 * 2) != ((w + 31) / 32 * 4))   //relating to the width of a video frame, possibly for the last column of each plane one must copy only 16 bit words, 
     half = true;
 }
 else {
   wordsize = 2;
   ncolumns = (w + 15) / 16;
 }

 dstpitch = ((w + 15) / 16 * 2) * bpp;


 //for every plane
 for(i = 0; i < bpp; i++)
 {

   //get 32 bit offset (pointer) to opcodes for the current plane, stored as Big Endian
   t = i * 4;
   p_op = (data[t] << 24) | (data[t + 1] << 16) | (data[t + 2] << 8) | data[t + 3];

   if(p_op)  //if opcode pointer index not 0 => plane is modified
   {
                
     //for each column
     for(j = 0; j < ncolumns; j++)
     {
        //set dst byte start offset for current column, a column starts in the first scanline
        ofsdst = (j + i * ncolumns) * wordsize;


        if(wordsize == 2)
          opcnt = (data[p_op] << 8) | data[p_op + 1]; //get number of ops for the column
        else {
          if(half) ofsdst -= (2 * i);                 //correct if last column has only 16 bit
          opcnt = (data[p_op] << 24) | (data[p_op + 1] << 16) | (data[p_op + 2] << 8) | data[p_op + 3];
        }

        p_op += wordsize;

        //interpret all ops of the column
        while(opcnt)
        {

          //fetch opcode
          if(wordsize == 2)
            op = (data[p_op] << 8) | data[p_op + 1];   
          else
            op = (data[p_op] << 24) | (data[p_op + 1] << 16) | (data[p_op + 2] << 8) | data[p_op + 3];
            
          p_op += wordsize;

          if((wordsize == 2) || (half && ((j + 1) == ncolumns)))    //2 bytes per data word, or 16 bit of last column with 32 bit byte wordsize
          {
             //SAME_OP, opcode is 0
             if(op == 0) {
               op = (data[p_op] << 8) | data[p_op + 1]; //number of same words
               p_op += 2;
               val16 = *((int16_t*)(data + p_op));      //get data word
               p_op += 2;
               while(op) {
                 *((int16_t*)(dst + ofsdst)) = val16;
                 ofsdst += dstpitch;
                 op--;
               }
             }

             //SKIP_OP, high bit is not set
             else if(op < 0x8000)
               ofsdst += dstpitch * op;


             //UNIQ_OP, high bit is set 
             else {
               op &= 0x7fff;   //mask out high bit and use as counter
               while(op) {
                  *((int16_t*)(dst + ofsdst)) = *((int16_t*)(data + p_op));
                  p_op += 2;
                  ofsdst += dstpitch;
                  op--;
               }
             }
            
          }
          else    //4 bytes per data word
          {
             //SAME_OP, opcode is 0
             if(op == 0) {
               op = (data[p_op] << 24) | (data[p_op + 1] << 16) | (data[p_op + 2] << 8) | data[p_op + 3];   //number of same words
               p_op += 4;
               val32 = *((int32_t*)(data + p_op));  //get data word
               p_op += 4;
               while(op) {
                 *((int32_t*)(dst + ofsdst)) = val32;
                 ofsdst += dstpitch;
                 op--;
               }
             }

             //SKIP_OP, high bit is not set
             else if(op < 0x80000000)
               ofsdst += dstpitch * op;

             //UNIQ_OP, high bit is set 
             else {
               op &= 0x7fffffff;
               while(op) {
                  *((int32_t*)(dst + ofsdst)) = *((int32_t*)(data + p_op));
                  p_op += 4;
                  ofsdst += dstpitch;
                  op--;
               }
             }
 
          } //end else

          opcnt--;
        } //end for number of ops
     }
   }
    
 }

}






/******************************************************************************/
/*
The following function is an interpretation of the
"Delta_J" code from " "xanim2801.tar.gz" (XAnim Revision 2.80.1).
It is modified to draw to a bitplanar frame buffer (BODY data format) instead a
chunky one, thus it fits better into a decoding pipeline.

 char *dst,     //Image Buffer pointer (old frame data, BODY format)
 void *delta_,  //delta data
 int  w,        //width in pixels
 int  h,        //height in pixels
 int  bpp       //bits per pixel (depth, number of bitplanes)
*/
int IffAnim::DecodeDeltaJ(char *dst, void *delta_, int w, int h, int bpp)
{
 unsigned char *image = (unsigned char*)dst;
 unsigned char *delta = (unsigned char*)delta_;
  
 int32_t   pitch;     //scanline width in bytes
 uint8_t   *i_ptr;    //used as destination pointer into the frame buffer
 uint32_t  type, r_flag, b_cnt, g_cnt, r_cnt; 
 int       b, g, r, d;    //loop counters
 uint32_t  offset;    //byte offset

 int planepitch_byte = (w + 7) / 8;      //plane pitch as multiple of 8 bits, needed to calc the right offset
 int planepitch = ((w + 15) / 16) * 2;   //width of a line of a single bitplane in bytes (multiple of 16 bit)
 pitch = planepitch * bpp;               //size of a scanline in bytes (bitplanar BODY buffer)

 //for pixel width < 320 we need the horizontal byte offset in a bitplane on a 320 pixel wide screen
 int kludge_j;
 if (w < 320)
   kludge_j = (320 - w) / 8 / 2;  //byte offset
 else 
   kludge_j = 0;



 //loop until block type 0 appears (or any unsupported type with unknown byte structure)
 int exitflag = 0;
 while(!exitflag)
 {
   //read compression type and reversible_flag ("reversible" means XOR operation) 
   type   = ((delta[0]) << 8) | (delta[1]);
   delta += 2;

   //switch on compression type
   switch(type)
   {
     case 0: exitflag = 1; break;  // end of list, delta frame complete -> leave
     case 1:
       //read reversible_flag
       r_flag = (*delta++) << 8; r_flag |= (*delta++);

       // Get byte count and group count 
       b_cnt = (*delta++) << 8; b_cnt |= (*delta++);
       g_cnt = (*delta++) << 8; g_cnt |= (*delta++);

       // Loop through groups
       for(g = 0; g < g_cnt; g++)
       {
         offset = (*delta++) << 8; offset |= (*delta++);

         //get real byte offset in IFF BODY data
         if (kludge_j)
           offset = ((offset/(320 / 8)) * pitch) + (offset % (320/ 8)) - kludge_j;
         else
           offset = ((offset/planepitch_byte) * pitch) + (offset % planepitch_byte);
 
         i_ptr = image + offset;  //BODY data pointer

         //read and apply "byte count" * "bpp" bytes (+ optional pad byte for even number of bytes)
         //1 byte for each plane -> modifies up to 8 bits
         // byte count represents number of rows

         // Loop thru byte count
         for(b = 0; b < b_cnt; b++)  //number of vertical steps
         {
           for(d = 0; d < bpp; d++)  //loop thru planes, a delta byte for each plane
           {
             if (r_flag) *i_ptr ^= *delta++;
             else        *i_ptr  = *delta++;

             i_ptr += planepitch;    //go to next plane
           } // end of depth loop 

         } // end of byte loop
         if((b_cnt * bpp) & 0x1) delta++;  //read pad byte (group contains even number of bytes)

       } //end of group loop 
       break;

     case 2:
       //read reversible_flag
       r_flag = (*delta++) << 8; r_flag |= (*delta++);

       // Read row count, byte count and group count
       r_cnt = (*delta++) << 8; r_cnt |= (*delta++);
       b_cnt = (*delta++) << 8; b_cnt |= (*delta++);
       g_cnt = (*delta++) << 8; g_cnt |= (*delta++);
 
       // Loop through groups
       for(g = 0; g < g_cnt; g++)
       {
         offset  = (*delta++) << 8; offset |= (*delta++);

         //get real byte offset in IFF BODY data
         if (kludge_j)
           offset = ((offset/(320 / 8)) * pitch) + (offset % (320/ 8)) - kludge_j;
         else
           offset = ((offset/planepitch_byte) * pitch) + (offset % planepitch_byte);


         // Loop through rows
         for(r = 0; r < r_cnt; r++)
         {
           for(d = 0; d < bpp; d++) // loop thru planes
           {
             i_ptr = image + offset + (r * pitch) + d * planepitch;
             
             for(b = 0; b < b_cnt; b++) // loop through byte count
             {
               if (r_flag) *i_ptr ^= *delta++;
               else        *i_ptr  = *delta++;           
               i_ptr++;      // data is horizontal
             } // end of byte loop
           } // end of depth loop 
         } // end of row loop
         if ((r_cnt * b_cnt * bpp) & 0x01) delta++; // pad to even number of bytes
       } // end of group loop
       break;

     default: //unknown type
       fprintf(stderr,"DeltaJ decoder: Unknown J-type %x\n", type);
       exitflag = 1;
       break;
   }  // end of type switch
 }  // end of while loop

 return 0;
} // end of DeltaJ routine







/******************************************************************************/
//return current (logical) frame
int IffAnim::CurrentFrameIndex()
{
 if(loopanim && (frameno >= (nframes - 2)))
   return frameno - (nframes - 2);
 else
   return frameno;
}


/******************************************************************************/
//find the chunk with the 4 byte id of "idreq" within a range from the current file position
//searches only in one level, file pointer must point to a chunk id inside this level
//returns start position in file of requested chunk and positions the file pointer to it's id
//not requested chunks are skipped
//returns -1 if chunk not found within range
int IffAnim::FindChunk(fstream *file, char *idreq, int len)
{
 char id[4];
 int  chunksize;
 int  pos;


 pos = file->tellg();
 len += pos;
  
 while(pos < len){
    file->read(id, 4);
    if(memcmp(id, idreq, 4) == 0) //break if found
       break;
    chunksize = (file->get() << 24) | (file->get() << 16) | (file->get() << 8) | file->get();
    //note: every chunk is padded to full 16 bit words (even number of bytes) in the file
    chunksize = ((chunksize + 1) >> 1) << 1;
    pos += chunksize + 8;
    file->seekg(chunksize, ios::cur);
 }
 if(pos >= len)
   return -1;
   
 file->seekg(pos, ios::beg);
 return pos;
}




/******************************************************************************/
//verify chunk structure
//count and return number of frames in the file
int IffAnim::GetNumFrames(fstream *file)
{
 char idbuf[4];
 int chunksize;
 int numframes;

 //init
 numframes = 0;
 file->seekg(0, ios::beg);

 //check for FORM id
 file->read(idbuf, 4);
 if(memcmp(idbuf, "FORM", 4) != 0) {
   sprintf(errorstring,"FORM id not found, no IFF file\n");
   return -1;
 }
 file->seekg(4, ios::cur);   

 //check for ANIM id
 file->read(idbuf, 4);
 if( memcmp(idbuf, "ANIM", 4) != 0) {
   sprintf(errorstring,"ANIM chunk not found, no supported ANIM file\n");
   return -1;
 }

 //count number of FORM...ILBM chunks (frames) within file
 do {
     //check for FORM id
     file->read(idbuf, 4);
     if(memcmp(idbuf, "FORM", 4) != 0)
       break;
     chunksize = (file->get()<<24) + (file->get()<<16) + (file->get()<<8) + file->get();
     chunksize = ((chunksize + 1) >> 1) << 1;   //must be multiple of 2 bytes
     //check for ILBM id
     file->read(idbuf, 4);
     if(memcmp(idbuf, "ILBM", 4) != 0)
       break;
     //skip ILBM
     file->seekg(chunksize-4, ios::cur);
     //frame found -> increase "nframes"
     numframes++;
 }while (1);
 
 //clear possible errors (when reading beyond eof)
 file->clear();

 if(numframes == 0)
   return -1;

 return numframes;
}



/******************************************************************************/
//read anim header chunk info into mem (frame entry of the frame list)
void IffAnim::read_ANHD(fstream *file, iffanim_frame *frame)
{
 file->seekg(8, ios::cur);   //file pointer points to first byte of chunk before, so we jump to the chunk content
 frame->delta_compression = file->get();
 frame->mask = file->get();
 frame->w = (file->get()<< 8) | file->get();
 frame->h = (file->get()<< 8) | file->get();
 frame->x = (file->get()<< 8) | file->get();
 frame->y = (file->get()<< 8) | file->get();

 file->seekg(4, ios::cur);
 frame->reltime = (file->get() << 24) | (file->get() << 16) | (file->get() << 8) | file->get();
 frame->interleave = file->get();

 file->seekg(1,ios::cur);
 frame->bits = (file->get() << 24) | (file->get() << 16) | (file->get() << 8) | file->get();
}



/******************************************************************************/
//read CMAP chunk into mem (frame entry)
void IffAnim::read_CMAP(fstream *file, iffanim_frame *frame)
{
 int j;
 int ncolors;
 int palsize;

 file->seekg(8, ios::cur);
 //allocate mem for cmap
 ncolors = 1 << bpp;
 palsize = ncolors * 3;   //RGB entries
 frame->cmap = new char[palsize];
 
 //read cmap, handle EHB mode (second half are darker versions of the previous colors)
 if(ehb) {
    palsize = palsize / 2;
    file->read(frame->cmap, palsize);
    for(j = 0; j < palsize; j++)
       frame->cmap[palsize + j] = frame->cmap[j] / 2;  // every color value divided by 2 (half brightness)
 }
 else
    file->read(frame->cmap, palsize);
}

/******************************************************************************/
/* - make audio interleaved -> reordering
  current sample point order:    0L,1L,2L,3L,... | 0R,1R,2R,3R,...
  requested sample point order:  0L,0R,1L,1R,2L,2R,3L,3R,...

 - structure of bit depth other than 8 ist unknown, although 1..32 should be supported as the format spec. says
 -> support only for 8 and 16 bit
*/
int IffAnim::InterleaveStereo(char *data, int datasize, int bps)
{
 int i;
 
 if(data == NULL)
   return -1;

 int nframes = datasize / 2 / ((bps + 7) / 8);  //number of sample frames in "data"

 char *newdata = new char[datasize];

 if(newdata == NULL)
   return -1;

 //reorder
 if(bps <= 8) //8 bit per point
 {
   int8_t *sl8 = (int8_t*)data;
   int8_t *sr8 = (int8_t*)(data + (datasize / 2));
   int8_t *dst8 = (int8_t*)newdata;
   for(i = 0; i < nframes; i++) {
     *dst8 = sl8[i];
     dst8[1] = sr8[i];
     dst8 += 2;
   }
 }
 else        //16 bit per point
 {
   int16_t *sl16  = (int16_t*)data;
   int16_t *sr16  = (int16_t*)(data + (datasize / 2));
   int16_t *dst16 = (int16_t*)newdata;
   for(i = 0; i < nframes; i++) {
     *dst16 = sl16[i];
     dst16[1] = sr16[i];
     dst16 += 2;
   }
 }

 //copy reordered points to old buffer
 memcpy(data, newdata, datasize);
 delete[] newdata;

 return 0;
}

/******************************************************************************/
//read SBDY chunk into mem (frame entry)
//stereo data is not interleaved in the file
int IffAnim::read_SBDY(fstream *file, int searchlen, char **audiobuf, int *audiobufsize)
{
 if((audiobuf == NULL) || (audiobufsize == NULL))
   return -1;

 char *tptr;    //help pointer
 int  chunksize;
 int  startpos = file->tellg();

 //file pointer should point to first SBDY chunk
 file->seekg(4, ios::cur);
 chunksize = (file->get()<<24) + (file->get()<<16) + (file->get()<<8) + file->get();

 *audiobuf = new char[chunksize];
 if(*audiobuf == NULL) {
   sprintf(errorstring,"Can't allocate memory");
   return -1;
 }
 *audiobufsize = chunksize;
 file->read(*audiobuf, chunksize);    

 //interleave stereo channels
 if((audio.nch == 2) && (audio.bps != 0))
   InterleaveStereo(*audiobuf, chunksize, audio.bps);



 //in case there is a second SBDY chunk, join the data to first one
 if(FindChunk(file, "SBDY", searchlen - ((int)file->tellg() - startpos)) != -1)
 {
   file->seekg(4, ios::cur);
   chunksize = (file->get()<<24) + (file->get()<<16) + (file->get()<<8) + file->get();
   tptr = new char[*audiobufsize + chunksize];
   if(tptr == NULL) {
     sprintf(errorstring, "Can't allocate memory");
     return -1;
   }
   memcpy(tptr, *audiobuf,  *audiobufsize);       //copy data of first SBDY
   file->read(tptr + *audiobufsize, chunksize);  //read first SBDY data to mem
   delete[] *audiobuf;  //delete old, too small buffer
   *audiobuf = tptr;    //set pointer to new buffer

   //interleave stereo channels
   if((audio.nch == 2) && (audio.bps != 0))
     InterleaveStereo(*audiobuf + *audiobufsize, chunksize, audio.bps);

   *audiobufsize += chunksize; 
 }
 
 audio.datasize += *audiobufsize;

 return 0;
}


/******************************************************************************/
//check file for valid frames, read to mem, get lentime
int IffAnim::ReadFrames(fstream *file)
{
 char **tabuf;    //temporary audio data buffer list, an allocated block for each frame
 int *tabufsize;  //list of size of a block in bytes (for each frame)
    
 int  i,k;
 char idbuf[8];
 int  chunksize;
 int  ILBMsize;   //size of ILBM chunk
 int  filepos;    //marks position in file 
 int  pos;        //for temporary use
 int  ncolors;
 
 char tptr;       //help pointer
 int  t;          //help variable

 Close();  //close open buffers
 lentime = 0;
 memset(dcompressions, 0, 32);

 //allocate / init frame list
 frame = new struct iffanim_frame[nframes];
 for(i = 0; i < nframes; i++) {
   frame[i].cmap = NULL;
   frame[i].data = NULL;
 }
 
 //set get pointer of file to first frame
 file->seekg(8, ios::beg);
 FindChunk(file, "ANIM", 100);
 file->seekg(4, ios::cur);

 //for all frames
 for(i = 0; i < nframes; i++)
 {
   
   file->seekg(4, ios::cur);    //get pointer should point now to "FORM....ILBM"

   //get size of ILBM chunk
   ILBMsize = (file->get() << 24) + (file->get() << 16) + (file->get() << 8) + file->get();
   ILBMsize -= 4;
   //save ILBM start position
   file->seekg(4, ios::cur);
   filepos = file->tellg();

   //the following is only for frame 0
   if(i == 0)
   {
       //search for SXHD (audio header)
       //init audio struct
       if(FindChunk(file, "SXHD", ILBMsize) != -1)
       {
         audio.n = nframes;
         tabuf = new char* [audio.n];        //temporary audio data buffer list, an allocated block for each frame
         tabufsize = new int [audio.n];     //list of size of a block in bytes (for each frame)

         for(int j = 0; j < audio.n; j++) {  //init dynamically allocated lists
           tabuf[j] = NULL;
           tabufsize[j] = 0;  
         }

         file->seekg(8, ios::cur);
         audio.bps = (unsigned char)file->get();
         audio.volume = (float)file->get() / 64;
         file->seekg(13, ios::cur);   //skip "length" (4 bytes) and "playrate" (4 bytes) "CompressionMethod" (4 bytes), "UsedChannels" (1 byte)
         audio.nch = file->get();     //only "1" or "2" supported
         audio.freq = (file->get()<<24) + (file->get()<<16) + (file->get()<<8) + file->get();

       }
       file->seekg(filepos, ios::beg);  //back to ilbm chunk start

       //search for BMHD
       pos = FindChunk(file, "BMHD", ILBMsize);
       if(pos == -1) {
         sprintf(errorstring,"BMHD chunk not found in first frame\n");
         return -1;
       }
       file->seekg(8, ios::cur);
       //read relevant format info
       w = (file->get() << 8) + file->get();
       h = (file->get() << 8) + file->get();
       file->seekg(4, ios::cur);
       bpp = file->get();      // bitplanes, same as bits per pixel
       mask = file->get();
       compressed = file->get();
       framesize = ((w + 15) / 16 * 2) * bpp * h; //multiple of 16 bit per plane

       //check compression
       if(compressed > 1) {
         sprintf(errorstring,"Unknown compression of first frame\n");
         return -1;
       }
       file->seekg(filepos, ios::beg);  //back to ilbm chunk start

       //search for CAMG chunk (for identifying HAM mode)
       ham = false;
       ehb = false;
       pos = FindChunk(file, "CAMG", ILBMsize);
       if(pos != -1) {
         file->seekg(pos + 10, ios::beg);
         //check if HAM or EHB mode is set
         if(file->get() & 0x8)
            ham = true;
         if(file->get() & 0x80)
            ehb = true;
       }
       file->seekg(filepos, ios::beg);  //back to ilbm chunk start

       //search & read CMAP
       if(bpp <= 8) {
         pos = FindChunk(file, "CMAP", ILBMsize);
         if(pos == -1) {
            sprintf(errorstring,"No CMAP chunk found in first frame (bit resolution requires a CMAP)\n");
            return -1;
         }
         read_CMAP(file, &(frame[i]));
         file->seekg(filepos, ios::beg);  //back to ilbm chunk start
       }
   }
   else
   {
       //search for new CMAP
       pos = FindChunk(file, "CMAP", ILBMsize);
       if(pos != -1) {
         read_CMAP(file, &(frame[i]));
       }
       file->seekg(filepos, ios::beg);
   }


   //search and read SBDY
   if((audio.nch > 0) && (audio.n > i) && (tabuf != NULL) && (tabufsize != NULL))
   {
     //read first SBDY
     if(FindChunk(file, "SBDY", ILBMsize) != -1)
       if(read_SBDY(file, ILBMsize, &(tabuf[i]), &(tabufsize[i])) == -1)   //if error occurs
         break;
     file->seekg(filepos, ios::beg);  //back to ilbm chunk start
   }

   //search & read ANHD
   pos = FindChunk(file, "ANHD", ILBMsize);
   if(pos != -1)
     read_ANHD(file, &(frame[i]));
   else {
     frame[i].reltime = 0;
     frame[i].delta_compression = 0;
   }
   lentime += frame[i].reltime;
   file->seekg(filepos, ios::beg);  //back to ilbm chunk start

   //check DLTA compression
   if((frame[i].delta_compression != 0) &&
      (frame[i].delta_compression != 5) &&
      (frame[i].delta_compression != 7) &&
      (frame[i].delta_compression != 8) &&
      (frame[i].delta_compression != 74))
   {
     sprintf(errorstring, "DLTA compression method %d is not supported but used in frame %d\n", frame[i].delta_compression, i);
     break;   //-> at least show the alreday loaded frames with supported compression
   }

   //search & read BODY or DLTA chunk
   bool body;
   pos = FindChunk(file, "BODY", ILBMsize);
   if(pos == -1) {
     file->seekg(filepos, ios::beg);
     pos = FindChunk(file, "DLTA", ILBMsize);
     if(pos == -1) {
        sprintf(errorstring,"no BODY or DLTA chunk found for frame %d\n", i);
        break;    //we stop reading frames here, maybe some frames are already read
     }
     else
       body = false;
   }
   else
     body = true;
   file->seekg(4, ios::cur);
  
   //get chunksize, allocate data buffer, read data
   chunksize = (file->get() << 24) + (file->get() << 16) + (file->get() << 8) + file->get();
   frame[i].data = new char[chunksize];
   if(frame[i].data == NULL) {
     sprintf(errorstring,"Can't allocate memory");
     break;
   }
   frame[i].datasize = chunksize;
   file->read(frame[i].data, chunksize);

   //decompress data from body chunks if RLE compressed, only "body" chunk data can be RLE compressed
   if(body && compressed)
   {
     framesize = (w + 15) / 16 * 2 * bpp * h;
     char *framemem = new char[framesize];  //memory for the RLE decompression is needed
     if(framemem == NULL) {
       sprintf(errorstring,"Can't allocate memory");
       break;
     }
     DecodeByteRun(framemem, frame[i].data, frame[i].datasize, w, h, bpp, mask); 
     delete[] frame[i].data;        //delete compressed data
     frame[i].data = framemem;      //insert decompressed data into framelist
     frame[i].datasize = framesize; //update size of decompressed data

     if((frame[i].delta_compression != 0)  &&  (frame[i].delta_compression != 1)) //in some files the delta compression is not set correctly for the first BODY frame, only 0 (uncompressed) or 1 (XOR map) is allowed (which can be RLE compression although)
       frame[i].delta_compression = 0;       //assume 0 is the correct value
   }

   //set bit in compression mode list (body chunks aren't delta compressed)
   dcompressions[frame[i].delta_compression / 8] |= 1 << (frame[i].delta_compression % 8);

   //set file pointer to next frame
   file->seekg(filepos + ILBMsize, ios::beg);
 }


 //correct number of frames (if there are any corrupt frames)
 if(i != nframes)
   sprintf(errorstring, "Error occured at opening of animation, continue anyway, %d if %d frames loaded", i, nframes);
 else
   sprintf(errorstring, "Animation successfully opened, %d of %d frames loaded", i, nframes);
 
 nframes = i;


 //copy audio to single buffer
 if(audio.datasize > 0)
 {
   audio.data = new char [audio.datasize];
   char *ptr = audio.data;
   audio.dataoffset = new int [audio.n];
   int sync = 0;
 
   for(int i = 0; i < audio.n; i++)
   {
     audio.dataoffset[i] = sync;          //set audio start byte for current video frame
     memcpy(ptr, tabuf[i], tabufsize[i]); //copy to single data buffer
     delete[] tabuf[i];
     ptr += tabufsize[i];
     sync += tabufsize[i];
   }
   delete[] tabuf;
   delete[] tabufsize;
 }

 if(i == 0)
   return -1;
 return 0;
}

/******************************************************************************/
//print format information to text buffer
void IffAnim::PrintInfo()
{
 sprintf(formatinfo,
   "number of frames: %d\n"
   "width: %d\n"
   "height: %d\n"
   "bits per pixel (bitplanar): %d\n"
   "bits per pixel decoded to (chunky): %d\n"
   "mask: %d\n"
   "HAM: %s\n"
   "EHB: %s\n"
   "total time in 1/60 sec: %d\n",
   nframes, w, h, bpp, disp_bpp, mask,
   ham? "yes":"no",
   ehb? "yes":"no",
   lentime);

 //info about compressions
 strcat(formatinfo, "compressions: ");
 if(compressed)
   strcat(formatinfo, "RLE,");

 int n = 0;
 for(int i = 0; i < 256; i++)  //list all delta compression modes
 {
   if((dcompressions[i / 8] >> (i % 8)) & 0x1)
   {
     n++;
     if(n == 1)
       sprintf(formatinfo,"%s %d",formatinfo, i);
     else
       sprintf(formatinfo,"%s, %d",formatinfo, i);
   }    
 }
 strcat(formatinfo, "\n");

 if(GetAudioFormat(NULL,NULL,NULL) != -1)
 {
   strcat(formatinfo, "audio format:\n");
   sprintf(formatinfo,
     "%s"
     " channels: %d\n"
     " bits per sample: %d\n"
     " sample rate: %d\n",
     formatinfo, audio.nch, audio.bps, audio.freq);
   int t;
   if((audio.nch != 0) && (audio.bps != 0))  //prevent division with 0
     t = audio.datasize / audio.nch * 8 / audio.bps;
   else
     t = 0;
   sprintf(formatinfo, "%s number of sample frames: %d\n", formatinfo, t);
 }
}




/******************************************************************************/
// specify, that animation is a special one, determined for looping
bool IffAnim::SetLoopAnim(bool state)
{
 if((state == true) && (nframes >= 4))
   loopanim = true;
 else
   loopanim = false;
}




/******************************************************************************/
// return info string
char *IffAnim::GetInfo()
{
 return formatinfo;
}




/******************************************************************************/
// decode frame from frame List, decide which decoding function to call
//  "dstframe" : bitplanar frame buffer, each plane per line padded to multiple of 16 bit
//  "index"    : frame number
int IffAnim::DecodeFrame(char *dstframe, int index)
{
 if(index > nframes)
   return -1;

 //decode frame
 switch (frame[index].delta_compression)
 {
   //uncompressed
   case 0 : memcpy(dstframe, frame[index].data, frame[index].datasize);
            break;
   //Byte vertical delta compression
   case 5 : DecodeByteVerticalDelta(dstframe, frame[index].data, w, bpp);
            break;
   //Short/Long vertical delta method 7
   case 7 : DecodeLSVerticalDelta7(dstframe, frame[index].data, w, bpp, (frame[index].bits & 0x1) ? true : false );
            break;
   //Short/Long vertical delta method 8
   case 8 : DecodeLSVerticalDelta8(dstframe, frame[index].data, w, bpp, (frame[index].bits & 0x1) ? true : false );
            break;
   case 74: DecodeDeltaJ(dstframe, frame[index].data, w, h, bpp); 
            break;
            
   default: fprintf(stderr, "Unsupported Delta Compression\n");
            return -1;
            break;
 }
    
 return 0;
}


/******************************************************************************/
char *IffAnim::GetFramePlanar(int *framesize_)
{
 if(framesize_ != NULL)
   *framesize_ = this->framesize; 
 
 if(curframe != NULL)
   return curframe;
 else
   return NULL;
}

/******************************************************************************/
void *IffAnim::GetFrame()
{
 return disp_frame;
}

/******************************************************************************/
void *IffAnim::GetCmap()
{
 return disp_cmap;
}

/******************************************************************************/
void *IffAnim::GetPrevFrame()
{
 return prev_disp_frame;
}

/******************************************************************************/
void *IffAnim::GetPrevCmap()
{
 return prev_disp_cmap;
}

/******************************************************************************/
//reset to first frame
int IffAnim::Reset()
{
 frameno = -1;   //so next frame is 0

 if(frame[0].delta_compression != 0)  //set to black, if frame 0 has delta compression
    memset(prevframe, 0, framesize);  //the next frame will be decoded to "prevframe"

 NextFrame();    //decompress, increment internal counter (swaps curframe <-> prevframe buffers)

 //make prevframe and curframe the same
 memcpy(prevframe, curframe, framesize);
 prevcmap = curcmap;
}





/******************************************************************************/
//- decompress next frame (loop), update counter
//- handle looping 
int IffAnim::NextFrame()
{
 if(!(file_loaded))  //if no anim file loaded
   return -1;
    
 if((frameno + 1) >= nframes) //if last frame
 {   
   if(this->loop == false)    //abort, do nothing (display frame remains)
     return -1;     
   else                       //handle looping
   {
     if(loopanim && (nframes >= 4))           //continue at frame 2 (skip the first 2)
       frameno = 1;
     else {
       Reset();    // loads the first frame
       return 0;
     }
   }
 }

 frameno++;

 //decompress to prevframe
 DecodeFrame(prevframe, frameno);
 
 //get cmap pointer
 if((bpp <= 8) && (frame[frameno].cmap != NULL))
    prevcmap = frame[frameno].cmap;

 //swap frame buffer pointers
 char *temp;
 temp = curframe;
 curframe = prevframe;
 prevframe = temp;
 //swap cmap
 temp = curcmap;
 curcmap = prevcmap;
 prevcmap = temp;

 return 0;
}


/******************************************************************************/
//calls the appropriate conversion function
int IffAnim::ConvertFrame()
{
 if(!(file_loaded))
   return -1;

 //swap pointers
 char *t;
 t = disp_frame;
 disp_frame = prev_disp_frame;
 prev_disp_frame = t;
 
 t = disp_cmap;
 disp_cmap = prev_disp_cmap;
 prev_disp_cmap = t;


 //convert multi to single planar display format (including bpp conversion)
 if(ham)
   ConvertHamTo24bpp(disp_frame, curframe, curcmap, w, h, bpp, disp_pitch);
 else
   BitplanarToChunky(disp_frame, curframe, w, h, bpp, disp_bpp, disp_pitch);

 //convert cmap: R,G,B  to  R,G,B,0
 int ncolors = 1 << bpp;
 int i;
 char *src = curcmap;
 char *dst = disp_cmap;

 if(disp_bpp <= 8) {
    for(i = 0; i < ncolors ;i++) {
        memcpy(dst, src,3);
        src += 3;
        dst += 4;
    }
 }
 
 num_disp_frames++;
 
 return 0;
}



/******************************************************************************/
//returns format information using pointers
int IffAnim::GetInfo(int *w_, int *h_, int *bpp_, int *pitch_, int *nframes_, int *mslentime_)
{
 if(w_ != NULL)
   *w_ = w;
 if(h_ != NULL)
   *h_ = h;
 if(bpp_ != NULL)
   *bpp_ = disp_bpp;

 if(nframes_ != NULL) {
   if(loopanim && (nframes >= 4))
     *nframes_ = nframes - 2;
   else
     *nframes_ = nframes;
 }
 
 if(pitch_ != NULL)
   *pitch_ = disp_pitch; 
 
 if(mslentime_!= NULL) {
   if(loopanim && (nframes >= 4))
     *mslentime_ = (lentime - frame[0].reltime - frame[1].reltime) * 1000 / 60;
   else
     *mslentime_ = lentime * 1000 / 60;
 }
 
}


/******************************************************************************/
//return frame delay time in milliseconds
int IffAnim::GetDelayTime()
{
 return (frame[frameno].reltime * 1000 / 60);
}


/******************************************************************************/
// original delay value in 1/60sec
int IffAnim::GetDelayTimeOriginal()
{
 return frame[frameno].reltime;
}


/******************************************************************************/
// activate or deactivate automatic looping
void IffAnim::SetLoop(bool state)
{
 this->loop = state;
}

/******************************************************************************/
//return audio format
int IffAnim::GetAudioFormat(int *nch, int *bps, int *freq)
{
 if(audio.nch <= 0)
   return -1;

 if(nch != NULL) *nch = audio.nch;
 if(bps != NULL) *bps = audio.bps;
 if(freq != NULL) *freq = audio.freq;

 return 0;
}

/******************************************************************************/
//return pointer to audio data and the size in bytes
char *IffAnim::GetAudioData(int *size)
{
 if(size != NULL)
   *size = audio.datasize;
 return audio.data;
}

/******************************************************************************/
//return audio data offset to a specific frame
int IffAnim::GetAudioOffset(int index)
{
 if((audio.dataoffset == NULL) || (index >= audio.n) || (index < 0))
   return 0;
      
 return audio.dataoffset[index];
}

/******************************************************************************/
//return audio data offset to a specific frame with time offset in millisec.
int IffAnim::GetAudioOffset(int index, int msoffs)
{
 int bpsf = audio.bps * audio.nch;   //bytes per sample frame
 return GetAudioOffset(index) + (msoffs * audio.freq * bpsf / 1000); //add "msoffs" in audio data
}

/******************************************************************************/
int IffAnim::GetAudioFrameSize(int index)
{
 if((audio.dataoffset == NULL) || (index >= audio.n))
   return 0;

 if((index + 1) >= audio.n)   //if index is the last frame
   return audio.datasize - audio.dataoffset[index];
 else 
   return audio.dataoffset[index + 1] - audio.dataoffset[index];
}




