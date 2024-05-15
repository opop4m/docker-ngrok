FROM golang:1.17

RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends ca-certificates curl
# RUN git clone https://github.com/tutumcloud/ngrok.git /ngrok
RUN git clone https://github.com/ngrox-io/ngrox.git --depth=1 /ngrok

ADD *.sh /

ENV DOMAIN **None**
ENV MY_FILES /myfiles
ENV TUNNEL_ADDR :4443
ENV HTTP_ADDR :80
ENV HTTPS_ADDR :443

EXPOSE 4443
EXPOSE 80
EXPOSE 443

CMD /bin/sh
