{{ config(materialized='table') }}

select
    activity_type,
    activity_category,
    athlete_name,

    count(*)                                    as total_activities,
    round(sum(moving_time_hours), 2)            as total_hours,
    round(sum(distance_km), 2)                  as total_km,
    round(avg(moving_time_min), 1)              as avg_duration_min,
    round(avg(avg_hr), 1)                       as avg_hr,
    round(avg(intensity_factor), 1)             as avg_intensity,
    round(sum(trimp_calculated), 1)             as total_trimp,
    round(sum(calories), 0)                     as total_calories

from {{ ref('fct_activities') }}
group by 1, 2, 3
order by total_hours desc