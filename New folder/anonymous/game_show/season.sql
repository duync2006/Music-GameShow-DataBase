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

