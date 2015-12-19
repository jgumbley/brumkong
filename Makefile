define green
	@tput setaf 2; echo $1; tput sgr0;
endef

in_venv=venv/bin/activate
with_db=export DATABASE_URL=postgres://postgres:mysecretpassword@192.168.99.100:5432/postgres
docker_host=kongdocker
in_docker_machine=$(shell docker-machine env $(docker_host))

.PHONY: test
test: venv clean_pyc flake8 unit_tests coverage
	$(call green,"[All steps successful]")

.PHONY: run
run: dockerdb venv
	. $(in_venv); $(with_db); python manage.py syncdb
	. $(in_venv); $(with_db); python manage.py migrate
	. $(in_venv); $(with_db); heroku local

.PHONY: dockerdb
dockerdb:
	eval "$(in_docker_machine)"; docker start some-postgres

.PHONY: dockerhost
dockerhost:
	docker-machine create --driver virtualbox $(docker_host)
	eval "$(in_docker_machine)"; docker run -p 5432:5432 --name some-postgres \
		-e POSTGRES_PASSWORD=mysecretpassword -d postgres

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
		--ignore E501,E122,F401
	$(call green,"[Static analysis (flake8) successful]")

.PHONY: unit_tests
unit_tests:
	. $(in_venv); nosetests --attr '!integration,!wip' --exclude-dir=venv/ --with-xunit --stop
	$(call green,"[Unit tests successful]")

.PHONY: coverage
coverage:
	. $(in_venv); nosetests --attr '!integration,!wip' --exclude-dir=venv/ --with-coverage \
		--cover-package=brumkong -q
	$(call green,"[Generated coverage report]")

.PHONY: dockerclean
dockersparkle:
	docker-machine rm devdocker

.PHONY: dockerclean
dockerclean:
	eval "$(in_docker_machine)"; docker rm -f some-postgres

.PHONY: clean
clean: dockerclean
	rm -Rf venv


