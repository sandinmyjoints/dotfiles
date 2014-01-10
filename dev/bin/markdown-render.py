#!/usr/bin/env python

import sys
import markdown

USAGE = "%s <file.md> <css dir>" % __file__

TAIL = """
</body>
</html>
"""

def main(args):
    if len(args) < 3:
        print USAGE
        sys.exit(1)

    css_dir = args[2].strip()
    if css_dir.endswith("/"):
        css_dir = css_dir[:-1]
    head = """
    <html>
    <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link href="%s/markdown-print.css" rel="stylesheet"></link>
    </head>
    <body>
    """ % args[2]

    md_file = args[1].strip()
    md = open(md_file).read()
    marked = markdown.markdown(unicode(md, "utf8"))
    marked = unicode(head) + marked + unicode(TAIL)

    html_file = md_file.replace(".md", ".html")
    with open(html_file, "w") as output:
        output.write(marked.encode("utf8"))

    print "Wrote to %s." % html_file

if __name__ == "__main__":
    main(sys.argv)
