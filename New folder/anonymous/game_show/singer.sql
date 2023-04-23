create table singer
(
    Guest_ID int         null,
    SSN      varchar(12) not null
        primary key,
    constraint SINGER_invitedguest_null_fk
        foreign key (Guest_ID) references invitedguest (Guest_ID),
    constraint SINGER_mentor_null_fk
        foreign key (SSN) references mentor (SSN)
);

