FROM kong:0.12.3-alpine
ADD src /usr/local/share/lua/5.1/kong/plugins/helloworld
