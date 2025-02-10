EXTRACOES = [
    {
        "origem": "google_sheets",
        "nome_arquivo": "dados_google_sheets",
        "formato": "excel",
        "api_key": "config/.dw-teste-6ff1adb6399f.json",
        "spreadsheet_url": "https://docs.google.com/spreadsheets/d/18mk7e1V4ZZNbeiZ_i-1mTK8UGaSRK7YJvsyHijHASG0"
    },
    {
        "origem": "sql",
        "nome_arquivo": "dados_vendas",
        "formato": "parquet",
        "query": "SELECT * FROM vendas",
        "credenciais": {
            "server": "meu_servidor",
            "user": "admin",
            "password": "1234"
        },
        "nome_banco": "loja_db",
        "tipo_banco": "sqlserver"
    },
    {
        "origem": "sql",
        "nome_arquivo": "dados_clientes",
        "formato": "parquet",
        "query": "SELECT * FROM clientes",
        "credenciais": {
            "host": "localhost",
            "port": "5432",
            "user": "admin",
            "password": "admin"
        },
        "nome_banco": "clientes_db",
        "tipo_banco": "postgresql"
    }
]



RELATORIOS_EXT = {
    1:[0,1],
    2:[0,],
    4:[7,9,10]}
