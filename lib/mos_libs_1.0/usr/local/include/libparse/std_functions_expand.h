/** 
 * In order to add a new standard function, you need to perform
 * 6 different actions:
 * 1) Add the function string expression "FUNC_OP" in std_functions.h
 * 2) Add the function ID "FUNC" in std_functions.h"
 * 3) Add the expand function in std_functions_expand.h (here) 
 * 	and define the corresponding macro
 * 4) Add the solver function in std_functions_solve.h"
 * 	and define the corresponding macro
#include "../Dropbox/m-parse/std_functions_expand.h"
#include "../Dropbox/m-parse/std_functions_expand.h"
 *	5) Add function initialization in init_func_bind function (here)
 *	6) Increase the "NOTOP" value by one in std_functions.h
 */

static btree * expand_std_2op_func(struct operation *me, btree **bt, list *tokens){
	int operations = list_count(tokens)-1;
	if(operations>0)
	{	
		int n_internal_nodes = operations;
		int n_external_nodes = n_internal_nodes+1;
		unsigned int count = 0;
		unsigned int to_append = 1;
		int i = 1, l = 2, starting_args_index;
		int operands_start_index,operands_upperlayer;
		
		///Detecting starting operand index
		while (n_internal_nodes > i + l) { i = i + l; l *= 2;	}
		if (n_internal_nodes == i + l ) starting_args_index = 0;
		else starting_args_index = (n_internal_nodes - i) * 2;
		
		///ROOT Filling
		btree_fill(bt[count], fill_operator_node(me->id));
		
		i=to_append;
		operands_start_index=0, operands_upperlayer=0;
		///Nodes left to fill
		while (to_append < n_internal_nodes + n_external_nodes)
		{
			///Node is an operator
			if(to_append < n_internal_nodes)
			{
				///Node to fill is a leftmost node
				if ( to_append == i )
				{
					btree_fill(bt[to_append],fill_operator_node(me->id));
					i = ((i + 1) * 2) - 1;
					operands_start_index = (n_internal_nodes + n_external_nodes - i) ;
					operands_upperlayer = (n_external_nodes > operands_start_index) ? n_external_nodes - operands_start_index : 0;
				}
				else //If it's not the leftmost node we could need to reverse the operation
				{
					if(me->id==DIV) btree_fill(bt[to_append],fill_operator_node(MULT));
					else if (me->id==SUB) btree_fill(bt[to_append],fill_operator_node(SUM));
					else btree_fill(bt[to_append],fill_operator_node(me->id));
				}
			}
			///LEFT Filling (to_append > internal && external > to_append) ==> (operand) 
			else
			{
				btree_fill(bt[to_append], fill_operand_node(list_pop_index(tokens, (((operands_upperlayer--))>0)?(operands_start_index):(0))));
			}
			///Connecting
			bt[count]->left = bt[to_append];
			///Incrementing [ next is RIGHT ]
			to_append++;
			
			///RIGHT Filling (operator)
			if(to_append < n_internal_nodes)
			{
				if(me->id==DIV) btree_fill(bt[to_append], fill_operator_node(MULT));	
				else if (me->id==SUB) btree_fill(bt[to_append], fill_operator_node(SUM));
				else btree_fill(bt[to_append], fill_operator_node(me->id));
			}
			///RIGHT Filling (to_append > internal && external> to_append) ==> (operand)
			else
			{
				btree_fill(bt[to_append], fill_operand_node(list_pop_index(tokens, (((operands_upperlayer--))>0)?(operands_start_index):(0))));
			}
			///Connecting
			bt[count]->right = bt[to_append];
			///Incrementing [next is LEFT]
			to_append++;
			///Incrementing node to attach new nodes to
			count++;
		}
	}
	return bt[0];
}

#define SUM_EXPAND expand_sum_func
static btree * (* expand_sum_func)(struct operation *, btree **, list *) = expand_std_2op_func;

#define SUB_EXPAND expand_sub_func
static btree * (* expand_sub_func)(struct operation *, btree **, list *) = expand_std_2op_func;

#define MULT_EXPAND expand_mult_func
static btree * (* expand_mult_func)(struct operation *, btree **, list *) = expand_std_2op_func;

#define DIV_EXPAND expand_div_func
static btree * (* expand_div_func)(struct operation *, btree **, list *) = expand_std_2op_func;


