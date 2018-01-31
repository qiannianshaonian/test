%%%-------------------------------------------------------------------
%%% @author xianyu
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十一月 2017 11:55
%%%-------------------------------------------------------------------
-module(proxy_web).
-author("xianyu").
-include("protocal_http.hrl").
%%-include("server_list_pb.hrl").
%% API
-export([
  start/1,
  loop/2,
  make_pb_send/4
  ]).
start(Options) ->
  {DocRoot, Options1} = get_option(docroot, Options),
  lager:info("Options1  :~p~n", [Options1]),
  Loop =
    fun(Req) ->
      ?MODULE:loop(Req, DocRoot)
    end,
  mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

loop(Req, _DocRoot) ->
  try
%%      "/" ++ ProtoBuffId = Req:get(path),
      [{PostData,_}] = Req:parse_post(),

      lager:info("PostData  :~p~n", [PostData]),
      <<Pm:16/little,Ps:16/little,_BufferLen:32/little,BindData/binary>> = iolist_to_binary(PostData),
      RetValue =
        case Pm of
         ?P_H_SERVER ->
            http_mod_login:excute(Ps,BindData);
         ?P_H_MAP ->
            h_mod_map:excute(Ps,BindData);
         ?P_H_LOG ->
            h_mod_log:excute(Ps,BindData);
         ?P_H_WEB ->
            h_mod_web:excute(Ps,BindData);
          ?P_H_ROLE ->
            h_mod_role:excute(Ps,BindData);
          _ ->
            lager:info("excute erro Pm:~p~n", [Pm]),
            <<"erro Pm">>
      end,
      lager:info("RetValue=~p", [RetValue]),
      Req:respond({200, [], RetValue})
  catch
    throw:{custom, Reason} ->
%%      PostData = Req:parse_post(),
%%      GetData = Req:parse_qs(),
%%      lager:info("post_data=~p", [PostData]),
%%      lager:info("get_data=~p", [GetData]),
      lager:info(" callback fail reason=~p", [Reason]),
      Req:respond({500, [], comm:to_list(Reason)});
    Type:What ->
      lager:info("exception type=~p, what=~p, stack=~p", [Type, What, erlang:get_stacktrace()]),
      Req:respond({500, [], ""})
  end.

%%proto_buff_check(?PS_H_WEB_BSERVER) ->
%%  ServerList = test:get_server_list(),
%%  RRl =encode_serverlist(ServerList),
%%  BLen = binary:referenced_byte_size(RRl),
%%  <<?P_H_SERVER:16/little, ?PS_H_WEB_BSERVER:16/little, BLen:32/little, RRl/binary>>.
%%
%%
%%encode_serverlist(ServerList)->
%%  SSL = serverlist_pb(ServerList),
%%  lager:info("SSL=~p", [SSL]),
%%  Result = server_list_pb:encode_serverlist(SSL),
%%  lager:info("Result=~p", [Result]),
%%  server_list_pb:decode_serverlist(list_to_binary(Result)),
%%  iolist_to_binary(Result).
%%
%%serverlist_pb(ServerList)->
%%  SL = lists:foldl(fun([ID,ST,IP,Port,FE,FD,SN,RES|_],TempList)->
%%    [#server{id=ID, status=ST,ip=IP,port=Port,flag_enable=FE,flag_disable = FD,server_name = SN,resource = RES}|TempList]
%%                   end,[],ServerList),
%%  #serverlist{server=SL}.




get_option(Option, Options) ->

  {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.

make_pb_send(PB,Group, Cmd, R) ->
  Bin = iolist_to_binary(PB:encode(R)),
  BLen = binary:referenced_byte_size(Bin),
  <<Group:16/little,Cmd:16/little,BLen:32/little,Bin/binary>>.