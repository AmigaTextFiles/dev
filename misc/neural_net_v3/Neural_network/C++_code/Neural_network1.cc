
#pragma implementation

#include <iostream.h>
#include <fstream.h>
#include <new.h>
#include <math.h>
#include "Neural_network1.h"

const double rand_max = RAND_MAX;


void Neural_network1::allocate_weight_matrices ()
{

  // Time to allocate the entire neural_net structure
  // Activation matrices
  hidden1_act = new double [num_hidden1];
  output_act = new double [num_outputs];

  // Weight matrices
  input_weights = new double [num_hidden1 * num_inputs];
  hidden1_weights = new double [num_outputs * num_hidden1];

}


void Neural_network1::allocate_bp_matrices ()
{
  if ( bp_flag )
    {
      // Learning rate matrices for each weight's learning rate.
      // Needed for delta-bar-delta algorithm
      input_learning_rate = new double [num_hidden1 * num_inputs];
      hidden1_learning_rate = new double [num_outputs * num_hidden1];

      // Momentum matrices for each weight's momentum value.
      // Needed for hybrid delta-bar-delta algorithm.
      input_momentum = new double [num_hidden1 * num_inputs];
      hidden1_momentum = new double [num_outputs * num_hidden1];

      // Learning rate deltas for each weight's learning rate.
      // Needed for delta-bar-delta algorithm.
      input_learning_delta = new double [num_hidden1 * num_inputs];
      hidden1_learning_delta = new double [num_outputs * num_hidden1];

      // Delta bar matrices for each weight's delta bar.
      // Needed for delta-bar-delta algorithm.
      input_learning_delta_bar = new double [num_hidden1 * num_inputs];
      hidden1_learning_delta_bar = new double [num_outputs * num_hidden1];

      // Weight delta matrices for each weights delta.
      // Needed for BackPropagation algorithm.
      input_weights_sum_delta = new double [num_hidden1 * num_inputs];
      hidden1_weights_sum_delta = new double [num_outputs * num_hidden1];

      // Sum of delta * weight matrices for each weight.
      // Needed for BackPropagation algorithm.
      hidden1_sum_delta_weight = new double [num_hidden1];
    }
  else // Set them all to zero
    {
      input_learning_rate = 0;
      hidden1_learning_rate = 0;

      input_momentum = 0;
      hidden1_momentum = 0;

      input_learning_delta = 0;
      hidden1_learning_delta = 0;

      input_learning_delta_bar = 0;
      hidden1_learning_delta_bar = 0;

      input_weights_sum_delta = 0;
      hidden1_weights_sum_delta = 0;

      hidden1_sum_delta_weight = 0;
    }
}


void Neural_network1::allocate_rand_opt_matrices ()
{

  if ( rand_opt_flag )
    {
      // Gaussian random vectors
      input_weights_g_offset = new double [num_hidden1 * num_inputs];
      hidden1_weights_g_offset = new double [num_outputs * num_hidden1];

      input_weights_bias = new double [num_hidden1 * num_inputs];
      hidden1_weights_bias = new double [num_outputs * num_hidden1];
    }
  else // Set them all to zero
    {
      input_weights_g_offset = 0;
      hidden1_weights_g_offset = 0;

      input_weights_bias = 0;
      hidden1_weights_bias = 0;
    }

}

void Neural_network1::initialize_learning_matrices ()
{
  int    x,y;

  for (x = 0; x < num_hidden1; ++x)
    {
      if ( bp_flag )
        {
          hidden1_sum_delta_weight [x] = 0.0;
        }

      for (y = 0; y < num_inputs; ++y)
        {
          if ( bp_flag )
            {
              input_weights_sum_delta [x * num_inputs + y] = 0.0;
              input_learning_rate [x * num_inputs + y] = _learning_rate;
              input_momentum [x * num_inputs + y] = 0.0;
              input_learning_delta [x * num_inputs + y] = 0.0;
              input_learning_delta_bar [x * num_inputs + y] = 0.0;
            }

          if ( rand_opt_flag )
            {
              input_weights_g_offset [x * num_inputs + y] = 0.0;
              input_weights_bias [x * num_inputs + y] = 0.0;
            }

        }
    }

  for (x = 0; x < num_outputs; ++x)
    {
      for (y = 0; y < num_hidden1; ++y)
        {
          if ( bp_flag )
            {
              hidden1_weights_sum_delta [x * num_hidden1 + y] = 0.0;
              hidden1_learning_rate [x * num_hidden1 + y] = _learning_rate;
              hidden1_momentum [x * num_hidden1 + y] = 0.0;
              hidden1_learning_delta [x * num_hidden1 + y] = 0.0;
              hidden1_learning_delta_bar [x * num_hidden1 + y] = 0.0;
            }

          if ( rand_opt_flag )
            {
              hidden1_weights_g_offset [x * num_hidden1 + y] = 0.0;
              hidden1_weights_bias [x * num_hidden1 + y] = 0.0;
            }

        }
    }

}

