%%%-------------------------------------------------------------------
%%% @author agear
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Jun 2019 19:39
%%%-------------------------------------------------------------------
-module(loadBalance).
%%-behavior(gen_server).
-author("ageare").

%% API
-export([startServers/0, stopServers/0,
  numberOfRunningFunctions/1, calcFun/3]).



startServers() ->
  sup_LB:start_link().

%TODO: Should we kill loadBalance?
stopServers() ->
  exit(whereis(sup_LB), shutdown).


numberOfRunningFunctions(ServerName) ->
  case ServerName of
    1 -> gen_server:call(server1,{state});
    2 -> gen_server:call(server2,{state});
    3 -> gen_server:call(server3,{state})
  end.


calcFun(Pid, F, MsgRef) ->
  LeastBusyServ = getLeastBusyServ(),
  gen_server:cast(LeastBusyServ, {calc, Pid, F, MsgRef}),
  ok.

getLeastBusyServ() ->
  Srv1 = numberOfRunningFunctions(1),
  Srv2 = numberOfRunningFunctions(2),
  Srv3 = numberOfRunningFunctions(3),
  case Srv1 =< Srv2 of
    true -> case Srv1 =< Srv3 of
              true -> server1;
              false -> server3
            end;
    false -> case Srv2 =< Srv3 of
              true -> server2;
              false -> server3
            end
  end.