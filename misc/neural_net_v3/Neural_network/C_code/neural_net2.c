
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "Neural_net2.h"

/* Uncomment this define if your compiler cannot
   free (NULL);  // This should be legal but some compilers generate code
                 // that crashes the machine.
#define TEST_NULL
*/

static void Neural_net2_allocate_bp_matrices (Neural_net2 *nn);
static void Neural_net2_allocate_rand_opt_matrices (Neural_net2 *nn);
static void Neural_net2_allocate_weight_matrices (Neural_net2 *nn);
static void Neural_net2_allocate_all_matrices (Neural_net2 *nn);

static void Neural_net2_initialize_learning_matrices (Neural_net2 *nn);
static void Neural_net2_initialize_weight_matrices (Neural_net2 *nn,
                                                    double range);
static void Neural_net2_initialize_all_matrices (Neural_net2 *nn,
                                                 double range);

static void Neural_net2_deallocate_bp_matrices (Neural_net2 *nn);
static void Neural_net2_deallocate_rand_opt_matrices (Neural_net2 *nn);
static void Neural_net2_deallocate_all_matrices (Neural_net2 *nn);

static void Neural_net2_allocate_weight_matrices (Neural_net2 *nn)
{

  /* Activation matrices */
  nn->hidden1_act = (double *) malloc (sizeof (double) * nn->num_hidden1);
  nn->hidden2_act = (double *) malloc (sizeof (double) * nn->num_hidden2);
  nn->output_act = (double *) malloc (sizeof (double) * nn->num_outputs);

  /* Weight matrices */
  nn->input_weights = (double *) malloc (sizeof (double) * nn->num_hidden1 *
                                         nn->num_inputs);
  nn->hidden1_weights = (double *) malloc (sizeof (double) * nn->num_hidden2 *
                                           nn->num_hidden1);
  nn->hidden2_weights = (double *) malloc (sizeof (double) * nn->num_outputs *
                                           nn->num_hidden2);
}

static void Neural_net2_allocate_bp_matrices (Neural_net2 *nn)
{
  if ( nn->bp_flag )
    {
      /* Learning rate matrices for each weight's learning rate.
      // Needed for delta-bar-delta algorithm */
      nn->input_learning_rate = (double *) malloc (sizeof (double) *
                                               nn->num_hidden1 * nn->num_inputs);
      nn->hidden1_learning_rate = (double *) malloc (sizeof (double) *
                                                 nn->num_hidden2 * nn->num_hidden1);
      nn->hidden2_learning_rate = (double *) malloc (sizeof (double) *
                                                 nn->num_outputs * nn->num_hidden2);

      /* Momentum rate matrices for each weight's momentum value.
      // Needed for hybrid delta-bar-delta algorithm */
      nn->input_momentum = (double *) malloc (sizeof (double) *
                                               nn->num_hidden1 * nn->num_inputs);
      nn->hidden1_momentum = (double *) malloc (sizeof (double) *
                                                 nn->num_hidden2 * nn->num_hidden1);
      nn->hidden2_momentum = (double *) malloc (sizeof (double) *
                                                 nn->num_outputs * nn->num_hidden2);

      /* Learning rate deltas for each weight's learning rate.
      // Needed for delta-bar-delta algorithm. */
      nn->input_learning_delta = (double *) malloc (sizeof (double) *
                                                nn->num_hidden1 * nn->num_inputs);
      nn->hidden1_learning_delta = (double *) malloc (sizeof (double) *
                                                  nn->num_hidden2 * nn->num_hidden1);
      nn->hidden2_learning_delta = (double *) malloc (sizeof (double) *
                                                  nn->num_outputs * nn->num_hidden2);

      /* Delta bar matrices for each weight's delta bar.
      // Needed for delta-bar-delta algorithm. */
      nn->input_learning_delta_bar = (double *) malloc (sizeof (double) *
                                                    nn->num_hidden1 * nn->num_inputs);
      nn->hidden1_learning_delta_bar = (double *) malloc (sizeof (double) *
                                                   nn->num_hidden2 * nn->num_hidden1);
      nn->hidden2_learning_delta_bar = (double *) malloc (sizeof (double) *
                                                   nn->num_outputs * nn->num_hidden2);

      /* Weight delta matrices for each weights delta.
      // Needed for BackPropagation algorithm. */
      nn->input_weights_sum_delta = (double *) malloc (sizeof (double) *
                                                   nn->num_hidden1 * nn->num_inputs);
      nn->hidden1_weights_sum_delta = (double *) malloc (sizeof (double) *
                                                   nn->num_hidden2 * nn->num_hidden1);
      nn->hidden2_weights_sum_delta = (double *) malloc (sizeof (double) *
                                                   nn->num_outputs * nn->num_hidden2);

      /* Sum of delta * weight matrices for each weight.
      // Needed for BackPropagation algorithm. */
      nn->hidden1_sum_delta_weight = (double *) malloc (sizeof (double) *
                                                    nn->num_hidden1);
      nn->hidden2_sum_delta_weight = (double *) malloc (sizeof (double) *
                                                    nn->num_hidden2);
    }
  else /* Set them all to 0 */
    {
      nn->input_learning_rate = NULL;
      nn->hidden1_learning_rate = NULL;
      nn->hidden2_learning_rate = NULL;

      nn->input_momentum = NULL;
      nn->hidden1_momentum = NULL;
      nn->hidden2_momentum = NULL;

      nn->input_learning_delta = NULL;
      nn->hidden1_learning_delta = NULL;
      nn->hidden2_learning_delta = NULL;

      nn->input_learning_delta_bar = NULL;
      nn->hidden1_learning_delta_bar = NULL;
      nn->hidden2_learning_delta_bar = NULL;

      nn->input_weights_sum_delta = NULL;
      nn->hidden1_weights_sum_delta = NULL;
      nn->hidden2_weights_sum_delta = NULL;

      nn->hidden1_sum_delta_weight = NULL;
      nn->hidden2_sum_delta_weight = NULL;
    }
}