void Neural_network1::initialize_weight_matrices (double range)
{
  int    x;

  training_examples = 0;
  examples_since_update = 0;

  /* Initialize all weights from -range to +range randomly */
  for (x = num_hidden1 * num_inputs - 1; x >= 0; --x)
    {
      input_weights [x] = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
         input_weights [x] *= -1.0;

    }

  for (x = num_outputs * num_hidden1 - 1; x >= 0; --x)
    {
      hidden1_weights [x] = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          hidden1_weights [x] *= -1.0;

    }

}

void Neural_network1::deallocate_bp_matrices ()
{

  // Learning rate matrices for each weight's learning rate.
  // Needed for delta-bar-delta algorithm
  delete input_learning_rate;
  delete hidden1_learning_rate;
  input_learning_rate = 0;
  hidden1_learning_rate = 0;

  // Learning rate deltas for each weight's learning rate.
  // Needed for delta-bar-delta algorithm.
  delete input_learning_delta;
  delete hidden1_learning_delta;
  input_learning_delta = 0;
  hidden1_learning_delta = 0;

  // Momentum matrices for each weight's momentum.
  // Needed for hybrid delta-bar-delta algorithm.
  delete input_momentum;
  delete hidden1_momentum;
  input_momentum = 0;
  hidden1_momentum = 0;

  // Delta bar matrices for each weight's delta bar.
  // Needed for delta-bar-delta algorithm.
  delete input_learning_delta_bar;
  delete hidden1_learning_delta_bar;
  input_learning_delta_bar = 0;
  hidden1_learning_delta_bar = 0;

  // Weight delta matrices for each weights delta.
  // Needed for BackPropagation algorithm.
  delete input_weights_sum_delta;
  delete hidden1_weights_sum_delta;
  input_weights_sum_delta = 0;
  hidden1_weights_sum_delta = 0;

  // Sum of delta * weight matrices for each weight.
  // Needed for BackPropagation algorithm.
  delete hidden1_sum_delta_weight;
  hidden1_sum_delta_weight = 0;

}

void Neural_network1::deallocate_rand_opt_matrices ()
{

  // Gaussian random matrices for each weights offset
  // Needed by random optimization
  delete input_weights_g_offset;
  delete hidden1_weights_g_offset;
  input_weights_g_offset = 0;
  hidden1_weights_g_offset = 0;

  // Bias matrices for each weight's bias
  delete input_weights_bias;
  delete hidden1_weights_bias;
  input_weights_bias = 0;
  hidden1_weights_bias = 0;

}

void Neural_network1::deallocate_all_matrices ()
{

  // Time to destroy the entire neural_net structure
  // Activation matrices
  delete hidden1_act;
  delete output_act;
  hidden1_act = 0;
  output_act = 0;

  // Weight matrices
  delete input_weights;
  delete hidden1_weights;
  input_weights = 0;
  hidden1_weights = 0;

  deallocate_bp_matrices ();
  deallocate_rand_opt_matrices ();

  /* Done neural net deallocation */
}

Neural_network1::Neural_network1 (int number_inputs, int number_hidden1,
                                int number_outputs, int backpropagation_flag,
                                int random_optimization_flag, double range,
                                double variance, double alpha,
                                double beta, double epsilon,
                                double skip_epsilon,
                                double learning_rate, double theta,
                                double phi, double K, double hdec) :
                num_inputs (number_inputs), num_hidden1 (number_hidden1),
                num_outputs (number_outputs), bp_flag (backpropagation_flag),
                rand_opt_flag (random_optimization_flag), _alpha (alpha),
                _beta (beta), _epsilon (epsilon), _skip_epsilon (skip_epsilon),
                _learning_rate (learning_rate), _theta (theta), _phi (phi),
                _K (K), _hdec (hdec), _variance (variance),
                training_examples (0),
                examples_since_update (0)
{
  allocate_all_matrices ();
  initialize_all_matrices (range);
}


