#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"



SELECT_SERVICE() {
  echo "$($PSQL "SELECT service_id, name FROM services;")" | while IFS="|" read -r SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  echo -------------------------
  echo "Which service do you want?"
  read SERVICE_ID_SELECTED

  VALID_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED;")

  if [[ -z "$VALID_ID" || ! "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]]; then

    SELECT_SERVICE
  else
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    CHECK_USER
  fi
}


CHECK_USER() {
  echo "Whats your phone number?"
  read CUSTOMER_PHONE

  READ_CUSTOMER_PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $READ_CUSTOMER_PHONE_NUMBER ]]
  then
    echo -e "\n- Number not found. Creating new user -"
    ADD_USER
  else
    echo -e "\n- Number found -"
    ADD_TO_SCHEDULE
  fi
}


ADD_USER() {
  echo -e "\nWhats your name?"
  read CUSTOMER_NAME

  ADD_USER_TO_DB=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  echo "- $CUSTOMER_NAME with Number: $CUSTOMER_PHONE added to the customers Database -"
  ADD_TO_SCHEDULE

}


ADD_TO_SCHEDULE() {

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  DISTINCT_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time do you want to book?"
  read SERVICE_TIME

  ADDED_TO_SCHEDULE=$($PSQL "INSERT INTO appointments(customer_id,service_id, time) VALUES('$DISTINCT_CUSTOMER_ID','$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

SELECT_SERVICE
