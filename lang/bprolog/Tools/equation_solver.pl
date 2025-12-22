/*
/*     LME v2.3.1      */
/*zhuhail@vax.sbu.ac.uk*/
/* any comment welcome */
/*      19/6/95        */
/*
This code solves linear multiple equations in Prolog. Using Gauss method,
It finds the maximum (abs) element and changes the corresponding row and
column to first row and column in the working matrix. */

go:-
    matrix(Matrix),
    write(Matrix),nl,
    linear_multi_equation(Matrix,Result),
    write('result = '),write(Result),nl,fail.

matrix(Matrix):-
    Matrix= [[ 5, 0, 2],
	     [ 1, 1,7]
	    ].

/*
matrix(Matrix):-
    Matrix= [[ 5, 1, 2,-3, 1],   % 5*X1 +   X2 + 2*X3 - 3*X4 = 1
	     [ 0, 0,-9, 7, 1],   %             - 9*X3 + 7*X4 = 1
	     [ 4, 9, 6,-8, 8],   % 4*X1 + 9*X2 + 6*X3 - 8*X4 = 8
	     [ 5, 8, 1,-4, 8]].  % 5*X1 + 8*X2 +   X3 - 4*X4 = 8
*/
%The output is
%[[5, 1, 2, -3, 1], [0, 0, -9, 7, 1], [4, 9, 6, -8, 8], [5, 8, 1, -4, 8]]
%result = [1, 2, 3, 4]
/*
matrix(Matrix):-
    Matrix=[
	[ 1,1,2,3,4,5,6,7,8,9,9,8,7,6,5,4,3,2,1,0,100 ] ,
	[ 1,1,3,4,5,6,7,8,9,9,8,7,6,5,4,3,2,1,0,0,100 ] ,
	[ 2,3,1,5,6,7,8,9,9,8,7,6,5,4,3,2,1,0,0,1,100 ] ,
	[ 3,4,5,1,7,8,9,9,8,7,6,5,4,3,2,1,0,0,1,2,100 ] ,
	[ 4,5,6,7,1,9,9,8,7,6,5,4,3,2,1,0,0,1,2,3,100 ] ,
	[ 5,6,7,8,9,1,8,7,6,5,4,3,2,1,0,0,1,2,3,4,100 ] ,
	[ 6,7,8,9,9,8,1,6,5,4,3,2,1,0,0,1,2,3,4,5,100 ] ,
	[ 7,8,9,9,8,7,6,1,4,3,2,1,0,0,1,2,3,4,5,6,100 ] ,
	[ 8,9,9,8,7,6,5,4,1,2,1,0,0,1,2,3,4,5,6,7,100 ] ,
	[ 9,9,8,7,6,5,4,3,2,1,0,0,1,2,3,4,5,6,7,8,100 ] ,
	[ 9,8,7,6,5,4,3,2,1,0,1,1,2,3,4,5,6,7,8,9,100 ] ,
	[ 8,7,6,5,4,3,2,1,0,0,1,1,3,4,5,6,7,8,9,9,100 ] ,
	[ 7,6,5,4,3,2,1,0,0,1,2,3,1,5,6,7,8,9,9,8,100 ] ,
	[ 6,5,4,3,2,1,0,0,1,2,3,4,5,1,7,8,9,9,8,7,100 ] ,
	[ 5,4,3,2,1,0,0,1,2,3,4,5,6,7,1,9,9,8,7,6,100 ] ,
	[ 4,3,2,1,0,0,1,2,3,4,5,6,7,8,9,1,8,7,6,5,100 ] ,
	[ 3,2,1,0,0,1,2,3,4,5,6,7,8,9,9,8,1,6,5,4,100 ] ,
	[ 2,1,0,0,1,2,3,4,5,6,7,8,9,9,8,7,6,1,4,3,100 ] ,
	[ 1,0,0,1,2,3,4,5,6,7,8,9,9,8,7,6,5,4,1,2,100 ] ,
	[ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,100 ]].

matrix(Matrix):- %representing a singular set of equations
    Matrix=[
	[ 1 , 1 , 1 , 10 ],
	[ 2 , 2 , 2 , 12 ],
	[ 1 , 2 , 4 ,  6 ]].

matrix(Matrix):-
    Matrix=[
	[ 100,10,1,2.83 ],
	[ 144,12,1,4.51 ],
	[ 225,15,1,8.32 ]].
matrix(Matrix):-
    Matrix=[
	[ 1,1,2,3,4,5,6,7,8,9,9,8,7,6,5,100 ],
	[ 1,1,3,4,5,6,7,8,9,9,8,7,6,5,4,100 ],
	[ 2,3,1,5,6,7,8,9,9,8,7,6,5,4,3,100 ],
	[ 3,4,5,1,7,8,9,9,8,7,6,5,4,3,2,100 ],
	[ 4,5,6,7,1,9,9,8,7,6,5,4,3,2,1,100 ],
	[ 5,6,7,8,9,1,8,7,6,5,4,3,2,1,0,100 ],
	[ 6,7,8,9,9,8,1,6,5,4,3,2,1,0,0,100 ],
	[ 7,8,9,9,8,7,6,1,4,3,2,1,0,0,1,100 ],
	[ 8,9,9,8,7,6,5,4,1,2,1,0,0,1,2,100 ],
	[ 9,9,8,7,6,5,4,3,2,1,0,0,1,2,3,100 ],
	[ 9,8,7,6,5,4,3,2,1,0,1,1,2,3,4,100 ],
	[ 8,7,6,5,4,3,2,1,0,0,1,1,3,4,5,100 ],
	[ 7,6,5,4,3,2,1,0,0,1,2,3,1,5,6,100 ],
	[ 6,5,4,3,2,1,0,0,1,2,3,4,5,1,7,100 ],
	[ 5,4,3,2,1,0,0,1,2,3,4,5,6,7,1,100 ]].
matrix(Matrix):-
    Matrix=[
	[ 1,1,2,3,4,5,6,7,8,9,9,8,100 ],
	[ 1,1,3,4,5,6,7,8,9,9,8,7,100 ],
	[ 2,3,1,5,6,7,8,9,9,8,7,6,100 ], 
	[ 3,4,5,1,7,8,9,9,8,7,6,5,100 ], 
	[ 4,5,6,7,1,9,9,8,7,6,5,4,100 ], 
	[ 5,6,7,8,9,1,8,7,6,5,4,3,100 ], 
	[ 6,7,8,9,9,8,1,6,5,4,3,2,100 ], 
	[ 7,8,9,9,8,7,6,1,4,3,2,1,100 ], 
	[ 8,9,9,8,7,6,5,4,1,2,1,0,100 ], 
	[ 9,9,8,7,6,5,4,3,2,1,0,0,100 ], 
	[ 9,8,7,6,5,4,3,2,1,0,1,1,100 ], 
	[ 8,7,6,5,4,3,2,1,0,0,1,1,100 ]].
matrix(Matrix):-
    Matrix=[
	[ 0,1,2,3,4,5,6,7,8,9,100 ],
	[ 1,2,3,4,5,6,7,8,9,0,100 ],
	[ 2,3,4,5,6,7,8,9,0,1,100 ],
	[ 3,4,5,6,7,8,9,0,1,2,100 ],
	[ 4,5,6,7,8,9,0,1,2,3,100 ],
	[ 5,6,7,8,9,0,1,2,3,4,100 ],
	[ 6,7,8,9,0,1,2,3,4,5,100 ],
	[ 7,8,9,0,1,2,3,4,5,6,100 ],
	[ 8,9,0,1,2,3,4,5,6,7,100 ],
	[ 1,1,1,1,1,1,1,1,1,1,100 ]].
matrix(Matrix):-
    Matrix= [[ 0, 1, 1, -5, -4],
	     [ 0, 0,-2,  1,  3],
	     [ 1,-3, 3,  0,-11],
	     [ 2, 0, 5, -3,-12]].
matrix(Matrix):-
    Matrix= [[ 3, 4,-1,-10], % 3*x1 +  4*x2 + -1*x3 = -10
	     [ 2,-3, 4, 28], % 2*x1 + -3*x2 +  4*x3 =  28
	     [-1, 1, 1,  2]]. %-1*x1 +    x2 +    x3 =   2
*/

