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
    {loadBalance, start_link,[server1]},
    permanent,
    2000,
    worker,
    [loadBalance]
  },
  Server2 = {
    server2,
    {loadBalance, start_link,[server2]},
    permanent,
    2000,
    worker,
    [loadBalance]
  },

  Server3 = {
    server3,
    {loadBalance, start_link,[server3]},
    permanent,
    2000,
    worker,
    [loadBalance]
  },
  {ok, {{rest_for_one, 1, 60000}, [Server1, Server2, Server3]}}.


