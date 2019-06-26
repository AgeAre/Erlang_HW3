-module(test).

-compile(export_all).

start()->
  loadBalance:startServers().

stop()->
  loadBalance:stopServers().

status(Time)->
  io:format("~p:Server 1 is handlling ~p tasks ~n",[Time,loadBalance:numberOfRunningFunctions(1)]),
  io:format("~p:Server 2 is handlling ~p tasks ~n",[Time,loadBalance:numberOfRunningFunctions(2)]),
  io:format("~p:Server 3 is handlling ~p tasks ~n",[Time,loadBalance:numberOfRunningFunctions(3)]).

whereare()->
  io:format("Server 1 pid is: ~p t~n",[whereis(server1)]),
  io:format("Server 2 pid is: ~p t~n",[whereis(server2)]),
  io:format("Server 3 pid is: ~p t~n",[whereis(server3)]).

battle()->
  %compile:file(loadBalance),compile:file(sup_LB),compile:file(server),
  F3 = fun()-> timer:sleep(3),3*3 end,
  F5 = fun()-> timer:sleep(3000),4*4 end,

  %Divide 10 functions:
  whereare(),
  myLoop(F5,10),
  status(fastTest),
  myLoop(F3,3),
  status(sec0),
  timer:sleep(15000),
  status(sec0),
  ok.

myLoop(_F,0)->
  ok;

myLoop(F,Times)->
  loadBalance:calcFun(self(),F,make_ref()),
  myLoop(F,Times-1).

main()->
  start(),
  battle(),
  timer:sleep(5000),
  c:flush(),
  stop(),
  ok_main.


