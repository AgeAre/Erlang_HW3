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

stopServers() ->
  erlang:error(not_implemented).

numberOfRunningFunctions(ServNum) ->
  case ServNum of
    1 -> gen_server:call(server1,{state});
    2 -> gen_server:call(server2,{state});
    3 -> gen_server:call(server3,{state});
    Else -> {invalid_number}
  end.

calcFun(Pid, F, MsgRef) ->
  %gen_server:cast(Server1, ),
  VacantServer = 2,%getVacantServer(),
  case VacantServer of
    1 -> whereis(server1) ! {Pid, F, MsgRef};
    2 -> whereis(server2) ! {Pid, F, MsgRef};
    3 -> whereis(server3) ! {Pid, F, MsgRef}
  end,
  ok.

%%getState() ->
%%  io:format("~n @@@@@@@@@@@@@@@@@@@@@@@@@@@@ ~n"),
%%  gen_server:call(server1,{state}),
%%  gen_server:call(server2,{state}),
%%  gen_server:call(server3,{state}).
%%%%  io:format("~nThe state is ~p~n",[State]).

getVacantServer() ->
  Srv1 = numberOfRunningFunctions(1),
  Srv2 = numberOfRunningFunctions(2),
  Srv3 = numberOfRunningFunctions(3),
  case Srv1 < Srv2 of
    true -> case Srv1 < Srv3 of
              true -> 1;
              false -> 3
            end;
    false -> case Srv2 < Srv3 of
              true -> 2;
              false -> 3
            end
  end.