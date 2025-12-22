

#include "Neural_net2.h"
#include "gaussian_rand.h"

double Neural_net2_calc_forward_rand_opt (Neural_net2 *nn, double input [],
                                          double desired_output [],
                                          int *num_wrong, int direction)
{
  int     x,y,wrong;
  int     size;
  double  *weight,error,abs_error,dir,*offset;

  if ( !nn->rand_opt_flag )
      return (-1.0);

  if ( direction > 0 )
      dir = 1.0;
  else
      dir = -1.0;

  wrong = 0;
  error = 0.0;

  /* Go backward for faster processing */
  /* Calculate hidden layer 1's activation */
  size = nn->num_inputs;
  for (x = nn->num_hidden1 - 1; x >= 0;  --x)
    {
      nn->hidden1_act [x] = 0.0;
      weight = &nn->input_weights [x * size];
      offset = &nn->input_weights_g_offset [x * size];
      for (y = nn->num_inputs - 1; y >= 0; --y)
        {
          nn->hidden1_act [x] += (input [y] * (weight [y] + dir * offset [y]));
        }
      nn->hidden1_act [x] = S(nn->hidden1_act [x]);
    }

  /* Calculate hidden layer 2's activation */
  size = nn->num_hidden1;
  for (x = nn->num_hidden2 - 1; x >= 0; --x)
    {
      nn->hidden2_act [x] = 0.0;
      weight = &nn->hidden1_weights [x * size];
      offset = &nn->hidden1_weights_g_offset [x * size];
      for (y = nn->num_hidden1 - 1; y >= 0; --y)
        {
          nn->hidden2_act [x] += (nn->hidden1_act [y] *
                                  (weight [y] + dir * offset [y]));
        }
      nn->hidden2_act [x] = S(nn->hidden2_act [x]);
    }

  /* Calculate output layer's activation */
  size = nn->num_hidden2;
  for (x = nn->num_outputs - 1; x >= 0; --x)
    {
      nn->output_act [x] = 0.0;
      weight = &nn->hidden2_weights [x * size];
      offset = &nn->hidden2_weights_g_offset [x * size];
      for (y = nn->num_hidden2 - 1; y >= 0; --y)
        {
          nn->output_act [x] += nn->hidden2_act [y] *
                                 (weight [y] + dir * offset [y]);
        }
      nn->output_act [x] = S(nn->output_act [x]);
      abs_error = fabs (nn->output_act [x] - desired_output [x]);
      error += abs_error;
      if ( abs_error > nn->_epsilon )
          wrong = 1;
    }

  if ( wrong )
      ++(*num_wrong);

  return (error);

}

int Neural_net2_generate_gaussian_offsets (Neural_net2 *nn)
{
  int x;

  if ( nn->rand_opt_flag == 0 )
      return (-1);

  for (x = (nn->num_hidden1 * nn->num_inputs) - 1; x >= 0; --x)
    {
      nn->input_weights_g_offset [x] = gaussian_rand (nn->_variance) +
                                       nn->input_weights_bias [x];
    }

  for (x = (nn->num_hidden2 * nn->num_hidden1) - 1; x >= 0; --x)
    {
      nn->hidden1_weights_g_offset [x] = gaussian_rand (nn->_variance) +
                                         nn->hidden1_weights_bias [x];
    }

  for (x = (nn->num_outputs * nn->num_hidden2) - 1; x >= 0; --x)
    {
      nn->hidden2_weights_g_offset [x] = gaussian_rand (nn->_variance) +
                                         nn->hidden2_weights_bias [x];
    }

  return (0);
}

void Neural_net2_update_weights_with_offset (Neural_net2 *nn, int direction)
{
  int    x;
  double dir,offset_cofactor,bias_cofactor;

  if ( !nn->rand_opt_flag )
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

  for (x = nn->num_hidden1 * nn->num_inputs - 1; x >= 0; --x)
    {
      nn->input_weights [x] += (nn->input_weights_g_offset [x] * dir);
      nn->input_weights_bias [x] = offset_cofactor *
                                   nn->input_weights_g_offset [x] +
                                   bias_cofactor * nn->input_weights_bias [x];
    }

  for (x = nn->num_hidden2 * nn->num_hidden1 - 1; x >= 0; --x)
    {
      nn->hidden1_weights [x] += (nn->hidden1_weights_g_offset [x] * dir);
      nn->hidden1_weights_bias [x] = offset_cofactor *
                                      nn->hidden1_weights_g_offset [x] +
                                     bias_cofactor *
                                      nn->hidden1_weights_bias [x];
    }

  for (x = nn->num_outputs * nn->num_hidden2 - 1; x >= 0; --x)
    {
      nn->hidden2_weights [x] += (nn->hidden2_weights_g_offset [x] * dir);
      nn->hidden2_weights_bias [x] = offset_cofactor *
                                      nn->hidden2_weights_g_offset [x] +
                                     bias_cofactor *
                                      nn->hidden2_weights_bias [x];
    }

}

