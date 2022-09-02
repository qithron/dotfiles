INSTALL_DIR = '~'

# absolute git paths
EXCLUDED_DIRS = ()
# absolute git paths
EXCLUDED_FILES = ()
# basenames
EXCLUDED_BASENAMES = 'README.md', '.gitignore'


def iter_git_ls_files():
    print('>>> selecting "git ls-files"')
    lsf = os.popen('git ls-files').read().strip()
    for f in lsf.split('\n'):
        skip = False
        if f in EXCLUDED_FILES or os.path.basename(f) in EXCLUDED_BASENAMES:
            skip = True
        else:
            for v in EXCLUDED_DIRS:
                if f.startswith(v):
                    skip = True
                    break
        if skip:
            print('skipping:', f)
            continue
        yield f

def sort_tree(arr):
    arr.sort(key=lambda x: x[1].lower())
    arr.sort(key=lambda x: x[1].count('/'), reverse=True)

def slash_index(string, count):
    i = 0
    for _ in range(count):
        i = string.find('/', i) + 1
    return i

def tree_symlink():
    arr = set()
    for src in iter_git_ls_files():
        if src.startswith('asd/.local/bin/'):
            src = 'asd/.local/bin'
            dst = '.local/bin'
        elif src.startswith('asd/'):
            dst = src.removeprefix('asd/')
        elif src.startswith('dot/'):
            dst = src[slash_index(src, 2):]
            if dst.startswith('.config/fish'):
                pass
            else:
                src = src[:slash_index(src, 4)-1]
                dst = dst[:slash_index(dst, 2)-1]
        else:
            continue
        arr.add((src, dst))
    arr = list(arr)
    sort_tree(arr)
    return arr

def tree_single_file():
    arr = set()
    for src in iter_git_ls_files():
        if src.startswith('asd/'):
            dst = src.removeprefix('asd/')
        elif src.startswith('dot/'):
            dst = src[slash_index(src, 2):]
        else:
            continue
        arr.add((src, dst))
    arr = list(arr)
    sort_tree(arr)
    return arr
