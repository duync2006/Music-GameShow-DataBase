create table singersignaturesong
(
    Song_name varchar(30) not null,
    SSN       varchar(12) not null,
    primary key (SSN, Song_name),
    constraint singersignaturesong_singer_null_fk
        foreign key (SSN) references singer (SSN)
);

