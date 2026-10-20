# setupPy

Script to install Ubuntu's Python, a virtual environment, [VS Code](https://code.visualstudio.com/), [PyCharm](https://www.jetbrains.com/pycharm/), and libraries for data science and LLMs on Ubuntu 26.04 LTS and newer.

PyCharm Community and PyCharm Professional are now one PyCharm product. The core that used to be free stays free, including Jupyter. The first launch starts a 30-day Pro trial.

## Usage

On Ubuntu 26.04.1 LTS or newer:

```bash
chmod +x py_ubuntu.sh
./py_ubuntu.sh
```

The script asks for an administrator password and needs internet access. It uses the Python that ships with Ubuntu, creates the environment in `~/venvs/ds`, and installs the current package versions from PyPI. VS Code is then updated from Microsoft's repository. The PyCharm build downloaded is the latest stable release.

Installing PyTorch, PyCharm, and the scientific libraries can take a long time and several gigabytes of disk space.

Activate the environment afterwards with:

```bash
source ~/venvs/ds/bin/activate
```

## What the script changes

- Stops compiling Python 3.10 and uses Ubuntu's current Python.
- Installs packages in the virtual environment instead of mixing them with the system Python.
- Replaces `fbprophet` with `prophet` and the old Google client with `google-genai`.
- Adds libraries for using LLMs (`openai`, `anthropic`, `google-genai`, `litellm`, `ollama`, `transformers`, `langchain`, `langgraph`) and for creating or fine-tuning them (`torch`, `datasets`, `accelerate`, `peft`, `trl`, `bitsandbytes`).
- Installs unified PyCharm instead of Community 2021.3.3.
- Does not install OpenJDK 11 for the IDE. PyCharm ships its own runtime. OpenJDK 21 is available for PySpark and H2O.

Packages that do not yet publish a wheel for this Ubuntu release's Python, such as TensorFlow on Python 3.14, are listed at the end of the run and do not stop the rest of the installation.

## License

MIT. See [LICENSE](LICENSE).
