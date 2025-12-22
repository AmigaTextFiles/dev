
#pragma implementation

#include <iostream.h>
#include <fstream.h>
#include <new.h>
#include <math.h>
#include "TD_Neural_network.h"

const double rand_max = RAND_MAX;


void TD_Neural_network::allocate_weight_matrices ()
{

  // Time to allocate the entire neural_net structure
  // Activation matrices
  hidden1_act = new double [num_cols1 * num_rows1];
  hidden2_act = new double [num_cols2 * num_rows2];
  output_act = new double [num_outputs];

  if ( (hidden1_act == 0) || (hidden2_act == 0) || (output_act == 0) )
    {
      cout << "Could not allocate activation matrices!!\n";
      exit (1);
    }

  // Weight matrices
  input_weights = new double [num_cols1 * num_rows1 * num_time_delay1 * num_rowsi];
  hidden1_weights = new double [num_cols2 * num_rows2 * num_time_delay2 * num_rows1];
  hidden2_weights = new double [num_outputs * num_cols2];

  if ( (input_weights == 0) || (hidden1_weights == 0) || (hidden2_weights == 0) )
    {
      cout << "Could not allocate weight matrices!!\n";
      exit (1);
    }
}

void TD_Neural_network::allocate_bp_matrices ()
{
  if ( bp_flag )
    {
      // Learning rate matrices for each weight's learning rate.
      // Needed for delta-bar-delta algorithm
      input_learning_rate = new double [num_cols1 * num_rows1 * num_time_delay1 *
                                        num_rowsi];
      hidden1_learning_rate = new double [num_cols2 * num_rows2 * num_time_delay2 *
                                          num_rows1];
      hidden2_learning_rate = new double [num_outputs * num_cols2];

      if ( (input_learning_rate == 0) || (hidden1_learning_rate == 0) ||
           (hidden2_learning_rate == 0) )
        {
          cout << "Could not allocate learning_rate matrices!!\n";
          exit (1);
        }

      // Momentum matrices for each weight's momentum.
      // Needed for hybrid delta-bar-delta algorithm
      input_momentum = new double [num_cols1 * num_rows1 * num_time_delay1 *
                                        num_rowsi];
      hidden1_momentum = new double [num_cols2 * num_rows2 * num_time_delay2 *
                                          num_rows1];
      hidden2_momentum = new double [num_outputs * num_cols2];

      if ( (input_momentum == 0) || (hidden1_momentum == 0) ||
           (hidden2_momentum == 0) )
        {
          cout << "Could not allocate momentum matrices!!\n";
          exit (1);
        }

      // Learning rate deltas for each weight's learning rate.
      // Needed for delta-bar-delta algorithm.
      input_learning_delta = new double [num_cols1 * num_rows1 * num_time_delay1 *
                                         num_rowsi];
      hidden1_learning_delta = new double [num_cols2 * num_rows2 * num_time_delay2 *
                                           num_rows1];
      hidden2_learning_delta = new double [num_outputs * num_cols2];

      if ( (input_learning_delta == 0) || (hidden1_learning_delta == 0) ||
           (hidden2_learning_delta == 0) )
        {
          cout << "Could not allocate learning_delta matrices!!\n";
          exit (1);
        }

      // Delta bar matrices for each weight's delta bar.
      // Needed for delta-bar-delta algorithm.
      input_learning_delta_bar = new double [num_cols1 * num_rows1 *
                                             num_time_delay1 * num_rowsi];
      hidden1_learning_delta_bar = new double [num_cols2 * num_rows2 *
                                               num_time_delay2 * num_rows1];
      hidden2_learning_delta_bar = new double [num_outputs * num_cols2];

      if ( (input_learning_delta_bar == 0) || (hidden1_learning_delta_bar == 0) ||
           (hidden2_learning_delta_bar == 0) )
        {
          cout << "Could not allocate learning_delta_bar matrices!!\n";
          exit (1);
        }

      // Weight delta matrices for each weights delta.
      // Needed for BackPropagation algorithm.
      input_weights_sum_delta = new double [num_cols1 * num_rows1 *
                                            num_time_delay1 * num_rowsi];
      hidden1_weights_sum_delta = new double [num_cols2 * num_rows2 *
                                              num_time_delay2 * num_rows1];
      hidden2_weights_sum_delta = new double [num_outputs * num_cols2];

      if ( (input_weights_sum_delta == 0) || (hidden1_weights_sum_delta == 0) ||
           (hidden2_weights_sum_delta == 0) )
        {
          cout << "Could not allocate weights_sum_delta matrices!!\n";
          exit (1);
        }

      // Sum of delta * weight matrices for each weight.
      // Needed for BackPropagation algorithm.
      hidden1_sum_delta_weight = new double [num_cols1 * num_rows1];
      hidden2_sum_delta_weight = new double [num_cols2 * num_rows2];

      if ( (hidden1_sum_delta_weight == 0) || (hidden2_sum_delta_weight == 0) )
        {
          cout << "Could not allocate sum_delta_weight matrices!!\n";
          exit (1);
        }
    }
  else  // Set them all to 0
    {
      // Learning rate matrices for each weight's learning rate.
      // Needed for delta-bar-delta algorithm
      input_learning_rate = 0;
      hidden1_learning_rate = 0;
      hidden2_learning_rate = 0;

      // Momentum matrices for each weight's momentum.
      // Needed for hybrid delta-bar-delta algorithm.
      input_momentum = 0;
      hidden1_momentum = 0;
      hidden2_momentum = 0;

      // Learning rate deltas for each weight's learning rate.
      // Needed for delta-bar-delta algorithm.
      input_learning_delta = 0;
      hidden1_learning_delta = 0;
      hidden2_learning_delta = 0;

      // Delta bar matrices for each weight's delta bar.
      // Needed for delta-bar-delta algorithm.
      input_learning_delta_bar = 0;
      hidden1_learning_delta_bar = 0;
      hidden2_learning_delta_bar = 0;

      // Weight delta matrices for each weights delta.
      // Needed for BackPropagation algorithm.
      input_weights_sum_delta = 0;
      hidden1_weights_sum_delta = 0;
      hidden2_weights_sum_delta = 0;

      // Sum of delta * weight matrices for each weight.
      // Needed for BackPropagation algorithm.
      hidden1_sum_delta_weight = 0;
      hidden2_sum_delta_weight = 0;


    }

}

