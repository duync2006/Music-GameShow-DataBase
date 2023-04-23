create procedure getPassTraineeEp1(IN year year, IN episode int)
BEGIN
    DECLARE firstlost int default 0;
    DECLARE secondlost int default 0;
    set firstlost = (SELECT Stage_No from stage WHERE Ep_No = 3 ORDER BY Total_vote ASC LIMIT 0,1);
    set secondlost = (SELECT Stage_No from stage WHERE Ep_No = 3 ORDER BY Total_vote ASC LIMIT 2,1);
    if episode = 1 then
        SELECT SSN_Trainee, AverageScore FROM average ORDER BY AverageScore DESC LIMIT 0,30;
    end if;
    if episode = 2 then
        SELECT SSN_Trainee, No_of_Vote from stageincludetrainee WHERE Ep_No = 2 ORDER BY No_of_Vote DESC LIMIT 0, 20;
    end if;
    if episode = 3 then
        SELECT SSN_Trainee, No_of_Vote from stageincludetrainee
        WHERE Stage_No = (SELECT Stage_No from stage
                                          WHERE Ep_No = 3 ORDER BY Total_vote ASC LIMIT 0,1)
        AND Ep_No = 3
        ORDER BY No_of_Vote DESC LIMIT 0,3;

    end if;
end;