static void Neural_net2_allocate_rand_opt_matrices (Neural_net2 *nn)
{

  if ( nn->rand_opt_flag )
    {
      /* Gaussian random vectors */
      nn->input_weights_g_offset = (double *) malloc (sizeof (double) * nn->num_hidden1 *
                                         nn->num_inputs);
      nn->hidden1_weights_g_offset = (double *) malloc (sizeof (double) * nn->num_hidden2 *
                                           nn->num_hidden1);
      nn->hidden2_weights_g_offset = (double *) malloc (sizeof (double) * nn->num_outputs *
                                           nn->num_hidden2);

      nn->input_weights_bias = (double *) malloc (sizeof (double) * nn->num_hidden1 *
                                         nn->num_inputs);
      nn->hidden1_weights_bias = (double *) malloc (sizeof (double) * nn->num_hidden2 *
                                           nn->num_hidden1);
      nn->hidden2_weights_bias = (double *) malloc (sizeof (double) * nn->num_outputs *
                                           nn->num_hidden2);
    }
  else /* Set them all to zero */
    {
      nn->input_weights_g_offset = NULL;
      nn->hidden1_weights_g_offset = NULL;
      nn->hidden2_weights_g_offset = NULL;

      nn->input_weights_bias = NULL;
      nn->hidden1_weights_bias = NULL;
      nn->hidden2_weights_bias = NULL;
    }
}

static void Neural_net2_allocate_all_matrices (Neural_net2 *nn)
{
  Neural_net2_allocate_weight_matrices (nn);
  Neural_net2_allocate_rand_opt_matrices (nn);
  Neural_net2_allocate_bp_matrices (nn);
}

static void Neural_net2_initialize_learning_matrices (Neural_net2 *nn)
{
  int    x,y;

  /* Initialize all weights from -range to +range randomly */
  for (x = 0; x < nn->num_hidden1; ++x)
    {
      if ( nn->bp_flag )
          nn->hidden1_sum_delta_weight [x] = 0.0;

      for (y = 0; y < nn->num_inputs; ++y)
        {
          if ( nn->bp_flag )
            {
              nn->input_weights_sum_delta [x * nn->num_inputs + y] = 0.0;
              nn->input_learning_rate [x * nn->num_inputs + y] = nn->_learning_rate;
              nn->input_momentum [x * nn->num_inputs + y] = 0.0;
              nn->input_learning_delta [x * nn->num_inputs + y] = 0.0;
              nn->input_learning_delta_bar [x * nn->num_inputs + y] = 0.0;
            }

          if ( nn->rand_opt_flag )
            {
              nn->input_weights_g_offset [x * nn->num_inputs + y] = 0.0;
              nn->input_weights_bias [x * nn->num_inputs + y] = 0.0;
            }
        }
    }

  for (x = 0; x < nn->num_hidden2; ++x)
    {
      if ( nn->bp_flag )
          nn->hidden2_sum_delta_weight [x] = 0.0;

      for (y = 0; y < nn->num_hidden1; ++y)
        {
          if ( nn->bp_flag )
            {
              nn->hidden1_weights_sum_delta [x * nn->num_hidden1 + y] = 0.0;
              nn->hidden1_learning_rate [x * nn->num_hidden1 + y] = nn->_learning_rate;
              nn->hidden1_momentum [x * nn->num_hidden1 + y] = 0.0;
              nn->hidden1_learning_delta [x * nn->num_hidden1 + y] = 0.0;
              nn->hidden1_learning_delta_bar [x * nn->num_hidden1 + y] = 0.0;
            }

          if ( nn->rand_opt_flag )
            {
              nn->hidden1_weights_g_offset [x * nn->num_hidden1 + y] = 0.0;
              nn->hidden1_weights_bias [x * nn->num_hidden1 + y] = 0.0;
            }
        }
    }

  for (x = 0; x < nn->num_outputs; ++x)
    {
      for (y = 0; y < nn->num_hidden2; ++y)
        {
          if ( nn->bp_flag )
            {
              nn->hidden2_weights_sum_delta [x * nn->num_hidden2 + y] = 0.0;
              nn->hidden2_learning_rate [x * nn->num_hidden2 + y] = nn->_learning_rate;
              nn->hidden2_momentum [x * nn->num_hidden2 + y] = 0.0;
              nn->hidden2_learning_delta [x * nn->num_hidden2 + y] = 0.0;
              nn->hidden2_learning_delta_bar [x * nn->num_hidden2 + y] = 0.0;
            }

          if ( nn->rand_opt_flag )
            {
              nn->hidden2_weights_g_offset [x * nn->num_hidden2 + y] = 0.0;
              nn->hidden2_weights_bias [x * nn->num_hidden2 + y] = 0.0;
            }
        }
    }

}

static void Neural_net2_initialize_weight_matrices (Neural_net2 *nn,
                                                    double range)
{
  int    x;
  double rand_max;

  nn->training_examples = 0;
  nn->examples_since_update = 0;

  rand_max = RAND_MAX;
  /* Initialize all weights from -range to +range randomly */
  for (x = nn->num_hidden1 * nn->num_inputs - 1; x >= 0; --x)
    {
      nn->input_weights [x] = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          nn->input_weights [x] *= -1.0;

    }

  for (x = nn->num_hidden2 * nn->num_hidden1 - 1; x >= 0; --x)
    {
      nn->hidden1_weights [x] = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          nn->hidden1_weights [x] *= -1.0;

    }

  for (x = nn->num_outputs * nn->num_hidden2 - 1; x >= 0; --x)
    {
      nn->hidden2_weights [x] = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          nn->hidden2_weights [x] *= -1.0;

    }

}

static void Neural_net2_initialize_all_matrices (Neural_net2 *nn, double range)
{
  Neural_net2_initialize_weight_matrices (nn,range);
  Neural_net2_initialize_learning_matrices (nn);
}


