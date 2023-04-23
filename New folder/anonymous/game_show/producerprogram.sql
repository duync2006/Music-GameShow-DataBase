create table producerprogram
(
    Program_name varchar(30) not null,
    SSN          varchar(12) not null,
    primary key (SSN, Program_name),
    constraint ProducerProgram_producer_null_fk
        foreign key (SSN) references producer (SSN)
);

