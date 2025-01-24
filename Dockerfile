# Use a imagem base do Python
FROM python:3.12.2-slim

# Instale o pacote tzdata e outras dependências necessárias, incluindo cron
RUN apt-get update && \
    apt-get install -y net-tools iputils-ping tzdata cron

# Defina o fuso horário
ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Copie o arquivo pyproject.toml e poetry.lock para o diretório de trabalho
COPY pyproject.toml poetry.lock ./

# Instale o Poetry
RUN pip install poetry

# Configure o Poetry para não usar um ambiente virtual
RUN poetry config virtualenvs.create false

# Instale as dependências do projeto
RUN poetry install --only main


# Copie todo o código fonte para o diretório de trabalho
COPY . .

# Adicione o crontab para rodar o comando nos horários especificados
#RUN echo "0 8,10,12,14,16,18,20 * * 1-5 cd /app && /usr/local/bin/poetry run python app.py -rel 31 1 5 4 11 12 20 2 30 33 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron
#RUN echo "0 8,10,12,14,16,18,20 * * 1-4 cd /app && /usr/local/bin/poetry run python app.py -rel 2 30 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron
#RUN echo "0 8,10,12,13,14,15,16,17,18,19,20 * * 5 cd /app && /usr/local/bin/poetry run python app.py -rel 31 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron

#RUN echo "0 8,9,10,11,12,13,14,15,16,17,18,19,20 * * 1-5 cd /app && /usr/local/bin/poetry run python app.py -rel 4 34 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron

#RUN echo "0 20 * * 1-4 cd /app && /usr/local/bin/poetry run python app.py -rel 30 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron
#RUN echo "0 10 * * 1-4 cd /app && /usr/local/bin/poetry run python app.py -rel 1 5 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron
#RUN echo "0 5 * * 1-4 cd /app && /usr/local/bin/poetry run python app.py -rel 45 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron
RUN echo "0 5 * * 6,7 cd /app && /usr/local/bin/poetry run python app.py -t 0 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron
#RUN echo "0 10,13,16,20 * * 6 cd /app && /usr/local/bin/poetry run python app.py -rel 1 5 4 11 12 20 2 30 33 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron
#RUN echo "0 10,13,16,20,22 * * 7 cd /app && /usr/local/bin/poetry run python app.py -rel 1 5 4 11 12 20 2 30 33 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron
RUN echo "0 5 * * 1-5 cd /app && /usr/local/bin/poetry run python app.py -t 0 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron
#RUN echo "0 18,19,20 * * 1-5 cd /app && /usr/local/bin/poetry run python app.py -t 0 >> /var/log/cron.log 2>&1" >> /etc/cron.d/mycron

# Sexta-feira: Agora, 17:00, 19:00, 21:00
#RUN echo "0 17,19,21 * * 5 cd /app && /usr/local/bin/poetry run python app.py -rel 2 31 20 34 4" >> /etc/cron.d/mycron
# Sábado: 08:00, 11:00, 14:00, 18:00
#RUN echo "0 8,11,14,18 * * 6 cd /app && /usr/local/bin/poetry run python app.py -rel 2 31 20 34 4" >> /etc/cron.d/mycron
# Domingo: 08:00, 11:00, 14:00, 18:00
#RUN echo "0 8,11,14,18 * * 7 cd /app && /usr/local/bin/poetry run python app.py -rel 2 31 20 34 4" >> /etc/cron.d/mycron



# Defina permissões corretas para o cron job
RUN chmod 0644 /etc/cron.d/mycron

# Aplicar o crontab
RUN crontab /etc/cron.d/mycron

# Crie um arquivo de log para o cron
RUN touch /var/log/cron.log

# Comando para iniciar o cron e manter o container ativo
CMD cron && tail -f /var/log/cron.log