static void Neural_net2_deallocate_bp_matrices (Neural_net2 *nn)
{

#ifdef TEST_NULL
  if ( nn->input_learning_rate == NULL )
      return;
#endif

  /* Learning rate matrices for each weight's learning rate.
  // Needed for delta-bar-delta algorithm */
  free (nn->input_learning_rate);
  free (nn->hidden1_learning_rate);
  free (nn->hidden2_learning_rate);
  nn->input_learning_rate = NULL;
  nn->hidden1_learning_rate = NULL;
  nn->hidden2_learning_rate = NULL;

  /* Momentum matrices for each weight's momemtum.
    Needed for hybrid delta-bar-delta algorithm. */
  free (nn->input_momentum);
  free (nn->hidden1_momentum);
  free (nn->hidden2_momentum);
  nn->input_momentum = NULL;
  nn->hidden1_momentum = NULL;
  nn->hidden2_momentum = NULL;

  /* Learning rate deltas for each weight's learning rate.
  // Needed for delta-bar-delta algorithm. */
  free (nn->input_learning_delta);
  free (nn->hidden1_learning_delta);
  free (nn->hidden2_learning_delta);
  nn->input_learning_delta = NULL;
  nn->hidden1_learning_delta = NULL;
  nn->hidden2_learning_delta = NULL;


  /* Delta bar matrices for each weight's delta bar.
  // Needed for delta-bar-delta algorithm. */
  free (nn->input_learning_delta_bar);
  free (nn->hidden1_learning_delta_bar);
  free (nn->hidden2_learning_delta_bar);
  nn->input_learning_delta_bar = NULL;
  nn->hidden1_learning_delta_bar = NULL;
  nn->hidden2_learning_delta_bar = NULL;


  /* Weight delta matrices for each weights delta.
  // Needed for BackPropagation algorithm. */
  free (nn->input_weights_sum_delta);
  free (nn->hidden1_weights_sum_delta);
  free (nn->hidden2_weights_sum_delta);
  nn->input_weights_sum_delta = NULL;
  nn->hidden1_weights_sum_delta = NULL;
  nn->hidden2_weights_sum_delta = NULL;


  /* Sum of delta * weight matrices for each weight.
  // Needed for BackPropagation algorithm. */
  free (nn->hidden1_sum_delta_weight);
  free (nn->hidden2_sum_delta_weight);
  nn->hidden1_sum_delta_weight = NULL;
  nn->hidden2_sum_delta_weight = NULL;

}

static void Neural_net2_deallocate_rand_opt_matrices (Neural_net2 *nn)
{

#ifdef TEST_NULL
  if ( nn->input_weights_g_offset == NULL )
      return;
#endif

  free (nn->input_weights_g_offset);
  free (nn->hidden1_weights_g_offset);
  free (nn->hidden2_weights_g_offset);
  nn->input_weights_g_offset = NULL;
  nn->hidden1_weights_g_offset = NULL;
  nn->hidden2_weights_g_offset = NULL;

  free (nn->input_weights_bias);
  free (nn->hidden1_weights_bias);
  free (nn->hidden2_weights_bias);
  nn->input_weights_bias = NULL;
  nn->hidden1_weights_bias = NULL;
  nn->hidden2_weights_bias = NULL;

}


static void Neural_net2_deallocate_all_matrices (Neural_net2 *nn)
{

#ifdef TEST_NULL
  if ( nn->hidden1_act == NULL )
      return;
#endif

  /* Time to destroy the entire neural_net structure
  // Activation matrices */
  free (nn->hidden1_act);
  free (nn->hidden2_act);
  free (nn->output_act);
  nn->hidden1_act = NULL;
  nn->hidden2_act = NULL;
  nn->output_act = NULL;

  /* Weight matrices */
  free (nn->input_weights);
  free (nn->hidden1_weights);
  free (nn->hidden2_weights);
  nn->input_weights = NULL;
  nn->hidden1_weights = NULL;
  nn->hidden2_weights = NULL;

  Neural_net2_deallocate_bp_matrices (nn);
  Neural_net2_deallocate_rand_opt_matrices (nn);

}

Neural_net2 *Neural_net2_constr (int number_inputs, int number_hidden1,
                           int number_hidden2, int number_outputs,
                           int backpropagation_flag,
                           int random_optimization_flag, double range,
                           double variance, double alpha, double beta,
                           double epsilon, double skip_epsilon,
                           double learning_rate, double theta,
                           double phi, double K, double hdec)
{
  Neural_net2 *nn;

  if ( (nn = malloc (sizeof (Neural_net2))) == NULL )
    {
      return (NULL);
    }

  nn->num_inputs = number_inputs;
  nn->num_hidden1 = number_hidden1;
  nn->num_hidden2 = number_hidden2;
  nn->num_outputs = number_outputs;

  nn->bp_flag = backpropagation_flag;
  nn->rand_opt_flag = random_optimization_flag;

  nn->_alpha = alpha;
  nn->_beta = beta;
  nn->_epsilon = epsilon;
  nn->_skip_epsilon = skip_epsilon;
  nn->_learning_rate = learning_rate;
  nn->_theta = theta;
  nn->_phi = phi;
  nn->_K = K;
  nn->_hdec = hdec;

  nn->training_examples = 0;
  nn->examples_since_update = 0;

  Neural_net2_allocate_all_matrices (nn);
  Neural_net2_initialize_all_matrices (nn,range);

  return (nn);
}


Neural_net2 *Neural_net2_read_constr (char *filename, int *file_error,
                                int backpropagation_flag,
                                int random_optimization_flag,
                                double variance, double alpha, double beta,
                                double epsilon, double skip_epsilon,
                                double learning_rate, double theta,
                                double phi, double K, double hdec)
{
  Neural_net2 *nn;

  if ( (nn = malloc (sizeof (Neural_net2))) == NULL )
    {
      return (NULL);
    }

  nn->bp_flag = backpropagation_flag;
  nn->rand_opt_flag = random_optimization_flag;

  nn->_alpha = alpha;
  nn->_beta = beta;
  nn->_epsilon = epsilon;
  nn->_skip_epsilon = skip_epsilon;
  nn->_learning_rate = learning_rate;
  nn->_theta = theta;
  nn->_phi = phi;
  nn->_K = K;
  nn->_hdec = hdec;

  nn->training_examples = 0;
  nn->examples_since_update = 0;

  nn->hidden1_act = NULL;
  nn->hidden2_act = NULL;
  nn->output_act = NULL;

  nn->input_weights = NULL;
  nn->hidden1_weights = NULL;
  nn->hidden2_weights = NULL;

  nn->input_learning_rate = NULL;
  nn->hidden1_learning_rate = NULL;
  nn->hidden2_learning_rate = NULL;

  nn->input_momentum = NULL;
  nn->hidden1_momentum = NULL;
  nn->hidden2_momentum = NULL;

  nn->input_learning_delta = NULL;
  nn->hidden1_learning_delta = NULL;
  nn->hidden2_learning_delta = NULL;

  nn->input_learning_delta_bar = NULL;
  nn->hidden1_learning_delta_bar = NULL;
  nn->hidden2_learning_delta_bar = NULL;

  nn->input_weights_sum_delta = NULL;
  nn->hidden1_weights_sum_delta = NULL;
  nn->hidden2_weights_sum_delta = NULL;

  nn->hidden1_sum_delta_weight = NULL;
  nn->hidden2_sum_delta_weight = NULL;

  nn->input_weights_g_offset = NULL;
  nn->hidden1_weights_g_offset = NULL;
  nn->hidden2_weights_g_offset = NULL;

  nn->input_weights_bias = NULL;
  nn->hidden1_weights_bias = NULL;
  nn->hidden2_weights_bias = NULL;

  if ( (*file_error = Neural_net2_read_weights (nn,filename)) < 0 )
    {
      free (nn);
      return (NULL);
    }

  return (nn);
}

