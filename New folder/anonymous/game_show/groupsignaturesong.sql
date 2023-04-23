create table groupsignaturesong
(
    Gname     varchar(30) not null,
    song_name varchar(30) not null,
    primary key (Gname, song_name),
    constraint groupsignaturesong_group_null_fk
        foreign key (Gname) references `group` (Gname)
);

