# Mowoli - DICOM Modality Worklist with HTTP API

**NOTE: This is prototype stuff!**


## Quickstart

- Install DCM4CHE 2

- Download and unpack the
  [latest version of *dcm4che2*](http://sourceforge.net/projects/dcm4che/files/dcm4che2/)
  into */usr/local* and create a symlink (i.e. `cd /usr/local && ln -s dcm4che-2.0.28 dcm4che`)
- Install XCode along with Command Line Developer Tools
- Install [foreman](https://github.com/ddollar/foreman)
- Install Bundler with `sudo gem install bundler`
- clone this repo and `cd` into it
- bootstrap with...

```console
bundle install
bin/rake db:create db:schema:load
foreman start
```

Create some stations via the [web UI](http://localhost:5000/stations)
and then you're ready to create some worklist orders by HTTP POSTs.
Please check the examples folder.

Orders are visible over the [web UI](http://localhost:5000/orders) as well.

## Worklist Attributes

### Study Instance UID

Study Instance UIDs are generated automatically.
They constist of a fixed *org root* and a random integer UUID in order to make
them practically collision-free:

```
<org root>.<random integer UUID>
```

The *org root* is "1.2.826.0.1.3680043.9.5265."
(Thanks to
[Medical Connections Ltd](https://www.medicalconnections.co.uk)
for their
[FREE UID](https://www.medicalconnections.co.uk/Free_UID)
service!).


## Deployment on Tomcat

Mowoli runs fine on JRuby, tested with these versions:

- Java JDK 8u45
- JRuby 1.7.20
- Warbler 1.4.7
- Bundler 1.9.9 (NOTE: Version 1.10.* is not yet supported by Warbler!)

Then run `warble runnable war` and throw the resulting *mowoli.war* into Tomcat.

## Change start value for accession numbers

If you have existing studies in your PACS and you'll likely create new orders with an accession number offset.
This is what I did to create accession numbers starting at 500.000:

    $ bin/rails db -e production
    SQLite version 3.7.13 2012-07-17 17:46:21
    Enter ".help" for instructions
    Enter SQL statements terminated with a ";"
    sqlite> UPDATE SQLITE_SEQUENCE SET seq = 500000 where name = 'orders';
    sqlite> SELECT name, seq FROM SQLITE_SEQUENCE;                                                                                                                                                   
    stations|10
    orders|500000
    sqlite> .quit


## Copyright

Copyright (c) 2015 Björn Albers