#ifndef __INLINE__
Neural_net2 *Neural_net2_default_constr (int number_inputs, int number_hidden1,
                                         int number_hidden2,
                                         int number_outputs,
                                         int backpropagation_flag,
                                         int random_optimization_flag,
                                         double range)
{
  return (Neural_net2_constr (number_inputs,number_hidden1,
                              number_hidden2,number_outputs,
                              backpropagation_flag,
                              random_optimization_flag,range,0.01,0.0,1.0,
                              0.1,0.0,0.1,1.0,0.0,0.0,0.0));
}

Neural_net2 *Neural_net2_default_read_constr (char *filename,
                                              int *file_error,
                                              int backpropagation_flag,
                                              int random_optimization_flag)
{
  return (Neural_net2_read_constr (filename,file_error,backpropagation_flag,
                                   random_optimization_flag,0.01,0.0,1.0,0.1,
                                   0.0,0.1,1.0,0.0,0.0,0.0));
}
#endif


void Neural_net2_destr (Neural_net2 *nn)
{
  if ( nn != NULL )
    {
      Neural_net2_deallocate_all_matrices (nn);
      free (nn);
    }
}

void Neural_net2_re_initialize_net (Neural_net2 *nn, double range,
                                    double learning_rate, double variance)
{
  nn->_learning_rate = learning_rate;
  nn->_variance = variance;
  Neural_net2_initialize_all_matrices (nn,range);
}

int Neural_net2_read_weights (Neural_net2 *nn, char *filename)
{
  FILE    *fp;
  int     x;
  long    iter;

  if ( ((fp = fopen (filename,"rt")) == NULL) )
    {
      printf ("Could not read weights from file '%s'\n",filename);
      return (-1);
    }

  /* First read in how many iterations have been performed so far */
  fscanf (fp,"%ld",&iter);
  printf ("Iterations = %ld\n",iter);

  /* Next read in how many input nodes, hidden1 nodes, hidden2 nodes */
  /* and output nodes. */
  fscanf (fp,"%d%d%d%d",&nn->num_inputs,&nn->num_hidden1,&nn->num_hidden2,
                        &nn->num_outputs);

  /* Deallocate previous matrices */
  Neural_net2_deallocate_all_matrices (nn);

  /* Allocate new matrices with new size */
  Neural_net2_allocate_all_matrices (nn);

  /* Initialize all matrices and variables */
  Neural_net2_initialize_learning_matrices (nn);
  nn->training_examples = iter;

  /* Read input->hidden1 weights from file. */
  for (x = 0; x < nn->num_inputs * nn->num_hidden1; ++x)
    {
      fscanf (fp,"%lf",&nn->input_weights [x]);
    }

  /* Read hidden1->hidden2 weights from file. */
  for (x = 0; x < nn->num_hidden1 * nn->num_hidden2; ++x)
    {
      fscanf (fp,"%lf",&nn->hidden1_weights [x]);
    }

  /* Read hidden2->output weights from file. */
  for (x = 0; x < (nn->num_hidden2 * nn->num_outputs); ++x)
    {
      fscanf (fp,"%lf",&nn->hidden2_weights [x]);
    }

  /* Now all the weights have been loaded */
 fclose (fp);

 return (0);
}



int Neural_net2_save_weights (Neural_net2 *nn, char *filename)
{
  FILE *fp;
  int   x;

  if ( ((fp = fopen (filename,"wt")) == NULL) )
    {
      printf ("Could not save weights to file '%s'\n",filename);
      return (-1);
    }

  /* First write out how many iterations have been performed so far */
  fprintf (fp," %ld\n",nn->training_examples);

  /* Next write out how many input nodes, hidden1 nodes, hidden2 nodes */
  /* and output nodes. */
  fprintf (fp," %d %d %d %d\n",nn->num_inputs,nn->num_hidden1,
           nn->num_hidden2,nn->num_outputs);

  /* Write input->hidden1 weights to output. */
  for (x = 0; x < nn->num_inputs * nn->num_hidden1; ++x)
    {
      fprintf (fp,"%10.5f ",nn->input_weights [x]);
      if ( (x % 5) == 4 )
          fprintf (fp,"\n");
    }
  fprintf (fp,"\n\n");

  /* Write hidden1->hidden2 weights to output. */
  for (x = 0; x < nn->num_hidden1 * nn->num_hidden2; ++x)
    {
      fprintf (fp,"%10.5f ",nn->hidden1_weights [x]);
      if ( (x % 5) == 4 )
          fprintf (fp,"\n");
    }
  fprintf (fp,"\n\n");

  /* Write hidden2->output weights to output. */
  for (x = 0; x < (nn->num_hidden2 * nn->num_outputs); ++x)
    {
      fprintf (fp,"%10.5f ",nn->hidden2_weights [x]);
      if ( (x % 5) == 4 )
          fprintf (fp,"\n");
    }
  fprintf (fp,"\n\n");

  fflush (fp);
  printf ("Flushed file\n");
  fclose (fp);
  printf ("Closed file\n");

  /* Now all the weights have been saved */
  return (0);
}


#ifndef __INLINE__
double Neural_net2_get_hidden1_activation (Neural_net2 *nn, int node)
{
  return (nn->hidden1_act [node]);
}

