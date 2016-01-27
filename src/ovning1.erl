%%%-------------------------------------------------------------------
%%% @author Alexander - WolfAlexander
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% Practice 1 - course in ID1019 Programming II at KTH
%%% @end
%%% Created : 20. jan 2016 08:10
%%%-------------------------------------------------------------------
-module(ovning1).
-author("Alexander").

%% API
-export([double/1]).
-export([convertToCelsius/1]).
-export([area/1]).
-export([product/2]).
-export([expFirst/2]).
-export([expSecond/2]).
-export([nth/2]).
-export([number/1]).
-export([sum/1]).
-export([duplicate/1]).
-export([duplicates/1]).
-export([unique/1]).
-export([reverse/1]).
-export([pack/1]).
-export([isort/1]).
-export([msort/1]).
-export([qsort/1]).
-export([binaryCodingWay0/1]).
-export([binaryCodingWay1/1]).

%% Just returns entered value
double(N)->
  N.

%% Converts Fahrenheit to Celsius
convertToCelsius(F)->
  (F-32)/1.8.

%% Evaluates area for different geometrical shapes
area({rectangle, A, B})->
  A*B;
area({square, A})->
  area({rectangle, A, A});
area({circle, A})->
  pi*A*A;
area(_)->
  'Error! Invalid object!'.

%% Calculates product only by addition
product(M, N)->
  case N of
    0-> 0;
    _ -> M + product(M, N-1)
  end.

%% Evaluates exponentiation by addition, subtraction and product function
expFirst(X, Y)->
  case Y of
    0-> 1;
    1-> X;
    _ -> product(X, expFirst(X, Y-1))
  end.

%% Evaluates exponentiation by applying following rules:
%% X raised to 1 is X
%% X raised to y, if y is even, is x raised to y/2 multiplied by itself
%% X raised to y, if y is idd, is x raised to (n-1) multiplied by x
expSecond(X,Y)->
  case Y of
    1-> X;
    _ -> if
           (Y rem 2 == 0) -> expSecond(X, Y div 2) * expSecond(X, Y div 2);
           (Y rem 2 =/= 0) -> X * expSecond(X, Y-1);
           true -> error
         end
  end.

%% Returns the N't element of the list L
nth(N, [H|Tail])->
  case N of
    1-> H;
    _-> nth(N-1, Tail)
  end.

%% Returns the number of elements in the list L
number(L)->
  case L of
    [] -> 0;
    _ -> number(L, 1)
  end.

number([_|T], N)->
  case T of
    []->N;
    _-> number(T, N+1)
  end.

%% Returns sum of all elements in the list L if they are integers
sum(L)->
  sum(L, 0).

sum([H|T], S) when is_integer(H)->
  case T of
    []->S+H;
    _->sum(T, H+S)
  end.

%% Return a list where all elements are duplicated
duplicate(L)->
  duplicate(L, []).

duplicate([], A) -> reverse(A);
duplicate([H|T], A)->
  duplicate(T, [H|[H|A]]).

%% Returns a list of element that are duplicated in the list L
duplicates(L)->
  duplicates(L, []).

duplicates([], A) -> A;
duplicates([H|T], A)->
  case isAMemberOf(H,T) of
    true -> duplicates(T, insertUnique(H, A));
    false -> duplicates(T, A)
  end.

%% Checks if list contains element E
isAMemberOf(_, []) -> false;
isAMemberOf(E, [H|T]) ->
  if
    (E /= H) -> isAMemberOf(E, T);
    true -> true
  end.

%% Returns a list unique of elements in list L
unique(L)->
  unique(L, []).

unique([],A) -> A;
unique([H|T], A)->
  unique(T, insertUnique(H,A)).

%% Inserts element E in list L if element E does not exists in L
insertUnique(E, L)->
  case isAMemberOf(E, L) of
    true -> L;
    false -> [E|L]
  end.

%% Returns list in reverse order
reverse(L)->
  reverse(L, []).

reverse([], A) -> A;
reverse([H|T], A)->
  reverse(T, [H|A]).

%% Returns a list containing lists of equal elements
%% Input: [a,a,b,c,b,a,c] -> Output: [[a,a,a],[b],[c,c]]
pack(L) -> pack(L, []).

pack([], A) -> A;
pack(L, A) ->
  Elements = unique(L),
  no_done.

%% Insertion sort
isort(L) ->
  isort(L, []).

isort([], S) -> S;
isort([H|T], S) ->
  isort(T, insert(H, S)).

insert(E, []) -> [E];
insert(E, [H|T])->
  if
    (E > H) -> [H|insert(E, T)];
    true -> [E|[H|T]]
  end.


%% Merge sort
msort([])->[];
msort([H])-> [H];
msort(L)->
  {A, B} = msplit(L, [], []),
  merge(msort(A), msort(B)).

msplit([], A, B)-> {reverse(A), reverse(B)};
msplit([H|T], A, B)->
  if
    (length(A) > (length(T)+length(A))/2) -> msplit(T, A, [H|B]);
    true -> msplit(T, [H|A], B)
  end.

merge(A, []) -> A;
merge([], B) -> B;
merge([H0|T0], [H1|T1])->
  if
    (H0 > H1) -> [H1 | merge([H0|T0], T1)];
    true -> [H0 | merge(T0, [H1|T1])]
  end.


%% Quick sort
qsort([]) -> [];
qsort([H]) -> [H];
qsort([P|T]) ->
  {A, B} = qsplit(T, P, [], []),
  SmallSorted = qsort(A),
  LargeSorted = qsort(B),
  SmallSorted ++ [P] ++ LargeSorted.

qsplit([], _, A, B)-> {reverse(A), reverse(B)};
qsplit([H|T], P, A, B) when H > P ->
  qsplit(T, P, A, [H|B]);
qsplit([H|T], P, A, B) when H =< P ->
  qsplit(T, P, [H|A], B).


%% Binary coding - convert integer to binary representation of it in list format
%% First approach - division and reminder
binaryCodingWay0(I)->
  binaryCodingWay0(I, []).

binaryCodingWay0(0, L) -> [0|L];
binaryCodingWay0(1, L) -> [1|L];
binaryCodingWay0(I,L)->
  binaryCodingWay0(I div 2, [I rem 2| L]).

%% Binary coding - convert integer to binary representation of it in list format
%% Second approach - powers of 2
binaryCodingWay1(I)->
  binaryCodingWay1(I, [] , 0).

binaryCodingWay1(I, L, Rem)->
  not_done_yet.


findGreatestPowerOf2(I, E)->
  Temp = expFirst(2, E),
  if
    (I - Temp =< 0) -> E;
    true -> findGreatestPowerOf2(I, E+1)
  end.