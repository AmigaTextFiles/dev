/*
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * The Initial Developer of this code is David Baum.
 * Portions created by David Baum are Copyright (C) 1998 David Baum.
 * All Rights Reserved.
 */

/*
 * LegoUSB support for classic AmigaOS
 * by Uwe Ryssel
 *
 * uses poseidon.library
 *
 */

#include <stdio.h>

// Amiga related includes und defs
#include <exec/types.h>
#include <exec/exec.h>
#include <libraries/poseidon.h>

#include <proto/exec.h>
#include <proto/poseidon.h>
#include <clib/alib_protos.h>

#include "RCX_Pipe.h"

// USB vendor request defs
#define LTW_REQ_SET_PARM                    0x02

#define LTW_REQ_SET_TX_SPEED                0xEF
#define LTW_REQ_SET_RX_SPEED                0xF1
#define LTW_REQ_SET_TX_CARRIER_FREQUENCY    0xF4

#define LTW_PARM_MODE                       0x01
#define LTW_MODE_IR                         0x02

#define LTW_PARM_RANGE                      0x02
#define LTW_RANGE_SHORT                     0x01
#define LTW_RANGE_MEDIUM                    0x02

#define SPEED_COMM_BAUD_2400                0x08
#define SPEED_COMM_BAUD_4800                0x10

typedef struct LTW_REQ_REPLY_HEADER
{
      UWORD wNoOfBytes;                      // Number of bytes in the reply
      UBYTE bErrCode;                        // Request return code
      UBYTE bValue;                          // Request return value
} LTW_REQ_REPLY_HEADER;

typedef LTW_REQ_REPLY_HEADER LTW_REQ_GET_SET_PARM_REPLY;


// LegoUSB Tower defs
#define kVendorID 1684
#define kProductID 1
#define kConfiguration 0
#define kReadPipe 1
#define kWritePipe 2

#define kReadPacketSize 8

// functions
void ReleaseFunc(struct Hook *hookPtr, Object *obj, APTR msg);

// variables
struct Library *PsdBase = NULL;

// is application binding released after unplugging the device (set by hook)
BOOL appBindingReleased = FALSE;

class RCX_USBTowerPipe_amiga : public RCX_Pipe
{
  public:

            RCX_USBTowerPipe_amiga();
            ~RCX_USBTowerPipe_amiga() { Close(); }

    virtual RCX_Result  Open(const char *name, int mode);
    virtual void        Close();

    virtual int         GetCapabilities() const;
    virtual RCX_Result  SetMode(int mode);

    virtual long        Read(void *ptr, long count, long timeout_ms);
    virtual long        Write(const void *ptr, long count);

           //  static char *getversion() { return "$VER: nqc 2.5r1 (__DATE__)"; }

  private:

            void        ConsumeInBuffer();

            LONG        ControlRequest(UBYTE request, UWORD value);
            LONG        ControlRequest(UBYTE request, UBYTE loByte, UBYTE hiByte)
                        {
                            return ControlRequest(request, loByte + (hiByte << 8));
                        }



    struct PsdDevice        *device;
    struct PsdAppBinding    *appBinding;

    struct PsdConfig        *config;
    struct PsdInterface     *interface;

    struct MsgPort          *msgPort;

    struct PsdPipe          *ep0Pipe;
    struct PsdPipe          *readPipe;
    struct PsdPipe          *writePipe;

    struct Hook             releaseHook;

    // buffered read data (sometimes more data is read from the endpoint than is needed)
    unsigned char           fInBuffer[kReadPacketSize];
    unsigned char           *fInBufferStart;
    unsigned char           *fInBufferEnd;

    // the pending read request
    unsigned char           *fReadPtr;
    int                     fReadRemain;
    BOOL                    fReadDone;
};

// creates RCX_USBTowerPipe_amiga object
RCX_Pipe* RCX_NewUSBTowerPipe()
{
    return new RCX_USBTowerPipe_amiga();
}

