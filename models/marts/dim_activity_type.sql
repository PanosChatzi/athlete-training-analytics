with activity_types as (
    select distinct
        activity_type
    from {{ ref('int_activities_enriched') }}
),

with_category as (
    select
        {{ dbt_utils.generate_surrogate_key(['activity_type']) }}    as activity_type_id,
        activity_type,

        case activity_type
            when 'Run'              then 'Cardio'
            when 'VirtualRun'       then 'Cardio'
            when 'Ride'             then 'Cardio'
            when 'VirtualRide'      then 'Cardio'
            when 'Swim'             then 'Cardio'
            when 'Walk'             then 'Recovery'
            when 'Hike'             then 'Recovery'
            when 'WeightTraining'   then 'Strength'
            when 'Workout'          then 'Strength'
            when 'Yoga'             then 'Recovery'
            else                         'Other'
        end                                                         as activity_category,

        case activity_type
            when 'Run'              then 1
            when 'VirtualRun'       then 2
            when 'Ride'             then 3
            when 'VirtualRide'      then 4
            when 'Swim'             then 5
            when 'Walk'             then 6
            when 'Hike'             then 7
            when 'WeightTraining'   then 8
            when 'Workout'          then 9
            when 'Yoga'             then 10
            else                         99
        end                                                         as sort_order

    from activity_types
)

select * from with_category
order by sort_order