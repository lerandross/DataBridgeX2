import pandas as pd
from sqlalchemy import create_engine
import pymssql
import os
from sqlalchemy.exc import SQLAlchemyError
from google.cloud import bigquery
from google.oauth2 import service_account


def load_dataframe(
    destino: str,
    dataframe: pd.DataFrame,
    target_table: str,
    credenciais: dict,
    nome_banco: str = None,
    if_exists: str = "replace",
):
    """
    Carrega um DataFrame no destino especificado (SQL Server, PostgreSQL, MySQL, SQLite ou BigQuery).

    Args:
        destino (str): Destino para onde os dados serão carregados ('sqlserver', 'postgresql', 'mysql', 'sqlite', 'bigquery').
        dataframe (pd.DataFrame): O DataFrame a ser carregado.
        target_table (str): Nome da tabela de destino.
        credenciais (dict): Dicionário com as credenciais do banco de dados ou BigQuery.
            Para SQL Server: {'server': '...', 'user': '...', 'password': '...'}
            Para outros bancos: {'user': '...', 'password': '...', 'host': '...', 'port': '...'}
            Para BigQuery: {'project_id': '...', 'credentials_path': '...'}
        nome_banco (str, opcional): Nome do banco de dados (necessário para alguns tipos de destino).
        if_exists (str, opcional): Comportamento caso a tabela já exista ('fail', 'replace', 'append').

    Raises:
        ValueError: Se o destino for inválido ou os parâmetros forem insuficientes.
        Exception: Outros erros durante o processo de upload.
    """
    try:
        if destino.lower() == "sqlserver":
            if not credenciais.get("server"):
                raise ValueError("Credencial 'server' é obrigatória para SQL Server.")
            with pymssql.connect(
                server=credenciais["server"],
                user=credenciais["user"],
                password=credenciais["password"],
                database=nome_banco,
            ) as conn:
                cursor = conn.cursor()
                for index, row in dataframe.iterrows():
                    placeholders = ", ".join(["%s"] * len(row))
                    columns = ", ".join(row.index)
                    sql = f"INSERT INTO {target_table} ({columns}) VALUES ({placeholders})"
                    cursor.execute(sql, tuple(row))
                conn.commit()

        elif destino.lower() in ("postgresql", "mysql", "sqlite"):
            if destino.lower() == "postgresql":
                engine = create_engine(
                    f'postgresql://{credenciais["user"]}:{credenciais["password"]}@{credenciais["host"]}:{credenciais["port"]}/{nome_banco}'
                )
            elif destino.lower() == "mysql":
                engine = create_engine(
                    f'mysql+mysqlconnector://{credenciais["user"]}:{credenciais["password"]}@{credenciais["host"]}:{credenciais["port"]}/{nome_banco}?ssl_disabled=true'
                )
            elif destino.lower() == "sqlite":
                if not os.path.exists(nome_banco):
                    pass  # Arquivo SQLite não encontrado, pode ser criado aqui, se necessário.
                engine = create_engine(f"sqlite:///{nome_banco}")

            dataframe.to_sql(
                name=target_table, con=engine, if_exists=if_exists, index=False, chunksize=1000
            )

        elif destino.lower() == "bigquery":
            if not credenciais.get("project_id") or not credenciais.get("credentials_path"):
                raise ValueError("Credenciais 'project_id' e 'credentials_path' são obrigatórias para BigQuery.")

            credentials = service_account.Credentials.from_service_account_file(
                credenciais["credentials_path"]
            )
            client = bigquery.Client(project=credenciais["project_id"], credentials=credentials)

            job_config = bigquery.LoadJobConfig(
                autodetect=True,
                write_disposition="WRITE_TRUNCATE" if if_exists == "replace" else "WRITE_APPEND",
            )

            load_job = client.load_table_from_dataframe(
                dataframe, target_table, job_config=job_config
            )
            print("Carregando tabela no BigQuery...")
            load_job.result()
            table = client.get_table(target_table)
            print(f"Tabela carregada com sucesso: {table.num_rows} linhas.")

        else:
            raise ValueError(
                "Destino inválido. Escolha entre 'sqlserver', 'postgresql', 'mysql', 'sqlite' ou 'bigquery'."
            )

    except SQLAlchemyError as e:
        print(f"Erro SQLAlchemy: {e}")
        raise
    except pymssql.Error as e:
        print(f"Erro pymssql: {e}")
        raise
    except Exception as e:
        print(f"Erro geral: {e}")
        raise
