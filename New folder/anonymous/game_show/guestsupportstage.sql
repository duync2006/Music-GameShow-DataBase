create table guestsupportstage
(
    Guest_ID int  null,
    Year     year not null,
    Ep_No    int  not null,
    Stage_No int  not null,
    primary key (Year, Ep_No, Stage_No),
    constraint GuestSupportStage_invitedguest_null_fk
        foreign key (Guest_ID) references invitedguest (Guest_ID),
    constraint GuestSupportStage_stage_null_null_null_fk
        foreign key (Year, Ep_No, Stage_No) references stage (Year, Ep_No, Stage_No)
);

