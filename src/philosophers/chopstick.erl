%%%-------------------------------------------------------------------
%%% @author Alexander
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. feb 2016 12:05
%%%-------------------------------------------------------------------
-module(chopstick).
-author("Alexander").

%% API
-export([start/0, request/2, return/1, quit/1]).

%% Creates process and gives it available state
start()->
  spawn_link(fun() -> available() end).

%% Requests stick
request(Stick, Timeout) ->
  Stick ! {request, self()},
  receive
    granted -> ok
  after Timeout ->
    no
  end.

%% Returns the stick back
return(Stick) ->
  Stick ! return.

%%  Closes process
quit(Stick) ->
  Stick ! quit.

available()->
   receive
     {request, From} ->
       From ! granted,
       %io:format("Chockstick granted to ~w~n", [From]),
       gone();
     quit ->
       %io:format("Quiting available~n", []),
       ok
   end.

gone()->
  receive
    return ->
      %io:format("Returning chopstick~n", []),
      available();
    quit ->
      %io:format("Quiting gone~n", []),
      ok
  end.