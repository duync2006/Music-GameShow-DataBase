create table episode
(
    Year     year     not null,
    No       int      not null comment '[1-5]',
    Datetime datetime null,
    Duration time     null,
    primary key (Year, No),
    constraint `check episode number`
        check ((`No` >= 1) and (`No` <= 5))
);