void TD_Neural_network::allocate_rand_opt_matrices ()
{
  if ( rand_opt_flag )
    {
      // Gaussian random vectors
      input_weights_g_offset = new double [num_cols1 * num_rows1 *
                                           num_time_delay1 * num_rowsi];
      hidden1_weights_g_offset = new double [num_cols2 * num_rows2 *
                                             num_time_delay2 * num_rows1];
      hidden2_weights_g_offset = new double [num_outputs * num_cols2];

      if ( (input_weights_g_offset == 0) || (hidden1_weights_g_offset == 0) ||
           (hidden2_weights_g_offset == 0) )
        {
          cout << "Could not allocate gaussian matrices!!\n";
          exit (1);
        }

      input_weights_bias = new double [num_cols1 * num_rows1 *
                                       num_time_delay1 * num_rowsi];
      hidden1_weights_bias = new double [num_cols2 * num_rows2 *
                                         num_time_delay2 * num_rows1];
      hidden2_weights_bias = new double [num_outputs * num_cols2];

      if ( (input_weights_bias == 0) || (hidden1_weights_bias == 0) ||
           (hidden2_weights_bias == 0) )
        {
          cout << "Could not allocate bias matrices!!\n";
          exit (1);
        }

    }
  else // Set them all to 0
    {
      input_weights_g_offset = 0;
      hidden1_weights_g_offset = 0;
      hidden2_weights_g_offset = 0;

      input_weights_bias = 0;
      hidden1_weights_bias = 0;
      hidden2_weights_bias = 0;
    }
}


void TD_Neural_network::initialize_weight_matrices (double range)
{
  int    x;

  training_examples = 0;
  examples_since_update = 0;

  /* Initialize all weights from -range to +range randomly */
  for (x = num_cols1 * num_rows1 * num_time_delay1 * num_rowsi - 1; x >= 0; --x)
    {
      input_weights [x] = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          input_weights [x] *= -1.0;

    }

  for (x = num_cols2 * num_rows2 * num_time_delay2 * num_rows1 - 1; x >= 0; --x)
    {
      hidden1_weights [x] = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          hidden1_weights [x] *= -1.0;

    }

  for (x = num_outputs * num_cols2 - 1; x >= 0; --x)
    {
      hidden2_weights [x] = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          hidden2_weights [x] *= -1.0;

    }

}

