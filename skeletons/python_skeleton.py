
import argparse
import logging
import os
from pathlib import Path
import sys
import shutil
from datetime import datetime



def get_curr_path() -> str:
    parent = os.path.join(__file__, os.pardir)
    return os.path.abspath(parent)


##DATE_TIME = pd.Timestamp.now().strftime("%Y%m%d_%H%M%S")
HERE = get_curr_path()

logging.basicConfig(
    level=logging.INFO,
    format="%(message)s",
    handlers=[logging.StreamHandler(), logging.FileHandler("log")],
)

logger = logging.getLogger()



def parse_args(logger):
    """
    Parse command-line arguments
    """
    parser = argparse.ArgumentParser(description="Put description here")
    parser.add_argument("--debug", action=argparse.BooleanOptionalAction)  # type: ignore[attr-defined]
    parser.add_argument("-i","--input",
            help="example optional input")

    logger.info("Parsing arguments")
    args = parser.parse_args()
    return args

def do_something(some_input, debug=False):
    pass
    return 


def main():
    args = parse_args(logger)
    if args.debug is None:
        debug = False
    else:
        debug = True

    if args.input is None:
        print("No input provided")

    do_something(args.input, debug=debug)


if __name__ == "__main__":
    main()
