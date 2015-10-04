define green
	@tput setaf 2; echo $1; tput sgr0;
endef

in_venv=venv/bin/activate
in_docker_machine=$(shell docker-machine env devdocker)

.PHONY: run
run: venv
	. $(in_venv); export DATABASE_URL=postgres://USER:PASSWORD@HOST:PORT/NAME; \
	   	python manage.py createsuperuser
	. $(in_venv); heroku local

.PHONY: default¬
default: venv clean_pyc flake8 unit_tests coverage
	$(call green,"[All steps successful]")

.PHONY: dps
dps:
	eval "$(in_docker_machine)"; docker ps

.PHONY: docker
docker:
	eval "$(in_docker_machine)"; docker run -p 5432:5432 --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres

.PHONY: dockerkill
dockerkill:
	#eval "$(in_docker_machine)"; docker kill some-postgres
	eval "$(in_docker_machine)"; docker rm some-postgres


.PHONY: venv
venv: venv/bin/activate
	$(call green,"[Virtualenv OK]")
venv/bin/activate:
	test -d venv || virtualenv venv
	. $(in_venv); pip install -r requirements.dev.txt
	$(call green,"[Making venv successful]")

.PHONY: clean_pyc
clean_pyc:
	find . -name "*.pyc" -delete
	$(call green,"[Cleanup loitering pyc files]")

.PHONY: flake8
flake8:
	. $(in_venv); flake8 . \
        --exclude venv/,.ropeproject,windows,loader.py \
		--ignore E501,E122
	$(call green,"[Static analysis (flake8) successful]")

.PHONY: unit_tests
unit_tests:
	. $(in_venv); nosetests --attr '!integration,!wip' --exclude-dir=venv/ --with-xunit --stop
	$(call green,"[Unit tests successful]")

.PHONY: coverage
coverage:
	. $(in_venv); nosetests --attr '!integration,!wip' --exclude-dir=venv/ --with-coverage --cover-package=sys -q
	$(call green,"[Generated coverage report]")

.PHONY: clean
clean:
	rm -Rf venv
