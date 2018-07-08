#!/usr/bin/env python

import sys
import codecs
import json

sys.stdout = codecs.getwriter('utf-8')(sys.stdout)

if __name__ == '__main__':
    # if (sys.stdout.encoding is None):
    #     print >> sys.stderr, "please set python env PYTHONIOENCODING=UTF-8, example: export PYTHONIOENCODING=UTF-8, when write to stdout."
    #     exit(1)

    obj = json.loads(sys.stdin.read())
    sys.stdout.write(json.dumps(obj, ensure_ascii=False, sort_keys=True))