void TD_Neural_network::initialize_learning_matrices ()
{
  int    x,z,offset;

  training_examples = 0;
  examples_since_update = 0;

  /* Initialize all weights from -range to +range randomly */
  for (x = num_cols1 * num_rows1 - 1; x >= 0; --x)
    {
      if ( bp_flag )
          hidden1_sum_delta_weight [x] = 0.0;
      offset = x * num_time_delay1 * num_rowsi;

      for (z = (num_time_delay1*num_rowsi - 1); z >= 0; --z)
        {
          if ( bp_flag )
            {
              input_weights_sum_delta [offset + z] = 0.0;
              input_learning_rate [offset + z] = _learning_rate;
              input_momentum [offset + z] = 0.0;
              input_learning_delta [offset + z] = 0.0;
              input_learning_delta_bar [offset + z] = 0.0;
            }

          if ( rand_opt_flag )
            {
              input_weights_g_offset [offset + z] = 0.0;
              input_weights_bias [offset + z] = 0.0;
            }
        }
    }

  for (x = num_cols2 * num_rows2 - 1; x >= 0; --x)
    {
      if ( bp_flag )
          hidden2_sum_delta_weight [x] = 0.0;
      offset = x * num_time_delay2 * num_rows1;

      for (z = (num_time_delay2*num_rows1 - 1); z >= 0; --z)
        {
          if ( bp_flag )
            {
              hidden1_weights_sum_delta [offset + z] = 0.0;
              hidden1_learning_rate [offset + z] = _learning_rate;
              hidden1_momentum [offset + z] = 0.0;
              hidden1_learning_delta [offset + z] = 0.0;
              hidden1_learning_delta_bar [offset + z] = 0.0;
            }

          if ( rand_opt_flag )
            {
              hidden1_weights_g_offset [offset + z] = 0.0;
              hidden1_weights_bias [offset + z] = 0.0;
            }
        }
    }

  for (x = num_outputs * num_cols2 - 1; x >= 0; --x)
    {
      if ( bp_flag )
        {
          hidden2_weights_sum_delta [x] = 0.0;
          hidden2_learning_rate [x] = _learning_rate;
          hidden2_momentum [x] = 0.0;
          hidden2_learning_delta [x] = 0.0;
          hidden2_learning_delta_bar [x] = 0.0;
        }

      if ( rand_opt_flag )
        {
          hidden2_weights_g_offset [x] = 0.0;
          hidden2_weights_bias [x] = 0.0;
        }
    }

}


void TD_Neural_network::deallocate_bp_matrices ()
{

  // Learning rate matrices for each weight's learning rate.
  // Needed for delta-bar-delta algorithm
  delete input_learning_rate;
  delete hidden1_learning_rate;
  delete hidden2_learning_rate;
  input_learning_rate = 0;
  hidden1_learning_rate = 0;
  hidden2_learning_rate = 0;

  // Momentum matrices for each weight's momentum.
  // Needed for hybrid delta-bar-delta algorithm.
  delete input_momentum;
  delete hidden1_momentum;
  delete hidden2_momentum;
  input_momentum = 0;
  hidden1_momentum = 0;
  hidden2_momentum = 0;

  // Learning rate deltas for each weight's learning rate.
  // Needed for delta-bar-delta algorithm.
  delete input_learning_delta;
  delete hidden1_learning_delta;
  delete hidden2_learning_delta;
  input_learning_delta = 0;
  hidden1_learning_delta = 0;
  hidden2_learning_delta = 0;

  // Delta bar matrices for each weight's delta bar.
  // Needed for delta-bar-delta algorithm.
  delete input_learning_delta_bar;
  delete hidden1_learning_delta_bar;
  delete hidden2_learning_delta_bar;
  input_learning_delta_bar = 0;
  hidden1_learning_delta_bar = 0;
  hidden2_learning_delta_bar = 0;

  // Weight delta matrices for each weights delta.
  // Needed for BackPropagation algorithm.
  delete input_weights_sum_delta;
  delete hidden1_weights_sum_delta;
  delete hidden2_weights_sum_delta;
  input_weights_sum_delta = 0;
  hidden1_weights_sum_delta = 0;
  hidden2_weights_sum_delta = 0;

  // Sum of delta * weight matrices for each weight.
  // Needed for BackPropagation algorithm.
  delete hidden1_sum_delta_weight;
  delete hidden2_sum_delta_weight;
  hidden1_sum_delta_weight = 0;
  hidden2_sum_delta_weight = 0;

}

void TD_Neural_network::deallocate_rand_opt_matrices ()
{

  // Gaussian random matrices for each weights offset
  // Needed by random optimization
  delete input_weights_g_offset;
  delete hidden1_weights_g_offset;
  delete hidden2_weights_g_offset;
  input_weights_g_offset = 0;
  hidden1_weights_g_offset = 0;
  hidden2_weights_g_offset = 0;

  // Bias matrices for each weight's bias
  delete input_weights_bias;
  delete hidden1_weights_bias;
  delete hidden2_weights_bias;
  input_weights_bias = 0;
  hidden1_weights_bias = 0;
  hidden2_weights_bias = 0;

}


void TD_Neural_network::deallocate_all_matrices ()
{

  // Time to destroy the entire neural_net structure
  // Activation matrices
  delete hidden1_act;
  delete hidden2_act;
  delete output_act;
  hidden1_act = 0;
  hidden2_act = 0;
  output_act = 0;

  // Weight matrices
  delete input_weights;
  delete hidden1_weights;
  delete hidden2_weights;
  input_weights = 0;
  hidden1_weights = 0;
  hidden2_weights = 0;

  deallocate_bp_matrices ();
  deallocate_rand_opt_matrices ();

  /* Done neural net deallocation */
}


