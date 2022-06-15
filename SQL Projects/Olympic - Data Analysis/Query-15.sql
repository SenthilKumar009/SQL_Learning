
-- PIVOT
In Postgresql, we can use crosstab function to create pivot table.
crosstab function is part of a PostgreSQL extension called tablefunc.
To call the crosstab function, you must first enable the tablefunc extension by executing the following SQL command:

CREATE EXTENSION TABLEFUNC;

15. List down total gold, silver and broze medals won by each country corresponding to each olympic games.

    SELECT substring(games,1,position(' - ' in games) - 1) as games
        , substring(games,position(' - ' in games) + 3) as country
        , coalesce(gold, 0) as gold
        , coalesce(silver, 0) as silver
        , coalesce(bronze, 0) as bronze
    FROM CROSSTAB('SELECT concat(games, '' - '', nr.region) as games
                , medal
                , count(1) as total_medals
                FROM olympics_history oh
                JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
                where medal <> ''NA''
                GROUP BY games,nr.region,medal
                order BY games,medal',
            'values (''Bronze''), (''Gold''), (''Silver'')')
    AS FINAL_RESULT(games text, bronze bigint, gold bigint, silver bigint);
