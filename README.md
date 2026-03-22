# Athlete Training Analytics


## 🎯 Problem
**Athletes and coaches need to understand training patterns, adherence to planned workouts, and load distribution across modalities (Run, Walk, Strength) to optimize performance and prevent overtraining.**

Raw training data from Intervals.icu (activities and planned events) is scattered across APIs. This pipeline ingests, cleans, and transforms it into an analytics warehouse with a dashboard showing:
- **Distribution of training time by activity type** (categorical).  
- **Weekly training load over time** (temporal).

**Business value**: Compare planned vs. actual training across multiple athletes, identify imbalances (e.g., too much running, insufficient strength), and track progression.

## 🏗️ Architecture
Intervals.icu API (Activities/Events)
↓ (Kestra)
GCS Lake (bronze/raw)
↓ (External tables)
BigQuery (bronze → silver → gold)
↓ (dbt Cloud)
Looker Studio Dashboard ← fact_weekly_training


**Bronze**: Raw API responses in GCS/BigQuery.  
**Silver**: Cleaned activities/events with quality checks.  
**Gold**: Weekly aggregates by sport/athlete for dashboard.

## 🛠️ Tech Stack
[![Python](https://img.shields.io/badge/language-Python-blue)](https://python.org) [![Docker](https://img.shields.io/badge/container-Docker-blue)](https://www.docker.com) [![Terraform](https://img.shields.io/badge/IaC-Terraform-purple)](https://www.terraform.io) [![GCP](https://img.shields.io/badge/cloud-GCP-orange)](https://cloud.google.com) [![BigQuery](https://img.shields.io/badge/warehouse-BigQuery-orange)](https://cloud.google.com/bigquery) [![Kestra](https://img.shields.io/badge/orchestration-Kestra-purple)](https://kestra.io) [![dbt](https://img.shields.io/badge/transform-dbt-brightgreen)](https://getdbt.com)

| Layer | Technology |
|-------|------------|
| IaC | Terraform |
| Orchestration | Kestra |
| Data Lake | Google Cloud Storage |
| Data Warehouse | BigQuery (partitioned by date, clustered by sport) |
| Transformations | dbt Cloud (+ tests) |
| Dashboard | Looker Studio |

## 🚀 Quick Start (Local)

1. **Prerequisites**: GCP project, Intervals.icu API key(s).
2. **Infra**:
   ```bash
   cd terraform
   terraform init && terraform apply
3. **Local Dev**:
`docker-compose up -d  # Kestra UI: localhost:8080`
4. **Run pipeline**: Upload Kestra flows → execute ingest_athlete → view dashboard.

## 📊 Dashboard
Tile 1 (Categorical): Training time by activity type (Run/Walk/Strength).
Tile 2 (Temporal): Weekly training duration/load over time.

[TODO: Add link here]

## 🧪 Data Quality
dbt tests ensure:

No negative durations/distances.

Valid sports (run, walk, strength).

Training load in realistic ranges.

## 🔄 Peer Review
1. Clone repo → follow Quick Start.
2. Verify: GCS populated → BQ tables → dashboard loads.
3. Check: 2 tiles work, tests pass.

## 🙏 Acknowledgments
Built for Data Engineering Zoomcamp by DataTalks.Club.
