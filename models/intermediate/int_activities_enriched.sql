with source as (
    select * from {{ ref('stg_activities') }}
),

enriched as (
    select
        *,

        -- date dimensions
        date(start_date_local)                              as activity_date,
        date_trunc(date(start_date_local), week(monday))    as week_start,
        date_trunc(date(start_date_local), month)           as month_start,
        extract(year from start_date_local)                 as activity_year,
        extract(month from start_date_local)                as activity_month,
        extract(dayofweek from start_date_local)            as day_of_week,

        -- unit conversions
        round(moving_time_sec / 60.0, 2)                    as moving_time_min,
        round(moving_time_sec / 3600.0, 3)                  as moving_time_hours,
        round(distance_m / 1000.0, 3)                       as distance_km,
        round(
            case
                when distance_m > 0
                then (moving_time_sec / 60.0) / (distance_m / 1000.0)
                else null
            end, 2
        )                                                   as pace_min_per_km,

        -- TRIMP macro calculation (Banister exponential, scaled 0.64 for males)
        -- formula: D(min) * HRr * 0.64 * EXP(1.92 * HRr)
        -- where HRr = (HRex - HRrest) / (HRmax - HRrest)
        -- ref: https://forum.intervals.icu/t/trimp-formula-required/68634/5
        {{ calculate_trimp('avg_hr', 'resting_hr', 'hr_max', 'moving_time_sec') }} as trimp_calculated,
        
        -- activity category (groups similar types)
        {{ get_activity_category('activity_type') }} as activity_category

    from source
)

select * from enriched