static btree * expand_alt_2op_func(struct operation *me, btree **bt, list *tokens){
	int operations = list_count(tokens)-1;
	if(operations>0)
	{	
		int n_internal_nodes = operations;
		int n_external_nodes = n_internal_nodes+1;
		unsigned int count = 0;
		unsigned int to_append = 1;
		///ROOT Filling
		btree_fill(bt[count], fill_operator_node(me->id));
		///Tokens must be inserted in swapped (list_reverse) order.
		list_reverse(tokens);
		while (to_append < n_internal_nodes + n_external_nodes)
		{
			btree_fill(bt[to_append],fill_operand_node(list_pop_index(tokens, 0)));
			bt[count]->right = bt[to_append];
			///Incrementing node to attach
			to_append++;
			if(to_append == n_internal_nodes + n_external_nodes - 1)
			{
				///We got to the leftmost node (it's an operand!)
				btree_fill(bt[to_append],fill_operand_node(list_pop_index(tokens, 0)));
				bt[count]->left = bt[to_append];
				break;
			}
			else
			{
				///Filling left operator
				btree_fill(bt[to_append],fill_operator_node(me->id));
				bt[count]->left = bt[to_append];
			}
			///Incrementing node to attach
			to_append++;
			///Incrementing node to attach new nodes to (by 2 to go left)
			count+=2;
		}
	}
	return bt[0];
}

#define MOD_EXPAND expand_mod_func
static btree * (* expand_mod_func)(struct operation *, btree **, list *) = expand_alt_2op_func;

#define EXP_EXPAND expand_exp_func
static btree * (* expand_exp_func)(struct operation *, btree **, list *) = expand_alt_2op_func;

static btree * expand_1op_func(struct operation *me, btree **bt, list *tokens){
	///ROOT Filling
	btree_fill(bt[0], fill_operator_node(me->id));
	
	///RIGHT Filling (operand)
	btree_fill(bt[1], fill_operand_node(list_pop_index(tokens, 1)));
	
	///Connecting
	bt[0]->right = bt[1];
	bt[0]->left = NULL;
	return bt[0];
}

#define COS_EXPAND expand_cos_func
static btree * (* expand_cos_func)(struct operation *, btree **, list *) = expand_1op_func;

#define SIN_EXPAND expand_sin_func
static btree * (* expand_sin_func)(struct operation *, btree **, list *) = expand_1op_func;

#define TAN_EXPAND expand_tan_func
static btree * (* expand_tan_func)(struct operation *, btree **, list *) = expand_1op_func;

#define ATAN_EXPAND expand_atan_func
static btree * (* expand_atan_func)(struct operation *, btree **, list *) = expand_1op_func;

#define NEP_EXPAND expand_nep_func
static btree * (* expand_nep_func)(struct operation *, btree **, list *) = expand_1op_func;

#define LOGN_EXPAND expand_logn_func
static btree * (* expand_logn_func)(struct operation *, btree **, list *) = expand_1op_func;

#define LOG2_EXPAND expand_log2_func
static btree * (* expand_log2_func)(struct operation *, btree **, list *) = expand_1op_func;

#define LOG10_EXPAND expand_log10_func
static btree * (* expand_log10_func)(struct operation *, btree **, list *) = expand_1op_func;

static void init_func_bind(void){
	void bind_op(op_id id, char *expr, void *expand_fnptr){
		operation[id].id = id;
		operation[id].op = expr;
		operation[id].expand_fptr = expand_fnptr;
		return;
	}
	bind_op(SUM ,SUM_OP, SUM_EXPAND);
	bind_op(SUB ,SUB_OP, SUB_EXPAND);
	bind_op(EXP ,EXP_OP, EXP_EXPAND);
	bind_op(MULT ,MULT_OP, MULT_EXPAND);
	bind_op(DIV ,DIV_OP, DIV_EXPAND);
	bind_op(MOD ,MOD_OP, MOD_EXPAND);
	bind_op(COS ,COS_OP, COS_EXPAND);
	bind_op(SIN ,SIN_OP, SIN_EXPAND);
	bind_op(TAN ,TAN_OP, TAN_EXPAND);
	bind_op(ATAN ,ATAN_OP, ATAN_EXPAND);
	bind_op(NEP ,NEP_OP, NEP_EXPAND);
	bind_op(LOGN ,LOGN_OP, LOGN_EXPAND);
	bind_op(LOG2 ,LOG2_OP, LOG2_EXPAND);
	bind_op(LOG10 ,LOG10_OP, LOG10_EXPAND);
	return;
}
