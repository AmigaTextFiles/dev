/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <stdio.h>
#include <math.h>

int main(int argc, char **argv)
{
  FILE *inFile1 = 0, *inFile2 = 0, *outFile = 0;
  char *outName = 0, ppmString[256];
  int t1, t2, x1, x2, y1, y2, i, max1, max2;
  long long int mse = 0;
  double psnr = 0, rmse = 0;

  if ((argc > 5) || (argc == 4)) {
    printf("too much arguments\n");
    return 5;
  }

  for (i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-o")) {
      outName = argv[++i];
      if (!(outFile = fopen(outName, "w"))) {
	printf("failed to open outputfile %s\n", outName);
	return 10;
      }
    }
    else if (!inFile1) {
      if (!(inFile1 = fopen(argv[i], "r"))) {
	printf("failed to open first inputfile %s\n", argv[i]);
	return 10;
      }
    }
    else if (!inFile2) {
      if (!(inFile2 = fopen(argv[i], "r"))) {
	printf("failed to open second inputfile %s\n", argv[i]);
	return 10;
      }
    }
  }

  if (!inFile1 || !inFile2) {
    printf("you must specify two sources\n");
    return 5;
  }
  if (!outFile)
    outFile = stdout;

  fscanf(inFile1, "P%1d\n%d %d\n%d\n", &t1, &x1, &y1, &max1);
  fscanf(inFile2, "P%1d\n%d %d\n%d\n", &t2, &x2, &y2, &max2);

  if ((t1 != t2) || (x1 != x2) || (y1 != y2) || (max1 != max2)) {
    printf("cannot compare pictures with different sizes or formats\n");
    return 5;
  }
  if (!((t1 == 5) || (t1 == 6))) {
    printf("cannot handle this format P%1d\n", t1);
    return 5;
  }

  fprintf(outFile, "P5\n%d %d\n255\n", x1, y1);

  for (i = 0; i < (x1 * y1); i++) {
    int r, g, b, p;

    r = fgetc(inFile2) - fgetc(inFile1);
    mse += (long long int)(r * r);
    r >>= 1;
    r += 127;
    if (t1 == 6) {
      g = fgetc(inFile2) - fgetc(inFile1);
      mse += (long long int)(g * g);
      g >>= 1;
      g += 127;
      b = fgetc(inFile2) - fgetc(inFile1);
      mse += (long long int)(b * b);
      b >>= 1;
      b += 127;

      p = (r + g + b) / 3;
      fputc(p, outFile);
    }
    else
      fputc(r, outFile);
  }

  psnr = 10 * log10(65536.0 / ((double)mse / (x1 * y1 * (t1 == 6 ? 3 : 1))));
  rmse = sqrt((double)mse / (x1 * y1 * (t1 == 6 ? 3 : 1)));
  printf("psnr: " VEC_CONV1D ", rmse: " VEC_CONV1D "\n", psnr, rmse);

  fclose(inFile1);
  fclose(inFile2);
  fclose(outFile);
}