Neural_network1::Neural_network1 (String& filename, int& file_error,
                                int backpropagation_flag,
                                int random_optimization_flag,
                                double variance, double alpha,
                                double beta, double epsilon,
                                double skip_epsilon,
                                double learning_rate, double theta,
                                double phi, double K, double hdec) :
                bp_flag (backpropagation_flag),
                rand_opt_flag (random_optimization_flag),
                _alpha (alpha), _beta (beta),
                _epsilon (epsilon), _skip_epsilon (skip_epsilon),
                _learning_rate (learning_rate), _theta (theta), _phi (phi),
                _K (K), _hdec (hdec), _variance (variance),
                examples_since_update (0),
                hidden1_act (0), output_act (0),
                input_weights (0), hidden1_weights (0),
                input_learning_rate (0), hidden1_learning_rate (0),
                input_momentum (0),
                hidden1_momentum (0),
                input_learning_delta (0),
                hidden1_learning_delta (0),
                input_learning_delta_bar (0), hidden1_learning_delta_bar (0),
                input_weights_sum_delta (0),
                hidden1_weights_sum_delta (0),
                hidden1_sum_delta_weight (0),
                input_weights_g_offset (0), hidden1_weights_g_offset (0),
                input_weights_bias (0),
                hidden1_weights_bias (0)
{
  file_error = read_weights (filename);
}

int Neural_network1::read_weights (String& filename)
{
  ifstream fp;
  int      x;
  long     iter;

  fp.open (filename);
  if ( fp.fail() != 0 )
    {
      cout << "Could not read weights from file " << filename << "\n";
      return (-1);
    }

  /* First read in how many iterations have been performed so far */
  fp >> iter;
  cout << "Iterations = " << iter << "\n";

  /* Next read in how many input nodes, hidden1 nodes */
  /* and output nodes. */
  fp >> num_inputs >> num_hidden1 >> num_outputs;

  // Deallocate previous matrices
  deallocate_all_matrices ();

  /* Allocate new matrices with new size */
  allocate_all_matrices ();

  // Initialize all matrices and variables
  initialize_learning_matrices ();
  training_examples = iter;

  /* Read input->hidden1 weights from file. */
  for (x = 0; x < num_inputs * num_hidden1; ++x)
    {
      fp >> input_weights [x];
    }

  /* Read hidden1->output weights from file. */
  for (x = 0; x < (num_hidden1 * num_outputs); ++x)
    {
      fp >> hidden1_weights [x];
    }

  fp.close ();

  /* Now all the weights have been loaded */
 return (0);
}



int Neural_network1::save_weights (String& filename)
{
  ofstream fp;
  int      x;

  fp.open (filename);
  if ( fp.fail() != 0 )
    {
      cout << "Could not save weights to file " << filename << "\n";
      return (-1);
    }

  /* First write out how many iterations have been performed so far */
  fp << training_examples << "\n";

  /* Next write out how many input nodes, hidden1 nodes */
  /* and output nodes. */
  fp << num_inputs << " " << num_hidden1 << " ";
  fp << num_outputs << "\n";

  fp.precision (6);
  /* Write input->hidden1 weights to output. */
  for (x = 0; x < num_inputs * num_hidden1; ++x)
    {
      fp.width (10);
      fp << input_weights [x] << " ";
      if ( (x % 5) == 4 )
          fp << "\n";
    }
  fp << "\n\n";

  /* Write hidden1->output weights to output. */
  for (x = 0; x < (num_hidden1 * num_outputs); ++x)
    {
      fp.width (10);
      fp << hidden1_weights [x] << " ";
      if ( (x % 5) == 4 )
          fp << "\n";
    }
  fp << "\n\n";

  fp.close ();
  cout << "Closed file\n";

  /* Now all the weights have been saved */
  return (0);
}


void Neural_network1::set_standard_dbd_parameters ()
{
  _alpha = 0.4;
  _beta = 1.0;
  _epsilon = 0.1;
  _skip_epsilon = 0.05;
  _learning_rate = 0.1;
  _theta = 0.8;
  _phi = 0.2;
  _K = 0.025;
  _hdec = 0.0;
}


