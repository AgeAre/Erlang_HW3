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
  gen_server:start_link({local, ServerName}, ?MODULE, [ServerName], []).

init([ServerName]) ->
  %process_flag(trap_exit, true), %TODO: Not sure if needed in a "one_for_one" mode
  NumOfFunc = 0,
  {ok, {ServerName, NumOfFunc}}.

% Reply will be automatically returned to the caller
handle_call({state}, _From, {ServerName, NumOfFunc}) ->
  Reply = NumOfFunc,
  {reply, Reply, {ServerName, NumOfFunc}}.

handle_cast({calc, SourceOrg, F, MsgRef}, {ServerName, NumOfFunc}) ->
  spawn(fun() -> runFun(ServerName, SourceOrg, F, MsgRef) end),
  {noreply, {ServerName, NumOfFunc + 1}};
  %Ret = F(),
  %io:format("~n~p~n",[Ret]),
  %SourceOrg ! Ret,
  %{noreply, {ServerName, NumOfFunc + 1}};

handle_cast({funDone}, {ServerName, NumOfFunc}) ->
  {noreply, {ServerName, NumOfFunc - 1}}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldV, State, _Extra) ->
  {ok, State}.

runFun(ServerName, SourceOrg, F, MsgRef) ->
  Res = F(),
  io:format("~nThis job is done by ~p~n", [ServerName]),
  SourceOrg ! {MsgRef, Res},
  gen_server:cast(ServerName, {funDone}).
