#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$(PSQL "TRUNCATE TABLE games, teams;")
teams=$(tail -n +2 games.csv | cut -d "," -f3,4 | tr "," "\n" | sort | uniq)

while IFS= read -r team
do
  $PSQL "INSERT INTO teams(name) VALUES('$team')"
done <<< "$teams"


cat games.csv | while IFS=, read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ "$YEAR" == "year" ]];
  then
    continue
  fi
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  $PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)"
done