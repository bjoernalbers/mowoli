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


# Deployment on Tomcat

Mowoli runs fine on JRuby, tested with these versions:

- Java JDK 8u45
- JRuby 1.7.20
- Warbler 1.4.7
- Bundler 1.9.9 (NOTE: Version 1.10.* is not yet supported by Warbler!)

Then run `warble runnable war` and throw the resulting *mowoli.war* into Tomcat.

# Deployment on Tomcat for dummies on OSX without homebrew
- Go to a tmp folder and install some helpers
```console
wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
cd chruby-0.3.9/
sudo make install
echo "source /usr/local/share/chruby/chruby.sh" >> ~/.bash_profile
cd ..
```
```console
wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz
tar -xzvf ruby-install-0.5.0.tar.gz
cd ruby-install-0.5.0/
sudo make install
cd ..
```
- Restart Terminal (or do a bash)
```console
ruby-install jruby 1.7.20
chruby 1.7.20
gem install warbler
gem install bundler -v 1.9.9
```
- Create Database as in database.yml or change it there
- Go to mowoli folder
```console
bundle
warble executeble war
```
- Copy to the webapps folder





## Copyright

Copyright (c) 2015 Björn Albers
