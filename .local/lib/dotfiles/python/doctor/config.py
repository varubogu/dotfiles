import configparser
import os
from pathlib import Path

class Config:
    """Configuration

    """
    def __init__(self):
        self.__config = configparser.ConfigParser()
        self.__config_path = Path.home() / ".config/dotfiles/doctor/config.ini"

    def load(self):
        try:
            self.__config.read(self.__config_path)
        except FileNotFoundError:
            raise FileNotFoundError("config.ini is missing")

    def valid(self):
        """Check config.ini format

        Raises:
            ValueError: config.ini is missing values
        """
        # check config.ini format
        error_msg = ""
        if not self.__config.has_section("output"):
            error_msg += " [output] section\n"
        if not self.__config.has_option("output", "dir"):
            error_msg += " [output] dir option\n"
        if not self.__config.has_option("output", "result_csv"):
            error_msg += " [output] result_csv option\n"
        if not self.__config.has_option("output", "current_env"):
            error_msg += " [output] current_env option\n"
        if not self.__config.has_option("output", "bash_env"):
            error_msg += " [output] bash_env option\n"
        if not self.__config.has_option("output", "zsh_env"):
            error_msg += " [output] zsh_env option\n"

        if error_msg:
            raise ValueError(f"Error: config.ini is missing values\n{error_msg}")


    def get_result_dir(self):
        return os.path.expanduser(self.__config["output"]["dir"])

    def get_result_csv(self):
        return os.path.join(self.get_result_dir(), self.__config["output"]["result_csv"])

    def get_result_env_file_current_shell(self):
        return os.path.join(self.get_result_dir(), self.__config["output"]["current_env"])

    def get_result_env_file_bash(self):
        return os.path.join(self.get_result_dir(), self.__config["output"]["bash_env"])

    def get_result_env_file_zsh(self):
        return os.path.join(self.get_result_dir(), self.__config["output"]["zsh_env"])
