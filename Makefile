CCRED=\033[0;31m
CCEND=\033[0m

.PHONY: build clean download unzip transform help

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: buildAWS buildGoogle ## Build AWS & Google icons

deploy: ## Copy scripts, stencils, templates, and documents to application's folders
	cp -R Stencils/ ~/Library/Containers/com.omnigroup.OmniGraffle7/Data/Library/Application\ Support/The\ Omni\ Group//OmniGraffle/Stencils/
	cp -R Scripts/ ~/Library/Containers/com.omnigroup.OmniGraffle7/Data/Library/Application\ Support/The\ Omni\ Group//OmniGraffle/Scripts/
	cp -R Templates/ ~/Library/Containers/com.omnigroup.OmniGraffle7/Data/Library/Application\ Support/The\ Omni\ Group//OmniGraffle/Templates/
	cp -R Documents/ ~/Documents/@Diagrams

buildAWS: ## Download AWS icons, unzip, and normalize filenames
	curl https://d1.awsstatic.com/webteam/architecture-icons/q2-2021/Asset-Package_04302021.9a0ee1879c72eb5b495566d3e0d97db954cf0258.zip --output awsIcons.zip
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

buildGoogle: ## Download AWS icons, unzip, and normalize filenames
	rm -rf googleSource googleTarget googleIcons.zip
	curl  https://cloud.google.com/icons/files/google-cloud-icons.zip --output googleIcons.zip
	unzip -d googleSource googleIcons.zip
	mv googleSource/Google*/Products*/* googleSource/.
	rm -rf googleSource/Google* googleSource/__MACOSX
	mkdir -p googleTarget
	cp -R googleSource/*/*.svg googleTarget/
	rename googleTarget/* --delete=-512 -e 's/ \(1\)//g' -e 's/_/ /g' -e 's/-/ /g'

clean: ## Delete awsSource & awsTarget directories
	@rm -rf awsSource awsTarget awsIcons.zip
	rm -rf googleSource googleTarget googleIcons.zip