double Neural_net2_get_hidden2_activation (Neural_net2 *nn, int node)
{
  return (nn->hidden2_act [node]);
}

double Neural_net2_get_output_activation (Neural_net2 *nn, int node)
{
  return (nn->output_act [node]);
}

double Neural_net2_get_input_weight (Neural_net2 *nn, int input_node,
                                    int hidden1_node)
{
  return (nn->input_weights [hidden1_node * nn->num_inputs + input_node]);
}

double Neural_net2_get_hidden1_weight (Neural_net2 *nn, int hidden1_node,
                                      int hidden2_node)
{
  return (nn->hidden1_weights [hidden2_node * nn->num_hidden1 +
                               hidden1_node]);
}

double Neural_net2_get_hidden2_weight (Neural_net2 *nn, int hidden2_node,
                                      int output_node)
{
  return (nn->hidden2_weights [output_node*nn->num_hidden2+hidden2_node]);
};

#endif

#ifndef __INLINE__
int Neural_net2_get_number_inputs (Neural_net2 *nn)
{
  return (nn->num_inputs);
}

int Neural_net2_get_number_hidden1 (Neural_net2 *nn)
{
  return (nn->num_hidden1);
}

int Neural_net2_get_number_hidden2 (Neural_net2 *nn)
{
  return (nn->num_hidden2);
}

int Neural_net2_get_number_outputs (Neural_net2 *nn)
{
  return (nn->num_outputs);
}
#endif


void Neural_net2_set_size_parameters (Neural_net2 *nn, int number_inputs,
                                     int number_hidden1, int number_hidden2,
                                     int number_outputs, double range)
{
  double *new_input_weights,*new_hidden1_weights;
  double *new_hidden2_weights;
  double rand_max;
  int    x;

  rand_max = RAND_MAX;

  /* Allocate new weight matrices with new size */
  new_input_weights = (double *) malloc (sizeof (double) *
                                     number_hidden1 * number_inputs);
  new_hidden1_weights = (double *) malloc (sizeof (double) *
                                       number_hidden2 * number_hidden1);
  new_hidden2_weights = (double *) malloc (sizeof (double) *
                                       number_outputs * number_hidden2);

  /* Copy over all weights
  // Input weights */
  for (x = 0; x < number_hidden1 * number_inputs; ++x)
    {
      /* IF the new size is larger than the old size, THEN make new connections
      // a random weight between +-range. */
      if ( x >= (nn->num_hidden1 * nn->num_inputs) )
        {
          new_input_weights [x] = rand () / rand_max * range;
          if ( rand () < (RAND_MAX / 2) )
              new_input_weights [x] *= -1.0;
        }
      else
          new_input_weights [x] = nn->input_weights [x];
    }

  /* Hidden1 weights */
  for (x = 0; x < number_hidden2 * number_hidden1; ++x)
    {
      /* IF the new size is larger than the old size, THEN make new connections
      // a random weight between +-range. */
      if ( x >= (nn->num_hidden2 * nn->num_hidden1) )
        {
          new_hidden1_weights [x] = rand () / rand_max * range;
          if ( rand () < (RAND_MAX / 2) )
              new_hidden1_weights [x] *= -1.0;
        }
      else
          new_hidden1_weights [x] = nn->hidden1_weights [x];
    }

  /* Hidden2 weights */
  for (x = 0; x < number_outputs * number_hidden2; ++x)
    {
      /* IF the new size is larger than the old size, THEN make new connections
      // a random weight between +-range. */
      if ( x >= (nn->num_outputs * nn->num_hidden2) )
        {
          new_hidden2_weights [x] = rand () / rand_max * range;
          if ( rand () < (RAND_MAX / 2) )
              new_hidden2_weights [x] *= -1.0;
        }
      else
          new_hidden2_weights [x] = nn->hidden2_weights [x];
    }

  /* All weights have been copied. */

  /* Change size paramters */
  nn->num_inputs = number_inputs;
  nn->num_hidden1 = number_hidden1;
  nn->num_hidden2 = number_hidden2;
  nn->num_outputs = number_outputs;

  /* Deallocate all matrices */
  Neural_net2_deallocate_all_matrices (nn);

  /* Allocate new nerual network matrices with the correct size and initialize */
  Neural_net2_allocate_all_matrices (nn);
  Neural_net2_initialize_learning_matrices (nn);

  /* Now deallocate new randomly initialized weight matrices and assign them
  // to the new weight matrices that have the correct weight values. */
  free (nn->input_weights);
  free (nn->hidden1_weights);
  free (nn->hidden2_weights);

  nn->input_weights = new_input_weights;
  nn->hidden1_weights = new_hidden1_weights;
  nn->hidden2_weights = new_hidden2_weights;

}

int Neural_net2_get_backpropagation_flag (Neural_net2 *nn)
{
  return (nn->bp_flag);
}

int Neural_net2_set_backpropagation_flag (Neural_net2 *nn, int new_flag)
{
  int old_bp_flag = nn->bp_flag;

  if ( new_flag == nn->bp_flag )
      return (old_bp_flag);

  nn->bp_flag = new_flag;

  if ( nn->bp_flag == 0 )
    {
      /* Deallocate matrices needed by backpropagation and delta-bar-delta. */
      Neural_net2_deallocate_bp_matrices (nn);
    }
  else
    {
      /* Allocate matrices needed by backpropagation and delta-bar-delta. */
      Neural_net2_allocate_bp_matrices (nn);
      Neural_net2_initialize_learning_matrices (nn);
    }

  return (old_bp_flag);
}


int Neural_net2_get_random_optimization_flag (Neural_net2 *nn)
{
  return (nn->rand_opt_flag);
}

int Neural_net2_set_random_optimization_flag (Neural_net2 *nn, int new_flag)
{
  int old_rand_opt_flag = nn->rand_opt_flag;

  if ( new_flag == nn->rand_opt_flag )
      return (old_rand_opt_flag);

  nn->rand_opt_flag = new_flag;

  if ( nn->rand_opt_flag == 0 )
    {
      /* Deallocate matrices needed for Random Optimization algorithm. */
      Neural_net2_deallocate_rand_opt_matrices (nn);
    }
  else
    {
      /* Allocate matrices needed for Random Optimization algorithm. */
      Neural_net2_allocate_rand_opt_matrices (nn);
      Neural_net2_initialize_learning_matrices (nn);
    }

  return (old_rand_opt_flag);
}

