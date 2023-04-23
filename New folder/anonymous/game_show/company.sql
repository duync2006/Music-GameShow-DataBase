create table company
(
    Cnumber varchar(4)  not null comment 'C[0-9][0-9][0-9]'
        primary key,
    Name    varchar(30) not null,
    Address varchar(50) null,
    Phone   varchar(30) not null,
    Edate   date        null,
    constraint COMPANY_pk
        unique (Phone)
);

