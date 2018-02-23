FROM scratch

ADD assets/bin /bin
ADD assets/conf /conf
ADD assets/public /public
ADD assets/vendor /vendor

ENTRYPOINT ["/bin/grafana-server"]
