create database game_show;
use game_show;
create table company
(
    Cnumber varchar(4)  not null comment 'C[0-9][0-9][0-9]'
        primary key,
    Name    varchar(30) not null,
    Address varchar(50) null,
    Phone   varchar(30) not null,
    Edate   date        null,
    constraint COMPANY_pk
        unique (Phone)
);

create table episode
(
    Year     year     not null,
    No       int      not null comment '[1-5]',
    Datetime datetime null,
    Duration time     null,
    primary key (Year, No),
    constraint `check episode number`
        check ((`No` >= 1) and (`No` <= 5))
);

create table invitedguest
(
    Guest_ID int auto_increment
        primary key
);

create table `group`
(
    Gname        varchar(30) not null
        primary key,
    No_of_member int         null comment '[1, 20] ',
    Guest_ID     int         null,
    constraint Group_invitedguest_null_fk
        foreign key (Guest_ID) references invitedguest (Guest_ID),
    constraint `check number member`
        check ((`No_of_member` >= 1) and (`No_of_member` <= 20))
);

create table groupsignaturesong
(
    Gname     varchar(30) not null,
    song_name varchar(30) not null,
    primary key (Gname, song_name),
    constraint groupsignaturesong_group_null_fk
        foreign key (Gname) references `group` (Gname)
);

create table mentor
(
    SSN varchar(12) not null
        primary key
);

create table person
(
    SSN     varchar(12)  not null comment ' 12 digit number'
        primary key,
    Phone   varchar(30)  not null comment 'Unique and not null',
    Fname   varchar(20)  null,
    Lname   varchar(20)  not null,
    Address varchar(255) null,
    constraint Phone
        unique (Phone)
);

create table mc
(
    SSN varchar(12) not null comment '12 digit'
        primary key,
    constraint MC_person_null_fk
        foreign key (SSN) references person (SSN)
);

create table producer
(
    SSN varchar(12) not null comment 'SSN'
        primary key,
    constraint producer_mentor_null_fk
        foreign key (SSN) references mentor (SSN)
);

create table producerprogram
(
    Program_name varchar(30) not null,
    SSN          varchar(12) not null,
    primary key (SSN, Program_name),
    constraint ProducerProgram_producer_null_fk
        foreign key (SSN) references producer (SSN)
);

create table singer
(
    Guest_ID int         null,
    SSN      varchar(12) not null
        primary key,
    constraint SINGER_invitedguest_null_fk
        foreign key (Guest_ID) references invitedguest (Guest_ID),
    constraint SINGER_mentor_null_fk
        foreign key (SSN) references mentor (SSN)
);

create table singersignaturesong
(
    Song_name varchar(30) not null,
    SSN       varchar(12) not null,
    primary key (SSN, Song_name),
    constraint singersignaturesong_singer_null_fk
        foreign key (SSN) references singer (SSN)
);

create table song
(
    Number                    int auto_increment comment ' S[auto increment integer] '
        primary key,
    Released_year             year        null,
    Name                      varchar(30) null,
    Singer_SSN_fist_performed varchar(12) null,
    constraint Song_singer_null_fk
        foreign key (Singer_SSN_fist_performed) references singer (SSN)
);

create table songwriter
(
    SSN varchar(12) not null comment 'Mentor'
        primary key,
    constraint Songwriter_mentor_null_fk
        foreign key (SSN) references mentor (SSN)
);

create table songcomposedby
(
    composer_SSN varchar(12) not null comment 'SSN of Songwritter',
    Song_ID      int         not null,
    primary key (Song_ID, composer_SSN),
    constraint Songcomposedby_song_null_fk
        foreign key (Song_ID) references song (Number),
    constraint songcomposedby_songwriter_null_fk
        foreign key (composer_SSN) references songwriter (SSN)
);

