create table `group`
(
    Gname        varchar(30) not null
        primary key,
    No_of_member int         null comment '[1, 20] ',
    Guest_ID     int         null,
    constraint Group_invitedguest_null_fk
        foreign key (Guest_ID) references invitedguest (Guest_ID),
    constraint `check number member`
        check ((`No_of_member` >= 1) and (`No_of_member` <= 20))
);

