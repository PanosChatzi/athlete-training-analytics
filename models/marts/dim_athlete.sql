select distinct
    athlete_id,
    athlete_name,
    round(avg(athlete_weight_kg) over (partition by athlete_id), 1)   as avg_weight_kg,
    max(lactate_threshold_hr) over (partition by athlete_id)          as lactate_threshold_hr,
    min(resting_hr) over (partition by athlete_id)                    as min_resting_hr,
    max(hr_max) over (partition by athlete_id)                        as max_hr

from {{ ref('stg_activities') }}