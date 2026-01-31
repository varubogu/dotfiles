#! /usr/bin/env python3

#------------------------------------------------------------------------------
# pyshell_venv
#------------------------------------------------------------------------------
# Re-run the Python shell script in the venv environment
#
#------------------------------------------------------------------------------
#
# This code creates a virtual environment and re-executes it when called from Python code.
# This code itself works by itself as `src/pyshell_venv.py` without adding any libraries.
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
# `src/example.py`
#
# ```python
# from pyshell_venv import PyShellVenv
#
# if not PyShellVenv.is_in_venv():
#     require_package = "numpy"
#     psv = PyShellVenv(require_package_text=require_package)
#     result: int = psv.execute()
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

import sys
import os
import subprocess
import argparse
import logging
from pathlib import Path

logger = logging.getLogger(__name__)


class PyShellVenv:
    """
    Re-run the Python shell script in the venv environment
    """

    # application name
    APP_NAME: str = "pyshell_venv"
    # environment variable name
    ENV_VAR_PYSHELL_VENV: str = "ENV_VAR_PYSHELL_VENV"

    def __init__(
            self,
            env_name: str = "",
            work_directory: str = "",
            is_local_project: bool = False,
            require_package_text: str = ""
        ):
        """
        Initialize the PyShellVenv class.

        Args:
            env_name (str): The name of the virtual environment.
            work_directory (str): The working directory.
            local_project_dir (str | None): The path to the local project directory.
            require_package_text (str): The text to be installed. (via pip install)
        """

        # arguments
        self.__script_path: str = sys.argv[0]
        logger.debug(f"script_path: {self.__script_path}")

        self.__script_args: list[str] = sys.argv[1:]
        logger.debug(f"script_args: {self.__script_args}")

        self.__env_name: str = env_name
        logger.debug(f"env_name: {self.__env_name}")

        self.__work_directory: str = work_directory
        if work_directory == "":
            logger.debug(f"work_directory is empty. use current directory.")
            self.__work_directory_path: Path = Path.cwd()
        else:
            self.__work_directory_path: Path = Path(work_directory)
        logger.debug(f"work_directory: {self.__work_directory_path}")

        self.__is_local_project: bool = is_local_project
        logger.debug(f"is_local_project: {self.__is_local_project}")

        self.__install_package_text: str = require_package_text
        logger.debug(f"install_package_text: {self.__install_package_text}")

        # internal variables
        self._venv_dir: Path = self.get_venv_dir(self.__env_name, self.__is_local_project, self.__work_directory)
        logger.debug(f"venv_dir: {self._venv_dir}")


    @classmethod
    def is_in_venv(cls) -> bool:
        """
        Check if the current process is running in a virtual environment.

        Returns:
            bool: True if the current process is running in a virtual environment, False otherwise.
        """
        return os.environ.get(cls.ENV_VAR_PYSHELL_VENV, None) is not None


    def execute(self) -> int:
        """
        Execute the venv environment script.

        Returns:
            int: The return code of the executed command.
        """

        # change working directory
        if self.__work_directory != "":
            cwd = self.__work_directory_path
            logger.debug(f"change working directory: {cwd}")
            os.chdir(cwd)

        # preparing commands
        activate_cmd = self.preparing_activate()
        logger.debug(f"activate command: {activate_cmd}")

        if self.__install_package_text != "":
            install_cmd = self.preparing_pip_install()
            logger.debug(f"pip install command: {install_cmd}")

        python_cmd = self.preparing_execute()
        logger.debug(f"execute command: {python_cmd}")

        # set environment variable
        os.environ[self.ENV_VAR_PYSHELL_VENV] = "1"

        # venv activate
        logger.debug(f"activate command: {activate_cmd}")
        activate_proc = subprocess.Popen(activate_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        activate_output, activate_error = activate_proc.communicate()
        activate_output_str = activate_output.decode()
        activate_error_str = activate_error.decode()
        if activate_output_str != "":
            logger.info(f"activate output: {activate_output_str}")
        if activate_error_str != "":
            logger.error(f"activate error: {activate_error_str}")

        if activate_proc.returncode != 0:
            logger.error(f"activate command failed")
            return activate_proc.returncode

        # (venv)pip install
        if self.__install_package_text != "":
            logger.debug(f"pip install command: {install_cmd}")
            pip_install_proc = subprocess.Popen(install_cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            pip_install_output, pip_install_error = pip_install_proc.communicate(input=activate_output)
            pip_install_output_str = pip_install_output.decode()
            pip_install_error_str = pip_install_error.decode()
            if pip_install_output_str != "":
                logger.info(f"pip install output: {pip_install_output_str}")
            if pip_install_error_str != "":
                logger.error(f"pip install error: {pip_install_error_str}")

            if pip_install_proc.returncode != 0:
                logger.error(f"pip install command failed")
                return pip_install_proc.returncode

        # (venv)python execute
        logger.debug(f"python command: {python_cmd}")
        python_proc = subprocess.Popen(python_cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        result, error = python_proc.communicate(input=pip_install_output)
        result_str = result.decode()
        error_str = error.decode()
        if result_str != "":
            logger.info(f"python command result: {result_str}")
        if error_str != "":
            logger.error(f"python command error: {error_str}")

        if python_proc.returncode != 0:
            logger.error(f"python command failed")
            return python_proc.returncode

        return python_proc.returncode


    def preparing_activate(self) -> list[str]:
        """
        Preparing for activation

        Returns:
            list[str]: The command to activate the virtual environment.

        Example:
            ["$XDG_DATA_HOME/pyshell_venv/default/bin/activate"]
            ["~/.local/share/pyshell_venv/default/bin/activate"]
            ["project_dir/.venv/bin/activate"]
        """

        if not self._venv_dir.exists():
            # create virtual environment
            host_python_command = self.get_host_python_command()
            logger.debug(f"venv create command: {host_python_command}")
            subprocess.run([host_python_command, "-m", "venv", self._venv_dir.as_posix()])

        if not self._venv_dir.is_dir():
            raise RuntimeError("venv is not directory.")

        if not self._venv_dir.is_dir():
            raise RuntimeError("venv is not accessible.")

        # Preparing for activation
        activate_command_path = self.get_venv_activate_command_path(self._venv_dir)
        logger.debug(f"activate_command_path: {activate_command_path}")

        if not activate_command_path.exists():
            raise RuntimeError("venv activate command is not found.")
        elif not self.is_executable_command(activate_command_path):
            logger.debug(f"venv activate command is not executable. change permission to 0o700.")
            os.chmod(activate_command_path, 0o700)
        else:
            logger.debug(f"venv activate command is accessible.")

        activate_command = ["sh", activate_command_path.as_posix()]
        logger.debug(f"activate command: {activate_command}")
        return activate_command

    def preparing_pip_install(self) -> list[str]:
        """
        Preparing for pip install

        Returns:
            list[str]: The command to install dependencies.

        Example:
            ["$XDG_DATA_HOME/pyshell_venv/default/bin/python", "-m", "pip", "install", "numpy"]
            ["~/.local/share/pyshell_venv/default/bin/python", "-m", "pip", "install", "numpy aiohttp"]
            ["project_dir/.venv/bin/python", "-m", "pip", "install", "numpy"]
        """
        requirements_path = Path(self.__work_directory_path / "requirements.txt")
        logger.debug(f"requirements_path: {requirements_path}")
        command = self.get_venv_python_path(self._venv_dir)
        logger.debug(f"install dependencies command: {command}")
        pip_install_command = [command, "-m", "pip", "install", self.__install_package_text]
        logger.debug(f"pip install command: {pip_install_command}")
        return pip_install_command

    def preparing_execute(self) -> list[str]:
        """
        Preparing for execution

        Returns:
            list[str]: The command to execute the script.

        Example:
            ["$XDG_DATA_HOME/pyshell_venv/default/bin/python", "script.py", "arg1", "arg2"]
            ["~/.local/share/pyshell_venv/default/bin/python", "script.py", "arg1", "arg2"]
            ["project_dir/.venv/bin/python", "script.py", "arg1", "arg2"]
        """
        venv_python_path = self.get_venv_python_path(self._venv_dir)
        logger.debug(f"exec command: {venv_python_path.as_posix()} {self.__script_path} {self.__script_args}")

        result =[venv_python_path.as_posix(), self.__script_path, *self.__script_args]
        logger.debug(f"exec result: {result}")
        return result

    @classmethod
    def get_venv_center_dir(cls) -> Path:
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
            dir_path = Path(dir_str / cls.APP_NAME)
            if dir_path.exists():
                if cls.is_accessible_dir(dir_path):
                    logger.debug(f"XDG_DATA_HOME: {dir_path}")
                    return dir_path

        # default directory
        dir_path = Path(Path.home() / ".local/share" / cls.APP_NAME)
        if not dir_path.exists():
            dir_path.mkdir(parents=True)
            logger.debug(f"default directory: {dir_path}")
            return dir_path

        elif not dir_path.is_dir():
            raise RuntimeError("venv parent directory is not found")

        elif not cls.is_accessible_dir(dir_path):
            raise RuntimeError("venv parent directory is not accessible")

        return dir_path

    @classmethod
    def get_venv_dir(cls, env_name: str, is_local_project: bool, work_directory_path: str) -> Path:
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
            return Path(cls.get_venv_center_dir() / env_dir_name)


    @classmethod
    def get_host_python_command(cls) -> str:
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


    @classmethod
    def get_venv_activate_command_path(cls, venv_dir: Path) -> Path:
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

    @classmethod
    def get_venv_python_path(cls, venv_dir: Path) -> Path:
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



    @classmethod
    def is_accessible_dir(cls, p: Path) -> bool:
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

    @classmethod
    def is_accessible_file(cls, p: Path) -> bool:
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

    @classmethod
    def is_executable_command(cls, p: Path) -> bool:
        """
        Check if the command is executable.

        Args:
            p (Path): The path to the command.

        Returns:
            bool: True if the command is executable, False otherwise.
        """
        result = cls.is_accessible_file(p) and os.access(p, os.X_OK)
        logger.debug(f"is_executable_command: {p} result: {result}")
        return result
