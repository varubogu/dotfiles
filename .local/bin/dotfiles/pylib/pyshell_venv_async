#! /usr/bin/env python3

#------------------------------------------------------------------------------
# pyshell_venv_async
#------------------------------------------------------------------------------
# Re-run the Python shell script in the venv environment
#
#------------------------------------------------------------------------------
#
# This code creates a virtual environment and re-executes it when called from Python code.
# This code itself works by itself as `src/pyshell_venv_async.py` without adding any libraries.
#
# The purpose is to allow you to freely install libraries and run Python shell scripts without polluting the host's Python environment.
#
# The actual venv directory is set with the following priority.
#
# The directory where the venv's actual files are stored is set with the following priority:
# 1. It is set in $XDG_DATA_HOME.
# 2. If $XDG_DATA_HOME cannot be set, it is set in ~/.local/share.
# 3. If it cannot be set even then, an error is raised.
#
#------------------------------------------------------------------------------
#
# Example:
#
# `src/example_async.py`
#
# ```python
# import pyshell_venv_async as psv
#
# is_in_venv = await psv.is_in_venv()
# if not is_in_venv:
#     require_package = "numpy"
#     result: int = await psv.execute(
#         require_package_text=require_package
#     )
#     sys.exit(result)
#
# # This code runs in a virtual environment.
# import numpy as np
# ary = np.array([1, 2, 3])
# print(ary)
# sys.exit(0)
# ```
#
#------------------------------------------------------------------------------
#
# LICENSE
#
# MIT License
#
# Copyright (c) 2024 ヴァルボーグ@toyosuke
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.#
#
#------------------------------------------------------------------------------

import asyncio
import sys
import os
import subprocess
import logging
from pathlib import Path

logger = logging.getLogger(__name__)


# application name
APP_NAME: str = "pyshell_venv"
# environment variable name
ENV_VAR_PYSHELL_VENV: str = "ENV_VAR_PYSHELL_VENV"


async def is_in_venv() -> bool:
    """
    Check if the current process is running in a virtual environment.

    Returns:
        bool: True if the current process is running in a virtual environment, False otherwise.
    """
    env_var_value = os.environ.get(ENV_VAR_PYSHELL_VENV, None)
    logger.debug(f"ENV_VAR_PYSHELL_VENV: {env_var_value}")
    return env_var_value is not None


async def execute(
        env_name: str = "",
        work_directory: str = "",
        is_local_project: bool = False,
        require_package_text: str = ""
    ) -> int:
    """
    Execute the venv environment script.

    Args:
        env_name (str): The name of the virtual environment.
        work_directory (str): The working directory.
        local_project_dir (str | None): The path to the local project directory.
        require_package_text (str): The text to be installed. (via pip install)

    Returns:
        int: The return code of the executed command.
    """

    # arguments
    script_path: str = sys.argv[0]
    logger.debug(f"script_path: {script_path}")

    script_args: list[str] = sys.argv[1:]
    logger.debug(f"script_args: {script_args}")

    env_name: str = env_name
    logger.debug(f"env_name: {env_name}")

    work_directory: str = work_directory
    if work_directory == "":
        logger.debug(f"work_directory is empty. use current directory.")
        work_directory_path: Path = Path.cwd()
    else:
        work_directory_path: Path = Path(work_directory)
    logger.debug(f"work_directory: {work_directory_path}")

    is_local_project: bool = is_local_project
    logger.debug(f"is_local_project: {is_local_project}")

    install_package_text: str = require_package_text
    logger.debug(f"install_package_text: {install_package_text}")

    venv_dir: Path = await get_venv_dir(env_name, is_local_project, work_directory)
    logger.debug(f"venv_dir: {venv_dir}")

    # change working directory
    if work_directory != "":
        cwd = work_directory_path
        logger.debug(f"change working directory: {cwd}")
        os.chdir(cwd)

    # preparing commands
    activate_cmd = await preparing_activate(venv_dir)
    logger.debug(f"activate command: {activate_cmd}")

    if install_package_text != "":
        install_cmd = await preparing_pip_install(
            venv_dir,
            install_package_text,
            work_directory_path
        )
        logger.debug(f"pip install command: {install_cmd}")

    python_cmd = await preparing_execute(
        venv_dir,
        script_path,
        script_args
    )
    logger.debug(f"execute command: {python_cmd}")

    # set environment variable
    os.environ[ENV_VAR_PYSHELL_VENV] = "1"

    # venv activate
    activate_result = await subprocess_run(
        "activate",
        activate_cmd
    )

    if activate_result != 0:
        logger.error(f"activate command failed")
        return activate_result

    # (venv)pip install
    if install_package_text != "":
        logger.debug(f"pip install command: {install_cmd}")
        pip_install_result = await subprocess_run(
            "pip install",
            install_cmd
        )
        if pip_install_result != 0:
            logger.error(f"pip install command failed")
            return pip_install_result

    # (venv)python execute
    logger.debug(f"python command: {python_cmd}")
    python_result = await subprocess_run(
        "python",
        python_cmd
    )
    if python_result != 0:
        logger.error(f"python command failed")

    return python_result


