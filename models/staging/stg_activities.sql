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
    SAFE_CAST(moving_time AS INT64)                         AS moving_time_sec,
    SAFE_CAST(elapsed_time AS INT64)                        AS elapsed_time_sec,
    SAFE_CAST(icu_recording_time AS INT64)                  AS recording_time_sec,
    SAFE_CAST(icu_warmup_time AS INT64)                     AS warmup_time_sec,
    SAFE_CAST(icu_cooldown_time AS INT64)                   AS cooldown_time_sec,
    SAFE_CAST(distance AS FLOAT64)                          AS distance_m,
    SAFE_CAST(total_elevation_gain AS FLOAT64)              AS elevation_gain_m,

    -- speed & pacing
    SAFE_CAST(average_speed AS FLOAT64)                     AS avg_speed_mps,
    SAFE_CAST(max_speed AS FLOAT64)                         AS max_speed_mps,
    SAFE_CAST(pace AS FLOAT64)                              AS pace_sec_per_m,
    SAFE_CAST(average_cadence AS FLOAT64)                   AS avg_cadence,

-- heart rate
    SAFE_CAST(average_heartrate AS INT64)                   AS avg_hr,
    SAFE_CAST(max_heartrate AS INT64)                       AS max_hr,
    SAFE_CAST(hr_max AS INT64)                              AS hr_max,
    SAFE_CAST(icu_resting_hr AS INT64)                      AS resting_hr,
    SAFE_CAST(lthr AS INT64)                                AS lactate_threshold_hr,

    -- heart rate zones
    SAFE_CAST(hr_z1 AS INT64)                               AS hr_z1,
    SAFE_CAST(hr_z2 AS INT64)                               AS hr_z2,
    SAFE_CAST(hr_z3 AS INT64)                               AS hr_z3,
    SAFE_CAST(hr_z4 AS INT64)                               AS hr_z4,
    SAFE_CAST(hr_z5 AS INT64)                               AS hr_z5,
    SAFE_CAST(hr_z6 AS INT64)                               AS hr_z6,
    SAFE_CAST(hr_load AS INT64)                             AS hr_load,
    SAFE_CAST(hr_z1_secs AS INT64)                          AS hr_z1_secs,
    SAFE_CAST(hr_z2_secs AS INT64)                          AS hr_z2_secs,
    SAFE_CAST(hr_z3_secs AS INT64)                          AS hr_z3_secs,
    SAFE_CAST(hr_z4_secs AS INT64)                          AS hr_z4_secs,
    SAFE_CAST(hr_z5_secs AS INT64)                          AS hr_z5_secs,
    SAFE_CAST(hr_z6_secs AS INT64)                          AS hr_z6_secs,
    SAFE_CAST(hr_z7_secs AS INT64)                          AS hr_z7_secs,

    -- training load
    SAFE_CAST(icu_intensity AS FLOAT64)                     AS intensity_factor,
    SAFE_CAST(icu_training_load AS INT64)                   AS trimp,
    SAFE_CAST(icu_rpe AS INT64)                             AS rpe,
    SAFE_CAST(icu_fatigue AS FLOAT64)                       AS fatigue,
    SAFE_CAST(icu_fitness AS FLOAT64)                       AS fitness,
    SAFE_CAST(calories AS FLOAT64)                          AS calories,

    -- recovery
    SAFE_CAST(icu_hrrc AS INT64)                            AS hrrc,
    SAFE_CAST(icu_hrrc_start_bpm AS INT64)                  AS hrrc_start_bpm,
    SAFE_CAST(icu_weight AS FLOAT64)                        AS athlete_weight_kg,

    -- power (STRING in BQ because all null — use SAFE_CAST)
    SAFE_CAST(icu_average_watts AS FLOAT64)         AS avg_watts,
    SAFE_CAST(icu_normalized_watts AS FLOAT64)      AS normalized_watts,
    SAFE_CAST(icu_joules AS FLOAT64)                AS total_joules,
    SAFE_CAST(icu_training_load_edited AS FLOAT64)  AS trimp_edited,
    SAFE_CAST(icu_ftp AS FLOAT64)                   AS ftp,
    SAFE_CAST(power_load AS FLOAT64)                AS power_load,

    -- dlt metadata
    _dlt_load_id                                    AS dlt_load_id

FROM {{ source("raw_data", "activities") }}

WHERE _id IS NOT NULL