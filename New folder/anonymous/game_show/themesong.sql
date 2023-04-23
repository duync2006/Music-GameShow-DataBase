create table themesong
(
    Song_ID int not null
        primary key,
    constraint ThemeSong_song_null_fk
        foreign key (Song_ID) references song (Number)
);

