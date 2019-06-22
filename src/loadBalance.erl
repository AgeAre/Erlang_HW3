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

%TODO: Still not working properly
stopServers() ->
  gen_server:stop(server1),
  gen_server:stop(server2),
  gen_server:stop(server3).

numberOfRunningFunctions(ServNum) ->
  case ServNum of
    1 -> gen_server:call(server1,{state});
    2 -> gen_server:call(server2,{state});
    3 -> gen_server:call(server3,{state});
    Else -> { invalid_number }
  end.

calcFun(Pid, F, MsgRef) ->
  LeastBusyServ = getLeastBusyServ(),
  gen_server:cast(LeastBusyServ, {calc, Pid, F, MsgRef}),
%%  case LeastBusyServ of
%%    server1 -> server1 ! {Pid, F, MsgRef};
%%    server2 -> server2 ! {Pid, F, MsgRef};
%%    server3 -> server3 ! {Pid, F, MsgRef}
%%  end,
  ok.

getLeastBusyServ() ->
  Srv1 = numberOfRunningFunctions(1),
  Srv2 = numberOfRunningFunctions(2),
  Srv3 = numberOfRunningFunctions(3),
  case Srv1 < Srv2 of
    true -> case Srv1 < Srv3 of
              true -> server1;
              false -> server3
            end;
    false -> case Srv2 < Srv3 of
              true -> server2;
              false -> server3
            end
  end.