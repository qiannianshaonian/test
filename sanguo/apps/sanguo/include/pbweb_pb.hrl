-ifndef(PBWEBBATTLESERVERSEARCH_PB_H).
-define(PBWEBBATTLESERVERSEARCH_PB_H, true).
-record(pbwebbattleserversearch, {
    pageindex = erlang:error({required, pageindex}),
    pagesize = erlang:error({required, pagesize}),
    addr,
    state
}).
-endif.

-ifndef(PBWEBBATTLESERVERGET_PB_H).
-define(PBWEBBATTLESERVERGET_PB_H, true).
-record(pbwebbattleserverget, {
    id = erlang:error({required, id})
}).
-endif.

-ifndef(PBWEBBATTLESERVERDEL_PB_H).
-define(PBWEBBATTLESERVERDEL_PB_H, true).
-record(pbwebbattleserverdel, {
    id = erlang:error({required, id})
}).
-endif.

-ifndef(PBWEBBATTLESERVERADD_PB_H).
-define(PBWEBBATTLESERVERADD_PB_H, true).
-record(pbwebbattleserveradd, {
    info = erlang:error({required, info})
}).
-endif.

-ifndef(PBWEBBATTLESERVEREDIT_PB_H).
-define(PBWEBBATTLESERVEREDIT_PB_H, true).
-record(pbwebbattleserveredit, {
    info = erlang:error({required, info})
}).
-endif.

-ifndef(PBWEBBATTLESERVERLIST_PB_H).
-define(PBWEBBATTLESERVERLIST_PB_H, true).
-record(pbwebbattleserverlist, {
    total = erlang:error({required, total}),
    serverlist = []
}).
-endif.

-ifndef(PBWEBBATTLESERVER_PB_H).
-define(PBWEBBATTLESERVER_PB_H, true).
-record(pbwebbattleserver, {
    id,
    addr = erlang:error({required, addr}),
    port = erlang:error({required, port}),
    ts = erlang:error({required, ts}),
    state = erlang:error({required, state}),
    num = erlang:error({required, num})
}).
-endif.

-ifndef(PBWEBROLESEARCH_PB_H).
-define(PBWEBROLESEARCH_PB_H, true).
-record(pbwebrolesearch, {
    pageindex = erlang:error({required, pageindex}),
    pagesize = erlang:error({required, pagesize}),
    rid,
    uid,
    nickname
}).
-endif.

-ifndef(PBWEBROLEGET_PB_H).
-define(PBWEBROLEGET_PB_H, true).
-record(pbwebroleget, {
    rid = erlang:error({required, rid})
}).
-endif.

-ifndef(PBWEBROLEEDIT_PB_H).
-define(PBWEBROLEEDIT_PB_H, true).
-record(pbwebroleedit, {
    info = erlang:error({required, info})
}).
-endif.

-ifndef(PBWEBROLELIST_PB_H).
-define(PBWEBROLELIST_PB_H, true).
-record(pbwebrolelist, {
    total = erlang:error({required, total}),
    datalist = []
}).
-endif.

-ifndef(PBWEBROLE_PB_H).
-define(PBWEBROLE_PB_H, true).
-record(pbwebrole, {
    id = erlang:error({required, id}),
    uid,
    login_times,
    last_login,
    game_time,
    combo,
    combo_max_lose,
    combo_max_win,
    win,
    lose,
    exp,
    icon,
    level,
    location,
    rank,
    score,
    score_hero,
    sign,
    nickname
}).
-endif.

