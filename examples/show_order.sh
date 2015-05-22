#!/bin/sh
curl --request GET 'http://localhost:5000/api/v1/orders/28' \
  --include \
  --silent \
  --header  'Accept: application/json' \
  --header  'Content-Type: application/json' \
