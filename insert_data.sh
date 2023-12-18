#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
CLEARED=$($PSQL "TRUNCATE games, teams RESTART IDENTITY")
if [[ $CLEARED == "TRUNCATE TABLE" ]]
then
  echo Table was cleared
fi

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPO WIN_GOALS OPPO_GOALS
do
  if [[ $YEAR != "year" ]]
    then

      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPO'")
      if [[ -z $WIN_ID ]]
        then
          INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
            then
              echo Inserted into teams, $WINNER
          fi

          WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      fi
      
      if [[ -z $OPPO_ID ]]
        then
          INSERT_OPPO_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPO')")
          if [[ $INSERT_OPPO_RESULT == "INSERT 0 1" ]]
           then
            echo Inserted into teams, $OPPO
          fi

          OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPO'")
      fi

      INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID, $OPPO_ID, $WIN_GOALS, $OPPO_GOALS)")
      if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
        then
          echo Inserted into games!
      fi
      
  fi
done
