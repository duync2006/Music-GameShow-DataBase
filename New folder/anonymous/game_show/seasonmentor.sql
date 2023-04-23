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

