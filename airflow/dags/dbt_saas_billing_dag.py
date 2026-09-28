from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

DBT_PROJECT_DIR = "/opt/airflow/dbt/saas_billing"
DBT_PROFILES_DIR = "/opt/airflow/dbt"

with DAG(
    dag_id="dbt_saas_billing",
    start_date=datetime(2026, 1, 1),
    schedule=None,  # run manually for now, add a schedule later once it works
    catchup=False,
) as dag:

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"dbt run --project-dir {DBT_PROJECT_DIR} --profiles-dir {DBT_PROFILES_DIR}",
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"dbt test --project-dir {DBT_PROJECT_DIR} --profiles-dir {DBT_PROFILES_DIR}",
    )

    dbt_run >> dbt_test