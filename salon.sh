#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"


SERVICE_LIST() {
  echo "$($PSQL "SELECT service_id, name FROM services;")" | while IFS="|" read -r SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}

SELECT_SERVICE() {
  SERVICE_LIST
  echo -------------------------
  echo "Which service do you want?"
  read SERVICE_ID_SELECTED

  VALID_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED;")

  if [[ -z "$VALID_ID" || ! "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]]; then
    SELECT_SERVICE
  else
    CHECK_USER
  fi
}

CHECK_USER() {
  echo "Whats your phone number?"
  read CUSTOMER_PHONE

  READ_CUSTOMER_PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $READ_CUSTOMER_PHONE_NUMBER ]]
  then
    echo -e "\nNumber not found. Creating new user."
    ADD_USER
  else
    echo "Pick a date"
    read SERVICE_TIME
    
  fi
}

ADD_USER() {
  echo -e "\nWhats your name?"
  read USER_NAME
  echo -e "\nWhats your phone number?"
  read USER_PHONE_NUMBER

  ADD_USER_TO_DB=$($PSQL "INSERT INTO customers(phone, name) VALUES('$USER_PHONE_NUMBER', '$USER_NAME')")
  echo "$USER_NAME with Number: $USER_PHONE_NUMBER added to the customers Database"
}

ADD_TO_SCHEDULE() {

}

SELECT_SERVICE