int Neural_network1::backpropagation_flag (int new_flag)
{
  int old_bp_flag = bp_flag;

  if ( new_flag == bp_flag )
      return (old_bp_flag);

  bp_flag = new_flag;

  if ( bp_flag == 0 )
    {
      // Deallocate matrices needed by backpropagation and delta-bar-delta.
      deallocate_bp_matrices ();
    }
  else
    {
      // Allocate matrices needed by backpropagation and delta-bar-delta.
      allocate_bp_matrices ();
      initialize_learning_matrices ();
    }

  return (old_bp_flag);
}


int Neural_network1::random_optimization_flag (int new_flag)
{
  int old_rand_opt_flag = rand_opt_flag;

  if ( new_flag == rand_opt_flag )
      return (old_rand_opt_flag);

  rand_opt_flag = new_flag;

  if ( rand_opt_flag == 0 )
    {
      // Deallocate matrices needed for Random Optimization algorithm.
      deallocate_rand_opt_matrices ();
    }
  else
    {
      // Allocate matrices needed for Random Optimization algorithm.
      allocate_rand_opt_matrices ();
      initialize_learning_matrices ();
    }

  return (old_rand_opt_flag);
}

double Neural_network1::learning_rate (double learning_rate)
{
  int    x;
  double old_learning_rate = _learning_rate;

  _learning_rate = learning_rate;

  if ( !bp_flag )
      return (old_learning_rate);

  for (x = num_hidden1 * num_inputs - 1; x >= 0; --x)
    {
      input_learning_rate [x] = _learning_rate;
    }

  for (x = num_outputs * num_hidden1 - 1; x >= 0; --x)
    {
      hidden1_learning_rate [x] = _learning_rate;
    }

  return (old_learning_rate);
}


void Neural_network1::set_size_parameters (int number_inputs,
                                 int number_hidden1,
                                 int number_outputs, double range)
{
  double *new_input_weights,*new_hidden1_weights;
  double rand_max;
  int    x;

  rand_max = RAND_MAX;

  // Allocate new weight matrices with new size
  new_input_weights = new double [number_hidden1 * number_inputs];
  new_hidden1_weights = new double [number_outputs * number_hidden1];

  // Copy over all weights
  // Input weights
  for (x = 0; x < number_hidden1 * number_inputs; ++x)
    {
      // IF the new size is larger than the old size, THEN make new connections
      // a random weight between +-range.
      if ( x >= (num_hidden1 * num_inputs) )
        {
          new_input_weights [x] = rand () / rand_max * range;
          if ( rand () < (RAND_MAX / 2) )
              new_input_weights [x] *= -1.0;
        }
      else
          new_input_weights [x] = input_weights [x];
    }

  // Hidden1 weights
  for (x = 0; x < number_outputs * number_hidden1; ++x)
    {
      // IF the new size is larger than the old size, THEN make new connections
      // a random weight between +-range.
      if ( x >= (num_outputs * num_hidden1) )
        {
          new_hidden1_weights [x] = rand () / rand_max * range;
          if ( rand () < (RAND_MAX / 2) )
              new_hidden1_weights [x] *= -1.0;
        }
      else
          new_hidden1_weights [x] = hidden1_weights [x];
    }

  // All weights have been copied.

  // Change size paramters
  num_inputs = number_inputs;
  num_hidden1 = number_hidden1;
  num_outputs = number_outputs;

  // Deallocate all matrices
  deallocate_all_matrices ();

  // Allocate new nerual network matrices with the correct size and initialize
  allocate_all_matrices ();
  initialize_learning_matrices ();

  // Now deallocate new randomly initialized weight matrices and assign them
  // to the new weight matrices that have the correct weight values.
  delete input_weights;
  delete hidden1_weights;

  input_weights = new_input_weights;
  hidden1_weights = new_hidden1_weights;

}


