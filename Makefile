.PHONY: infra start stop pipeline dbt-run dbt-test help

help:
	@echo "Available commands:"
	@echo "  make infra      - provision GCP infrastructure with Terraform"
	@echo "  make start      - start Kestra locally"
	@echo "  make stop       - stop Kestra"
	@echo "  make pipeline   - run dlt pipeline locally"
	@echo "  make dbt-run    - run dbt models"
	@echo "  make dbt-test   - run dbt tests"
	@echo "  make destroy    - destroy Terraform infrastructure"

infra:
	cd terraform && terraform init && terraform apply -auto-approve

destroy:
	cd terraform && terraform destroy -auto-approve

start:
	docker-compose up -d
	@echo "Kestra UI: http://localhost:8080"

stop:
	docker-compose down

pipeline:
	python main.py

dbt-run:
	dbt run

dbt-test:
	dbt test

all: infra start