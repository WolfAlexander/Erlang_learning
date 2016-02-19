%%%-------------------------------------------------------------------
%%% @author Alexander
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. feb 2016 13:52
%%%-------------------------------------------------------------------
-module(philosopher).
-author("Alexander").

%% API
-export([start/5]).

%% Creates process and diving it a state
%% @param Hungry - how many times
start(Hungry, Left, Right, Name, Ctrl)->
  spawn_link(fun()-> dreaming(Hungry, Left, Right, Name, Ctrl) end).

%% Philosopher is dreaming random amount of time and then wants to eat
dreaming(Hungry, Left, Right, Name, Ctrl)->
  io:format("~s is dreaming~n", [Name]),
  sleep(rand:uniform(2000), 3000),
  io:format("~s wants to eat~n", [Name]),
  waiting(Hungry, Left, Right, Name, Ctrl).

%% Philosopher waits for available chopsticks
%% If both chopsticks are not available too long than
%% drop an acquired stick, sleep for 10-15 milliseconds and try again
%% In case of success starts eating
waiting(Hungry, Left, Right, Name, Ctrl) ->
  io:format("~s waits for chopsticks: ~w and ~w~n", [Name, Left, Right]),
  L = chopstick:request(Left, 500),
  R = chopstick:request(Right, 500),
  GotL = L == ok,
  GotR = R == ok,
  GotAll = GotL == GotR,
  case GotAll of
    true -> eating(Hungry, Left, Right, Name, Ctrl);
    false -> case GotL of
               true -> chopstick:return(Left);
               false -> false
             end,
            case GotR of
              true -> chopstick:return(Right);
              false -> false
            end,
            sleep(10, 5),
            waiting(Hungry, Left, Right, Name, Ctrl)
  end.

%% Philosopher eats for random time and returns chopsticks
%% and decreases number of time that philosopher have to eat
%% If philosopher eat
eating(Hungry, Left, Right, Name, Ctrl) ->
  io:format("~s is eating~n", [Name]),
  sleep(random:uniform(1000), 1600),
  chopstick:return(Left),
  chopstick:return(Right),
  io:format("~s returns sticks ~w and ~w~n", [Name, Left, Right]),
  H = Hungry - 1,
  if
    (H == 0) ->
      io:format("~s is done~n", [Name]),
      Ctrl ! done;
    true -> dreaming(H, Left, Right, Name, Ctrl)
  end.

%% Sleeps for random amount of time
sleep(T, D) ->
  timer:sleep(T + rand:uniform(D)).