// Done
TD_Neural_network::TD_Neural_network (int number_rowsi, int number_colsi,
                                int number_rows1, int number_time_delay1,
                                int number_time_delay2, int number_outputs,
                                int backpropagation_flag,
                                int random_optimization_flag,
                                double range, double variance,
                                double alpha, double beta,
                                double epsilon, double skip_epsilon,
                                double learning_rate, double theta,
                                double phi, double K, double hdec) :
                num_rowsi (number_rowsi), num_colsi (number_colsi),
                num_rows1 (number_rows1), num_time_delay1 (number_time_delay1),
                num_cols1 (number_colsi - number_time_delay1 + 1),
                num_rows2 (number_outputs), num_time_delay2 (number_time_delay2),
                num_cols2 (num_cols1 - number_time_delay2 + 1),
                num_outputs (number_outputs),
                bp_flag (backpropagation_flag),
                rand_opt_flag (random_optimization_flag), _variance (variance),
                _alpha (alpha), _beta (beta),
                _epsilon (epsilon), _skip_epsilon (skip_epsilon),
                _learning_rate (learning_rate), _theta (theta), _phi (phi),
                _K (K), _hdec (hdec),
                training_examples (0), examples_since_update (0)
{
  if ( (num_cols1 <= 0) || (num_cols2 <= 0) )
    {
      cout << "Illegal network dimensions!!!\n";
      exit (1);
    }

  allocate_all_matrices ();
  initialize_all_matrices (range);
}

// Done
TD_Neural_network::TD_Neural_network (String& filename, int& file_error,
                                int backpropagation_flag,
                                int random_optimization_flag,
                                double variance,
                                double alpha, double beta,
                                double epsilon, double skip_epsilon,
                                double learning_rate, double theta,
                                double phi, double K, double hdec) :
                bp_flag (backpropagation_flag),
                rand_opt_flag (random_optimization_flag),
                _variance (variance), _alpha (alpha), _beta (beta),
                _epsilon (epsilon), _skip_epsilon (skip_epsilon),
                _learning_rate (learning_rate), _theta (theta), _phi (phi),
                _K (K), _hdec (hdec), examples_since_update (0),
                hidden1_act (0), hidden2_act (0), output_act (0),
                input_weights (0), hidden1_weights (0), hidden2_weights (0),
                input_learning_rate (0), hidden1_learning_rate (0),
                hidden2_learning_rate (0), input_momentum (0),
                hidden1_momentum (0), hidden2_momentum (0),
                input_learning_delta (0),
                hidden1_learning_delta (0), hidden2_learning_delta (0),
                input_learning_delta_bar (0), hidden1_learning_delta_bar (0),
                hidden2_learning_delta_bar (0), input_weights_sum_delta (0),
                hidden1_weights_sum_delta (0), hidden2_weights_sum_delta (0),
                hidden1_sum_delta_weight (0), hidden2_sum_delta_weight (0),
                input_weights_g_offset (0), hidden1_weights_g_offset (0),
                hidden2_weights_g_offset (0), input_weights_bias (0),
                hidden1_weights_bias (0), hidden2_weights_bias (0)
{
  file_error = read_weights (filename);
}

// Done
int TD_Neural_network::read_weights (String& filename)
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

  /* Next read in how many input rows and cols, hidden1 rows and time_delay,
     hidden2 time_delay, and output nodes. */
  fp >> num_rowsi >> num_colsi >> num_rows1 >> num_time_delay1
     >> num_time_delay2 >> num_outputs;

  // Now calculate missing parameters
  num_cols1 = num_colsi - num_time_delay1 + 1;
  num_rows2 = num_outputs;
  num_cols2 = num_cols1 - num_time_delay2 + 1;

  // Deallocate previous matrices
  deallocate_all_matrices ();

  /* Allocate new matrices with new size */
  allocate_all_matrices ();

  // Initialize all matrices and variables
  initialize_learning_matrices ();

  training_examples = iter;

  /* Read input->hidden1 weights from file. */
  for (x = 0; x < (num_cols1 * num_rows1 * num_time_delay1 * num_rowsi); ++x)
    {
      fp >> input_weights [x];
    }

  /* Read hidden1->hidden2 weights from file. */
  for (x = 0; x < (num_cols2 * num_rows2 * num_time_delay2 * num_rows1); ++x)
    {
      fp >> hidden1_weights [x];
    }

  /* Read hidden2->output weights from file. */
  for (x = 0; x < (num_outputs * num_cols2); ++x)
    {
      fp >> hidden2_weights [x];
    }

  fp.close ();

  /* Now all the weights have been loaded */
 return (0);
}


