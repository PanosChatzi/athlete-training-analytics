{#
    Macro to map activity_type to a higher-level activity_category.
    Uses a Jinja dictionary to generate a CASE statement at compile time.
    Works seamlessly across BigQuery, DuckDB, Snowflake etc.

    Usage: {{ get_activity_category('activity_type') }}
    Returns: SQL CASE expression mapping activity_type to category
#}
{% macro get_activity_category(activity_type_column) %}
{% set activity_categories = {
    'Run':            'Cardio',
    'VirtualRun':     'Cardio',
    'Ride':           'Cardio',
    'VirtualRide':    'Cardio',
    'Swim':           'Cardio',
    'Walk':           'Recovery',
    'Hike':           'Recovery',
    'WeightTraining': 'Strength',
    'Workout':        'Strength',
    'Yoga':           'Recovery'
} %}
case {{ activity_type_column }}
    {% for activity_type, category in activity_categories.items() %}
    when '{{ activity_type }}' then '{{ category }}'
    {% endfor %}
    else 'Other'
end
{% endmacro %}