///+ constructor
RCX_USBTowerPipe_amiga::RCX_USBTowerPipe_amiga()
{
    device = NULL;
    appBinding = NULL;

    config = NULL;
    interface = NULL;

    msgPort = NULL;

    ep0Pipe = NULL;
    readPipe = NULL;
    writePipe = NULL;
}
///-

///+ open device
RCX_Result RCX_USBTowerPipe_amiga::Open(const char *name, int mode)
{
    // open library
    PsdBase = OpenLibrary("poseidon.library", 1);

    if (!PsdBase)
    {
        printf("Can't open poseidon.library.\n");
        return kRCX_OpenSerialError;
    }

    // find USBTower device entry
    device = (struct PsdDevice *)psdFindDevice(device,
            DA_VendorID, kVendorID,
            DA_ProductID, kProductID,
            TAG_END);

    if (!device)
    {
        printf("Can't find Lego USB Tower.\n");
        Close();
        return kRCX_OpenSerialError;
    }

    // init Hook
    releaseHook.h_MinNode.mln_Succ  = NULL;
    releaseHook.h_MinNode.mln_Pred  = NULL;
    releaseHook.h_Entry             = (ULONG (*)())HookEntry;   // amiga.lib stub
    releaseHook.h_SubEntry          = (ULONG (*)())ReleaseFunc; // HLL entry
    releaseHook.h_Data              = NULL;

    // claim binding
    appBinding = (PsdAppBinding *)psdClaimAppBinding(ABA_Device, (ULONG)device,
            ABA_ReleaseHook, (ULONG)&releaseHook,
            TAG_END);

    if (!appBinding)
    {
        printf("Can't claim binding\n");
        Close();
        return kRCX_OpenSerialError;
    }

    // create message port
    msgPort = CreateMsgPort();

    if (!msgPort)
    {
        printf("Can't create message port.\n");
        Close();
        return kRCX_OpenSerialError;
    }

    // create config pipe
    ep0Pipe = (struct PsdPipe *)psdAllocPipe(device, msgPort, NULL);

    if (!ep0Pipe)
    {
        printf("Can't allocate config pipe\n");
        Close();
        return kRCX_OpenSerialError;
    }

    // set to config #1
    psdSetDeviceConfig(ep0Pipe, 1);

    // get config list
    struct List *configList;

    psdGetAttrs(PGA_DEVICE, device,
            DA_ConfigList, (ULONG)&configList,
            TAG_END);

    if(!configList->lh_Head->ln_Succ)
    {
        printf("No configs?\n");
        Close();
        return kRCX_OpenSerialError;
    }

    // get 1st config
    config = (struct PsdConfig *)configList->lh_Head;

    // get interface list
    struct List *interfaceList;

    psdGetAttrs(PGA_CONFIG, config,
                CA_InterfaceList, (ULONG)&interfaceList,
                TAG_END);

    if(!interfaceList->lh_Head->ln_Succ)
    {
        printf("No interfaces?\n");
        Close();
        return kRCX_OpenSerialError;
    }

    // get interface
    interface = (struct PsdInterface *)interfaceList->lh_Head;

    /*
    // get endpoint list
    struct List *endpointList;

    psdGetAttrs(PGA_INTERFACE, interface,
                IFA_EndpointList, (ULONG)&endpointList,
                TAG_END);

    if(!endpointList->lh_Head->ln_Succ)
    {
        printf("No endpoints?\n");
        Close();
        return kRCX_OpenSerialError;
    } */

    // get endpoints
    struct PsdEndpoint *readEndpoint;
    struct PsdEndpoint *writeEndpoint;

    readEndpoint = (struct PsdEndpoint *)psdFindEndpoint(interface, NULL,
                EA_EndpointNum, kReadPipe,
                TAG_END);

    if (!readEndpoint)
    {
        printf("No Read Endpoint?\n");
        Close();
        return kRCX_OpenSerialError;
    }

    writeEndpoint = (struct PsdEndpoint *)psdFindEndpoint(interface, NULL,
                EA_EndpointNum, kWritePipe,
                TAG_END);

    if (!writeEndpoint)
    {
        printf("No Write Endpoint?\n");
        Close();
        return kRCX_OpenSerialError;
    }

    // create pipes
    readPipe = (struct PsdPipe *)psdAllocPipe(device, msgPort, readEndpoint);

    if (!readPipe)
    {
        printf("Can't allocate Read Pipe\n");
        Close();
        return kRCX_OpenSerialError;
    }

    writePipe = (struct PsdPipe *)psdAllocPipe(device, msgPort, writeEndpoint);

    if (!writePipe)
    {
        printf("Can't allocate Write Pipe\n");
        Close();
        return kRCX_OpenSerialError;
    }

    // setup mode
    ControlRequest(LTW_REQ_SET_PARM, LTW_PARM_MODE, LTW_MODE_IR);

    // setup range
    UBYTE range;
    range = (strcmp(name, "short") == 0) ? LTW_RANGE_SHORT : LTW_RANGE_MEDIUM;
    ControlRequest(LTW_REQ_SET_PARM, LTW_PARM_RANGE,range);

    // set speed
    SetMode(mode);

    return 0;
}
///-