// Done
int TD_Neural_network::save_weights (String& filename)
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

  /* Next write out how many input rows and cols, hidden1 rows and time_delay,
     hidden2 time_delay, and output nodes. */
  fp << num_rowsi << " " << num_colsi << " " << num_rows1 << " "
     << num_time_delay1 << " " << num_time_delay2 << " " << num_outputs << "\n";

  fp.precision (6);
  /* Write input->hidden1 weights to output. */
  for (x = 0; x < (num_cols1 * num_rows1 * num_time_delay1 * num_rowsi); ++x)
    {
      fp.width (10);
      fp << input_weights [x] << " ";
      if ( (x % 5) == 4 )
          fp << "\n";
    }
  fp << "\n\n";

  /* Write hidden1->hidden2 weights to output. */
  for (x = 0; x < (num_cols2 * num_rows2 * num_time_delay2 * num_rows1); ++x)
    {
      fp.width (10);
      fp << hidden1_weights [x] << " ";
      if ( (x % 5) == 4 )
          fp << "\n";
    }
  fp << "\n\n";

  /* Write hidden2->output weights to output. */
  for (x = 0; x < (num_outputs * num_cols2); ++x)
    {
      fp.width (10);
      fp << hidden2_weights [x] << " ";
      if ( (x % 5) == 4 )
          fp << "\n";
    }
  fp << "\n\n";

  fp.close ();
  cout << "Closed file\n";

  /* Now all the weights have been saved */
  return (0);
}


// Done
int TD_Neural_network::set_size_parameters (int number_input_rows,
                         int number_input_cols, int number_hidden1_rows,
                         int number_hidden1_time_delay, int number_hidden2_time_delay,
                         int number_outputs, double range)
{
  double *new_input_weights,*new_hidden1_weights,*new_hidden2_weights;
  int    x,y,z,z2,number_hidden1_cols,number_hidden2_cols,number_hidden2_rows;
  int    offset;

  // Allocate new weight matrices with new size
  number_hidden1_cols = number_input_cols - number_hidden1_time_delay + 1;
  number_hidden2_cols = number_hidden1_cols - number_hidden2_time_delay + 1;
  number_hidden2_rows = number_outputs;
  new_input_weights = new double [number_hidden1_cols * number_hidden1_rows *
                                  number_hidden1_time_delay * number_input_rows];
  new_hidden1_weights = new double [number_hidden2_cols * number_hidden2_rows *
                                    number_hidden2_time_delay * number_hidden1_rows];
  new_hidden2_weights = new double [number_outputs * number_hidden2_cols];

  if ( (new_input_weights == 0) || (new_hidden1_weights == 0) ||
       (new_hidden2_weights == 0) )
    {
      cout << "Could not allocate new matrices in "
           << "TD_Neural_network::set_size_parameters!\n";
      return (-1);
    }

  // Copy over all weights
  // Input weights
  for (x = 0; x < number_hidden1_cols; ++x)
    {
      for (y = 0; y < number_hidden1_rows; ++y)
        {
          for (z = 0; z < number_hidden1_time_delay; ++z)
            {
              for (z2 = 0; z2 < number_input_rows; ++z2)
                {
                  offset = ((x * number_hidden1_rows + y) *
                             number_hidden1_time_delay + z) * number_input_rows + z2;

                  // IF the new size is larger than the old size,
                  // THEN make new connections a random weight between +-range.
                  if ( (x >= num_cols1) || (y >= num_rows1) ||
                       (z >= num_time_delay1) || (z2 >= num_rowsi) )
                    {
                      new_input_weights [offset] = rand () / rand_max * range;
                      if ( rand () < (RAND_MAX / 2) )
                          new_input_weights [offset] *= -1.0;
                    }
                  else
                      new_input_weights [offset] = get_input_weight (y,x,z2,z);
                }
            }
        }
    }

  // Hidden1 weights
  for (x = 0; x < number_hidden2_cols; ++x)
    {
      for (y = 0; y < number_hidden2_rows; ++y)
        {
          for (z = 0; z < number_hidden2_time_delay; ++z)
            {
              for (z2 = 0; z2 < number_hidden1_rows; ++z2)
                {
                  offset = ((x * number_hidden2_rows + y) *
                             number_hidden2_time_delay + z) * number_hidden1_rows + z2;

                  // IF the new size is larger than the old size,
                  // THEN make new connections a random weight between +-range.
                  if ( (x >= num_cols2) || (y >= num_rows2) ||
                       (z >= num_time_delay2) || (z2 >= num_rows1) )
                    {
                      new_hidden1_weights [offset] = rand () / rand_max * range;
                      if ( rand () < (RAND_MAX / 2) )
                          new_hidden1_weights [offset] *= -1.0;
                    }
                  else
                      new_hidden1_weights [offset] = get_hidden1_weight (y,x,z2,z);
                }
            }
        }
    }

  // Hidden2 weights
  for (x = 0; x < number_outputs; ++x)
    {
      for (y = 0; y < number_hidden2_cols; ++y)
        {
          offset = x * number_hidden2_cols + y;

          // IF the new size is larger than the old size,
          // THEN make new connections a random weight between +-range.
          if ( (x >= num_outputs) || (y >= num_cols2) )
            {
              new_hidden2_weights [offset] = rand () / rand_max * range;
              if ( rand () < (RAND_MAX / 2) )
                  new_hidden2_weights [offset] *= -1.0;
            }
          else
              new_hidden2_weights [offset] = get_hidden2_weight (x,y);
        }
    }

  // All weights have been copied.

  // Change size paramters
  num_rowsi = number_input_rows;
  num_colsi = number_input_cols;
  num_rows1 = number_hidden1_rows;
  num_cols1 = number_hidden1_cols;
  num_time_delay1 = number_hidden1_time_delay;
  num_rows2 = number_hidden2_rows;
  num_cols2 = number_hidden2_cols;
  num_time_delay2 = number_hidden2_time_delay;
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
  delete hidden2_weights;

  input_weights = new_input_weights;
  hidden1_weights = new_hidden1_weights;
  hidden2_weights = new_hidden2_weights;

  return (0);
}

