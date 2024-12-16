deploy:
	scp -r build/web root@50.6.193.168:~/containers/php/www/raccoontech
build_web:
	sh build_web.sh