# Mowoli - DICOM Modality Worklist with HTTP API

Mowoli is a Rails application to provide a modality worklist for a radiology.
In other terms: I sends study and patient data to modalities / stations in a
radiology which is a lot less error-prone that typing everything twice.


## Development

Clone this repo locally and run the bootstrap script (you might need
to install *XCode* with *Command Line Developer Tools* first):

```console
git clone https://github.com/bjoernalbers/mowoli.git
cd mowoli && bin/setup
```
  
From here on you can start playing with the HTTP UI & API:

````console
bin/rails server
```

### ...with DICOM

You wanna get fancy by also running the "DICOM" part? Nice.
This requires a bit more work:

1. Download and unpack the
  [latest version of *dcm4che2*](http://sourceforge.net/projects/dcm4che/files/dcm4che2/)
  into */usr/local* and create a symlink (i.e. `cd /usr/local && ln -s dcm4che-2.0.28 dcm4che`)
2. Install [foreman](https://github.com/ddollar/foreman)
3. Tweak your configuration file (`.env`) if you want / need to change the TCP
   port, installed dcm4che somewhere else, etc.

Then bring up the whole beast with...

```
foreman start
```

This will start the webserver (make sure you're not also running `bin/rails
server`) and the "worklist-daemon" a.k.a. `dcmof`.
Thats it :-)


## Usage

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

Mowoli is released under the
[MIT License](https://github.com/bjoernalbers/mowoli/blob/master/LICENSE.txt).