async def preparing_activate(venv_dir: Path) -> list[str]:
    """
    Preparing for activation

    Returns:
        list[str]: The command to activate the virtual environment.

    Example:
        ["$XDG_DATA_HOME/pyshell_venv/default/bin/activate"]
        ["~/.local/share/pyshell_venv/default/bin/activate"]
        ["project_dir/.venv/bin/activate"]
    """

    if not venv_dir.exists():
        # create virtual environment
        host_python_command = await get_host_python_command()
        logger.debug(f"venv create command: {host_python_command}")
        subprocess.run([host_python_command, "-m", "venv", venv_dir.as_posix()])

    if not venv_dir.is_dir():
        raise RuntimeError("venv is not directory.")

    if not venv_dir.is_dir():
        raise RuntimeError("venv is not accessible.")

    # Preparing for activation
    activate_command_path = await get_venv_activate_command_path(venv_dir)
    logger.debug(f"activate_command_path: {activate_command_path}")

    if not activate_command_path.exists():
        raise RuntimeError("venv activate command is not found.")
    executable = await is_executable_command(activate_command_path)
    if not executable:
        logger.debug(f"venv activate command is not executable. change permission to 0o700.")
        os.chmod(activate_command_path, 0o700)
    else:
        logger.debug(f"venv activate command is accessible.")

    activate_command = ["sh", activate_command_path.as_posix()]
    logger.debug(f"activate command: {activate_command}")
    return activate_command

async def preparing_pip_install(
        venv_dir: Path,
        install_package_text: str,
        work_directory_path: str
    ) -> list[str]:
    """
    Preparing for pip install

    Returns:
        list[str]: The command to install dependencies.

    Example:
        ["$XDG_DATA_HOME/pyshell_venv/default/bin/python", "-m", "pip", "install", "numpy"]
        ["~/.local/share/pyshell_venv/default/bin/python", "-m", "pip", "install", "numpy aiohttp"]
        ["project_dir/.venv/bin/python", "-m", "pip", "install", "numpy"]
    """
    requirements_path = Path(work_directory_path / "requirements.txt")
    logger.debug(f"requirements_path: {requirements_path}")
    command = await get_venv_python_path(venv_dir)
    logger.debug(f"install dependencies command: {command}")
    pip_install_command = [command, "-m", "pip", "install", install_package_text]
    logger.debug(f"pip install command: {pip_install_command}")
    return pip_install_command

async def preparing_execute(venv_dir: Path, script_path: str, script_args: list[str]) -> list[str]:
    """
    Preparing for execution

    Returns:
        list[str]: The command to execute the script.

    Example:
        ["$XDG_DATA_HOME/pyshell_venv/default/bin/python", "script.py", "arg1", "arg2"]
        ["~/.local/share/pyshell_venv/default/bin/python", "script.py", "arg1", "arg2"]
        ["project_dir/.venv/bin/python", "script.py", "arg1", "arg2"]
    """
    venv_python_path = await get_venv_python_path(venv_dir)
    logger.debug(f"exec command: {venv_python_path.as_posix()} {script_path} {script_args}")

    result =[venv_python_path.as_posix(), script_path, *script_args]
    logger.debug(f"exec result: {result}")
    return result


async def get_venv_center_dir() -> Path:
    """
    Get the parent directory for the virtual environment.

    Returns:
        Path: The parent directory for the virtual environment.

    Example:
        /home/user/.local/share/pyshell_venv
        $XDG_DATA_HOME/pyshell_venv
        ./project_dir/.venv
    """

    # environment variable XDG_DATA_HOME
    dir_str = os.environ.get("XDG_DATA_HOME", None)
    if dir_str is not None:
        logger.debug(f"XDG_DATA_HOME: {dir_str}")
        dir_path = Path(dir_str / APP_NAME)
        if dir_path.exists():
            accesable = await is_accessible_dir(dir_path)
            if accesable:
                logger.debug(f"XDG_DATA_HOME: {dir_path}")
                return dir_path

    # default directory
    dir_path = Path(Path.home() / ".local/share" / APP_NAME)
    if not dir_path.exists():
        dir_path.mkdir(parents=True)
        logger.debug(f"default directory: {dir_path}")
        return dir_path

    elif not dir_path.is_dir():
        raise RuntimeError("venv parent directory is not found")

    else:
        accesable = await is_accessible_dir(dir_path)
        if not accesable:
            raise RuntimeError("venv parent directory is not accessible")

    return dir_path


