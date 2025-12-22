
#ifndef _NEURAL_NET1_H_
#define _NEURAL_NET1_H_

/* This is the "C" version of the Neural Network code */


#define SLOPE    1.0
#define S(x)    (1.0 / (1.0 + exp (0.0 - SLOPE*(x))))

#define private
#define public
#define class typedef struct

#define WRONG    0
#define GOOD     1
#define CORRECT  2


/*****************************************************************************
//
// Neural_net1 class:
//
//      This class performs all the necessary functions needed to train
//      a Neural Network.  The network has an input layer, one hidden
//      layer, and an output layer.  The size of each layer is specified
//      a run time so there is no restriction on size except memory.
//      This is a feed-forward network with full connctions from one
//      layer to the next.
//
//      The network can perform straight back-propagation with no
//      modifications (Rumelhart, Hinton, and Williams, 1985) which
//      will find a solution but not very quickly.  The network can also
//      perform back-propagation with the delta-bar-delta and the
//      hybrid rule developed
//      by Robert A. Jacobs, University of Massachusetts
//
//      "Increased Rates of Convergence Through Learning Rate Adaptation"
//      by Robert A. Jacobs.
//      Neural Networks, Vol 1. pp.295-307, 1988.
//
//      The basic idea of this rule is that every weight has its own
//      learning rate and momentum.  Each learning rate should be continously
//      changed according to the following rules -
//      - If the weight changes in the same direction as the previous update,
//        then the learning rate for that weight should increase by a constant.
//      - If the weight changes in the opposite direction as the previous
//        update, then the learning rate for that weight should decrease
//        exponentially.
//
//      learning rate = e(t) for each individual weight
//      The exact formula for the change in learning rate (DELTA e(t)) is
//
//
//                   | K          if DELTA_BAR(t-1)*DELTA(t) > 0
//      DELTA e(t) = | -PHI*e(t)  if DELTA_BAR(t-1)*DELTA(t) < 0
//                   | 0          otherwise
//
//      where DELTA(t) = dJ(t) / dw(t) ---> Partial derivative
//
//      and DELTA_BAR(t) = (1 - THETA)*DELTA(t) + THETA*DELTA_BAR(t-1).
//
//      The rule in the paper was:
//      delta weight (t) = (1 - ALPHA) * learning rate * dJ(t)/dw(t) +
//                         ALPHA * delta weight (t - 1)
//
//      I modified it slightly so that there is a separate parameter for
//      (1 - alpha) called BETA which can be set to any value.
//      Also added is the parameter HDEC which is the decay factor which is
//      supposed to only allow weight to survive that do useful work.
//      delta weight (t) = BETA * learning rate * dJ(t)/dw(t) +
//                         ALPHA * delta weight (t - 1) - HDEC * weight (t-1)
//
//      For full details of the algorithm, read the article in
//      Neural Networks.
//
//      The parameter HDEC is from
//      "Learning translation invariant recognition in a massivelly parallel
//       network"
//      by G.E. Hinton
//      PARLE: Parallel Architectures and Languages Europe 1987
//      Referenced from "Multilayer Perceptron, Fuzzy Sets, and
//      Classification" Neural Networks, Vol 1, NO. 5, Sept. 1992.
//
//      Range of values
//      ALPHA [0,1.0]
//      BETA [0,1.0]
//      THETA [0,1.0]
//      PHI [0,1.0]
//      K [0,infinity) --> recommended range [0,1.0]
//      HDEC [0,infinity) --> recommended range [0,0.01)
//
//      I know very little about the HDEC parameter.  I read about it in
//      the "Multilayer..." paper and the paper did not go into
//      detail about it.
//
//      To perform straight back-propagation, just construct a Neural_net2work2
//      with no learning parameters specified (they default to straight
//      back-propagation) or set them to
//      ALPHA = 0.0, BETA = 1.0, THETA = 1.0, PHI = 0.0, K = 0.0, HDEC = 0.0
//
//      For momentum only with fixed learning rate
//      ALPHA = ?, BETA = 1.0, THETA = 1.0, PHI = 0.0, K = 0.0, HDEC = 0.0
//
//      However, using the delta-bar-delta rule should increase your rate of
//      convergence by a factor of 1 to 30 generally.  The parameters for
//      the delta-bar-delta rule I use are
//      ALPHA = 0.0, BETA = 1.0, THETA = 0.8, PHI = 0.2, K = 0.025, HDEC = 0.0
//
//      The hybrid rule uses the delta-bar-delta learning update rule plus
//      sets ALPHA so that there is momentum.
//      ALPHA = 0.4 plus previous delta-bar-delta settings should generally
//      improve the rate of convergence even more.
//
//      One more heuristic method has been employed in this Neural net class-
//      the skip heuristic.  This is something I thought of and I am sure
//      other people have also.  If the output activation is within
//      skip_epsilon of its desired for each output, then the calc_forward
//      routine returns the skip_flag = 1.  This allows you to not waste
//      time trying to push already very close examples to the exact value.
//      If the skip_flag comes back '1', then don't bother calculating forward
//      or back-propagating the example for X number of epochs.  You must
//      write the routine to skip the example yourself, but the Neural_net2work2
//      will tell you when to skip the example.  This heuristic also has the
//      advantage of reducing memorization and increases generalization.
//      Typical values I use for this heuristic -
//      skip_epsilon = 0.01 - 0.05
//      number skipped = 2-10.
//
//      As with all heuristics, some work well in some situations and
//      poorly in others.  The delta-bar-delta and hybrid rule seem
//      somewhat succeptible to starting location so that training from
//      scratch may take 200 epochs one time and 10000 epochs another.
//      Experiment with all the values to see which work best for your
//      application.
//
//
//      Another training method has been implemented, the Random Optimization
//      Method by Solis & Wets, 1981.  The reference is
//
//      "A New Approach for Finding the Global Minimum of Error Function
//      of Neural Networks" by Norio Baba.
//      Neural Networks, Vol. 2, pp. 367-373, 1989.
//
//      I implemented this algorithm because it claimed to be quite good.
//      However, it makes exaggerated generalized claims based upon on
//      three very limited tests.
//
//      The basic algorithm is to generate a gaussian random offset for each
//      weight, see if adding (or subtracting) all of the offsets to the
//      weights will reduce the error.  If the error is reduced, move to that
//      new location by adding (or subtracting) the offsets to the weights.
//      The claim is that this algorithm will find the Global Minimum with
//      probability 1, which is true.  The example test cases used to show
//      that it converges faster than standard backpropagation are fudged
//      because they solve 10 input patterns with over 100 weights which
//      is ridiculously easy to do without learning anything because the
//      solution space is so large.  However, when the solution space is
//      small (i.e. there are barely enough nodes to hold all the information)
//      then random optimization has a hard time finding the solution.
//      I tried to have it solve
//      the XOR problem with 2 inputs, 2 hidden1, 2 hidden2 and 1 output.
//      Delta-bar-delta solved it about half the time but this algorithm
//      solved it about 20% of the time.  If I had let the algorithm go
//      forever, it would have eventually solved the problem, but not
//      for a long time.
//
//      Basically if it does not solve the problem quickly, it won't for a
//      very long time.
//
//      Now the answer to the question - If Random Optimization doesn't seem
//      to work in general, why include it?
//      The reason - for completeness.  Someone may come across the paper
//      and want to try it so here it is.  Also I have seen it work very
//      well for some applications.
//
//      Comments and suggestions are welcome and can be emailed to me
//      anstey@sun.soe.clarkson.edu
//
/ ****************************************************************************/




