
#ifndef _TD_NEURAL_NETWORK_H_
#define _TD_NEURAL_NETWORK_H_

#pragma interface

#include <String.h>

#define SLOPE    1.0
#define S(x)    (1.0 / (1.0 + exp (0.0 - SLOPE*(x))))

#define WRONG    0
#define GOOD     1
#define CORRECT  2


//****************************************************************************
//
// Time-Delay Neural_network class:
//
//      This class performs all the necessary functions needed to train
//      a Time-Delay Neural Network.  The network has an input layer, two hidden
//      layers, and an output layer.  The size of each layer is specified
//      a run time so there is no restriction on size except memory.
//      This is a feed-forward network with a time-delay connection between
//      hidden1 --> input  and  hidden2 --> hidden1
//
//      The general connection pattern looks like
//
//      # /-#     #   Output layer connected to one entire row of
//     / /       /    hidden2.  Output 1 is connected to hidden2 row1,
//    / / -------     Output 2 is connectect to hidden2 row2, etc.
//   | / / / / /
//   || # # # #      Hidden layer 2.  Each column of hidden2 is connected
//   ||-# # # #      to an entire column of hidden1 starting at the
//   |--# # # #      same hidden2 column for time_delay2 columns
//      |\    |\
//      | \   | \    Time_delay2 == 3
//      |  \  |  \
//      # # # # # #  Hidden layer 1.  Each column of hidden1 is connected
//      # # # # # #  to an entire column of the input starting at the
//      # # # # # #  same hidden1 column for time_delay1 columns
//      # # # # # #
//      |\        |\   Time_delay1 == 2
//      | |       | |
//      # # # # # # #  Input layer.
//      # # # # # # #
//      # # # # # # #
//      # # # # # # #
//
//      The network can perform straight back-propagation with no
//      modifications (Rumelhart, Hinton, and Williams, 1985) which
//      will find a solution but not very quickly.  The network can also
//      perform back-propagation with the delta-bar-delta rule developed
//      by Robert A. Jacobs, University of Massachusetts
//      (Neural Networks, Vol 1. pp.295-307, 1988).  The basic idea of this
//      rule is that every weight has its own learning rate and each
//      learning rate should be continously changed according to the
//      following rules -
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
//      To perform straight back-propagation, just construct a Neural_network2
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
//      write the routine to skip the example yourself, but the Neural_network2
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
//****************************************************************************






class TD_Neural_network {
private:
  //  We need
  //
  //  Matrix for hidden layer 1 activation [num_rows1] [num_cols1]
  //  Matrix for hidden layer 2 activation [num_row2] [num_cols2]
  //  Matrix for output layer activation [num_outputs]
  //
  //  Matrix for input to first hidden layer
  //      Weights [num_cols1] [num_rows1] [num_time_delay1] [num_rowsi]
  //  Matrix for hidden layer 1 to hidden layer 2
  //      Weights [num_cols2] [num_rows1] [num_time_delay2] [num_row1]
  //  Matrix for hidden layer 2 to output layer
  //      Weights [num_outputs] [num_cols2]

  //  3 Matrices for sum of all the deltas in an epoch - Back propagation
  //  2 Matrices for sum of deltas * weight for each neuron in hidden layers
  //    1 and 2 for backpropagation - Back propagation
  //
  //  3 Matrices for each weight's learning rate - delta-bar-delta rule
  //  3 Matrices for each weight's learning delta - delta-bar-delta rule
  //  3 Matrices for each weight's learning delta_bar - delta-bar-delta rule

  //  Some paramter equivalence
  //  num_cols1 = num_colsi - num_time_delay1 + 1
  //  num_cols2 = num_cols1 - num_time_delay2 + 1
  //  num_rows2 = num_outputs

  int     num_rowsi;
  int     num_colsi;
  int     num_rows1;
  int     num_cols1;
  int     num_time_delay1;
  int     num_rows2;
  int     num_cols2;
  int     num_time_delay2;
  int     num_outputs;

  int     bp_flag;
  int     rand_opt_flag;

  double  _epsilon;
  double  _learning_rate;
  double  _alpha;
  double  _beta;
  double  _skip_epsilon;
  double  _theta;
  double  _phi;
  double  _K;
  double  _hdec;
  double  _variance;

  long    training_examples;
  long    examples_since_update;

  double  *hidden1_act;
  double  *hidden2_act;
  double  *output_act;

