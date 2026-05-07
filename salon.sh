#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=salon_test -t --no-align -c"
else
  PSQL="psql --username=postgres --dbname=salon -t --no-align -c"
fi

echo "$($PSQL "SELECT service_id || ') ' || name FROM services;")"
read SERVICE_ID_SELECTED

