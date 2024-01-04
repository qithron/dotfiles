import os
import sys
import time
import subprocess
from functools import partial
from ranger.api.commands import Command


class quit_f(Command):
    def execute(self):
        sys.exit(1)


class rename_edit(Command):
    def execute(self):
        path = os.getenv('RANGER_TMP')
        if path is None:
            return

        path += f'/{time.time()}.txt'
        with open(path, 'w', encoding='utf8') as f:
            ls = self.fm.thistab.get_selection()
            if not ls:
                ls = self.fm.thisdir.files

            for v in ls:
                f.write(v.basename)
                f.write('\n')

        self.fm.edit_file(path)
        self.fm.ui.console.ask('Rename?: (y/N)',
            partial(self._question_callback, path, self.fm.thistab.path, ls),
            ('n', 'N', 'y', 'Y'))

    def _question_callback(self, path, dn, ls, answer):
        if answer in ('y', 'Y'):
            with open(path, encoding='utf8') as f:
                l2 = tuple((s.strip() for s in f))

            if len(ls) == len(l2):
                for (i, j) in zip(ls, l2):
                    src = i.path
                    dst = f'{dn}/{j}'
                    os.rename(src, dst)

        if os.path.exists(path):
            os.remove(path)


class edit_link(Command):
    def execute(self):
        path = os.getenv('RANGER_TMP')
        if path is None:
            return

        path += f'/{time.time()}.txt'
        with open(path, 'w', encoding='utf8') as f:
            ls = self.fm.thistab.get_selection()
            if not ls:
                ls = self.fm.thisdir.files

            for v in ls:
                f.write(os.readlink(v.path))
                f.write('\n')

        self.fm.edit_file(path)
        self.fm.ui.console.ask('Rename?: (y/N)',
            partial(self._question_callback, path, ls),
            ('n', 'N', 'y', 'Y'))

    def _question_callback(self, path, ls, answer):
        if answer in ('y', 'Y'):
            with open(path, encoding='utf8') as f:
                l2 = tuple((s.strip() for s in f))

            if len(ls) == len(l2):
                for (i, j) in zip(ls, l2):
                    subprocess.run(['ln', '-sfn', j, i.path], check=1)

        if os.path.exists(path):
            os.remove(path)
