import pandas as pd
import os
from datetime import datetime

def load_data(file_path: str, file_type: str = "csv") -> pd.DataFrame:
    """Carrega dados a partir de um arquivo"""
    if file_type == "csv":
        df = pd.read_csv(file_path)
    elif file_type == "json":
        df = pd.read_json(file_path)
    elif file_type == "parquet":
        df = pd.read_parquet(file_path)
    else:
        raise ValueError("Formato de arquivo não suportado")
    
    return df

def transform_data(df: pd.DataFrame) -> pd.DataFrame:
    """Realiza transformações nos dados"""
    df = df.dropna()
    df["data_processada"] = datetime.now()  # Adicionando uma coluna com a data do processamento
    df["nova_coluna"] = df["coluna_existente"] * 2  # Exemplo de nova coluna
    
    return df

def validate_data(df: pd.DataFrame) -> bool:
    """Valida os dados"""
    if df.isnull().sum().sum() > 0:
        return False
    if df.empty:
        return False
    return True

def save_data(df: pd.DataFrame, output_path: str):
    """Salva os dados processados em Parquet"""
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    df.to_parquet(output_path, index=False)


def execute_pipeline(input_file: str, output_file: str):
    # Pipeline de tratamento
    df = load_data(input_file)
    df = transform_data(df)

    if validate_data(df):
        save_data(df, output_file)

if __name__ == "__main__":
    # Definição de caminhos
    input_file = "../../data/raw/sheets/dados_google_sheets.xlsx"
    output_file = f"../../data/output/dataset_processado_{datetime.now().strftime('%Y%m%d_%H%M%S')}.parquet"
    
    # Execução do pipeline
    execute_pipeline(input_file, output_file)
