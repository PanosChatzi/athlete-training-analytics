"""dlt pipeline to ingest athlete training data from Intervals.icu REST API.

Configure credentials in .dlt/secrets.toml:

    [sources.intervals_icu_source]
    athlete_id = "iXXXXXX"   # your Intervals.icu athlete ID (e.g. i236215)
    api_key    = "xxxx..."    # your API key from intervals.icu/settings

Optional date range can be passed at call-time; defaults to all data since 2020-01-01.
"""

import base64
import csv
import io

import dlt
import requests
from dlt.sources.rest_api import rest_api_resources
from dlt.sources.rest_api.typing import RESTAPIConfig


@dlt.source
def intervals_icu_source(
    athlete_id: str = dlt.secrets.value,
    api_key: str = dlt.secrets.value,
    start_date: str = "2020-01-01",
    end_date: str = None,
):
    """Yields dlt resources for the Intervals.icu activities endpoints."""

    # ── JSON activities ────────────────────────────────────────────────────────
    config: RESTAPIConfig = {
        "client": {
            "base_url": "https://intervals.icu/api/v1/",
            # Basic Auth: username is the literal string "API_KEY",
            # password is your personal API key.
            "auth": {
                "type": "http_basic",
                "username": "API_KEY",
                "password": api_key,
            },
        },
        "resource_defaults": {
            "primary_key": "id",
            "write_disposition": "merge",
        },
        "resources": [
            {
                "name": "activities",
                "endpoint": {
                    "path": f"athlete/{athlete_id}/activities",
                    "params": {
                        "oldest": start_date,
                        **({"newest": end_date} if end_date else {}),
                    },
                },
            },
        ],
    }

    yield from rest_api_resources(config)

    # ── CSV activities ─────────────────────────────────────────────────────────
    yield activities_csv(
        athlete_id=athlete_id,
        api_key=api_key,
        start_date=start_date,
        end_date=end_date,
    )


@dlt.resource(name="activities_csv", write_disposition="replace")
def activities_csv(
    athlete_id: str,
    api_key: str,
    start_date: str = "2020-01-01",
    end_date: str = None,
):
    """Fetches activities.csv and yields one dict per row."""
    credentials = base64.b64encode(f"API_KEY:{api_key}".encode()).decode()
    url = f"https://intervals.icu/api/v1/athlete/{athlete_id}/activities.csv"
    params: dict = {"oldest": start_date}
    if end_date:
        params["newest"] = end_date

    response = requests.get(
        url,
        headers={
            "Authorization": f"Basic {credentials}",
            "Accept": "text/csv",
        },
        params=params,
    )
    response.raise_for_status()

    reader = csv.DictReader(io.StringIO(response.text))
    yield from reader


pipeline = dlt.pipeline(
    pipeline_name="athlete_pipeline",
    destination="duckdb",
    progress="log",
)


if __name__ == "__main__":
    load_info = pipeline.run(intervals_icu_source())
    print(load_info)  # noqa: T201
