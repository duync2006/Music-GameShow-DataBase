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

