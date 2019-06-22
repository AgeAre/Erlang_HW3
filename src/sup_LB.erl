%%%-------------------------------------------------------------------
%%% @author agear
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 05. Jun 2019 20:42
%%%-------------------------------------------------------------------
-module(sup_LB).
-behavior(supervisor).
-author("ageare").

%% API
-export([start_link/0, init/1]).


start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  Server1 = {
    server1,
    {server, start_link,[server1]},
    permanent,
    2000,
    worker,
    [server]
  },
  Server2 = {
    server2,
    {server, start_link,[server2]},
    permanent,
    2000,
    worker,
    [server]
  },

  Server3 = {
    server3,
    {server, start_link,[server3]},
    permanent,
    2000,
    worker,
    [server]
  },
  {ok, {{one_for_one, 3, 1}, [Server1, Server2, Server3]}}.


