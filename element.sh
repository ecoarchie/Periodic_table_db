#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  # if input is a atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    SELECTED_ELEMENT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $1")
  fi

  # if input is a name (1-2 chars)
  if [[ $1 =~ ^[A-Za-z]{1,2} ]]
  then
    SELECTED_ELEMENT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$1'")
  fi

  # if input is element's name
  if [[ $1 =~ ^[A-Z][a-z]{2,} ]]
  then
    SELECTED_ELEMENT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name = '$1'")
  fi
  
  if [[ -z $SELECTED_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$SELECTED_ELEMENT" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR TYPE
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi

