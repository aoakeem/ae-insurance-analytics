{#
  Date dimension from 2018-01-01 through 2028-12-31.
  One row per calendar day via dbt_utils.date_spine.
#}

with

date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2018-01-01' as date)",
        end_date="cast('2029-01-01' as date)"
    ) }}

),

final as (

    select
        cast(date_day as date)                     as date_day,

        extract(year   from date_day)              as year_number,
        extract(quarter from date_day)             as quarter_number,
        extract(month  from date_day)              as month_number,
        strftime(date_day, '%B')                   as month_name,
        extract(day    from date_day)              as day_of_month,
        extract(doy    from date_day)              as day_of_year,
        extract(dow    from date_day)              as day_of_week,
        strftime(date_day, '%A')                   as day_name,
        extract(week   from date_day)              as week_of_year,

        case
            when extract(dow from date_day) in (0, 6) then true
            else false
        end                                        as is_weekend,

        cast(strftime(date_day, '%Y-%m') as varchar)   as year_month,
        cast(strftime(date_day, '%Y-Q') || extract(quarter from date_day) as varchar) as year_quarter

    from date_spine

)

select * from final