/* This 'class' (struct) is private.  You should not modify it directly */
/* or corrupted data may occur.  Only modify it through the 'class' */
/* functions listed below. */
class Neural_net1 {
private

/*
  //  We need
  //
  //  Matrix for hidden layer 1 activation [num_hidden1]
  //  Matrix for output layer activation [num_outputs]
  //
  //  Matrix for input to first hidden layer weights [num_inputs] [num_hidden1]
  //  Matrix for hidden layer 2 to output layer weights [hidden2] [outputs]

  //  2 Matrices for sum of all the deltas in an epoch - Back propagation
  //  1 Matrices for sum of deltas * weight for each neuron in hidden layers
  //    1 and 2 for backpropagation - Back propagation
  //
  //  2 Matrices for each weight's learning rate - delta-bar-delta rule
  //  2 Matrices for each weight's learning delta - delta-bar-delta rule
  //  2 Matrices for each weight's learning delta_bar - delta-bar-delta rule
  //  2 Matrices for each weight's momentum - hybrid delta-bar-delta rule

  //  2 Matrices for each weight's gaussian offset - Random Optimization
  //  2 Matrices for each weight's bias - Random Optimization
*/

  int     num_inputs;
  int     num_hidden1;
  int     num_outputs;
  int     bp_flag;
  int     rand_opt_flag;

