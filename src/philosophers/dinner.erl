%%%-------------------------------------------------------------------
%%% @author Alexander
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. feb 2016 16:55
%%%-------------------------------------------------------------------
-module(dinner).
-author("Alexander").

%% API
-export([start/0]).

start() ->
  spawn(fun() -> init() end).

init() ->
  C1 = chopstick:start(),
  C2 = chopstick:start(),
  C3 = chopstick:start(),
  C4 = chopstick:start(),
  C5 = chopstick:start(),
  Ctrl = self(),
  philosopher:start(5, C1, C2, "P1", Ctrl),
  philosopher:start(5, C2, C3, "P2", Ctrl),
  philosopher:start(5, C3, C4, "P3", Ctrl),
  philosopher:start(5, C4, C5, "P4", Ctrl),
  philosopher:start(5, C5, C1, "P5", Ctrl),
  wait(5, [C1, C2, C3, C4, C5]).

wait(0, Chopsticks) ->
  lists:foreach(fun(C) -> chopstick:quit(C) end, Chopsticks);
wait(N, Chopsticks) ->
  receive
    done ->
      wait(N-1, Chopsticks);
    abort ->
      exit(abort)
  end.