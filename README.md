# Shiny on Heroku with Docker

Example of a Docker-based Shiny deployment on Heroku. Uses
[albertw/r-apache](https://hub.docker.com/r/albertw/r-apache/) as the base
image, where most of the logic is implemented.

This image uses OIDC authentication and requires a `g.harvard.edu` login.

The important files:

- `Dockerfile`: Dockerizing the Shiny app
- `heroku.yml`: build manifest for Heroku
- `apache.conf`: VHost configuration for Apache
- `01_hello/*`: Shiny app files

## Notes

- There are two ways to use Docker with Heroku: (1) build locally and push the
  image to the Heroku container registry, or (2) specify the build in the
  `heroku.yml` manifest ([details
  here](https://devcenter.heroku.com/articles/build-docker-images-heroku-yml)).
  This example uses the manifest, which triggers builds on pushes to special git
  remotes.
- Using the build manifest seems a bit slow; the builder seems to need to fetch
  the base layers on every run. The layers _are_ cached in the registry, so
  after the first run, builds are at least faster. It's probably much faster to
  build the image locally (using the `container:*` set of commands from the
  CLI).