void Neural_network1::backpropagation (double input [],
                                       double desired_output [],
                                       int& done)
{
  int     x,y;
  int     size;
  double  delta,*weight,*p_sum_delta,*p_learning_delta;

  /* First check if training complete. */
  for (x = num_outputs - 1; x >= 0; --x)
    {
      if ( fabs (desired_output [x] - output_act [x]) > _epsilon )
        {
          done = 0;
        }
    }

  /* Go backward through list for speed */
  size = num_hidden1;
  /* First calculate deltas of weights from output to hidden layer 1. */
  for (x = num_outputs - 1; x >= 0; --x)
    {
      weight = &hidden1_weights [x * size];
      p_sum_delta = &hidden1_weights_sum_delta [x * size];
      p_learning_delta = &hidden1_learning_delta [x * size];

      /* Formula delta = (desired - actual) * derivative
         derivative = S(1 - S)
         Also calculate sum of deltas * weight for next layer.
      */
      delta = (desired_output [x] - output_act [x])
               * SLOPE * output_act [x] * (1.0 - output_act [x]);

      for (y = num_hidden1 - 1; y >= 0; --y)
        {
          hidden1_sum_delta_weight [y] += delta * weight [y];

          p_learning_delta [y] += delta;

          /* Now multiply by activation and sum in weights sum delta */
          p_sum_delta [y] += delta * hidden1_act [y];
        }
    }


  /* Finally calculate deltas of weights between hidden layer 1 and input
     layer */
  size = num_inputs;
  for (x = num_hidden1 - 1; x >= 0; --x)
    {
      p_sum_delta = &input_weights_sum_delta [x * size];
      p_learning_delta = &input_learning_delta [x * size];

      /* Formula delta = SUM (previous deltas*weight)
                         * derivative * activation of input
         previous deltas already muliplied by weight
         derivative = S(1 - S)
      */
      delta = hidden1_sum_delta_weight [x] * hidden1_act [x] *
              (1.0 - hidden1_act [x]) * SLOPE;

      for (y = num_inputs - 1; y >= 0; --y)
        {
          p_learning_delta [y] += delta;

          p_sum_delta [y] += (delta * input [y]);
        }
      hidden1_sum_delta_weight [x] = 0.0;
    }

  /* Now all deltas have been calculated and added into their appropriate
     neuron connection. */
  ++examples_since_update;

}


double Neural_network1::calc_forward (double input [], double desired_output [],
                                     int& num_wrong, int& skip, int print_it,
                                     int& actual_printed)
{
  int     x,y,wrong;
  int     size;
  double  *weight,error,abs_error;

  skip = 1;
  wrong = 0;
  error = 0.0;

  /* Go backward for faster processing */
  /* Calculate hidden layer 1's activation */
  size = num_inputs;
  for (x = num_hidden1 - 1; x >= 0;  --x)
    {
      hidden1_act [x] = 0.0;
      weight = &input_weights [x * size];
      for (y = num_inputs - 1; y >= 0; --y)
        {
          hidden1_act [x] += (input [y] * weight [y]);
        }
      hidden1_act [x] = S(hidden1_act [x]);
    }

  /* Calculate output layer's activation */
  size = num_hidden1;
  for (x = num_outputs - 1; x >= 0; --x)
    {
      output_act [x] = 0.0;
      weight = &hidden1_weights [x * size];
      for (y = num_hidden1 - 1; y >= 0; --y)
        {
          output_act [x] += hidden1_act [y] * weight [y];
        }
      output_act [x] = S(output_act [x]);
      abs_error = fabs (output_act [x] - desired_output [x]);
      error += abs_error;
      if ( abs_error > _epsilon )
          wrong = 1;
      if ( abs_error > _skip_epsilon )
          skip = 0;
    }

  if ( wrong )
      ++num_wrong;

  cout.precision (3);
  if ( print_it == 2 )
    {
      for (x = 0; x < num_outputs; ++x)
        {
          cout.width (6);
          cout << output_act [x] << " ";
        }
      ++actual_printed;
    }
  else if ( print_it && wrong )
    {
      for (x = 0; x < num_outputs; ++x)
        {
          cout.width (6);
          cout << fabs (desired_output [x] - output_act [x]) << " ";
        }
      ++actual_printed;
    }

  return (error);

}


