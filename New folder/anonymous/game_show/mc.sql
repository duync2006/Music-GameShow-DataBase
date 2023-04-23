create table mc
(
    SSN varchar(12) not null comment '12 digit'
        primary key,
    constraint MC_person_null_fk
        foreign key (SSN) references person (SSN)
);

