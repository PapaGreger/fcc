#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

LIST_SERVICES() {
  echo -e $1

  ($PSQL "SELECT * FROM services") | while read ID BAR SERVICE
  do
    if [[ ! -z $SERVICE ]]
    then
      echo "$ID) $SERVICE"
    fi
  done

  read SERVICE_ID_SELECTED  
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE ]]
  then
    LIST_SERVICES "\nI could not find that service. What would you like today?"
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      ($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi

    echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"
    read SERVICE_TIME

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    ($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

LIST_SERVICES "\nWelcome to My Salon, how can I help you?"