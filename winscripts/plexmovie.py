"Add a movie to Plex."

import sys
import re
from pathlib import Path
from argparse import ArgumentParser
from tkinter import messagebox, filedialog, simpledialog, Tk


def get_parser():
    parser = ArgumentParser()
    parser.add_argument('infile')
    return parser


def main(infile):
    try:
        tkr = Tk()
        tkr.withdraw()
        src = Path(infile)
        root = Path(src.anchor)
        dst = root/'media-library'/'movies'/simpledialog\
            .askstring("Movie Name", f"Selected: {src}.\n\nName of movie (and year in parens):",
                       initialvalue=src.name, parent=tkr) or sys.exit()
        ext = simpledialog\
            .askstring("Extension",
                       "File extension (If you want to specify a variant, do so here by prepending "
                       "it to the extension, e.g. ` - [OldVersion].mp4`):",
                       initialvalue=src.suffix, parent=tkr)
        out = dst/(dst.name+ext)
        if not messagebox.askokcancel("Proceed?", f"Ready to link {src.name} -> {out}. Proceed?", parent=tkr):
            return
        dst.mkdir(exist_ok=True)
        src.link_to(out)
        messagebox.showinfo("Success", "Success.")
    except Exception as e:
        messagebox.showerror("Fatal Error", f"Fatal error: {e}")
        raise


if __name__ == "__main__":
    main(get_parser().parse_args().infile)