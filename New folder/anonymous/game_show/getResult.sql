create procedure getResult(IN SSN int, IN year year)
BEGIN
        SELECT descrip as Episode , value as 'Num of votes/ avg score' from (Select descrip, value, Year, SSN_trainee from
                                                                                   (select Year, SSN_trainee, AverageScore value, '1' descrip
                                                                                   from average
                                                                                   union all
                                                                                   select Year, SSN_trainee, VoteEp2 value, '2' descrip
                                                                                   from average
                                                                                   union all
                                                                                   select Year, SSN_trainee, VoteEp3 value, '3' descrip
                                                                                   from average
                                                                                   union all
                                                                                   select Year, SSN_trainee, VoteEp4 value, '4' descrip
                                                                                   from average
                                                                                   union all
                                                                                   select Year, SSN_trainee, VoteEp5 value, '5' descrip
                                                                                   from average
                                                                                  ) src
                                    GROUP BY  descrip, value) src1
        WHERE SSN_trainee = SSN AND year = year;
    end;