  double  _epsilon;
  double  _skip_epsilon;
  double  _learning_rate;
  double  _alpha;
  double  _beta;
  double  _theta;
  double  _phi;
  double  _K;
  double  _hdec;
  double  _variance;
  long    training_examples;
  long    examples_since_update;

  double  *hidden1_act;
  double  *output_act;

  double  *input_weights;
  double  *hidden1_weights;

  double  *input_weights_sum_delta;
  double  *hidden1_weights_sum_delta;

  double  *hidden1_sum_delta_weight;

  double  *input_learning_rate;
  double  *hidden1_learning_rate;

  double  *input_learning_delta;
  double  *hidden1_learning_delta;

  double  *input_learning_delta_bar;
  double  *hidden1_learning_delta_bar;

  double  *input_momentum;
  double  *hidden1_momentum;

  double  *input_weights_g_offset;
  double  *hidden1_weights_g_offset;

  double  *input_weights_bias;
  double  *hidden1_weights_bias;

} Neural_net1;

public /* These are the functions that operate on a struct Neural_net1 */
        /* The first parameter to any Neural_net1 function
           (except constructors) is a pointer to an initialized Neural_net1 */

  /**************************************************************************
  // Constructors : Each constructor returns a pointer to a                 *
  //                Neural_net1 which has been initialized.                 *
  //                                                                        *
  //    Neural_net1_constr : Constructs (initializes) a Neural_net1 struct. *
  //         Full size specifications and learning parameters need to be    *
  //         specified.                                                     *
  //                                                                        *
  //    Neural_net1_default_constr : Constructs (initializes) a Neural_net1 *
  //         structure of the given size with the default learning          *
  //         parameters for BP and weights between +-1.0.                   *
  //                                                                        *
  //    Neural_net1_read_constr : Constructs (initializes) a Neural_net1    *
  //         structure by reading the weights from a file.  The size of     *
  //         the Neural_net1 is determined by the file.  Learning           *
  //         parameters need to be specified.                               *
  //                                                                        *
  //    Neural_net1_default_read_constr : Constructs (initializes) a        *
  //         Neural_net1 structure by reading the weights from a file.      *
  //         The size of the Neural_net1 is determined by the file.         *
  //         Learning parameters are given default BP values.               *
  //                                                                        *
  // Destructor : The destructor destroys (frees) all matrices in a         *
  //         Neural_net1 structure                                          *
  //                                                                        *
  //    Neural_net1_destr : YOU MUST CALL THIS ROUTINE TO DESTROY THE       *
  //          Neural_net1. The destructor frees all matrices in the         *
  //          Neural_net1.                                                  *
  / ************************************************************************/

Neural_net1 *Neural_net1_constr (int number_inputs, int number_hidden1,
                     int number_outputs, int backpropagation_flag,
                     int random_optimization_flag, double range,
                     double variance, double alpha, double beta,
                     double epsilon,
                     double skip_epsilon, double learning_rate,
                     double theta, double phi, double K,
                     double hdec);

Neural_net1 *Neural_net1_read_constr (char *filename, int *file_error,
                   int backpropagationflag,
                   int random_optimization_flag, double variance,
                   double alpha, double beta, double epsilon,
                   double skip_epsilon, double learning_rate,
                   double theta, double phi, double K, double hdec);

void Neural_net1_destr (Neural_net1 *nn);

