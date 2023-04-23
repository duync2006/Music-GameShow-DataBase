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

