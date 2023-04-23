create table person
(
    SSN     varchar(12)  not null comment ' 12 digit number'
        primary key,
    Phone   varchar(30)  not null comment 'Unique and not null',
    Fname   varchar(20)  null,
    Lname   varchar(20)  not null,
    Address varchar(255) null,
    constraint Phone
        unique (Phone)
);