create table stage
(
    Year       year       not null,
    Ep_No      int        not null,
    Stage_No   int        not null,
    is_Group   tinyint(1) null comment 'Yes: group stage, No: individual stage',
    Skill      int        null comment ' 1 – vocal, 2 – rap, 3 – dance, 4 – mixed (default value)',
    Total_vote int        null,
    Song_ID    int        null,
    primary key (Year, Ep_No, Stage_No),
    constraint Stage_episode_null_null_fk
        foreign key (Year, Ep_No) references episode (Year, No),
    constraint Stage_song_null_fk
        foreign key (Song_ID) references song (Number)
);

create table guestsupportstage
(
    Guest_ID int  null,
    Year     year not null,
    Ep_No    int  not null,
    Stage_No int  not null,
    primary key (Year, Ep_No, Stage_No),
    constraint GuestSupportStage_invitedguest_null_fk
        foreign key (Guest_ID) references invitedguest (Guest_ID),
    constraint GuestSupportStage_stage_null_null_null_fk
        foreign key (Year, Ep_No, Stage_No) references stage (Year, Ep_No, Stage_No)
);

create table stageincludetrainee
(
    Year        year        not null,
    Ep_No       int         not null,
    Stage_No    int         not null,
    SSN_Trainee varchar(12) not null,
    Role        int         null comment '1 – member (default), 2 – leader, 3 – center',
    No_of_Vote  int         null comment ' [0, 500]',
    primary key (Ep_No, Year, Stage_No, SSN_Trainee),
    constraint StageIncludeTrainee_stage_null_null_null_fk
        foreign key (Year, Ep_No, Stage_No) references stage (Year, Ep_No, Stage_No),
    constraint `check number of vote`
        check ((`No_of_Vote` >= 0) and (`No_of_Vote` <= 500))
);
create table themesong
(
    Song_ID int not null
        primary key,
    constraint ThemeSong_song_null_fk
        foreign key (Song_ID) references song (Number)
);

create table season
(
    Year         year         not null
        primary key,
    Themesong_ID int          null,
    MC_SSN       varchar(12)  null,
    Location     varchar(100) not null,
    constraint Season_mc_null_fk
        foreign key (MC_SSN) references mc (SSN),
    constraint Season_themesong_null_fk
        foreign key (Themesong_ID) references themesong (Song_ID)
);

create table seasonmentor
(
    Year       year        not null,
    SSN_Mentor varchar(12) not null,
    primary key (Year, SSN_Mentor),
    constraint SeasonMentor_mentor_null_fk
        foreign key (SSN_Mentor) references mentor (SSN),
    constraint SeasonMentor_season_null_fk
        foreign key (Year) references season (Year)
);

create table trainee
(
    SSN        varchar(12) not null comment '12 digits'
        primary key,
    DoB        date        null,
    Photo      text        null comment 'url',
    Company_ID varchar(4)  null,
    constraint TRAINEE_company_null_fk
        foreign key (Company_ID) references company (Cnumber),
    constraint TRAINEE_person_null_fk
        foreign key (SSN) references person (SSN)
);

create table mentorvaluatetrainee
(
    Year        year        not null,
    SSN_Trainee varchar(12) not null,
    SSN_Mentor  varchar(12) not null,
    Score       int         null comment 'in range of [0-100]',
    primary key (Year, SSN_Trainee, SSN_Mentor),
    constraint MentorValuateTrainee_mentor_null_fk
        foreign key (SSN_Mentor) references mentor (SSN),
    constraint MentorValuateTrainee_season_null_fk
        foreign key (Year) references season (Year),
    constraint MentorValuateTrainee_trainee_null_fk
        foreign key (SSN_Trainee) references trainee (SSN),
    constraint check_name
        check ((`Score` >= 0) and (`Score` <= 100))
);

