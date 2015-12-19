Use of docker in here
---------------------

Effectively whimsical, but lighter than a Vagrant machine for the database piece.

Entry point is docker-machine. This creates virtualised dockerhosts. 

Local environment lifecycle:

`make dockersparkle` use docker-machine to remove the devdocker host
`make dockerhost` use docker-machine to create the devdocker host in virtbox
                 and provision the docker container with the database

