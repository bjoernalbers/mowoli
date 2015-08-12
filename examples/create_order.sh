#!/bin/sh
curl --request POST 'http://localhost:5000/api/v1/orders' \
  --include \
  --silent \
  --header  'Accept: application/json' \
  --header  'Content-Type: application/json' \
  --data \
'{
    "order": {
        "patient_id":                           "674563",
        "patients_birth_date":                  "1952-07-17",
        "patients_sex":                         "M",
        "requested_procedure_description":      "brain",
        "station_id":                           "1",
        "patients_name_attributes": {
            "family":                           "Hasselhoff",
            "given":                            "David",
            "middle":                           "Michael",
            "prefix":                           "Mr.",
            "suffix":                           "(Knight Rider)"
        },
        "referring_physicians_name_attributes": {
              "family":                         "House",
              "given":                          "Gregory",
              "prefix":                         "Dr."
        }
    }
}'
