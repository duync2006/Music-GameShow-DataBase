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

