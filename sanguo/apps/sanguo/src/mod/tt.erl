%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 十二月 2017 17:12
%%%-------------------------------------------------------------------
-module(tt).
-author("Administrator").

%% API
-export([test/0]).
test() ->
  {ok, Socket} = gen_tcp:connect('127.0.0.1', 8041, [binary,{packet,4}]),
  loop(Socket ).

loop(Socket) ->
  lager:info("Bin111:~p~n", [ 1111]),
  gen_tcp:send(Socket, list_to_binary("1111111111111")),

  receive
    {tcp, Socket, Bin} ->
      lager:info("Bin:~p~n", [ Bin]);
    Any ->
      lager:info("Any~p~n",[Any])
  end.