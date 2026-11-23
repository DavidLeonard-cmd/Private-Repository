help:
	@echo "David Leonard"
	@echo "Build the deployment package: make build"
	@echo "Deploy the package to Git: make deploy"

build: xmen-report.sh xmen-roster.txt README.md
	rm -f xmen-package.zip
	zip xmen-package.zip xmen-report.sh xmen-roster.txt README.md

deploy: build
	git add Makefile xmen-report.sh xmen-roster.txt README.md xmen-package.zip
	git commit -m "Build and deploy X-Men roster report"
