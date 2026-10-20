# setupPy

Script para instalar o Python do Ubuntu, um ambiente virtual, o [VS Code](https://code.visualstudio.com/), o [PyCharm](https://www.jetbrains.com/pycharm/) e bibliotecas de ciência de dados e de LLMs no Ubuntu 26.04 LTS e em versões mais novas.

O PyCharm Community e o PyCharm Professional foram unificados num só PyCharm. O núcleo que era gratuito continua gratuito, incluindo Jupyter. A primeira execução ativa um teste de 30 dias da edição Pro.

## Uso

No Ubuntu 26.04.1 LTS ou mais recente:

```bash
chmod +x py_ubuntu.sh
./py_ubuntu.sh
```

O script pede senha de administrador e precisa de internet. Ele usa o Python que já vem no Ubuntu, cria o ambiente em `~/venvs/ds` e instala as versões atuais dos pacotes no PyPI. O VS Code passa a ser atualizado pelo repositório da Microsoft. O PyCharm baixado é a versão estável mais recente.

A instalação do PyTorch, do PyCharm e das bibliotecas científicas pode levar bastante tempo e vários gigabytes de disco.

Para usar o ambiente depois:

```bash
source ~/venvs/ds/bin/activate
```

## O que o script troca

- Deixa de compilar o Python 3.10 e usa o Python atual do Ubuntu.
- Instala os pacotes no ambiente virtual, em vez de misturá-los com o Python do sistema.
- Troca o `fbprophet` pelo `prophet` e o cliente antigo do Google pelo `google-genai`.
- Inclui bibliotecas para usar LLMs (`openai`, `anthropic`, `google-genai`, `litellm`, `ollama`, `transformers`, `langchain`, `langgraph`) e para criá-los ou ajustá-los (`torch`, `datasets`, `accelerate`, `peft`, `trl`, `bitsandbytes`).
- Instala o PyCharm unificado no lugar do Community 2021.3.3.
- Não instala o OpenJDK 11 para o IDE. O PyCharm traz o próprio runtime. O OpenJDK 21 fica disponível para o PySpark e o H2O.

Pacotes que ainda não publicam wheel para o Python desta versão do Ubuntu, como o TensorFlow no Python 3.14, aparecem no final da execução e não interrompem o resto da instalação.

## Licença

MIT. Veja [LICENSE](LICENSE).