create table average
(
    SSN_trainee  varchar(12) not null
        primary key,
    AverageScore int         null,
    VoteEp2      int         null,
    VoteEp3      int         null,
    Year         year        not null,
    VoteEp4      int         null,
    VoteEp5      int         null,
    constraint average_mentorvaluatetrainee_null_fk
        foreign key (SSN_trainee) references mentorvaluatetrainee (SSN_Trainee),
    constraint CheckVoteEp2
        check ((`VoteEp2` >= 0) and (`VoteEp2` <= 500)),
    constraint CheckVoteEp3
        check ((`VoteEp3` >= 0) and (`VoteEp3` <= 500)),
    constraint average
        check ((`AverageScore` >= 0) and (`AverageScore` <= 100))
);
create table seasontrainee
(
    Year        year        not null,
    SSN_Trainee varchar(12) not null,
    primary key (Year, SSN_Trainee),
    constraint SeasonTrainee_season_null_fk
        foreign key (Year) references season (Year),
    constraint SeasonTrainee_trainee_null_fk
        foreign key (SSN_Trainee) references trainee (SSN)
);

create trigger debutNightCheck
    before insert
    on seasontrainee
    for each row
begin
    -- missing source code
end;

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


Drop procedure if exists getPassTraineeEpN;
DELIMITER $$
CREATE PROCEDURE getPassTraineeEpN
(IN year YEAR, IN episode INT)
BEGIN
    DECLARE firstlose int default 0;
    DECLARE secondlose int default 0;
    set firstlose = (SELECT Stage_No from stage WHERE Ep_No = 3 AND stage.Year = year ORDER BY Total_vote ASC LIMIT 0,1);
    set secondlose = (SELECT Stage_No from stage WHERE Ep_No = 3 AND stage.Year = year ORDER BY Total_vote ASC LIMIT 1,1);
    if episode = 1 then
        SELECT SSN_Trainee, AverageScore FROM average WHERE average.Year = year ORDER BY AverageScore DESC LIMIT 0,30;
    end if;
    if episode = 2 then
        SELECT SSN_Trainee, No_of_Vote from stageincludetrainee WHERE Ep_No = 2 AND stageincludetrainee.Year = year
                                                                ORDER BY No_of_Vote DESC LIMIT 0, 20;
    end if;
    if episode = 3 then
        SELECT SSN_Trainee, No_of_Vote from stageincludetrainee
        WHERE Ep_No = 3 AND stageincludetrainee.Year = year
        AND SSN_Trainee != (SELECT SSN_Trainee from stageincludetrainee
                            WHERE Stage_No = firstlose
                              AND stageincludetrainee.Year = year
                              AND Ep_No = 3
                            ORDER BY No_of_Vote ASC LIMIT 0,1)
          AND SSN_Trainee != (SELECT SSN_Trainee from stageincludetrainee
                              WHERE Stage_No = firstlose
                                AND stageincludetrainee.Year = year
                                AND Ep_No = 3
                              ORDER BY No_of_Vote ASC LIMIT 1,1)
          AND SSN_Trainee != (SELECT SSN_Trainee from stageincludetrainee
                              WHERE Stage_No = secondlose
                                AND stageincludetrainee.Year = year
                                AND Ep_No = 3
                              ORDER BY No_of_Vote ASC LIMIT 0,1)
          AND SSN_Trainee != (SELECT SSN_Trainee from stageincludetrainee
                              WHERE Stage_No = secondlose
                                AND stageincludetrainee.Year = year
                                AND Ep_No = 3
                              ORDER BY No_of_Vote ASC LIMIT 1,1);
    end if;
    if episode = 4 then
        SELECT SSN_Trainee, No_of_Vote from stageincludetrainee WHERE Ep_No = 4 AND stageincludetrainee.Year = year
        ORDER BY No_of_Vote DESC LIMIT 0, 10;
    end if;
    if episode = 5 then
        SELECT SSN_Trainee, VoteEp5 as 'Debut(Total vote in ep5)' from average WHERE average.Year = year
        ORDER BY VoteEp5 DESC LIMIT 0, 5;
    end if;
end $$
delimiter ;

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

Drop procedure if exists  getPassTraineeEpN;
DELIMITER $$
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
end $$
DELIMITER ;

