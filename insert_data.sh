#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# clear table first
echo "$($PSQL "TRUNCATE teams, games")"

# read data from file
cat games.csv | while IFS=',' read YEAR ROUND WINNER_NAME OPPONENT_NAME WINNER_GOALS OPPONENT_GOALS

  do
  # skip first row
  if [[ $YEAR != "year" ]]
    then

    # find winner and opponent in teams table
    WINNER=$($PSQL "SELECT * FROM teams WHERE name = '$WINNER_NAME'")
    OPPONENT=$($PSQL "SELECT * FROM teams WHERE name = '$OPPONENT_NAME'")

    # if not found, insert them into teams table
    if [[ -z $WINNER ]]
      then
        ($PSQL "INSERT INTO teams(name) VALUES ('$WINNER_NAME')")
    fi

    if [[ -z $OPPONENT ]]
      then
        ($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT_NAME')")
    fi

    # find team_id for the winner team
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER_NAME'")

    # find team_id for the opponent team
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT_NAME'")

    # insert winner_id, opponent_id, year, round, winner_goals, opponent_goals values to games table
    ($PSQL "INSERT INTO games(winner_id, opponent_id, year, round, winner_goals, opponent_goals) VALUES($WINNER_ID, $OPPONENT_ID, $YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
  
  done

  
