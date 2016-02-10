# Mowoli - DICOM Modality Worklist with HTTP API

Mowoli is a gateway between modalities (i.e. MRI or CT stations) and Radiology
Informations Systems:
It allows systems that don't "talk" DICOM to send patient data simply over HTTP
and provides it via DICOM for modalities.
Mowoli just sits in between and does the "translation".


## Getting started

Clone this repository and run the setup script (you might need
to install *XCode* with *Command Line Developer Tools* first):

```console
git clone https://github.com/bjoernalbers/mowoli.git
cd mowoli && bin/setup
```
  
From here on you can start playing with the HTTP UI & API:

```console
bin/rails server
```

Next [create some stations](http://localhost:3000/stations) in Mowoli's database
and then you're ready to send patient / study data (we call them *orders*) by HTTP.
Please check the examples folder on how to do that.
[Take a look](http://localhost:3000/orders) to see all orders.


## DICOM

Mowoli uses [dcm4che](http://www.dcm4che.org) to provide orders via DICOM.
So if you need DICOM you have to install dcm4che first:

1. Download and unpack the
  [latest version of *dcm4che2*](http://sourceforge.net/projects/dcm4che/files/dcm4che2/)
2. Copy the unziped folder to `/usr/local/`
3. Create a symlink for convenience, for example `cd /usr/local && ln -s dcm4che-2.0.28 dcm4che`
4. Create the *worklist directory* which holds all orders in xml format `mkdir -p /usr/local/dcm4che/var/dcmof`

For a quick test you could start `dcmof` and make some queries with your station:

```
$ /usr/local/dcm4che/bin/dcmof --mwl /usr/local/dcm4che/var/dcmof MOWOLI:11112
```


## Development

1. Install [foreman](https://github.com/ddollar/foreman)
2. Tweak your configuration file (`.env`) if you want / need to change the TCP
   port, installed dcm4che somewhere else, etc.

Then bring up the whole beast with...

```
foreman start
```

This will start the webserver (make sure you're not also running `bin/rails
server`) and the "worklist-daemon" a.k.a. `dcmof`.
Thats it :-)


## Production

I suggest you deploy to Mac OS X 10.9 or later.
To do that you create a deployment configuration `config/production.rb`, i.e. with this content:

```Ruby
set :rails_env, 'production' 
set :user, 'admin' # You might need to change the username
server '192.168.1.42', # ...and the target host!
  user: fetch(:user),
  roles: %w(web app db)
```

Then run this command on your workstation to deploy the app on your target host:

    $ bundle exec cap production deploy

Done.
To update just `git pull` the updates and run the above command again.

NOTE: On the server side you have to setup DICOM manually (see above).


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