/* Inline functions if compiler supports inlining */
#ifdef __INLINE__
inline Neural_net1 *Neural_net1_default_constr (int number_inputs,
                   int number_hidden1, int number_outputs,
                   int backpropagation_flag,
                   int random_optimization_flag, double range)
{
  return (Neural_net1_constr (number_inputs,number_hidden1,
                              number_outputs,
                              backpropagation_flag,
                              random_optimization_flag,range,0.01,0.0,1.0,
                              0.1,0.0,0.1,1.0,0.0,0.0,0.0);
}

inline Neural_net1 *Neural_net1_default_read_constr (char *filename,
                                                     int *file_error,
                                             int backpropagation_flag,
                                             int random_optimization_flag)
{
  return (Neural_net1_read_constr (filename,file_error,backpropagation_flag,
                                   random_optimization_flag,0.01,0.0,1.0,0.1,
                                   0.0,0.1,1.0,0.0,0.0,0.0);
}
#else
Neural_net1 *Neural_net1_default_constr (int number_inputs,
                   int number_hidden1, int number_outputs,
                   int backpropagation_flag,
                   int random_optimization_flag, double range);

Neural_net1 *Neural_net1_default_read_constr (char *filename,
                                              int *file_error,
                                              int backpropagation_flag,
                                              int random_optimization_flag);
#endif

  /***************************************************************************
  // Weight parameter routines:                                              *
  //     save_weights : This routine saves the weights of the network        *
  //          to the file <filename>.                                        *
  //                                                                         *
  //     read_weights : This routine reads the weight values from the file   *
  //          <filename>.  The network is automatically resized to the       *
  //          size specified by the file.                                    *
  //                                                                         *
  //     Activation routines return the node activation after a calc_forward *
  //          has been performed.                                            *
  //                                                                         *
  //     get_weight routines return the weight between node1 and node2.      *
  //                                                                         *
  / *************************************************************************/

void   Neural_net1_re_initialize_net (Neural_net1 *nn, double range,
                                      double learning_rate, double variance);

int    Neural_net1_save_weights (Neural_net1 *nn, char *filename);
int    Neural_net1_read_weights (Neural_net1 *nn, char *filename);

#ifdef __INLINE__
inline double Neural_net1_get_hidden1_activation (Neural_net1 *nn,
                                                 int node)
  { return (nn->hidden1_act [node]); };

inline double Neural_net1_get_output_activation (Neural_net1 *nn,
                                                int node)
  { return (nn->output_act [node]); };

inline double Neural_net1_get_input_weight (Neural_net1 *nn,
                                           int input_node, int hidden1_node)
  { return (nn->input_weights [hidden1_node * nn->num_inputs + input_node]);};

inline double Neural_net1_get_hidden1_weight (Neural_net1 *nn,
                                             int hidden1_node, int output_node)
  { return (nn->hidden1_weights [output_node*nn->num_hidden1+hidden1_node]);};

#else
double Neural_net1_get_hidden1_activation (Neural_net1 *nn, int node);
double Neural_net1_get_output_activation (Neural_net1 *nn, int node);

double Neural_net1_get_input_weight (Neural_net1 *nn, int input_node,
                                    int hidden1_node);
double Neural_net1_get_hidden1_weight (Neural_net1 *nn, int hidden1_node,
                                      int hidden2_node);
#endif

  /********************************************************************
  // Size parameters of network.                                      *
  // The size of the network may be changed at any time.  The weights *
  // will be copied from the old size to the new size.  If the new    *
  // size is larger, then the extra weights will be randomly set      *
  // between +-range.  The matrices used to hold learning updates     *
  // and activations will be re-initialized (cleared).                *
  / ******************************************************************/

#ifdef __INLINE__
inline int Neural_net1_get_number_inputs (Neural_net1 *nn)
  { return (nn->num_inputs); };
inline int Neural_net1_get_number_hidden1 (Neural_net1 *nn)
  { return (nn->num_hidden1); };
inline int Neural_net1_get_number_outputs (Neural_net1 *nn)
  { return (nn->num_outputs); };
#else
int Neural_net1_get_number_inputs (Neural_net1 *nn);
int Neural_net1_get_number_hidden1 (Neural_net1 *nn);
int Neural_net1_get_number_outputs (Neural_net1 *nn);
#endif

void Neural_net1_set_size_parameters (Neural_net1 *nn, int number_inputs,
                                     int number_hidden1, int number_outputs,
                                     double range);

  /********************************************************************
  // Learning parameters functions.  These parameters may be changed  *
  // on the fly.  The learning rate and K may have to be reduced as   *
  // more and more training is done to prevent oscillations.          *
  / ******************************************************************/

int  Neural_net1_get_backpropagation_flag (Neural_net1 *nn);
int  Neural_net1_set_backpropagation_flag (Neural_net1 *nn, int flag);
int  Neural_net1_get_random_optimization_flag (Neural_net1 *nn);
int  Neural_net1_set_random_optimization_flag (Neural_net1 *nn, int flag);
double Neural_net1_get_learning_rate (Neural_net1 *nn);
double Neural_net1_set_learning_rate (Neural_net1 *nn, double learning_rate);

/* I use this because I can never remember what the standard delta-bar-delta
   parameter settings are that I use. */
void Neural_net1_set_standard_dbd_parameters (Neural_net1 *nn);

#ifdef __INLINE__
inline double Neural_net1_set_alpha (Neural_net1 *nn, double alpha)
  {double old_alpha = nn->_alpha; nn->_alpha = alpha; return old_alpha; }
inline double Neural_net1_set_beta (Neural_net1 *nn, double beta)
  {double old_beta = nn->_beta; nn->_beta = beta; return old_beta; }
inline double Neural_net1_set_epsilon (Neural_net1 *nn, double epsilon)
  {double old_eps = nn->_epsilon; nn->_epsilon = epsilon; return old_eps; }
inline double Neural_net1_set_skip_epsilon (Neural_net1 *nn, double skip_eps)
  {double old_skip_eps = nn->_skip_epsilon; nn->_skip_epsilon = skip_eps;
   return old_skip_eps; }
inline double Neural_net1_set_theta (Neural_net1 *nn, double theta)
  {double old_theta = nn->_theta; nn->_theta = theta; return old_theta; }
inline double Neural_net1_set_phi (Neural_net1 *nn, double phi)
  {double old_phi = nn->_phi; nn->_phi = phi; return old_phi; }
inline double Neural_net1_set_K (Neural_net1 *nn, double K)
  {double old_K = nn->_K; nn->_K = K; return old_K; }
inline double Neural_net1_set_hdec (Neural_net1 *nn, double hdec)
  {double old_hdec = nn->_hdec; nn->_hdec = hdec; return old_hdec; }
inline double Neural_net1_set_variance (Neural_net1 *nn, double variance)
  {double old_variance = nn->_variance; nn->_variance = variance;
   return old_variance; }

inline double Neural_net1_get_alpha (Neural_net1 *nn)
  { return (nn->_alpha); }
inline double Neural_net1_get_beta (Neural_net1 *nn)
  { return (nn->_beta); }
inline double Neural_net1_get_epsilon (Neural_net1 *nn)
  { return (nn->_epsilon); };
inline double Neural_net1_get_skip_epsilon (Neural_net1 *nn)
  { return (nn->_skip_epsilon); };
inline double Neural_net1_get_theta (Neural_net1 *nn)
  { return (nn->_theta); };
inline double Neural_net1_get_phi (Neural_net1 *nn)
  { return (nn->_phi); };
inline double Neural_net1_get_K (Neural_net1 *nn)
  { return (nn->_K); };
inline double Neural_net1_get_hdec (Neural_net1 *nn)
  { return (nn->_hdec); }
inline double Neural_net1_get_variance (Neural_net1 *nn)
  { return (nn->_variance); }

inline long   Neural_net1_get_iterations (Neural_net1 *nn)
  { return (nn->training_examples); }

#else
double Neural_net1_set_alpha (Neural_net1 *nn, double alpha);
double Neural_net1_set_beta (Neural_net1 *nn, double beta);
double Neural_net1_set_epsilon (Neural_net1 *nn, double epsilon);
double Neural_net1_set_skip_epsilon (Neural_net1 *nn, double skip_eps);
double Neural_net1_set_theta (Neural_net1 *nn, double theta);
double Neural_net1_set_phi (Neural_net1 *nn, double phi);
double Neural_net1_set_K (Neural_net1 *nn, double K);
double Neural_net1_set_hdec (Neural_net1 *nn, double hdec);
double Neural_net1_set_variance (Neural_net1 *nn, double variance);

double Neural_net1_get_alpha (Neural_net1 *nn);
double Neural_net1_get_beta (Neural_net1 *nn);
double Neural_net1_get_epsilon (Neural_net1 *nn);
double Neural_net1_get_skip_epsilon (Neural_net1 *nn);
double Neural_net1_get_theta (Neural_net1 *nn);
double Neural_net1_get_phi (Neural_net1 *nn);
double Neural_net1_get_K (Neural_net1 *nn);
double Neural_net1_get_hdec (Neural_net1 *nn);
double Neural_net1_get_variance (Neural_net1 *nn);

long   Neural_net1_get_iterations (Neural_net1 *nn);
#endif


  /**************************************************************************
  // The main neural network routines:                                       *
  //                                                                         *
  //      The network input is an array of doubles which has a size of       *
  //           number_inputs.                                                *
  //      The network desired output is an array of doubles which has a size *
  //           of number_outputs.                                            *
  //                                                                         *
  //      back_propagation : Calculates how each weight should be changed.   *
  //           Assumes that calc_forward has been called just prior to       *
  //           this routine to calculate all of the node activations.        *
  //                                                                         *
  //      calc_forward_rand_opt : Calculates the error for the input         *
  //           by adding (or subtracting) the gaussian offsets to the        *
  //           weights.  First call generate_gaussian_offsets to create      *
  //           the offsets, call this routine for each example to find the   *
  //           global error.  If the new global error is less than the       *
  //           current error, call update_weights_with_offsets.              *
  //                                                                         *
  //      calc_forward : Calculates the output for a given input.  Finds     *
  //           all node activations which are needed for back_propagation    *
  //           to calculate weight adjustment.  Returns abs (error).         *
  //           The parameter skip is for use with the skip_epsilon           *
  //           parameter.  What it means is if the output is within          *
  //           skip_epsilon of the desired, then it is so close that it      *
  //           should be skipped from being calculated the next X times.     *
  //           Careful use of this parameter can significantly increase      *
  //           the rate of convergence and also help prevent over-learning.  *
  //                                                                         *
  //      calc_forward_test : Calculates the output for a given input.  This *
  //           routine is used for testing rather than training.  It returns *
  //           whether the test was CORRECT, GOOD or WRONG which is          *
  //           determined by the parameters correct_epsilon and              *
  //           good_epsilon.  CORRECT > GOOD > WRONG.                        *
  //                                                                         *
  //      update_weights : Actually adjusts all the weights according to     *
  //           the calculations of back_propagation.  This routine should    *
  //           be called at the end of every training epoch.  The weights    *
  //           can be updated by the straight BP algorithm, or by the        *
  //           delta-bar-delta algorithm developed by Robert A. Jacobs       *
  //           which increases the rate of convergence generally by at       *
  //           least a factor of 10.  The parameters THETA, PHI, and K       *
  //           determine which algorithm is used.  The default settings      *
  //           for these parameters cause update_weights to use the straight *
  //           BP algorithm.                                                 *
  //                                                                         *
  //      kick_weights : This routine changes all weights by a random amount *
  //           within +-range.  It is useful in case the network gets        *
  //           'stuck' and is having trouble converging to a solution.  I    *
  //           use it when the number wrong has not changed for the last 200 *
  //           epochs.  Getting the range right will take some trial and     *
  //           error as it depends on the application and the weights'       *
  //           actual values.                                                *
  //                                                                         *
  / *************************************************************************/


void Neural_net1_back_propagation (Neural_net1 *nn, double input [],
                                  double desired_output [], int *done);

double Neural_net1_calc_forward (Neural_net1 *nn, double input [],
                                double desired_output [], int *num_wrong,
                                int* skip, int print_it, int *actual_printed);

int Neural_net1_calc_forward_test (Neural_net1 *nn, double input [],
                                  double desired_output [], int print_it,
                                  double correct_eps, double good_eps);

void Neural_net1_update_weights (Neural_net1 *nn);

double Neural_net1_calc_forward_rand_opt (Neural_net1 *nn, double input [],
                                          double desired_output [],
                                          int *num_wrong, int direction);

int Neural_net1_generate_gaussian_offsets (Neural_net1 *nn);

void Neural_net1_update_weights_with_offset (Neural_net1 *nn, int direction);

void Neural_net1_kick_weights (Neural_net1 *nn, double range);



#endif
