#!/bin/sh
curl --request GET 'http://localhost:5000/api/v1/stations' \
  --include \
  --silent \
  --header  'Accept: application/json' \
  --header  'Content-Type: application/json' \
