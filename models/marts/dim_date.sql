with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2025-01-01' as date)",
        end_date="cast('2026-12-31' as date)"
    ) }}
),

dates as (
    select
        cast(date_day as date)                                  as date_id,
        cast(date_day as date)                                  as full_date,

        -- year / month / day
        extract(year from date_day)                             as year,
        extract(month from date_day)                            as month,
        extract(day from date_day)                              as day_of_month,

        -- week
        extract(week from date_day)                             as week_of_year,
        extract(dayofweek from date_day)                        as day_of_week_num,
        format_date('%A', date_day)                             as day_of_week_name,
        date_trunc(cast(date_day as date), week(monday))        as week_start,
        date_trunc(cast(date_day as date), month)               as month_start,
        date_trunc(cast(date_day as date), year)                as year_start,

        -- quarter
        extract(quarter from date_day)                          as quarter,
        concat(
            cast(extract(year from date_day) as string),
            '/Q',
            cast(extract(quarter from date_day) as string)
        )                                                       as year_quarter,

        -- month name
        format_date('%B', date_day)                             as month_name,
        format_date('%b', date_day)                             as month_short,

        -- flags
        case
            when extract(dayofweek from date_day) in (1, 7)
            then true else false
        end                                                     as is_weekend

    from date_spine
)

select * from dates