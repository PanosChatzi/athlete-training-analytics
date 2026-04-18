select
    activity_id,
    athlete_id,
    athlete_name,
    {{ dbt_utils.generate_surrogate_key(['activity_type']) }} as activity_type_id,
    activity_type,
    activity_sub_type,
    activity_category,
    activity_name,
    activity_date,
    week_start,
    month_start,
    activity_year,
    activity_month,
    day_of_week,
    start_date_local,
    start_date_utc,

    -- duration
    moving_time_sec,
    moving_time_min,
    moving_time_hours,
    elapsed_time_sec,
    recording_time_sec,
    warmup_time_sec,
    cooldown_time_sec,

    -- distance
    distance_m,
    distance_km,
    elevation_gain_m,

    -- pace & speed
    avg_speed_mps,
    max_speed_mps,
    pace_sec_per_m,
    pace_min_per_km,
    avg_cadence,

    -- heart rate
    avg_hr,
    max_hr,
    hr_max,
    resting_hr,
    lactate_threshold_hr,
    hr_load,
    hr_z1_secs, hr_z2_secs, hr_z3_secs,
    hr_z4_secs, hr_z5_secs, hr_z6_secs, hr_z7_secs,

    -- training load
    trimp,
    trimp_calculated,
    trimp_edited,
    intensity_factor,
    fatigue,
    fitness,
    rpe,
    calories,

    -- recovery
    hrrc,
    hrrc_start_bpm,
    athlete_weight_kg,

    -- power
    avg_watts,
    normalized_watts,
    total_joules,
    ftp,
    power_load,

    -- flags
    race,
    trainer,
    commute,
    has_heartrate,
    device_watts,
    icu_ignore_power,
    icu_ignore_hr,
    icu_ignore_time

from {{ ref('int_activities_enriched') }}