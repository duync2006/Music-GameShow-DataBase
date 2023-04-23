
/* ---------------TRIGGER FOR CHECKING FOR PARTICIPATE OVER 3 TIMES-----------------------*/
DROP trigger if exists participate_time_counting;
DELIMITER $$
create trigger participate_time_counting
    before insert on seasontrainee
    for each row
begin
    DECLARE count int default 0;
    set count = (SELECT COUNT(SSN_Trainee) from seasontrainee WHERE NEW.SSN_Trainee = SSN_Trainee AND NEW.Year != YEAR);
    IF count > 2 then
        signal SQLSTATE '45000' set message_text = 'This trainee had participated 3 time!';
    end if;
end$$
DELIMITER ;

/* ---------------TRIGGER FOR DEBUT NIGHT CHECKING FOR PARTICIPATE -----------------------*/
drop trigger if exists  debutNightCheck;
DELIMITER $$
create trigger debutNightCheck
    before insert on seasontrainee
    for each row
begin
    if exists(SELECT * from seasontrainee, stageincludetrainee
              WHERE (NEW.SSN_Trainee = seasontrainee.SSN_Trainee AND seasontrainee.Year < new.Year)
                AND NEW.SSN_Trainee IN (
                    SELECT seasontrainee.SSN_Trainee
                        from stageincludetrainee, seasontrainee
                            WHERE seasontrainee.SSN_Trainee = stageincludetrainee.SSN_Trainee
                            AND Ep_No = 5
                            AND seasontrainee.Year = stageincludetrainee.Year))
        then
        signal SQLSTATE '45000' set message_text = 'This trainee had taken part in The Debut Night before';
    end if;
end$$
DELIMITER ;


/* ---------------TRIGGER FOR CALCULATE TOTAL VOTE -----------------------*/
drop trigger if exists  sum_vote;
DELIMITER $$
create trigger sum_vote
    after insert on stageincludetrainee
    for each row
begin
    UPDATE stage SET Total_vote = (SELECT SUM(No_of_Vote) from stageincludetrainee
                                        WHERE stageincludetrainee.Year = NEW.Year
                                        AND stageincludetrainee.Ep_No = NEW.Ep_No
                                        AND stageincludetrainee.Stage_No = NEW.Stage_No)
        WHERE NEW.Year = Year AND NEW.Ep_No = Ep_No AND NEW.Stage_No = Stage_No;
end;

drop trigger if exists sum_vote_update;
create trigger sum_vote_update
    after update on stageincludetrainee
    for each row
begin
    UPDATE stage SET Total_vote = (SELECT SUM(No_of_Vote) from stageincludetrainee
                                   WHERE stageincludetrainee.Year = NEW.Year
                                     AND stageincludetrainee.Ep_No = NEW.Ep_No
                                     AND stageincludetrainee.Stage_No = NEW.Stage_No)
    WHERE NEW.Year = Year AND NEW.Ep_No = Ep_No AND NEW.Stage_No = Stage_No;
end$$
DELIMITER ;


/* ---------------TRIGGER FOR ENSURE GROUP AT EPISODE 2,3,4 -----------------------*/
drop trigger if exists ensure_group;
DELIMITER $$
create trigger ensure_group
    after insert on stageincludetrainee
    for each row
begin
    if (NEW.Ep_No = 2 OR NEW.Ep_No = 3 or NEW.Ep_No = 4)
    then
        if not exists((SELECT Stage_No from stage
                       WHERE (Year = new.Year )
                         AND (Ep_No = new.Ep_No)
                         AND (NEW.Ep_No = 2 OR NEW.Ep_No = 3 OR NEW.Ep_No = 4)
                         AND (is_Group = 1)))
        then
            signal SQLSTATE '45000' set message_text = 'This trainee must have at most one group';
        end if;
    end if;
end $$
DELIMITER ;

/* ---------------TRIGGER FOR ENSURE GROUP AT EPISODE 5 -----------------------*/
drop trigger if exists ensure_final_stage;
DELIMITER $$
create trigger ensure_final_stage
    after insert on stageincludetrainee
    for each row
begin
    DECLARE count int default 0;
    set count = (SELECT count(stageincludetrainee.Stage_No) from stageincludetrainee
                 WHERE (stageincludetrainee.Year = new.Year )
                   AND (stageincludetrainee.Ep_No = new.Ep_No)
                   AND (stageincludetrainee.SSN_Trainee = new.SSN_Trainee)
                   AND (NEW.Ep_No = 5));
    if count > 2
    then
        signal SQLSTATE '45000' set message_text = 'This trainee must have one group and one individual stage';
    end if;
end$$
DELIMITER ;

/*-------------------------------II.1----------------------------------------------*/
/* ---------------TRIGGER FOR AVERAGE SCORE -----------------------*/
DROP trigger IF EXISTS addAverageScore;
DELIMITER $$
create trigger addAverageScore
    after insert on mentorvaluatetrainee
    for each row
    begin
        IF exists(select SSN_trainee from average where NEW.SSN_Trainee = average.SSN_Trainee) then
        UPDATE average
        SET AverageScore = (SELECT AVG(Score) FROM mentorvaluatetrainee
                            WHERE new.SSN_Trainee = mentorvaluatetrainee.SSN_Trainee
                            AND new.Year = mentorvaluatetrainee.Year)
        WHERE new.SSN_Trainee = average.SSN_trainee;
        else
            insert into average (SSN_trainee, AverageScore, Year)
            values (new.SSN_Trainee, new.Score, NEW.Year);
        end if;
    end$$
DELIMITER ;

