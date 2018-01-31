%HTTP主协议
-define(P_H_SERVER, 1).%服务器相关
-define(P_H_MAP, 15).%地图相关
-define(P_H_LOG, 16).%地图相关


-define(P_H_WEB, 1001).%web相关请求
-define(P_H_ROLE, 1002).%角色相关

%HTTP子协议
%服务器相关
-define(PS_H_SERVER_GETLIST, 1).%登录
-define(PS_H_LOGIN_XIANYU, 4).%咸鱼SDK登录

-define(PS_H_MAP_REPLAY, 6).%获取录像
-define(PS_H_MAP_REPLAY_LIST, 9).%获取录像列表

-define(PS_H_LOG_SYNC, 1).%上报同步出错日志
-define(PS_H_LOG_GET, 2).%获取指定比赛上报信息

%web相关请求
-define(PS_H_WEB_BSERVER, 1).%获取战斗服列表
-define(PS_H_WEB_BSERVER_GET, 2).%获取
-define(PS_H_WEB_BSERVER_DEL, 3).%删除
-define(PS_H_WEB_BSERVER_ADD, 4).%增加
-define(PS_H_WEB_BSERVER_EDIT, 5).%改

%%角色相关
-define(PS_H_WEB_ROLE_LOOK_UP, 1). %%查找角色
-define(PS_H_WEB_ROLE_GET_INFO, 2). %%获取角色
-define(PS_H_WEB_ROLE_EDIT_INFO, 3). %%修改角色