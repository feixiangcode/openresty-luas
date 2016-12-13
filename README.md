luas
===
1.介绍
---
用lua实现的基于openresty的简单的WEB API框架[其实不算一个框架，只是把多个开源的框架按需合一块便于小项目方便的使用]。(我们实际项目目前都是比较简单的接口,就需要按照不同项目把一些并发高的接口移植到openresty上,大多接口还是使用原来的PHP,所以项目是PHP和lua混编的项目,于是就有了luas)
2.安装
---
当然了,首先安装openresty,这个就不解释了<br>
下载项目放到服务器硬盘上，如：/data/www/lua/;在nginx.conf的http区块加上
```
lua_package_path '/data/www/lua/?.lua;;';
init_by_lua_file '/data/www/lua/init.lua';
```
创建server区块
```
server {
    listen 80;
    server_name www.demo.com;
    charset utf-8;
    error_log   /var/log/openresty/www.demo.com_error.log debug;
    access_log  /var/log/openresty/www.demo.com_access.log;
    index index.html index.php;
    root /data/www/php/;
    set $APP_NAME 'demo';
    location / {
        index index.php index.html index.luaphp;
    }

    location ~ \.php$ {
        default_type text/html;
        lua_code_cache off;
        access_by_lua_file /data/www/lua/demo/main.lua;
        fastcgi_pass   php-fcgi;
        include        fastcgi.conf;
    }
}
```
3.开始
---
####结构
>lua
>>init.lua --nginx启动的时候初始化<br>
>>luas.conf --nginx配置样例<br>
>>luas --框架<br>
>>demo --demo<br>
>>>luas/core --常用的库<br>
>>>luas/utils --工具类<br>
>>>demo/main.lua --项目入口文件<br>
>>>demo/config --项目配置文件夹<br>
>>>demo/components --项目自己的组件<br>
>>>demo/controller --项目控制器<br>

>>>>luas/core/Debug.lua --debug库<br>
>>>>luas/core/Request.lua --请求库<br>
>>>>luas/core/Response.lua --响应库<br>
>>>>luas/core/Route.lua --路由库<br>
>>>>luas/core/SMysql.lua --mysql链接池<br>
>>>>luas/core/SRedis.lua --redis链接池<br>

>>>>luas/utils/IO.lua --IO工具<br>
>>>>luas/utils/String.lua --字符串工具<br>
>>>>luas/utils/Table.lua --TABLE工具<br>
>>>>luas/utils/Utils.lua --常用的工具<br>

>>>>demo/config/config.lua --项目配置文件<br>
>>>>demo/controller/TestController.lua --项目测试控制器<br>
>>>>demo/controller/RedisController.lua --项目测试redis<br>
>>>>demo/components/hello.lua --项目测试组件<br>

####注意
#####文件夹名称禁止使用. 它会影响引入的路径
#####nginx启动的时候重写require,项目里面请使用include，必须设置APP_NAME是lua中的项目的文件夹名称,这样才能引入的时候像PHP的项目一样直接include
#####原来的PHP项目使用的是YII，所以结构上跟YII类似。而且放在了access阶段，如果lua没有实现，就直接执行PHP阶段。实现LUA PHP混编的目的
#####项目的路由是跟YII类似的。如果路由无法满足需求，在main.lua里面重写，include自有的route
