#
# Merch Ward Makefile
#
.PHONY: requirements.txt
.PHONY: help
.PHONY: run


help:
	@echo "Makefile rules:"
	@echo "   help    - This."
	@echo "	  init    - Install requirements"
	@echo "	  run	  - Run program"


installRequirements:
	cd ../merchWardApp \
	&& pip install -r requirements.txt -t .

deploy:
	${MAKE} installRequirements

	cd ../merchWardApp \
	&& zip -r --exclude=*v-env* --exclude=*.zip merchWardApp.zip * 	\
	&& mv merchWardApp.zip ../deploy

	terraform init
	terraform plan
	terraform apply

clean:
	cd ../merchWardApp \
	&& mv merchWardApp.py requirements.txt .. \
	&& rm -rf * \
	&& mv ../merchWardApp.py ../requirements.txt .

