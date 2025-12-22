#ifndef PRAGMAS_MINISSC_H
#define PRAGMAS_MINISSC_H

/*
**      $VER: minissc_pragmas.h 1.0 (15.1.2000)
**
**      Copyright © 2000 Janne Peräaho.
**            All Rights Reerved.
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#pragma amicall(MiniSSCBase, 0x1e, ssc_ServoStatus(d0))
#pragma amicall(MiniSSCBase, 0x24, ssc_ControllerStatus(d0))
#pragma amicall(MiniSSCBase, 0x2a, ssc_ControllerRange(d0))
#pragma amicall(MiniSSCBase, 0x30, ssc_ServoRange(d0))
#pragma amicall(MiniSSCBase, 0x36, ssc_OccupyController(d0, d1, d2))
#pragma amicall(MiniSSCBase, 0x3c, ssc_ChangeControllerSettings(d0, d1, d2))
#pragma amicall(MiniSSCBase, 0x42, ssc_ChangeServoSettings(d0, d1))
#pragma amicall(MiniSSCBase, 0x48, ssc_FreeController(d0))
#pragma amicall(MiniSSCBase, 0x4e, ssc_OccupyServo(d0, d1))
#pragma amicall(MiniSSCBase, 0x54, ssc_FreeServo(d0))
#pragma amicall(MiniSSCBase, 0x5a, ssc_Reset(d0))
#pragma amicall(MiniSSCBase, 0x60, ssc_ResetAll())
#pragma amicall(MiniSSCBase, 0x66, ssc_GetAPosition(d0))
#pragma amicall(MiniSSCBase, 0x6c, ssc_GetPosition(d0))
#pragma amicall(MiniSSCBase, 0x72, ssc_SetAPosition(d0, d1))
#pragma amicall(MiniSSCBase, 0x78, ssc_SetPosition(d0, d1))
#pragma amicall(MiniSSCBase, 0x7e, ssc_AMove(d0, d1))
#pragma amicall(MiniSSCBase, 0x84, ssc_Move(d0, d1))

#ifdef __cplusplus
};
#endif /* __cplusplus */

#endif /* PRAGMAS_MINISSC_H */
