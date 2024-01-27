SHELL=/bin/bash
.PHONY: bn
bn:
	make nrestart
	make mrestart
	make arestart
	/home/isucon/bench run --enable-ssl

.PHONY: arestart
arestart:
	cd golang && make all
	sudo systemctl restart isu-go.service
	sudo systemctl status isu-go.service

.PHONY: nrestart
nrestart:
	sudo rm /var/log/nginx/access.log
	sudo systemctl reload nginx
	sudo systemctl status nginx

.PHONY: mrestart
mrestart:
	now=`date +%Y%m%d-%H%M%S`&& sudo mv /var/log/mysql/slow.log /var/log/mysql/slow.log.$now
	sudo mysqladmin flush-logs
	sudo systemctl mysql restart
	sudo systemctl status mysql

.PHONY: nalp
nalp:
	alp --sum -r -f /var/log/nginx/access.log --aggregates='/api/estate/[0-9]+,/api/chair/[0-9]+,/api/recommended_estate/[0-9]+,/api/chair/buy/[0-9]+,/api/estate/req_doc/[0-9]+'

.PHONY: pt 
pt:
	sudo pt-query-digest /var/log/mysql/slow.log