double Neural_net2_get_learning_rate (Neural_net2 *nn)
{
  return (nn->_learning_rate);
}

double Neural_net2_set_learning_rate (Neural_net2 *nn, double learning_rate)
{
  int    x;
  double old_learning_rate = nn->_learning_rate;

  nn->_learning_rate = learning_rate;

  if ( !nn->bp_flag )
      return (old_learning_rate);

  for (x = nn->num_hidden1 * nn->num_inputs - 1; x >= 0; --x)
    {
      nn->input_learning_rate [x] = nn->_learning_rate;
    }

  for (x = nn->num_hidden2 * nn->num_hidden1 - 1; x >= 0; --x)
    {
      nn->hidden1_learning_rate [x] = nn->_learning_rate;
    }

  for (x = nn->num_outputs * nn->num_hidden2 - 1; x >= 0; --x)
    {
      nn->hidden2_learning_rate [x] = nn->_learning_rate;
    }

  return (old_learning_rate);
}



void Neural_net2_set_standard_dbd_parameters (Neural_net2 *nn)
{
  nn->_alpha = 0.4;
  nn->_beta = 1.0;
  nn->_epsilon = 0.1;
  nn->_skip_epsilon = 0.05;
  nn->_learning_rate = 0.1;
  nn->_theta = 0.8;
  nn->_phi = 0.2;
  nn->_K = 0.025;
  nn->_hdec = 0.0;
}

#ifndef __INLINE__
double Neural_net2_set_alpha (Neural_net2 *nn, double alpha)
{
  double old_alpha = nn->_alpha;
  nn->_alpha = alpha;
  return old_alpha;
}

double Neural_net2_set_beta (Neural_net2 *nn, double beta)
{
  double old_beta = nn->_beta;
  nn->_beta = beta;
  return old_beta;
}

double Neural_net2_set_epsilon (Neural_net2 *nn, double epsilon)
{
  double old_eps = nn->_epsilon;
  nn->_epsilon = epsilon;
  return old_eps;
}

double Neural_net2_set_skip_epsilon (Neural_net2 *nn, double skip_eps)
{
  double old_skip_eps = nn->_skip_epsilon;
  nn->_skip_epsilon = skip_eps;
  return old_skip_eps;
}

double Neural_net2_set_theta (Neural_net2 *nn, double theta)
{
  double old_theta = nn->_theta;
  nn->_theta = theta;
  return old_theta;
}

double Neural_net2_set_phi (Neural_net2 *nn, double phi)
{
  double old_phi = nn->_phi;
  nn->_phi = phi;
  return old_phi;
}

double Neural_net2_set_K (Neural_net2 *nn, double K)
{
  double old_K = nn->_K;
  nn->_K = K;
  return old_K;
}

double Neural_net2_set_hdec (Neural_net2 *nn, double hdec)
{
  double old_hdec = nn->_hdec;
  nn->_hdec = hdec;
  return old_hdec;
}

double Neural_net2_set_variance (Neural_net2 *nn, double variance)
{
  double old_variance = nn->_variance;
  nn->_variance = variance;
  return old_variance;
}

double Neural_net2_get_alpha (Neural_net2 *nn)
{
  return (nn->_alpha);
}

double Neural_net2_get_beta (Neural_net2 *nn)
{
  return (nn->_beta);
}

double Neural_net2_get_epsilon (Neural_net2 *nn)
{
  return (nn->_epsilon);
}

double Neural_net2_get_skip_epsilon (Neural_net2 *nn)
{
  return (nn->_skip_epsilon);
}

double Neural_net2_get_theta (Neural_net2 *nn)
{
  return (nn->_theta);
}

double Neural_net2_get_phi (Neural_net2 *nn)
{
  return (nn->_phi);
}

double Neural_net2_get_K (Neural_net2 *nn)
{
  return (nn->_K);
}

double Neural_net2_get_hdec (Neural_net2 *nn)
{
  return (nn->_hdec);
}

long   Neural_net2_get_iterations (Neural_net2 *nn)
{
  return (nn->training_examples);
}

#endif


void Neural_net2_backpropagation (Neural_net2 *nn, double *input,
                                  double *desired_output, int *done)
{
  int     x,y;
  register int size;
  double  delta,*weight,*p_sum_delta,*p_learning_delta;

  /* First check if training complete. */
  for (x = nn->num_outputs - 1; x >= 0; --x)
    {
      if ( fabs (desired_output [x] - nn->output_act [x]) > nn->_epsilon )
        {
          *done = 0;
        }
    }

  /* Go backward through list for speed */
  size = nn->num_hidden2;
  /* First calculate deltas of weights from output to hidden layer 2. */
  for (x = nn->num_outputs - 1; x >= 0; --x)
    {
      weight = &nn->hidden2_weights [x * size];
      p_sum_delta = &nn->hidden2_weights_sum_delta [x * size];
      p_learning_delta = &nn->hidden2_learning_delta [x * size];

      /* Formula delta = (desired - actual) * derivative
         derivative = S(1 - S)
         Also calculate sum of deltas * weight for next layer.
      */
      delta = (desired_output [x] - nn->output_act [x])
               * SLOPE * nn->output_act [x] * (1.0 - nn->output_act [x]);

      for (y = nn->num_hidden2 - 1; y >= 0; --y)
        {
          nn->hidden2_sum_delta_weight [y] += delta * weight [y];

          p_learning_delta [y] += delta;

          /* Now multiply by activation and sum in weights sum delta */
          p_sum_delta [y] += delta * nn->hidden2_act [y];
        }
    }


  /* Next calculate deltas of weights between hidden layer2 and hidden
     layer 1 */
  size = nn->num_hidden1;
  for (x = nn->num_hidden2 - 1; x >= 0; --x)
    {
      weight = &nn->hidden1_weights [x * size];
      p_sum_delta = &nn->hidden1_weights_sum_delta [x * size];
      p_learning_delta = &nn->hidden1_learning_delta [x * size];

      /* Formula delta = SUM (previous deltas*weight)
                         * derivative
         previous deltas already muliplied by weight.
         derivative = S(1 - S)

         Also calculate sum of deltas * weight to save from doing
         it for next layer.
      */

      delta = nn->hidden2_sum_delta_weight [x] * nn->hidden2_act [x] *
              (1.0 - nn->hidden2_act [x]) * SLOPE;

      for (y = nn->num_hidden1 - 1; y >= 0; --y)
        {
          nn->hidden1_sum_delta_weight [y] += delta * weight [y];

          p_learning_delta [y] += delta;

          /* Now multiply by activation and sum in weights_sum_delta */
          p_sum_delta [y] += delta * nn->hidden1_act [y];
        }
      nn->hidden2_sum_delta_weight [x] = 0.0;
    }

  /* Finally calculate deltas of weights between hidden layer 1 and input
     layer */
  size = nn->num_inputs;
  for (x = nn->num_hidden1 - 1; x >= 0; --x)
    {
      p_sum_delta = &nn->input_weights_sum_delta [x * size];
      p_learning_delta = &nn->input_learning_delta [x * size];

      /* Formula delta = SUM (previous deltas*weight)
                         * derivative * activation of input
         previous deltas already muliplied by weight
         derivative = S(1 - S)
      */
      delta = nn->hidden1_sum_delta_weight [x] * nn->hidden1_act [x] *
              (1.0 - nn->hidden1_act [x]) * SLOPE;

      for (y = nn->num_inputs - 1; y >= 0; --y)
        {
          p_learning_delta [y] += delta;

          p_sum_delta [y] += (delta * input [y]);
        }
      nn->hidden1_sum_delta_weight [x] = 0.0;
    }

  /* Now all deltas have been calculated and added into their appropriate
     neuron connection. */
  ++nn->examples_since_update;

}


