%%%-------------------------------------------------------------------
%%% @author xianyu
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十一月 2017 11:47
%%%-------------------------------------------------------------------
-module(proxy_web_sup).
-author("xianyu").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
  {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
  lager:info("Http.......~p~n",[1]),
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
  {ok, {SupFlags :: {RestartStrategy :: supervisor:strategy(),
    MaxR :: non_neg_integer(), MaxT :: non_neg_integer()},
    [ChildSpec :: supervisor:child_spec()]
  }} |
  ignore |
  {error, Reason :: term()}).
init([]) ->

%%  ListenIp = "10.20.20.72",
%%  ListenPort = 20000,
  ListenPort=app_ctl:get_config(listen_port),
  %%ipstr_to_v4(ListenIp)
  Http = web_specs(proxy_web,any , ListenPort),
  lager:info("Http.......~p~n",[Http]),
  ProxyOrderMgr =
    {proxy_web_srv,
      {proxy_web_srv, start_link, []},
      permanent,
      5000,
      worker,
      [proxy_web_srv]},
  {ok,
    {
      {one_for_one, 10, 10},
      [ProxyOrderMgr, Http]
    }
  }.

%%ipstr_to_v4(IpStr) when is_list(IpStr) ->
%%  [V1, V2, V3, V4] = string:tokens(IpStr, "."),
%%  {list_to_integer(V1), list_to_integer(V2), list_to_integer(V3), list_to_integer(V4)}.

web_specs(Mod, ListenIp, Port) ->
  WebConfig = [{ip, ListenIp},
    {port, Port},
    {nodelay, true},
    {docroot, dd_http_deps:local_path(["priv", "www"])}],
  {Mod,
    {Mod, start, [WebConfig]},
    permanent, 5000, worker, dynamic}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