/*-------------------------------------------------------------------------*/
linear_multi_equation(Matrix,Result):-              /*     LME v2.3.1      */
   getorder(Matrix,Index0),                         /*      made by        */
   solut(Matrix,[],TriMatrix,Result1,Index0,Index), /*zhuhail@vax.sbu.ac.uk*/
   backsubstitute(TriMatrix,[Result1],Result0),     /* any comment welcome */
   make_in_order(Result0,Index,Result).             /*      19/6/95        */

solut([[H|[T|[]]]],Tem,TriMatrix,Result1,TemIndex,Index):- !,
	Tem=TriMatrix, Result1 is T/H, TemIndex=Index.
solut(Matrix,Tem,TriMatrix,Result1,Index0,Index):-
	changematrix(Matrix,ChangedMatrix,
		     Tem,ChangedTem,Index0,Index1),
	ChangedMatrix =[MainRow|SubMatrix],
	solut1(MainRow,SubMatrix,SubMatrix1),
	drop(SubMatrix1,ReduceMatrix),
	solut(ReduceMatrix,[MainRow|ChangedTem],TriMatrix,Result1,Index1,Index).

solut1(_,[],N):- !, N=[].
solut1(MainRow,[Row|RT],[NewRow|NT]):-
	MainRow=[MainElement|_],
	Row=[LeftElement|_],
	Ratio is LeftElement/MainElement,
	solut2(MainElement,Ratio,MainRow,Row,NewRow),
	solut1(MainRow,RT,NT).