int TD_Neural_network::backpropagation_flag (int new_flag)
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


int TD_Neural_network::random_optimization_flag (int new_flag)
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


double TD_Neural_network::learning_rate (double learning_rate)
{
  int    x;
  double old_learning_rate = _learning_rate;

  _learning_rate = learning_rate;

  if ( !bp_flag )
      return (old_learning_rate);

  for (x = num_cols1 * num_rows1 * num_time_delay1 * num_rowsi - 1; x >= 0; --x)
    {
      input_learning_rate [x] = _learning_rate;
    }

  for (x = num_cols2 * num_rows1 * num_time_delay2 * num_rows1 - 1; x >= 0; --x)
    {
      hidden1_learning_rate [x] = _learning_rate;
    }

  for (x = num_outputs * num_cols2 - 1; x >= 0; --x)
    {
      hidden2_learning_rate [x] = _learning_rate;
    }

  return (old_learning_rate);
}


void TD_Neural_network::set_standard_dbd_parameters ()
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


void TD_Neural_network::backpropagation (double input [],
                                         double desired_output [],
                                         int& done)
{
  int     x,y,z;
  int     offset;
  double  delta;

  if ( !bp_flag )
    {
      cout << "Trying to back_propagate TEST_ONLY network!!\n";
      return;
    }

  /* First check if training complete. */
  for (x = num_outputs - 1; x >= 0; --x)
    {
      if ( fabs (desired_output [x] - output_act [x]) > _epsilon )
        {
          done = 0;
        }
    }

  /* Go backward through list for speed */
  /* First calculate deltas of weights from output to hidden layer 2. */
  for (x = num_outputs - 1; x >= 0; --x)
    {
      offset = x * num_cols2;

      /* Formula delta = (desired - actual) * derivative
         derivative = S(1 - S)
         Also calculate sum of deltas * weight for next layer.
      */
      // Calculate delta but do not multiply by hidden2 node activation
      // just yet.  This intermediate value is needed to calculate
      // the deltas from hidden2 to hidden1.
      delta = (desired_output [x] - output_act [x])
               * SLOPE * output_act [x] * (1.0 - output_act [x]);

      for (y = num_cols2 - 1; y >= 0; --y)
        {
          // Need sum of all deltas * weight for all weights connected to
          // each node in hidden2 to use to calculate the deltas for
          // hidden1.  Used by backpropagaion
          hidden2_sum_delta_weight [y * num_rows2 + x] += delta *
              hidden2_weights [offset + y];

          // Add calculate change in weight from hidden2 to output
          // Use += because it is summing all the deltas for all examples
          // Needed for delta-bar-delta learning rule.
          hidden2_learning_delta [offset + y] += delta;

          // Add delta for weight * activation for this example
          // Contains the update delta for backpropagation
          hidden2_weights_sum_delta [offset + y] += delta *
              hidden2_act [y * num_rows2 + x];
        }
    }


  /* Next calculate deltas of weights between hidden layer2 and hidden
     layer 1 */
  for (x = num_cols2 - 1; x >= 0; --x)
    {
      for (y = num_rows2 - 1; y >= 0; --y)
        {
          offset = x * num_rows2 + y;
          /* Formula delta = SUM (previous deltas*weight)
                             * derivative
             previous deltas already muliplied by weight.
             derivative = S(1 - S)

             Also calculate sum of deltas * weight to save from doing
             it for next layer.
          */

          delta = hidden2_sum_delta_weight [offset] * hidden2_act [offset] *
                  (1.0 - hidden2_act [offset]) * SLOPE;
          hidden2_sum_delta_weight [offset] = 0.0;

          offset = (x * num_rows2 + y) * num_time_delay2 * num_rows1;
          for (z = (num_time_delay2 * num_rows1 - 1); z >= 0; --z)
            {
              hidden1_sum_delta_weight [x * num_rows1 + z] += delta *
                  hidden1_weights [offset + z];

              hidden1_learning_delta [offset + z] += delta;

              /* Now multiply by activation and sum in weights_sum_delta */
              hidden1_weights_sum_delta [offset + z] += delta *
                  hidden1_act [x * num_rows1 + z];
            }
        }
    }

  /* Finally calculate deltas of weights between hidden layer 1 and input
     layer */
  for (x = num_cols1 - 1; x >= 0; --x)
    {
      for (y = num_rows1 - 1; y >= 0; --y)
        {
          offset = x * num_rows1 + y;
          /* Formula delta = SUM (previous deltas*weight)
                             * derivative * activation of input
             previous deltas already muliplied by weight
             derivative = S(1 - S)
          */
          delta = hidden1_sum_delta_weight [offset] * hidden1_act [offset] *
                  (1.0 - hidden1_act [offset]) * SLOPE;
          hidden1_sum_delta_weight [offset] = 0.0;

          offset = (x * num_rows1 + y) * num_time_delay1 * num_rowsi;
          for (z = (num_time_delay1 * num_rowsi - 1); z >= 0; --z)
            {
              input_learning_delta [offset + z] += delta;

              input_weights_sum_delta [offset + z] += (delta *
                                                       input [x * num_rowsi + z]);
            }
        }
    }

  /* Now all deltas have been calculated and added into their appropriate
     neuron connection. */
  ++examples_since_update;

}

