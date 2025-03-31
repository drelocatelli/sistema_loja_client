deploy:
	ssh andressa@192.168.15.10 "rm -rf ~/containers/php/www/raccoontech"
	scp -r build/web andressa@192.168.15.10:~/containers/php/www/raccoontech
	scp -r build/app/outputs/flutter-apk/app-release.apk andressa@192.168.15.10:~/containers/php/www/raccoon
build_all:
	sh build.sh
build_version:
	./build.sh --version 3.1.8  # set it on .env file