///+ close device
void RCX_USBTowerPipe_amiga::Close()
{
    // free pipes
    if (writePipe) psdFreePipe(writePipe);
    writePipe = NULL;

    if (readPipe) psdFreePipe(readPipe);
    readPipe = NULL;

    if (ep0Pipe) psdFreePipe(ep0Pipe);
    ep0Pipe = NULL;

    // delete message port
    if (msgPort) DeleteMsgPort(msgPort);
    msgPort = NULL;

    interface = NULL;
    config = NULL;

    // release app binding
    if (appBinding && !appBindingReleased) psdReleaseAppBinding(appBinding);
    appBinding = NULL;

    device = NULL;

    if (PsdBase) CloseLibrary(PsdBase);
    PsdBase = NULL;
}
///-

///+ get capabilities
int RCX_USBTowerPipe_amiga::GetCapabilities() const
{
    return kNormalIrMode | kFastIrMode | kFastOddParityFlag; //  | kAbsorb55Flag;
}
///-

///+ set mode
RCX_Result RCX_USBTowerPipe_amiga::SetMode(int mode)
{
    // printf("Set mode %d\n", mode);

    switch (mode)
    {
        case kNormalIrMode:
            // printf("Normal Speed.\n");
            ControlRequest(LTW_REQ_SET_TX_SPEED, SPEED_COMM_BAUD_2400);
            ControlRequest(LTW_REQ_SET_RX_SPEED, SPEED_COMM_BAUD_2400);
            return kRCX_OK;

        case kFastIrMode:
            // printf("Fast Speed.\n");
            ControlRequest(LTW_REQ_SET_PARM, LTW_PARM_RANGE, LTW_RANGE_SHORT);
            ControlRequest(LTW_REQ_SET_TX_SPEED, SPEED_COMM_BAUD_4800);
            ControlRequest(LTW_REQ_SET_RX_SPEED, SPEED_COMM_BAUD_4800);
            ControlRequest(LTW_REQ_SET_TX_CARRIER_FREQUENCY, 38);
            return kRCX_OK;

        default:
            return kRCX_PipeModeError;
    }
}
///-

#define MAX_PACKET 200

