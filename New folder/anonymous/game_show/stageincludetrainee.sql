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

