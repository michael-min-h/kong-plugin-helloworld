docker build . -t kong:test

docker volume create kong-database
docker volume create kong

docker run -d \
    --name kong-database \
    -p 5432:5432 \
    -e "POSTGRES_USER=kong" \
    -e "POSTGRES_DB=kong" \
    -e "POSTGRES_PASSWORD=kong" \
    -v kong-database:/var/lib/postgresql/data \
    postgres:10.3

docker run --rm \
    --link kong-database:kong-database \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=kong-database" \
    -e "KONG_PG_PASSWORD=kong" \
    kong kong migrations up

docker run -d --name kong \
    --link kong-database:kong-database \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=kong-database" \
    -e "KONG_PG_PASSWORD=kong" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
    -e "KONG_ADMIN_LISTEN_SSL=0.0.0.0:8444" \
    -v "kong:/usr/local/kong" \
    -v "$(pwd)/kong.conf:/etc/kong/kong.conf:ro" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    kong:test

#create api
curl -i -X POST \
    --url http://localhost:8001/apis/ \
    --data 'name=testapi' \
    --data 'upstream_url=https://www.baidu.com/' \
    -d 'uris=/test'

#enable plugin
curl -X POST http://localhost:8001/apis/testapi/plugins \
    --data "name=helloworld"

#test
curl http://localhost:8000/test

#check result
#docker exec -it kong /bin/sh
#cd /usr/local/kong/logs
#cat error.log