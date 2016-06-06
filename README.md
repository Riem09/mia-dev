## Getting Started With Development

Because we are using Docker we don't need to worry about running the application
on our host computer, we just need to be able to run a docker container.

###### Docker, Docker Machine and Dinghy

We use docker for a virtual machine system. It means that this application will
run the same regardless of the host machine it's running on. It's also running
the exact same environment on our host computers as it would on the production
server. So, we save some hassle of environment changes.

```bash
brew install docker docker-machine docker-compose
```

We also use [Dinghy](https://github.com/codekitchen/dinghy). Which is a great
tool for development with docker, adds faster file volume mounting and some
virtual host tweaks.

```bash
brew tap codekitchen/dinghy
brew install dinghy
dinghy create --provider=virtualbox --memory=4096
```

For more information on Dinghy commands see the repo above.

Once that's finished up. We should have all we need to run a docker container.

###### Using Development Repo

Clone this repo.

Then cd into the directory and run

```bash
git submodule init
git submodule update
```

This components repos are a submodule of this development repo, and the code is now
in a folder under the development repo. We do this so we have all parts of the
application (frontend and backend) in one repository while still having individual
git repos for the separate components of the application.

The development repo has a file called `docker-compose.yml`. This file has
instructions on how to compose the application and build all the necessary
components.

# BUG THAT I NEED TO FIX FOR FRONTEND
Yeah... sorry. but you need to run NPM locally on the host machine right now
so in the FRONTEND root folder
```bash
npm install
```

Running:
```bash
docker-compose up
```
Will spin up the entire application and give you logs for each component.

From here you should be able to visit `mia.docker` and `api.mia.docker`
to see the application. The docker compose file tells it to run a development
server so you can make changes to the application and they will be reflected on
that page.