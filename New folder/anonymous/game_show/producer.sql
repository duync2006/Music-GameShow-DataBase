create table producer
(
    SSN varchar(12) not null comment 'SSN'
        primary key,
    constraint producer_mentor_null_fk
        foreign key (SSN) references mentor (SSN)
);

