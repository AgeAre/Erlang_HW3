%%%-------------------------------------------------------------------
%%% @author agear
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Jun 2019 19:39
%%%-------------------------------------------------------------------
-module(loadBalance).
-behavior(gen_server).
-author("ageare").

%% API
-export([startServers/0, stopServers/0, numberOfRunningFunctions/1, calcFun/3, start_link/1,
init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).



startServers() ->
  sup_LB:start_link().

stopServers() ->
erlang:error(not_implemented).

numberOfRunningFunctions(_Arg0) ->
erlang:error(not_implemented).

calcFun(_Arg0, _Arg1, _Arg2) ->
  erlang:error(not_implemented).

start_link(ServerName) ->
  io:format("@@@@@@@@@@@@bla bla bla@@@@@@@@@@@@@~n"),
  gen_server:start_link({local, ServerName}, ?MODULE, [ServerName], []).

init([ServerName]) ->
  process_flag(trap_exit, true),
  io:format("~p is up",[ServerName]),
  {ok, ServerName, 1000}.





handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.

handle_cast(_Msg, State) ->
  Reply = ok,
  {reply, Reply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldV, State, _Extra) ->
  {ok, State}.