

#include "TD_Neural_network.h"
#include "gaussian_rand.h"

double TD_Neural_network::calc_forward_rand_opt (double input [],
                                                 double desired_output [],
                                                 int& num_wrong,
                                                 int direction)
{
  int     x,y,z,wrong;
  int     offset,offset_act;
  double  *weight,error,abs_error,dir,*g_offset;

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
  for (x = num_cols1 - 1; x >= 0;  --x)
    {
      for (y = num_rows1 - 1; y >= 0; --y)
        {
          offset_act = x * num_rows1 + y;
          hidden1_act [offset_act] = 0.0;
          weight = &input_weights [(x * num_rows1 + y) * num_time_delay1 *
                                   num_rowsi];
          g_offset = &input_weights_g_offset [(x * num_rows1 + y) *
                                              num_time_delay1 * num_rowsi];
          offset = x * num_rowsi;
          for (z = (num_time_delay1 * num_rowsi - 1); z >= 0; --z)
            {
              hidden1_act [offset_act] += (input [offset + z] *
                                           (weight [z] + g_offset [z] * dir));
            }
          hidden1_act [offset_act] = S(hidden1_act [offset_act]);
        }
    }

  /* Calculate hidden layer 2's activation */
  for (x = num_cols2 - 1; x >= 0; --x)
    {
      for (y = num_rows2 - 1; y >= 0; --y)
        {
          offset_act = x * num_rows2 + y;
          hidden2_act [offset_act] = 0.0;
          weight = &hidden1_weights [(x*num_rows2 + y) * num_time_delay2 *
                                     num_rows1];
          g_offset = &hidden1_weights_g_offset [(x*num_rows2 + y) *
                                                num_time_delay2 * num_rows1];
          offset = x * num_rows1;
          for (z = (num_time_delay2 * num_rows1 - 1); z >= 0; --z)
            {
              hidden2_act [offset_act] += (hidden1_act [offset + z] *
                                           (weight [z] + dir * g_offset [z]));
            }
          hidden2_act [offset_act] = S(hidden2_act [offset_act]);
        }
    }

  /* Calculate output layer's activation */
  for (x = num_outputs - 1; x >= 0; --x)
    {
      output_act [x] = 0.0;
      weight = &hidden2_weights [x * num_cols2];
      g_offset = &hidden2_weights_g_offset [x * num_cols2];
      for (y = num_cols2 - 1; y >= 0; --y)
        {
          output_act [x] += (hidden2_act [y * num_rows2 + x] *
                            (weight [y] + dir * g_offset [y]));
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

int TD_Neural_network::generate_gaussian_offsets ()
{
  int x;

  if ( rand_opt_flag == 0 )
      return (-1);

  for (x = (num_cols1*num_rows1*num_time_delay1*num_rowsi) - 1; x >= 0; --x)
    {
      input_weights_g_offset [x] = gaussian_rand (_variance) +
                                   input_weights_bias [x];
    }

  for (x = (num_cols2*num_rows2*num_time_delay2*num_rows1) - 1; x >= 0; --x)
    {
      hidden1_weights_g_offset [x] = gaussian_rand (_variance) +
                                     hidden1_weights_bias [x];
    }

  for (x = (num_outputs * num_cols2) - 1; x >= 0; --x)
    {
      hidden2_weights_g_offset [x] = gaussian_rand (_variance) +
                                     hidden2_weights_bias [x];
    }

  return (0);
}

void TD_Neural_network::update_weights_with_offset (int direction)
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

  for (x = (num_cols1*num_rows1*num_time_delay1*num_rowsi) - 1; x >= 0; --x)
    {
      input_weights [x] += (input_weights_g_offset [x] * dir);
      input_weights_bias [x] = offset_cofactor * input_weights_g_offset [x] +
                               bias_cofactor * input_weights_bias [x];
    }

  for (x = (num_cols2*num_rows2*num_time_delay2*num_rows1) - 1; x >= 0; --x)
    {
      hidden1_weights [x] += (hidden1_weights_g_offset [x] * dir);
      hidden1_weights_bias [x] = offset_cofactor * hidden1_weights_g_offset [x] +
                                 bias_cofactor * hidden1_weights_bias [x];
    }

  for (x = (num_outputs * num_cols2) - 1; x >= 0; --x)
    {
      hidden2_weights [x] += (hidden2_weights_g_offset [x] * dir);
      hidden2_weights_bias [x] = offset_cofactor * hidden2_weights_g_offset [x] +
                                 bias_cofactor * hidden2_weights_bias [x];
    }

}

