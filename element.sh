#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -A --tuples-only -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[  $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$1'")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1' OR symbol = '$1'")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties ON types.type_id=properties.type_id WHERE atomic_number = $ATOMIC_NUMBER")
    ELEMENT=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
exit 0


