/* Copyright (C) 2010  Andor Polgar */


 
#ifndef __LIBWAV_H__
#define __LIBEAV_H__

#include <stdio.h>



/**
 *
 * @param samples
 * @param num_samples
 * @param num_channels
 * @param sample_rate
 * @param bits_per_sample
 * @param file_path
 *
 * @return
 */
int writeWav(void           *samples,
             unsigned int   num_samples,
             unsigned short num_channels,
             unsigned int   sample_rate,
             unsigned short bits_per_sample,
             char           *file_path);



#endif /* __LIBWAV__ */
    