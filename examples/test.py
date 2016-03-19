import logging
import leapcy

logging.getLogger('leapcy').setLevel(logging.DEBUG)
logging.basicConfig()

ei = leapcy.EventIterator()
ei.monitor_background_frames = True

import time
time.sleep(2)

ei.stop()
