create table song
(
    Number                    int auto_increment comment ' S[auto increment integer] '
        primary key,
    Released_year             year        null,
    Name                      varchar(30) null,
    Singer_SSN_fist_performed varchar(12) null,
    constraint Song_singer_null_fk
        foreign key (Singer_SSN_fist_performed) references singer (SSN)
);

