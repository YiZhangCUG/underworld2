__version__ = "0.1"

import warnings

warnings.warn(
"""\n
The scaling module is not supported.\n
It requires 'pint' as a dependency.\n
You can install pint by running:\n
'pip install pint' in a terminal\n
Questions should be addressed to romain.beucher@unimelb.edu.au \n """
)

from scaling import *
