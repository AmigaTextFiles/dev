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
 * Lego Serial Tower support for classic AmigaOS
 *
 * by Uwe Ryssel
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <exec/types.h>

#include <devices/serial.h>
#include <devices/timer.h>

#include <proto/exec.h>
#include <clib/alib_protos.h>

#include "PSerial.h"


#define kDefaultSpeed       9600
#define kDefaultBufferSize  16384

class PSerial_amiga : public PSerial
{
public:
    PSerial_amiga();
    ~PSerial_amiga() { Close(); }

    virtual bool    Open(const char *name);
    virtual void    Close();

    virtual long    Write(const void *ptr, long count);
    virtual long    Read(void *ptr, long count);
    virtual bool    SetSpeed(int speed, int opts = 0);

    virtual bool    SetTimeout(long timeout_ms);

private:

    // serial device stuff
    struct MsgPort  *serport;
    struct IOExtSer *ser_io;

    // timer device stuff
    struct MsgPort  *timerport;
    struct timerequest *timer_io;

    long  timeout;
};


PSerial* PSerial::NewSerial()
{
    return new PSerial_amiga();
}

const char *PSerial::GetDefaultName()
{
    return "serial.device:0";
}

///+ constructor
PSerial_amiga::PSerial_amiga()
{
    serport = NULL;
    ser_io = NULL;

    timerport = NULL;
    timer_io = NULL;

    timeout = -1;
}
///-

///+ open
bool PSerial_amiga::Open(const char *name)
{
    char *deviceName = (char *)name;
    long unitNumber;

    // name has format <device>|<unitnumber>
    deviceName = strtok(deviceName, ":");
    unitNumber = strtoul(strtok(NULL, NULL), NULL, 10);

    if (!deviceName || deviceName[0] == 0x00)
    {
        return FALSE;
    }

    // create device port
    serport = CreatePort(NULL, 0);
    if (serport)
    {
        // create io struct
        ser_io = (struct IOExtSer *)CreateExtIO(serport,sizeof(struct IOExtSer));
        if (ser_io)
        {
            BYTE ioerr;

            ser_io->io_SerFlags = NULL;

            // open device
            ioerr = OpenDevice(deviceName, unitNumber, (struct IORequest *)ser_io, 0);

            if (!ioerr)
            {
                // reset device
                ser_io->IOSer.io_Command = CMD_RESET;
                DoIO((struct IORequest *)ser_io);

                // set device parameters
                SetSpeed(kDefaultSpeed);

                // timer device
                timerport = CreatePort(NULL, 0);
                if (timerport)
                {
                    timer_io = (struct timerequest *)CreateExtIO(timerport,
                            sizeof(struct timerequest));

                    if (timer_io)
                    {
                        ioerr = OpenDevice(TIMERNAME, UNIT_VBLANK, (struct IORequest *)timer_io, 0);

                        if (!ioerr)
                        {
                            return TRUE;
                        }

                        DeleteExtIO((struct IORequest *)timer_io);
                        timer_io = NULL;
                    }

                    DeletePort(timerport);
                    timerport = NULL;
                }

                CloseDevice((struct IORequest *)ser_io);
            }

            printf("Can't open %s Unit %ld.\n", deviceName, unitNumber);

            DeleteExtIO((struct IORequest *)ser_io);
            ser_io = NULL;
        }

        DeletePort(serport);
        serport = NULL;
    }

    return FALSE;
}
///-

///+ close
void PSerial_amiga::Close()
{
    if (ser_io)
    {
        // abort running ios
        if (!CheckIO((struct IORequest *)ser_io))
        {
            AbortIO((struct IORequest *)ser_io);
            WaitIO((struct IORequest *)ser_io);
        }

        // close device
        CloseDevice((struct IORequest *)ser_io);

        // free io struct
        DeleteExtIO((struct IORequest *)ser_io);
        ser_io = NULL;
    }

    if (serport)
    {
        DeletePort(serport);
        serport = NULL;
    }

    if (timer_io)
    {
        // abort running ios
        if (!CheckIO((struct IORequest *)timer_io))
        {
            AbortIO((struct IORequest *)timer_io);
            WaitIO((struct IORequest *)timer_io);
        }

        // close device
        CloseDevice((struct IORequest *)timer_io);

        DeleteExtIO((struct IORequest *)timer_io);
        timer_io = NULL;
    }

    if (timerport)
    {
        DeletePort(timerport);
        timerport = NULL;
    }
}
///- close

