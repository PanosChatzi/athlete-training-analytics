{{ config(materialized='table') }}

select
    week_start,
    activity_category,
    activity_type,
    athlete_name,

    count(*)                                    as activity_count,
    round(sum(moving_time_hours), 2)            as total_hours,
    round(sum(distance_km), 2)                  as total_km,
    round(sum(elevation_gain_m), 0)             as total_elevation_m,
    round(sum(trimp_calculated), 1)             as total_trimp,
    round(avg(intensity_factor), 1)             as avg_intensity,
    round(sum(calories), 0)                     as total_calories,
    round(avg(avg_hr), 1)                       as avg_hr,
    round(avg(fitness), 2)                      as avg_fitness,
    round(avg(fatigue), 2)                      as avg_fatigue

from {{ ref('fct_activities') }}
group by 1, 2, 3, 4
order by week_start desc, activity_category