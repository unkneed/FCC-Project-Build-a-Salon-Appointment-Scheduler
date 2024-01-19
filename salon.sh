#! /bin/bash
SQL_QUERY="SELECT * FROM services"
PSQL="psql --username=freecodecamp --dbname=salon --no-align -t -c"

MAIN_MENU() {
  #MENU DISPLAY
  echo $($PSQL "SELECT service_id, name FROM services") | while read CUT COLOR BLOW_DRY PERM 
  do
    echo -e "\n$1"
    echo $CUT | sed "s/|/) /"
    echo $COLOR | sed "s/|/) /"
    echo $BLOW_DRY | sed "s/|/) /"
    echo $PERM | sed "s/|/) /"
  done
  #USER SELECTION
  read SERVICE_ID_SELECTED

  if [[ $SERVICE_ID_SELECTED > 4 || $SERVICE_ID_SELECTED < 1 ]]
  then
    MAIN_MENU 'Please pick an appropriate number between 1-4 for the service you desire:'
  else
    echo "Please enter your phone number"
    read CUSTOMER_PHONE
    if [[ -z $($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'") ]]
    then
      echo "You must be new here, can we have your name please?"
      read CUSTOMER_NAME
      CUSTOMER_NAME_INSERTED=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

    else
      # query customer name
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi
    echo "Lastly, when would you like your appointment?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    APPOINTMENT_CREATED=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME') ")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU "Hello how may we service you?"