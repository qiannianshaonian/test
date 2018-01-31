%%%-------------------------------------------------------------------
%%% @author cyy
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 下午5:38
%%%-------------------------------------------------------------------
-module(mod_ctl).
-author("cyy").

%% API
-export([
  init/0,
  stop/0
]).

init() ->
  %start_player_sup(),
  %start_listen(),
  %mgo_comm:pool_startup(),
%%  mgo_comm:mc_api_connect(),
%%  start_cow_boy(),
  lager:info("login server init start").

stop() ->
  %cowboy_app:stop(),
  error_logger:info_msg("mod_ctl stop = ~p  ~n", [1]),
  lager:info("login server stop").

%%start_player_sup() ->
%%  ChildSpec = {player_sup, {player_sup, start_link, []},
%%    permanent, 60000, supervisor, [player_sup]},
%%  supervisor:start_child(login_server_sup, ChildSpec).
%%
%%start_listen() ->
%%  {Ip, Port} = app_ctl:get_config(server_addr),
%%  SockOpt = [binary, {packet, 2}, {active, true}, {reuseaddr, true}, {nodelay, true},
%%    {delay_send, false}, {send_timeout, 5000}, {keepalive, true}, {ip, Ip}],
%%  lager:info("start listen : ~p", [Port]),
%%  Res = tcp:start(Port, SockOpt, 10, {supervisor, start_child, [player_sup, []]}, agent),
%%  lager:info("res : ~p", [Res]),
%%  lager:info("tcp listen ok").

%%start_cow_boy()->
%%  {_Ip, Port} = app_ctl:get_config(cowboy_addr),
%%  lager:info("start_cow_boy : ~p", [Port]),
%%  Dispatch = cowboy_router:compile([
%%    {'_', [
%%      {"/", toppage_handler, []}
%%    ]}
%%  ]),
%%  {ok, _} = cowboy:start_clear(http, [{port, Port}], #{
%%    env => #{dispatch => Dispatch}
%%  }).
