
#include <stdio.h>
#include "Neural_net1.h"

#define num_examples 4

int main (int argc, char *argv[])
{
  Neural_net1 *nn;
  double input [num_examples] [2] = {{0,0},{0,1},{1,0},{1,1}};
  double desired_output [num_examples] = {0,1,1,0};
  double error,curr_error;
  int    x,number_wrong,skip,printed,epochs;

  if ( argc != 2 )
    {
      printf ("Usage: xor_rand_opt2 <variance>\n");
      printf ("Recommended variance = 0.1 to 1.0\n");
      exit (1);
    }

  nn = Neural_net1_default_constr (2,4,1,0,1,1.0);
  Neural_net1_set_variance (nn,atof (argv [1]));

  /* First find out how many are wrong and find the global error */
  number_wrong = 0;
  curr_error = 0.0;
  for (x = 0; x < num_examples; ++x)
    {
      curr_error += Neural_net1_calc_forward (nn,input [x],
                                              &desired_output [x],
                                              &number_wrong,
                                              &skip,0,&printed);
    }

  /* Loop until all input patterns generate the correct output OR
  // until the epochs is > 10000.
  // Random optimization theoretically will eventually solve the problem
  // but it could take infinite amount of time so cut our losses.
  // Practically, if random opt. doesn't solve the problem quickly,
  // it will take a very long time. */
  epochs = 0;
  skip = 0;
  while ( (number_wrong > 0) && (epochs < 10000) )
    {
      ++epochs;
      /* Generate weight matrices gaussian offsets
      // The IF checks to make sure the routine did generate the offsets */
      if ( Neural_net1_generate_gaussian_offsets (nn) )
        {
          ++skip;
          continue;
        }

      /* Find new global error in the positive direction */
      number_wrong = 0;
      error = 0.0;
      for (x = 0; x < num_examples; ++x)
        {
          error += Neural_net1_calc_forward_rand_opt (nn,input [x],
                                             &desired_output [x],
                                             &number_wrong, 1);
                                       /* Direction flag  ^^^ */
        }

      /* IF new error < current global error THEN update error and weights */
      if ( error < curr_error  )
        {
          curr_error = error;
          /* Update in positive direction */
          Neural_net1_update_weights_with_offset (nn,1);
        }
      else /* Check new global error in negative direction */
        {
          error = 0;
          number_wrong = 0;
          for (x = 0; x < num_examples; ++x)
            {
              error += Neural_net1_calc_forward_rand_opt (nn,input [x],
                                                 &desired_output [x],
                                                 &number_wrong, -1);
                                             /* Direction flag ^^^ */
            }

          /* IF new global error < current global error THEN update error, weights */
          if ( error < curr_error )
            {
              curr_error = error;
              /* Update in negative direction. */
              Neural_net1_update_weights_with_offset (nn,-1);
            }

          else /* Neither direction improved error so update only the bias */
              Neural_net1_update_weights_with_offset (nn,0);

        }
      if ( (epochs % 50) == 0 )
        {
          printf ("Epoch = %d  number wrong = %d  Current Error = %10.4f ",
                  epochs,number_wrong,curr_error);
          printf ("New error = %10.4f\n",error);
        }
    }

  /* Print out if problem was not solved */
  if ( number_wrong > 0 )
    {
      printf ("PROBLEM COULD NOT BE SOLVED in less than %d epochs\n",epochs);
    }

  /* Print out information */
  printf ("Epoch = %d  number wrong = %d  Error = %10.4f\n",epochs,
          number_wrong,curr_error);

  /* Print out output for each example (aprox. 0,1,1,0) */
  for (x = 0; x < num_examples; ++x)
    {
      Neural_net1_calc_forward_test (nn,input [x],&desired_output [x],1,0.1,0.3);
    }
  printf ("\n\n");
}

