CCRED=\033[0;31m
CCEND=\033[0m

.PHONY: build clean download unzip transform help

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: buildAWS buildGoogle ## Build AWS & Google icons

buildAWS: clean dlAWS unzipAWS ## Build AWS icons

buildGoogle: clean dlGoogle unzipGoogle ## Build Google icons

clean: ## Delete awsSource & awsTarget directories
	@rm -rf awsSource awsTarget
	rm -rf googleSource googleTarget

dlAWS: ## Download AWS icons
	curl https://d1.awsstatic.com/webteam/architecture-icons/q2-2021/Asset-Package_04302021.9a0ee1879c72eb5b495566d3e0d97db954cf0258.zip --output awsIcons.zip
dlGoogle: ## Download Google icons
	curl  https://cloud.google.com/icons/files/google-cloud-icons.zip --output googleIcons.zip

unzipAWS: ## Unzip AWS icons and normalize filenames
	unzip -d awsSource awsIcons.zip
	mv awsSource/Asset*/* awsSource/.
	rm -rf awsSource/Asset* awsSource/__MACOSX
	mkdir -p awsTarget
	cp -R awsSource/Category-Icons_*/48/*.svg awsTarget/
	find awsTarget -type f -execdir mv {} awsCategory_{} \;
	cp -R awsSource/Architecture-Service-Icons_*/*/48/*.svg awsTarget/
	cp -R awsSource/Resource-Icons_*/*/Res_48_Light/*.svg awsTarget/
	rename awsTarget/Res_* -e 's/Res_/ICON /' --delete=_Light
	rename awsTarget/Arch_* -e 's/Arch_/SERVICE /'
	rename awsTarget/* --delete=_48 -e 's/_/ /g' -e 's/-/ /g'

unzipGoogle: ## Unzip Google icons and normalize filenames
	unzip -d googleSource googleIcons.zip
	mv googleSource/Google*/Products*/* googleSource/.
	rm -rf googleSource/Google* googleSource/__MACOSX
	mkdir -p googleTarget
	cp -R googleSource/*/*.svg googleTarget/
#	rename googleTarget/* -e 's/ \(1\)//g'
	rename googleTarget/* --delete=-512 -e 's/ \(1\)//g' -e 's/_/ /g' -e 's/-/ /g'
