# Mowoli - DICOM Modality Worklist with HTTP API

**NOTE: This is prototype stuff!**


## Quickstart

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

Then create a worklist entry by HTTP POST, i.e. from your console:

```console
/usr/bin/curl \
  -F 'entry[patient_id]="674563"' \
  -F 'entry[patients_name]="Hasselhoff^David"' \
  -F 'entry[patients_birth_date]="1952-07-17"' \
  -F 'entry[patients_sex]="M"' \
  -F 'entry[referring_physicians_name]="House^Gregory^^Dr."' \
  -F 'entry[requesting_physicians_name]="Volakis^Amber^^Dr."' \
  -F 'entry[requested_procedure_description]="knee"' \
  -F 'entry[scheduled_station_ae_title]="AGFA"' \
  -F 'entry[modality]="MR"' \
  -F 'entry[accession_number]="9837613118"' \
  -F 'entry[study_instance_uid]="1.2.3.4.567890"' \
  http://localhost:5000/entries
```


## Copyright

Copyright (c) 2015 Björn Albers
