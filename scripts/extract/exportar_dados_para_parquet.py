import pandas as pd
import os
import pymssql
import gspread
import re
import time
from sqlalchemy import create_engine
from google.oauth2.service_account import Credentials
from typing import Optional, Dict


def salvar_dados(
    origem: str,
    nome_arquivo: str,
    formato: str,
    path_file: Optional[str] = "data/raw/",
    query: Optional[str] = None,
    credenciais: Optional[Dict] = None,
    nome_banco: Optional[str] = None,
    tipo_banco: Optional[str] = None,
    api_key: Optional[str] = None,
    spreadsheet_url: Optional[str] = None,
):
    """
    Extrai dados de uma fonte especificada (SQL ou Google Sheets) e salva no formato desejado.

    Parâmetros:
    ----------
    origem : str
        Origem dos dados. Valores suportados: 'sql' ou 'google_sheets'.
    nome_arquivo : str
        Nome do arquivo a ser salvo (sem extensão).
    formato : str
        Formato do arquivo de saída. Valores suportados: 'excel' ou 'parquet'.
    path_file : Optional[str], padrão "data/raw/"
        Caminho onde o arquivo será salvo.
    query : Optional[str], padrão None
        Query SQL a ser executada caso a origem seja 'sql'.
    credenciais : Optional[Dict], padrão None
        Dicionário contendo as credenciais de acesso ao banco de dados (usuário, senha, host, etc.).
    nome_banco : Optional[str], padrão None
        Nome do banco de dados, caso a origem seja 'sql'.
    tipo_banco : Optional[str], padrão None
        Tipo de banco de dados ('sqlserver', 'postgresql', 'mysql' ou 'sqlite').
    api_key : Optional[str], padrão None
        Caminho do arquivo de credenciais de serviço do Google para acessar Google Sheets.
    spreadsheet_url : Optional[str], padrão None
        URL da planilha do Google Sheets para extração de dados.

    Exceções:
    ---------
    ValueError:
        - Se parâmetros obrigatórios não forem fornecidos.
        - Se o tipo de banco de dados ou formato for inválido.
        - Se o arquivo SQLite especificado não existir.
    pymssql.Error:
        - Erros ao conectar ao SQL Server.
    ImportError:
        - Se alguma biblioteca necessária não estiver instalada.
    Exception:
        - Outros erros inesperados.

    Exemplo de uso:
    --------------
    Salvar dados de um banco SQL Server como arquivo Parquet:
    
    ```python
    salvar_dados(
        origem="sql",
        nome_arquivo="dados_vendas",
        formato="parquet",
        path_file="data/output/",
        query="SELECT * FROM vendas",
        credenciais={"server": "meu_servidor", "user": "admin", "password": "1234"},
        nome_banco="loja_db",
        tipo_banco="sqlserver"
    )
    ```

    Salvar dados de uma planilha do Google Sheets como Excel:
    
    ```python
    salvar_dados(
        origem="google_sheets",
        nome_arquivo="planilha_dados",
        formato="excel",
        api_key="path/to/credentials.json",
        spreadsheet_url="https://docs.google.com/spreadsheets/d/1xyz123"
    )
    ```
    """
    try:
        df = None  # Inicializa o DataFrame

        if origem.lower() == "sql":
            if not query or not credenciais or not nome_banco or not tipo_banco:
                raise ValueError(
                    "Para origem 'sql', forneça 'query', 'credenciais', 'nome_banco' e 'tipo_banco'."
                )

            # Validação de credenciais
            if not all(key in credenciais for key in ["user", "password"]):
                raise ValueError(
                    "As credenciais devem conter pelo menos 'user' e 'password'."
                )

            if tipo_banco.lower() == "sqlserver":
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

        elif origem.lower() == "google_sheets":
            if not api_key or not spreadsheet_url:
                raise ValueError(
                    "Para origem 'google_sheets', forneça 'api_key' e 'spreadsheet_url'."
                )

            # Configuração de credenciais do Google
            scopes = [
                "https://www.googleapis.com/auth/spreadsheets",
                "https://www.googleapis.com/auth/drive",
            ]
            creds = Credentials.from_service_account_file(api_key, scopes=scopes)
            client = gspread.authorize(creds)

            # Abre a planilha do Google Sheets
            spreadsheet = client.open_by_url(spreadsheet_url)

            # Criar um escritor do pandas para Excel se necessário
            if formato.lower() == "excel":
                writer = pd.ExcelWriter(f"{path_file}/{nome_arquivo}.xlsx", engine="xlsxwriter")

            # Baixar todas as abas da planilha
            for sheet in spreadsheet.worksheets():
                data = sheet.get_all_values()
                headers = data.pop(0)
                df = pd.DataFrame(data, columns=headers)

                if formato.lower() == "excel":
                    # Tratar o nome das abas para não ultrapassar 30 caracteres e remover caracteres especiais
                    sheet_title = re.sub(r"[^a-zA-Z0-9_\-]", "_", sheet.title)[:30]
                    df.to_excel(writer, sheet_name=sheet_title, index=False)

            if formato.lower() == "excel":
                writer.close()
                print(f"Planilha salva com sucesso em: {path_file}/{nome_arquivo}.xlsx")
                return  # Para evitar a execução do restante da função

        else:
            raise ValueError(f"Origem '{origem}' não suportada. Use 'sql' ou 'google_sheets'.")

        # Salvar os dados no formato escolhido
        if df is not None:
            caminho_arquivo = f"{path_file}/{nome_arquivo}.{formato}"
            if formato.lower() == "parquet":
                df.to_parquet(caminho_arquivo, index=False)
            elif formato.lower() == "excel":
                df.to_excel(caminho_arquivo, index=False)
            else:
                raise ValueError("Formato inválido. Use 'excel' ou 'parquet'.")

            print(f"Dados salvos com sucesso em: {caminho_arquivo}")

    except pymssql.Error as e:
        print(f"Erro no pymssql (SQL Server): {e}")
        raise
    except ImportError as e:
        print("Erro: Verifique se as bibliotecas necessárias estão instaladas.")
        raise
    except Exception as e:
        print(f"Ocorreu um erro inesperado: {e}")
        raise
