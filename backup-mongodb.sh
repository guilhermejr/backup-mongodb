#!/bin/bash
#
# Desenvolvido por: Guilherme Jr. http://www.guilhermejr.net
# Licença de uso: GPL
# Backup de um banco de dados MongoDB

# --- Variáveis ---
HOST="localhost"
PORT="27017"
USER="usuario"
PASS="senha"
BASE="banco"
PASTA_DESTINO="/home/guilhermejr/backup"

# --- Data do backup ---
DATA=$(date +"%d-%m-%Y")

# --- Realiza o backup do mongodb ---
echo "Realizando backup... "
if ! mongodump --host=$HOST --port=$PORT --username=$USER --password=$PASS --authenticationDatabase=admin --db=$BASE --out=$DATA 1>/dev/null 2>>error.log; then
    echo "Erro ao tentar realizar backup"
    exit 1
fi

# --- Compacta pasta do backup ---
echo "Zipando backup... "
if ! zip -r "$DATA.zip" $DATA 1>/dev/null 2>>error.log; then
echo "Erro ao tentar compactar backup"
    exit 1
fi

# --- Remove pasta ---
echo "Removendo pasta... "
if ! rm -rf $DATA 1>/dev/null 2>>error.log; then
echo "Erro ao tentar remover pasta"
    exit 1
fi

# --- Move arquivo compactado para a pasta compartilhado com a VM ---
echo "Movendo arquivo compactado para pasta compartilhada..."
if ! mv "$DATA.zip" $PASTA_DESTINO 1>/dev/null 2>>error.log; then
    echo "Erro ao tentar mover backup"
    exit 1
fi

# --- Mensagem de sucesso ---
echo "Backup realizado com sucesso"
exit 0