///+ write
long RCX_USBTowerPipe_amiga::Write(const void *ptr, long length)
{
    // printf("Write %ld Bytes. ", length);

    const unsigned char *data = (const unsigned char *)ptr;

    int total = 0;

    /*
    for (total = 0; total < length; total++)
    {
        printf("%02X ", data[total]);
    } */

    total = 0;

    while (length > 0)
    {
        LONG ioerr;
        int count = length;

        if (count > MAX_PACKET) count = MAX_PACKET;

        ioerr = psdDoPipe(writePipe, (APTR)data, count);
        if (ioerr)
        {
            if (ioerr != UHIOERR_TIMEOUT) // ! timeout after unplugging the USB IR Tower
            {
                printf("Bulk transfer (write) failed: %s (%ld)\n",
                        psdNumToStr(NTS_IOERR, ioerr, "unknown"), ioerr);
            }

            return total;
        }

        length -= count;
        data += count;
        total += count;
    }

    // printf("-> %d Bytes written.\n", total);

    return total;
}
///-

///+ read
long RCX_USBTowerPipe_amiga::Read(void *data, long length, long timeout_ms)
{
    // printf("Read %ld Bytes. ", length);

    ULONG received;

    // Timeout konfigurieren
    psdSetAttrs(PGA_PIPE, readPipe,
            PPA_AllowRuntPackets, TRUE,
            PPA_NakTimeout, TRUE,
            PPA_NakTimeoutTime, timeout_ms,
            TAG_END);


    fReadPtr = (unsigned char *)data;
    fReadRemain = length;
    fReadDone = FALSE;

    // consume any previously buffered data
    ConsumeInBuffer();

    // read data
    while (!fReadDone)
    {
        LONG ioerr;

        // clear the input buffer
        fInBufferStart = fInBufferEnd = fInBuffer;

        ioerr = psdDoPipe(readPipe, fInBuffer, kReadPacketSize);

        if (ioerr == UHIOERR_NO_ERROR || ioerr == UHIOERR_NAKTIMEOUT) // no error or time out
        {
            // how many bytes received ?
            received = psdGetPipeActual(readPipe);

            // consume input buffer; <received> Bytes read
            fInBufferEnd = fInBuffer + received;
            ConsumeInBuffer();

            if (ioerr == UHIOERR_NAKTIMEOUT) // time out
            {
                // stop receiving
                fReadDone = TRUE;
            }
        }
        else if (ioerr == UHIOERR_TIMEOUT) // timeout after unplugging the USB IR Tower
        {
            return 0;
        }
        else // another error
        {
            printf("Bulk transfer (read) failed: %s (%ld)\n",
                psdNumToStr(NTS_IOERR, ioerr, "unknown"), ioerr);

            return 0;
        }
    }

    received = fReadPtr - (unsigned char *)data;

    /*
    int i;
    for (i = 0; i < received; i++)
    {
        printf("%02X ", ((unsigned char *)data)[i]);
    }

    printf("-> %ld Bytes read.\n", received);
      */

    return received;
}
///-

///+ ConsumeInBuffer
void RCX_USBTowerPipe_amiga::ConsumeInBuffer()
{
    while(fReadRemain && (fInBufferStart < fInBufferEnd))
    {
        *fReadPtr++ = *fInBufferStart++;
        fReadRemain--;
    }

    if (fReadRemain==0) fReadDone = true;
}
///-

///+ ControlRequest
LONG RCX_USBTowerPipe_amiga::ControlRequest(UBYTE request, UWORD value)
{
    LONG ioerr;

    LTW_REQ_GET_SET_PARM_REPLY reply;

    psdPipeSetup(ep0Pipe, URTF_IN | URTF_VENDOR | URTF_DEVICE,
            request, value, 0);

    ioerr = psdDoPipe(ep0Pipe, &reply, sizeof(reply));

    // printf("CR: %02X %02X  %02X  %02X\n", reply.wNoOfBytes & 0xFF, reply.wNoOfBytes >> 8, reply.bErrCode, reply.bValue);

    return ioerr;
}
///-

///+ Release Hook
void ReleaseFunc(struct Hook *hookPtr, Object *obj, APTR msg)
{
    appBindingReleased = TRUE;
    // psdAddErrorMsg(RETURN_WARN, "NQC" ,"USBTower killed!");
}
///-

