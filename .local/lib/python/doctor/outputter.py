import logging
import os
from pathlib import Path
import csv
from config import Config

logger = logging.getLogger(__name__)

class Output:
    """Result outputter

    Attributes:
        config: Config instance
        result_dir: result directory path
        log_file: log file path
        result_csv: result csv file path
        current_env: current environment file path
        bash_env: bash environment file path
        zsh_env: zsh environment file path
    """
    def __init__(self, config: Config):
        self.__config = config

        # result files
        self.__result_dir = self.__config.get_result_dir()
        self.__result_csv = self.__config.get_result_csv()
        self.__current_env = self.__config.get_result_env_file_current_shell()
        self.__bash_env = self.__config.get_result_env_file_bash()
        self.__zsh_env = self.__config.get_result_env_file_zsh()

        # result texts
        self.__log_text = ""
        self.__result_csv_obj = []
        self.__current_env_text = ""
        self.__bash_env_text = ""
        self.__zsh_env_text = ""

    def check_write(self):
        if not os.path.exists(self.__result_dir):
            os.makedirs(self.__result_dir)

        if not os.access(self.__result_dir, os.W_OK | os.X_OK):
            raise PermissionError(f"Error: {self.__result_dir} is not writable")
        if not os.access(self.__log_file, os.W_OK):
            raise PermissionError(f"Error: {self.__log_file} is not writable")
        if not os.access(self.__result_csv, os.W_OK):
            raise PermissionError(f"Error: {self.__result_csv} is not writable")
        if not os.access(self.__current_env, os.W_OK):
            raise PermissionError(f"Error: {self.__current_env} is not writable")
        if not os.access(self.__bash_env, os.W_OK):
            raise PermissionError(f"Error: {self.__bash_env} is not writable")
        if not os.access(self.__zsh_env, os.W_OK):
            raise PermissionError(f"Error: {self.__zsh_env} is not writable")

    def write(self):
        with open(self.__log_file, "w") as log_file:
            log_file.write(self.__log_text)
        with open(self.__result_csv, "w") as result_csv:
            writer = csv.writer(result_csv)
            writer.writerows(self.__result_csv_obj)
        with open(self.__current_env, "w") as current_env:
            current_env.write(self.__current_env_text)
        with open(self.__bash_env, "w") as bash_env:
            bash_env.write(self.__bash_env_text)
        with open(self.__zsh_env, "w") as zsh_env:
            zsh_env.write(self.__zsh_env_text)




    # print format
    #   - test_number
    #   - parameter value
    #   - example
    #     - print_format(1, "hello world")
    #     - result: 0001,0001,hello world
    def print_format(var, msg):
        echo_wrapper("{:04d},{:04d},{}".format(test_number, var, msg))

    def echo_env_file(var, msg, file_path):
        echo_wrapper("環境変数をファイルに保存: {}".format(file_path))
        print_format(var, msg)
        with open(file_path, "w") as env_file:
            env_file.write(msg + "\n")

    def echo_info(var, msg):
        print_format(var, msg)

    def echo_error(var, msg):
        print_format(var, msg)
        print(msg, file=sys.stderr)

    def echo_ok(var, msg):
        echo_info(var, "✓, {}".format(msg))

    def echo_ng(var, msg):
        echo_error(var, "✗, {}".format(msg))