  double  *input_weights;
  double  *hidden1_weights;
  double  *hidden2_weights;

  double  *input_learning_rate;
  double  *hidden1_learning_rate;
  double  *hidden2_learning_rate;

  double  *input_momentum;
  double  *hidden1_momentum;
  double  *hidden2_momentum;

  double  *input_learning_delta;
  double  *hidden1_learning_delta;
  double  *hidden2_learning_delta;

  double  *input_learning_delta_bar;
  double  *hidden1_learning_delta_bar;
  double  *hidden2_learning_delta_bar;

  double  *input_weights_sum_delta;
  double  *hidden1_weights_sum_delta;
  double  *hidden2_weights_sum_delta;

  double  *hidden1_sum_delta_weight;
  double  *hidden2_sum_delta_weight;

  double  *input_weights_g_offset;
  double  *hidden1_weights_g_offset;
  double  *hidden2_weights_g_offset;

  double  *input_weights_bias;
  double  *hidden1_weights_bias;
  double  *hidden2_weights_bias;

  void    allocate_weight_matrices ();
  void    allocate_bp_matrices ();
  void    allocate_rand_opt_matrices ();
  void    allocate_all_matrices () { allocate_weight_matrices ();
                                     allocate_bp_matrices ();
                                     allocate_rand_opt_matrices (); }
  void    initialize_weight_matrices (double range);
  void    initialize_learning_matrices ();
  void    initialize_all_matrices (double range) {
                                   initialize_weight_matrices (range);
                                   initialize_learning_matrices (); }
  void    deallocate_bp_matrices ();
  void    deallocate_rand_opt_matrices ();
  void    deallocate_all_matrices ();

public:

  //***********************************************************************
  // Constructors :                                                       *
  //    Full size specifications and learning parameters.                 *
  //         Learning parameters are provided defaults which are set to   *
  //         just use the BP algorithm with no modifications.             *
  //                                                                      *
  //    Read constructor which reads in the size and all the weights from *
  //         a file.  The network is resized to match the size specified  *
  //         by the file.  Learning parameters must be specified          *
  //         separately.                                                  *
  //***********************************************************************

  TD_Neural_network (int number_rowsi = 1, int number_colsi = 1,
                     int number_rows1 = 1,
                     int number_time_delay1 = 1, int number_time_delay2 = 1,
                     int number_outputs = 1, int backpropagation_flag = 1,
                     int random_optimization_flag = 0, double range = 3.0,
                     double variance = 0.01, double alpha = 0.0,
                     double beta = 1.0, double epsilon = 0.1,
                     double skip_epsilon = 0.0, double learning_rate = 0.1,
                     double theta = 1.0, double phi = 0.0, double K = 0.0,
                     double hdec = 0.0);
  TD_Neural_network (String& filename, int& file_error,
                     int backpropagation_flag = 1,
                     int random_optimization_flag = 0, double variance = 0.01,
                     double alpha = 0.0,
                     double beta = 1.0, double epsilon = 0.1,
                     double skip_epsilon = 0.0, double learning_rate = 0.1,
                     double theta = 1.0, double phi = 0.0, double K = 0.0,
                     double hdec = 0.0);
  ~TD_Neural_network () { deallocate_all_matrices ();}


  //**************************************************************************
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
  //**************************************************************************

  void   re_initialize_net (double range = 1.0, double learning_rate = 0.1,
                            double variance = 0.01)
         {
           _learning_rate = learning_rate;
           _variance = variance;
           initialize_all_matrices (range);
         }

  int    save_weights (String& filename);
  int    read_weights (String& filename);

  double get_hidden1_activation (int row, int col) {
         return (hidden1_act [col * num_rows1 + row]); }
  double get_hidden2_activation (int row, int col) {
         return (hidden2_act [col * num_rows2 + row]); }
  double get_output_activation (int node) {
         return (output_act [node]); }

  double get_input_weight (int hidden1_row, int hidden1_col, int input_row,
                           int time_delay) {
         return (input_weights [((hidden1_col * num_rows1 + hidden1_row) *
                                  num_time_delay1 + time_delay) * num_rowsi +
                                  input_row]);}
  double get_hidden1_weight (int hidden2_row, int hidden2_col, int hidden1_row,
                             int time_delay) {
         return (hidden1_weights [((hidden2_col * num_rows2 + hidden2_row) *
                                    num_time_delay2 + time_delay) * num_rows1 +
                                    hidden1_row]);}
  double get_hidden2_weight (int output_node, int hidden2_col) {
         return (hidden2_weights [output_node * num_cols2 + hidden2_col]);}


