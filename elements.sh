#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Function to query the database and get element information
get_element_info() {
  local query_result=$($PSQL "
    SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
    FROM elements e
    JOIN properties p ON e.atomic_number = p.atomic_number
    JOIN types t ON p.type_id = t.type_id
    WHERE e.atomic_number::text = '$1'
       OR e.symbol = '$1'
       OR e.name = '$1';
  ")

  if [[ -z "$query_result" ]]; then
    echo "I could not find that element in the database."
  else
    echo "$query_result" | while IFS='|' read -r atomic_number name symbol atomic_mass melting_point boiling_point type; do
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    done
  fi
}

# Main script logic
if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
else
  get_element_info "$1"
fi
