#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#year,round,winner,opponent,winner_goals,opponent_goals
echo $($PSQL "TRUNCATE TABLE games, teams")
cat "games.csv" | while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    #Insert teams
    WINNER=$($PSQL "SELECT name FROM teams WHERE name='$winner'")
    if [[ $WINNER == '' ]]
    then
      WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
    fi
    
    OPPONENT=$($PSQL "SELECT name FROM teams WHERE name='$opponent'")
    if [[ $OPPONENT == '' ]]
    then
      OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
    fi

    #Insert games
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    GAME=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($year, '$round', $winner_goals, $opponent_goals, $WINNER_ID, $OPPONENT_ID)")
  fi
done