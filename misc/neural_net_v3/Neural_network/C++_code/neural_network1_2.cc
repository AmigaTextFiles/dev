

#include "Neural_network1.h"
#include "gaussian_rand.h"

double Neural_network1::calc_forward_rand_opt (double input [],
                                              double desired_output [],
                                              int& num_wrong,
                                              int direction)
{
  int     x,y,wrong;
  int     size;
  double  *weight,error,abs_error,dir,*offset;

  if ( !rand_opt_flag )
      return (-1.0);

  if ( direction > 0 )
      dir = 1.0;
  else
      dir = -1.0;

  wrong = 0;
  error = 0.0;

  /* Go backward for faster processing */
  /* Calculate hidden layer 1's activation */
  size = num_inputs;
  for (x = num_hidden1 - 1; x >= 0;  --x)
    {
      hidden1_act [x] = 0.0;
      weight = &input_weights [x * size];
      offset = &input_weights_g_offset [x * size];
      for (y = num_inputs - 1; y >= 0; --y)
        {
          hidden1_act [x] += (input [y] * (weight [y] + dir * offset [y]));
        }
      hidden1_act [x] = S(hidden1_act [x]);
    }

  /* Calculate output layer's activation */
  size = num_hidden1;
  for (x = num_outputs - 1; x >= 0; --x)
    {
      output_act [x] = 0.0;
      weight = &hidden1_weights [x * size];
      offset = &hidden1_weights_g_offset [x * size];
      for (y = num_hidden1 - 1; y >= 0; --y)
        {
          output_act [x] += hidden1_act [y] * (weight [y] + dir * offset [y]);
        }
      output_act [x] = S(output_act [x]);
      abs_error = fabs (output_act [x] - desired_output [x]);
      error += abs_error;
      if ( abs_error > _epsilon )
          wrong = 1;
    }

  if ( wrong )
      ++num_wrong;

  return (error);

}

int Neural_network1::generate_gaussian_offsets ()
{
  int x;

  if ( rand_opt_flag == 0 )
      return (-1);

  for (x = (num_hidden1 * num_inputs) - 1; x >= 0; --x)
    {
      input_weights_g_offset [x] = gaussian_rand (_variance) +
                                   input_weights_bias [x];
    }

  for (x = (num_outputs * num_hidden1) - 1; x >= 0; --x)
    {
      hidden1_weights_g_offset [x] = gaussian_rand (_variance) +
                                     hidden1_weights_bias [x];
    }

  return (0);
}

void Neural_network1::update_weights_with_offset (int direction)
{
  int    x;
  double dir,offset_cofactor,bias_cofactor;

  if ( !rand_opt_flag )
      return;

  if ( direction == 0 )
    {
      offset_cofactor = 0.0;
      bias_cofactor = 0.5;
      dir = 0.0;
    }
  else if ( direction > 0 )
    {
      offset_cofactor = 0.4;
      bias_cofactor = 0.2;
      dir = 1.0;
    }
  else
    {
      offset_cofactor = -0.4;
      bias_cofactor = 1.0;
      dir = -1.0;
    }

  for (x = num_hidden1 * num_inputs - 1; x >= 0; --x)
    {
      input_weights [x] += (input_weights_g_offset [x] * dir);
      input_weights_bias [x] = offset_cofactor * input_weights_g_offset [x] +
                               bias_cofactor * input_weights_bias [x];
    }

  for (x = num_outputs * num_hidden1 - 1; x >= 0; --x)
    {
      hidden1_weights [x] += (hidden1_weights_g_offset [x] * dir);
      hidden1_weights_bias [x] = offset_cofactor * hidden1_weights_g_offset [x] +
                                 bias_cofactor * hidden1_weights_bias [x];
    }

}

