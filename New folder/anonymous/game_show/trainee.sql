create table trainee
(
    SSN        varchar(12) not null comment '12 digits'
        primary key,
    DoB        date        null,
    Photo      text        null comment 'url',
    Company_ID varchar(4)  null,
    constraint TRAINEE_company_null_fk
        foreign key (Company_ID) references company (Cnumber),
    constraint TRAINEE_person_null_fk
        foreign key (SSN) references person (SSN)
);