  //*******************************************************************
  // Size parameters of network.                                      *
  // The size of the network may be changed at any time.  The weights *
  // will be copied from the old size to the new size.  If the new    *
  // size is larger, then the extra weights will be randomly set      *
  // between +-range.  The matrices used to hold learning updates     *
  // and activations will be re-initialized (cleared).                *
  //*******************************************************************

  int get_number_of_input_rows () { return (num_rowsi); }
  int get_number_of_input_cols () { return (num_colsi); }
  int get_number_of_hidden1_rows () { return (num_rows1); }
  int get_number_of_hidden1_cols () { return (num_cols1); }
  int get_number_of_hidden1_time_delay () { return (num_time_delay1); }
  int get_number_of_hidden2_rows () { return (num_rows2); }
  int get_number_of_hidden2_cols () { return (num_cols2); }
  int get_number_of_hidden2_time_delay () { return (num_time_delay2); }
  int get_number_of_outputs () { return (num_outputs); }
  int set_size_parameters (int number_input_rows, int number_input_cols,
                           int number_hidden1_rows, int number_hidden1_time_delay,
                           int number_hidden2_time_delay, int number_outputs,
                           double range = 3.0);


  //*******************************************************************
  // Learning parameters functions.  These parameters may be changed  *
  // on the fly.  The learning rate and K may have to be reduced as   *
  // more and more training is done to prevent oscillations.          *
  //*******************************************************************

  int    backpropagation_flag () { return (bp_flag); }
  int    backpropagation_flag (int new_flag);
  int    random_optimization_flag () { return (rand_opt_flag); }
  int    random_optimization_flag (int new_flag);
  double learnine_rate () { return (_learning_rate); }
  double learning_rate (double learning_rate);

  double alpha () { return _alpha;}
  double alpha (double alpha) {double old_alpha = _alpha;
                               _alpha = alpha; return old_alpha;}
  double beta () { return _beta;}
  double beta (double beta) {double old_beta = _beta; _beta = beta;
                             return old_beta;}
  double epsilon () { return _epsilon;}
  double epsilon (double epsilon) {double old_epsilon = _epsilon;
                                   _epsilon = epsilon; return old_epsilon;}
  double skip_epsilon () { return _skip_epsilon; }
  double skip_epsilon (double skip_epsilon) {double old_skip = _skip_epsilon;
                              _skip_epsilon = skip_epsilon; return old_skip;}
  double theta () { return _theta;}
  double theta (double theta) {double old_theta = _theta; _theta = theta;
                               return old_theta;}
  double phi () { return _phi;}
  double phi (double phi) {double old_phi = _phi; _phi = phi;
                           return old_phi;}
  double K () { return _K;}
  double K (double K) {double old_K = _K; _K = K; return old_K;}
  double hdec () { return _hdec;}
  double hdec (double hdec) {double old_hdec = _hdec; _hdec = hdec;
                             return old_hdec;}
  double variance () { return _variance;}
  double variance (double variance) {double old_variance = _variance;
                                     _variance = variance;
                                     return old_variance;}

  // I use this because I can never remember what the standard delta-bar-delta
  // parameter settings are that I use.
  void set_standard_dbd_parameters ();

  long   get_iterations () { return (training_examples); }


  //**************************************************************************
  // The main neural network routines:                                       *
  //                                                                         *
  //      The network input is an array of doubles which has a size of       *
  //           number_inputs.                                                *
  //      The network desired output is an array of doubles which has a size *
  //           of number_outputs.                                            *
  //                                                                         *
  //      backpropagation : Calculates how each weight should be changed.    *
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
  //           all node activations which are needed for backpropagation     *
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
  //           the calculations of backpropagation.  This routine should     *
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
  //**************************************************************************

  void backpropagation (double input [], double desired_output [],
                         int& done);

  double calc_forward (double input [], double desired_output [],
                       int& num_wrong, int& skip, int print_it,
                       int& actual_printed);

  int calc_forward_test (double input [], double desired_output [],
                         int print_it, double correct_eps, double good_eps);

  void update_weights ();

  double calc_forward_rand_opt (double input [], double desired_output [],
                                int& num_wrong, int direction);

  int generate_gaussian_offsets ();

  void update_weights_with_offset (int direction);

  void kick_weights (double range);

};

#endif

