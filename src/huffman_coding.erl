%%%-------------------------------------------------------------------
%%% @author Alexander
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. feb 2016 12:19
%%%-------------------------------------------------------------------
-module(huffman_coding).
-author("Alexander").
-import(ovning1, [msort/1, pack/1, number/1, reverse/1]).
%% API
-compile(export_all).

sample()-> "the quick brown fox jumps over the lazy dog
      this is a sample text that we will use when we build
      up a table we will only handle lower case letters and
      no punctuation symbols the frequency will of course not
      represent english but it is probably not that far off".

text() -> "this is something that we should encode".

test()->
  Tree = huffman(freq(sample())),
  Table =  encode_table(Tree),
  Text = text(),
  Seq = encode(Text, Table),
  Text = decode(Seq, Table).

%% Returns a tree
tree(Sample) ->
  Freq = freq(Sample),
  huffman(Freq).

%% Frequency List - how frequent every letter is used
freq(L)->
  PL = pack(L),
  freq(PL, []).

freq([], A) -> reverse(A);
freq([H|T], A)->
  freq(T, [{hd(H), number(H)}|A]).

%% Huffman tree - tree of symbols
huffman([{H,_}|[]]) -> H;
huffman(L)->
  [{C0, F0}, {C1, F1} | T] = lists:keysort(2, L),
  huffman([{{C0, C1}, F0 + F1}|T]).

%% Encode table - different symbols gets their codes
encode_table({L, R}) ->
  encode_table(L, [0]) ++ encode_table(R, [1]).

encode_table({L, R}, Code) ->
  encode_table(L, [0|Code]) ++ encode_table(R, [1|Code]);
encode_table(Symbol, Code)-> [{Symbol, reverse(Code)}].

%% Encode text
encode(Text, Table) ->
  encode(Text, Table, []).

encode([], _, R)-> lists:append(R);
encode([H|T], Table, R)->
  encode(T, Table, [getCodeBySymbol(H, Table)|R]).

%% Get code of the symbol in the table
getCodeBySymbol(_, []) -> not_found;
getCodeBySymbol(H, [{Value, Code}|T])->
  if
    (H == Value) -> Code;
    true -> getCodeBySymbol(H, T)
  end.


%% Decode encoded text
decode([], _)-> [];
decode(Seq, Table) ->
  decode(Seq, Table, []).

decode([], _, R) -> string:concat(R, "");
decode(Seq, Table, R)->
  {Char, Rest} = decode_char(Seq, 1, Table),
  decode(Rest, Table, [Char|R]).

decode_char(Seq, N, Table) ->
  {Code, Rest} = lists:split(N, Seq),
  case lists:keyfind(Code, 2, Table) of
    {Char, _} -> {Char, Rest};
    false ->
      decode_char(Seq, N+1, Table)
  end.

%% Returns symbol from table by given code
getSymbolByCode(_, []) -> not_found;
getSymbolByCode(H, [{Value, Code}|T]) ->
  {C, _} = string:to_integer(lists:concat(Code)),
  if
    (H == C) -> Value;
    true -> getSymbolByCode(H, T)
  end.