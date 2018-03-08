FROM scratch

ADD assets/bin /bin
ADD assets/conf /conf
ADD assets/public /public
ADD assets/vendor /vendor
ADD extracted /etc/pki/ca-trust/extracted 
ADD certs /etc/ssl/certs


ENTRYPOINT ["/bin/grafana-server"]