solut2(_,_,[],E,N):- !, E=[], N=[].
solut2(MainElement,Ratio,[TopElement|MT],[Element|T],[NewElement|NT]):-
	NewElement is Element-Ratio*TopElement,
	solut2(MainElement,Ratio,MT,T,NT).

changematrix(Matrix,ChangedMatrix,Tem,ChangedTem,Index0,Index):-
	maximum(Matrix,1,0,1,1,MaxRowNum,MaxColNum),
	change_row(Matrix,MaxRowNum,ChangedRowMatrix),
	change_col(ChangedRowMatrix,MaxColNum,ChangedMatrix),
	change_tri(Tem,MaxColNum,ChangedTem,Index0,Index).

maximum([],_,_,TemRowNum,TemColNum,MaxRowNum,MaxColNum):- !,
   TemRowNum=MaxRowNum, TemColNum=MaxColNum.
maximum([Row|MatrixT],RowNum,Max,TemRowNum,TemColNum,MaxRowNum,MaxColNum):-
   maximum1(Row,RowNum,1,Max,NewM,TemRowNum,TemColNum,MaxRowNum1,MaxColNum1),
   NextRowNum is RowNum+1,
   maximum(MatrixT,NextRowNum,NewM,MaxRowNum1,MaxColNum1,MaxRowNum,MaxColNum).

abs(A,Abs):- A < 0, !, Abs is -A.
abs(A,A).

maximum1([_],_,_,Max,NewM,TemRowNum,TemColNum,MaxRowNum,MaxColNum):- !,
	Max=NewM, TemRowNum=MaxRowNum, TemColNum=MaxColNum.

maximum1([H|T],RowNum,ColNum,Max,NewM,_,_,MaxRowNum,MaxColNum):-
	abs(H,AbsH), Max < AbsH, !,
	Max1 is AbsH, TemRowNum1 is RowNum,
	TemColNum1 is ColNum, NextC is ColNum+1,
  maximum1(T,RowNum,NextC,Max1,NewM,TemRowNum1,TemColNum1,MaxRowNum,MaxColNum).
maximum1([_|T],RowNum,ColNum,Max,NewM,TemRowNum,TemColNum,MaxRowNum,MaxColNum):-
	NextC is ColNum+1,
maximum1(T,RowNum,NextC,Max,NewM,TemRowNum,TemColNum,MaxRowNum,MaxColNum).

change_row(Matrix,1,ChangedMatrix):- !, ChangedMatrix=Matrix.
change_row(Matrix,MaxRowNum,ChangedMatrix):-
	change_row1(Matrix,1,MaxRowNum,NewMatrix,_,_,MainRow),
	NewMatrix=[_|T],
	ChangedMatrix = [MainRow|T].

change_col(Matrix,1,ChangedMatrix):- !, ChangedMatrix=Matrix.
change_col(Matrix,MaxColNum,ChangedMatrix):-
	change_col1(Matrix,MaxColNum,ChangedMatrix).

change_row1([],_,_,N,_,TemR,MainRow):- !,
   N=[], TemR=MainRow.
change_row1([Row|MatrixT],RowNum,MaxRowNum,[_|NT],FirstRow,TemR,MainRow):-
   RowNum = 1, !, NextRowNum is RowNum+1, FirstRow = Row,
	change_row1(MatrixT,NextRowNum,MaxRowNum,NT,FirstRow,TemR,MainRow).
change_row1([Row|MatrixT],RowNum,MaxRowNum,[NewRow|NT],FirstRow,TemR,MainRow):-
   RowNum = MaxRowNum, !, NewRow = FirstRow, TemR = Row, NextRowNum is RowNum+1,
	change_row1(MatrixT,NextRowNum,MaxRowNum,NT,FirstRow,TemR,MainRow).
change_row1([Row|MatrixT],RowNum,MaxRowNum,[NewRow|NT],FirstRow,TemR,MainRow):-
	NewRow = Row, NextRowNum is RowNum+1,
	change_row1(MatrixT,NextRowNum,MaxRowNum,NT,FirstRow,TemR,MainRow).