double Neural_net2_calc_forward (Neural_net2 *nn, double *input,
                                double *desired_output, int *num_wrong,
                                int *skip, int print_it, int *actual_printed)
{
  int     x,y,wrong;
  int     size;
  double  *weight,error,abs_error;

  *skip = 1;
  wrong = 0;
  error = 0.0;

  /* Go backward for faster processing */
  /* Calculate hidden layer 1's activation */
  size = nn->num_inputs;
  for (x = nn->num_hidden1 - 1; x >= 0;  --x)
    {
      nn->hidden1_act [x] = 0.0;
      weight = &nn->input_weights [x * size];
      for (y = nn->num_inputs - 1; y >= 0; --y)
        {
          nn->hidden1_act [x] += (input [y] * weight [y]);
        }
      nn->hidden1_act [x] = S(nn->hidden1_act [x]);
    }

  /* Calculate hidden layer 2's activation */
  size = nn->num_hidden1;
  for (x = nn->num_hidden2 - 1; x >= 0; --x)
    {
      nn->hidden2_act [x] = 0.0;
      weight = &nn->hidden1_weights [x * size];
      for (y = nn->num_hidden1 - 1; y >= 0; --y)
        {
          nn->hidden2_act [x] += (nn->hidden1_act [y] * weight [y]);
        }
      nn->hidden2_act [x] = S(nn->hidden2_act [x]);
    }

  /* Calculate output layer's activation */
  size = nn->num_hidden2;
  for (x = nn->num_outputs - 1; x >= 0; --x)
    {
      nn->output_act [x] = 0.0;
      weight = &nn->hidden2_weights [x * size];
      for (y = nn->num_hidden2 - 1; y >= 0; --y)
        {
          nn->output_act [x] += nn->hidden2_act [y] * weight [y];
        }
      nn->output_act [x] = S(nn->output_act [x]);
      abs_error = fabs (nn->output_act [x] - desired_output [x]);
      error += abs_error;
      if ( abs_error > nn->_epsilon )
          wrong = 1;
      if ( abs_error > nn->_skip_epsilon )
          *skip = 0;
    }

  if ( wrong )
      ++(*num_wrong);

  if ( print_it == 2 )
    {
      for (x = 0; x < nn->num_outputs; ++x)
        {
          printf ("%6.4f ",nn->output_act [x]);
        }
      ++(*actual_printed);
    }
  else if ( print_it && wrong )
    {
      for (x = 0; x < nn->num_outputs; ++x)
        {
          printf ("%6.4f ",fabs (desired_output [x] - nn->output_act [x]));
        }
      ++(*actual_printed);
    }

  return (error);

}


