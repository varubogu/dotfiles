from enum import Enum

class TestTarget(Enum):
    """Test target enum

    Attributes:
        CONFIG: Config target -> ~/.config/dotfiles
        LOCAL_BIN: Local bin target -> ~/.local/bin
        HOME: Home target -> ~
    """
    CONFIG = 0
    LOCAL_BIN = 1
    HOME = 2

class TestStatus:
    """Test status class

    Attributes:
        test_number: Test number
        test_config_number: Test config number
        test_local_bin_number: Test local bin number
        test_home_number: Test home number
    """

    def __init__(self):
        self.test_number = 0
        self.test_config_number = 0
        self.test_local_bin_number = 0
        self.test_home_number = 0

    def increment_no(self, target):
        self.test_number += 1
        if target == TestTarget.CONFIG:
            self.test_config_number += 1
        elif target == TestTarget.LOCAL_BIN:
            self.test_local_bin_number += 1
        elif target == TestTarget.HOME:
            self.test_home_number += 1

