deploy:
	scp -r build/web root@50.6.193.168:~/containers/php/www/raccoontech
	scp -r build/app/outputs/flutter-apk/app-release.apk root@50.6.193.168:~/containers/php/www/raccoon
build_web:
	sh build.sh