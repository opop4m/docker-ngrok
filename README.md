# DOCKER NGROK IMAGE



## RUN
* you must mount your folder (E.g `/data/ngrok`) to container `/myfiles`
* if it is the first run, it will generate the binaries file and CA in your floder `/data/ngrok`

```linux
docker run -idt --name ngrok-server \
-v /data/ngrok:/myfiles \
-e DOMAIN='tunnel.hteen.cn' hteen/ngrok /bin/sh /server.sh
```
