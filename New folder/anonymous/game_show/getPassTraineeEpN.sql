create procedure getPassTraineeEpN(IN year year, IN episode int)
BEGIN
    DECLARE firstlose int default 0;
    DECLARE secondlose int default 0;
    set firstlose = (SELECT Stage_No from stage WHERE Ep_No = 3 AND Year = year ORDER BY Total_vote ASC LIMIT 0,1);
    set secondlose = (SELECT Stage_No from stage WHERE Ep_No = 3 AND Year = year ORDER BY Total_vote ASC LIMIT 1,1);
    if episode = 1 then
        SELECT SSN_Trainee, AverageScore FROM average WHERE Year = year ORDER BY AverageScore DESC LIMIT 0,30;
    end if;
    if episode = 2 then
        SELECT SSN_Trainee, No_of_Vote from stageincludetrainee WHERE Ep_No = 2 AND Year = year
        ORDER BY No_of_Vote DESC LIMIT 0, 20;
    end if;
    if episode = 3 then
        SELECT SSN_Trainee, No_of_Vote from stageincludetrainee
        WHERE Ep_No = 3 AND Year = year
          AND SSN_Trainee != (SELECT SSN_Trainee from stageincludetrainee
                              WHERE Stage_No = firstlose
                                AND Year = year
                                AND Ep_No = 3
                              ORDER BY No_of_Vote ASC LIMIT 0,1)
          AND SSN_Trainee != (SELECT SSN_Trainee from stageincludetrainee
                              WHERE Stage_No = firstlose
                                AND Year = year
                                AND Ep_No = 3
                              ORDER BY No_of_Vote ASC LIMIT 1,1)
          AND SSN_Trainee != (SELECT SSN_Trainee from stageincludetrainee
                              WHERE Stage_No = secondlose
                                AND Year = year
                                AND Ep_No = 3
                              ORDER BY No_of_Vote ASC LIMIT 0,1)
          AND SSN_Trainee != (SELECT SSN_Trainee from stageincludetrainee
                              WHERE Stage_No = secondlose
                                AND Year = year
                                AND Ep_No = 3
                              ORDER BY No_of_Vote ASC LIMIT 1,1);
    end if;
    if episode = 4 then
        SELECT SSN_Trainee, No_of_Vote from stageincludetrainee WHERE Ep_No = 4 AND Year = year
        ORDER BY No_of_Vote DESC LIMIT 0, 10;
    end if;
    if episode = 5 then
        SELECT SSN_Trainee, VoteEp5 as 'Debut(Total vote in ep5)' from average WHERE Year = year
        ORDER BY VoteEp5 DESC LIMIT 0, 5;
    end if;
end;

