
#include <iostream.h>
#include <math.h>
#include <stdlib.h>
#include "Neural_network1.h"

int main (int argc, char *argv[])
{
  Neural_network1 nn (2,4,1,1,0,1.0);
  double  error;
  int     x,number_wrong,skip,printed,epochs,num_checked;
  int     skip_array [4];
  double input [4] [2] = {{0,0},{0,1},{1,0},{1,1}};
  double desired_output [4] = {0,1,1,0};

  if ( argc != 8 )
    {
      cout << "Usage: xor_bp1 <alpha> <beta> <skip_epsilon> <theta> <phi> <K> "
           << "<hdec>\n\n"
           << "Typical values:\n"
           << "xor_bp2 0 1 0 1 0 0 0              "
           << "--> straight backpropagation\n"
           << "xor_bp2 0 1 0.05 0.8 0.2 0.025 0   "
           << "--> delta-bar-delta with skip\n"
           << "xor_bp2 0.4 1 0.05 0.8 0.2 0.025 0 "
           << "--> hybrid algorithm with skip\n";
      exit (1);
    }

  // Set learning parameters
  nn.alpha (atof (argv [1]));
  nn.beta (atof (argv [2]));
  nn.skip_epsilon (atof (argv [3]));
  nn.theta (atof (argv [4]));
  nn.phi (atof (argv [5]));
  nn.K (atof (argv [6]));
  nn.hdec (atof (argv [7]));

  // Initialized skip array
  for (x = 0; x < 4; ++x)
      skip_array [x] = 0;

  // Loop until all inputs are classified correctly OR after 50000 epochs
  // in case the NN gets stuck in a local minimum.
  epochs = 0;
  number_wrong = 4;
  while ( (number_wrong > 0) && (epochs < 50000) )
    {
      error = 0;
      number_wrong = 0;
      num_checked = 0;

      // Call calc_forward and back_propagation for all examples
      for (x = 0; x < 4; ++x)
        {
          // Skip checking input because it is already very close to desired
          if ( skip_array [x] )
            {
              --skip_array [x];
            }
          else
            {
              error += nn.calc_forward (input [x],&desired_output [x],
                                        number_wrong,skip,0,printed);
              ++num_checked;
              // Check to see if input is now very close to desired output
              // so it can be skipped the next 5 epochs
              if ( skip )
                {
                  skip_array [x] = 5;
                }
              else  // Not close enough so backpropagate error
                  nn.backpropagation (input [x],&desired_output [x],skip);
           }
        }
      // Now call update_weights so the weights will be changed to
      // reduce the error.
      nn.update_weights ();

      ++epochs;
      error /= num_checked;

      // Normally you would check here to see if the network is stuck
      // in a local minimum.  However, it is sometimes very hard to
      // code how to check for this case and it is not coded here at
      // this time.

      // Print out updates to see that the network is converging.
      if ( (epochs % 50) == 0 )
        {
          cout << "Epoch = " << epochs << " number wrong " << number_wrong
               << " Error = " << error << "\n";
        }
    }

  // Print out if network failed to solve problem
  if ( number_wrong > 0 )
    {
      cout << "COULD NOT SOLVE PROBLEM in less than " << epochs
           << " epochs\n";
    }

  // Print out how long it took to solve
  cout << "Epoch = " << epochs << " number wrong " << number_wrong
       << "\n\n";

}

