%%%-------------------------------------------------------------------
%%% @author agear
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2019 21:25
%%%-------------------------------------------------------------------
-module(server).
-behavior(gen_server).
-author("ageare").

%% API
-export([start_link/1, init/1, handle_call/3, handle_cast/2,
  handle_info/2, terminate/2, code_change/3]).

start_link(ServerName) ->
  io:format("~n@@@@@@@@@@@@ a server was started @@@@@@@@@@@@@~n"),
  gen_server:start_link({local, ServerName}, ?MODULE, [ServerName], []).

init([ServerName]) ->
  process_flag(trap_exit, true),
  case ServerName of
    server1 -> State = 5;
    server2 -> State = 4;
    server3 -> State = 6
  end,
  io:format("~n~p is up~n",[ServerName]),
  {ok, {ServerName, State}}.

% Reply will be automatically returned to the caller
handle_call({state}, _From, {ServName, NumOfFunc}) ->
  Reply = NumOfFunc,
  {reply, Reply, {ServName, NumOfFunc}}.

handle_cast({calc, SourceOrg, F, MsgRef}, {ServName, NumOfFunc}) ->
  spawn(fun() -> runFun(ServName, SourceOrg, F, MsgRef) end),
  {noreply, {ServName, NumOfFunc + 1}};

handle_cast({funDone}, {ServName, NumOfFunc}) ->
  {noreply, {ServName, NumOfFunc - 1}}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldV, State, _Extra) ->
  {ok, State}.

runFun(ServName, SourceOrg, F, MsgRef) ->
  Res = F(),
  io:format("Source Pid is ~p~n", [SourceOrg]),
  SourceOrg ! {MsgRef, Res},
  gen_server:cast(ServName, {funDone}).
