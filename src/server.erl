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
  State = 0,
  %process_flag(trap_exit, true),
  io:format("~n~p is up~n",[ServerName]),
  {ok, {ServerName, State}}.





handle_call({state}, _From, {Name, State}) ->
  Reply = State,
  %io:format("~nThe state is ~p~n",[State]),
%%  io:format("~n @@@@@@@@@@@@@@~p, ~p, ~p@@@@@@@@@@@@@@@@ ~n",[Name, _From, State]),
%%  gen_server:cast(server2, )
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

