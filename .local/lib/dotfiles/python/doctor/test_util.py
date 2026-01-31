
import os
import logging
from .test_status import TestTarget, TestStatus

logger = logging.getLogger(__name__)

class TestUtil:
    def __init__(self):
        self.test_status = TestStatus()

    def test_directory_exists(self, directory, test_target: TestTarget):
        self.test_status.increment_test_number(test_target)
        if os.path.isdir(directory):
            logger.info(self.test_status.test_number, "ディレクトリが存在します。{}".format(directory))
        else:
            logger.error(self.test_status.test_number, "ディレクトリが存在しません。期待値: {} ディレクトリが存在する".format(directory))

    def test_file_exists(self, file_path, test_target: TestTarget):
        self.test_status.increment_test_number(test_target)
        if os.path.isfile(file_path):
            logger.info(self.test_status.test_number, "{}ファイルが存在します。{}".format(file_path, file_path))
        else:
            logger.error(self.test_status.test_number, "{}ファイルが存在しません。期待値: ファイルが存在する".format(file_path))

    def test_symlink_exists(self, symlink, link_source_path, test_target: TestTarget):
        self.test_status.increment_test_number(test_target)
        if os.path.islink(symlink):
            if os.readlink(symlink) == link_source_path:
                logger.info(self.test_status.test_number, "正しいシンボリックリンクになっています。{} -> {}".format(symlink, link_source_path))
            else:
                logger.error(self.test_status.test_number, "シンボリックリンク先が正しくありません。期待値: シンボリックリンク {} -> {}".format(symlink, link_source_path))
        else:
            logger.error(self.test_status.test_number, "シンボリックリンクとして見つかりません。期待値: シンボリックリンク {} -> {}".format(symlink, link_source_path))

    def test_not_exists(self, path, test_target: TestTarget):
        self.test_status.increment_test_number(test_target)
        if not os.path.exists(path):
            logger.info(self.test_status.test_number, "{}が存在しません。".format(path))
        else:
            logger.error(self.test_status.test_number, "{}が存在します。期待値: 存在しない".format(path))

    def test_file_content_equals(self, file_path, expected_content, test_target: TestTarget):
        self.test_status.increment_test_number(test_target)
        with open(file_path, "r") as file:
            content = file.read()
        if content == expected_content:
            logger.info(self.test_status.test_number, "内容が期待値と一致します。{} -> {}".format(file_path, expected_content))
        else:
            logger.error(self.test_status.test_number, "内容が期待値と一致しません。期待値: {} -> {}".format(file_path, expected_content))

    def test_file_content_contains(self, file_path, expected_content, test_target: TestTarget):
        self.test_status.increment_test_number(test_target)
        with open(file_path, "r") as file:
            content = file.read()
        if expected_content in content:
            logger.info(self.test_status.test_number, "内容が期待値を含みます。{} -> {}".format(file_path, expected_content))
        else:
            logger.error(self.test_status.test_number, "内容が期待値を含みません。期待値: {} -> {}".format(file_path, expected_content))


