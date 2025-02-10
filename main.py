import logging
import argparse
from scripts.extract.exportar_dados_para_parquet import salvar_dados
from config.extracoes import EXTRACOES, RELATORIOS_EXT

# Configuração básica de logs
logging.basicConfig(filename="data/logs/extracoes.log", level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

# Criando o parser de argumentos
parser = argparse.ArgumentParser(description="Executar extrações específicas ou todas.")
parser.add_argument("-t", nargs="+", type=int, help="Posições das extrações na lista (começa em 0). Se não for informado, executa todas.", default=None)
parser.add_argument("-tab", nargs="+", type=int, help="Executa extrações associadas a múltiplas chaves do dicionário RELATORIOS_EXT", default=None)
args = parser.parse_args()

# Conjunto para armazenar os índices das extrações (evita duplicação)
indices_extracoes = set()

# Se um número for passado em -t, adiciona os índices diretamente
if args.t is not None:
    indices_extracoes.update(args.t)

# Se múltiplas chaves forem passadas em -tab, adiciona os índices associados no dicionário RELATORIOS_EXT
if args.tab is not None:
    for tab in args.tab:
        if tab in RELATORIOS_EXT:
            indices_extracoes.update(RELATORIOS_EXT[tab])  # O set() automaticamente remove duplicatas
        else:
            print(f"Erro: A chave {tab} não existe no dicionário RELATORIOS_EXT.")
            logging.error(f"Chave inválida: {tab}")

# Se nenhum índice foi especificado, executa todas as extrações
if not indices_extracoes:
    indices_extracoes = set(range(len(EXTRACOES)))  # Executa todas as extrações

# Executando as extrações conforme os índices coletados (ordenados para melhor leitura)
for index in sorted(indices_extracoes):
    if 0 <= index < len(EXTRACOES):  # Verifica se a posição é válida
        extracao = EXTRACOES[index]
        try:
            salvar_dados(**extracao)
            mensagem = f"Extração '{extracao['nome_arquivo']}' concluída com sucesso!"
            print(mensagem)
            logging.info(mensagem)
        except Exception as e:
            mensagem = f"Erro ao extrair '{extracao['nome_arquivo']}': {e}"
            print(mensagem)
            logging.error(mensagem)
    else:
        print(f"Erro: O índice fornecido ({index}) está fora do intervalo de 0 a {len(EXTRACOES)-1}.")
        logging.error(f"Índice inválido: {index}")
