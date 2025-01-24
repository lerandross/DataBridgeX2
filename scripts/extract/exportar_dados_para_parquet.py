import pandas as pd
from typing import Optional
from sqlalchemy import create_engine
import pymssql
import os


def salvar_dataframe_em_parquet(
    query: str, nome_arquivo: str, credenciais: dict, nome_banco: str, tipo_banco: str, path_file: Optional[str] = "data/raw/parquet"
):
    """
    Salva o resultado de uma query em um arquivo Parquet.

    Args:
        query (str): A query SQL a ser executada.
        nome_arquivo (str): O nome do arquivo (sem extensão).
        credenciais (dict): Dicionário com credenciais do banco de dados.
            Exemplos:
                Para SQL Server: {'server': '...', 'user': '...', 'password': '...'}
                Para outros bancos: {'user': '...', 'password': '...', 'host': '...', 'port': '...'}
        nome_banco (str): O nome do banco de dados.
        tipo_banco (str): O tipo do banco de dados ('sqlserver', 'postgresql', 'mysql', 'sqlite', etc.).

    Raises:
        ValueError: Tipo de banco de dados não suportado ou credenciais inválidas.
        Exception: Outras exceções durante a execução.
    """
    try:
        # Validação de credenciais
        if not all(key in credenciais for key in ["user", "password"]):
            raise ValueError(
                "As credenciais devem conter pelo menos 'user' e 'password'."
            )

        if tipo_banco.lower() == "sqlserver":
            # Conexão com SQL Server usando pymssql
            if not credenciais.get("server"):
                raise ValueError("Credencial 'server' é obrigatória para SQL Server.")
            with pymssql.connect(
                server=credenciais["server"],
                user=credenciais["user"],
                password=credenciais["password"],
                database=nome_banco,
                tds_version="7.0",
            ) as conn:
                df = pd.read_sql(query, conn)
        elif tipo_banco.lower() in ("postgresql", "mysql", "sqlite"):
            # Conexão com outros bancos usando SQLAlchemy
            if tipo_banco.lower() == "postgresql":
                engine = create_engine(
                    f'postgresql://{credenciais["user"]}:{credenciais["password"]}@{credenciais["host"]}:{credenciais["port"]}/{nome_banco}'
                )
            elif tipo_banco.lower() == "mysql":
                engine = create_engine(
                    f'mysql+mysqlconnector://{credenciais["user"]}:{credenciais["password"]}@{credenciais["host"]}:{credenciais["port"]}/{nome_banco}'
                )
            elif tipo_banco.lower() == "sqlite":
                if not os.path.exists(nome_banco):
                    raise ValueError("O arquivo SQLite especificado não existe.")
                engine = create_engine(f"sqlite:///{nome_banco}")
            with engine.connect() as conn:
                df = pd.read_sql(query, conn)
        else:
            raise ValueError(f"Tipo de banco de dados '{tipo_banco}' não suportado.")

        # Construir o nome do arquivo
        caminho_arquivo = f"{path_file}/{nome_banco}.{nome_arquivo}.parquet"

        # Salvar o DataFrame em Parquet
        df.to_parquet(caminho_arquivo, index=False)
        print(f"DataFrame salvo com sucesso em: {caminho_arquivo}")

    except pymssql.Error as e:
        print(f"Erro no pymssql (SQL Server): {e}")
        raise
    except ImportError as e:
        print(
            "Erro: Verifique se as bibliotecas necessárias estão instaladas. Instale com: pip install sqlalchemy pymssql"
        )
        raise
    except Exception as e:
        print(f"Ocorreu um erro inesperado: {e}")
        raise
