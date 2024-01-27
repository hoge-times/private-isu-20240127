SHELL=/bin/bash
.PHONY: bn
bn:
	make re
	/home/isucon/bench run --enable-ssl

# アプリ､nginx､mysqlの再起動
.PHONY: re
re:
	make arestart
	make nrestart
	make mrestart

# アプリの再起動
.PHONY: arestart
arestart:
	cd golang && make all
	sudo systemctl restart isu-go.service
	sudo systemctl status isu-go.service

# nginxの再起動
.PHONY: nrestart
nrestart:
	sudo rm /var/log/nginx/access.log
	sudo systemctl reload nginx
	sudo systemctl status nginx

# mysqlの再起動
.PHONY: mrestart
mrestart:
	now=`date +%Y%m%d-%H%M%S`&& sudo mv /var/log/mysql/slow.log /var/log/mysql/slow.log.$now
	sudo mysqladmin flush-logs
	sudo systemctl restart mysql
	sudo systemctl status mysql

# アプリのログを見る
.PHONY: nalp
nalp:
	sudo cat /var/log/nginx/access.log | alp ltsv -m "/image/\d+.(jpg|png)","/posts/\d+","/\@\w+" --sort=sum --reverse --filters 'Time > TimeAgo("5m")'

# mysqlのslowlogを見る
.PHONY: pt 
pt:
	sudo pt-query-digest /var/log/mysql/slow.log