void Neural_net2_update_weights (Neural_net2 *nn)
{
  int     x,y;
  int     size;
  double  rate,*p_ldelta,*p_ldelta_bar,*weight,*p_lrate,*p_sum_delta;
  double  *p_momentum;

  /* Check to see if any changes have been calculated. */
  if ( nn->examples_since_update == 0 )
    {
      return;
    }

  /* Go backward for slightly faster processing */
  /* First add deltas of weights from output to hidden layer 2. */
  size = nn->num_hidden2;
  for (x = nn->num_outputs - 1; x >= 0; --x)
    {
      p_ldelta = &nn->hidden2_learning_delta [x * size];
      p_ldelta_bar = &nn->hidden2_learning_delta_bar [x * size];
      weight = &nn->hidden2_weights [x * size];
      p_lrate = &nn->hidden2_learning_rate [x * size];
      p_momentum = &nn->hidden2_momentum [x * size];
      p_sum_delta = &nn->hidden2_weights_sum_delta [x * size];

      for (y = nn->num_hidden2 - 1; y >= 0; --y)
        {
          rate = p_ldelta [y] * p_ldelta_bar [y];
          if ( rate < 0.0 )
            {
              p_lrate [y] -= (nn->_phi * p_lrate [y]);
            }
          else if ( rate > 0.0 )
            {
              p_lrate [y] += nn->_K;
            }

          /* This is really DELTA weight [time] */
          p_momentum [y] = nn->_beta * (p_lrate [y] * p_sum_delta [y]) +
                           nn->_alpha * p_momentum [y] -
                           nn->_hdec * weight [y];
          weight [y] += p_momentum [y];
          p_sum_delta [y] = 0.0;
          p_ldelta_bar [y] *= nn->_theta;
          p_ldelta_bar [y] += ((1.0 - nn->_theta) * p_ldelta [y]);
          p_ldelta [y] = 0.0;
        }
    }

  /* Next add deltas of weights between hidden layer2 and hidden
     layer 1 */
  size = nn->num_hidden1;
  for (x = nn->num_hidden2 - 1; x >= 0; --x)
    {
      p_ldelta = &nn->hidden1_learning_delta [x * size];
      p_ldelta_bar = &nn->hidden1_learning_delta_bar [x * size];
      weight = &nn->hidden1_weights [x * size];
      p_lrate = &nn->hidden1_learning_rate [x * size];
      p_momentum = &nn->hidden1_momentum [x * size];
      p_sum_delta = &nn->hidden1_weights_sum_delta [x * size];

      for (y = nn->num_hidden1 - 1; y >= 0; --y)
        {
          rate = p_ldelta [y] * p_ldelta_bar [y];
          if ( rate < 0.0 )
            {
              p_lrate [y] -= (nn->_phi * p_lrate [y]);
            }
          else if ( rate > 0.0 )
            {
              p_lrate [y] += nn->_K;
            }

          /* This is really DELTA weight [time] */
          p_momentum [y] = nn->_beta * (p_lrate [y] * p_sum_delta [y]) +
                           nn->_alpha * p_momentum [y] -
                           nn->_hdec * weight [y];
          weight [y] += p_momentum [y];
          p_sum_delta [y] = 0.0;
          p_ldelta_bar [y] *= nn->_theta;
          p_ldelta_bar [y] += ((1.0 - nn->_theta) * p_ldelta [y]);
          p_ldelta [y] = 0.0;
        }
    }

  /* Finally add deltas of weights between hidden layer 1 and input
     layer */
  size = nn->num_inputs;
  for (x = nn->num_hidden1 - 1; x >= 0; --x)
    {
      p_ldelta = &nn->input_learning_delta [x * size];
      p_ldelta_bar = &nn->input_learning_delta_bar [x * size];
      weight = &nn->input_weights [x * size];
      p_lrate = &nn->input_learning_rate [x * size];
      p_momentum = &nn->input_momentum [x * size];
      p_sum_delta = &nn->input_weights_sum_delta [x * size];

      for (y = nn->num_inputs - 1; y >= 0; --y)
        {
          rate = p_ldelta [y] * p_ldelta_bar [y];
          if ( rate < 0.0 )
            {
              p_lrate [y] -= (nn->_phi * p_lrate [y]);
            }
          else if ( rate > 0.0 )
            {
              p_lrate [y] += nn->_K;
            }

          /* This is really DELTA weight [time] */
          p_momentum [y] = nn->_beta * (p_lrate [y] * p_sum_delta [y]) +
                           nn->_alpha * p_momentum [y] -
                           nn->_hdec * weight [y];
          weight [y] += p_momentum [y];
          p_sum_delta [y] = 0.0;
          p_ldelta_bar [y] *= nn->_theta;
          p_ldelta_bar [y] += ((1.0 - nn->_theta) * p_ldelta [y]);
          p_ldelta [y] = 0.0;
        }
    }

  /* Now all deltas have been added into their appropriate neuron
     connection. */
  nn->training_examples += nn->examples_since_update;
  nn->examples_since_update = 0;

}


int Neural_net2_calc_forward_test (Neural_net2 *nn, double input [],
                                  double desired_output [],
                                  int print_it, double correct_eps,
                                  double good_eps)
{
  int x,y,wrong,good;

  wrong = 0;
  good = 0;

  /* Go backward for faster processing */
  /* Calculate hidden layer 1's activation */
  for (x = nn->num_hidden1 - 1; x >= 0;  --x)
    {
      nn->hidden1_act [x] = 0.0;
      for (y = nn->num_inputs - 1; y >= 0; --y)
        {
          nn->hidden1_act [x] += (input [y] *
                              nn->input_weights [x * nn->num_inputs + y]);
        }
      nn->hidden1_act [x] = S(nn->hidden1_act [x]);
    }

  /* Calculate hidden layer 2's activation */
  for (x = nn->num_hidden2 - 1; x >= 0; --x)
    {
      nn->hidden2_act [x] = 0.0;
      for (y = nn->num_hidden1 - 1; y >= 0; --y)
        {
          nn->hidden2_act [x] += (nn->hidden1_act [y] *
                                 nn->hidden1_weights [x*nn->num_hidden1 + y]);
        }
      nn->hidden2_act [x] = S(nn->hidden2_act [x]);
    }

  /* Calculate output layer's activation */
  for (x = nn->num_outputs - 1; x >= 0; --x)
    {
      nn->output_act [x] = 0.0;
      for (y = nn->num_hidden2 - 1; y >= 0; --y)
        {
          nn->output_act [x] += nn->hidden2_act [y] *
                                nn->hidden2_weights [x * nn->num_hidden2 + y];
        }
      nn->output_act [x] = S(nn->output_act [x]);

      if ( fabs (nn->output_act [x] - desired_output [x]) > good_eps )
          wrong = 1;
      else if ( fabs (nn->output_act [x] - desired_output [x]) > correct_eps )
          good = 1;
    }

  if ( print_it )
    {
      for (x = 0; x < nn->num_outputs; ++x)
        {
          printf ("%6.4f ",nn->output_act [x]);
        }
    }

  if ( wrong )
      return (WRONG);
  else if ( good )
      return (GOOD);
  else
      return (CORRECT);
}


void Neural_net2_kick_weights (Neural_net2 *nn, double range)
{
  int    x;
  double rand_max;
  double variation;

  rand_max = RAND_MAX;
  /* Add from -range to +range to all weights randomly */
  for (x = 0; x < (nn->num_hidden1 * nn->num_inputs); ++x)
    {
      variation = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          variation *= -1.0;
      nn->input_weights [x] += variation;
    }

  for (x = 0; x < (nn->num_hidden2 * nn->num_hidden1); ++x)
    {
      variation = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          variation *= -1.0;
      nn->hidden1_weights [x] += variation;
    }

  for (x = 0; x < (nn->num_outputs * nn->num_hidden2); ++x)
    {
      variation = rand () / rand_max * range;
      if ( rand () < (RAND_MAX / 2) )
          variation *= -1.0;
      nn->hidden2_weights [x] += variation;
    }

}

