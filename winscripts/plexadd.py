"Add stuff to Plex."

from pathlib import Path
import re
from tkinter import messagebox, filedialog, simpledialog, Tk


# https://runestone.academy/runestone/books/published/thinkcspy/GUIandEventDrivenProgramming/02_standard_dialog_boxes.html
def add_tv():
    tkr = Tk()
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
    dst = root/'media-library'/'tv'/simpledialog.askstring("Show Name", "Name of show (for plex)?", parent=tkr)
    in_pat = r".* - 0*(\d+).*\.([^.]*)"
    out_func = r'lambda m: f"'+dst.name+' S01E{int(m[1]):02d}.{m[2]}"'
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
        out_func = simpledialog.askstring("Output name lambda", "Function literal for output filename?",
                                          parent=tkr, initialvalue=out_func)
        try:
            func = eval(out_func)
        except SyntaxError:
            if messagebox.askretrycancel("Syntax Error", "Syntax Error. Retry?"):
                continue
            else:
                return
        links = [(s, dst/reg.sub(func, s.name)) for s in src.iterdir() if reg.match(s.name)]
        ok = messagebox.askyesnocancel("Accept Links?", "\n".join(f"{s.name} -> {d}" for s, d in links) +
                                       "\n\nACCEPT AND PROCEED?")
        if ok is None:
            return
    dst.mkdir(exist_ok=True)
    for s, d in links:
        s.link_to(d)
    messagebox.showinfo("Success", "Success.")
    #messagebox.showwarning("NOOP", "Still testing, no action taken.")


if __name__ == "__main__":
    add_tv()