DROP trigger IF EXISTS updateAverageScore;
DELIMITER $$
create trigger updateAverageScore
    after update on mentorvaluatetrainee
    for each row
begin
    IF exists(select SSN_trainee from average where NEW.SSN_Trainee = average.SSN_Trainee) then
        UPDATE average
        SET AverageScore = (SELECT AVG(Score) FROM mentorvaluatetrainee
                            WHERE new.SSN_Trainee = mentorvaluatetrainee.SSN_Trainee
                            AND new.Year = mentorvaluatetrainee.Year)
        WHERE new.SSN_Trainee = average.SSN_trainee;
    else
        insert into average (SSN_trainee, AverageScore, Year)
        values (new.SSN_Trainee, new.Score, new.Year);
    end if;
end$$
DELIMITER ;

/* ---------------TRIGGER FOR ADD AND UPDATE VOTE EPISODE 2 -----------------------*/
DROP trigger if exists addVoteEp2;
DELIMITER $$
CREATE trigger addVoteEp2
    after INSERT on stageincludetrainee
    for each row
begin
    UPDATE average SET VoteEp2 = New.No_of_Vote
    WHERE New.Ep_No = 2
      AND New.SSN_Trainee = SSN_trainee
      AND New.Year = Year;
end $$
delimiter ;

DROP trigger if exists updateVoteEp2;
DELIMITER $$
CREATE trigger updateVoteEp2
    after UPDATE on stageincludetrainee
    for each row
begin
    UPDATE average SET VoteEp2 = New.No_of_Vote
    WHERE New.Ep_No = 2
      AND New.SSN_Trainee = SSN_trainee
      AND NEW.Year = Year;
end $$
delimiter ;

/* ---------------TRIGGER FOR ADD AND UPDATE VOTE EPISODE 3 -----------------------*/
DROP trigger if exists addVoteEp3;
DELIMITER $$
CREATE trigger addVoteEp3
    after INSERT on stageincludetrainee
    for each row
begin
    UPDATE average SET VoteEp3 = New.No_of_Vote
    WHERE New.Ep_No = 3
      AND New.SSN_Trainee = SSN_trainee
      AND New.Year = Year;
end $$
delimiter ;

DROP trigger if exists updateVoteEp3;
DELIMITER $$
CREATE trigger updateVoteEp3
    after UPDATE on stageincludetrainee
    for each row
begin
    UPDATE average SET VoteEp3 = New.No_of_Vote
    WHERE New.Ep_No = 3
      AND New.SSN_Trainee = SSN_trainee
      AND NEW.Year = Year;
end $$
delimiter ;

/* ---------------TRIGGER FOR ADD AND UPDATE VOTE EPISODE 4 -----------------------*/
DROP trigger if exists addVoteEp4;
DELIMITER $$
CREATE trigger addVoteEp4
    after INSERT on stageincludetrainee
    for each row
begin
    UPDATE average SET VoteEp4 = New.No_of_Vote
    WHERE New.Ep_No = 4
      AND New.SSN_Trainee = SSN_trainee
      AND New.Year = Year;
end $$
delimiter ;

DROP trigger if exists updateVoteEp4;
DELIMITER $$
CREATE trigger updateVoteEp4
    after UPDATE on stageincludetrainee
    for each row
begin
    UPDATE average SET VoteEp4 = New.No_of_Vote
    WHERE New.Ep_No = 4
      AND New.SSN_Trainee = SSN_trainee
      AND NEW.Year = Year;
end $$
delimiter ;

/* ---------------TRIGGER FOR ADD AND UPDATE VOTE EPISODE 5 -----------------------*/
DROP trigger if exists addVoteEp5;
DELIMITER $$
CREATE trigger addVoteEp5
    after INSERT on stageincludetrainee
    for each row
begin
    UPDATE average SET VoteEp5 = (SELECT SUM(No_of_Vote) FROM stageincludetrainee
                                                         WHERE stageincludetrainee.Year = new.Year
                                                         AND stageincludetrainee.SSN_Trainee = new.SSN_Trainee
                                                         AND stageincludetrainee.Ep_No = 5)
    WHERE New.Ep_No = 5
      AND New.SSN_Trainee = SSN_trainee
      AND New.Year = Year;
end $$
delimiter ;

DROP trigger if exists updateVoteEp5;
DELIMITER $$
CREATE trigger updateVoteEp5
    after UPDATE on stageincludetrainee
    for each row
begin
    UPDATE average SET VoteEp5 = (SELECT SUM(No_of_Vote) FROM stageincludetrainee
                                  WHERE stageincludetrainee.Year = new.Year
                                    AND stageincludetrainee.SSN_Trainee = new.SSN_Trainee
                                    AND stageincludetrainee.Ep_No = 5)
    WHERE New.Ep_No = 5
      AND New.SSN_Trainee = SSN_trainee
      AND New.Year = Year;
end $$
delimiter ;

/*-------------------------------II.1----------------------------------------------*/

Drop procedure if exists  getPassTraineeEpN;
create
    definer = root@localhost procedure getPassTraineeEpN(IN year year, IN episode int)
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

CAll getPassTraineeEpN(2022,5);
CALL getResult('123456789', 2022);
/*-------------------------------II.2----------------------------------------------*/
DROP PROCEDURE if exists getResult;
DELIMITER $$
CREATE PROCEDURE getResult(SSN int, year YEAR)
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
    end $$
    DELIMITER ;
SET SESSION SQL_MODE='ALLOW_INVALID_DATES';
CALL getPassTraineeEpN(2022, 1);