void Neural_network1::update_weights ()
{
  int     x,y;
  int     size;
  double  rate,*p_ldelta,*p_ldelta_bar,*weight,*p_lrate,*p_sum_delta;
  double  *p_momentum;

  // Check to see if any changes have been calculated.
  if ( examples_since_update == 0 )
    {
      return;
    }

  /* Go backward for slightly faster processing */
  /* First add deltas of weights from output to hidden layer 1. */
  size = num_hidden1;
  for (x = num_outputs - 1; x >= 0; --x)
    {
      p_ldelta = &hidden1_learning_delta [x * size];
      p_ldelta_bar = &hidden1_learning_delta_bar [x * size];
      weight = &hidden1_weights [x * size];
      p_lrate = &hidden1_learning_rate [x * size];
      p_momentum = &hidden1_momentum [x * size];
      p_sum_delta = &hidden1_weights_sum_delta [x * size];

      for (y = num_hidden1 - 1; y >= 0; --y)
        {
          rate = p_ldelta [y] * p_ldelta_bar [y];
          if ( rate < 0.0 )
            {
              p_lrate [y] -= (_phi * p_lrate [y]);
            }
          else if ( rate > 0.0 )
            {
              p_lrate [y] += _K;
            }

          // This is actually DELTA weight [time t]
          p_momentum [y] = _beta * (p_lrate [y] * p_sum_delta [y]) +
                           _alpha * p_momentum [y] - _hdec * weight [y];
          weight [y] += p_momentum [y];
          p_sum_delta [y] = 0.0;
          p_ldelta_bar [y] *= _theta;
          p_ldelta_bar [y] += ((1.0 - _theta) * p_ldelta [y]);
          p_ldelta [y] = 0.0;
        }
    }


  /* Finally add deltas of weights between hidden layer 1 and input
     layer */
  size = num_inputs;
  for (x = num_hidden1 - 1; x >= 0; --x)
    {
      p_ldelta = &input_learning_delta [x * size];
      p_ldelta_bar = &input_learning_delta_bar [x * size];
      weight = &input_weights [x * size];
      p_lrate = &input_learning_rate [x * size];
      p_momentum = &input_momentum [x * size];
      p_sum_delta = &input_weights_sum_delta [x * size];

      for (y = num_inputs - 1; y >= 0; --y)
        {
          rate = p_ldelta [y] * p_ldelta_bar [y];
          if ( rate < 0.0 )
            {
              p_lrate [y] -= (_phi * p_lrate [y]);
            }
          else if ( rate > 0.0 )
            {
              p_lrate [y] += _K;
            }

          // This is actually DELTA weight [time t]
          p_momentum [y] = _beta * (p_lrate [y] * p_sum_delta [y]) +
                           _alpha * p_momentum [y] - _hdec * weight [y];
          weight [y] += p_momentum [y];
          p_sum_delta [y] = 0.0;
          p_ldelta_bar [y] *= _theta;
          p_ldelta_bar [y] += ((1.0 - _theta) * p_ldelta [y]);
          p_ldelta [y] = 0.0;
        }
    }

  /* Now all deltas have been added into their appropriate neuron
     connection. */
  training_examples += examples_since_update;
  examples_since_update = 0;

}


int Neural_network1::calc_forward_test (double input [],
                                       double desired_output [],
                                       int print_it, double correct_eps,
                                       double good_eps)
{
  int x,y,wrong,good;

  wrong = 0;
  good = 0;

  /* Go backward for faster processing */
  /* Calculate hidden layer 1's activation */
  for (x = num_hidden1 - 1; x >= 0;  --x)
    {
      hidden1_act [x] = 0.0;
      for (y = num_inputs - 1; y >= 0; --y)
        {
          hidden1_act [x] += (input [y] *
                              input_weights [x * num_inputs + y]);
        }
      hidden1_act [x] = S(hidden1_act [x]);
    }

  /* Calculate output layer's activation */
  for (x = num_outputs - 1; x >= 0; --x)
    {
      output_act [x] = 0.0;
      for (y = num_hidden1 - 1; y >= 0; --y)
        {
          output_act [x] += hidden1_act [y] *
                                hidden1_weights [x * num_hidden1 + y];
        }
      output_act [x] = S(output_act [x]);

      if ( fabs (output_act [x] - desired_output [x]) > good_eps )
          wrong = 1;
      else if ( fabs (output_act [x] - desired_output [x]) > correct_eps )
          good = 1;
    }

  cout.precision(3);
  if ( print_it )
    {
      for (x = 0; x < num_outputs; ++x)
        {
          cout.width (6);
          cout << output_act [x] << " ";
        }
    }

  if ( wrong )
      return (WRONG);
  else if ( good )
      return (GOOD);
  else
      return (CORRECT);
}


void Neural_network1::kick_weights (double range)
{
  int    x;
  double rand_max;
  double variation;

  rand_max = RAND_MAX;
  /* Add from -range to +range to all weights randomly */
  for (x = 0; x < (num_hidden1 * num_inputs); ++x)
    {
      variation = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          variation *= -1.0;
      input_weights [x] += variation;
    }

  for (x = 0; x < (num_outputs * num_hidden1); ++x)
    {
      variation = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          variation *= -1.0;
      hidden1_weights [x] += variation;
    }

}

