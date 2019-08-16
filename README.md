PhpBB Docker Image (based on RiotKit's PHP-APP container)
=========================================================

[![Build Status](https://travis-ci.org/riotkit-org/docker-phpbb.svg?branch=master)](https://travis-ci.org/riotkit-org/docker-phpbb)

## What is PhpBB?

```
phpBB is a free flat-forum bulletin board software solution that can be used to stay in touch with a group of people or can power your entire website. 
With an extensive database of user-created extensions and styles database containing hundreds of style and image packages to customise your board, you can create a very unique forum in minutes.

No other bulletin board software offers a greater complement of features, while maintaining efficiency and ease of use. Best of all, phpBB is completely free. We welcome you to test it for yourself today. If you have any questions please visit our Community Forum where our staff and members of the community will be happy to assist you with anything from configuring the software to modifying the code for individual needs.
```

## Running this image

The uploads, files, configuration is stored in the `/data` and symlinked into the application.
You can mount whole `/data` directory or only part of it. When no `config.php` exists, then a `config.php` is generated from a template.

```
sudo docker run \ 
    --name phpbb \
    -v ./my-app/images:/data/images \
    -v ./my-app/files:/data/files \
    -v ./my-app/store:/data/store \
    -e 
    --rm -p 80:80 \
    quay.io/riotkit/phpbb:3.2
```

## Image

The image is built with superpower of RiotKit's PHP image. See
[php-app](https://github.com/riotkit-org/docker-php-app) for available
envronment variables to configure.

## Extending

Please put your files and JINJA2 templates into the container with
bind-mount under /.etc.template - all files there will be copied into
/etc with additional JINJA2 rendering (only .j2 files)

The base image [php-app](https://github.com/riotkit-org/docker-php-app)
is supporting files in /.etc.template/nginx/conf.d/ to extend NGINX
configuration.

See also variables in
[php-app](https://github.com/riotkit-org/docker-php-app), they are very
useful, and there are a lot of options.

## Requirements to build image

- Docker
- JINJA2 CLI (j2cli - `pip install j2cli`)

## Building

```
# building a latest version from master
make build VERSION=snapshot TAG=master PUSH=false

# building a stable version "3.2.7"
make build VERSION=3.2.7 TAG=release-3.2.7 PUSH=false

# building all recent tags from github - phpbb/phpbb
make all
```

## How does the image building work?

Dockerfile is generated from a template `Dockerfile.j2`, it's a JINJA2
template (mostly used standard by DevOps around the world). 

The variables required for rendering of the `Dockerfile.j2` are in
`versions` directory. 

`Makefile` is listing all versions, and going through them. For each
version it is rendering a `Dockerfile.j2` into a `Dockerfile` and
executing a `docker build`, next `docker tag` and `docker push`.

**What about configuration files, huh?**

Files in `etc` directory are copied into `.etc.template`, and then the
entrypoint is rendering all jinja2 templates into `etc`, and the rest
files are just copied as is.
