{% macro calculate_trimp(avg_hr, resting_hr, hr_max, moving_time_sec) %}
case
    when {{ hr_max }} > {{ resting_hr }}
     and {{ avg_hr }} is not null
     and {{ resting_hr }} is not null
    then cast(
        round(
            ({{ moving_time_sec }} / 60.0)
            * (({{ avg_hr }} - {{ resting_hr }}) / nullif(cast({{ hr_max }} - {{ resting_hr }} as float64), 0))
            * 0.64
            * exp(
                1.92
                * (({{ avg_hr }} - {{ resting_hr }}) / nullif(cast({{ hr_max }} - {{ resting_hr }} as float64), 0))
            ),
        0)
    as int64)
    else null
end
{% endmacro %}