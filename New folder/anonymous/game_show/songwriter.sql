create table songwriter
(
    SSN varchar(12) not null comment 'Mentor'
        primary key,
    constraint Songwriter_mentor_null_fk
        foreign key (SSN) references mentor (SSN)
);

