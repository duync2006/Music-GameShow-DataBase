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