///+ write
long PSerial_amiga::Write(const void *ptr, long count)
{
    ser_io->IOSer.io_Command = CMD_WRITE;
    ser_io->IOSer.io_Length = count;
    ser_io->IOSer.io_Data = (APTR)ptr;
    DoIO((struct IORequest *)ser_io);

    return count;
}
///-

///+ read
long PSerial_amiga::Read(void *ptr, long count)
{
    // start read io
    ser_io->IOSer.io_Command    = CMD_READ;
    ser_io->IOSer.io_Length     = count;
    ser_io->IOSer.io_Data       = (APTR)ptr;
    SendIO((struct IORequest *)ser_io);

    BOOL timerStarted = FALSE;

    // start timer io
    if (timeout > 0)
    {
        timer_io->tr_node.io_Command = TR_ADDREQUEST;
        timer_io->tr_time.tv_secs    = 0;
        timer_io->tr_time.tv_micro   = timeout * 1000;
        SendIO((struct IORequest *)timer_io);

        timerStarted = TRUE;
    }

    // wait for timer and serial
    ULONG signal;
    ULONG waitSignal = (1L << serport->mp_SigBit);
    waitSignal |= (timerStarted) ? (1L << timerport->mp_SigBit) : 0;
    signal = Wait(waitSignal);

    // get count of received bytes
    ULONG received = 0;

    if (signal & (1L << serport->mp_SigBit)) // serial: all bytes received
    {
        received = count;

        // abort running timer io
        if (!CheckIO((struct IORequest *)timer_io))
        {
            AbortIO((struct IORequest *)timer_io);
            WaitIO((struct IORequest *)timer_io);
        }


    }

    if (signal & (1L << timerport->mp_SigBit)) // timeout expired
    {
        // abort running serial io
        if (!CheckIO((struct IORequest *)ser_io))
        {
            AbortIO((struct IORequest *)ser_io);
            WaitIO((struct IORequest *)ser_io);
        }

        received = ser_io->IOSer.io_Actual;
    }

    return received;
}
///-

///+ set speed
bool PSerial_amiga::SetSpeed(int speed, int opts = 0)
{
    ser_io->IOSer.io_Command = SDCMD_SETPARAMS;
    ser_io->io_RBufLen = (ULONG)kDefaultBufferSize;

    // speed
    ser_io->io_Baud = speed;

    // byte len
    int len = 8 - (opts & kPSerial_DataMask);
    ser_io->io_ReadLen = len;
    ser_io->io_WriteLen = len;

    // parity
    int parity = (opts & kPSerial_ParityMask) >> kPSerial_ParityShift;

    switch (parity)
    {
        case 0: // no parity
            ser_io->io_SerFlags &= ~SERF_PARTY_ON; // parity off
            break;

        case 1: // odd parity
            ser_io->io_SerFlags |= SERF_PARTY_ON; // parity on
            ser_io->io_SerFlags |= SERF_PARTY_ODD; // odd parity
            break;

        case 2: // even parity
            ser_io->io_SerFlags |= SERF_PARTY_ON; // parity on
            ser_io->io_SerFlags &= ~SERF_PARTY_ODD; // even parity
    }

    // stop bits
    int stopbits = (opts & kPSerial_StopMask) >> kPSerial_StopShift;

    if (stopbits == 0) ser_io->io_StopBits = 1;
        else ser_io->io_StopBits = 2;

    // other flags
    ser_io->io_SerFlags |= SERF_XDISABLED;
    ser_io->io_ExtFlags = NULL;
               
                
    DoIO((struct IORequest *)ser_io);

    return TRUE;
}
///-

///+ set timeout
bool PSerial_amiga::SetTimeout(long timeout_ms)
{
    timeout = timeout_ms;

    if (timeout == 0) timeout = 1;
    return TRUE;
}
///-

