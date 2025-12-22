
#include <iostream.h>
#include <stdlib.h>
#include "Neural_network2.h"

const int num_examples = 4;

int main (int argc, char *argv[])
{
  Neural_network2 nn (2,3,3,1,0,1,1.0);
  double input [num_examples] [2] = {{0,0},{0,1},{1,0},{1,1}};
  double desired_output [num_examples] = {0,1,1,0};
  double error,curr_error;
  int    x,number_wrong,skip,printed,epochs;

  if ( argc != 2 )
    {
      cout << "Usage: xor_rand_opt2 <variance>\n"
           << "Recommended variance = 0.1 to 1.0\n";
      exit (1);
    }

  nn.variance (atof (argv [1]));

  cout.precision (5);

  // First find out how many are wrong and find the global error
  number_wrong = 0;
  curr_error = 0.0;
  for (x = 0; x < num_examples; ++x)
    {
      curr_error += nn.calc_forward (input [x],&desired_output [x],number_wrong,
                                     skip,0,printed);
    }

  // Loop until all input patterns generate the correct output OR
  // until the epochs is > 10000.
  // Random optimization theoretically will eventually solve the problem
  // but it could take infinite amount of time so cut our losses.
  // Practically, if random opt. doesn't solve the problem quickly,
  // it will take a very long time.
  epochs = 0;
  skip = 0;
  while ( (number_wrong > 0) && (epochs < 10000) )
    {
      ++epochs;
      // Generate weight matrices gaussian offsets
      // The IF checks to make sure the routine did generate the offsets
      if ( nn.generate_gaussian_offsets () )
        {
          ++skip;
          continue;
        }

      // Find new global error in the positive direction
      number_wrong = 0;
      error = 0.0;
      for (x = 0; x < num_examples; ++x)
        {
          error += nn.calc_forward_rand_opt (input [x],&desired_output [x],
                                             number_wrong, 1);
                                       // Direction flag  ^^^
        }

      // IF new error < current global error THEN update error and weights
      if ( error < curr_error  )
        {
          curr_error = error;
          nn.update_weights_with_offset (1); // Update in positive direction
        }
      else // Check new global error in negative direction
        {
          error = 0;
          number_wrong = 0;
          for (x = 0; x < num_examples; ++x)
            {
              error += nn.calc_forward_rand_opt (input [x],&desired_output [x],
                                                 number_wrong, -1);
                                             // Direction flag ^^^
            }

          // IF new global error < current global error THEN update error, weights
          if ( error < curr_error )
            {
              curr_error = error;
              nn.update_weights_with_offset (-1);  // Update in negative dir.
            }

          else // Neither direction improved error so update only the bias
              nn.update_weights_with_offset (0);

        }
      if ( (epochs % 50) == 0 )
        {
          cout << "Epoch = " << epochs << " number wrong " << number_wrong
               << " Current Error = " << curr_error << " New error = "
               << error << "\n";
        }
    }

  // Print out if problem was not solved
  if ( number_wrong > 0 )
    {
      cout << "PROBLEM COULD NOT BE SOLVED in less than " << epochs
           << " epochs\n";
    }

  // Print out information
  cout << "Epoch = " << epochs << " number wrong " << number_wrong
       << " Error = " << curr_error << "\n";

  // Print out output for each example (aprox. 0,1,1,0)
  for (x = 0; x < num_examples; ++x)
    {
      nn.calc_forward_test (input [x],&desired_output [x],1,0.1,0.3);
    }
  cout << "\n\n";
}

