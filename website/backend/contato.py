#!python
# -*- coding: utf-8 -*-
# ============================================================================
# Backend CGI - Formulário de Contato
# Space Code LTDA
# Recebe POST com JSON e salva em contatos.json
# ============================================================================

import cgi
import cgitb
import json
import os
import sys
from datetime import datetime

cgitb.enable()

# Headers
print("Content-Type: application/json")
print("Access-Control-Allow-Origin: *")
print("Access-Control-Allow-Methods: POST, GET, OPTIONS")
print("Access-Control-Allow-Headers: Content-Type")
print()

def get_contatos_path():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    return os.path.join(script_dir, "contatos.json")

def load_contatos():
    path = get_contatos_path()
    if os.path.exists(path):
        try:
            with open(path, "r", encoding="utf-8") as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            return []
    return []

def save_contatos(contatos):
    path = get_contatos_path()
    with open(path, "w", encoding="utf-8") as f:
        json.dump(contatos, f, ensure_ascii=False, indent=2)

def main():
    method = os.environ.get("REQUEST_METHOD", "GET")

    if method == "OPTIONS":
        response = {"status": "ok"}
        print(json.dumps(response))
        return

    if method == "POST":
        try:
            content_length = int(os.environ.get("CONTENT_LENGTH", 0))
            if content_length > 0:
                raw_data = sys.stdin.read(content_length)
            else:
                raw_data = sys.stdin.read()

            data = json.loads(raw_data)

            nome = data.get("nome", "").strip()
            sobrenome = data.get("sobrenome", "").strip()
            mensagem = data.get("mensagem", "").strip()

            if not nome or not sobrenome or not mensagem:
                response = {
                    "status": "error",
                    "message": "Todos os campos são obrigatórios."
                }
                print(json.dumps(response, ensure_ascii=False))
                return

            contato = {
                "nome": nome,
                "sobrenome": sobrenome,
                "mensagem": mensagem,
                "data": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            }

            contatos = load_contatos()
            contatos.append(contato)
            save_contatos(contatos)

            response = {
                "status": "success",
                "message": "Contato salvo com sucesso!",
                "contato": contato
            }
            print(json.dumps(response, ensure_ascii=False))

        except json.JSONDecodeError:
            response = {
                "status": "error",
                "message": "Dados inválidos. Envie JSON válido."
            }
            print(json.dumps(response, ensure_ascii=False))

        except Exception as e:
            response = {
                "status": "error",
                "message": str(e)
            }
            print(json.dumps(response, ensure_ascii=False))

    elif method == "GET":
        contatos = load_contatos()
        response = {
            "status": "success",
            "total": len(contatos),
            "contatos": contatos
        }
        print(json.dumps(response, ensure_ascii=False))

    else:
        response = {
            "status": "error",
            "message": "Método não suportado."
        }
        print(json.dumps(response, ensure_ascii=False))

if __name__ == "__main__":
    main()
