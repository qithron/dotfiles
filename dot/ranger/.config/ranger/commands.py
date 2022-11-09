# -*- coding: utf-8 -*-
# This file is part of ranger, the console file manager.
# This configuration file is licensed under the same terms as ranger.
# ===================================================================
#
# NOTE: If you copied this file to /etc/ranger/commands_full.py or
# ~/.config/ranger/commands_full.py, then it will NOT be loaded by ranger,
# and only serve as a reference.
#
# ===================================================================
#
# self.fm
# pydoc ranger.core.fm

import os
import time
import subprocess
from functools import partial
from ranger.api.commands import Command

class quit_write_last_dir(Command):
    def execute(self):
        if len(self.fm.tabs) >= 2:
            self.fm.tab_close()
        elif self.fm.loader.has_work():
            self.fm.notify('Not quitting: Tasks in progress: '
                           'Use `quit!` to force quit')
        else:
            d = os.getenv('RANGER_TMP')
            if d is not None:
                d += '/ranger-last-dir-ranger'
                with open(d, 'w', encoding='utf8') as f:
                    f.write(str(self.fm.thisdir))
                os.chmod(d, 0o777)
            self.fm.exit()

class rename_edit(Command):
    def execute(self):
        file = os.getenv('RANGER_TMP')
        if file is None:
            return
        file += f'/{time.time()}.txt'
        with open(file, 'w', encoding='utf8') as f:
            ls = self.fm.thistab.get_selection()
            if len(ls) == 1:
                ls = self.fm.thisdir.files
            for v in ls:
                f.write(v.basename)
                f.write('\n')
        # self.fm.thistab.path
        self.fm.edit_file(file)
        self.fm.ui.console.ask('Rename?: (y/N)',
            partial(self._question_callback, file, self.fm.thistab.path, ls),
            ('n', 'N', 'y', 'Y'))
        #os.system('vim')
        #self.fm.redraw_window()

    def _question_callback(self, file, dn, ls, answer):
        if answer in ('y', 'Y'):
            with open(file, encoding='utf8') as f:
                l2 = tuple((s.strip() for s in f))
            if len(ls) == len(l2):
                for (i, j) in zip(ls, l2):
                    subprocess.run(['mv', i.path, f'{dn}/{j}'], check=1)
        if os.path.exists(file):
            os.remove(file)
