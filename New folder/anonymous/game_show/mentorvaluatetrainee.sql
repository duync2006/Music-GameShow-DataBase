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

