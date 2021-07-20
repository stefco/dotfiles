"Add a movie to Plex."

import sys
from pathlib import Path
from argparse import ArgumentParser
from tkinter import filedialog, messagebox, simpledialog, Tk, Frame, Label
from tkinter.ttk import Combobox, Button


class FeaturettePicker:
    FEATURETTES = {
        "Behind the Scenes": "behindthescenes",
        "Deleted Scenes": "deleted",
        "Featurette": "featurette",
        "Interview": "interview",
        "Scene": "scene",
        "Short": "short",
        "Trailer": "trailer",
        "Other": "other",
    }

    def __init__(self, parent, file):
        self.file = Path(file)
        self.label = Label(parent, text=self.file.name, justify='left')
        # can also position using "grid" instead of "pack", but no both
        self.label.pack(fill="x", padx=5, pady=5)
        self.parent = parent
        self.parent.bind("<Return>", self.ok)
        self.parent.bind("<Escape>", self.cancel)
        self.box = Frame(parent)
        self.ok_button = Button(self.box, text="Add", command=self.ok, default='active')
        self.ok_button.pack(padx=5, pady=5, side='right')
        self.cancel_button = Button(self.box, text="Cancel", command=self.cancel)
        self.cancel_button.pack(padx=5, pady=5, side='right')
        self.combo = Combobox(parent, values=[*self.FEATURETTES])
        self.combo.pack(fill="x", padx=5, pady=5)
        self.box.pack()
        self.result = None

    def run(self):
        self.parent.mainloop()
        return self.result

    def cancel(self):
        try:
            self.parent.withdraw()
        finally:
            self.parent.quit()

    def ok(self):
        self.result = self.combo.get()
        self.cancel()


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
        outname = simpledialog\
            .askstring("Movie Name", f"Selected: {src}.\n\nName of movie (and year in parens):",
                       initialvalue=src.name, parent=tkr) or sys.exit()
        dst = root/'media-library'/'movies'/outname
        ext = simpledialog\
            .askstring("Extension",
                       "File extension (If you want to specify a variant, do so here by prepending "
                       "it to the extension, e.g. ` - [OldVersion].mp4`):",
                       initialvalue=src.suffix, parent=tkr)
        out = dst/(outname+ext)
        files = []
        while messagebox.askyesno("Special Features", "Add more files as special features?"):
            for f in filedialog.askopenfilenames(parent=tkr, initialdir="."):
                fsrc = Path(f)
                ftype = FeaturettePicker(Tk(), fsrc).run()
                if ftype is None:
                    return
                name = simpledialog.askstring("Featurette Name", "Featurette Name:",
                                              initialvalue=fsrc.name[:-len(fsrc.suffix)], parent=tkr)
                if name is None:
                    return
                fext = simpledialog.askstring("Extension",
                                             f"File extension for {fsrc.name}:",
                                             initialvalue=fsrc.suffix, parent=tkr)
                fdst = dst/f"{name}-{FeaturettePicker.FEATURETTES[ftype]}{fext}"
                files.append((fsrc, fdst))
        msg = ("\n\nFeatures:\n\n"+"\n".join(f"{s} -> {d.name}" for (s, d) in files)+"\n\n") if files else ""
        if not messagebox.askokcancel("Proceed?",
                                      f"Ready to link {src.name} -> {out}. {msg}Proceed?",
                                      parent=tkr):
            return
        dst.mkdir(exist_ok=True)
        for s, d in [(src, out)] + files:
            if d.exists():
                overwrite = messagebox.askyesnocancel("Overwrite?", f"{d} exists. Overwrite?")
                if overwrite is None:
                    return
                if overwrite:
                    d.unlink()
                else:
                    continue
            s.link_to(d)
        messagebox.showinfo("Success", "Success.")
    except Exception as e:
        messagebox.showerror("Fatal Error", f"Fatal error: {e}")
        raise


if __name__ == "__main__":
    main(get_parser().parse_args().infile)