change_col1([],_,N):- !, N=[].
change_col1([Row|MatrixT],MaxColNum,[NewRow|NT]):-
	change_col2(Row,1,MaxColNum,Row1,_,_,Main),
	Row1 = [_|T],
	NewRow = [Main|T],
	change_col1(MatrixT,MaxColNum,NT).

change_col2([Last],_,_,N,_,TemMain,Main):- !,
	N=[Last], TemMain=Main.
change_col2([H|T],ColNum,MaxColNum,[_|NT],First,TemMain,Main):-
    ColNum = 1, !, NextColNum is ColNum+1, First = H,
	change_col2(T,NextColNum,MaxColNum,NT,First,TemMain,Main).
change_col2([H|T],ColNum,MaxColNum,[NH|NT],First,TemMain,Main):-
    ColNum = MaxColNum, !, NH = First, TemMain = H, NextColNum is ColNum+1,
	change_col2(T,NextColNum,MaxColNum,NT,First,TemMain,Main).
change_col2([H|T],ColNum,MaxColNum,[NH|NT],First,TemMain,Main):-
	NH = H, NextColNum is ColNum+1,
	change_col2(T,NextColNum,MaxColNum,NT,First,TemMain,Main).

change_tri(Tem,1,ChangedTem,Index0,Index):- !,
	Tem=ChangedTem, Index0=Index.
change_tri(Tem,MaxColNum,ChangedTem,Index0,Index):-
	ChangeNum is MaxColNum+1,
	change_tri1(Tem,2,ChangeNum,ChangedTem,MainNum1,ChangeNum1),
	MainNum2 is MainNum1-1,
	ChangeNum2 is ChangeNum1-1,   /*for change vector*/
	change_tri2(Index0,1,MainNum2,ChangeNum2,_,_,Index).

change_tri1([],NextMainNum,NextChangeNum,N,MainNum1,ChangeNum1):- !,
	N=[], NextMainNum=MainNum1, NextChangeNum=ChangeNum1.
change_tri1([Row|MatrixT],MainNum,ChangeNum,[NewRow|NT],MainNum1,ChangeNum1):-
	change_tri2(Row,1,MainNum,ChangeNum,_,_,NewRow),
	NextMainNum is MainNum+1,
	NextChangeNum is ChangeNum+1,
	change_tri1(MatrixT,NextMainNum,NextChangeNum,NT,MainNum1,ChangeNum1).

change_tri2([],_,_,_,_,_,N):- !, N=[].
change_tri2([H|T],Num,MainNum,ChangeNum,MainE,ChangeE,[NH|NT]):-
     Num = MainNum, !, NH = ChangeE, NextNum is Num+1, MainE = H,
	change_tri2(T,NextNum,MainNum,ChangeNum,MainE,ChangeE,NT).
change_tri2([H|T],Num,MainNum,ChangeNum,MainE,ChangeE,[NH|NT]):-
     Num = ChangeNum, !, NH = MainE, NextNum is Num+1, ChangeE = H,
	change_tri2(T,NextNum,MainNum,ChangeNum,MainE,ChangeE,NT).
change_tri2([H|T],Num,MainNum,ChangeNum,MainE,ChangeE,[NH|NT]):-
	NH = H, NextNum is Num+1,
	change_tri2(T,NextNum,MainNum,ChangeNum,MainE,ChangeE,NT).

drop([],R):- !, R=[].
drop([[_|ReduceRow]|T],[ReduceRow|RT]):-
	drop(T,RT).

backsubstitute([],Tem,Result0):- !, Tem=Result0.
backsubstitute([[H|RowT]|MatrixT],Tem,Result0):-
	multiply(RowT,Tem,0,Sum,RightElement),
	Result is (RightElement-Sum)/H,
	backsubstitute(MatrixT,[Result|Tem],Result0).

multiply([H|[]],_,Tem,Sum,RightElement):- !,
	Sum is Tem, RightElement is H.
multiply([H|T],[RH|RT],Tem,Sum,RightElement):-
	NewSum is Tem+H*RH,
	multiply(T,RT,NewSum,Sum,RightElement).

make_in_order(Result0,Index,Result):-
	make_in_order1(Result0,Index,VectorWithNum),
	sort(VectorWithNum,SortVector),
	make_in_order2(SortVector,Result).

make_in_order1([],_,R):- !, R=[].
make_in_order1([H|T],[IH|IT],[IH-H|RT]):-
	make_in_order1(T,IT,RT).

make_in_order2([],R):- !, R=[].
make_in_order2([_-S|T],[S|RT]):-
	make_in_order2(T,RT).

getorder([Row|_],Index0):-
	get1(Row,Index0,1).

get1([],O,_):- !, O=[].
get1([_|T],[Num|OT],Num):-
	NextNum is Num+1,
	get1(T,OT,NextNum).