async def get_venv_dir(env_name: str, is_local_project: bool, work_directory_path: str) -> Path:
    """
    Get the path to the virtual environment directory.

    Args:
        env_name (str): The name of the virtual environment.
        is_local_project (bool): True if the virtual environment is in the local project directory, False otherwise.
        work_directory_path (str): The path to the working directory.

    Returns:
        Path: The path to the virtual environment directory.

    Example:
        $XDG_DATA_HOME/pyshell_venv/default
        /home/user/.local/share/pyshell_venv/env_name
        ./project_dir/.venv
    """
    if is_local_project:
        return Path(work_directory_path, ".venv")
    else:
        env_dir_name = "default"
        if env_name != "":
            env_dir_name = env_name
        dir_path = await get_venv_center_dir()
        return Path(dir_path / env_dir_name)



async def get_host_python_command() -> str:
    """
    Get the command to use to run the host python interpreter.

    Returns:
        str: The command to use to run the host python interpreter.
    """
    if sys.platform == "win32":
        if subprocess.run(["cmd.exe", "/C", "command", "-v", "python3"]).returncode == 0:
            logger.debug(f"python3 found")
            return "python3"
        elif subprocess.run(["cmd.exe", "/C", "command", "-v", "python"]).returncode == 0:
            logger.debug(f"python found")
            return "python"
        elif subprocess.run(["cmd.exe", "/C", "command", "-v", "py"]).returncode == 0:
            logger.debug(f"py found")
            return "py"
        else:
            raise RuntimeError("python is not available")
    else:
        if subprocess.run(["sh", "-c", "command", "-v", "python3"]).returncode == 0:
            logger.debug(f"python3 found")
            return "python3"
        elif subprocess.run(["sh", "-c", "command", "-v", "python"]).returncode == 0:
            logger.debug(f"python found")
            return "python"
        elif subprocess.run(["sh", "-c", "command", "-v", "py"]).returncode == 0:
            logger.debug(f"py found")
            return "py"
        else:
            raise RuntimeError("python is not available")


async def get_venv_activate_command_path(venv_dir: Path) -> Path:
    """
    Get the command to activate the virtual environment.

    Args:
        venv_dir (Path): The path to the virtual environment directory.

    Returns:
        Path: The path to the command to activate the virtual environment.
    """
    if sys.platform == "win32":
        if os.name == "nt":
            logger.debug(f"activate.bat found")
            return venv_dir / "Scripts/activate.bat"
        else:
            logger.debug(f"activate.ps1 found")
            return venv_dir / "Scripts/activate.ps1"
    else:
        logger.debug(f"activate found")
        return venv_dir / "bin/activate"

async def get_venv_python_path(venv_dir: Path) -> Path:
    """
    Get the path to the python interpreter in the virtual environment.

    Args:
        venv_dir (Path): The path to the virtual environment directory.

    Returns:
        Path: The path to the python interpreter in the virtual environment.
    """
    if sys.platform == "win32":
        logger.debug(f"python.exe found")
        return venv_dir / "Scripts/python.exe"
    else:
        logger.debug(f"python3 found")
        return venv_dir / "bin/python3"



async def is_accessible_dir(p: Path) -> bool:
    """
    Check if the directory is accessible.

    Args:
        p (Path): The path to the directory.

    Returns:
        bool: True if the directory is accessible, False otherwise.
    """
    result = p.is_dir() and os.access(p, os.W_OK | os.X_OK)
    logger.debug(f"is_accessible_dir: {p} result: {result}")
    return result

async def is_accessible_file(p: Path) -> bool:
    """
    Check if the file is accessible.

    Args:
        p (Path): The path to the file.

    Returns:
        bool: True if the file is accessible, False otherwise.
    """
    result = p.exists() and p.is_file() and os.access(p, os.R_OK)
    logger.debug(f"is_accessible_file: {p} result: {result}")
    return result

async def is_executable_command(p: Path) -> bool:
    """
    Check if the command is executable.

    Args:
        p (Path): The path to the command.

    Returns:
        bool: True if the command is executable, False otherwise.
    """
    accesable = await is_accessible_file(p)
    if not accesable:
        return False
    result = os.access(p, os.X_OK)
    logger.debug(f"is_executable_command: {p} result: {result}")
    return result

async def subprocess_run(
        command_name: str,
        command: list[str],
        input: bytes = None
    ) -> int:
    """
    Run the command and return the output.
    """
    logger.debug(f"{command_name} command: {command}")

    proc = await asyncio.create_subprocess_exec(
        *command,
        stdin=asyncio.subprocess.PIPE,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )


    output, error = await proc.communicate()
    output_str = output.decode()
    error_str = error.decode()
    if output_str != "":
        logger.info(f"{command_name} output: {output_str}")
    if error_str != "":
        logger.error(f"{command_name} error: {error_str}")

    if proc.returncode != 0:
        logger.error(f"{command_name} command failed")
    return proc.returncode
