# Mowoli - A Modality Worklist with RESTful HTTP API

Mowoli is a
[DICOM Modality Worklist](https://en.wikipedia.org/wiki/DICOM#Modality_worklist)
that can be managed via RESTful HTTP API.
Basically it provides a *worklist* of patient data (name, date of birth, etc.)
to medical imaging devices such as MRI or CT scanner (*modalities*).
Mowoli was created as an enhancement for [tomedo](https://tomedo.de),
which couldn't "talk" DICOM at that time.

## Getting started

Mowoli requires [Docker](https://www.docker.com) which has to be installed.
Then clone this repository and change into it:

```console
$ git clone https://github.com/bjoernalbers/mowoli.git
$ cd mowoli
```

Start Mowoli with the following command:

```console
$ docker compose up
```

This will start two Docker containers serving...

- HTTP (port `80/tcp`)
- DICOM (port `11113/tcp`)

Next create some modalities (stations) with your browser:
http://localhost/stations
Then you're ready to create worklist entries (orders) by the HTTP API.
Please take a look at the examples directory on how to do that.
You can inspect all created orders with your browser:
http://localhost/orders

## Production

We run Mowoli on a Docker Swarm using the supplied compose file
(`docker-stack.yml`).

## Copyright

Mowoli is released under the
[MIT License](https://github.com/bjoernalbers/mowoli/blob/master/LICENSE.txt).
