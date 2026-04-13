SELECT
    -- identifiers
    _id                                             AS activity_id,
    external_id,
    _dlt_id                                         AS dlt_id,

    -- athlete
    'i254220'               AS athlete_id,
    'Dimitris Choutopoulos'  AS athlete_name,

    -- timestamps (already correct types, no cast needed)
    start_date_local,
    start_date                                      AS start_date_utc,
    icu_sync_date,

    -- activity metadata
    name                                            AS activity_name,
    type                                            AS activity_type,
    sub_type                                        AS activity_sub_type,
    file_type,
    timezone,
    description,
    gear,
    compliance,

    -- boolean flags (already BOOL, no cast needed)
    trainer,
    commute,
    race,
    has_heartrate,
    device_watts,
    icu_ignore_power,
    icu_ignore_hr,
    icu_ignore_time,

    -- duration & distance
    moving_time                                     AS moving_time_sec,
    elapsed_time                                    AS elapsed_time_sec,
    icu_recording_time                              AS recording_time_sec,
    icu_warmup_time                                 AS warmup_time_sec,
    icu_cooldown_time                               AS cooldown_time_sec,
    distance                                        AS distance_m,
    total_elevation_gain                            AS elevation_gain_m,

    -- speed & pacing
    average_speed                                   AS avg_speed_mps,
    max_speed                                       AS max_speed_mps,
    pace                                            AS pace_sec_per_m,
    average_cadence                                 AS avg_cadence,

    -- heart rate summary
    average_heartrate                               AS avg_hr,
    max_heartrate                                   AS max_hr,
    hr_max,
    icu_resting_hr                                  AS resting_hr,
    lthr                                            AS lactate_threshold_hr,

    -- heart rate zones (bpm boundaries)
    hr_z1, hr_z2, hr_z3, hr_z4, hr_z5, hr_z6,

    -- heart rate time in zones (seconds)
    hr_load,
    hr_z1_secs, hr_z2_secs, hr_z3_secs,
    hr_z4_secs, hr_z5_secs, hr_z6_secs, hr_z7_secs,

    -- power (STRING in BQ because all null — use SAFE_CAST)
    SAFE_CAST(icu_average_watts AS FLOAT64)         AS avg_watts,
    SAFE_CAST(icu_normalized_watts AS FLOAT64)      AS normalized_watts,
    SAFE_CAST(icu_joules AS FLOAT64)                AS total_joules,
    SAFE_CAST(icu_training_load_edited AS FLOAT64)  AS trimp_edited,
    SAFE_CAST(icu_ftp AS FLOAT64)                   AS ftp,
    SAFE_CAST(power_load AS FLOAT64)                AS power_load,

    -- training load & intensity
    icu_intensity                                   AS intensity_factor,
    icu_training_load                               AS training_load,
    icu_rpe                                         AS rpe,
    icu_fatigue                                     AS fatigue,
    icu_fitness                                     AS fitness,
    calories,

    -- recovery & physiology
    icu_hrrc                                        AS hrrc,
    icu_hrrc_start_bpm                              AS hrrc_start_bpm,
    icu_weight                                      AS athlete_weight_kg,

    -- dlt metadata
    _dlt_load_id                                    AS dlt_load_id

FROM {{ source("raw_data", "activities") }}

WHERE _id IS NOT NULL