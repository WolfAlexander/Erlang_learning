-module(hello_test).
-author("Alexander").

-export([world/0]).
-export([test/1]).

world()->
  "Hello world ~n".

test(N)->
  N + 5.