// Done
double TD_Neural_network::calc_forward (double input [], double desired_output [],
                                     int& num_wrong, int& skip, int print_it,
                                     int& actual_printed)
{
  int     x,y,z,wrong;
  int     offset,offset_act;
  double  *weight,error,abs_error;

  skip = 1;
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
          weight = &input_weights [(x * num_rows1 + y) * num_time_delay1 * num_rowsi];
          offset = x * num_rowsi;
          for (z = (num_time_delay1 * num_rowsi - 1); z >= 0; --z)
            {
              hidden1_act [offset_act] += (input [offset + z] * weight [z]);
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
          weight = &hidden1_weights [(x*num_rows2 + y) * num_time_delay2 * num_rows1];
          offset = x * num_rows1;
          for (z = (num_time_delay2 * num_rows1 - 1); z >= 0; --z)
            {
              hidden2_act [offset_act] += (hidden1_act [offset + z] * weight [z]);
            }
          hidden2_act [offset_act] = S(hidden2_act [offset_act]);
        }
    }

  /* Calculate output layer's activation */
  for (x = num_outputs - 1; x >= 0; --x)
    {
      output_act [x] = 0.0;
      weight = &hidden2_weights [x * num_cols2];
      for (y = num_cols2 - 1; y >= 0; --y)
        {
          output_act [x] += hidden2_act [y * num_rows2 + x] * weight [y];
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

// Done
void TD_Neural_network::update_weights ()
{
  int     x,y,z;
  int     offset;
  double  rate;

  if ( !bp_flag )
    {
      cout << "Trying to update_weights of TEST_ONLY network!!\n";
      return;
    }

  // Check to see if any changes have been calculated.
  if ( examples_since_update == 0 )
    {
      return;
    }

  /* Go backward for slightly faster processing */
  /* First add deltas of weights from output to hidden layer 2. */
  for (x = num_outputs - 1; x >= 0; --x)
    {
      offset = x * num_cols2;
      for (y = num_cols2 - 1; y >= 0; --y)
        {
          rate = hidden2_learning_delta [offset+y] *
                 hidden2_learning_delta_bar [offset+y];
          if ( rate < 0.0 )
            {
              hidden2_learning_rate [offset+y] -=
                  (_phi * hidden2_learning_rate [offset+y]);
            }
          else if ( rate > 0.0 )
            {
              hidden2_learning_rate [offset+y] += _K;
            }

          // This is really DELTA weight [time]
          hidden2_momentum [offset+y] = _beta *
                                         (hidden2_learning_rate [offset+y] *
                                        hidden2_weights_sum_delta [offset+y]) +
                                        _alpha * hidden2_momentum [offset+y] -
                                        _hdec * hidden2_weights [offset+y];
          hidden2_weights [offset+y] += hidden2_momentum [offset+y];
          hidden2_weights_sum_delta [offset+y] = 0.0;
          hidden2_learning_delta_bar [offset+y] *= _theta;
          hidden2_learning_delta_bar [offset+y] += ((1.0 - _theta) *
              hidden2_learning_delta [offset+y]);
          hidden2_learning_delta [offset+y] = 0.0;
        }
    }

  /* Next add deltas of weights between hidden layer2 and hidden
     layer 1 */
  for (x = num_cols2 - 1; x >= 0; --x)
    {
      for (y = num_rows2 - 1; y >= 0; --y)
        {
          offset = (x * num_rows2 + y) * num_time_delay2 * num_rows1;
          for (z = num_time_delay2 * num_rows1 - 1; z >= 0; --z)
            {
              rate = hidden1_learning_delta [offset+z] *
                     hidden1_learning_delta_bar [offset+z];
              if ( rate < 0.0 )
                {
                  hidden1_learning_rate [offset+z] -= (_phi *
                      hidden1_learning_rate [offset+z]);
                }
              else if ( rate > 0.0 )
                {
                  hidden1_learning_rate [offset+z] += _K;
                }

              // This is really DELTA weight [time]
              hidden1_momentum [offset+z] = _beta *
                                            (hidden1_learning_rate [offset+z] *
                                             hidden1_weights_sum_delta [offset+z]) +
                                            _alpha * hidden1_momentum [offset+z] -
                                            _hdec * hidden1_weights [offset+z];
              hidden1_weights [offset+z] += hidden1_momentum [offset+z];
              hidden1_weights_sum_delta [offset+z] = 0.0;
              hidden1_learning_delta_bar [offset+z] *= _theta;
              hidden1_learning_delta_bar [offset+z] += ((1.0 - _theta) *
                  hidden1_learning_delta [offset+z]);
              hidden1_learning_delta [offset+z] = 0.0;
            }
        }
     }

  /* Finally add deltas of weights between hidden layer 1 and input
     layer */
  for (x = num_cols1 - 1; x >= 0; --x)
    {
      for (y = num_rows1 - 1; y >= 0; --y)
        {
          offset = (x * num_rows1 + y) * num_time_delay1 * num_rowsi;
          for (z = (num_time_delay1 * num_rowsi - 1); z >= 0; --z)
            {
              rate = input_learning_delta [offset+z] *
                     input_learning_delta_bar [offset+z];
              if ( rate < 0.0 )
                {
                  input_learning_rate [offset+z] -= (_phi *
                      input_learning_rate [offset+z]);
                }
              else if ( rate > 0.0 )
                {
                  input_learning_rate [offset+z] += _K;
                }

              // This is really DELTA weight [time]
              input_momentum [offset+z] = _beta *
                                          (input_learning_rate [offset+z] *
                                          input_weights_sum_delta [offset+z]) +
                                          _alpha * input_momentum [offset+z] -
                                          _hdec * input_weights [offset+z];
              input_weights [offset+z] += input_momentum [offset+z];
              input_weights_sum_delta [offset+z] = 0.0;
              input_learning_delta_bar [offset+z] *= _theta;
              input_learning_delta_bar [offset+z] += ((1.0 - _theta) *
                  input_learning_delta [offset+z]);
              input_learning_delta [offset+z] = 0.0;
            }
        }
    }

  /* Now all deltas have been added into their appropriate neuron
     connection. */
  training_examples += examples_since_update;
  examples_since_update = 0;

}


// Done
int TD_Neural_network::calc_forward_test (double input [], double desired_output [],
                                       int print_it, double correct_eps,
                                       double good_eps)
{
  int     x,y,z,wrong,good;
  int     offset,offset_act;
  double  *weight;

  wrong = 0;
  good = 0;

  /* Go backward for faster processing */
  /* Calculate hidden layer 1's activation */
  for (x = num_cols1 - 1; x >= 0;  --x)
    {
      for (y = num_rows1 - 1; y >= 0; --y)
        {
          offset_act = x * num_rows1 + y;
          hidden1_act [offset_act] = 0.0;
          weight = &input_weights [x * num_rows1 * num_time_delay1 * num_rowsi +
                                   y * num_time_delay1 * num_rowsi];
          offset = x * num_rowsi;
          for (z = (num_time_delay1 * num_rowsi - 1); z >= 0; --z)
            {
              hidden1_act [offset_act] += (input [offset + z] * weight [z]);
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
          weight = &hidden1_weights [x * num_rows2 * num_time_delay2 * num_rows1 +
                                     y * num_time_delay2 * num_rows1];
          offset = x * num_rows1;
          for (z = (num_time_delay2 * num_rows1 - 1); z >= 0; --z)
            {
              hidden2_act [offset_act] += (hidden1_act [offset + z] * weight [z]);
            }
          hidden2_act [offset_act] = S(hidden2_act [offset_act]);
        }
    }

  /* Calculate output layer's activation */
  for (x = num_outputs - 1; x >= 0; --x)
    {
      output_act [x] = 0.0;
      weight = &hidden2_weights [x * num_cols2];
      for (y = num_cols2 - 1; y >= 0; --y)
        {
          output_act [x] += hidden2_act [y * num_rows2 + x] * weight [y];
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

// Done
void TD_Neural_network::kick_weights (double range)
{
  int    x;
  double variation;

  /* Add from -range to +range to all weights randomly */
  for (x = (num_cols1 * num_rows1 * num_time_delay1 * num_rowsi - 1); x >= 0; --x)
    {
      variation = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          variation *= -1.0;
      input_weights [x] += variation;
    }

  for (x = (num_cols2 * num_rows2 * num_time_delay2 * num_rows1 - 1); x >= 0; --x)
    {
      variation = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          variation *= -1.0;
      hidden1_weights [x] += variation;
    }

  for (x = (num_outputs * num_cols2 - 1); x >= 0; --x)
    {
      variation = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          variation *= -1.0;
      hidden2_weights [x] += variation;
    }

}

