"Add stuff to Plex."

from pathlib import Path
import re
from tkinter import messagebox, filedialog, simpledialog, Tk


# https://runestone.academy/runestone/books/published/thinkcspy/GUIandEventDrivenProgramming/02_standard_dialog_boxes.html
def add_tv():
    tkr = Tk()
    tkr.withdraw()
    ok = False
    while not ok:
        src_raw = filedialog.askdirectory(initialdir=".", parent=tkr)
        if src_raw == '':
            return
        src = Path(src_raw)
        ok = messagebox.askyesnocancel("Contents okay?", (
            "Contents of "+str(src)+":\n\n"+"\n".join(p.name for p in src.iterdir())+
            "\n\nAccept?"))
        if ok is None:
            return
    root = Path(src.anchor)
    success = False
    filt_raw = r"lambda m: True"
    in_pat = r".* - 0*(\d+).*\.([^.]*)"
    out_func = None
    name = ''
    while not success:
        name = simpledialog.askstring("Show Name", "Name of show (for plex)?", parent=tkr,
                                      initialvalue=name)
        dst = root/'media-library'/'tv'/name
        out_func = out_func or r'lambda m: f"'+dst.name+' S01E{int(m[1]):02d}.{m[2]}"'
        ok = False
        while not ok:
            in_pat = simpledialog.askstring("Input file regex", "Regular expression for inputs?", parent=tkr,
                                            initialvalue=in_pat)
            reg = re.compile(in_pat)
            ok = messagebox.askyesnocancel("Accept Input Matches?", "\n".join(str(reg.match(s.name)) for s in src.iterdir()))
            if ok is None:
                return
            if not ok:
                messagebox.showinfo("Contents",
                    "Contents of "+str(src)+":\n\n"+"\n".join(p.name for p in src.iterdir()))
        ok = False
        while not ok:
            filt_raw = simpledialog.askstring("Filter", "Filter function for files?", parent=tkr,
                                          initialvalue=filt_raw)
            try:
                filt = eval(filt_raw)
            except SyntaxError:
                if messagebox.askretrycancel("Syntax Error", "Syntax Error. Retry?"):
                    continue
                else:
                    return
            ok = messagebox.askyesnocancel("Filtered files", "Filtered files:\n\n" +
                                           "\n".join(s.name for s in src.iterdir()
                                                     if (lambda m: m and filt(m))(reg.match(s.name))) +
                                           "\n\nContinue?")
            if ok is None:
                return
        ok = False
        while not ok:
            out_func = simpledialog.askstring("Output name lambda", "Function literal for output filename?",
                                              parent=tkr, initialvalue=out_func)
            try:
                func = eval(out_func)
            except SyntaxError:
                if messagebox.askretrycancel("Syntax Error", "Syntax Error. Retry?"):
                    continue
                else:
                    return
            links = [(s, dst/reg.sub(func, s.name)) for s in src.iterdir() if (lambda m: m and filt(m))(reg.match(s.name))]
            ok = messagebox.askyesnocancel("Accept Links?", "\n".join(f"{s.name} -> {d}" for s, d in links) +
                                           "\n\nACCEPT AND PROCEED?")
            if ok is None:
                return
        try:
            dst.mkdir(exist_ok=True)
        except OSError as e:
            if messagebox.askretrycancel("Could not make destination directory",
                                         "Directory creation failed, probably because you "
                                         f"used an illegal character:\n\n{e}"):
                continue
            return
        existing = [d for d in [*zip(*links)][1] if d.exists()]
        if existing:
            clbr = messagebox.askyesnocancel("Destination files exist",
                                             "Some of the destination files already exist:\n\n" +
                                             "\n".join(d.name for d in existing) +
                                             "\n\nProceed with overwrite? " +
                                             "(Click 'No' to go back and change output settings)")
            if clbr is None:
                return
            if not clbr:
                continue
        for i, (s, d) in enumerate(links):
            try:
                d.unlink(missing_ok=True)
                s.link_to(d)
            except OSError as e:
                if messagebox.askretrycancel("Unexpected linking error",
                                             f"Unexpected error while linking file {i}/{len(links)} "
                                             f"({s.name} -> {d}):\n\n{e}\n\nGo back and change settings?"):
                    continue
                return
        success = True
    messagebox.showinfo("Success", "Success.")
    #messagebox.showwarning("NOOP", "Still testing, no action taken.")


if __name__ == "__main__":
    add_tv()