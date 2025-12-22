
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "Neural_net1.h"

int main (int argc, char *argv[])
{
  Neural_net1 *nn;
  double  error;
  int     x,number_wrong,skip,printed,epochs,num_checked;
  int     skip_array [4];
  double input [4] [2] = {{0,0},{0,1},{1,0},{1,1}};
  double desired_output [4] = {0,1,1,0};

  if ( argc != 8 )
    {
      printf ("Usage: xor_bp2 <alpha> <beta> <skip_epsilon> <theta> <phi> ");
      printf ("<K> <hdec>\n\n");
      printf ("Typical values:\n");
      printf ("xor_bp2 0 1 0 1 0 0 0              ");
      printf ("--> straight backpropagation\n");
      printf ("xor_bp2 0 1 0.05 0.8 0.2 0.025 0   ");
      printf ("--> delta-bar-delta with skip\n");
      printf ("xor_bp2 0.4 1 0.05 0.8 0.2 0.025 0 ");
      printf ("--> hybrid algorithm with skip\n");
      exit (1);
    }

  nn = Neural_net1_default_constr (2,8,1,1,0,1.0);

  /* Set learning parameters */
  Neural_net1_set_alpha (nn,atof (argv [1]));
  Neural_net1_set_beta (nn,atof (argv [2]));
  Neural_net1_set_skip_epsilon (nn,atof (argv [3]));
  Neural_net1_set_theta (nn,atof (argv [4]));
  Neural_net1_set_phi (nn,atof (argv [5]));
  Neural_net1_set_K (nn,atof (argv [6]));
  Neural_net1_set_hdec (nn,atof (argv [7]));

  /* Initialized skip array */
  for (x = 0; x < 4; ++x)
      skip_array [x] = 0;

  /* Loop until all inputs are classified correctly OR after 50000 epochs
  // in case the NN gets stuck in a local minimum. */
  epochs = 0;
  number_wrong = 4;
  while ( (number_wrong > 0) && (epochs < 10000) )
    {
      error = 0;
      number_wrong = 0;
      num_checked = 0;

      /* Call calc_forward and back_propagation for all examples */
      for (x = 0; x < 4; ++x)
        {
          /* Skip checking input because it is already very close to desired */
          if ( skip_array [x] )
            {
              --skip_array [x];
            }
          else
            {
              error += Neural_net1_calc_forward (nn,input [x],
                                                 &desired_output [x],
                                                 &number_wrong,&skip,0,&printed);
              ++num_checked;
              /* Check to see if input is now very close to desired output
              // so it can be skipped the next 5 epochs */
              if ( skip )
                {
                  skip_array [x] = 5;
                }
              else  /* Not close enough so backpropagate error */
                  Neural_net1_backpropagation (nn,input [x],
                                               &desired_output [x],skip);
           }
        }
      /* Now call update_weights so the weights will be changed to
      // reduce the error. */
      Neural_net1_update_weights (nn);

      ++epochs;
      error /= num_checked;

      /* Normally you would check here to see if the network is stuck
      // in a local minimum.  However, it is sometimes very hard to
      // code how to check for this case and it is not coded here at
      // this time. */

      /* Print out updates to see that the network is converging. */
      if ( (epochs % 50) == 0 )
        {
          printf ("Epoch = %d  number wrong = %d  Error = %f\n",epochs,
                  number_wrong,error);
        }
    }

  /* Print out if network failed to solve problem */
  if ( number_wrong > 0 )
    {
      printf ("COULD NOT SOLVE PROBLEM in less than %d epochs\n",epochs);
    }

  /* Print out how long it took to solve */
  printf ("Epoch = %d  number_wrong = %d\n\n",epochs,number_wrong);

}

